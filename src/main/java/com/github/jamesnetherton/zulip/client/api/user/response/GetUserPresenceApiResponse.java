package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetail;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetailMapDeserializer;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API response class for getting user presence.
 *
 * @see <a href="https://zulip.com/api/get-user-presence#response">https://zulip.com/api/get-user-presence#response</a>
 */
public class GetUserPresenceApiResponse extends ZulipApiResponse {

    @JsonProperty
    @JsonDeserialize(using = UserPresenceDetailMapDeserializer.class)
    private Map<String, UserPresenceDetail> presence = new HashMap<>();

    @JsonProperty
    private double serverTimestamp;

    public Map<String, UserPresenceDetail> getPresence() {
        return presence;
    }

    public double getServerTimestamp() {
        return serverTimestamp;
    }
}
