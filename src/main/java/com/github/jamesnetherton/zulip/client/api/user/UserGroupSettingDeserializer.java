package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.core.JacksonException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

class UserGroupSettingDeserializer extends JsonDeserializer<UserGroupSetting> {
    @Override
    public UserGroupSetting deserialize(JsonParser jsonParser, DeserializationContext deserializationContext)
            throws IOException, JacksonException {
        JsonNode node = jsonParser.readValueAsTree();
        if (node.isInt()) {
            return new UserGroupSetting(node.asInt());
        }

        if (node.isObject()) {
            List<Long> directMembers = null;
            List<Long> directSubGroups = null;

            if (node.has("direct_members")) {
                JsonNode directMembersArray = node.get("direct_members");
                if (directMembersArray.isArray()) {
                    directMembers = new ArrayList<>(directMembersArray.size());
                    for (JsonNode item : directMembersArray) {
                        directMembers.add(item.asLong());
                    }
                }
            }

            if (node.has("direct_subgroups")) {
                JsonNode directMembersArray = node.get("direct_subgroups");
                if (directMembersArray.isArray()) {
                    directSubGroups = new ArrayList<>(directMembersArray.size());
                    for (JsonNode item : directMembersArray) {
                        directSubGroups.add(item.asLong());
                    }
                }
            }

            return UserGroupSetting.of(directMembers, directSubGroups);
        }

        return null;
    }
}
