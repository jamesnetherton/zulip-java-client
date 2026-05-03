package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_EMOJI_WITH_NAME;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deactivating a custom emoji.
 *
 * @see <a href="https://zulip.com/api/deactivate-custom-emoji">https://zulip.com/api/deactivate-custom-emoji</a>
 */
public class DeactivateEmojiApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final String emojiName;

    /**
     * Constructs a {@link DeactivateEmojiApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param emojiName The name of the custom emoji to deactivate
     */
    public DeactivateEmojiApiRequest(ZulipHttpClient client, String emojiName) {
        super(client);
        this.emojiName = emojiName;
    }

    /**
     * Executes the Zulip API request for deactivating a custom emoji.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(REALM_EMOJI_WITH_NAME, emojiName);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
