package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.REACTIONS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.ReactionType;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for emoji emoji reactions from a message.
 *
 * @see <a href="https://zulip.com/api/remove-reaction">https://zulip.com/api/remove-reaction</a>
 */
public class DeleteEmojiReactionApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String EMOJI_CODE = "emoji_code";
    public static final String EMOJI_NAME = "emoji_name";
    public static final String REACTION_TYPE = "reaction_type";

    private final long messageId;

    /**
     * Constructs a {@link DeleteEmojiReactionApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param messageId The id of the message to remove the emoji reaction from
     * @param emojiName The name of the emoji to use
     */
    public DeleteEmojiReactionApiRequest(ZulipHttpClient client, long messageId, String emojiName) {
        super(client);
        this.messageId = messageId;
        putParam(EMOJI_NAME, emojiName);
    }

    /**
     * Sets an optional unique identifier defining the specific emoji codepoint requested.
     *
     * This is usually not required to be specified.
     *
     * @see         <a href=
     *              "https://zulip.com/api/remove-reaction#parameter-emoji_code">https://zulip.com/api/remove-reaction#parameter-emoji_code</a>
     *
     * @param  code The emoji unique identifier
     * @return      This {@link DeleteEmojiReactionApiRequest} instance
     */
    public DeleteEmojiReactionApiRequest withEmojiCode(String code) {
        putParam(EMOJI_CODE, code);
        return this;
    }

    /**
     * Sets an optional reaction type.
     *
     * @see         <a href=
     *              "https://zulip.com/api/add-reaction#parameter-reaction_type">https://zulip.com/api/add-reaction#parameter-reaction_type</a>
     *
     * @param  type The emoji reaction type
     * @return      This {@link DeleteEmojiReactionApiRequest} instance
     */
    public DeleteEmojiReactionApiRequest withReactionType(ReactionType type) {
        putParam(REACTION_TYPE, type.toString());
        return this;
    }

    /**
     * Executes the Zulip API request for removing an emoji reaction from a message.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(REACTIONS_API_PATH, messageId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
