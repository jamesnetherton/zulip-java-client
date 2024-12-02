package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.databind.JsonNode;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Defines a Zulip message
 */
public class Message {

    @JsonProperty
    private String avatarUrl;

    @JsonProperty
    private String client;

    @JsonProperty
    private String content;

    @JsonProperty
    private String contentType;

    @JsonProperty
    private List<MessageEdit> editHistory = new ArrayList<>();

    @JsonProperty
    private List<MessageFlag> flags;

    @JsonProperty
    private long id;

    @JsonProperty
    private boolean isMeMessage;

    @JsonProperty
    private List<MessageReaction> reactions;

    private List<MessageRecipient> recipients = new ArrayList<>();

    @JsonProperty
    private long recipientId;

    @JsonProperty
    private String senderEmail;

    @JsonProperty
    private String senderFullName;

    @JsonProperty
    private long senderId;

    @JsonProperty("sender_realm_str")
    private String senderRealm;

    private String stream;

    private Long streamId;

    @JsonProperty
    private String subject;

    @JsonProperty
    private Instant timestamp;

    @JsonProperty
    private List<String> topicLinks;

    @JsonProperty
    private MessageType type;

    @JsonSetter("display_recipient")
    void displayRecipient(JsonNode node) {
        if (node.isTextual()) {
            stream = node.asText();
        }

        if (node.isArray()) {
            Iterator<JsonNode> elements = node.elements();
            while (elements.hasNext()) {
                JsonNode next = elements.next();
                MessageRecipient recipient = new MessageRecipient(
                        next.get("email").asText(),
                        next.get("full_name").asText(),
                        next.get("id").asLong(),
                        next.get("is_mirror_dummy").asBoolean(false));
                recipients.add(recipient);
            }
        }
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public String getClient() {
        return client;
    }

    public String getContent() {
        return content;
    }

    public String getContentType() {
        return contentType;
    }

    public List<MessageEdit> getEditHistory() {
        return editHistory;
    }

    public List<MessageRecipient> getRecipients() {
        return recipients;
    }

    public String getStream() {
        return stream;
    }

    public List<MessageFlag> getFlags() {
        return flags;
    }

    public long getId() {
        return id;
    }

    public boolean isMeMessage() {
        return isMeMessage;
    }

    public List<MessageReaction> getReactions() {
        return reactions;
    }

    public long getRecipientId() {
        return recipientId;
    }

    public String getSenderEmail() {
        return senderEmail;
    }

    public String getSenderFullName() {
        return senderFullName;
    }

    public long getSenderId() {
        return senderId;
    }

    public String getSenderRealm() {
        return senderRealm;
    }

    public String getSubject() {
        return subject;
    }

    public Instant getTimestamp() {
        return timestamp;
    }

    public List<String> getTopicLinks() {
        return topicLinks;
    }

    public MessageType getType() {
        return type;
    }

    public Long getStreamId() {
        return streamId;
    }

    public void setStreamId(Long streamId) {
        this.streamId = streamId;
    }
}
