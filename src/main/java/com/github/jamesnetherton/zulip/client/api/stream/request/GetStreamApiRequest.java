package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.STREAMS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;
import com.github.jamesnetherton.zulip.client.api.stream.response.GetStreamApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting a stream by id.
 *
 * @see <a href="https://zulip.com/api/get-stream-by-id">https://zulip.com/api/get-stream-by-id</a>
 */
public class GetStreamApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Stream> {

    private final String path;

    /**
     * Constructs a {@link GetStreamApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to get
     */
    public GetStreamApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        this.path = String.format(STREAMS_WITH_ID, streamId);
    }

    /**
     * Executes the Zulip API request for getting a stream by id.
     *
     * @return                      The stream matching the provided stream id
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Stream execute() throws ZulipClientException {
        GetStreamApiResponse getStreamApiResponse = client().get(path, getParams(), GetStreamApiResponse.class);
        return getStreamApiResponse.getStream();
    }
}
