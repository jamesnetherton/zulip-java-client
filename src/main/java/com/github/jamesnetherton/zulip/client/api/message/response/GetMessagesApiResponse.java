package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for searching and getting messages.
 *
 * @see <a href="https://zulip.com/api/get-messages#response">https://zulip.com/api/get-messages#response</a>
 */
public class GetMessagesApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Message> messages = new ArrayList<>();

    public List<Message> getMessages() {
        return messages;
    }
}
