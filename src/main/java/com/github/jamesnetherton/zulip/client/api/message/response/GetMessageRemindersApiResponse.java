package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.MessageReminder;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all message reminders for the current user.
 *
 * @see <a href="https://zulip.com/api/get-reminders#response">https://zulip.com/api/get-reminders#response</a>
 */
public class GetMessageRemindersApiResponse extends ZulipApiResponse {
    @JsonProperty
    List<MessageReminder> reminders = new ArrayList<>();

    public List<MessageReminder> getReminders() {
        return reminders;
    }
}
