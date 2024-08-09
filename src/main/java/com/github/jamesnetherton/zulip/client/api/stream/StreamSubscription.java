package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;
import java.util.List;

/**
 * Defines a Zulip stream subscription.
 */
public class StreamSubscription {

    @JsonProperty
    private boolean audibleNotifications;

    @JsonProperty
    private String color;

    @JsonProperty
    private long creatorId;

    @JsonProperty
    private Instant dateCreated;

    @JsonProperty
    private String description;

    @JsonProperty
    private boolean desktopNotifications;

    @JsonProperty
    private boolean emailNotifications;

    @JsonProperty
    private long firstMessageId;

    @JsonProperty
    private boolean historyPublicToSubscribers;

    @JsonProperty
    private boolean inviteOnly;

    @JsonProperty
    private int messageRetentionDays;

    @JsonProperty
    private boolean isMuted;

    @JsonProperty
    private String name;

    @JsonProperty
    private boolean pinToTop;

    @JsonProperty
    private boolean pushNotifications;

    @JsonProperty
    private String renderedDescription;

    @JsonProperty
    private long streamId;

    @JsonProperty
    private int streamWeeklyTraffic;

    @JsonProperty
    List<String> subscribers;

    @JsonProperty
    private boolean isWebPublic;

    @JsonProperty
    private boolean wildcardMentionsNotify;

    @JsonProperty
    private int canRemoveSubscribersGroup;

    public boolean isAudibleNotifications() {
        return audibleNotifications;
    }

    public String getColor() {
        return color;
    }

    public long getCreatorId() {
        return creatorId;
    }

    public Instant getDateCreated() {
        return dateCreated;
    }

    public String getDescription() {
        return description;
    }

    public boolean isDesktopNotifications() {
        return desktopNotifications;
    }

    public boolean isEmailNotifications() {
        return emailNotifications;
    }

    public long getFirstMessageId() {
        return firstMessageId;
    }

    public boolean isHistoryPublicToSubscribers() {
        return historyPublicToSubscribers;
    }

    public boolean isInviteOnly() {
        return inviteOnly;
    }

    public int getMessageRetentionDays() {
        return messageRetentionDays;
    }

    public boolean isMuted() {
        return isMuted;
    }

    public String getName() {
        return name;
    }

    public boolean isPinToTop() {
        return pinToTop;
    }

    public boolean isPushNotifications() {
        return pushNotifications;
    }

    public String getRenderedDescription() {
        return renderedDescription;
    }

    public long getStreamId() {
        return streamId;
    }

    public int getStreamWeeklyTraffic() {
        return streamWeeklyTraffic;
    }

    public List<String> getSubscribers() {
        return subscribers;
    }

    public boolean isWebPublic() {
        return isWebPublic;
    }

    public boolean isWildcardMentionsNotify() {
        return wildcardMentionsNotify;
    }

    public int getCanRemoveSubscribersGroup() {
        return canRemoveSubscribersGroup;
    }
}
