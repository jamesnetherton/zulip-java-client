package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_STATUS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.ReactionType;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating own user status.
 *
 * @see <a href="https://zulip.com/api/update-status">https://zulip.com/api/update-status</a>
 */
public class UpdateOwnUserStatusApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String AWAY = "away";
    public static final String EMOJI_CODE = "emoji_code";
    public static final String EMOJI_NAME = "emoji_name";
    public static final String REACTION_TYPE = "reaction_type";
    public static final String STATUS_TEXT = "status_text";

    /**
     * Constructs a {@link UpdateOwnUserStatusApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public UpdateOwnUserStatusApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets whether the user should be marked as "away".
     *
     * @param  away {@code true} to set the user status as 'away'. {@code false} to not set the user status as 'away'
     * @return      This {@link UpdateOwnUserStatusApiRequest} instance
     */
    public UpdateOwnUserStatusApiRequest withAway(boolean away) {
        putParam(AWAY, away);
        return this;
    }

    /**
     * Sets whether the user should be marked as "away".
     *
     * @param  emojiCode A unique identifier, defining the specific emoji codepoint requested, within the namespace of the
     *                   reaction_type
     * @return           This {@link UpdateOwnUserStatusApiRequest} instance
     */
    public UpdateOwnUserStatusApiRequest withEmojiCode(String emojiCode) {
        putParam(EMOJI_CODE, emojiCode);
        return this;
    }

    /**
     * Sets whether the user should be marked as "away".
     *
     * @param  emojiName The name for the emoji to associate with this status.
     * @return           This {@link UpdateOwnUserStatusApiRequest} instance
     */
    public UpdateOwnUserStatusApiRequest withEmojiName(String emojiName) {
        putParam(EMOJI_NAME, emojiName);
        return this;
    }

    /**
     * Sets reaction type for the emoji.
     *
     * @see         <a href=
     *              "https://zulip.com/api/update-status#parameter-reaction_type">https://zulip.com/api/update-status#parameter-reaction_type</a>
     *
     * @param  type The emoji reaction type
     * @return      This {@link UpdateOwnUserStatusApiRequest} instance
     */
    public UpdateOwnUserStatusApiRequest withReactionType(ReactionType type) {
        putParam(REACTION_TYPE, type.toString());
        return this;
    }

    /**
     * The text content of the status message.
     *
     * @param  statusText The text content of the status message. Sending the empty string will clear the user's status
     * @return            This {@link UpdateOwnUserStatusApiRequest} instance
     */
    public UpdateOwnUserStatusApiRequest withStatusText(String statusText) {
        putParam(STATUS_TEXT, statusText);
        return this;
    }

    /**
     * Executes the Zulip API request for updating a user status.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(USERS_STATUS, getParams(), ZulipApiResponse.class);
    }
}
