package com.github.jamesnetherton.zulip.client.api.stream.request;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.TopicPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.RetentionPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamPostPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionResult;
import com.github.jamesnetherton.zulip.client.api.stream.response.SubscribeStreamsApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for subscribing to a stream.
 *
 * @see <a href="https://zulip.com/api/subscribe">https://zulip.com/api/subscribe</a>
 */
public class SubscribeStreamsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<StreamSubscriptionResult> {

    public static final String SUBSCRIPTIONS = "subscriptions";
    public static final String PRINCIPALS = "principals";
    public static final String AUTHORIZATION_ERRORS_FATAL = "authorization_errors_fatal";
    public static final String ANNOUNCE = "announce";
    public static final String INVITE_ONLY = "invite_only";
    public static final String IS_DEFAULT_STREAM = "is_default_stream";
    public static final String IS_WEB_PUBLIC = "is_web_public";
    public static final String HISTORY_PUBLIC_TO_SUBSCRIBERS = "history_public_to_subscribers";
    public static final String STREAM_POST_POLICY = "stream_post_policy";
    public static final String MESSAGE_RETENTION_DAYS = "message_retention_days";
    public static final String CAN_ADD_SUBSCRIBERS_GROUP = "can_add_subscribers_group";
    public static final String CAN_ADMINISTER_CHANNEL_GROUP = "can_administer_channel_group";
    public static final String CAN_DELETE_ANY_MESSAGE_GROUP = "can_delete_any_message_group";
    public static final String CAN_DELETE_OWN_MESSAGE_GROUP = "can_delete_own_message_group";
    public static final String CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP = "can_move_messages_out_of_channel_group";
    public static final String CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP = "can_move_messages_within_channel_group";
    public static final String CAN_SEND_MESSAGE_GROUP = "can_send_message_group";
    public static final String CAN_SUBSCRIBE_GROUP = "can_subscribe_group";
    public static final String CAN_REMOVE_SUBSCRIBERS_GROUP = "can_remove_subscribers_group";
    public static final String CAN_RESOLVE_TOPICS_GROUP = "can_resolve_topics_group";
    public static final String TOPICS_POLICY = "topics_policy";
    public static final String FOLDER_ID = "folder_id";
    public static final String SEND_NEW_SUBSCRIPTION_MESSAGES = "send_new_subscription_messages";

    /**
     * Constructs a {@link SubscribeStreamsApiRequest}.
     *
     * @param client        The Zulip HTTP client
     * @param subscriptions An array of {@link StreamSubscriptionRequest} objects detailing the stream name and description
     */
    public SubscribeStreamsApiRequest(ZulipHttpClient client, StreamSubscriptionRequest[] subscriptions) {
        super(client);
        putParam(AUTHORIZATION_ERRORS_FATAL, true);
        putParamAsJsonString(SUBSCRIPTIONS, subscriptions);
    }

