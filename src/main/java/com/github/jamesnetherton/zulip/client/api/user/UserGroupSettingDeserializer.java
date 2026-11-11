package com.github.jamesnetherton.zulip.client.api.user;

import java.util.ArrayList;
import java.util.List;
import tools.jackson.core.JsonParser;
import tools.jackson.databind.DeserializationContext;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ValueDeserializer;

class UserGroupSettingDeserializer extends ValueDeserializer<UserGroupSetting> {
    @Override
    public UserGroupSetting deserialize(JsonParser jsonParser, DeserializationContext deserializationContext) {
        JsonNode node = deserializationContext.readTree(jsonParser);
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
