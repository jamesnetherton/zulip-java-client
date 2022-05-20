package com.github.jamesnetherton.zulip.client.api.user.response;

import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for updating own user settings.
 *
 * @see <a href="https://zulip.com/api/update-settings#response">https://zulip.com/api/update-settings#response</a>
 */
public class UpdateOwnUserSettingsApiResponse extends ZulipApiResponse {
    private List<String> ignoredParametersUnsupported = new ArrayList<>();

    public List<String> getIgnoredParametersUnsupported() {
        return ignoredParametersUnsupported;
    }
}
