package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.BOT_STORAGE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.GetBotStorageApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;
import java.util.Map;

/**
 * Zulip API request builder for retrieving data stored for a bot user.
 *
 * @see <a href="https://zulip.com/api/get-bot-storage">https://zulip.com/api/get-bot-storage</a>
 */
public class GetBotStorageApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Map<String, String>> {

    public static final String KEYS = "keys";

    /**
     * Constructs a {@link GetBotStorageApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetBotStorageApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets specific keys to retrieve from the bot's storage. If not set, all stored data is returned.
     *
     * @param  keys The keys to retrieve
     * @return      This {@link GetBotStorageApiRequest} instance
     */
    public GetBotStorageApiRequest withKeys(List<String> keys) {
        putParamAsJsonString(KEYS, keys);
        return this;
    }

    /**
     * Executes the Zulip API request for retrieving bot storage data.
     *
     * @return                      Map of string key-value pairs stored for the bot
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Map<String, String> execute() throws ZulipClientException {
        return client().get(BOT_STORAGE, getParams(), GetBotStorageApiResponse.class).getStorage();
    }
}
