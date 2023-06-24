package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.SCHEDULED_MESSAGES_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a scheduled message.
 *
 * @see <a href="https://zulip.com/api/delete-scheduled-message">https://zulip.com/api/delete-scheduled-message</a>
 */
public class DeleteScheduledMessageApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long scheduledMessageId;

    /**
     * Constructs a {@link DeleteScheduledMessageApiRequest}.
     *
     * @param client             The Zulip HTTP client
     * @param scheduledMessageId The id of the scheduled message to delete
     */
    public DeleteScheduledMessageApiRequest(ZulipHttpClient client, long scheduledMessageId) {
        super(client);
        this.scheduledMessageId = scheduledMessageId;
    }

    /**
     * Executes the Zulip API request for deleting a scheduled message.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(SCHEDULED_MESSAGES_ID_API_PATH, scheduledMessageId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
