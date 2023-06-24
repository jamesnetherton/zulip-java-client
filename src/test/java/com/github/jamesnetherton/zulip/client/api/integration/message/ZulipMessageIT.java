package com.github.jamesnetherton.zulip.client.api.integration.message;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.message.Anchor;
import com.github.jamesnetherton.zulip.client.api.message.Emoji;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.MessageEdit;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlag;
import com.github.jamesnetherton.zulip.client.api.message.MessageHistory;
import com.github.jamesnetherton.zulip.client.api.message.MessageReaction;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import com.github.jamesnetherton.zulip.client.api.message.PropagateMode;
import com.github.jamesnetherton.zulip.client.api.message.ScheduledMessage;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.api.stream.RetentionPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamPostPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

public class ZulipMessageIT extends ZulipIntegrationTestBase {

    @Test
    public void messageCrudOperations() throws ZulipClientException {
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Test Message Stream 1", "Test Message Stream 1"),
                StreamSubscriptionRequest.of("Test Message Stream 2", "Test Message Stream 2"),
                StreamSubscriptionRequest.of("Test Message Stream 3", "Test Message Stream 3"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withAnnounce(true)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Long streamId = zulip.streams().getStreamId("Test Message Stream 2").execute();

        // Create messages using each variant of sendStreamMessage
        zulip.messages().sendStreamMessage("Test Content", "Test Message Stream 1", "Test Topic 1").execute();
        zulip.messages().sendStreamMessage("Test Content", streamId, "Test Topic 2").execute();

        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", "Test Message Stream 1"))
                .execute();

        assertEquals(2, messages.size());
        Message message = messages.get(0);
        assertEquals("Internal", message.getClient());
        assertEquals("stream events", message.getSubject());
        assertEquals("Test Message Stream 1", message.getStream());
        assertEquals(MessageType.STREAM, message.getType());

        message = messages.get(1);
        // TODO: Handle null avatar URL properly
        // https://github.com/jamesnetherton/zulip-java-client/issues/149
        assertNull(message.getAvatarUrl());
        // assertTrue(message.getAvatarUrl().startsWith("https://secure.gravatar.com"));
        assertEquals("<p>Test Content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertEquals("Test Message Stream 1", message.getStream());
        assertEquals(MessageType.STREAM, message.getType());
        assertTrue(message.getId() > 0);
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertEquals("Test Topic 1", message.getSubject());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        message = zulip.messages().getMessage(message.getId()).execute();
        // TODO: Handle null avatar URL properly
        // https://github.com/jamesnetherton/zulip-java-client/issues/149
        assertNull(message.getAvatarUrl());
        // assertTrue(message.getAvatarUrl().startsWith("https://secure.gravatar.com"));
        assertEquals("<p>Test Content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertEquals("Test Message Stream 1", message.getStream());
        assertEquals(MessageType.STREAM, message.getType());
        assertTrue(message.getId() > 0);
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertEquals("Test Topic 1", message.getSubject());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withIncludeAnchor(true)
                .withNarrows(Narrow.of("stream", "Test Message Stream 2"))
                .execute();

        assertEquals(2, messages.size());
        message = messages.get(0);
        assertEquals("Internal", message.getClient());
        assertEquals("stream events", message.getSubject());
        assertEquals("Test Message Stream 2", message.getStream());
        assertEquals(MessageType.STREAM, message.getType());

        message = messages.get(1);
        // TODO: Handle null avatar URL properly
        // https://github.com/jamesnetherton/zulip-java-client/issues/149
        assertNull(message.getAvatarUrl());
        // assertTrue(message.getAvatarUrl().startsWith("https://secure.gravatar.com"));
        assertEquals("<p>Test Content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertEquals("Test Message Stream 2", message.getStream());
        assertEquals(MessageType.STREAM, message.getType());
        assertTrue(message.getId() > 0);
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertEquals("Test Topic 2", message.getSubject());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        // Update message
        Long stream3Id = zulip.streams().getStreamId("Test Message Stream 3").execute();

        zulip.messages().editMessage(message.getId())
                .withStreamId(stream3Id)
                .withPropagateMode(PropagateMode.CHANGE_ONE)
                .withSendNotificationToNewThread(true)
                .withSendNotificationToOldThread(false)
                .withTopic("Edited Topic")
                .execute();

        zulip.messages().updateMessageFlags(MessageFlag.STARRED, Operation.ADD, message.getId()).execute();
        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", "Test Message Stream 3"))
                .execute();
        message = messages.get(1);
        assertEquals(1, message.getFlags().size());
        assertEquals(MessageFlag.STARRED, message.getFlags().get(0));
        assertEquals("Edited Topic", message.getSubject());

        zulip.messages().updateMessageFlagsForNarrow(1, 1, 10, Operation.REMOVE, MessageFlag.STARRED,
                Narrow.of("stream", "Test Message Stream 3")).execute();
        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", "Test Message Stream 3"))
                .execute();
        message = messages.get(1);
        assertTrue(message.getFlags().isEmpty());
        assertEquals("Edited Topic", message.getSubject());

        List<MessageEdit> editHistory = message.getEditHistory();
        assertEquals(1, editHistory.size());
        MessageEdit edit = editHistory.get(0);
        assertNull(edit.getPreviousContent());
        assertNull(edit.getPreviousRenderedContent());
        assertEquals(0, edit.getPreviousRenderedContentVersion());
        assertEquals(streamId, edit.getPreviousStream());
        assertEquals("Test Topic 2", edit.getPreviousTopic());
        assertEquals(stream3Id, edit.getStream());
        assertEquals("Edited Topic", edit.getTopic());
        assertNotNull(edit.getTimestamp().toEpochMilli());
        assertEquals(ownUser.getUserId(), edit.getUserId());

        List<MessageHistory> messageHistories = zulip.messages().getMessageHistory(message.getId()).execute();
        assertEquals(2, messageHistories.size());

        MessageHistory messageHistory = messageHistories.get(1);
        assertEquals("Edited Topic", messageHistory.getTopic());
        assertEquals("Test Topic 2", messageHistory.getPreviousTopic());

        // Delete message
        zulip.messages().deleteMessage(message.getId()).execute();

        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", "Test Message Stream 2"))
                .execute();

        assertEquals(1, messages.size());
    }

    @Test
    public void reactions() throws ZulipClientException {
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Test Message Reaction", "Test Message Reaction"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        // Create message
        long messageId = zulip.messages().sendStreamMessage("Test Content", "Test Message Reaction", "Test Topic 1").execute();

        // Add reaction
        zulip.messages().addEmojiReaction(messageId, Emoji.PIG.getName()).execute();

        // Verify reaction added
        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", "Test Message Reaction"))
                .execute();

        assertEquals(2, messages.size());

        Message message = messages.get(1);
        List<MessageReaction> reactions = message.getReactions();
        assertEquals(1, reactions.size());
        assertEquals(Emoji.PIG.name().toLowerCase(), reactions.get(0).getEmojiName());

        // Delete reaction
        zulip.messages().deleteEmojiReaction(messageId, Emoji.PIG.getName()).execute();

        // Verify reaction removed
        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", "Test Message Reaction"))
                .execute();

        assertEquals(2, messages.size());

        message = messages.get(1);
        reactions = message.getReactions();
        assertTrue(reactions.isEmpty());
    }

    @Test
    public void fileUpload() throws IOException, ZulipClientException {
        Path tmpFile = Files.createTempFile("zulip", ".txt");
        Files.write(tmpFile, "test content".getBytes(StandardCharsets.UTF_8));

        String url = zulip.messages().fileUpload(tmpFile.toFile()).execute();

        assertTrue(url.matches("/user_uploads/.*/.*/.*/zulip[0-9]+.txt"));
    }

    @Test
    public void directMessages() throws ZulipClientException {
        // Send direct messages
        long firstMessageId = zulip.messages().sendDirectMessage("Test Direct Message 1", "test@test.com")
                .execute();

        long secondMessageId = zulip.messages().sendPrivateMessage("Test Direct Message 2", ownUser.getUserId())
                .execute();

        // Get private messages
        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("is", "dm"))
                .execute();

        messages = messages.stream()
                .filter(message -> message.getId() == firstMessageId || message.getId() == secondMessageId)
                .collect(Collectors.toList());

        assertEquals(2, messages.size());

        Message message = messages.get(0);
        assertEquals("<p>Test Direct Message 1</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertNull(message.getStream());
        assertEquals(MessageType.PRIVATE, message.getType());
        assertEquals(firstMessageId, message.getId());
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        message = messages.get(1);
        assertEquals("<p>Test Direct Message 2</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertNull(message.getStream());
        assertEquals(MessageType.PRIVATE, message.getType());
        assertEquals(secondMessageId, message.getId());
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        // Delete messages
        zulip.messages().deleteMessage(firstMessageId).execute();
        zulip.messages().deleteMessage(secondMessageId).execute();

        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("is", "dm"))
                .execute();

        messages = messages.stream()
                .filter(msg -> msg.getId() == firstMessageId || msg.getId() == secondMessageId)
                .collect(Collectors.toList());

        assertTrue(messages.isEmpty());
    }

    @Test
    public void markAsRead() throws ZulipClientException {
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Mark As Read Stream", "Mark As Read Stream"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        zulip.messages()
                .sendStreamMessage("content", "Mark As Read Stream", "Test Topic")
                .execute();

        Long streamId = zulip.streams().getStreamId("Mark As Read Stream").execute();

        zulip.messages().markStreamAsRead(streamId).execute();

        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", "Mark As Read Stream"))
                .execute();

        assertFalse(messages.isEmpty());

        Message message = messages.get(0);
        List<MessageFlag> flags = message.getFlags();
        assertFalse(flags.isEmpty());

        MessageFlag flag = flags.get(0);
        assertEquals(MessageFlag.READ, flag);
    }

    @Test
    public void markTopicAsRead() throws ZulipClientException {
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Mark Topic As Read Stream", "Mark Topic As Read Stream"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        zulip.messages()
                .sendStreamMessage("content", "Mark Topic As Read Stream", "Test Topic")
                .execute();

        long streamId = zulip.streams().getStreamId("Mark Topic As Read Stream").execute();

        zulip.messages().markTopicAsRead(streamId, "Test Topic").execute();

        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", "Mark Topic As Read Stream"))
                .execute();

        assertFalse(messages.isEmpty());

        Message message = messages.get(0);
        List<MessageFlag> flags = message.getFlags();
        assertFalse(flags.isEmpty());

        MessageFlag flag = flags.get(0);
        assertEquals(MessageFlag.READ, flag);
    }

    @Test
    public void markAllAsRead() throws ZulipClientException {
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Mark All Read Stream 1", "Mark All Read Stream 1"),
                StreamSubscriptionRequest.of("Mark All Read Stream 2", "Mark All Read Stream 2"),
                StreamSubscriptionRequest.of("Mark All Read Stream 3", "Mark All Read Stream 3"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        for (int i = 1; i <= 3; i++) {
            zulip.messages()
                    .sendStreamMessage("content", "Mark All Read Stream " + i, "Test Topic")
                    .execute();
        }

        zulip.messages().markAllAsRead().execute();

        List<Message> messages = zulip.messages().getMessages(3, 0, Anchor.NEWEST)
                .execute();

        assertEquals(3, messages.size());

        for (Message message : messages) {
            List<MessageFlag> flags = message.getFlags();
            assertFalse(flags.isEmpty());

            MessageFlag flag = flags.get(0);
            assertEquals(MessageFlag.READ, flag);

            List<Long> receipts = zulip.messages().getMessageReadReceipts(message.getId()).execute();
            assertNotNull(receipts);
        }
    }

    @Test
    public void messageMarkdown() throws ZulipClientException {
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Markdown Stream", "Markdown Stream"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        long messageId = zulip.messages()
                .sendStreamMessage("**content**", "Markdown Stream", "Test Topic")
                .execute();

        String markdown = zulip.messages().getMessageMarkdown(messageId).execute();
        assertEquals("**content**", markdown);

        Message message = zulip.messages().getMessage(messageId).withApplyMarkdown(false).execute();
        assertEquals("**content**", message.getContent());

        String rendered = zulip.messages().renderMessage("**content**").execute();
        assertEquals("<p><strong>content</strong></p>", rendered);
    }

    @Test
    @Tag("slow")
    public void scheduledMessagesCrudOperations() throws ZulipClientException {
        Instant deliveryTimestamp = Instant.now().plusSeconds(10);
        zulip.messages()
                .sendScheduledMessage(MessageType.DIRECT, "test scheduled message", deliveryTimestamp, ownUser.getUserId())
                .execute();

        List<ScheduledMessage> scheduledMessages = zulip.messages().getScheduledMessages().execute();
        assertEquals(1, scheduledMessages.size());

        ScheduledMessage scheduledMessage = scheduledMessages.get(0);
        assertEquals("test scheduled message", scheduledMessage.getContent());
        assertEquals("<p>test scheduled message</p>", scheduledMessage.getRenderedContent());

        List<Long> to = scheduledMessage.getTo();
        assertEquals(1, to.size());
        assertEquals(ownUser.getUserId(), to.get(0));
        assertEquals(MessageType.PRIVATE, scheduledMessage.getType());
        assertFalse(scheduledMessage.isFailed());

        long scheduledMessageId = scheduledMessage.getScheduledMessageId();
        zulip.messages().editScheduledMessage(scheduledMessageId).withContent("test edited scheduled message").execute();

        int maxAttempts = 20;
        int currAttempts = 1;
        List<Message> messages = null;
        while (currAttempts < maxAttempts) {
            messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                    .withNarrows(Narrow.of("is", "dm"))
                    .execute();

            if (messages.size() > 0) {
                break;
            }

            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            currAttempts++;
        }

        assertNotNull(messages);
        assertEquals(1, messages.size());

        Message message = messages.get(0);
        assertEquals("<p>test edited scheduled message</p>", message.getContent());

        zulip.messages().deleteScheduledMessage(scheduledMessageId).execute();

        scheduledMessages = zulip.messages().getScheduledMessages().execute();
        assertTrue(scheduledMessages.isEmpty());
    }
}
