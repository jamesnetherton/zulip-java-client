package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Objects;
import java.util.concurrent.ExecutorService;

/**
 * Builder for configuring an {@link EventPoller} that captures one or more Zulip event types.
 *
 * Note that {@link Narrow} expressions only filter {@code message} events. All other event types are received for every
 * message that the user has access to.
 *
 * @see <a href="https://zulip.com/api/real-time-events">https://zulip.com/api/real-time-events</a>
 */
public class EventPollerBuilder {

    private final EventPollerConfiguration configuration;

    EventPollerBuilder(ZulipHttpClient client) {
        this.configuration = new EventPollerConfiguration(client);
    }

    /**
     * Adds a listener for new message events.
     *
     * @param  listener The {@link EventListener} to be invoked on each {@link MessageEvent}
     * @return          This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder onMessage(EventListener<MessageEvent> listener) {
        return on(EventType.MESSAGE, MessageEvent.class, listener);
    }

    /**
     * Adds a listener for message edit events.
     *
     * @param  listener The {@link EventListener} to be invoked on each {@link UpdateMessageEvent}
     * @return          This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder onUpdateMessage(EventListener<UpdateMessageEvent> listener) {
        return on(EventType.UPDATE_MESSAGE, UpdateMessageEvent.class, listener);
    }

    /**
     * Adds a listener for message deletion events.
     *
     * @param  listener The {@link EventListener} to be invoked on each {@link DeleteMessageEvent}
     * @return          This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder onDeleteMessage(EventListener<DeleteMessageEvent> listener) {
        return on(EventType.DELETE_MESSAGE, DeleteMessageEvent.class, listener);
    }

    /**
     * Adds a listener for message reaction events.
     *
     * @param  listener The {@link EventListener} to be invoked on each {@link ReactionEvent}
     * @return          This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder onReaction(EventListener<ReactionEvent> listener) {
        return on(EventType.REACTION, ReactionEvent.class, listener);
    }

    /**
     * Adds a listener for message flag update events.
     *
     * @param  listener The {@link EventListener} to be invoked on each {@link UpdateMessageFlagsEvent}
     * @return          This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder onUpdateMessageFlags(EventListener<UpdateMessageFlagsEvent> listener) {
        return on(EventType.UPDATE_MESSAGE_FLAGS, UpdateMessageFlagsEvent.class, listener);
    }

    /**
     * Adds a listener for typing notification events.
     *
     * @param  listener The {@link EventListener} to be invoked on each {@link TypingEvent}
     * @return          This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder onTyping(EventListener<TypingEvent> listener) {
        return on(EventType.TYPING, TypingEvent.class, listener);
    }

    /**
     * Adds a listener for message edit typing notification events.
     *
     * @param  listener The {@link EventListener} to be invoked on each {@link TypingEditMessageEvent}
     * @return          This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder onTypingEditMessage(EventListener<TypingEditMessageEvent> listener) {
        return on(EventType.TYPING_EDIT_MESSAGE, TypingEditMessageEvent.class, listener);
    }

    /**
     * Adds a listener for submessage events.
     *
     * @param  listener The {@link EventListener} to be invoked on each {@link SubmessageEvent}
     * @return          This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder onSubmessage(EventListener<SubmessageEvent> listener) {
        return on(EventType.SUBMESSAGE, SubmessageEvent.class, listener);
    }

    /**
     * Adds a listener for a Zulip event type. Events of types that have no dedicated {@link Event} implementation expose
     * their payload via {@link Event#getProperties()}.
     *
     * @param  eventType The Zulip {@link EventType}
     * @param  listener  The {@link EventListener} to be invoked on each event of the given type
     * @return           This {@link EventPollerBuilder} instance
     * @see              <a href="https://zulip.com/api/get-events">https://zulip.com/api/get-events</a>
     */
    public EventPollerBuilder on(EventType eventType, EventListener<Event> listener) {
        Objects.requireNonNull(eventType, "eventType cannot be null");
        return on(eventType.toString(), listener);
    }

    /**
     * Adds a listener for an arbitrary Zulip event type. This is useful for event types introduced in newer Zulip versions
     * that are not yet defined by {@link EventType}. Events of types that have no dedicated {@link Event} implementation
     * expose their payload via {@link Event#getProperties()}.
     *
     * @param  eventType The Zulip event type name. E.g. {@code subscription}
     * @param  listener  The {@link EventListener} to be invoked on each event of the given type
     * @return           This {@link EventPollerBuilder} instance
     * @see              <a href="https://zulip.com/api/get-events">https://zulip.com/api/get-events</a>
     */
    public EventPollerBuilder on(String eventType, EventListener<Event> listener) {
        configuration.addListener(eventType, listener);
        return this;
    }

    /**
     * Sets the {@link Narrow} expressions to filter which message events are captured.
     *
     * @param  narrows The narrow expression message filter
     * @return         This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder withNarrows(Narrow... narrows) {
        configuration.setNarrows(narrows);
        return this;
    }

    /**
     * Sets whether to request message events from all public channels.
     *
     * @param  allPublicStreams {@code true} to request message events from all public channels
     * @return                  This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder withAllPublicStreams(boolean allPublicStreams) {
        configuration.setAllPublicStreams(allPublicStreams);
        return this;
    }

    /**
     * Sets the minimum number of seconds that the server should keep the event queue alive when it is not being polled.
     *
     * @param  idleQueueTimeoutSeconds The idle queue timeout in seconds
     * @return                         This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder withIdleQueueTimeout(int idleQueueTimeoutSeconds) {
        configuration.setIdleQueueTimeout(idleQueueTimeoutSeconds);
        return this;
    }

    /**
     * Sets a custom executor to use for invoking event listeners.
     *
     * @param  executorService Custom {@link ExecutorService} to use for event listener execution
     * @return                 This {@link EventPollerBuilder} instance
     */
    public EventPollerBuilder withExecutorService(ExecutorService executorService) {
        configuration.setEventListenerExecutorService(executorService);
        return this;
    }

    /**
     * Builds the {@link EventPoller}.
     *
     * @return {@link EventPoller} to initiate event polling
     */
    public EventPoller build() {
        if (configuration.getListeners().isEmpty()) {
            throw new IllegalStateException("At least one event listener must be configured");
        }
        return new EventPoller(configuration);
    }

    private <T extends Event> EventPollerBuilder on(EventType eventType, Class<T> eventClass, EventListener<T> listener) {
        Objects.requireNonNull(listener, "EventListener cannot be null");
        configuration.addListener(eventType.toString(), event -> {
            if (eventClass.isInstance(event)) {
                listener.onEvent(eventClass.cast(event));
            }
        });
        return this;
    }
}
