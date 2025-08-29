package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.STREAMS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.TopicPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.RetentionPolicy;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating a stream.
 *
 * @see <a href="https://zulip.com/api/update-stream">https://zulip.com/api/update-stream</a>
 */
public class UpdateStreamApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String DESCRIPTION = "description";
    public static final String NEW_NAME = "new_name";
    public static final String IS_PRIVATE = "is_private";
    public static final String IS_WEB_PUBLIC = "is_web_public";
    public static final String HISTORY_PUBLIC_TO_SUBSCRIBERS = "history_public_to_subscribers";
    public static final String IS_DEFAULT_STREAM = "is_default_stream";
    public static final String MESSAGE_RETENTION_DAYS = "message_retention_days";
    public static final String IS_ARCHIVED = "is_archived";
    public static final String FOLDER_ID = "folder_id";
    public static final String TOPICS_POLICY = "topics_policy";
    public static final String CAN_ADD_SUBSCRIBERS_GROUP = "can_add_subscribers_group";
    public static final String CAN_REMOVE_SUBSCRIBERS_GROUP = "can_remove_subscribers_group";
    public static final String CAN_ADMINISTER_CHANNEL_GROUP = "can_administer_channel_group";
    public static final String CAN_DELETE_ANY_MESSAGE_GROUP = "can_delete_any_message_group";
    public static final String CAN_DELETE_OWN_MESSAGE_GROUP = "can_delete_own_message_group";
    public static final String CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP = "can_move_messages_out_of_channel_group";
    public static final String CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP = "can_move_messages_within_channel_group";
    public static final String CAN_SEND_MESSAGE_GROUP = "can_send_message_group";
    public static final String CAN_SUBSCRIBE_GROUP = "can_subscribe_group";
    public static final String CAN_RESOLVE_TOPICS_GROUP = "can_resolve_topics_group";

    private final long streamId;

    /**
     * Constructs a {@link DeleteStreamApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to update
     */
    public UpdateStreamApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        this.streamId = streamId;
    }

    /**
     * Sets the updated stream description.
     *
     * @param  description The description of the stream
     * @return             This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withDescription(String description) {
        putParam(DESCRIPTION, description);
        return this;
    }

    /**
     * Sets the updated stream name.
     *
     * @param  name The name of the stream
     * @return      This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withName(String name) {
        putParam(NEW_NAME, name);
        return this;
    }

    /**
     * Sets whether the stream is private.
     *
     * @param  isPrivate {@code true} if the stream should be private. {@code false} if the stream should be public
     * @return           This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withIsPrivate(boolean isPrivate) {
        putParam(IS_PRIVATE, isPrivate);
        return this;
    }

    /**
     * Sets whether any newly created streams will be added as default streams for new users joining the organization.
     *
     * @param  defaultStream {@code true} results in any newly created streams as the default. {@code false} results in any
     *                       newly created streams being the default
     * @return               This {@link SubscribeStreamsApiRequest} instance
     */
    public UpdateStreamApiRequest withDefaultStream(boolean defaultStream) {
        putParam(IS_DEFAULT_STREAM, defaultStream);
        return this;
    }

    /**
     * Sets whether the stream is a web-public stream.
     *
     * @param  webPublic {@code true} results in any newly created streams created as web public. {@code false} results in
     *                   created streams being
     *                   non web-public
     * @return           This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withWebPublic(boolean webPublic) {
        putParam(IS_WEB_PUBLIC, webPublic);
        return this;
    }

    /**
     * Sets the updated number of days that message history should be retained.
     *
     * @param  messageRetentionDays The number of days for which message history should be retained
     * @return                      This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withMessageRetention(int messageRetentionDays) {
        putParam(MESSAGE_RETENTION_DAYS, messageRetentionDays);
        return this;
    }

    /**
     * Sets whether the stream is archived.
     *
     * @param  isArchived {@code true} to archive the stream. {@code false} to unarchive the stream
     * @return            This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withIsArchived(boolean isArchived) {
        putParam(IS_ARCHIVED, isArchived);
        return this;
    }

    /**
     * Sets the folder this stream belongs to.
     *
     * @param  folderId the id of the folder this stream belongs to
     * @return          This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withFolderId(int folderId) {
        putParam(FOLDER_ID, folderId);
        return this;
    }

    /**
     * Sets whether named topics and the empty topic are enabled in this channel.
     *
     * <a href=
     * "https://zulip.com/api/update-stream#parameter-topics_policy">https://zulip.com/api/update-stream#parameter-topics_policy</a>
     *
     * @param  topicPolicy The {@link TopicPolicy}
     * @return             This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withTopicPolicy(TopicPolicy topicPolicy) {
        putParam(TOPICS_POLICY, topicPolicy.toString());
        return this;
    }

    /**
     * Sets the updated message retention policy of a stream.
     *
     * @param  messageRetentionPolicy The {@link RetentionPolicy} that should apply to the stream
     * @return                        This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withMessageRetention(RetentionPolicy messageRetentionPolicy) {
        putParamAsJsonString(MESSAGE_RETENTION_DAYS, messageRetentionPolicy.toString());
        return this;
    }

    /**
     * Sets whether the stream history is public to new subscribers.
     *
     * @param  historyPublicToSubscribers {@code true} if stream history should be public to new subscribers. {@code false} if
     *                                    stream history should not be public to new subscribers
     * @return                            This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withHistoryPublicToSubscribers(boolean historyPublicToSubscribers) {
        putParam(HISTORY_PUBLIC_TO_SUBSCRIBERS, historyPublicToSubscribers);
        return this;
    }

    /**
     * Sets the users who have permission to unsubscribe others from this stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining which members are allowed to unsubscribe others from
     *                          the stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanRemoveSubscribersGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_REMOVE_SUBSCRIBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to add others to this stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining which members are allowed to subscribe others to the
     *                          stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanAddSubscribersGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_ADD_SUBSCRIBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to administer this stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining which members are allowed to subscribe others to the
     *                          stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanAdministerChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_ADMINISTER_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to delete any message in the stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining the users who have permission to delete any message in
     *                          the stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanDeleteAnyMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_DELETE_ANY_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to delete they have sent to the stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining the users who have permission to delete they have sent
     *                          to the stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanDeleteOwnMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_DELETE_OWN_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to move messages out of this stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining the users who have permission to move messages out of
     *                          this stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanMoveMessagesOutOfChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to move messages within this stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining the users who have permission to move messages within
     *                          this stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanMoveMessagesWithinChannelGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to post in this stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining which members are allowed to subscribe others to the
     *                          stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanSendMessageGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_SEND_MESSAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to subscribe themselves to this stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining which members are allowed to subscribe others to the
     *                          stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanSubscribeGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_SUBSCRIBE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Set the users who have permission to resolve topics in this stream.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} determining the users who have permission resolve topics in this
     *                          stream
     * @return                  This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanResolveTopicsGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_RESOLVE_TOPICS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Executes the Zulip API request for updating a stream.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(STREAMS_WITH_ID, streamId);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}
