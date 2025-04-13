package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import java.io.IOException;

public class UserGroupSettingSerializer extends JsonSerializer<UserGroupSetting> {
    @Override
    public void serialize(UserGroupSetting userGroupSetting, JsonGenerator jsonGenerator, SerializerProvider serializerProvider)
            throws IOException {
        if (userGroupSetting != null) {
            if (userGroupSetting.getUserGroupId() > 0) {
                jsonGenerator.writeNumber(userGroupSetting.getUserGroupId());
            } else {
                jsonGenerator.writeStartObject();
                jsonGenerator.writeObjectField("direct_members", userGroupSetting.getDirectMembers());
                jsonGenerator.writeObjectField("direct_subgroups", userGroupSetting.getDirectSubGroups());
                jsonGenerator.writeEndObject();
            }
        }
    }
}
