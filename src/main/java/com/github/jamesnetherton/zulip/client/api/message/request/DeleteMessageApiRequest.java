package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGES_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a message.
 *
 * @see <a href="https://zulip.com/api/delete-message">https://zulip.com/api/delete-message</a>
 */
public class DeleteMessageApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long messageId;

    /**
     * Constructs a {@link DeleteMessageApiRequest}.
     * 
     * @param client    The Zulip HTTP client
     * @param messageId The id of the message to delete
     */
    public DeleteMessageApiRequest(ZulipHttpClient client, long messageId) {
        super(client);
        this.messageId = messageId;
    }

    /**
     * Executes the Zulip API request for deleting a message.
     * 
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(MESSAGES_ID_API_PATH, messageId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
