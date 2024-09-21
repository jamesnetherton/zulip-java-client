package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.concurrent.ExecutorService;

/**
 * Zulip event APIs.
 *
 * Note that these service methods are <b>experimental</b> and subject to change or removal in future releases.
 */
public class EventService implements ZulipService {

    private final ZulipHttpClient client;

    /**
     * Constructs a {@link EventService}.
     *
     * @param client The Zulip HTTP client
     */
    public EventService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Capture message events.
     *
     * @param  listener The {@link MessageEventListener} to be invoked on each message event
     * @param  narrows  optional {@link Narrow} expressions to filter which message events are captured. E.g messages from a
     *                  specific stream
     * @return          {@link EventPoller} to initiate event polling
     */
    public EventPoller captureMessageEvents(MessageEventListener listener, Narrow... narrows) {
        return new EventPoller(this.client, listener, narrows);
    }

    /**
     * Capture message events.
     *
     * @param  listener        The {@link MessageEventListener} to be invoked on each message event
     * @param  executorService Custom {@link ExecutorService} to use for processing message events
     * @param  narrows         optional {@link Narrow} expressions to filter which message events are captured. E.g. messages
     *                         from a
     *                         specific stream
     * @return                 {@link EventPoller} to initiate event polling
     */
    public EventPoller captureMessageEvents(MessageEventListener listener, ExecutorService executorService, Narrow... narrows) {
        return new EventPoller(this.client, listener, narrows, executorService);
    }
}
