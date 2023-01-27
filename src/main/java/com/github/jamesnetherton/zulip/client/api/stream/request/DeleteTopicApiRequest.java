package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.TOPIC_DELETE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a topic.
 *
 * @see <a href="https://zulip.com/api/delete-topic">https://zulip.com/api/delete-topic</a>
 */
public class DeleteTopicApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String TOPIC_NAME = "topic_name";
    private final String path;

    /**
     * Constructs a {@link DeleteTopicApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param streamId  The id of the stream containing the topic to delete
     * @param topicName The name of the topic to delete
     */
    public DeleteTopicApiRequest(ZulipHttpClient client, long streamId, String topicName) {
        super(client);
        this.path = String.format(TOPIC_DELETE, streamId);
        putParam(TOPIC_NAME, topicName);
    }

    /**
     * Executes the Zulip API request for deleting a topic.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        ZulipApiResponse response = null;
        while (response == null || response.isPartiallyCompleted()) {
            response = client().post(this.path, getParams(), ZulipApiResponse.class);
        }
    }
}
