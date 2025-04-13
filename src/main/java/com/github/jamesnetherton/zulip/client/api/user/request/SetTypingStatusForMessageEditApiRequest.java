package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.TYPING_FOR_MESSAGE_EDIT;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.TypingOperation;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for notifying other users whether the current user is editing a message.
 *
 * @see <a href=
 *      "https://zulip.com/api/set-typing-status-for-message-edit">https://zulip.com/api/set-typing-status-for-message-edit</a>
 */
public class SetTypingStatusForMessageEditApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String MESSAGE_ID = "message_id";
    public static final String OPERATION = "op";

    private final long messageId;

    /**
     * Constructs a {@link SetTypingStatusForMessageEditApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param operation The typing operation to apply
     * @param messageId The id of the message being edited
     */
    public SetTypingStatusForMessageEditApiRequest(ZulipHttpClient client, long messageId, TypingOperation operation) {
        super(client);
        this.messageId = messageId;
        putParam(OPERATION, operation.toString());
    }

    /**
     * Executes the Zulip API request for notifying other users whether the current user is editing a message.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(TYPING_FOR_MESSAGE_EDIT, messageId);
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}
