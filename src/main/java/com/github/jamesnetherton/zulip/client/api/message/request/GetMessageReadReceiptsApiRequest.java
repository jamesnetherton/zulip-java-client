package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.READ_RECEIPTS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.response.GetMessageReadReceiptsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting a list containing of IDs for all users who have marked the given message as read.
 *
 * @see <a href="https://zulip.com/api/get-read-receipts">https://zulip.com/api/get-read-receipts</a>
 */
public class GetMessageReadReceiptsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Long>> {

    public static final String MESSAGE_ID = "message_id";
    private final String path;

    /**
     * Constructs a {@link GetMessageReadReceiptsApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param messageId The id of the message to get read recipients for
     */
    public GetMessageReadReceiptsApiRequest(ZulipHttpClient client, long messageId) {
        super(client);
        this.path = String.format(READ_RECEIPTS_API_PATH, messageId);
    }

    /**
     * Executes the Zulip API request for getting message receipts.
     *
     * @return                      List of user ids who have marked the target message as read
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Long> execute() throws ZulipClientException {
        GetMessageReadReceiptsApiResponse response = client().get(path, getParams(), GetMessageReadReceiptsApiResponse.class);
        return response.getUserIds();
    }
}
