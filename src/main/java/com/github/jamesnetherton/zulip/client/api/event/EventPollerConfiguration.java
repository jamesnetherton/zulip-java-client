package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ExecutorService;

/**
 * Configuration items for the {@link EventPoller}.
 */
public class EventPollerConfiguration {
    private final MessageEventListener listener;
    private final ZulipHttpClient client;
    private final Map<String, List<EventListener<Event>>> listeners = new LinkedHashMap<>();
    private Narrow[] narrows = new Narrow[0];
    private ExecutorService eventListenerExecutorService;
    private boolean allPublicStreams;
    private Integer idleQueueTimeout;

    /**
     * Constructs a {@link EventPollerConfiguration}.
     */
    EventPollerConfiguration(ZulipHttpClient client, MessageEventListener listener) {
        Objects.requireNonNull(client, "ZulipHttpClient cannot be null");
        Objects.requireNonNull(listener, "MessageEventListener cannot be null");
        this.listener = listener;
        this.client = client;
        addListener(EventType.MESSAGE.toString(), event -> {
            if (event instanceof MessageEvent) {
                Message message = ((MessageEvent) event).getMessage();
                if (message != null) {
                    listener.onEvent(message);
                }
            }
        });
    }

    /**
     * Constructs a {@link EventPollerConfiguration}.
     */
    EventPollerConfiguration(ZulipHttpClient client) {
        Objects.requireNonNull(client, "ZulipHttpClient cannot be null");
        this.listener = null;
        this.client = client;
    }

    /**
     * Gets the {@link MessageEventListener} configured via
     * {@link EventService#captureMessageEvents(MessageEventListener, Narrow...)}.
     *
     * @return The {@link MessageEventListener} or {@code null} if the {@link EventPoller} was created with
     *         {@link EventService#captureEvents()}
     */
    public MessageEventListener getListener() {
        return listener;
    }

    public ZulipHttpClient getClient() {
        return client;
    }

    /**
     * Gets the event listeners keyed by the Zulip event type name.
     *
     * @return Unmodifiable map of event type names to event listeners
     */
    public Map<String, List<EventListener<Event>>> getListeners() {
        return Collections.unmodifiableMap(listeners);
    }

    void addListener(String eventType, EventListener<Event> eventListener) {
        Objects.requireNonNull(eventType, "eventType cannot be null");
        Objects.requireNonNull(eventListener, "EventListener cannot be null");
        listeners.computeIfAbsent(eventType, key -> new ArrayList<>()).add(eventListener);
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
        this.narrows = narrows != null ? narrows : new Narrow[0];
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

    public Integer getIdleQueueTimeout() {
        return idleQueueTimeout;
    }

    /**
     * Sets the minimum number of seconds that the server should keep the event queue alive when it is not being polled.
     *
     * @param idleQueueTimeout The idle queue timeout in seconds
     */
    public void setIdleQueueTimeout(Integer idleQueueTimeout) {
        this.idleQueueTimeout = idleQueueTimeout;
    }
}
