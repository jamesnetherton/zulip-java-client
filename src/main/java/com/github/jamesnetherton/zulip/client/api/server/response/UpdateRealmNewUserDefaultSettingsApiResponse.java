package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for updating realm level default settings for new users.
 *
 * @see <a href=
 *      "https://zulip.com/api/update-realm-user-settings-defaults#response">https://zulip.com/api/update-realm-user-settings-defaults#response</a>
 */
public class UpdateRealmNewUserDefaultSettingsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<String> ignoredParametersUnsupported = new ArrayList<>();

    public List<String> getIgnoredParametersUnsupported() {
        return ignoredParametersUnsupported;
    }
}
