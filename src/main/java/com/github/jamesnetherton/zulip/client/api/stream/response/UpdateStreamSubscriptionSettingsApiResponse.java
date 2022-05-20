package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for updating stream subscription settings.
 *
 * @see <a href=
 *      "https://zulip.com/api/update-subscription-settings#response">https://zulip.com/api/update-subscription-settings#response</a>
 */
public class UpdateStreamSubscriptionSettingsApiResponse extends ZulipApiResponse {

    @JsonProperty
    List<String> ignoredParametersUnsupported = new ArrayList<>();

    public List<String> getIgnoredParametersUnsupported() {
        return ignoredParametersUnsupported;
    }
}
