package com.github.jamesnetherton.zulip.client.generator;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.Objects;
import java.util.TreeMap;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.Test;

public class EmojiEnumGenerator {
    private static final String ENUM_VALUE_INDENT = " ".repeat(4);
    private static final String ZULIP_EMOJI_JSON = "https://raw.githubusercontent.com/zulip/zulip/8.0/tools/setup/emoji/emoji_map.json";
    private static final Path ZULIP_ENUM_JAVA = Paths
            .get("src/main/java/com/github/jamesnetherton/zulip/client/api/message/Emoji.java");

    @Test
    public void generateEmojiEnum() throws IOException {
        Assumptions.assumeTrue(System.getProperty("emoji.generate") != null);

        ObjectMapper mapper = JsonUtils.getMapper();
        JsonNode node = mapper.readTree(new URL(ZULIP_EMOJI_JSON));
        StringBuilder builder = new StringBuilder();

        Map<String, String> emoji = new TreeMap<>();
        node.fieldNames().forEachRemaining(fieldName -> {
            String name = fieldName.toUpperCase().replace("-", "_");
            if (name.equals("+1")) {
                name = "PLUS_ONE";
            } else if (name.equals("_1")) {
                name = "MINUS_ONE";
            } else if (name.equals("100")) {
                name = "ONE_HUNDRED";
            } else if (name.equals("1234")) {
                name = "ONE_TWO_THREE_FOUR";
            } else if (name.equals("8BALL")) {
                name = "EIGHT_BALL";
            }

            emoji.put(name, node.get(fieldName).asText());
        });

        AtomicInteger count = new AtomicInteger(1);
        emoji.forEach((key, value) -> {
            String lineEnd = count.intValue() == emoji.size() ? ";" : ",";
            String indent = count.intValue() == 1 ? "" : ENUM_VALUE_INDENT;

            builder.append(indent);
            builder.append(key);
            builder.append("(\"");
            builder.append(value);
            builder.append("\")");
            builder.append(lineEnd);
            builder.append("\n");
            count.getAndIncrement();
        });

        try (InputStream stream = EmojiEnumGenerator.class.getResourceAsStream("emoji.template")) {
            byte[] bytes = Objects.requireNonNull(stream).readAllBytes();
            String template = new String(bytes, StandardCharsets.UTF_8);
            String enumContent = template.replace("{values}", builder.toString());
            Files.write(ZULIP_ENUM_JAVA, enumContent.getBytes(StandardCharsets.UTF_8));
        }
    }
}
