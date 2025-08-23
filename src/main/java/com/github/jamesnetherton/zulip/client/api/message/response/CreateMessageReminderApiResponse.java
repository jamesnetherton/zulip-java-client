package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for creating a message reminder.
 *
 * @see <a href=
 *      "https://zulip.com/api/create-message-reminder#response">https://zulip.com/api/create-message-reminder#response</a>
 */
public class CreateMessageReminderApiResponse extends ZulipApiResponse {
    @JsonProperty
    private int reminderId;

    public int getReminderId() {
        return reminderId;
    }
}
