package com.github.jamesnetherton.zulip.client.api.stream.request;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.StreamUnsubscribeResult;
import com.github.jamesnetherton.zulip.client.api.stream.response.UnsubscribeStreamsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for unsubscribing users from a stream.
 *
 * @see <a href="https://zulip.com/api/unsubscribe">https://zulip.com/api/unsubscribe</a>
 */
public class UnsubscribeStreamsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<StreamUnsubscribeResult> {

    public static final String SUBSCRIPTIONS = "subscriptions";
    public static final String PRINCIPALS = "principals";

    /**
     * Constructs a {@link UnsubscribeStreamsApiRequest}.
     *
     * @param client        The Zulip HTTP client
     * @param subscriptions An array of stream names to unsubscribe from
     */
    public UnsubscribeStreamsApiRequest(ZulipHttpClient client, String[] subscriptions) {
        super(client);
        putParamAsJsonString(SUBSCRIPTIONS, subscriptions);
    }

    /**
     * Sets the list of users that are to be unsubscribed from the stream.
     *
     * @param  emailAddresses The array of user email addresses to unsubscribe to the stream
     * @return                This {@link UnsubscribeStreamsApiRequest} instance
     */
    public UnsubscribeStreamsApiRequest withPrincipals(String... emailAddresses) {
        putParamAsJsonString(PRINCIPALS, emailAddresses);
        return this;
    }

    /**
     * Sets the list of users that are to be unsubscribed from the stream.
     *
     * @param  userIds The array of user ids to unsubscribe to the stream
     * @return         This {@link UnsubscribeStreamsApiRequest} instance
     */
    public UnsubscribeStreamsApiRequest withPrincipals(long... userIds) {
        putParamAsJsonString(PRINCIPALS, userIds);
        return this;
    }

    /**
     * Executes the Zulip API request for unsubscribing users from a stream.
     *
     * @return                      {@link StreamUnsubscribeResult} describing the result of the request to unsubscribe users
     *                              from streams
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public StreamUnsubscribeResult execute() throws ZulipClientException {
        UnsubscribeStreamsApiResponse response = client().delete(StreamRequestConstants.SUBSCRIPTIONS, getParams(),
                UnsubscribeStreamsApiResponse.class);
        return new StreamUnsubscribeResult(response);
    }
}
