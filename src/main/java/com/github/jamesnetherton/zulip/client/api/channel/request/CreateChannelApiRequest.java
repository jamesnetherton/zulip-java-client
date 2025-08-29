package com.github.jamesnetherton.zulip.client.api.channel.request;

import static com.github.jamesnetherton.zulip.client.api.channel.request.ChannelRequestConstants.CREATE_CHANNELS;

import com.github.jamesnetherton.zulip.client.api.channel.response.CreateChannelApiResponse;
import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.TopicPolicy;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating new channel.
 *
 * @see <a href="https://zulip.com/api/create-channel">https://zulip.com/api/create-channel</a>
 */
public class CreateChannelApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {
    public static final String NAME = "name";
    public static final String DESCRIPTION = "description";
    public static final String SUBSCRIBERS = "subscribers";
    public static final String ANNOUNCE = "announce";
    public static final String INVITE_ONLY = "invite_only";
    public static final String IS_WEB_PUBLIC = "is_web_public";
    public static final String IS_DEFAULT_STREAM = "is_default_stream";
    public static final String FOLDER_ID = "folder_id";
    public static final String SEND_NEW_SUBSCRIPTION_MESSAGES = "send_new_subscription_messages";
    public static final String TOPICS_POLICY = "topics_policy";
    public static final String HISTORY_PUBLIC_TO_SUBSCRIBERS = "history_public_to_subscribers";
    public static final String MESSAGE_RETENTION_DAYS = "message_retention_days";
    public static final String CAN_ADD_SUBSCRIBERS_GROUP = "can_add_subscribers_group";
    public static final String CAN_DELETE_ANY_MESSAGE_GROUP = "can_delete_any_message_group";
    public static final String CAN_DELETE_OWN_MESSAGE_GROUP = "can_delete_own_message_group";
    public static final String CAN_REMOVE_SUBSCRIBERS_GROUP = "can_remove_subscribers_group";
    public static final String CAN_ADMINISTER_CHANNEL_GROUP = "can_administer_channel_group";
    public static final String CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP = "can_move_messages_out_of_channel_group";
    public static final String CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP = "can_move_messages_within_channel_group";
    public static final String CAN_SEND_MESSAGE_GROUP = "can_send_message_group";
    public static final String CAN_SUBSCRIBE_GROUP = "can_subscribe_group";
    public static final String CAN_RESOLVE_TOPICS_GROUP = "can_resolve_topics_group";

    /**
     * Constructs a {@link ZulipApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param name        The name of the channel
     * @param subscribers The user ids that should be subscribed to the channel
     */
    public CreateChannelApiRequest(ZulipHttpClient client, String name, Long... subscribers) {
        super(client);
        putParam(NAME, name);
        putParamAsJsonString(SUBSCRIBERS, subscribers);
    }

