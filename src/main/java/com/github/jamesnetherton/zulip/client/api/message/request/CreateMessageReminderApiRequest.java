package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGE_REMINDER_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.response.CreateMessageReminderApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.time.Instant;

/**
 * Zulip API request builder for creating a message reminder.
 *
 * @see <a href="https://zulip.com/api/create-message-reminder">https://zulip.com/api/create-message-reminder</a>
 */
public class CreateMessageReminderApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Integer> {
    public static final String MESSAGE_ID = "message_id";
    public static final String NOTE = "note";
    public static final String SCHEDULED_DELIVERY_TIMESTAMP = "scheduled_delivery_timestamp";

    /**
     * Constructs a {@link CreateMessageReminderApiRequest}.
     *
     * @param messageId                  The id of the previously sent message to reference in the message reminder
     * @param scheduledDeliveryTimestamp The timestamp for when the message reminder will be sent
     * @param client                     The Zulip HTTP client
     */
    public CreateMessageReminderApiRequest(ZulipHttpClient client, long messageId, Instant scheduledDeliveryTimestamp) {
        super(client);
        putParam(MESSAGE_ID, messageId);
        putParam(SCHEDULED_DELIVERY_TIMESTAMP, scheduledDeliveryTimestamp.getEpochSecond());
    }

    /**
     * Sets the note associated with the reminder shown in the Notification Bot message.
     *
     * @see         <a href=
     *              "https://zulip.com/api/create-message-reminder#parameter-note">https://zulip.com/api/create-message-reminder#parameter-note</a>
     *
     * @param  note The reminder note
     * @return      This {@link CreateMessageReminderApiRequest} instance
     */
    public CreateMessageReminderApiRequest withNote(String note) {
        putParam(NOTE, note);
        return this;
    }

    /**
     * Executes the Zulip API request for creating a message reminder.
     *
     * @return                      The id of the created message reminder
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Integer execute() throws ZulipClientException {
        return client().post(MESSAGE_REMINDER_API_PATH, getParams(), CreateMessageReminderApiResponse.class).getReminderId();
    }
}
