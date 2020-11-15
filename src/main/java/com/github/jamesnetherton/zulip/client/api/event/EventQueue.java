package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.event.response.RegisterEventQueueApiResponse;

/**
 * Defines a Zulip event queue.
 */
public class EventQueue {

    private final RegisterEventQueueApiResponse delegate;

    public EventQueue(RegisterEventQueueApiResponse delegate) {
        this.delegate = delegate;
    }

    public String getQueueId() {
        return delegate.getQueueId();
    }

    public long getLastEventId() {
        return delegate.getLastEventId();
    }
}
