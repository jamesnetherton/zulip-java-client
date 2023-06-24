package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.ScheduledMessage;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting scheduled messages for the current user.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-scheduled-messages#response">https://zulip.com/api/get-scheduled-messages#response</a>
 */
public class GetScheduledMessagesApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<ScheduledMessage> scheduledMessages = new ArrayList<>();

    public List<ScheduledMessage> getScheduledMessages() {
        return scheduledMessages;
    }
}
