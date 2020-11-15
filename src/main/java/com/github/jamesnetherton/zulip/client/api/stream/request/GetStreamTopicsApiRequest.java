package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.STREAM_TOPICS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.Topic;
import com.github.jamesnetherton.zulip.client.api.stream.response.GetStreamTopicsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting stream topics.
 *
 * @see <a href="https://zulip.com/api/get-stream-topics">https://zulip.com/api/get-stream-topics</a>
 */
public class GetStreamTopicsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Topic>> {

    private final long streamId;

    /**
     * Constructs a {@link GetStreamTopicsApiResponse}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to get topics from
     */
    public GetStreamTopicsApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        this.streamId = streamId;
    }

    /**
     * Executes the Zulip API request for getting stream topic.
     *
     * @return                      List of {@link Topic} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Topic> execute() throws ZulipClientException {
        String path = String.format(STREAM_TOPICS, streamId);
        GetStreamTopicsApiResponse response = client().get(path, getParams(), GetStreamTopicsApiResponse.class);
        return response.getTopics();
    }
}
