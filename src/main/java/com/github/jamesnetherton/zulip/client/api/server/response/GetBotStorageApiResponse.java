package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API response class for getting bot storage data.
 *
 * @see <a href="https://zulip.com/api/get-bot-storage">https://zulip.com/api/get-bot-storage</a>
 */
public class GetBotStorageApiResponse extends ZulipApiResponse {

    @JsonProperty
    private Map<String, String> storage = new HashMap<>();

    public Map<String, String> getStorage() {
        return storage;
    }
}
