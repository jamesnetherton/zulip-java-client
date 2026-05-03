package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.BOT_STORAGE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * Zulip API request builder for adding or updating data stored for a bot user.
 *
 * @see <a href="https://zulip.com/api/update-bot-storage">https://zulip.com/api/update-bot-storage</a>
 */
public class UpdateBotStorageApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String STORAGE = "storage";

    /**
     * Constructs an {@link UpdateBotStorageApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param storage Map of string key-value pairs to store for the bot
     */
    public UpdateBotStorageApiRequest(ZulipHttpClient client, Map<String, String> storage) {
        super(client);
        putParamAsJsonString(STORAGE, storage);
    }

    /**
     * Executes the Zulip API request for updating bot storage data.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().put(BOT_STORAGE, getParams(), ZulipApiResponse.class);
    }
}
