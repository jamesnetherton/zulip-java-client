package com.github.jamesnetherton.zulip.client.api.integration.message;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipTestUtils;
import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.message.Anchor;
import com.github.jamesnetherton.zulip.client.api.message.DetachedUpload;
import com.github.jamesnetherton.zulip.client.api.message.Emoji;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.MessageEdit;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlag;
import com.github.jamesnetherton.zulip.client.api.message.MessageHistory;
import com.github.jamesnetherton.zulip.client.api.message.MessageReaction;
import com.github.jamesnetherton.zulip.client.api.message.MessageReminder;
import com.github.jamesnetherton.zulip.client.api.message.MessageReportReason;
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
import java.util.UUID;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

public class ZulipMessageIT extends ZulipIntegrationTestBase {

    @Test
    public void messageCrudOperations() throws ZulipClientException {
        String stream1Name = UUID.randomUUID().toString();
        String stream2Name = UUID.randomUUID().toString();
        String stream3Name = UUID.randomUUID().toString();

        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(stream1Name, stream1Name),
                StreamSubscriptionRequest.of(stream2Name, stream2Name),
                StreamSubscriptionRequest.of(stream3Name, stream3Name))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withAnnounce(true)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Long streamId = zulip.streams().getStreamId(stream2Name).execute();

        // Create messages using each variant of sendStreamMessage
        zulip.messages().sendStreamMessage("Test Content", stream1Name, "Test Topic 1")
                .withReadBySender(true)
                .execute();
        zulip.messages().sendStreamMessage("Test Content", streamId, "Test Topic 2").execute();

        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", stream1Name))
                .execute();

        assertEquals(2, messages.size());
        Message message = messages.get(0);
        assertEquals("Internal", message.getClient());
        assertEquals("channel events", message.getSubject());
        assertEquals(stream1Name, message.getStream());
        assertEquals(MessageType.STREAM, message.getType());

