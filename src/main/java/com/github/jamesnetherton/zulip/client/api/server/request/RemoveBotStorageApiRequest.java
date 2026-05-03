package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.BOT_STORAGE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for deleting data stored for a bot user.
 *
 * @see <a href="https://zulip.com/api/remove-bot-storage">https://zulip.com/api/remove-bot-storage</a>
 */
public class RemoveBotStorageApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String KEYS = "keys";

    /**
     * Constructs a {@link RemoveBotStorageApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public RemoveBotStorageApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets specific keys to delete from the bot's storage. If not set, all stored data is deleted.
     *
     * @param  keys The keys to delete
     * @return      This {@link RemoveBotStorageApiRequest} instance
     */
    public RemoveBotStorageApiRequest withKeys(List<String> keys) {
        putParamAsJsonString(KEYS, keys);
        return this;
    }

    /**
     * Executes the Zulip API request for removing bot storage data.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(BOT_STORAGE, getParams(), ZulipApiResponse.class);
    }
}