    /**
     * Sets the list of users that are to be subscribed to the stream.
     *
     * @param  emailAddresses The array of user email addresses to subscribe to the stream
     * @return                This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withPrincipals(String... emailAddresses) {
        putParamAsJsonString(PRINCIPALS, emailAddresses);
        return this;
    }

    /**
     * Sets the list of users that are to be subscribed to the stream.
     *
     * @param  userIds The array of user ids to subscribe to the stream
     * @return         This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withPrincipals(long... userIds) {
        putParamAsJsonString(PRINCIPALS, userIds);
        return this;
    }

    /**
     * Sets whether authorization failures should result in a failure response. I.e if a specified user does not have access to
     * the stream.
     *
     * @param  authorizationErrorsFatal {@code true} if authorization failures should result in a failure response. {@code true}
     *                                  if authorization failures should be ignored
     * @return                          This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withAuthorizationErrorsFatal(boolean authorizationErrorsFatal) {
        putParam(AUTHORIZATION_ERRORS_FATAL, authorizationErrorsFatal);
        return this;
    }

    /**
     * Sets whether creation of the new stream should be announced.
     *
     * @param  announce {@code true} to announce the creation of the new stream. {@code false} to not make any announcement
     * @return          This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withAnnounce(boolean announce) {
        putParam(ANNOUNCE, announce);
        return this;
    }

    /**
     * Sets whether any newly created streams will be added as default streams for new users joining the organization.
     *
     * @param  defaultStream {@code true} results in any newly created streams as the default. {@code false} results in any
     *                       newly created streams being the default
     * @return               This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withDefaultStream(boolean defaultStream) {
        putParam(IS_DEFAULT_STREAM, defaultStream);
        return this;
    }

    /**
     * Sets whether a created stream will be private.
     *
     * @param  inviteOnly {@code true} results in any streams created as private. {@code false} results in created streams being
     *                    public
     * @return            This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withInviteOnly(boolean inviteOnly) {
        putParam(INVITE_ONLY, inviteOnly);
        return this;
    }

    /**
     * Sets whether any newly created streams will be web-public streams.
     *
     * @param  webPublic {@code true} results in any newly created streams created as web0public. {@code false} results in
     *                   created streams being
     *                   non web-public
     * @return           This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withWebPublic(boolean webPublic) {
        putParam(IS_WEB_PUBLIC, webPublic);
        return this;
    }

    /**
     * Sets whether the stream history is public to new subscribers.
     *
     * @param  historyPublicToSubscribers {@code true} if stream history should be public to new subscribers. {@code false} if
     *                                    stream history should not be public to new subscribers
     * @return                            This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withHistoryPublicToSubscribers(boolean historyPublicToSubscribers) {
        putParam(HISTORY_PUBLIC_TO_SUBSCRIBERS, historyPublicToSubscribers);
        return this;
    }

    /**
     * Sets the policy for which users can post messages to the stream.
     *
     * @param  policy The {@link StreamPostPolicy} that should apply to the stream
     * @return        This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withStreamPostPolicy(StreamPostPolicy policy) {
        putParam(STREAM_POST_POLICY, policy.getId());
        return this;
    }

    /**
     * Sets the number of days that message history should be retained.
     *
     * @param  messageRetentionDays The number of days for which message history should be retained
     * @return                      This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withMessageRetention(int messageRetentionDays) {
        putParam(MESSAGE_RETENTION_DAYS, messageRetentionDays);
        return this;
    }

    /**
     * Sets the message retention policy of a stream.
     *
     * @param  messageRetentionPolicy The {@link RetentionPolicy} that should apply to the stream
     * @return                        This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withMessageRetention(RetentionPolicy messageRetentionPolicy) {
        putParamAsJsonString(MESSAGE_RETENTION_DAYS, messageRetentionPolicy.toString());
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to add subscribers to this channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to add subscribers to this channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanAddSubscribersGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_ADD_SUBSCRIBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to administer this channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to administer this channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanAdministerChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_ADMINISTER_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to delete any message in the channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to delete any message in the channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanDeleteAnyMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_DELETE_ANY_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to delete the messages that they have sent in the channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to delete the messages that they have
     *                          sent in the channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanDeleteOwnMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_DELETE_OWN_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to move messages out of this channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to move messages out of this channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanMoveMessagesOutOfChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to move messages within this channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to move messages within this channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanMoveMessagesWithinChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to post in this channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to post in this channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanSendMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_SEND_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to subscribe themselves to this channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to subscribe themselves to this
     *                          channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanSubscribeGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_SUBSCRIBE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group id whose members are allowed to unsubscribe others from the stream.
     *
     * @param      userGroupID The user group id whose members are allowed to unsubscribe others from the stream
     * @return                 This {@link SubscribeStreamsApiRequest} instance
     * @deprecated             Use {@link SubscribeStreamsApiRequest#withCanRemoveSubscribersGroup(UserGroupSetting)}
     */
    public SubscribeStreamsApiRequest withCanRemoveSubscribersGroup(long userGroupID) {
        return withCanRemoveSubscribersGroup(UserGroupSetting.of(userGroupID));
    }

    /**
     * Sets the user group id whose members are allowed to unsubscribe others from the stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} whose members are allowed to unsubscribe others from the stream
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanRemoveSubscribersGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_REMOVE_SUBSCRIBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the user group settings for users who have permission to resolve topics in the channel.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to resolve topics in the channel
     * @return                  This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withCanResolveTopicsGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_RESOLVE_TOPICS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets whether named topics and the empty topic are enabled in this channel.
     *
     * @param  topicPolicy The {@link TopicPolicy}
     * @return             This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withTopicPolicy(TopicPolicy topicPolicy) {
        putParamAsJsonString(TOPICS_POLICY, topicPolicy.toString());
        return this;
    }

    /**
     * Sets the id of the folder to which the newly created channel will be added.
     *
     * @param  folderId The id of the folder to which the newly created channel will be added
     * @return          This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withFolderId(int folderId) {
        putParam(FOLDER_ID, folderId);
        return this;
    }

    /**
     * Sets whether any other users newly subscribed via this request should be sent a Notification Bot DM notifying them about
     * their new subscription.
     *
     * @param  sendNewSubscriptionMessages {@code true} to send new subscription messages. {@code false} to not send a
     *                                     subscription message
     * @return                             This {@link SubscribeStreamsApiRequest} instance
     */
    public SubscribeStreamsApiRequest withSendNewSubscriptionMessages(boolean sendNewSubscriptionMessages) {
        putParam(SEND_NEW_SUBSCRIPTION_MESSAGES, sendNewSubscriptionMessages);
        return this;
    }

    /**
     * Executes the Zulip API request for subscribing to a stream.
     *
     * @return                      {@link StreamSubscriptionRequest} describing the result of the
     *                              {@link StreamSubscriptionRequest}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public StreamSubscriptionResult execute() throws ZulipClientException {
        SubscribeStreamsApiResponse response = client().post(StreamRequestConstants.SUBSCRIPTIONS, getParams(),
                SubscribeStreamsApiResponse.class);
        return new StreamSubscriptionResult(response);
    }
}