        message = messages.get(1);
        // TODO: Handle null avatar URL properly
        // https://github.com/jamesnetherton/zulip-java-client/issues/149
        assertNull(message.getAvatarUrl());
        // assertTrue(message.getAvatarUrl().startsWith("https://secure.gravatar.com"));
        assertEquals("<p>Test Content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertEquals(stream1Name, message.getStream());
        assertEquals(MessageType.STREAM, message.getType());
        assertTrue(message.getId() > 0);
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertEquals("Test Topic 1", message.getSubject());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        List<Message> messagesFromId = zulip.messages().getMessages(List.of(messages.get(0).getId(), messages.get(1).getId()))
                .execute();
        assertEquals(2, messagesFromId.size());

        message = zulip.messages().getMessage(message.getId()).execute();
        // TODO: Handle null avatar URL properly
        // https://github.com/jamesnetherton/zulip-java-client/issues/149
        assertNull(message.getAvatarUrl());
        // assertTrue(message.getAvatarUrl().startsWith("https://secure.gravatar.com"));
        assertEquals("<p>Test Content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertEquals(stream1Name, message.getStream());
        assertEquals(MessageType.STREAM, message.getType());
        assertTrue(message.getId() > 0);
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertEquals("Test Topic 1", message.getSubject());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withIncludeAnchor(true)
                .withAllowEmptyTopicName(true)
                .withNarrows(Narrow.of("stream", stream2Name))
                .execute();

        assertEquals(2, messages.size());
        message = messages.get(0);
        assertEquals("Internal", message.getClient());
        assertEquals("channel events", message.getSubject());
        assertEquals(stream2Name, stream2Name);
        assertEquals(MessageType.STREAM, message.getType());

        message = messages.get(1);
        // TODO: Handle null avatar URL properly
        // https://github.com/jamesnetherton/zulip-java-client/issues/149
        assertNull(message.getAvatarUrl());
        // assertTrue(message.getAvatarUrl().startsWith("https://secure.gravatar.com"));
        assertEquals("<p>Test Content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertEquals(stream2Name, stream2Name);
        assertEquals(MessageType.STREAM, message.getType());
        assertTrue(message.getId() > 0);
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertEquals("Test Topic 2", message.getSubject());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        // Update message
        Long stream3Id = zulip.streams().getStreamId(stream3Name).execute();

        List<DetachedUpload> detachedUploads = zulip.messages().editMessage(message.getId())
                .withStreamId(stream3Id)
                .withPrevContentSha256(ZulipTestUtils.stringToSha256("Test Content"))
                .withPropagateMode(PropagateMode.CHANGE_ONE)
                .withSendNotificationToNewThread(true)
                .withSendNotificationToOldThread(false)
                .withTopic("Edited Topic")
                .execute();

        assertTrue(detachedUploads.isEmpty());

        zulip.messages().updateMessageFlags(MessageFlag.STARRED, Operation.ADD, message.getId()).execute();
        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", stream3Name))
                .execute();
        message = messages.get(1);
        assertEquals(1, message.getFlags().size());
        assertEquals(MessageFlag.STARRED, message.getFlags().get(0));
        assertEquals("Edited Topic", message.getSubject());

        zulip.messages().updateMessageFlagsForNarrow(1, 1, 10, Operation.REMOVE, MessageFlag.STARRED,
                Narrow.of("stream", stream3Name)).execute();
        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", stream3Name))
                .execute();
        message = messages.get(1);
        assertTrue(message.getFlags().isEmpty());
        assertEquals("Edited Topic", message.getSubject());

        List<MessageEdit> editHistory = message.getEditHistory();
        assertEquals(1, editHistory.size());
        MessageEdit edit = editHistory.get(0);
        assertNull(edit.getPreviousContent());
        assertNull(edit.getPreviousRenderedContent());
        assertEquals(streamId, edit.getPreviousStream());
        assertEquals("Test Topic 2", edit.getPreviousTopic());
        assertEquals(stream3Id, edit.getStream());
        assertEquals("Edited Topic", edit.getTopic());
        assertNotNull(edit.getTimestamp().toEpochMilli());
        assertEquals(ownUser.getUserId(), edit.getUserId());

        List<MessageHistory> messageHistories = zulip.messages()
                .getMessageHistory(message.getId())
                .withAllowEmptyTopicName(true)
                .execute();
        assertEquals(2, messageHistories.size());

        MessageHistory messageHistory = messageHistories.get(1);
        assertEquals("Edited Topic", messageHistory.getTopic());
        assertEquals("Test Topic 2", messageHistory.getPreviousTopic());

        // Delete message
        zulip.messages().deleteMessage(message.getId()).execute();

        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", stream2Name))
                .execute();

        assertEquals(1, messages.size());
    }

    @Test
    public void channelMessages() throws ZulipClientException {
        String streamName1 = UUID.randomUUID().toString();
        String streamName2 = UUID.randomUUID().toString();
        zulip.channels().subscribe(
                StreamSubscriptionRequest.of(streamName1, streamName1),
                StreamSubscriptionRequest.of(streamName2, streamName2))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withAnnounce(true)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Long streamId = zulip.channels().getStreamId(streamName2).execute();

        // Create messages using each variant of sendStreamMessage
        zulip.messages().sendChannelMessage("Test Content", streamName1, "Test Topic 1")
                .withReadBySender(true)
                .execute();
        zulip.messages().sendChannelMessage("Test Content", streamId, "Test Topic 2").execute();

        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("channel", streamName1))
                .execute();

        assertEquals(2, messages.size());
        Message message = messages.get(0);
        assertEquals("Internal", message.getClient());
        assertEquals("channel events", message.getSubject());
        assertEquals(streamName1, message.getStream());
        assertEquals(MessageType.STREAM, message.getType());

        message = messages.get(1);
        // TODO: Handle null avatar URL properly
        // https://github.com/jamesnetherton/zulip-java-client/issues/149
        assertNull(message.getAvatarUrl());
        // assertTrue(message.getAvatarUrl().startsWith("https://secure.gravatar.com"));
        assertEquals("<p>Test Content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertEquals(streamName1, message.getStream());
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
        assertEquals(streamName1, message.getStream());
        assertEquals(MessageType.STREAM, message.getType());
        assertTrue(message.getId() > 0);
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertEquals("Test Topic 1", message.getSubject());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());

        messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withIncludeAnchor(true)
                .withNarrows(Narrow.of("channel", streamName2))
                .execute();

        assertEquals(2, messages.size());
        message = messages.get(0);
        assertEquals("Internal", message.getClient());
        assertEquals("channel events", message.getSubject());
        assertEquals(streamName2, message.getStream());
        assertEquals(MessageType.STREAM, message.getType());

        message = messages.get(1);
        // TODO: Handle null avatar URL properly
        // https://github.com/jamesnetherton/zulip-java-client/issues/149
        assertNull(message.getAvatarUrl());
        // assertTrue(message.getAvatarUrl().startsWith("https://secure.gravatar.com"));
        assertEquals("<p>Test Content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals("Apache-HttpClient", message.getClient());
        assertEquals(streamName2, message.getStream());
        assertEquals(MessageType.STREAM, message.getType());
        assertTrue(message.getId() > 0);
        assertEquals("test@test.com", message.getSenderEmail());
        assertEquals("tester", message.getSenderFullName());
        assertEquals("Test Topic 2", message.getSubject());
        assertNotNull(message.getTimestamp());
        assertFalse(message.isMeMessage());
        assertEquals(streamId, message.getStreamId());
    }

    @Test
    public void reactions() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        // Create message
        long messageId = zulip.messages().sendStreamMessage("Test Content", streamName, "Test Topic 1").execute();

        // Add reaction
        zulip.messages().addEmojiReaction(messageId, Emoji.PIG.getName()).execute();

        // Verify reaction added
        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", streamName))
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
                .withNarrows(Narrow.of("stream", streamName))
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

        long secondMessageId = zulip.messages().sendDirectMessage("Test Direct Message 2", ownUser.getUserId())
                .execute();

        // Get private messages
        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("is", "dm"))
                .execute();

        messages = messages.stream()
                .filter(message -> message.getId() == firstMessageId || message.getId() == secondMessageId)
                .collect(Collectors.toList());

        assertEquals(2, messages.size());

        List<Long> messageIds = messages.stream().map(Message::getSenderId).collect(Collectors.toList());
        List<Message> matches = zulip.messages()
                .getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("dm", messageIds))
                .execute();
        assertEquals(2, matches.size());

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
        String streamName = UUID.randomUUID().toString();
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        zulip.messages()
                .sendStreamMessage("content", streamName, "Test Topic")
                .execute();

