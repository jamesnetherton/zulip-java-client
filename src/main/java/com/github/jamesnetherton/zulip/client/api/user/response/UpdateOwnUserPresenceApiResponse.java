package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetail;
import java.util.Map;

/**
 * Zulip API response class for updating own user presence.
 *
 * @see <a href="https://zulip.com/api/update-presence#response">https://zulip.com/api/update-presence#response</a>
 */
public class UpdateOwnUserPresenceApiResponse extends ZulipApiResponse {
    @JsonProperty
    private Map<Long, UserPresenceDetail> presences;

    public Map<Long, UserPresenceDetail> getPresences() {
        return presences;
    }
}
