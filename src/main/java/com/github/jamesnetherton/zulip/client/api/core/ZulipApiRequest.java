package com.github.jamesnetherton.zulip.client.api.core;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import java.util.HashMap;
import java.util.Map;

/**
 * The default Zulip REST API request object with common behaviour for all API request types.
 */
public class ZulipApiRequest {

    private final ZulipHttpClient client;
    private final Map<String, Object> params = new HashMap<>();

    /**
     * Constructs a {@link ZulipApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    protected ZulipApiRequest(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Gets the Zulip HTTP client.
     *
     * @return The Zulip HTTP client
     */
    protected ZulipHttpClient client() {
        return client;
    }

    /**
     * Gets the map of query parameters that should be passed to the Zulip API request.
     *
     * @return The map of query parameters
     */
    protected Map<String, Object> getParams() {
        return params;
    }

    /**
     * Adds a value to the query parameters map.
     *
     * @param key   The name of the query parameter
     * @param value The value of the query parameter
     */
    protected void putParam(String key, Object value) {
        params.put(key, value);
    }

    /**
     * Adds a value to the query parameters map serialized as a JSON string.
     *
     * @param key   The name of the query parameter
     * @param value The value of the query parameter that should be JSON string serialized
     */
    protected void putParamAsJsonString(String key, Object value) {
        try {
            params.put(key, JsonUtils.getMapper().writeValueAsString(value));
        } catch (JsonProcessingException e) {
            throw new IllegalStateException(e);
        }
    }
}
