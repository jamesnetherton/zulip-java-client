package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGES_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.DetachedUpload;
import com.github.jamesnetherton.zulip.client.api.message.PropagateMode;
import com.github.jamesnetherton.zulip.client.api.message.response.EditMessageApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for editing a message.
 *
 * @see <a href="https://zulip.com/api/update-message">https://zulip.com/api/update-message</a>
 */
public class EditMessageApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<DetachedUpload>> {

    public static final String CONTENT = "content";
    public static final String PREV_CONTENT_SHA256 = "prev_content_sha256";
    public static final String PROPAGATE_MODE = "propagate_mode";
    public static final String SEND_NOTIFICATION_TO_OLD_THREAD = "send_notification_to_old_thread";
    public static final String SEND_NOTIFICATION_TO_NEW_THREAD = "send_notification_to_new_thread";
    public static final String STREAM_ID = "stream_id";
    public static final String TOPIC = "topic";

    private final long messageId;

    /**
     * Constructs a {@link EditMessageApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param messageId The id of the message to edit
     */
    public EditMessageApiRequest(ZulipHttpClient client, long messageId) {
        super(client);
        this.messageId = messageId;
    }

    /**
     * Sets the optional edited message content.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/update-message#parameter-content">https://zulip.com/api/update-message#parameter-content</a>
     *
     * @param  content The modified message content
     * @return         This {@link EditMessageApiRequest} instance
     */
    public EditMessageApiRequest withContent(String content) {
        putParam(CONTENT, content);
        return this;
    }

    /**
     * Sets the SHA256 hash of the previous raw content of the message that the client has at the time of the request.
     *
     * @see                      <a href=
     *                           "https://zulip.com/api/update-message#parameter-prev_content_sha256">https://zulip.com/api/update-message#parameter-prev_content_sha256</a>
     *
     * @param  prevContentSha256 The SHA-256 hash of the previous raw content
     * @return                   This {@link EditMessageApiRequest} instance
     */
    public EditMessageApiRequest withPrevContentSha256(String prevContentSha256) {
        putParam(PREV_CONTENT_SHA256, prevContentSha256);
        return this;
    }

    /**
     * Sets the optional propagation mode. Controls which messages(s) should be deleted.
     *
     * @see         <a href=
     *              "https://zulip.com/api/update-message#parameter-propagate_mode">https://zulip.com/api/update-message#parameter-propagate_mode</a>
     *
     * @param  mode The propagation mode to use
     * @return      This {@link EditMessageApiRequest} instance
     */
    public EditMessageApiRequest withPropagateMode(PropagateMode mode) {
        putParam(PROPAGATE_MODE, mode.toString());
        return this;
    }

    /**
     * Sets the optional flag for whether to send a message to the old thread to
     * notify users where the message has moved to.
     *
     * @see         <a href=
     *              "https://zulip.com/api/update-message#parameter-send_notification_to_old_thread">https://zulip.com/api/update-message#parameter-send_notification_to_old_thread</a>
     *
     * @param  send {@code true} to send message notifications to the old thread. {@code false} to not send any notification
     * @return      This {@link EditMessageApiRequest} instance
     */
    public EditMessageApiRequest withSendNotificationToOldThread(boolean send) {
        putParam(SEND_NOTIFICATION_TO_OLD_THREAD, send);
        return this;
    }

    /**
     * Sets the optional flag for whether to send a message to the new thread to
     * notify users where the message came from.
     *
     * @see         <a href=
     *              "https://zulip.com/api/update-message#parameter-send_notification_to_new_thread">https://zulip.com/api/update-message#parameter-send_notification_to_new_thread</a>
     *
     * @param  send {@code true} to send message notifications to the new thread. {@code false} to not send any notification
     * @return      This {@link EditMessageApiRequest} instance
     */
    public EditMessageApiRequest withSendNotificationToNewThread(boolean send) {
        putParam(SEND_NOTIFICATION_TO_NEW_THREAD, send);
        return this;
    }

    /**
     * Sets the optional id of the stream to move the message to.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/update-message#parameter-send_notification_to_new_thread">https://zulip.com/api/update-message#parameter-send_notification_to_new_thread</a>
     *
     * @param  streamId The id of the stream to which the message should be moved to
     * @return          This {@link EditMessageApiRequest} instance
     */
    public EditMessageApiRequest withStreamId(long streamId) {
        putParam(STREAM_ID, streamId);
        return this;
    }

    /**
     * Sets the optional name of the topic to move the message to.
     *
     * @see          <a href=
     *               "https://zulip.com/api/update-message#parameter-topic">https://zulip.com/api/update-message#parameter-topic</a>
     *
     * @param  topic The name of the topic that the message should use
     * @return       This {@link EditMessageApiRequest} instance
     */
    public EditMessageApiRequest withTopic(String topic) {
        putParam(TOPIC, topic);
        return this;
    }

    /**
     * Executes the Zulip API request for editing a message.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<DetachedUpload> execute() throws ZulipClientException {
        String path = String.format(MESSAGES_ID_API_PATH, messageId);
        return client().patch(path, getParams(), EditMessageApiResponse.class).getDetachedUploads();
    }
}
