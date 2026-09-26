package com.github.jamesnetherton.zulip.client.generator;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.github.jamesnetherton.zulip.client.api.event.Event;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.TreeSet;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.Test;

public class EventTypeEnumGenerator {
    private static final String ENUM_VALUE_INDENT = " ".repeat(4);
    private static final String EVENT_PACKAGE = Event.class.getPackageName();
    private static final String ZULIP_OPENAPI_YAML = "https://raw.githubusercontent.com/zulip/zulip/12.3/zerver/openapi/zulip.yaml";
    private static final Path ZULIP_ENUM_JAVA = Paths
            .get("src/main/java/com/github/jamesnetherton/zulip/client/api/event/EventType.java");

    @Test
    public void generateEventTypeEnum() throws IOException {
        Assumptions.assumeTrue(System.getProperty("event.type.generate") != null);

        ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
        JsonNode spec = mapper.readTree(new URL(ZULIP_OPENAPI_YAML));
        JsonNode events = spec
                .at("/paths/~1events/get/responses/200/content/application~1json/schema/allOf/1/properties/events/items/oneOf");

        Set<String> eventTypes = new TreeSet<>();
        for (JsonNode event : events) {
            List<JsonNode> schemas = new ArrayList<>();
            schemas.add(event);
            event.path("allOf").forEach(schemas::add);

            for (JsonNode schema : schemas) {
                JsonNode type = schema.path("properties").path("type");
                type.path("enum").forEach(value -> eventTypes.add(value.asText()));
                type.path("allOf").forEach(node -> node.path("enum").forEach(value -> eventTypes.add(value.asText())));
            }
        }

        if (eventTypes.isEmpty()) {
            throw new IllegalStateException("No event types found in " + ZULIP_OPENAPI_YAML);
        }

        StringBuilder builder = new StringBuilder();
        int count = 1;
        for (String eventType : eventTypes) {
            String lineEnd = count == eventTypes.size() ? ";" : ",";
            String indent = count == 1 ? "" : ENUM_VALUE_INDENT;

            builder.append(indent);
            builder.append(eventType.toUpperCase());

            String eventClass = getEventClassName(eventType);
            if (eventClass != null) {
                builder.append("(");
                builder.append(eventClass);
                builder.append(".class)");
            }

            builder.append(lineEnd);
            builder.append("\n");
            count++;
        }

        try (InputStream stream = EventTypeEnumGenerator.class.getResourceAsStream("eventType.template")) {
            byte[] bytes = Objects.requireNonNull(stream).readAllBytes();
            String template = new String(bytes, StandardCharsets.UTF_8);
            String enumContent = template.replace("{values}", builder.toString());
            Files.write(ZULIP_ENUM_JAVA, enumContent.getBytes(StandardCharsets.UTF_8));
        }
    }

    private static String getEventClassName(String eventType) {
        StringBuilder className = new StringBuilder();
        for (String part : eventType.split("_")) {
            className.append(Character.toUpperCase(part.charAt(0)));
            className.append(part.substring(1));
        }
        className.append("Event");

        try {
            Class<?> clazz = Class.forName(EVENT_PACKAGE + "." + className);
            return Event.class.isAssignableFrom(clazz) ? className.toString() : null;
        } catch (ClassNotFoundException e) {
            return null;
        }
    }
}
