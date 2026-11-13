import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;
import tools.jackson.dataformat.yaml.YAMLFactory;

/**
 * Compares two Zulip OpenAPI specs and checks the client against the newer one.
 *
 * Usage (see spec_report.sh): java -cp <test classpath> SpecReport.java <old-version> <new-version> [repo-dir] [cache-dir]
 */
public class SpecReport {

    static final String SPEC_URL = "https://raw.githubusercontent.com/zulip/zulip/%s/zerver/openapi/zulip.yaml";
    static final Set<String> COMMON_RESPONSE_FIELDS = Set.of("result", "msg", "code", "ignored_parameters_unsupported");
    static final Pattern IGNORED_OPS = Pattern.compile("^(dev-|zulip-outgoing-webhooks|real-time-events|rest-error-handling).*");
    static final Pattern JAVADOC_LINK = Pattern.compile("zulip\\.com/api/([a-z0-9-]+)");
    static final Pattern STRING_CONSTANT = Pattern.compile("static final String (\\w+)\\s*=\\s*\"([^\"]*)\"\\s*;");
    // putParam(NAME, value), putParamAsJsonString(NAME, value), putParamAsWrappedObject("new", NAME, value)
    static final Pattern PUT_PARAM = Pattern.compile("putParam\\w*\\(\\s*(?:\"[^\"]*\"\\s*,\\s*)?(\\w+)\\s*,");

    record Field(String type, boolean deprecated, Set<String> enumValues) {
    }

