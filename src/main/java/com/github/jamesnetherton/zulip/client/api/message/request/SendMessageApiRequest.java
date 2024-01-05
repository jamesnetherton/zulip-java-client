package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGES_API_PATH;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import com.github.jamesnetherton.zulip.client.api.message.response.SendMessageApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API request builder for sending a message.
 *
 * @see <a href="https://zulip.com/api/send-message">https://zulip.com/api/send-message</a>
 */
public class SendMessageApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {

    public static final String CONTENT = "content";
    public static final String LOCAL_ID = "local_id";
    public static final String QUEUE_ID = "queue_id";
    public static final String READ_BY_SENDER = "read_by_sender";
    public static final String TO = "to";
    public static final String TO_DIRECT = "to_direct";
    public static final String TO_STREAM = "to_stream";
    public static final String TOPIC = "topic";
    public static final String TYPE = "type";

    /**
     * Constructs a {@link SendMessageApiRequest} for sending a direct message.
     *
     * @param client  The Zulip HTTP client
     * @param content The message content
     * @param to      One or more user email addresses for which the direct message should be sent to
     */
    public SendMessageApiRequest(ZulipHttpClient client, String content, String... to) {
        super(client);
        putParam(CONTENT, content);
        putParam(TYPE, MessageType.DIRECT.toString());
        putParam(TO_DIRECT, to);
    }

    /**
     * Constructs a {@link SendMessageApiRequest} for sending a direct message.
     *
     * @param client  The Zulip HTTP client
     * @param content The message content
     * @param to      One or more user ids for which the direct message should be sent to
     */
    public SendMessageApiRequest(ZulipHttpClient client, String content, long... to) {
        super(client);
        putParam(CONTENT, content);
        putParam(TYPE, MessageType.DIRECT.toString());
        putParam(TO_DIRECT, to);
    }

    /**
     * Constructs a {@link SendMessageApiRequest} for sending a message to a stream.
     *
     * @param client     The Zulip HTTP client
     * @param content    The message content
     * @param streamName The name of the stream to which the stream should be sent to
     * @param topic      The name od the topic to post the message under
     */
    public SendMessageApiRequest(ZulipHttpClient client, String content, String streamName, String topic) {
        super(client);
        putParam(CONTENT, content);
        putParam(TYPE, MessageType.STREAM.toString());
        putParam(TO_STREAM, streamName);
        putParam(TOPIC, topic);
    }

    /**
     * Constructs a {@link SendMessageApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param content  The message content
     * @param streamId The id of the stream to which the stream should be sent to
     * @param topic    The name od the topic to post the message under
     */
    public SendMessageApiRequest(ZulipHttpClient client, String content, long streamId, String topic) {
        super(client);
        putParam(CONTENT, content);
        putParam(TYPE, MessageType.STREAM.toString());
        putParam(TO_STREAM, streamId);
        putParam(TOPIC, topic);
    }

    /**
     * The optional local id associated with the message.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/send-message#parameter-local_id">https://zulip.com/api/send-message#parameter-local_id</a>
     *
     * @param  localId The local id to associate with the message
     * @return         This {@link SendMessageApiRequest} instance
     */
    public SendMessageApiRequest withLocalId(String localId) {
        putParam(LOCAL_ID, localId);
        return this;
    }

    /**
     * The optional queue id associated with the message.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/send-message#parameter-queue_id">https://zulip.com/api/send-message#parameter-queue_id</a>
     *
     * @param  queueId The queue id to associate with the message
     * @return         This {@link SendMessageApiRequest} instance
     */
    public SendMessageApiRequest withQueueId(String queueId) {
        putParam(QUEUE_ID, queueId);
        return this;
    }

    /**
     * The optional value of whether the message should be initially marked read by its sender.
     *
     * @see                 <a href=
     *                      "https://zulip.com/api/send-message#parameter-read_by_sender">https://zulip.com/api/send-message#parameter-read_by_sender</a>
     *
     * @param  readBySender Whether the message should be initially marked read by its sender
     * @return              This {@link SendMessageApiRequest} instance
     */
    public SendMessageApiRequest withReadBySender(boolean readBySender) {
        putParam(READ_BY_SENDER, readBySender);
        return this;
    }

    /**
     * Executes the Zulip API request for sending a message.
     *
     * @return                      The id of the message
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        final Map<String, Object> params = getParams();
        final Map<String, Object> modified = new HashMap<>();

        if (params.get(TYPE) != null) {
            for (Map.Entry<String, Object> entry : params.entrySet()) {
                if (!entry.getKey().equals(TO_DIRECT) && !entry.getKey().equals(TO_STREAM)) {
                    modified.put(entry.getKey(), entry.getValue());
                }
            }

            String type = (String) params.get(TYPE);
            if (type.equals(MessageType.DIRECT.toString())) {
                try {
                    modified.put(TO, JsonUtils.getMapper().writeValueAsString(params.get(TO_DIRECT)));
                } catch (JsonProcessingException e) {
                    throw new ZulipClientException(e);
                }
            } else {
                modified.put(TO, params.get(TO_STREAM));
            }
        }

        SendMessageApiResponse response = client().post(MESSAGES_API_PATH, modified, SendMessageApiResponse.class);
        return response.getId();
    }
}
