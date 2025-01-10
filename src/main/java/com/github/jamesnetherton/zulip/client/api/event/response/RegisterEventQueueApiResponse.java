package com.github.jamesnetherton.zulip.client.api.event.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for registering an event queue.
 *
 * @see <a href="https://zulip.com/api/register-queue#response">https://zulip.com/api/register-queue#response</a>
 */
public class RegisterEventQueueApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String queueId;

    @JsonProperty
    private long lastEventId;

    @JsonProperty("event_queue_longpoll_timeout_seconds")
    private int eventQueueLongPollTimeoutSeconds;

    public String getQueueId() {
        return queueId;
    }

    public long getLastEventId() {
        return lastEventId;
    }

    public int getEventQueueLongPollTimeoutSeconds() {
        return eventQueueLongPollTimeoutSeconds;
    }
}
