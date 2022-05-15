package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGES_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.response.GetMessageApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting the raw content from a message.
 *
 * @see <a href="https://zulip.com/api/get-message">https://zulip.com/api/get-message</a>
 */
@Deprecated
public class GetMessageMarkdownApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    private final long messageId;

    /**
     * Constructs a {@link GetMessageMarkdownApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param messageId The id of the message to get raw content from
     */
    public GetMessageMarkdownApiRequest(ZulipHttpClient client, long messageId) {
        super(client);
        this.messageId = messageId;
    }

    /**
     * Executes the Zulip API request for getting raw content from a message.
     *
     * @return                      The message raw content
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        String path = String.format(MESSAGES_ID_API_PATH, messageId);
        GetMessageApiResponse response = client().get(path, getParams(), GetMessageApiResponse.class);
        return response.getRawContent();
    }
}
