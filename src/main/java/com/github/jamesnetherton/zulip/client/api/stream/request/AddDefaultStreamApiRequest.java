package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.DEFAULT_STREAMS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for adding a default stream for new users joining the organization.
 *
 * @see <a href="https://zulip.com/api/add-default-stream">https://zulip.com/api/add-default-stream</a>
 */
public class AddDefaultStreamApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String STREAM_ID = "stream_id";

    /**
     * Constructs a {@link AddDefaultStreamApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to make a default for new users joining the organization
     */
    public AddDefaultStreamApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        putParam(STREAM_ID, streamId);
    }

    /**
     * Executes the Zulip API request for adding a default stream for new users joining the organization.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(DEFAULT_STREAMS, getParams(), ZulipApiResponse.class);
    }
}
