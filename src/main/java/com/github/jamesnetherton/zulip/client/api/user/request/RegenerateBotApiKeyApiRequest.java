package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.BOTS_API_KEY_REGENERATE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.GetBotApiKeyApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for regenerating the API key of a bot user.
 *
 * @see <a href="https://zulip.com/api/regenerate-bot-api-key">https://zulip.com/api/regenerate-bot-api-key</a>
 */
public class RegenerateBotApiKeyApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    private final long botId;

    /**
     * Constructs a {@link RegenerateBotApiKeyApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param botId  The user ID of the target bot
     */
    public RegenerateBotApiKeyApiRequest(ZulipHttpClient client, long botId) {
        super(client);
        this.botId = botId;
    }

    /**
     * Executes the Zulip API request for regenerating a bot's API key.
     *
     * @return                      The new API key for the bot
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        String path = String.format(BOTS_API_KEY_REGENERATE, botId);
        return client().post(path, getParams(), GetBotApiKeyApiResponse.class).getApiKey();
    }
}
