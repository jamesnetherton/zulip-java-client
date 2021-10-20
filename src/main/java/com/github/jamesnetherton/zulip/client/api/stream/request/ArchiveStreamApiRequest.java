package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.STREAMS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a topic.
 *
 * @see <a href="https://zulip.com/api/archive-stream">https://zulip.com/api/archive-stream</a>
 */
public class ArchiveStreamApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final String path;

    /**
     * Constructs a {@link ArchiveStreamApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to archive
     */
    public ArchiveStreamApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        this.path = String.format(STREAMS_WITH_ID, streamId);
    }

    /**
     * Executes the Zulip API request for archiving a stream.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(this.path, getParams(), ZulipApiResponse.class);
    }
}
