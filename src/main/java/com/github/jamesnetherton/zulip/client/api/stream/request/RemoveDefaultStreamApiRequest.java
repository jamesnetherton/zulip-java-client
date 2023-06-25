package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.DEFAULT_STREAMS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for removing a default stream for new users joining the organization.
 *
 * @see <a href="https://zulip.com/api/remove-default-stream">https://zulip.com/api/remove-default-stream</a>
 */
public class RemoveDefaultStreamApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String STREAM_ID = "stream_id";

    /**
     * Constructs a {@link RemoveDefaultStreamApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to remove as a default for new users joining the organization
     */
    public RemoveDefaultStreamApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        putParam(STREAM_ID, streamId);
    }

    /**
     * Executes the Zulip API request for removing a default stream for new users joining the organization.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(DEFAULT_STREAMS, getParams(), ZulipApiResponse.class);
    }
}
