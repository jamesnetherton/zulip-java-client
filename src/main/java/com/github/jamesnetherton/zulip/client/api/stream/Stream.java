package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

/**
 * Defines a Zulip stream.
 */
public class Stream {

    @JsonProperty
    private boolean isAnnouncementOnly;

    @JsonProperty
    private Instant dateCreated;

    @JsonProperty
    private long creatorId;

    @JsonProperty
    private boolean isDefault;

    @JsonProperty
    private String description;

    @JsonProperty
    private long firstMessageId;

    @JsonProperty
    private boolean historyPublicToSubscribers;

    @JsonProperty
    private boolean inviteOnly;

    @JsonProperty
    private int messageRetentionDays;

    @JsonProperty
    private String name;

    @JsonProperty
    private String renderedDescription;

    @JsonProperty
    private long streamId;

    @JsonProperty
    private StreamPostPolicy streamPostPolicy;

    @JsonProperty
    private int streamWeeklyTraffic;

    @JsonProperty
    private boolean isWebPublic;

    @JsonProperty
    private int canRemoveSubscribersGroup;

    public boolean isAnnouncementOnly() {
        return isAnnouncementOnly;
    }

    public long getCreatorId() {
        return creatorId;
    }

    public Instant getDateCreated() {
        return dateCreated;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public String getDescription() {
        return description;
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

    public String getName() {
        return name;
    }

    public String getRenderedDescription() {
        return renderedDescription;
    }

    public long getStreamId() {
        return streamId;
    }

    public StreamPostPolicy getStreamPostPolicy() {
        return streamPostPolicy;
    }

    public int getStreamWeeklyTraffic() {
        return streamWeeklyTraffic;
    }

    public boolean isWebPublic() {
        return isWebPublic;
    }

    public int canRemoveSubscribersGroup() {
        return canRemoveSubscribersGroup;
    }
}