        Long streamId = zulip.streams().getStreamId(streamName).execute();

        zulip.messages().markStreamAsRead(streamId).execute();

        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", streamName))
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
        String streamName = UUID.randomUUID().toString();
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        zulip.messages()
                .sendStreamMessage("content", streamName, "Test Topic")
                .execute();

        long streamId = zulip.streams().getStreamId(streamName).execute();

        zulip.messages().markTopicAsRead(streamId, "Test Topic").execute();

        List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST)
                .withNarrows(Narrow.of("stream", streamName))
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
        String streamName1 = UUID.randomUUID().toString();
        String streamName2 = UUID.randomUUID().toString();
        String streamName3 = UUID.randomUUID().toString();
        List<String> streamNames = List.of(streamName1, streamName2, streamName3);
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamName1, streamName1),
                StreamSubscriptionRequest.of(streamName2, streamName2),
                StreamSubscriptionRequest.of(streamName3, streamName3))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        for (int i = 1; i <= 3; i++) {
            zulip.messages()
                    .sendStreamMessage("content", streamNames.get(i - 1), "Test Topic")
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
        String streamName = UUID.randomUUID().toString();
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        long messageId = zulip.messages()
                .sendStreamMessage("**content**", streamName, "Test Topic")
                .execute();

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
                .withReadBySender(true)
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

    @Test
    public void reportMessage() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        zulip.messages()
                .sendStreamMessage("content", streamName, "Test Topic")
                .execute();

        Long messageId = zulip.messages().sendStreamMessage("Some bad content", streamName, "Test Topic").execute();

        // TODO: Remove assertThrows when realm settings APIs are enhanced with moderation settings
        assertThrows(ZulipClientException.class, () -> {
            zulip.messages().reportMessage(messageId, MessageReportReason.INAPPROPRIATE)
                    .withDescription("This message has some inappropriate content")
                    .execute();
        });
    }

    @Test
    public void messageReminderCrudOperations() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        zulip.messages()
                .sendStreamMessage("content", streamName, "Test Topic")
                .execute();

        Long messageId = zulip.messages().sendStreamMessage("Remind me about this", streamName, "Test Topic").execute();

        // Create
        Instant nowPlusOneSecond = Instant.now().plusSeconds(1);
        Integer messageReminderId = zulip.messages().createMessageReminder(messageId, nowPlusOneSecond)
                .withNote("Remind me about this")
                .execute();

        try {
            Thread.sleep(1500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Read
        List<MessageReminder> messageReminders = zulip.messages().getMessageReminders().execute();
        assertEquals(1, messageReminders.size());

        MessageReminder messageReminder = messageReminders.get(0);
        assertEquals(messageId, messageReminder.getReminderTargetMessageId());
        assertTrue(messageReminder.getContent().contains("Remind me about this"));
        assertNotNull(messageReminder.getRenderedContent());
        assertNotNull(messageReminder.getScheduledDeliveryTimestamp());
        assertFalse(messageReminder.isFailed());

        // Delete
        zulip.messages().deleteMessageReminder(messageReminderId).execute();

        messageReminders = zulip.messages().getMessageReminders().execute();
        assertTrue(messageReminders.isEmpty());
    }
}
