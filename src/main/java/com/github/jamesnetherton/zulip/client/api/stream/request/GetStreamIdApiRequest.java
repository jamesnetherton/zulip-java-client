package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.STREAM_ID;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.response.GetStreamIdApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting the id of a stream.
 *
 * @see <a href="https://zulip.com/api/get-stream-id">https://zulip.com/api/get-stream-id</a>
 */
public class GetStreamIdApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {

    public static final String STREAM = "stream";

    /**
     * Constructs a {@link GetStreamsApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param stream The name of the stream
     */
    public GetStreamIdApiRequest(ZulipHttpClient client, String stream) {
        super(client);
        putParam(STREAM, stream);
    }

    /**
     * Executes the Zulip API request for getting the id of a stream.
     *
     * @return                      The stream id
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        return client().get(STREAM_ID, getParams(), GetStreamIdApiResponse.class).getStreamId();
    }
}
