package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Defines a Zulip custom profile field.
 */
public class ProfileField {

    @JsonProperty
    private Object fieldData;

    @JsonProperty
    private String hint;

    @JsonProperty
    private long id;

    @JsonProperty
    private String name;

    @JsonProperty
    private int order;

    @JsonProperty
    private ProfileFieldType type;

    @JsonProperty
    private boolean displayInProfileSummary;

    @JsonProperty
    private boolean required;

    @JsonCreator
    public ProfileField(JsonNode node) {
        this.hint = node.get("hint").asText();
        this.id = node.get("id").asLong();
        this.name = node.get("name").asText();
        this.order = node.get("order").asInt();
        this.type = ProfileFieldType.fromInt(node.get("type").asInt());
        if (node.has("required")) {
            this.required = node.get("required").asBoolean();
        }
        if (node.has("display_in_profile_summary")) {
            this.displayInProfileSummary = node.get("display_in_profile_summary").asBoolean();
        }

        JsonNode fieldDataNode = node.get("field_data");
        if (this.type.equals(ProfileFieldType.LIST_OF_OPTIONS)) {
            try {
                JsonNode parsedData = JsonUtils.getMapper().readTree(fieldDataNode.asText());
                Iterator<Map.Entry<String, JsonNode>> fields = parsedData.fields();

                Map<String, Map<String, String>> data = new LinkedHashMap<>();
                while (fields.hasNext()) {
                    Map<String, String> object = new LinkedHashMap<>();

                    Map.Entry<String, JsonNode> next = fields.next();
                    JsonNode parent = next.getValue();
                    Iterator<Map.Entry<String, JsonNode>> parentFields = parent.fields();
                    while (parentFields.hasNext()) {
                        Map.Entry<String, JsonNode> parentEntry = parentFields.next();
                        object.put(parentEntry.getKey(), parentEntry.getValue().asText());
                    }
                    data.put(next.getKey(), object);
                }
                this.fieldData = data;
            } catch (JsonProcessingException e) {
                this.fieldData = "";
            }
        } else if (this.type.equals(ProfileFieldType.EXTERNAL_ACCOUNT)) {
            try {
                JsonNode parsedData = JsonUtils.getMapper().readTree(fieldDataNode.asText());
                Iterator<Map.Entry<String, JsonNode>> fields = parsedData.fields();

                Map<String, String> data = new LinkedHashMap<>();
                while (fields.hasNext()) {
                    Map.Entry<String, JsonNode> next = fields.next();
                    data.put(next.getKey(), next.getValue().asText());
                }
                this.fieldData = data;
            } catch (JsonProcessingException e) {
                this.fieldData = "";
            }
        } else {
            this.fieldData = fieldDataNode.asText();
        }
    }

    public Object getFieldData() {
        return fieldData;
    }

    public String getHint() {
        return hint;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getOrder() {
        return order;
    }

    public ProfileFieldType getType() {
        return type;
    }

    public boolean isDisplayInProfileSummary() {
        return displayInProfileSummary;
    }

    public boolean isRequired() {
        return required;
    }
}
