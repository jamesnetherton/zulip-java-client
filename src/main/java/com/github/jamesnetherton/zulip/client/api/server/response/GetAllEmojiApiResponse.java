package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.CustomEmoji;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API response class for getting all emoji.
 *
 * @see <a href="https://zulip.com/api/get-custom-emoji#response">https://zulip.com/api/get-custom-emoji#response</a>
 */
public class GetAllEmojiApiResponse extends ZulipApiResponse {

    @JsonProperty
    private Map<String, CustomEmoji> emoji = new HashMap<>();

    public Map<String, CustomEmoji> getEmoji() {
        return emoji;
    }
}
