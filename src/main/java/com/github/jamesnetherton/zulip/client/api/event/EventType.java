package com.github.jamesnetherton.zulip.client.api.event;

/**
 * Defines the Zulip event types.
 *
 * Event types that have a dedicated {@link Event} implementation are mapped to it. All other event types are mapped to
 * {@link Event}, with the event payload available from {@link Event#getProperties()}.
 *
 * @see <a href="https://zulip.com/api/get-events#events-by-type">https://zulip.com/api/get-events#events-by-type</a>
 */
public enum EventType {
    ALERT_WORDS,
    ATTACHMENT,
    CHANNEL_FOLDER,
    CUSTOM_PROFILE_FIELDS,
    DEFAULT_STREAM_GROUPS,
    DEFAULT_STREAMS,
    DELETE_MESSAGE(DeleteMessageEvent.class),
    DEVICE,
    DRAFTS,
    HAS_WEBEX_TOKEN,
    HAS_ZOOM_TOKEN,
    HEARTBEAT,
    INVITES_CHANGED,
    MESSAGE(MessageEvent.class),
    MUTED_TOPICS,
    MUTED_USERS,
    NAVIGATION_VIEW,
    ONBOARDING_STEPS,
    PRESENCE,
    REACTION(ReactionEvent.class),
    REALM,
    REALM_BOT,
    REALM_DOMAINS,
    REALM_EMOJI,
    REALM_EXPORT,
    REALM_EXPORT_CONSENT,
    REALM_FILTERS,
    REALM_LINKIFIERS,
    REALM_PLAYGROUNDS,
    REALM_USER,
    REALM_USER_SETTINGS_DEFAULTS,
    REMINDERS,
    RESTART,
    SAVED_SNIPPETS,
    SCHEDULED_MESSAGES,
    STREAM,
    SUBMESSAGE(SubmessageEvent.class),
    SUBSCRIPTION,
    TYPING(TypingEvent.class),
    TYPING_EDIT_MESSAGE(TypingEditMessageEvent.class),
    UPDATE_MESSAGE(UpdateMessageEvent.class),
    UPDATE_MESSAGE_FLAGS(UpdateMessageFlagsEvent.class),
    USER_GROUP,
    USER_SETTINGS,
    USER_STATUS,
    USER_TOPIC,
    WEB_RELOAD_CLIENT;

    private final Class<? extends Event> eventClass;

    EventType() {
        this(Event.class);
    }

    EventType(Class<? extends Event> eventClass) {
        this.eventClass = eventClass;
    }

    public Class<? extends Event> getEventClass() {
        return eventClass;
    }

    /**
     * Gets the {@link Event} class to use for the given Zulip event type name.
     *
     * @param  type The Zulip event type name. E.g. {@code update_message}
     * @return      The {@link Event} implementation for the event type or {@link Event} if the type has no dedicated
     *              implementation
     */
    public static Class<? extends Event> getEventClass(String type) {
        for (EventType eventType : values()) {
            if (eventType.toString().equals(type)) {
                return eventType.getEventClass();
            }
        }
        return Event.class;
    }

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}
