package com.github.jamesnetherton.zulip.client.api.event.request;

import static com.github.jamesnetherton.zulip.client.api.event.request.EventRequestConstants.EVENTS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.MessageEvent;
import com.github.jamesnetherton.zulip.client.api.event.response.GetMessageEventsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for receiving events from an event queue.
 *
 * @see <a href="https://zulip.com/api/get-events">https://zulip.com/api/get-events</a>
 */
public class GetMessageEventsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<MessageEvent>> {

    public static final String QUEUE_ID = "queue_id";
    public static final String LAST_EVENT_ID = "last_event_id";

    /**
     * Constructs a {@link ZulipApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetMessageEventsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the id of the queue to receieve events from.
     *
     * @param  queueId The id of the queue to receive events from
     * @return         This {@link GetMessageEventsApiRequest} instance
     */
    public GetMessageEventsApiRequest withQueueId(String queueId) {
        putParam(QUEUE_ID, queueId);
        return this;
    }

    /**
     * Sets the queue name to events from.
     *
     * @param  lastEventId The event id of the last consumed event
     * @return             This {@link GetMessageEventsApiRequest} instance
     */
    public GetMessageEventsApiRequest withLastEventId(long lastEventId) {
        putParam(LAST_EVENT_ID, lastEventId);
        return this;
    }

    /**
     * Executes the Zulip API request for receiving events from an event queue.
     *
     * @return                      {@link MessageEvent} containing new messages
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<MessageEvent> execute() throws ZulipClientException {
        GetMessageEventsApiResponse response = client().get(EVENTS, getParams(), GetMessageEventsApiResponse.class);
        return response.getMessageEvents();
    }
}
