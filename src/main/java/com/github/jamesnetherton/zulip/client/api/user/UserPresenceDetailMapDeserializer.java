package com.github.jamesnetherton.zulip.client.api.user;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import tools.jackson.core.JsonParser;
import tools.jackson.databind.DeserializationContext;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.deser.std.StdDeserializer;

/**
 * Custom Jackson deserializer for presence maps that filters out non-object entries.
 *
 * <p>
 * In Zulip 12.0 (feature level 487/497), the presence object contains top-level numeric fields
 * ({@code active_timestamp}, {@code idle_timestamp}) alongside the per-client object dictionaries.
 * This deserializer skips those numeric entries and only includes entries whose values are JSON
 * objects (i.e., actual {@link UserPresenceDetail} records).
 */
public class UserPresenceDetailMapDeserializer extends StdDeserializer<Map<String, UserPresenceDetail>> {

    public UserPresenceDetailMapDeserializer() {
        super(Map.class);
    }

    @Override
    public Map<String, UserPresenceDetail> deserialize(JsonParser p, DeserializationContext ctxt) {
        JsonNode node = ctxt.readTree(p);
        Map<String, UserPresenceDetail> result = new LinkedHashMap<>();
        Iterator<Map.Entry<String, JsonNode>> fields = node.properties().iterator();
        while (fields.hasNext()) {
            Map.Entry<String, JsonNode> entry = fields.next();
            if (entry.getValue().isObject()) {
                result.put(entry.getKey(), ctxt.readTreeAsValue(entry.getValue(), UserPresenceDetail.class));
            }
        }
        return result;
    }
}