    /**
     * Sets the description of the channel.
     *
     * @see                <a href=
     *                     "https://zulip.com/api/create-channel#parameter-description">https://zulip.com/api/create-channel#parameter-description</a>
     *
     * @param  description The channel description
     * @return             This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withDescription(String description) {
        putParam(DESCRIPTION, description);
        return this;
    }

    /**
     * Sets whether the notification bot will send an announcement about the new channel creation.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-announce">https://zulip.com/api/create-channel#parameter-announce</a>
     *
     * @param  announce {@code true} to send an announcement. {@code false} to not send an announcement.
     * @return          This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withAnnounce(boolean announce) {
        putParam(ANNOUNCE, announce);
        return this;
    }

    /**
     * Sets whether the newly created channel will be a private channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-invite_only">https://zulip.com/api/create-channel#parameter-invite_only</a>
     *
     * @param  inviteOnly {@code true} to create the channel as a private channel. {@code false} to create as a public channel
     * @return            This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withInviteOnly(boolean inviteOnly) {
        putParam(INVITE_ONLY, inviteOnly);
        return this;
    }

    /**
     * Sets whether the newly created channel will be a web public channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-is_web_public">https://zulip.com/api/create-channel#parameter-is_web_public</a>
     *
     * @param  isWebPublic {@code true} to create the channel as web public. {@code false} to not create as web public
     * @return             This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withIsWebPublic(boolean isWebPublic) {
        putParam(IS_WEB_PUBLIC, isWebPublic);
        return this;
    }

    /**
     * Sets whether the newly created channel will be added as a default channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-is_default_stream">https://zulip.com/api/create-channel#parameter-is_default_stream</a>
     *
     * @param  isDefaultStream {@code true} create the channel as a default channel. {@code false} to not create as a default
     *                         channel
     * @return                 This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withIsDefaultStream(boolean isDefaultStream) {
        putParam(IS_DEFAULT_STREAM, isDefaultStream);
        return this;
    }

    /**
     * Sets the id of the folder to which the channel belongs.
     *
     * @param  folderId The id of the folder
     * @return          This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withFolderId(int folderId) {
        putParam(FOLDER_ID, folderId);
        return this;
    }

    /**
     * Sets whether any other users newly subscribed via this request should be sent a notification bot direct message notifying
     * them about their new subscription.
     *
     * @see                                <a href=
     *                                     "https://zulip.com/api/create-channel#parameter-send_new_subscription_messages">https://zulip.com/api/create-channel#parameter-send_new_subscription_messages</a>
     *
     * @param  sendNewSubscriptionMessages {@code true} to have any other users newly subscribed via this request be sent a
     *                                     notification bot direct message. {@code false} to not have newly subscribed users
     *                                     notified
     * @return                             This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withSendNewSubscriptionMessages(boolean sendNewSubscriptionMessages) {
        putParam(SEND_NEW_SUBSCRIPTION_MESSAGES, sendNewSubscriptionMessages);
        return this;
    }

    /**
     * Sets whether named topics and the empty topic are enabled in this channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-topics_policy">https://zulip.com/api/create-channel#parameter-topics_policy</a>
     *
     * @param  topicPolicy The {@link TopicPolicy}
     * @return             This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withTopicPolicy(TopicPolicy topicPolicy) {
        putParamAsJsonString(TOPICS_POLICY, topicPolicy.toString());
        return this;
    }

    /**
     * Sets whether the channel message history should be available to newly subscribed members.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-history_public_to_subscribers">https://zulip.com/api/create-channel#parameter-history_public_to_subscribers</a>
     *
     * @param  historyPublicToSubscribers {@code true} to make channel history available to newly subscribed members.
     *                                    {@code false} to make channel history unavailable to newly subscribed members
     * @return                            This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withHistoryPublicToSubscribers(boolean historyPublicToSubscribers) {
        putParam(HISTORY_PUBLIC_TO_SUBSCRIBERS, historyPublicToSubscribers);
        return this;
    }

    /**
     * Sets the number of days that messages sent to this channel will be stored before being automatically deleted by the
     * message retention policy.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-message_retention_days">https://zulip.com/api/create-channel#parameter-message_retention_days</a>
     *
     * @param  messageRetentionDays The number of days that messages sent to this channel will be stored before being
     *                              automatically deleted by the message retention policy
     * @return                      This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withMessageRetentionDays(int messageRetentionDays) {
        putParam(MESSAGE_RETENTION_DAYS, messageRetentionDays);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to add subscribers to this channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_add_subscribers_group">https://zulip.com/api/create-channel#parameter-can_add_subscribers_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to add subscribers to this channel
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanAddSubscribersGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_ADD_SUBSCRIBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to delete any message in the channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_delete_any_message_group">https://zulip.com/api/create-channel#parameter-can_delete_any_message_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to delete any message in the channel
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanDeleteAnyMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_DELETE_ANY_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to delete the messages that they have sent in the channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_delete_own_message_group">https://zulip.com/api/create-channel#parameter-can_delete_own_message_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to delete the messages that they have
     *                          sent in the channel
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanDeleteOwnMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_DELETE_OWN_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group id whose members are allowed to unsubscribe others from the stream.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_remove_subscribers_group">https://zulip.com/api/create-channel#parameter-can_remove_subscribers_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} whose members are allowed to unsubscribe others from the stream
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanRemoveSubscribersGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_REMOVE_SUBSCRIBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to administer this stream.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_administer_channel_group">https://zulip.com/api/create-channel#parameter-can_administer_channel_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining which members are allowed to subscribe others to the
     *                          stream
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanAdministerChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_ADMINISTER_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to move messages out of this channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_move_messages_out_of_channel_group">https://zulip.com/api/create-channel#parameter-can_move_messages_out_of_channel_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to move messages out of this channel
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanMoveMessagesOutOfChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to move messages within this channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_move_messages_within_channel_group">https://zulip.com/api/create-channel#parameter-can_move_messages_within_channel_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to move messages within this channel
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanMoveMessagesWithinChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to post in this stream.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_send_message_group">https://zulip.com/api/create-channel#parameter-can_send_message_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining which members are allowed to subscribe others to the
     *                          stream
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanSendMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_SEND_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to subscribe themselves to this channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_subscribe_group">https://zulip.com/api/create-channel#parameter-can_subscribe_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to subscribe themselves to this
     *                          channel
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanSubscribeGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_SUBSCRIBE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to resolve topics in the channel.
     *
     * <a href=
     * "https://zulip.com/api/create-channel#parameter-can_resolve_topics_group">https://zulip.com/api/create-channel#parameter-can_resolve_topics_group</a>
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to resolve topics in the channel
     * @return                  This {@link CreateChannelApiRequest} instance
     */
    public CreateChannelApiRequest withCanResolveTopicsGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_RESOLVE_TOPICS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Executes the Zulip API request for creating new channel.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        return client().post(CREATE_CHANNELS, getParams(), CreateChannelApiResponse.class).getId();
    }
}
