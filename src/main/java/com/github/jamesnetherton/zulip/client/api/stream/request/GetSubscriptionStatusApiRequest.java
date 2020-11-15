package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.USER_SUBSCRIPTIONS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.response.GetSubscriptionStatusApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for checking whether a user is subscribed to a stream.
 *
 * @see <a href="https://zulip.com/api/get-subscription-status">https://zulip.com/api/get-subscription-status</a>
 */
public class GetSubscriptionStatusApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Boolean> {

    private final long userId;
    private final long streamId;

    /**
     * Constructs a {@link GetSubscriptionStatusApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param userId   The user id to check if it is subscribed to the specified stream
     * @param streamId The id of the stream to check if the specified user is subscribed
     */
    public GetSubscriptionStatusApiRequest(ZulipHttpClient client, long userId, long streamId) {
        super(client);
        this.userId = userId;
        this.streamId = streamId;
    }

    /**
     * Executes the Zulip API request for checking whether a user is subscribed to a stream.
     *
     * @return                      {@code true} if the specified user is subscribed to the specified stream. {@code false} if
     *                              the user is not subscribed to the stream
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Boolean execute() throws ZulipClientException {
        String path = String.format(USER_SUBSCRIPTIONS, userId, streamId);
        return client().get(path, getParams(), GetSubscriptionStatusApiResponse.class).isSubscribed();
    }
}
