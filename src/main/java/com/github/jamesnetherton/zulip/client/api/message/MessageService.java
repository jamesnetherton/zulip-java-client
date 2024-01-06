package com.github.jamesnetherton.zulip.client.api.message;

import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.message.request.AddEmojiReactionApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.DeleteEmojiReactionApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.DeleteMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.DeleteScheduledMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.EditMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.EditScheduledMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.FileUploadApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.GetMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.GetMessageHistoryApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.GetMessageReadReceiptsApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.GetMessagesApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.GetScheduledMessagesApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.MarkAllAsReadApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.MarkStreamAsReadApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.MarkTopicAsReadApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.MatchesNarrowApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.RenderMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.SendMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.SendScheduledMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.UpdateMessageFlagsApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.UpdateMessageFlagsForNarrowApiRequest;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.io.File;
import java.time.Instant;

/**
 * Zulip message APIs.
 */
public class MessageService implements ZulipService {

    private final ZulipHttpClient client;

    /**
     * Constructs a {@link MessageService}.
     *
     * @param client The Zulip HTTP client
     */
    public MessageService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Adds a emoji reaction to a message.
     *
     * @see              <a href="https://zulip.com/api/add-reaction">https://zulip.com/api/add-reaction</a>
     *
     * @param  messageId The id of the message to add an emoji reaction to
     * @param  emojiName The name of the emoji to add
     * @return           The {@link AddEmojiReactionApiRequest} builder object
     */
    public AddEmojiReactionApiRequest addEmojiReaction(long messageId, String emojiName) {
        return new AddEmojiReactionApiRequest(this.client, messageId, emojiName);
    }

    /**
     * Removes a emoji reaction.
     *
     * @see              <a href="https://zulip.com/api/remove-reaction">https://zulip.com/api/remove-reaction</a>
     *
     * @param  messageId The id of the message to remove the reaction from
     * @param  emojiName The name of the emoji to remove
     * @return           The {@link DeleteEmojiReactionApiRequest} builder object
     */
    public DeleteEmojiReactionApiRequest deleteEmojiReaction(long messageId, String emojiName) {
        return new DeleteEmojiReactionApiRequest(this.client, messageId, emojiName);
    }

    /**
     * Permanently deletes a message.
     *
     * @see              <a href="https://zulip.com/api/delete-message">https://zulip.com/api/delete-message</a>
     *
     * @param  messageId The id of the message to delete
     * @return           The {@link DeleteMessageApiRequest} builder object
     */
    public DeleteMessageApiRequest deleteMessage(long messageId) {
        return new DeleteMessageApiRequest(this.client, messageId);
    }

    /**
     * Deletes and cancels the sending of a previously scheduled message.
     *
     * @see                       <a href=
     *                            "https://zulip.com/api/delete-scheduled-message">https://zulip.com/api/delete-scheduled-message</a>
     *
     * @param  scheduledMessageId The id of the scheduled message to delete
     * @return                    The {@link DeleteMessageApiRequest} builder object
     */
    public DeleteScheduledMessageApiRequest deleteScheduledMessage(long scheduledMessageId) {
        return new DeleteScheduledMessageApiRequest(this.client, scheduledMessageId);
    }

    /**
     * Edits the content or topic of a message.
     *
     * @see              <a href="https://zulip.com/api/update-message">https://zulip.com/api/update-message</a>
     *
     * @param  messageId The id of the message to edit
     * @return           The {@link EditMessageApiRequest} builder object
     */
    public EditMessageApiRequest editMessage(long messageId) {
        return new EditMessageApiRequest(this.client, messageId);
    }

    /**
     * Edits an existing scheduled message.
     *
     * @see                       <a href=
     *                            "https://zulip.com/api/update-scheduled-message">https://zulip.com/api/update-scheduled-message</a>
     *
     * @param  scheduledMessageId The id of the scheduled message to edit
     * @return                    The {@link EditMessageApiRequest} builder object
     */
    public EditScheduledMessageApiRequest editScheduledMessage(long scheduledMessageId) {
        return new EditScheduledMessageApiRequest(this.client, scheduledMessageId);
    }

    /**
     * Uploads a file to the Zulip server.
     *
     * @see         <a href="https://zulip.com/api/upload-file">https://zulip.com/api/upload-file</a>
     *
     * @param  file The file to upload
     * @return      The {@link FileUploadApiRequest} builder object
     */
    public FileUploadApiRequest fileUpload(File file) {
        return new FileUploadApiRequest(this.client, file);
    }

