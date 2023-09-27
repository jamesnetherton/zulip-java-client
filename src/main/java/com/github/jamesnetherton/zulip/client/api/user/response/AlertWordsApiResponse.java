package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for alert words.
 *
 * @see <a href="https://zulip.com/api/add-alert-words#response">https://zulip.com/api/add-alert-words#response</a>
 * @see <a href="https://zulip.com/api/get-alert-words#response">https://zulip.com/api/get-alert-words#response</a>
 * @see <a href="https://zulip.com/api/remove-alert-words#response">https://zulip.com/api/remove-alert-words#response</a>
 */
public class AlertWordsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<String> alertWords = new ArrayList<>();

    public List<String> getAlertWords() {
        return alertWords;
    }
}
