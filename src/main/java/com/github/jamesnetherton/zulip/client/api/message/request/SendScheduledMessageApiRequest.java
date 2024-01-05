package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.SCHEDULED_MESSAGES_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import com.github.jamesnetherton.zulip.client.api.message.response.SendScheduledMessageApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.time.Instant;

/**
 * Zulip API request builder for sending a scheduled message.
 *
 * @see <a href="https://zulip.com/api/create-scheduled-message">https://zulip.com/api/create-scheduled-message</a>
 */
public class SendScheduledMessageApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {

    public static final String CONTENT = "content";
    public static final String READ_BY_SENDER = "read_by_sender";
    public static final String SCHEDULED_DELIVERY_TIMESTAMP = "scheduled_delivery_timestamp";
    public static final String TO = "to";
    public static final String TOPIC = "topic";
    public static final String TYPE = "type";

    /**
     * Constructs a {@link SendScheduledMessageApiRequest} for sending a scheduled message.
     *
     * @param type              The type of scheduled message to be sent
     * @param content           The content of the message
     * @param deliveryTimestamp The UNIX epoch timestamp for when the message will be sent
     * @param to                If the type is 'stream' then this is the id of the stream. Else one or more user ids may be
     *                          specified
     * @param client            The Zulip HTTP client
     */
    public SendScheduledMessageApiRequest(ZulipHttpClient client, MessageType type, String content, Instant deliveryTimestamp,
            long... to) {
        super(client);
        putParam(CONTENT, content);
        putParam(SCHEDULED_DELIVERY_TIMESTAMP, deliveryTimestamp.getEpochSecond());
        putParam(TYPE, type.toString());

        if (type.equals(MessageType.STREAM)) {
            if (to.length > 1) {
                throw new IllegalArgumentException("Can only have one 'to' id for a scheduled stream message");
            }
            putParam(TO, to[0]);
        } else {
            putParamAsJsonString(TO, to);
        }
    }

    /**
     * Sets optional the value of whether the message should be initially marked read by its sender.
     *
     * @see                 <a href=
     *                      "https://zulip.com/api/create-scheduled-message#parameter-read_by_sender">https://zulip.com/api/create-scheduled-message#parameter-read_by_sender</a>
     *
     * @param  readBySender Whether the message should be initially marked read by its sender
     * @return              This {@link SendScheduledMessageApiRequest} instance
     */
    public SendScheduledMessageApiRequest withReadBySender(boolean readBySender) {
        putParam(READ_BY_SENDER, readBySender);
        return this;
    }

    /**
     * Sets the topic of the message. Only required if 'type' is 'stream'.
     *
     * @see          <a href=
     *               "https://zulip.com/api/create-scheduled-message#parameter-topic">https://zulip.com/api/create-scheduled-message#parameter-topic</a>
     *
     * @param  topic The topic that the scheduled message should be sent to
     * @return       This {@link SendScheduledMessageApiRequest} instance
     */
    public SendScheduledMessageApiRequest withTopic(String topic) {
        putParam(TOPIC, topic);
        return this;
    }

    /**
     * Executes the Zulip API request for sending a scheduled message.
     *
     * @return                      The id of the scheduled message
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        SendScheduledMessageApiResponse response = client().post(SCHEDULED_MESSAGES_API_PATH, getParams(),
                SendScheduledMessageApiResponse.class);
        return response.getScheduledMessageId();
    }
}
