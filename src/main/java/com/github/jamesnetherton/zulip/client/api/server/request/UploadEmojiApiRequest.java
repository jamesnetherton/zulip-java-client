package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_EMOJI_WITH_NAME;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.io.File;

/**
 * Zulip API request builder for uploading custom emoji images.
 *
 * @see <a href="https://zulip.com/help/add-custom-emoji">https://zulip.com/help/add-custom-emoji</a>
 */
public class UploadEmojiApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final String name;
    private final File emojiFile;

    /**
     * Constructs a {@link UploadEmojiApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param name      The name of the emoji
     * @param emojiFile The file containing the emoji image to be uploaded
     */
    public UploadEmojiApiRequest(ZulipHttpClient client, String name, File emojiFile) {
        super(client);
        this.name = name;
        this.emojiFile = emojiFile;
    }

    /**
     * Executes the Zulip API request for uploading custom emoji images.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(REALM_EMOJI_WITH_NAME, name);
        client().upload(path, emojiFile, ZulipApiResponse.class);
    }
}
