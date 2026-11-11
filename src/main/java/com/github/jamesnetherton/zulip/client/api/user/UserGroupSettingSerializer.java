package com.github.jamesnetherton.zulip.client.api.user;

import tools.jackson.core.JsonGenerator;
import tools.jackson.databind.SerializationContext;
import tools.jackson.databind.ValueSerializer;

public class UserGroupSettingSerializer extends ValueSerializer<UserGroupSetting> {
    @Override
    public void serialize(UserGroupSetting userGroupSetting, JsonGenerator jsonGenerator,
            SerializationContext serializationContext) {
        if (userGroupSetting != null) {
            if (userGroupSetting.getUserGroupId() > 0) {
                jsonGenerator.writeNumber(userGroupSetting.getUserGroupId());
            } else {
                jsonGenerator.writeStartObject();
                jsonGenerator.writePOJOProperty("direct_members", userGroupSetting.getDirectMembers());
                jsonGenerator.writePOJOProperty("direct_subgroups", userGroupSetting.getDirectSubGroups());
                jsonGenerator.writeEndObject();
            }
        }
    }
}
