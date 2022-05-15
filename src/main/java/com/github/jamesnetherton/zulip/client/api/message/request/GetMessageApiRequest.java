package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGES_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.response.GetMessageApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting a single message.
 *
 * @see <a href="https://zulip.com/api/get-message">https://zulip.com/api/get-message</a>
 */
public class GetMessageApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Message> {

    public static final String APPLY_MARKDOWN = "apply_markdown";

    private final long messageId;

    /**
     * Constructs a {@link GetMessageApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param messageId The id of the message to get
     */
    public GetMessageApiRequest(ZulipHttpClient client, long messageId) {
        super(client);
        this.messageId = messageId;
    }

    /**
     * Sets whether message content is returned in its raw markdown format.
     *
     * @see                  <a href=
     *                       "https://zulip.com/api/get-message#parameter-apply_markdown">https://zulip.com/api/get-message#parameter-apply_markdown</a>
     *
     * @param  applyMarkdown If {@code true}, message content is returned in the rendered HTML format. If {@code false}, message
     *                       content is returned in the raw Markdown-format text that user entered.
     * @return               This {@link GetMessageApiRequest} instance
     */
    public GetMessageApiRequest withApplyMarkdown(boolean applyMarkdown) {
        putParam(APPLY_MARKDOWN, applyMarkdown);
        return this;
    }

    /**
     * Executes the Zulip API request for getting raw content from a message.
     *
     * @return                      The message
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Message execute() throws ZulipClientException {
        String path = String.format(MESSAGES_ID_API_PATH, messageId);
        GetMessageApiResponse response = client().get(path, getParams(), GetMessageApiResponse.class);
        return response.getMessage();
    }
}
