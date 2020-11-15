package com.github.jamesnetherton.zulip.client.api.event.request;

import static com.github.jamesnetherton.zulip.client.api.event.request.EventRequestConstants.EVENTS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a event queue.
 *
 * @see <a href="https://zulip.com/api/delete-queue">https://zulip.com/api/delete-queue</a>
 */
public class DeleteEventQueueApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String QUEUE_ID = "queue_id";

    /**
     * Constructs a {@link ZulipApiRequest}.
     *
     * @param queueId the queue id to delete
     * @param client  The Zulip HTTP client
     */
    public DeleteEventQueueApiRequest(ZulipHttpClient client, String queueId) {
        super(client);
        putParam(QUEUE_ID, queueId);
    }

    /**
     * Executes the Zulip API request for deleting a event queue.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(EVENTS, getParams(), ZulipApiResponse.class);
    }
}
