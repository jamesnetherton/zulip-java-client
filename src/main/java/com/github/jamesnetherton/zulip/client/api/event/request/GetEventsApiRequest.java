package com.github.jamesnetherton.zulip.client.api.event.request;

import static com.github.jamesnetherton.zulip.client.api.event.request.EventRequestConstants.EVENTS;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.jamesnetherton.zulip.client.api.core.TimeoutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.Event;
import com.github.jamesnetherton.zulip.client.api.event.EventType;
import com.github.jamesnetherton.zulip.client.api.event.response.GetEventsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Zulip API request builder for receiving events from an event queue.
 *
 * @see <a href="https://zulip.com/api/get-events">https://zulip.com/api/get-events</a>
 */
public class GetEventsApiRequest extends ZulipApiRequest implements TimeoutableApiRequest<List<Event>> {

    private static final Logger LOG = Logger.getLogger(GetEventsApiRequest.class.getName());

    public static final String QUEUE_ID = "queue_id";
    public static final String LAST_EVENT_ID = "last_event_id";

    /**
     * Constructs a {@link GetEventsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetEventsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the id of the queue to receive events from.
     *
     * @param  queueId The id of the queue to receive events from
     * @return         This {@link GetEventsApiRequest} instance
     */
    public GetEventsApiRequest withQueueId(String queueId) {
        putParam(QUEUE_ID, queueId);
        return this;
    }

    /**
     * Sets the id of the last consumed event.
     *
     * @param  lastEventId The event id of the last consumed event
     * @return             This {@link GetEventsApiRequest} instance
     */
    public GetEventsApiRequest withLastEventId(long lastEventId) {
        putParam(LAST_EVENT_ID, lastEventId);
        return this;
    }

    /**
     * Executes the Zulip API request for receiving events from an event queue.
     *
     * Events are mapped to the {@link Event} implementation defined by {@link EventType}. Events that have no dedicated
     * implementation, or that cannot be mapped to it, are returned as a plain {@link Event}.
     *
     * @return                      List of {@link Event} received from the event queue
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Event> execute(int responseTimeoutSeconds) throws ZulipClientException {
        GetEventsApiResponse response = client().get(EVENTS, getParams(), responseTimeoutSeconds,
                GetEventsApiResponse.class);

        ObjectMapper mapper = JsonUtils.getMapper();
        List<Event> events = new ArrayList<>();
        for (JsonNode node : response.getEvents()) {
            Class<? extends Event> eventClass = EventType.getEventClass(node.path("type").asText());
            try {
                events.add(mapper.treeToValue(node, eventClass));
            } catch (JsonProcessingException | IllegalArgumentException e) {
                LOG.warning("Unable to map event to " + eventClass.getSimpleName() + " - " + e.getMessage());
                try {
                    events.add(mapper.treeToValue(node, Event.class));
                } catch (JsonProcessingException ex) {
                    throw new ZulipClientException(ex);
                }
            }
        }
        return events;
    }
}
