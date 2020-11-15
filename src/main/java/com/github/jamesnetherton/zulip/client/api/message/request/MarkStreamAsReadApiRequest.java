package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MARK_STREAM_AS_READ;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for marking a stream as read.
 *
 * @see <a href=
 *      "https://zulip.com/api/mark-all-as-read#mark-messages-in-a-stream-as-read">https://zulip.com/api/mark-all-as-read#mark-messages-in-a-stream-as-read</a>
 */
public class MarkStreamAsReadApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String STREAM_ID = "stream_id";

    /**
     * Constructs a {@link MarkStreamAsReadApiRequest}.
     * 
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to mark as read
     */
    public MarkStreamAsReadApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        putParam(STREAM_ID, streamId);
    }

    /**
     * Executes the Zulip API request for marking a stream as read.
     * 
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(MARK_STREAM_AS_READ, getParams(), ZulipApiResponse.class);
    }
}
