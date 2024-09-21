package com.github.jamesnetherton.zulip.client.api.event.request;

import static com.github.jamesnetherton.zulip.client.api.event.request.EventRequestConstants.REGISTER_QUEUE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.EventQueue;
import com.github.jamesnetherton.zulip.client.api.event.response.RegisterEventQueueApiResponse;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for registering an event queue.
 *
 * @see <a href="https://zulip.com/api/register-queue">https://zulip.com/api/register-queue</a>
 */
public class RegisterEventQueueApiRequest extends ZulipApiRequest implements ExecutableApiRequest<EventQueue> {

    public static final String EVENT_TYPES = "event_types";
    public static final String NARROW = "narrow";
    public static final String[] MONITORED_EVENTS = new String[] { "message" };

    /**
     * Constructs a {@link ZulipApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param narrows optional {@link Narrow} expressions to filter which message events are captured. E.g messages from a
     *                specific stream
     */
    public RegisterEventQueueApiRequest(ZulipHttpClient client, Narrow... narrows) {
        super(client);
        putParamAsJsonString(EVENT_TYPES, MONITORED_EVENTS);

        if (narrows.length > 0) {
            String[][] stringNarrows = new String[narrows.length][2];
            for (int i = 0; i < narrows.length; i++) {
                stringNarrows[i] = new String[] { narrows[i].getOperator(), narrows[i].getOperand() };
            }

            putParamAsJsonString(NARROW, stringNarrows);
        }
    }

    /**
     * Executes the Zulip API request for registering an event queue.
     *
     * @return                      the created {@link EventQueue}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public EventQueue execute() throws ZulipClientException {
        RegisterEventQueueApiResponse response = client().post(REGISTER_QUEUE, getParams(),
                RegisterEventQueueApiResponse.class);
        return new EventQueue(response);
    }
}
