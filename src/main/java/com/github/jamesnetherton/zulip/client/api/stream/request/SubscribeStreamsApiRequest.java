package com.github.jamesnetherton.zulip.client.api.stream.request;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.RetentionPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamPostPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionResult;
import com.github.jamesnetherton.zulip.client.api.stream.response.SubscribeStreamsApiResponse;
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
    public static final String IS_WEB_PUBLIC = "is_web_public";
    public static final String HISTORY_PUBLIC_TO_SUBSCRIBERS = "history_public_to_subscribers";
    public static final String STREAM_POST_POLICY = "stream_post_policy";
    public static final String MESSAGE_RETENTION_DAYS = "message_retention_days";

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
