package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.ReactionType;

/**
 * Defines a Zulip event for a message reaction being added or removed.
 *
 * @see <a href="https://zulip.com/api/get-events#reaction-add">https://zulip.com/api/get-events#reaction-add</a>
 */
public class ReactionEvent extends Event {

    @JsonProperty
    private EventOperation op;

    @JsonProperty
    private long messageId;

    @JsonProperty
    private long userId;

    @JsonProperty
    private String emojiName;

    @JsonProperty
    private String emojiCode;

    @JsonProperty
    private ReactionType reactionType;

    public EventOperation getOperation() {
        return op;
    }

    public long getMessageId() {
        return messageId;
    }

    public long getUserId() {
        return userId;
    }

    public String getEmojiName() {
        return emojiName;
    }

    public String getEmojiCode() {
        return emojiCode;
    }

    public ReactionType getReactionType() {
        return reactionType;
    }
}
