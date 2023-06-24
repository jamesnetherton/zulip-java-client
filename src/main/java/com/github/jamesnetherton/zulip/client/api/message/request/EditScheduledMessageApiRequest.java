package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.SCHEDULED_MESSAGES_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.time.Instant;

/**
 * Zulip API request builder for editing a scheduled message.
 *
 * @see <a href="https://zulip.com/api/update-scheduled-message">https://zulip.com/api/update-scheduled-message</a>
 */
public class EditScheduledMessageApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String CONTENT = "content";
    public static final String SCHEDULED_DELIVERY_TIMESTAMP = "scheduled_delivery_timestamp";
    public static final String TO = "to";
    public static final String TOPIC = "topic";
    public static final String TYPE = "type";

    private final long scheduledMessageId;

    /**
     * Constructs a {@link EditScheduledMessageApiRequest}.
     *
     * @param client             The Zulip HTTP client
     * @param scheduledMessageId The id of the scheduled message to edit
     */
    public EditScheduledMessageApiRequest(ZulipHttpClient client, long scheduledMessageId) {
        super(client);
        this.scheduledMessageId = scheduledMessageId;
    }

    /**
     * Sets the topic of the message. Only required if 'type' is 'stream'.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/update-scheduled-message#parameter-topic">https://zulip.com/api/update-scheduled-message#parameter-topic</a>
     *
     * @param  content The content of the message
     * @return         This {@link EditScheduledMessageApiRequest} instance
     */
    public EditScheduledMessageApiRequest withContent(String content) {
        putParam(CONTENT, content);
        return this;
    }

    /**
     * Sets the UNIX epoch timestamp for when the message will be sent.
     *
     * @see                               <a href=
     *                                    "https://zulip.com/api/update-scheduled-message#parameter-topic">https://zulip.com/api/update-scheduled-message#parameter-topic</a>
     *
     * @param  scheduledDeliveryTimestamp {@link Instant} set to the UNIX epoch timestamp for when the message will be sent
     * @return                            This {@link EditScheduledMessageApiRequest} instance
     */
    public EditScheduledMessageApiRequest withScheduledDeliveryTimestamp(Instant scheduledDeliveryTimestamp) {
        putParam(SCHEDULED_DELIVERY_TIMESTAMP, scheduledDeliveryTimestamp.getEpochSecond());
        return this;
    }

    /**
     * Sets the id of the stream, or one or more user ids to send the scheduled message to.
     *
     * @see       <a href=
     *            "https://zulip.com/api/update-scheduled-message#parameter-topic">https://zulip.com/api/update-scheduled-message#parameter-topic</a>
     *
     * @param  to If the type is 'stream' then this is the id of the stream. Else one or more user ids may be specified
     * @return    This {@link EditScheduledMessageApiRequest} instance
     */
    public EditScheduledMessageApiRequest withTo(long... to) {
        putParam(TO, to);
        return this;
    }

    /**
     * Sets the topic of the message. Only required if 'type' is 'stream'.
     *
     * @see          <a href=
     *               "https://zulip.com/api/update-scheduled-message#parameter-topic">https://zulip.com/api/update-scheduled-message#parameter-topic</a>
     *
     * @param  topic The topic that the scheduled message should be sent to
     * @return       This {@link EditScheduledMessageApiRequest} instance
     */
    public EditScheduledMessageApiRequest withTopic(String topic) {
        putParam(TOPIC, topic);
        return this;
    }

    /**
     * Sets the type of scheduled message to be sent
     *
     * @see         <a href=
     *              "https://zulip.com/api/update-scheduled-message#parameter-topic">https://zulip.com/api/update-scheduled-message#parameter-topic</a>
     *
     * @param  type The type of scheduled message to be sent
     * @return      This {@link EditScheduledMessageApiRequest} instance
     */
    public EditScheduledMessageApiRequest withType(MessageType type) {
        putParam(TYPE, type.toString());
        return this;
    }

    @Override
    public void execute() throws ZulipClientException {
        String type = (String) getParam(TYPE);
        long[] to = (long[]) getParam(TO);

        if (type != null) {
            if (to == null) {
                throw new ZulipClientException("'to' must be set if the scheduled message 'type' is updated");
            }

            if (type.equals(MessageType.STREAM.toString()) && to.length > 1) {
                throw new ZulipClientException("Can only have one 'to' id for a scheduled stream message");
            }

            if (type.equals(MessageType.STREAM.toString())) {
                putParam(TO, to[0]);
            } else {
                putParamAsJsonString(TO, to);
            }
        }

        String path = String.format(SCHEDULED_MESSAGES_ID_API_PATH, scheduledMessageId);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}
