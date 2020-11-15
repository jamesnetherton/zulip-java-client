package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.MUTED_TOPICS;

import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for muting or unmuting a topic.
 *
 * @see <a href="https://zulip.com/api/mute-topic">https://zulip.com/api/mute-topic</a>
 */
public class MuteTopicApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String OPERATION = "op";
    public static final String STREAM = "stream";
    public static final String STREAM_ID = "stream_id";
    public static final String TOPIC = "topic";

    /**
     * Constructs a {@link MuteTopicApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param topic     The name of the topic to mute or unmute
     * @param operation The {@link Operation} to apply. {@code Operation.ADD} to mute the topic or {@code Operation.REMOVE} to
     *                  unmute the topic
     */
    public MuteTopicApiRequest(ZulipHttpClient client, String topic, Operation operation) {
        super(client);
        putParam(TOPIC, topic);
        putParam(OPERATION, operation.toString());
    }

    /**
     * Sets the name of the stream where the topic resides.
     *
     * @param  stream The name of the stream where the topic resides
     * @return        This {@link MuteTopicApiRequest} instance
     */
    public MuteTopicApiRequest withStream(String stream) {
        putParam(STREAM, stream);
        return this;
    }

    /**
     * Sets the id of the stream where the topic resides.
     *
     * @param  streamId The id of the stream where the topic resides
     * @return          This {@link MuteTopicApiRequest} instance
     */
    public MuteTopicApiRequest withStreamId(long streamId) {
        putParam(STREAM_ID, streamId);
        return this;
    }

    /**
     * Executes the Zulip API request for muting or unmuting a topic.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().patch(MUTED_TOPICS, getParams(), ZulipApiResponse.class);
    }
}
