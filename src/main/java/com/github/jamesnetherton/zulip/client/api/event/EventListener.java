package com.github.jamesnetherton.zulip.client.api.event;

/**
 * An abstraction that defines an {@link EventListener} for receiving Zulip events.
 */
public interface EventListener<T> {

    /**
     * Actions to execute whenever an event is received. It is recommended to keep the implementation
     * lightweight to avoid blocking the event loop for long periods.
     *
     * @param event The Zulip event received
     */
    void onEvent(T event);
}
