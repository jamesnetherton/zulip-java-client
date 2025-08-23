package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGE_REMINDER_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.MessageReminder;
import com.github.jamesnetherton.zulip.client.api.message.response.GetMessageRemindersApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all message reminders for the current user.
 *
 * @see <a href="https://zulip.com/api/get-reminders">https://zulip.com/api/get-reminders</a>
 */
public class GetMessageRemindersApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<MessageReminder>> {
    /**
     * Constructs a {@link GetMessageRemindersApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetMessageRemindersApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all message reminders for the current user.
     *
     * @return                      List of {@link MessageReminder}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<MessageReminder> execute() throws ZulipClientException {
        return client().get(MESSAGE_REMINDER_API_PATH, getParams(), GetMessageRemindersApiResponse.class).getReminders();
    }
}
