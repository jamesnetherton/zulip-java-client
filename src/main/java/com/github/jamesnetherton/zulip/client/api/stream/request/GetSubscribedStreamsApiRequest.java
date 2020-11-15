package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.SUBSCRIPTIONS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscription;
import com.github.jamesnetherton.zulip.client.api.stream.response.GetSubscribedStreamsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting streams that the user is subscribed to.
 *
 * @see <a href="https://zulip.com/api/get-subscriptions">https://zulip.com/api/get-subscriptions</a>
 */
public class GetSubscribedStreamsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<StreamSubscription>> {

    public static final String INCLUDE_SUBSCRIBERS = "include_subscribers";

    /**
     * Constructs a {@link GetSubscribedStreamsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetSubscribedStreamsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets whether the response should include a list of subscriber user ids.
     *
     * @param  includeSubscribers {@code true} for the response to include a list of subscriber user ids. {@code false} for the
     *                            response to include an empty list of subscriber user id.
     * @return                    This {@link GetSubscribedStreamsApiRequest} instance
     */
    public GetSubscribedStreamsApiRequest withIncludeSubscribers(boolean includeSubscribers) {
        putParam(INCLUDE_SUBSCRIBERS, includeSubscribers);
        return this;
    }

    /**
     * Executes the Zulip API request for getting streams that the user is subscribed to.
     *
     * @return                      List of {@link StreamSubscription} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<StreamSubscription> execute() throws ZulipClientException {
        GetSubscribedStreamsApiResponse response = client().get(SUBSCRIPTIONS, getParams(),
                GetSubscribedStreamsApiResponse.class);
        return response.getSubscriptions();
    }
}
