package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.HISTORY_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.MessageHistory;
import com.github.jamesnetherton.zulip.client.api.message.response.GetMessageHistoryApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for retrieving the history of a message.
 *
 * @see <a href="https://zulip.com/api/get-message-history">https://zulip.com/api/get-message-history</a>
 */
public class GetMessageHistoryApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<MessageHistory>> {
    public static final String ALLOW_EMPTY_TOPIC_NAME = "allow_empty_topic_name";

    private final long messageId;

    /**
     * Constructs a {@link GetMessageHistoryApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param messageId The id of the message to fetch history for
     */
    public GetMessageHistoryApiRequest(ZulipHttpClient client, long messageId) {
        super(client);
        this.messageId = messageId;
    }

    /**
     * Sets whether the topic names such as topic and prev_topic fields in the message_history objects returned can be an empty
     * string.
     *
     * @see                        <a href=
     *                             "https://zulip.com/api/get-message-history#parameter-allow_empty_topic_name">https://zulip.com/api/get-message-history#parameter-allow_empty_topic_name</a>
     *
     * @param  allowEmptyTopicName When {@code true} topic names such as topic and prev_topic fields in the message_history
     *                             objects returned can be an empty string. When {@code} false, empty topic name strings are not
     *                             allowed
     * @return                     This {@link GetMessageHistoryApiRequest} instance
     */
    public GetMessageHistoryApiRequest withAllowEmptyTopicName(boolean allowEmptyTopicName) {
        putParam(ALLOW_EMPTY_TOPIC_NAME, allowEmptyTopicName);
        return this;
    }

    /**
     * Executes The Zulip API request for retrieving the history of a message.
     *
     * @return                      this list of {@link MessageHistory} items
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<MessageHistory> execute() throws ZulipClientException {
        String path = String.format(HISTORY_API_PATH, messageId);
        GetMessageHistoryApiResponse response = client().get(path, getParams(), GetMessageHistoryApiResponse.class);
        return response.getMessageHistory();
    }
}
