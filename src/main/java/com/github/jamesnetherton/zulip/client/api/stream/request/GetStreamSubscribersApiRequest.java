package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.MEMBERS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.response.GetStreamSubscribersApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all users subscribed to a stream.
 *
 * @see <a href="https://zulip.com/api/get-subscribers">https://zulip.com/api/get-subscribers</a>
 */
public class GetStreamSubscribersApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Long>> {
    public static final String STREAM_ID = "stream_id";

    private final long streamId;

    /**
     * Constructs a {@link GetStreamSubscribersApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to get subscribers for
     */
    public GetStreamSubscribersApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        this.streamId = streamId;
    }

    /**
     * Executes the Zulip API request for getting all users subscribed to a stream.
     *
     * @return                      The list of user ids subscribed to the stream
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Long> execute() throws ZulipClientException {
        String path = String.format(MEMBERS, streamId);
        GetStreamSubscribersApiResponse response = client().get(path, getParams(), GetStreamSubscribersApiResponse.class);
        return response.getSubscribers();
    }
}
