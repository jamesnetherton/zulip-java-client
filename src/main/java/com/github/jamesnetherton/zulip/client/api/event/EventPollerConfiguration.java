package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Objects;
import java.util.concurrent.ExecutorService;

/**
 * Configuration items for the {@link EventPoller}.
 */
public class EventPollerConfiguration {
    private final MessageEventListener listener;
    private final ZulipHttpClient client;
    private Narrow[] narrows;
    private ExecutorService eventListenerExecutorService;
    private boolean allPublicStreams;

    /**
     * Constructs a {@link EventPollerConfiguration}.
     */
    EventPollerConfiguration(ZulipHttpClient client, MessageEventListener listener) {
        Objects.requireNonNull(client, "ZulipHttpClient cannot be null");
        Objects.requireNonNull(listener, "MessageEventListener cannot be null");
        this.listener = listener;
        this.client = client;
    }

    public MessageEventListener getListener() {
        return listener;
    }

    public ZulipHttpClient getClient() {
        return client;
    }

    public Narrow[] getNarrows() {
        return narrows;
    }

    /**
     * Sets the {@link Narrow} expressions to filter which message events are captured.
     *
     * @param narrows The narrow expression message filter
     */
    public void setNarrows(Narrow[] narrows) {
        this.narrows = narrows;
    }

    public ExecutorService getEventListenerExecutorService() {
        return eventListenerExecutorService;
    }

    /**
     * Sets a custom executor to use for processing message events.
     *
     * @param eventListenerExecutorService Custom {@link ExecutorService} to use for message event listener execution
     */
    public void setEventListenerExecutorService(ExecutorService eventListenerExecutorService) {
        this.eventListenerExecutorService = eventListenerExecutorService;
    }

    public boolean isAllPublicStreams() {
        return allPublicStreams;
    }

    /**
     * Sets whether to request message events from all public channels.
     *
     * @param allPublicStreams {@code true} to request message events from all public channels. {@code false} to not include
     *                         message events from all public channels
     */
    public void setAllPublicStreams(boolean allPublicStreams) {
        this.allPublicStreams = allPublicStreams;
    }
}
