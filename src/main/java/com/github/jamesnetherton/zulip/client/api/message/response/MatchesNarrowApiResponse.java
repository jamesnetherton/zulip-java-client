package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.MessageMatch;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API response class for checking if a set of messages matches a narrow.
 *
 * @see <a href="https://zulip.com/api/check-narrow-matches#response">https://zulip.com/api/check-narrow-matches#response</a>
 */
public class MatchesNarrowApiResponse extends ZulipApiResponse {

    @JsonProperty
    private Map<Long, MessageMatch> messages = new HashMap<>();

    public Map<Long, MessageMatch> getMessages() {
        return messages;
    }
}
