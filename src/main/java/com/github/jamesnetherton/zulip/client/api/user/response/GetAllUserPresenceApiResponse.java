package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetail;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API response class for getting all users.
 *
 * @see <a href="https://zulip.com/api/get-presence#response">https://zulip.com/api/get-presence#response</a>
 */
public class GetAllUserPresenceApiResponse extends ZulipApiResponse {
    @JsonProperty
    Map<String, Map<String, UserPresenceDetail>> presences = new HashMap<>();

    @JsonProperty
    private double serverTimestamp;

    public Map<String, Map<String, UserPresenceDetail>> getPresences() {
        return presences;
    }

    public double getServerTimestamp() {
        return serverTimestamp;
    }
}
