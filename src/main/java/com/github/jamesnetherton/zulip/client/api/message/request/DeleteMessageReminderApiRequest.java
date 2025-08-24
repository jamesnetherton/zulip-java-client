package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGE_REMINDER_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a previously scheduled message reminder.
 *
 * @see <a href="https://zulip.com/api/delete-reminder">https://zulip.com/api/delete-reminder</a>
 */
public class DeleteMessageReminderApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    private final int messageReminderId;

    /**
     * Constructs a {@link DeleteMessageReminderApiRequest}.
     *
     * @param messageReminderId The id of the message reminder to delete
     * @param client            The Zulip HTTP client
     */
    public DeleteMessageReminderApiRequest(ZulipHttpClient client, int messageReminderId) {
        super(client);
        this.messageReminderId = messageReminderId;
    }

    /**
     * Executes the Zulip API request for deleting a previously scheduled message reminder.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(MESSAGE_REMINDER_ID_API_PATH, messageReminderId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
