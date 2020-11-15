package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetail;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API response class for getting user presence.
 *
 * @see <a href="https://zulip.com/api/get-user-presence#response">https://zulip.com/api/get-user-presence#response</a>
 */
public class GetUserPresenceApiResponse extends ZulipApiResponse {

    @JsonProperty
    private Map<String, UserPresenceDetail> presence = new HashMap<>();

    public Map<String, UserPresenceDetail> getPresence() {
        return presence;
    }
}