    /**
     * Gets a message edit history.
     *
     * @see              <a href="https://zulip.com/api/get-message-history">https://zulip.com/api/get-message-history</a>
     *
     * @param  messageId The id of the message to get edit history
     * @return           The {@link GetMessageHistoryApiRequest} builder object
     */
    public GetMessageHistoryApiRequest getMessageHistory(long messageId) {
        return new GetMessageHistoryApiRequest(this.client, messageId);
    }

    /**
     * Gets a single message.
     *
     * @see              <a href="https://zulip.com/api/get-message">https://zulip.com/api/get-message</a>
     *
     * @param  messageId The id of the message to get
     * @return           The {@link GetMessageApiRequest} builder object
     */
    public GetMessageApiRequest getMessage(long messageId) {
        return new GetMessageApiRequest(this.client, messageId);
    }

    /**
     * <p>
     * Fetch message history from a Zulip server using the specified before message id, after message id and
     * anchor value.
     * </p>
     * <p>
     * To refine the list of messages returned, use the returned {@link GetMessagesApiRequest} builder object
     * to set an anchor and narrow expression.
     * </p>
     * <p>
     * Note that a maximum of 5000 messages can be obtained per request. Therefore Zulip recommends
     * using a numBefore value of &lt;= 1000 and a numAfter value &lt;= 1000.
     * </p>
     *
     * @see              <a href="https://www.zulipchat.com/api/get-messages">https://www.zulipchat.com/api/get-messages</a>
     *
     * @param  numBefore The number of messages with IDs less than the anchor to retrieve
     * @param  numAfter  The number of messages with IDs greater than the anchor to retrieve
     * @param  anchor    The value for the server to compute the anchor from
     * @return           The {@link GetMessagesApiRequest} builder object
     */
    public GetMessagesApiRequest getMessages(int numBefore, int numAfter, Anchor anchor) {
        return new GetMessagesApiRequest(this.client)
                .withNumBefore(numBefore)
                .withNumAfter(numAfter)
                .withAnchor(anchor);
    }

    /**
     * <p>
     * Fetch message history from a Zulip server using the specified before message id, after message id and
     * anchor message ID.
     * </p>
     * <p>
     * To refine the list of messages returned, use the returned {@link GetMessagesApiRequest} builder object
     * to set an anchor and narrow expression.
     * </p>
     * <p>
     * Note that a maximum of 5000 messages can be obtained per request. Therefore Zulip recommends
     * using a numBefore value of &lt;= 1000 and a numAfter vlaue &lt;= 1000.
     * </p>
     *
     * @see              <a href="https://www.zulipchat.com/api/get-messages">https://www.zulipchat.com/api/get-messages</a>
     *
     * @param  numBefore The number of messages with IDs less than the (optional) anchor to retrieve
     * @param  numAfter  The number of messages with IDs greater than the (optional) anchor to retrieve
     * @param  anchor    The message ID to anchor fetching of new message
     * @return           The {@link GetMessagesApiRequest} builder object
     */
    public GetMessagesApiRequest getMessages(int numBefore, int numAfter, long anchor) {
        return new GetMessagesApiRequest(this.client)
                .withNumBefore(numBefore)
                .withNumAfter(numAfter)
                .withAnchor(anchor);
    }

    /**
     * Fetch all scheduled messages for the current user.
     *
     * @see    <a href="https://zulip.com/api/get-scheduled-messages"/>https://zulip.com/api/get-scheduled-messages</a>
     *
     * @return The {@link GetScheduledMessagesApiRequest} builder object
     */
    public GetScheduledMessagesApiRequest getScheduledMessages() {
        return new GetScheduledMessagesApiRequest(this.client);
    }

    /**
     * Marks all of the current user unread messages as read.
     *
     * @see        <a href="https://zulip.com/api/mark-all-as-read">https://zulip.com/api/mark-all-as-read</a>
     *
     * @return     The {@link MarkAllAsReadApiRequest} builder object
     *
     * @deprecated use {@code updateMessageFlagsForNarrow} instead.
     */
    @Deprecated
    public MarkAllAsReadApiRequest markAllAsRead() {
        return new MarkAllAsReadApiRequest(this.client);
    }

    /**
     * Marks a stream as read.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/mark-all-as-read#mark-messages-in-a-stream-as-read">https://zulip.com/api/mark-all-as-read#mark-messages-in-a-stream-as-read</a>
     *
     * @param  streamId The id of the stream to mark as read
     * @return          The {@link MarkStreamAsReadApiRequest} builder object
     */
    public MarkStreamAsReadApiRequest markStreamAsRead(long streamId) {
        return new MarkStreamAsReadApiRequest(this.client, streamId);
    }

