package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for updating message flags.
 *
 * @see <a href="https://zulip.com/api/update-message-flags#response">https://zulip.com/api/update-message-flags#response</a>
 */
public class UpdateMessageFlagsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Long> messages = new ArrayList<>();

    public List<Long> getMessages() {
        return messages;
    }
}
