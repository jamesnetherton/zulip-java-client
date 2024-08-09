package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.ReactionType;

public class UserStatus {
    @JsonProperty
    private boolean away;

    @JsonProperty
    private String statusText;

    @JsonProperty
    private String emojiName;

    @JsonProperty
    private String emojiCode;

    @JsonProperty
    ReactionType reactionType;

    public boolean isAway() {
        return away;
    }

    public String getStatusText() {
        return statusText;
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
