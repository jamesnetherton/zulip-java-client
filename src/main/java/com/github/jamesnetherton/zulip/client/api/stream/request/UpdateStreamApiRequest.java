package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.STREAMS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.stream.RetentionPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamPostPolicy;
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
    public static final String PRIVATE = "is_private";
    public static final String IS_DEFAULT_STREAM = "is_default_stream";
    public static final String IS_WEB_PUBLIC = "is_web_public";
    public static final String STREAM_POST_POLICY = "stream_post_policy";
    public static final String MESSAGE_RETENTION_DAYS = "message_retention_days";
    public static final String HISTORY_PUBLIC_TO_SUBSCRIBERS = "history_public_to_subscribers";
    public static final String CAN_REMOVE_SUBSCRIBERS_GROUP = "can_remove_subscribers_group";

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
        // TODO: Consider adding back support for Zulip 3 requiring the description to be JSON encoded
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
        // TODO: Consider adding back support for Zulip 3 requiring the name to be JSON encoded
        putParam(NEW_NAME, name);
        return this;
    }

    /**
     * Sets the whether the stream is private.
     *
     * @param  isPrivate {@code true} if the stream should be private. {@code false} if the stream should be public
     * @return           This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withIsPrivate(boolean isPrivate) {
        putParam(PRIVATE, isPrivate);
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
     * @param  webPublic {@code true} results in any newly created streams created as web0public. {@code false} results in
     *                   created streams being
     *                   non web-public
     * @return           This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withWebPublic(boolean webPublic) {
        putParam(IS_WEB_PUBLIC, webPublic);
        return this;
    }

    /**
     * Sets the updated policy for which users can post messages to the stream.
     *
     * @param  policy The {@link StreamPostPolicy} that should apply to the stream
     * @return        This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withStreamPostPolicy(StreamPostPolicy policy) {
        putParam(STREAM_POST_POLICY, policy.getId());
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
     * Sets the updated user group id whose members are allowed to unsubscribe others from the stream.
     *
     * @param  userGroupID The user group id whose members are allowed to unsubscribe others from the stream
     * @return             This {@link UpdateStreamApiRequest} instance
     */
    public UpdateStreamApiRequest withCanRemoveSubscribersGroup(long userGroupID) {
        putParam(CAN_REMOVE_SUBSCRIBERS_GROUP, userGroupID);
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
