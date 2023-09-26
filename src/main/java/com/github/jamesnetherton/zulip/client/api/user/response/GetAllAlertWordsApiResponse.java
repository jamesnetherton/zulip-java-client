package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting alert words.
 *
 * @see <a href="https://zulip.com/api/v1/users/me/alert_words#response">https://zulip.com/api/v1/users/me/alert_words#response</a>
 */
public class GetAllAlertWordsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String[] alertWords;

    public String[] getAlertWords() {
        return alertWords;
    }
}
