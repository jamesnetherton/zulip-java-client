package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MARK_TOPIC_AS_READ;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for marking a topic as read.
 *
 * @see <a href=
 *      "https://zulip.com/api/mark-all-as-read#mark-messages-in-a-topic-as-read">https://zulip.com/api/mark-all-as-read#mark-messages-in-a-topic-as-read</a>
 */
public class MarkTopicAsReadApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String STREAM_ID = "stream_id";
    public static final String TOPIC_NAME = "topic_name";

    /**
     * Constructs a {@link MarkTopicAsReadApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param streamId  The id of stream containing the topic to mark as read
     * @param topicName The name of the topic to mark as read
     */
    public MarkTopicAsReadApiRequest(ZulipHttpClient client, long streamId, String topicName) {
        super(client);
        putParam(STREAM_ID, streamId);
        putParam(TOPIC_NAME, topicName);
    }

    /**
     * Executes the Zulip API request for marking a topic as read.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(MARK_TOPIC_AS_READ, getParams(), ZulipApiResponse.class);
    }
}
