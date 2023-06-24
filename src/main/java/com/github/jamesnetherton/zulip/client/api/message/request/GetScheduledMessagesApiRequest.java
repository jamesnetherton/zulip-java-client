package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.SCHEDULED_MESSAGES_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.ScheduledMessage;
import com.github.jamesnetherton.zulip.client.api.message.response.GetScheduledMessagesApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting scheduled messages for the current user.
 *
 * @see <a href="https://zulip.com/api/get-scheduled-messages">https://zulip.com/api/get-scheduled-messages</a>
 */
public class GetScheduledMessagesApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<ScheduledMessage>> {

    /**
     * Constructs a {@link GetScheduledMessagesApiRequest}
     *
     * @param client The Zulip HTTP client
     */
    public GetScheduledMessagesApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting scheduled messages for the current user.
     *
     * @return                      List of {@link ScheduledMessage} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<ScheduledMessage> execute() throws ZulipClientException {
        GetScheduledMessagesApiResponse response = client().get(SCHEDULED_MESSAGES_API_PATH, getParams(),
                GetScheduledMessagesApiResponse.class);
        return response.getScheduledMessages();
    }
}
