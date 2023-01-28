package com.github.jamesnetherton.zulip.client.api.message;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.PATCH;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static com.github.tomakehurst.wiremock.stubbing.Scenario.STARTED;
import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.message.request.AddEmojiReactionApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.EditMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.GetMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.GetMessagesApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.MarkStreamAsReadApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.MarkTopicAsReadApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.MatchesNarrowApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.RenderMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.SendMessageApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.UpdateMessageFlagsApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.request.UpdateMessageFlagsForNarrowApiRequest;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipMessageApiTest extends ZulipApiTestBase {

    @Test
    public void addEmojiReaction() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddEmojiReactionApiRequest.EMOJI_CODE, "test")
                .add(AddEmojiReactionApiRequest.EMOJI_NAME, "happy")
                .add(AddEmojiReactionApiRequest.REACTION_TYPE, ReactionType.UNICODE.toString())
                .get();

        stubZulipResponse(POST, "/messages/1/reactions", params);

        zulip.messages().addEmojiReaction(1, "happy")
                .withEmojiCode("test")
                .withReactionType(ReactionType.UNICODE)
                .execute();
    }

    @Test
    public void deleteEmojiReaction() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddEmojiReactionApiRequest.EMOJI_CODE, "test")
                .add(AddEmojiReactionApiRequest.EMOJI_NAME, "happy")
                .add(AddEmojiReactionApiRequest.REACTION_TYPE, ReactionType.UNICODE.toString())
                .get();

        stubZulipResponse(DELETE, "/messages/1/reactions", params);

        zulip.messages().deleteEmojiReaction(1, "happy")
                .withEmojiCode("test")
                .withReactionType(ReactionType.UNICODE)
                .execute();
    }

    @Test
    public void deleteMessage() throws Exception {
        stubZulipResponse(DELETE, "/messages/1", Collections.emptyMap());

        zulip.messages().deleteMessage(1).execute();
    }

    @Test
    public void editMessage() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(EditMessageApiRequest.CONTENT, "edited content")
                .add(EditMessageApiRequest.PROPAGATE_MODE, PropagateMode.CHANGE_ONE.toString())
                .add(EditMessageApiRequest.SEND_NOTIFICATION_TO_NEW_THREAD, "true")
                .add(EditMessageApiRequest.SEND_NOTIFICATION_TO_OLD_THREAD, "true")
                .add(EditMessageApiRequest.STREAM_ID, "1")
                .add(EditMessageApiRequest.TOPIC, "test topic")
                .get();

        stubZulipResponse(PATCH, "/messages/1", params);

        zulip.messages().editMessage(1)
                .withContent("edited content")
                .withPropagateMode(PropagateMode.CHANGE_ONE)
                .withSendNotificationToNewThread(true)
                .withSendNotificationToOldThread(true)
                .withStreamId(1)
                .withTopic("test topic")
                .execute();
    }

    @Test
    public void fileUpload() throws Exception {
        Path tmpFile = Files.createTempFile("zulip", ".txt");
        Files.write(tmpFile, "test content".getBytes(StandardCharsets.UTF_8));

        stubMultiPartZulipResponse(POST, "/user_uploads", "fileUpload.json");

        String url = zulip.messages().fileUpload(tmpFile.toFile()).execute();

        assertEquals("/user_uploads/1/4e/m2A3MSqFnWRLUf9SaPzQ0Up_/zulip.txt", url);
    }

    @Test
    public void getMessageHistory() throws Exception {
        stubZulipResponse(GET, "/messages/1/history", "messageHistory.json");

        List<MessageHistory> messageHistories = zulip.messages().getMessageHistory(1).execute();
        assertEquals(2, messageHistories.size());

        MessageHistory messageHistory = messageHistories.get(0);
        assertEquals("content 1", messageHistory.getContent());
        assertEquals("<p>content 1</p>", messageHistory.getRenderedContent());
        assertEquals(1603913066000L, messageHistory.getTimestamp().toEpochMilli());
        assertEquals("topic 1", messageHistory.getTopic());
        assertEquals(1, messageHistory.getUserId());

        MessageHistory updatedHistory = messageHistories.get(1);
        assertEquals("content 2", updatedHistory.getContent());
        assertEquals("content 1", updatedHistory.getPreviousContent());
        assertEquals("<div>content diff</div>", updatedHistory.getContentHtmlDiff());
        assertEquals("<p>content 1</p>", updatedHistory.getPreviousRenderedContent());
        assertEquals("topic 1", updatedHistory.getPreviousTopic());
        assertEquals("<p>content 2</p>", updatedHistory.getRenderedContent());
        assertEquals(1603913066000L, updatedHistory.getTimestamp().toEpochMilli());
        assertEquals("topic 2", updatedHistory.getTopic());
        assertEquals(2, updatedHistory.getUserId());
    }

    @Test
    public void getMessageMarkdown() throws Exception {
        stubZulipResponse(GET, "/messages/1", "rawMarkdown.json");

        String markdown = zulip.messages().getMessageMarkdown(1).execute();

        assertEquals("some **bold** content", markdown);
    }

    @Test
    public void getMessagesWithIntAnchor() throws Exception {
        getMessages(1);
    }

    @Test
    public void getMessagesWithEnumAnchor() throws Exception {
        getMessages(Anchor.FIRST_UNREAD);
    }

    @Test
    public void getMessage() throws Exception {
        stubZulipResponse(GET, "/messages/1", "getMessage.json");

        Message message = zulip.messages().getMessage(1).execute();
        assertEquals("http://avatars.net/foobar", message.getAvatarUrl());
        assertEquals("populate_db", message.getClient());
        assertEquals("<p>Some test content</p>", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals(16, message.getId());
        assertFalse(message.isMeMessage());
        assertEquals(22, message.getRecipientId());
        assertEquals("hamlet@zulip.com", message.getSenderEmail());
        assertEquals("King Hamlet", message.getSenderFullName());
        assertEquals(99, message.getSenderId());
        assertEquals("zulip", message.getSenderRealm());
        assertEquals("Test message subject", message.getSubject());
        assertEquals(1603913066000L, message.getTimestamp().toEpochMilli());
        assertEquals(MessageType.STREAM, message.getType());

        List<MessageFlag> flags = message.getFlags();
        assertEquals(MessageFlag.values().length, flags.size());

        List<MessageReaction> reactions = message.getReactions();
        assertEquals(3, reactions.size());

        for (int i = 1; i <= reactions.size(); i++) {
            MessageReaction recation = reactions.get(i - 1);
            assertEquals("code " + i, recation.getEmojiCode());
            assertEquals("emoji " + i, recation.getEmojiName());
            assertEquals(i, recation.getUserId());

            if (i == 1) {
                assertEquals(ReactionType.UNICODE, recation.getReactionType());
            } else if (i == 2) {
                assertEquals(ReactionType.REALM, recation.getReactionType());
            } else if (i == 3) {
                assertEquals(ReactionType.ZULIP_EXTRA, recation.getReactionType());
            }
        }

        List<MessageRecipient> recipients = message.getRecipients();
        assertEquals(3, recipients.size());

        for (int i = 1; i <= recipients.size(); i++) {
            MessageRecipient recipient = recipients.get(i - 1);
            assertEquals("test" + i + "@zulip.com", recipient.getEmail());
            assertEquals("Test Name " + i, recipient.getFullName());
            assertEquals(i, recipient.getId());

            if (i != 2) {
                assertFalse(recipient.isMirrorDummy());
            } else {
                assertTrue(recipient.isMirrorDummy());
            }
        }

        List<String> topicLinks = message.getTopicLinks();
        assertEquals(3, topicLinks.size());

        for (int i = 1; i <= topicLinks.size(); i++) {
            String topicLink = topicLinks.get(i - 1);
            assertEquals("Topic " + i, topicLink);
        }

        List<MessageEdit> editHistory = message.getEditHistory();
        assertEquals(3, editHistory.size());

        for (int i = 1; i <= editHistory.size(); i++) {
            MessageEdit edit = editHistory.get(i - 1);
            assertEquals("Old Content " + i, edit.getPreviousContent());
            assertEquals("Old Rendered Content " + i, edit.getPreviousRenderedContent());
            assertEquals(i, edit.getPreviousRenderedContentVersion());
            assertEquals(i, edit.getPreviousStream());
            assertEquals("Old Topic " + i, edit.getPreviousTopic());
            assertEquals(i, edit.getStream());
            assertEquals("New Topic " + i, edit.getTopic());
            assertEquals(1603913066000L, edit.getTimestamp().toEpochMilli());
            assertEquals(i, edit.getUserId());
        }
    }

    @Test
    public void getMessageWithApplyRawMarkdown() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetMessageApiRequest.APPLY_MARKDOWN, "true")
                .get();

        stubZulipResponse(GET, "/messages/1", params, "getMessageRawMarkdown.json");

        Message message = zulip.messages().getMessage(1).withApplyMarkdown(true).execute();
        assertEquals("http://avatars.net/foobar", message.getAvatarUrl());
        assertEquals("populate_db", message.getClient());
        assertEquals("**Some test content**", message.getContent());
        assertEquals("text/html", message.getContentType());
        assertEquals(16, message.getId());
        assertFalse(message.isMeMessage());
        assertEquals(22, message.getRecipientId());
        assertEquals("hamlet@zulip.com", message.getSenderEmail());
        assertEquals("King Hamlet", message.getSenderFullName());
        assertEquals(99, message.getSenderId());
        assertEquals("zulip", message.getSenderRealm());
        assertEquals("Test message subject", message.getSubject());
        assertEquals(1603913066000L, message.getTimestamp().toEpochMilli());
        assertEquals(MessageType.STREAM, message.getType());

        List<MessageFlag> flags = message.getFlags();
        assertEquals(MessageFlag.values().length, flags.size());

        List<MessageReaction> reactions = message.getReactions();
        assertEquals(3, reactions.size());

        for (int i = 1; i <= reactions.size(); i++) {
            MessageReaction recation = reactions.get(i - 1);
            assertEquals("code " + i, recation.getEmojiCode());
            assertEquals("emoji " + i, recation.getEmojiName());
            assertEquals(i, recation.getUserId());

            if (i == 1) {
                assertEquals(ReactionType.UNICODE, recation.getReactionType());
            } else if (i == 2) {
                assertEquals(ReactionType.REALM, recation.getReactionType());
            } else if (i == 3) {
                assertEquals(ReactionType.ZULIP_EXTRA, recation.getReactionType());
            }
        }

        List<MessageRecipient> recipients = message.getRecipients();
        assertEquals(3, recipients.size());

        for (int i = 1; i <= recipients.size(); i++) {
            MessageRecipient recipient = recipients.get(i - 1);
            assertEquals("test" + i + "@zulip.com", recipient.getEmail());
            assertEquals("Test Name " + i, recipient.getFullName());
            assertEquals(i, recipient.getId());

            if (i != 2) {
                assertFalse(recipient.isMirrorDummy());
            } else {
                assertTrue(recipient.isMirrorDummy());
            }
        }

        List<String> topicLinks = message.getTopicLinks();
        assertEquals(3, topicLinks.size());

        for (int i = 1; i <= topicLinks.size(); i++) {
            String topicLink = topicLinks.get(i - 1);
            assertEquals("Topic " + i, topicLink);
        }

        List<MessageEdit> editHistory = message.getEditHistory();
        assertEquals(3, editHistory.size());

        for (int i = 1; i <= editHistory.size(); i++) {
            MessageEdit edit = editHistory.get(i - 1);
            assertEquals("Old Content " + i, edit.getPreviousContent());
            assertEquals("Old Rendered Content " + i, edit.getPreviousRenderedContent());
            assertEquals(i, edit.getPreviousRenderedContentVersion());
            assertEquals(i, edit.getPreviousStream());
            assertEquals("Old Topic " + i, edit.getPreviousTopic());
            assertEquals(i, edit.getStream());
            assertEquals("New Topic " + i, edit.getTopic());
            assertEquals(1603913066000L, edit.getTimestamp().toEpochMilli());
            assertEquals(i, edit.getUserId());
        }
    }

    public void getMessages(Object anchor) throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetMessagesApiRequest.ANCHOR, anchor.toString())
                .add(GetMessagesApiRequest.INCLUDE_ANCHOR, "true")
                .add(GetMessagesApiRequest.NUM_BEFORE, "3")
                .add(GetMessagesApiRequest.NUM_AFTER, "1")
                .add(GetMessagesApiRequest.MARKDOWN, "true")
                .add(GetMessagesApiRequest.GRAVATAR, "true")
                .add(GetMessagesApiRequest.NARROW,
                        "[{\"operator\":\"foo\",\"operand\":\"bar\",\"negated\":false},{\"operator\":\"cheese\",\"operand\":\"wine\",\"negated\":true}]")
                .get();

        stubZulipResponse(GET, "/messages", params, "getMessages.json");

        List<Message> messages;
        if (anchor instanceof Integer) {
            messages = zulip.messages().getMessages(3, 1, (Integer) anchor)
                    .withIncludeAnchor(true)
                    .withMarkdown(true)
                    .withGravatar(true)
                    .withNarrows(Narrow.of("foo", "bar"), Narrow.ofNegated("cheese", "wine"))
                    .execute();
        } else {
            messages = zulip.messages().getMessages(3, 1, (Anchor) anchor)
                    .withIncludeAnchor(true)
                    .withMarkdown(true)
                    .withGravatar(true)
                    .withNarrows(Narrow.of("foo", "bar"), Narrow.ofNegated("cheese", "wine"))
                    .execute();
        }

        assertEquals(2, messages.size());

        Message streamMessage = messages.get(0);
        assertEquals("http://avatars.net/foobar", streamMessage.getAvatarUrl());
        assertEquals("populate_db", streamMessage.getClient());
        assertEquals("<p>Some test content</p>", streamMessage.getContent());
        assertEquals("text/html", streamMessage.getContentType());
        assertEquals(16, streamMessage.getId());
        assertFalse(streamMessage.isMeMessage());
        assertEquals(22, streamMessage.getRecipientId());
        assertEquals("hamlet@zulip.com", streamMessage.getSenderEmail());
        assertEquals("King Hamlet", streamMessage.getSenderFullName());
        assertEquals(99, streamMessage.getSenderId());
        assertEquals("zulip", streamMessage.getSenderRealm());
        assertEquals("Test message subject", streamMessage.getSubject());
        assertEquals(1603913066000L, streamMessage.getTimestamp().toEpochMilli());
        assertEquals(MessageType.STREAM, streamMessage.getType());

        List<MessageFlag> flags = streamMessage.getFlags();
        assertEquals(MessageFlag.values().length, flags.size());

        List<MessageReaction> reactions = streamMessage.getReactions();
        assertEquals(3, reactions.size());

        for (int i = 1; i <= reactions.size(); i++) {
            MessageReaction recation = reactions.get(i - 1);
            assertEquals("code " + i, recation.getEmojiCode());
            assertEquals("emoji " + i, recation.getEmojiName());
            assertEquals(i, recation.getUserId());

            if (i == 1) {
                assertEquals(ReactionType.UNICODE, recation.getReactionType());
            } else if (i == 2) {
                assertEquals(ReactionType.REALM, recation.getReactionType());
            } else if (i == 3) {
                assertEquals(ReactionType.ZULIP_EXTRA, recation.getReactionType());
            }
        }

        List<MessageRecipient> recipients = streamMessage.getRecipients();
        assertEquals(3, recipients.size());

        for (int i = 1; i <= recipients.size(); i++) {
            MessageRecipient recipient = recipients.get(i - 1);
            assertEquals("test" + i + "@zulip.com", recipient.getEmail());
            assertEquals("Test Name " + i, recipient.getFullName());
            assertEquals(i, recipient.getId());

            if (i != 2) {
                assertFalse(recipient.isMirrorDummy());
            } else {
                assertTrue(recipient.isMirrorDummy());
            }
        }

        List<String> topicLinks = streamMessage.getTopicLinks();
        assertEquals(3, topicLinks.size());

        for (int i = 1; i <= topicLinks.size(); i++) {
            String topicLink = topicLinks.get(i - 1);
            assertEquals("Topic " + i, topicLink);
        }

        List<MessageEdit> editHistory = streamMessage.getEditHistory();
        assertEquals(3, editHistory.size());

        for (int i = 1; i <= editHistory.size(); i++) {
            MessageEdit edit = editHistory.get(i - 1);
            assertEquals("Old Content " + i, edit.getPreviousContent());
            assertEquals("Old Rendered Content " + i, edit.getPreviousRenderedContent());
            assertEquals(i, edit.getPreviousRenderedContentVersion());
            assertEquals(i, edit.getPreviousStream());
            assertEquals("Old Topic " + i, edit.getPreviousTopic());
            assertEquals(i, edit.getStream());
            assertEquals("New Topic " + i, edit.getTopic());
            assertEquals(1603913066000L, edit.getTimestamp().toEpochMilli());
            assertEquals(i, edit.getUserId());
        }

        Message privateMessage = messages.get(1);
        assertEquals("Verona", privateMessage.getStream());
        assertTrue(privateMessage.isMeMessage());
        assertEquals(MessageType.PRIVATE, privateMessage.getType());
    }

    @Test
    public void markAllAsRead() throws Exception {
        stubZulipResponse(POST, "/mark_all_as_read", Collections.emptyMap());

        zulip.messages().markAllAsRead().execute();
    }

    @Test
    public void markAllAsReadPartiallyCompleted() throws Exception {
        String scenarioName = "markAllAsReadPartiallyCompleted";
        stubZulipResponse(POST, "/mark_all_as_read", Collections.emptyMap(), "markAllAsReadPartiallyCompleted.json",
                scenarioName, STARTED, "retry");
        stubZulipResponse(POST, "/mark_all_as_read", Collections.emptyMap(), SUCCESS_JSON, scenarioName, "retry", "success");

        zulip.messages().markAllAsRead().execute();
    }

    @Test
    public void markStreamAsRead() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(MarkStreamAsReadApiRequest.STREAM_ID, "1")
                .get();

        stubZulipResponse(POST, "/mark_stream_as_read", params);

        zulip.messages().markStreamAsRead(1).execute();
    }

    @Test
    public void markTopicAsRead() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(MarkTopicAsReadApiRequest.STREAM_ID, "1")
                .add(MarkTopicAsReadApiRequest.TOPIC_NAME, "test topic")
                .get();

        stubZulipResponse(POST, "/mark_topic_as_read", params);

        zulip.messages().markTopicAsRead(1, "test topic").execute();
    }

    @Test
    public void matchesNarrow() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(MatchesNarrowApiRequest.MESSAGE_IDS, "[1,2,3]")
                .add(MatchesNarrowApiRequest.NARROW,
                        "[{\"operator\":\"foo\",\"operand\":\"bar\",\"negated\":false},{\"operator\":\"cheese\",\"operand\":\"wine\",\"negated\":true}]")
                .get();

        stubZulipResponse(GET, "/messages/matches_narrow", params, "matchesNarrow.json");

        Map<Long, MessageMatch> matches = zulip.messages().matchMessages()
                .withMessageIds(1, 2, 3)
                .withNarrows(Narrow.of("foo", "bar"), Narrow.ofNegated("cheese", "wine"))
                .execute();

        assertEquals(2, matches.size());

        for (long i = 1; i <= matches.size(); i++) {
            MessageMatch match = matches.get(i);
            assertEquals("test content " + i, match.getContent());
            assertEquals("test subject " + i, match.getSubject());
        }
    }

    @Test
    public void renderMessage() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(RenderMessageApiRequest.CONTENT, "test")
                .get();

        stubZulipResponse(POST, "/messages/render", params, "renderMessage.json");

        String rendered = zulip.messages().renderMessage("test").execute();

        assertEquals("<p><strong>test</strong></p>", rendered);
    }

    @Test
    public void sendPrivateMessageWithUserIds() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SendMessageApiRequest.CONTENT, "test private message")
                .add(SendMessageApiRequest.LOCAL_ID, "foo")
                .add(SendMessageApiRequest.QUEUE_ID, "bar")
                .add(SendMessageApiRequest.TO, "[1,2,3]")
                .add(SendMessageApiRequest.TYPE, MessageType.PRIVATE.toString())
                .get();

        stubZulipResponse(POST, "/messages", params, "sendMessage.json");

        long messageId = zulip.messages().sendPrivateMessage("test private message", 1, 2, 3)
                .withLocalId("foo")
                .withQueueId("bar")
                .execute();

        assertEquals(42, messageId);
    }

    @Test
    public void sendPrivateMessageWithEmailAddresses() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SendMessageApiRequest.CONTENT, "test private message")
                .add(SendMessageApiRequest.LOCAL_ID, "foo")
                .add(SendMessageApiRequest.QUEUE_ID, "bar")
                .add(SendMessageApiRequest.TO, "[\"foo@bar.com\",\"cheese@wine.net\"]")
                .add(SendMessageApiRequest.TYPE, MessageType.PRIVATE.toString())
                .get();

        stubZulipResponse(POST, "/messages", params, "sendMessage.json");

        long messageId = zulip.messages().sendPrivateMessage("test private message", "foo@bar.com", "cheese@wine.net")
                .withLocalId("foo")
                .withQueueId("bar")
                .execute();

        assertEquals(42, messageId);
    }

    @Test
    public void sendStreamMessageWithStreamId() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SendMessageApiRequest.CONTENT, "test stream message")
                .add(SendMessageApiRequest.LOCAL_ID, "foo")
                .add(SendMessageApiRequest.QUEUE_ID, "bar")
                .add(SendMessageApiRequest.TO, "1")
                .add(SendMessageApiRequest.TOPIC, "test topic")
                .add(SendMessageApiRequest.TYPE, MessageType.STREAM.toString())
                .get();

        stubZulipResponse(POST, "/messages", params, "sendMessage.json");

        long messageId = zulip.messages().sendStreamMessage("test stream message", 1, "test topic")
                .withLocalId("foo")
                .withQueueId("bar")
                .execute();

        assertEquals(42, messageId);
    }

    @Test
    public void sendStreamMessageWithStreamName() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SendMessageApiRequest.CONTENT, "test stream message")
                .add(SendMessageApiRequest.LOCAL_ID, "foo")
                .add(SendMessageApiRequest.QUEUE_ID, "bar")
                .add(SendMessageApiRequest.TO, "test stream")
                .add(SendMessageApiRequest.TOPIC, "test topic")
                .add(SendMessageApiRequest.TYPE, MessageType.STREAM.toString())
                .get();

        stubZulipResponse(POST, "/messages", params, "sendMessage.json");

        long messageId = zulip.messages().sendStreamMessage("test stream message", "test stream", "test topic")
                .withLocalId("foo")
                .withQueueId("bar")
                .execute();

        assertEquals(42, messageId);
    }

    @Test
    public void updateMessageFlags() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateMessageFlagsApiRequest.FLAG, MessageFlag.READ.toString())
                .add(UpdateMessageFlagsApiRequest.MESSAGES, "[1,2,3]")
                .add(UpdateMessageFlagsApiRequest.OP, Operation.ADD.toString())
                .get();

        stubZulipResponse(POST, "/messages/flags", params, "updateMessageFlags.json");

        List<Long> updatedIds = zulip.messages().updateMessageFlags(MessageFlag.READ, Operation.ADD, 1, 2, 3)
                .execute();

        assertEquals(3, updatedIds.size());
        assertArrayEquals(new Long[] { 4L, 18L, 15L }, updatedIds.toArray(new Long[0]));
    }

    @Test
    public void updateMessageFlagsForNarrow() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateMessageFlagsForNarrowApiRequest.ANCHOR, Anchor.NEWEST.toString())
                .add(UpdateMessageFlagsForNarrowApiRequest.INCLUDE_ANCHOR, "true")
                .add(UpdateMessageFlagsForNarrowApiRequest.NARROW,
                        "[{\"operator\":\"foo\",\"operand\":\"bar\",\"negated\":false}]")
                .add(UpdateMessageFlagsForNarrowApiRequest.NUM_BEFORE, "1")
                .add(UpdateMessageFlagsForNarrowApiRequest.NUM_AFTER, "2")
                .add(UpdateMessageFlagsForNarrowApiRequest.FLAG, MessageFlag.READ.toString())
                .add(UpdateMessageFlagsForNarrowApiRequest.OP, Operation.ADD.toString())
                .get();

        stubZulipResponse(POST, "/messages/flags/narrow", params, "updateMessageFlagsForNarrow.json");

        MessageFlagsUpdateResult result = zulip.messages()
                .updateMessageFlagsForNarrow(Anchor.NEWEST, 1, 2, Operation.ADD, MessageFlag.READ, Narrow.of("foo", "bar"))
                .withIncludeAnchor(true)
                .execute();

        assertEquals(1, result.getFirstProcessedId());
        assertEquals(2, result.getLastProcessedId());
        assertEquals(3, result.getProcessedCount());
        assertEquals(4, result.getUpdatedCount());
        assertTrue(result.isFoundNewest());
        assertTrue(result.isFoundOldest());
    }

    @Test
    public void updateMessageFlagsForNarrowWithIntAnchor() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateMessageFlagsForNarrowApiRequest.ANCHOR, "1")
                .add(UpdateMessageFlagsForNarrowApiRequest.INCLUDE_ANCHOR, "true")
                .add(UpdateMessageFlagsForNarrowApiRequest.NARROW,
                        "[{\"operator\":\"foo\",\"operand\":\"bar\",\"negated\":false}]")
                .add(UpdateMessageFlagsForNarrowApiRequest.NUM_BEFORE, "1")
                .add(UpdateMessageFlagsForNarrowApiRequest.NUM_AFTER, "2")
                .add(UpdateMessageFlagsForNarrowApiRequest.FLAG, MessageFlag.READ.toString())
                .add(UpdateMessageFlagsForNarrowApiRequest.OP, Operation.ADD.toString())
                .get();

        stubZulipResponse(POST, "/messages/flags/narrow", params, "updateMessageFlagsForNarrow.json");

        MessageFlagsUpdateResult result = zulip.messages()
                .updateMessageFlagsForNarrow(1, 1, 2, Operation.ADD, MessageFlag.READ, Narrow.of("foo", "bar"))
                .withIncludeAnchor(true)
                .execute();

        assertEquals(1, result.getFirstProcessedId());
        assertEquals(2, result.getLastProcessedId());
        assertEquals(3, result.getProcessedCount());
        assertEquals(4, result.getUpdatedCount());
        assertTrue(result.isFoundNewest());
        assertTrue(result.isFoundOldest());
    }

    @Test
    public void getMessageReadReceipts() throws Exception {
        stubZulipResponse(GET, "/messages/1/read_receipts", Collections.emptyMap(), "getMessageReadReceipts.json");

        List<Long> messageIds = zulip.messages().getMessageReadReceipts(1).execute();
        assertEquals(List.of(1L, 2L, 3L), messageIds);
    }
}
