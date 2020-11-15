package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Defines a Zulip message reaction.
 */
public class MessageReaction {

    @JsonProperty
    private String emojiCode;

    @JsonProperty
    private String emojiName;

    private ReactionType reactionType;

    @JsonProperty
    private long userId;

    public String getEmojiCode() {
        return emojiCode;
    }

    public String getEmojiName() {
        return emojiName;
    }

    public ReactionType getReactionType() {
        return reactionType;
    }

    @JsonSetter("reaction_type")
    void reactionType(JsonNode node) {
        if (node.isTextual()) {
            String reaction = node.asText().toUpperCase().replace("_EMOJI", "");
            reactionType = ReactionType.valueOf(reaction);
        }
    }

    public long getUserId() {
        return userId;
    }
}