    record Op(String id, String endpoint, boolean deprecated, Map<String, Field> params, Set<String> pathParams,
            Map<String, Field> response) {
    }

    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            System.err.println("Usage: SpecReport <old-version> <new-version> [repo-dir] [cache-dir]");
            System.exit(1);
        }
        String oldVersion = args[0];
        String newVersion = args[1];
        Path repo = Path.of(args.length > 2 ? args[2] : ".");
        Path cache = Path.of(args.length > 3 ? args[3] : "target/zulip-openapi");

        Map<String, Op> oldOps = parse(load(oldVersion, cache));
        Map<String, Op> newOps = parse(load(newVersion, cache));
        Map<String, Set<String>> implementedBy = new TreeMap<>();
        Map<String, Set<String>> clientParams = new TreeMap<>();
        scanClient(repo, implementedBy, clientParams);

        StringBuilder out = new StringBuilder();
        out.append("# Zulip OpenAPI report: ").append(oldVersion).append(" -> ").append(newVersion).append("\n\n");
        out.append("Client classes are matched to operations through `https://zulip.com/api/<operationId>` javadoc links.\n");
        out.append("An operation with no linked class is reported as not implemented, so check for a missing link before adding a class.\n");

        section(out, "Operations added in " + newVersion);
        newOps.values().stream().filter(op -> !oldOps.containsKey(op.id())).forEach(op -> out.append("- ")
                .append(describe(op)).append(" — ").append(clients(implementedBy, op.id())).append("\n"));

        section(out, "Operations removed in " + newVersion);
        oldOps.values().stream().filter(op -> !newOps.containsKey(op.id())).forEach(op -> out.append("- ")
                .append(describe(op)).append(" — ").append(clients(implementedBy, op.id())).append("\n"));

        section(out, "Changes to existing operations");
        for (Op op : newOps.values()) {
            Op before = oldOps.get(op.id());
            if (before == null) {
                continue;
            }
            List<String> changes = new ArrayList<>();
            if (op.deprecated() && !before.deprecated()) {
                changes.add("operation is now **deprecated**");
            }
            diffFields("param", before.params(), op.params(), changes);
            diffFields("response", before.response(), op.response(), changes);
            if (!changes.isEmpty()) {
                out.append("\n### ").append(describe(op)).append("\n\nClient: ").append(clients(implementedBy, op.id()))
                        .append("\n\n");
                changes.forEach(change -> out.append("- ").append(change).append("\n"));
            }
        }

        section(out, "Client parameters not accepted by " + newVersion);
        out.append("Parameters a client request class sends that its operation does not define. Usually removed or renamed upstream; "
                + "occasionally a constant that isn't a parameter at all.\n\n");
        forEachImplemented(newOps, implementedBy, clientParams, (op, sent) -> sent.stream()
                .filter(param -> !op.params().containsKey(param))
                .forEach(param -> out.append("- `").append(param).append("` — ").append(describe(op)).append(" — ")
                        .append(clients(implementedBy, op.id())).append("\n")));

        section(out, "Client parameters deprecated in " + newVersion);
        forEachImplemented(newOps, implementedBy, clientParams, (op, sent) -> sent.stream()
                .filter(param -> op.params().containsKey(param) && op.params().get(param).deprecated())
                .forEach(param -> out.append("- `").append(param).append("` — ").append(describe(op)).append("\n")));

        section(out, "Client classes linked to unknown operations");
        out.append("Javadoc links that match no " + newVersion + " operationId: either a wrong link or an operation that was removed.\n\n");
        implementedBy.forEach((slug, classes) -> {
            if (!newOps.containsKey(slug) && !IGNORED_OPS.matcher(slug).matches()) {
                out.append("- `").append(slug).append("` — ").append(String.join(", ", classes)).append("\n");
            }
        });

        section(out, "Operations in " + newVersion + " the client does not implement (pre-existing)");
        newOps.values().stream()
                .filter(op -> oldOps.containsKey(op.id()) && !implementedBy.containsKey(op.id()) && !op.deprecated())
                .forEach(op -> out.append("- ").append(describe(op)).append("\n"));

        section(out, "Parameters of implemented operations the client does not send (pre-existing)");
        out.append("Only parameters that already existed in " + oldVersion + "; new ones are listed under the changes above.\n\n");
        forEachImplemented(newOps, implementedBy, clientParams, (op, sent) -> {
            Op before = oldOps.get(op.id());
            List<String> missing = op.params().entrySet().stream()
                    .filter(e -> !e.getValue().deprecated() && !sent.contains(e.getKey()))
                    .filter(e -> !op.pathParams().contains(e.getKey()))
                    .filter(e -> before != null && before.params().containsKey(e.getKey()))
                    .map(Map.Entry::getKey)
                    .toList();
            if (!missing.isEmpty()) {
                out.append("- ").append(describe(op)).append(": ").append(String.join(", ", missing)).append("\n");
            }
        });

        System.out.print(out);
    }

    interface OpConsumer {
        void accept(Op op, Set<String> sent);
    }

    static void forEachImplemented(Map<String, Op> ops, Map<String, Set<String>> implementedBy,
            Map<String, Set<String>> clientParams, OpConsumer consumer) {
        for (Op op : ops.values()) {
            Set<String> classes = implementedBy.get(op.id());
            if (classes == null) {
                continue;
            }
            Set<String> sent = new TreeSet<>();
            classes.forEach(c -> sent.addAll(clientParams.getOrDefault(c, Set.of())));
            if (!sent.isEmpty()) {
                consumer.accept(op, sent);
            }
        }
    }

    static void diffFields(String kind, Map<String, Field> before, Map<String, Field> after, List<String> changes) {
        after.forEach((name, field) -> {
            Field old = before.get(name);
            if (old == null) {
                changes.add(kind + " `" + name + "` **added** (" + field.type() + enumSuffix(field.enumValues())
                        + (field.deprecated() ? ", deprecated" : "") + ")");
                return;
            }
            if (field.deprecated() && !old.deprecated()) {
                changes.add(kind + " `" + name + "` now **deprecated**");
            }
            if (!Objects.equals(old.type(), field.type())) {
                changes.add(kind + " `" + name + "` type changed " + old.type() + " -> " + field.type());
            }
            Set<String> added = new TreeSet<>(field.enumValues());
            added.removeAll(old.enumValues());
            Set<String> removed = new TreeSet<>(old.enumValues());
            removed.removeAll(field.enumValues());
            if (!added.isEmpty()) {
                changes.add(kind + " `" + name + "` enum values added: " + added);
            }
            if (!removed.isEmpty()) {
                changes.add(kind + " `" + name + "` enum values removed: " + removed);
            }
        });
        before.keySet().stream().filter(name -> !after.containsKey(name))
                .forEach(name -> changes.add(kind + " `" + name + "` **removed**"));
    }

    static String enumSuffix(Set<String> values) {
        return values.isEmpty() ? "" : ", enum " + values;
    }

    static String describe(Op op) {
        return "`" + op.endpoint() + "` [" + op.id() + "](https://zulip.com/api/" + op.id() + ")"
                + (op.deprecated() ? " (deprecated)" : "");
    }

    static String clients(Map<String, Set<String>> implementedBy, String id) {
        Set<String> classes = implementedBy.get(id);
        if (classes == null) {
            return "NOT IMPLEMENTED";
        }
        List<String> list = new ArrayList<>(classes);
        return list.size() > 4 ? String.join(", ", list.subList(0, 4)) + " (+" + (list.size() - 4) + " more)"
                : String.join(", ", list);
    }

    static void section(StringBuilder out, String title) {
        out.append("\n## ").append(title).append("\n\n");
    }

    static JsonNode load(String version, Path cache) throws IOException {
        Files.createDirectories(cache);
        Path file = cache.resolve("zulip-" + version + ".yaml");
        if (!Files.exists(file)) {
            try (InputStream in = URI.create(String.format(SPEC_URL, version)).toURL().openStream()) {
                Files.copy(in, file);
            }
        }
        return new ObjectMapper(new YAMLFactory()).readTree(file.toFile());
    }

    static Map<String, Op> parse(JsonNode spec) {
        Map<String, Op> ops = new TreeMap<>();
        for (Map.Entry<String, JsonNode> path : spec.path("paths").properties()) {
            for (Map.Entry<String, JsonNode> method : path.getValue().properties()) {
                JsonNode op = method.getValue();
                String id = op.path("operationId").asString("");
                if (id.isEmpty() || IGNORED_OPS.matcher(id).matches()) {
                    continue;
                }
                Map<String, Field> params = new TreeMap<>();
                Set<String> pathParams = new TreeSet<>();
                List<JsonNode> paramNodes = new ArrayList<>();
                path.getValue().path("parameters").forEach(paramNodes::add);
                op.path("parameters").forEach(paramNodes::add);
                for (JsonNode p : paramNodes) {
                    JsonNode param = resolve(spec, p);
                    JsonNode schema = resolve(spec, param.path("schema"));
                    if (schema.isMissingNode()) {
                        schema = resolve(spec, param.path("content").path("application/json").path("schema"));
                    }
                    params.put(param.path("name").asString(), field(spec, schema, param.path("deprecated").asBoolean(false)));
                    if ("path".equals(param.path("in").asString())) {
                        pathParams.add(param.path("name").asString());
                    }
                }
                for (JsonNode content : resolve(spec, op.path("requestBody")).path("content")) {
                    flatten(spec, content.path("schema"), "", params, 1);
                }
                Map<String, Field> response = new TreeMap<>();
                for (JsonNode content : resolve(spec, op.path("responses").path("200")).path("content")) {
                    flatten(spec, content.path("schema"), "", response, 8);
                }
                COMMON_RESPONSE_FIELDS.forEach(response::remove);
                ops.put(id, new Op(id, method.getKey().toUpperCase() + " " + path.getKey(),
                        op.path("deprecated").asBoolean(false), params, pathParams, response));
            }
        }
        return ops;
    }

    static void flatten(JsonNode spec, JsonNode node, String prefix, Map<String, Field> out, int depth) {
        node = resolve(spec, node);
        if (depth <= 0 || node.isMissingNode()) {
            return;
        }
        for (String combiner : List.of("allOf", "oneOf", "anyOf")) {
            node.path(combiner).forEach(child -> flatten(spec, child, prefix, out, depth));
        }
        for (Map.Entry<String, JsonNode> property : node.path("properties").properties()) {
            JsonNode schema = resolve(spec, property.getValue());
            String name = prefix + property.getKey();
            Field field = field(spec, schema, schema.path("deprecated").asBoolean(false));
            out.merge(name, field, SpecReport::mergeFields);
            flatten(spec, schema, name + ".", out, depth - 1);
            flatten(spec, schema.path("items"), name + "[].", out, depth - 1);
            if (schema.path("additionalProperties").isObject()) {
                flatten(spec, schema.path("additionalProperties"), name + "{}.", out, depth - 1);
            }
        }
    }

    static Field mergeFields(Field a, Field b) {
        Set<String> values = new TreeSet<>(a.enumValues());
        values.addAll(b.enumValues());
        String type = Objects.equals(a.type(), b.type()) ? a.type() : a.type() + "|" + b.type();
        return new Field(type, a.deprecated() && b.deprecated(), values);
    }

    static Field field(JsonNode spec, JsonNode schema, boolean deprecated) {
        Set<String> values = new TreeSet<>();
        collectEnum(spec, schema, values);
        collectEnum(spec, schema.path("items"), values);
        String type = schema.path("type").asString("");
        if (type.isEmpty()) {
            type = Stream.of("oneOf", "anyOf", "allOf")
                    .flatMap(c -> schema.path(c).valueStream())
                    .map(n -> resolve(spec, n).path("type").asString(""))
                    .filter(t -> !t.isEmpty())
                    .distinct()
                    .collect(Collectors.joining("|"));
        }
        if ("array".equals(type)) {
            type = "array<" + resolve(spec, schema.path("items")).path("type").asString("?") + ">";
        }
        return new Field(type.isEmpty() ? "?" : type, deprecated || schema.path("deprecated").asBoolean(false), values);
    }

    static void collectEnum(JsonNode spec, JsonNode schema, Set<String> values) {
        schema = resolve(spec, schema);
        schema.path("enum").forEach(v -> values.add(v.asString()));
        for (String combiner : List.of("allOf", "oneOf", "anyOf")) {
            schema.path(combiner).forEach(child -> resolve(spec, child).path("enum").forEach(v -> values.add(v.asString())));
        }
    }

    static JsonNode resolve(JsonNode spec, JsonNode node) {
        for (int i = 0; i < 10 && node.has("$ref"); i++) {
            node = spec.at(node.get("$ref").asString().substring(1));
        }
        return node;
    }

    static void scanClient(Path repo, Map<String, Set<String>> implementedBy, Map<String, Set<String>> clientParams)
            throws IOException {
        Path src = repo.resolve("src/main/java");
        List<Path> files;
        try (Stream<Path> walk = Files.walk(src)) {
            files = walk.filter(p -> p.toString().endsWith(".java")).toList();
        }
        Map<Path, Map<String, String>> sharedConstants = new LinkedHashMap<>();
        for (Path file : files) {
            if (file.getFileName().toString().endsWith("RequestConstants.java")) {
                sharedConstants.put(file.getParent(), constants(Files.readString(file, StandardCharsets.UTF_8)));
            }
        }
        for (Path file : files) {
            String text = Files.readString(file, StandardCharsets.UTF_8);
            String className = file.getFileName().toString().replace(".java", "");
            Matcher link = JAVADOC_LINK.matcher(text);
            while (link.find()) {
                implementedBy.computeIfAbsent(link.group(1), k -> new TreeSet<>()).add(className);
            }
            if (!file.getParent().getFileName().toString().equals("request")) {
                continue;
            }
            Map<String, String> known = new LinkedHashMap<>(sharedConstants.getOrDefault(file.getParent(), Map.of()));
            known.putAll(constants(text));
            Matcher put = PUT_PARAM.matcher(text);
            while (put.find()) {
                String value = known.get(put.group(1));
                if (value != null && !value.contains("/")) {
                    clientParams.computeIfAbsent(className, k -> new TreeSet<>()).add(value);
                }
            }
        }
    }

    static Map<String, String> constants(String text) {
        Map<String, String> constants = new LinkedHashMap<>();
        Matcher m = STRING_CONSTANT.matcher(text);
        while (m.find()) {
            constants.put(m.group(1), m.group(2));
        }
        return constants;
    }
}
