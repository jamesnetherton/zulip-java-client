package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.STREAMS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a stream.
 *
 * @see <a href="https://zulip.com/api/delete-stream">https://zulip.com/api/delete-stream</a>
 */
public class DeleteStreamApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long streamId;

    /**
     * Constructs a {@link DeleteStreamApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to delete
     */
    public DeleteStreamApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        this.streamId = streamId;
    }

    /**
     * Executes the Zulip API request for deleting a stream.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(STREAMS_WITH_ID, streamId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
