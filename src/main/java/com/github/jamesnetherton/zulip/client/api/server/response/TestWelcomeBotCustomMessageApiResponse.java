package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for testing the welcome bot custom message.
 *
 * @see <a href=
 *      "https://zulip.com/api/test-welcome-bot-custom-message#response">https://zulip.com/api/test-welcome-bot-custom-message#response</a>
 */
public class TestWelcomeBotCustomMessageApiResponse extends ZulipApiResponse {
    @JsonProperty
    public int messageId;

    public int getMessageId() {
        return messageId;
    }
}