    /**
     * Marks a topic as read.
     *
     * @see              <a href=
     *                   "https://zulip.com/api/mark-all-as-read#mark-messages-in-a-topic-as-read">https://zulip.com/api/mark-all-as-read#mark-messages-in-a-topic-as-read</a>
     *
     * @param  streamId  The id of the stream wher the topic resides
     * @param  topicName The name of the topic to mark as read
     * @return           The {@link MarkTopicAsReadApiRequest} builder object
     */
    public MarkTopicAsReadApiRequest markTopicAsRead(long streamId, String topicName) {
        return new MarkTopicAsReadApiRequest(this.client, streamId, topicName);
    }

    /**
     * Searches for and matches messages with a narrow.
     *
     * @see    <a href="https://zulip.com/api/check-narrow-matches">https://zulip.com/api/check-narrow-matches</a>
     *
     * @return The {@link MatchesNarrowApiRequest} builder object
     */
    public MatchesNarrowApiRequest matchMessages() {
        return new MatchesNarrowApiRequest(this.client);
    }

    /**
     * Renders a message to HTML.
     *
     * @see            <a href="https://zulip.com/api/render-message">https://zulip.com/api/render-message</a>
     *
     * @param  content The content to render as HTML
     * @return         The {@link RenderMessageApiRequest} builder object
     */
    public RenderMessageApiRequest renderMessage(String content) {
        return new RenderMessageApiRequest(this.client, content);
    }

    /**
     * Sends a direct message to the users matching the given email addresses.
     *
     * @see               <a href="https://zulip.com/api/send-message">https://zulip.com/api/send-message</a>
     *
     * @param  content    The content of the message
     * @param  userEmails The email addresses of the users to send the message to
     * @return            The {@link SendMessageApiRequest} builder object
     */
    public SendMessageApiRequest sendDirectMessage(String content, String... userEmails) {
        return new SendMessageApiRequest(this.client, content, userEmails);
    }

    /**
     * Sends a direct message to the users matching the given email user ids.
     *
     * @see            <a href="https://zulip.com/api/send-message">https://zulip.com/api/send-message</a>
     *
     * @param  content The content of the message
     * @param  userIds The ids of the users to send the message to
     * @return         The {@link SendMessageApiRequest} builder object
     */
    public SendMessageApiRequest sendDirectMessage(String content, long... userIds) {
        return new SendMessageApiRequest(this.client, content, userIds);
    }

    /**
     * Sends a private message to the users matching the given email addresses.
     *
     * @see                   <a href="https://zulip.com/api/send-message">https://zulip.com/api/send-message</a>
     *
     * @param      content    The content of the message
     * @param      userEmails The email addresses of the users to send the message to
     * @return                The {@link SendMessageApiRequest} builder object
     * @deprecated            Use sendDirectMessage instead
     */
    @Deprecated(forRemoval = true)
    public SendMessageApiRequest sendPrivateMessage(String content, String... userEmails) {
        return sendDirectMessage(content, userEmails);
    }

    /**
     * Sends a private message to the users matching the given email user ids.
     *
     * @see                <a href="https://zulip.com/api/send-message">https://zulip.com/api/send-message</a>
     *
     * @param      content The content of the message
     * @param      userIds The ids of the users to send the message to
     * @return             The {@link SendMessageApiRequest} builder object
     * @deprecated         Use sendDirectMessage instead
     */
    @Deprecated(forRemoval = true)
    public SendMessageApiRequest sendPrivateMessage(String content, long... userIds) {
        return sendDirectMessage(content, userIds);
    }

    /**
     * Schedules the sending of a message to a specified stream or users.
     *
     * @param  type              The type of scheduled message to be sent
     * @param  content           The content of the message
     * @param  deliveryTimestamp {@link Instant} set to the UNIX epoch timestamp for when the message will be sent
     * @param  to                If the type is 'stream' then this is the id of the stream. Else one or more user ids may be
     *                           specified
     * @return                   The {@link SendScheduledMessageApiRequest}
     */
    public SendScheduledMessageApiRequest sendScheduledMessage(MessageType type, String content, Instant deliveryTimestamp,
            long... to) {
        return new SendScheduledMessageApiRequest(this.client, type, content, deliveryTimestamp, to);
    }

