package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.TopicPolicy;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip stream subscription.
 */
public class StreamSubscription {

    @JsonProperty
    private boolean audibleNotifications;

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
    private UserGroupSetting canRemoveSubscribersGroupId;

    @JsonProperty
    private UserGroupSetting canResolveTopicsGroup;

    @JsonProperty
    private UserGroupSetting canSendMessageGroup;

    @JsonProperty
    private UserGroupSetting canSubscribeGroup;

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
    private int folderId;

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
    private List<String> partialSubscribers = new ArrayList<>();

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
    List<String> subscribers = new ArrayList<>();

    @JsonProperty
    private int subscriberCount;

    @JsonProperty("topics_policy")
    TopicPolicy topicPolicy;

    @JsonProperty
    private boolean isWebPublic;

    @JsonProperty
    private boolean wildcardMentionsNotify;

    public boolean isAudibleNotifications() {
        return audibleNotifications;
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

    public UserGroupSetting getCanRemoveSubscribersGroupId() {
        return canRemoveSubscribersGroupId;
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

    public int getFolderId() {
        return folderId;
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

    public List<String> getPartialSubscribers() {
        return partialSubscribers;
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

    public int getSubscriberCount() {
        return subscriberCount;
    }

    public TopicPolicy getTopicPolicy() {
        return topicPolicy;
    }

    public boolean isWebPublic() {
        return isWebPublic;
    }

    public boolean isWildcardMentionsNotify() {
        return wildcardMentionsNotify;
    }
}
