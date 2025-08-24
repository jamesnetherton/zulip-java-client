package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.TopicPolicy;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
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
    private boolean isArchived;

    @JsonProperty
    private boolean isRecentlyActive;

    @JsonProperty
    private UserGroupSetting canAddSubscribersGroup;

    @JsonProperty
    private UserGroupSetting canAdministerChannelGroup;

    @JsonProperty
    private UserGroupSetting canDeleteAnyMessageGroup;

    @JsonProperty
    private UserGroupSetting canDeleteOwnMessageGroup;

    @JsonProperty
    private UserGroupSetting canMoveMessagesBetweenChannelsGroup;

    @JsonProperty
    private UserGroupSetting canMoveMessagesOutOfChannelGroup;

    @JsonProperty
    private UserGroupSetting canMoveMessagesWithinChannelGroup;

    @JsonProperty
    private UserGroupSetting canMoveMessagesBetweenTopicsGroup;

    @JsonProperty
    private UserGroupSetting canRemoveSubscribersGroup;

    @JsonProperty
    private UserGroupSetting canResolveTopicsGroup;

    @JsonProperty
    private UserGroupSetting canSendMessageGroup;

    @JsonProperty
    private UserGroupSetting canSubscribeGroup;

    @JsonProperty("topics_policy")
    private TopicPolicy topicPolicy;

    @JsonProperty
    private int subscriberCount;

    @JsonProperty
    private int folderId;

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

    @Deprecated
    public StreamPostPolicy getStreamPostPolicy() {
        return streamPostPolicy;
    }

    public int getStreamWeeklyTraffic() {
        return streamWeeklyTraffic;
    }

    public boolean isWebPublic() {
        return isWebPublic;
    }

    public boolean isArchived() {
        return isArchived;
    }

    public boolean isRecentlyActive() {
        return isRecentlyActive;
    }

    public TopicPolicy getTopicPolicy() {
        return topicPolicy;
    }

    public int getFolderId() {
        return folderId;
    }

    public UserGroupSetting getCanAddSubscribersGroup() {
        return canAddSubscribersGroup;
    }

    public UserGroupSetting getCanAdministerChannelGroup() {
        return canAdministerChannelGroup;
    }

    public UserGroupSetting getCanDeleteAnyMessageGroup() {
        return canDeleteAnyMessageGroup;
    }

    public UserGroupSetting getCanDeleteOwnMessageGroup() {
        return canDeleteOwnMessageGroup;
    }

    public UserGroupSetting getCanMoveMessagesBetweenChannelsGroup() {
        return canMoveMessagesBetweenChannelsGroup;
    }

    public UserGroupSetting getCanMoveMessagesOutOfChannelGroup() {
        return canMoveMessagesOutOfChannelGroup;
    }

    public UserGroupSetting getCanMoveMessagesWithinChannelGroup() {
        return canMoveMessagesWithinChannelGroup;
    }

    public UserGroupSetting getCanMoveMessagesBetweenTopicsGroup() {
        return canMoveMessagesBetweenTopicsGroup;
    }

    public UserGroupSetting getCanRemoveSubscribersGroup() {
        return canRemoveSubscribersGroup;
    }

    public UserGroupSetting getCanResolveTopicsGroup() {
        return canResolveTopicsGroup;
    }

    public UserGroupSetting getCanSendMessageGroup() {
        return canSendMessageGroup;
    }

    public UserGroupSetting getCanSubscribeGroup() {
        return canSubscribeGroup;
    }

    public int getSubscriberCount() {
        return subscriberCount;
    }
}
