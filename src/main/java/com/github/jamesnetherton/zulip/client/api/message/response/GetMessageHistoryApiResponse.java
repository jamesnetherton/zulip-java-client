package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.MessageHistory;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for retrieving the history of a message.
 *
 * @see <a href="https://zulip.com/api/upload-file#response">https://zulip.com/api/upload-file#response</a>
 */
public class GetMessageHistoryApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<MessageHistory> messageHistory = new ArrayList<>();

    public List<MessageHistory> getMessageHistory() {
        return messageHistory;
    }
}
