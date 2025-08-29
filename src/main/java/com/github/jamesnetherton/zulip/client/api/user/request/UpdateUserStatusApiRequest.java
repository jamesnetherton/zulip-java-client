package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_STATUS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.ReactionType;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating user status.
 *
 * @see <a href="https://zulip.com/api/update-status-for-user">https://zulip.com/api/update-status-for-user</a>
 */
public class UpdateUserStatusApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String STATUS_TEXT = "status_text";
    public static final String EMOJI_NAME = "emoji_name";
    public static final String EMOJI_CODE = "emoji_code";
    public static final String REACTION_TYPE = "reaction_type";

    private final long userId;

    /**
     * Constructs a {@link UpdateUserStatusApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public UpdateUserStatusApiRequest(ZulipHttpClient client, long userId) {
        super(client);
        this.userId = userId;
    }

    /**
     * Sets the content of the status message.
     *
     * @see               <a href=
     *                    "https://zulip.com/api/update-status-for-user#parameter-status_text">https://zulip.com/api/update-status-for-user#parameter-status_text</a>
     *
     * @param  statusText The content of the status message
     * @return            This {@link UpdateUserStatusApiRequest} instance
     */
    public UpdateUserStatusApiRequest withStatusText(String statusText) {
        if (statusText != null && statusText.length() > 60) {
            throw new IllegalArgumentException("Status text cannot be longer than 60 characters");
        }
        putParam(STATUS_TEXT, statusText);
        return this;
    }

    /**
     * Sets the name for the emoji to associate with this status.
     *
     * @see              <a href=
     *                   "https://zulip.com/api/update-status-for-user#parameter-status_text">https://zulip.com/api/update-status-for-user#parameter-status_text</a>
     *
     * @param  emojiName The name for the emoji to associate with this status
     * @return           This {@link UpdateUserStatusApiRequest} instance
     */
    public UpdateUserStatusApiRequest withEmojiName(String emojiName) {
        putParam(EMOJI_NAME, emojiName);
        return this;
    }

    /**
     * Sets the unique identifier defining the emoji.
     *
     * @see              <a href=
     *                   "https://zulip.com/api/update-status-for-user#parameter-emoji_code">https://zulip.com/api/update-status-for-user#parameter-emoji_code</a>
     *
     * @param  emojiCode The unique identifier defining the specific emoji
     * @return           This {@link UpdateUserStatusApiRequest} instance
     */
    public UpdateUserStatusApiRequest withEmojiCode(String emojiCode) {
        putParam(EMOJI_CODE, emojiCode);
        return this;
    }

    /**
     * Sets the reaction type.
     *
     * @see                 <a href=
     *                      "https://zulip.com/api/update-status-for-user#parameter-reaction_type">https://zulip.com/api/update-status-for-user#parameter-reaction_type</a>
     *
     * @param  reactionType The reaction type
     * @return              This {@link UpdateUserStatusApiRequest} instance
     */
    public UpdateUserStatusApiRequest withReactionType(ReactionType reactionType) {
        putParam(REACTION_TYPE, reactionType.toString());
        return this;
    }

    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USERS_STATUS, userId);
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}