    /**
     * Sends a stream message to the given stream name and topic.
     *
     * @see               <a href="https://zulip.com/api/send-message">https://zulip.com/api/send-message</a>
     *
     * @param  content    The content of the message
     * @param  streamName The name of the stream to send the message to
     * @param  topic      The name of the message topic
     * @return            The {@link SendMessageApiRequest} builder object
     */
    public SendMessageApiRequest sendStreamMessage(String content, String streamName, String topic) {
        return new SendMessageApiRequest(this.client, content, streamName, topic);
    }

    /**
     * Sends a stream message to the given stream id and topic.
     *
     * @see             <a href="https://zulip.com/api/send-message">https://zulip.com/api/send-message</a>
     *
     * @param  content  The content of the message
     * @param  streamId The id of the stream to send the message to
     * @param  topic    The name of the message topic
     * @return          The {@link SendMessageApiRequest} builder object
     */
    public SendMessageApiRequest sendStreamMessage(String content, long streamId, String topic) {
        return new SendMessageApiRequest(this.client, content, streamId, topic);
    }

    /**
     * Add or remove personal message flags on a collection of message ids
     *
     * @see               <a href=
     *                    "https://zulip.com/api/update-message-flags-for-narrow">https://zulip.com/api/update-message-flags</a>
     *
     * @param  flag       The {@link MessageFlag} to add or remove
     * @param  operation  The {@link Operation} to apply
     * @param  messageIds The message ids to update flags on
     * @return            The {@link UpdateMessageFlagsApiRequest} builder object
     */
    public UpdateMessageFlagsApiRequest updateMessageFlags(MessageFlag flag, Operation operation, long... messageIds) {
        return new UpdateMessageFlagsApiRequest(this.client, flag, operation, messageIds);
    }

    /**
     * Add or remove personal message flags with a narrow
     *
     * @see              <a href=
     *                   "https://zulip.com/api/update-message-flags-for-narrow">https://zulip.com/api/update-message-flags-for-narrow</a>
     *
     * @param  anchor    The {@link Anchor} to use
     * @param  numBefore The number of messages preceding the anchor in the update range
     * @param  numAfter  The number of messages following the anchor in the update range
     * @param  operation The {@link Operation} to apply for the {@link MessageFlag}
     * @param  flag      The {@link MessageFlag} to add or remove to the messages
     * @param  narrows   The {@link Narrow} expressions to use
     * @return           The {@link UpdateMessageFlagsApiRequest} builder object
     */
    public UpdateMessageFlagsForNarrowApiRequest updateMessageFlagsForNarrow(
            Anchor anchor,
            int numBefore,
            int numAfter,
            Operation operation,
            MessageFlag flag,
            Narrow... narrows) {
        return new UpdateMessageFlagsForNarrowApiRequest(this.client, anchor, numBefore, numAfter, operation, flag, narrows);
    }

    /**
     * Add or remove personal message flags with a narrow
     *
     * @see              <a href=
     *                   "https://zulip.com/api/update-message-flags-for-narrow">https://zulip.com/api/update-message-flags-for-narrow</a>
     *
     * @param  anchor    The message id anchor to filter and restrict messages
     * @param  numBefore The number of messages preceding the anchor in the update range
     * @param  numAfter  The number of messages following the anchor in the update range
     * @param  operation The {@link Operation} to apply for the {@link MessageFlag}
     * @param  flag      The {@link MessageFlag} to add or remove to the messages
     * @param  narrows   The {@link Narrow} expressions to use
     * @return           The {@link UpdateMessageFlagsApiRequest} builder object
     */
    public UpdateMessageFlagsForNarrowApiRequest updateMessageFlagsForNarrow(
            int anchor,
            int numBefore,
            int numAfter,
            Operation operation,
            MessageFlag flag,
            Narrow... narrows) {
        return new UpdateMessageFlagsForNarrowApiRequest(this.client, anchor, numBefore, numAfter, operation, flag, narrows);
    }

    /**
     * Gets a list containing of IDs for all users who have marked the given message as read.
     *
     * @see              <a href="https://zulip.com/api/get-read-receipts">https://zulip.com/api/get-read-receipts</a>
     *
     * @param  messageId The id of the message to get read recipients for
     * @return           The {@link GetMessageReadReceiptsApiRequest} builder object
     */
    public GetMessageReadReceiptsApiRequest getMessageReadReceipts(long messageId) {
        return new GetMessageReadReceiptsApiRequest(this.client, messageId);
    }
}
