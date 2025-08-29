package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.TEST_WELCOME_BOT_CUSTOM_MESSAGE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.TestWelcomeBotCustomMessageApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for testing the welcome bot custom message.
 *
 * @see <a href=
 *      "https://zulip.com/api/test-welcome-bot-custom-message">https://zulip.com/api/test-welcome-bot-custom-message</a>
 *
 */
public class TestWelcomeBotCustomMessageApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Integer> {
    public static final String WELCOME_MESSAGE_CUSTOM_TEXT = "welcome_message_custom_text";

    /**
     * Constructs a {@link TestWelcomeBotCustomMessageApiRequest}.
     *
     * @param client                   The Zulip HTTP client
     * @param welcomeMessageCustomTest The custom welcome message content
     */
    public TestWelcomeBotCustomMessageApiRequest(ZulipHttpClient client, String welcomeMessageCustomTest) {
        super(client);

        if (welcomeMessageCustomTest != null && welcomeMessageCustomTest.length() > 8000) {
            throw new IllegalArgumentException("Welcome message custom text must not be longer than 8000 characters");
        }
        putParam(WELCOME_MESSAGE_CUSTOM_TEXT, welcomeMessageCustomTest);
    }

    /**
     * Executes the Zulip API request for testing the welcome bot custom message.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Integer execute() throws ZulipClientException {
        return client().post(TEST_WELCOME_BOT_CUSTOM_MESSAGE, getParams(), TestWelcomeBotCustomMessageApiResponse.class)
                .getMessageId();
    }
}
