package com.github.jamesnetherton.zulip.client.api.event;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.equalTo;
import static com.github.tomakehurst.wiremock.client.WireMock.get;
import static com.github.tomakehurst.wiremock.client.WireMock.urlPathEqualTo;
import static org.awaitility.Awaitility.await;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.event.request.GetEventsApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.request.RegisterEventQueueApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlag;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import com.github.jamesnetherton.zulip.client.api.message.PropagateMode;
import com.github.jamesnetherton.zulip.client.api.message.ReactionType;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class ZulipEventApiTest extends ZulipApiTestBase {

    private static final String QUEUE_ID = "fb67bf8a-c031-47cc-84cf-ed80accacda8";
    private static final Duration EVENT_DELIVERY_TIMEOUT = Duration.ofSeconds(10);

    @BeforeEach
    public void beforeEach() throws Exception {
        server.resetAll();

        stubZulipResponse(GET, "/events", QueryParams.create()
                .add(GetEventsApiRequest.QUEUE_ID, QUEUE_ID)
                .add(GetEventsApiRequest.LAST_EVENT_ID, "-1")
                .get(), "getEvents.json");

        server.stubFor(get(urlPathEqualTo("/" + ZulipUrlUtils.API_BASE_PATH + "/events"))
                .withQueryParam(GetEventsApiRequest.LAST_EVENT_ID, equalTo("10"))
                .willReturn(aResponse()
                        .withHeader("Content-Type", "application/json")
                        .withFixedDelay(250)
                        .withBody(getStubbedResponse("getEventsEmpty.json"))));

        stubZulipResponse(DELETE, "/events", QueryParams.create()
                .add(GetEventsApiRequest.QUEUE_ID, QUEUE_ID)
                .get());
    }

    @Test
    public void captureEvents() throws Exception {
        stubRegisterEventQueue(List.of("message", "update_message", "delete_message", "reaction", "update_message_flags",
                "typing", "typing_edit_message", "submessage", "subscription"), false, null);

        List<MessageEvent> messageEvents = new CopyOnWriteArrayList<>();
        List<UpdateMessageEvent> updateMessageEvents = new CopyOnWriteArrayList<>();
        List<DeleteMessageEvent> deleteMessageEvents = new CopyOnWriteArrayList<>();
        List<ReactionEvent> reactionEvents = new CopyOnWriteArrayList<>();
        List<UpdateMessageFlagsEvent> updateMessageFlagsEvents = new CopyOnWriteArrayList<>();
        List<TypingEvent> typingEvents = new CopyOnWriteArrayList<>();
        List<TypingEditMessageEvent> typingEditMessageEvents = new CopyOnWriteArrayList<>();
        List<SubmessageEvent> submessageEvents = new CopyOnWriteArrayList<>();
        List<Event> subscriptionEvents = new CopyOnWriteArrayList<>();

        EventPoller eventPoller = zulip.events().captureEvents()
                .onMessage(messageEvents::add)
                .onUpdateMessage(updateMessageEvents::add)
                .onDeleteMessage(deleteMessageEvents::add)
                .onReaction(reactionEvents::add)
                .onUpdateMessageFlags(updateMessageFlagsEvents::add)
                .onTyping(typingEvents::add)
                .onTypingEditMessage(typingEditMessageEvents::add)
                .onSubmessage(submessageEvents::add)
                .on(EventType.SUBSCRIPTION, subscriptionEvents::add)
                .build();

        try {
            eventPoller.start();

            await().atMost(EVENT_DELIVERY_TIMEOUT).until(() -> !messageEvents.isEmpty()
                    && !updateMessageEvents.isEmpty()
                    && !deleteMessageEvents.isEmpty()
                    && !reactionEvents.isEmpty()
                    && !updateMessageFlagsEvents.isEmpty()
                    && !typingEvents.isEmpty()
                    && !typingEditMessageEvents.isEmpty()
                    && !submessageEvents.isEmpty()
                    && !subscriptionEvents.isEmpty());
        } finally {
            eventPoller.stop();
        }

        MessageEvent messageEvent = messageEvents.get(0);
        assertEquals(0, messageEvent.getId());
        assertEquals("message", messageEvent.getType());
        assertEquals(List.of(MessageFlag.READ, MessageFlag.MENTIONED), messageEvent.getFlags());
        assertEquals("Test content", messageEvent.getMessage().getContent());
        assertEquals("Denmark", messageEvent.getMessage().getStream());

        UpdateMessageEvent updateMessageEvent = updateMessageEvents.get(0);
        assertEquals(10, updateMessageEvent.getUserId());
        assertFalse(updateMessageEvent.isRenderingOnly());
        assertEquals(31, updateMessageEvent.getMessageId());
        assertEquals(List.of(31L, 32L), updateMessageEvent.getMessageIds());
        assertEquals(List.of(MessageFlag.READ), updateMessageEvent.getFlags());
        assertEquals(Instant.ofEpochSecond(1594825451), updateMessageEvent.getEditTimestamp());
        assertEquals(1, updateMessageEvent.getStreamId());
        assertEquals(2, updateMessageEvent.getNewStreamId());
        assertEquals(PropagateMode.CHANGE_LATER, updateMessageEvent.getPropagateMode());
        assertEquals("test", updateMessageEvent.getOrigSubject());
        assertEquals("new topic", updateMessageEvent.getSubject());
        assertEquals("Old content", updateMessageEvent.getOrigContent());
        assertEquals("<p>Old content</p>", updateMessageEvent.getOrigRenderedContent());
        assertEquals("New content", updateMessageEvent.getContent());
        assertEquals("<p>New content</p>", updateMessageEvent.getRenderedContent());
        assertFalse(updateMessageEvent.isMeMessage());

        DeleteMessageEvent deleteMessageEvent = deleteMessageEvents.get(0);
        assertEquals(List.of(31L, 32L), deleteMessageEvent.getMessageIds());
        assertEquals(MessageType.STREAM, deleteMessageEvent.getMessageType());
        assertEquals(1, deleteMessageEvent.getStreamId());
        assertEquals("", deleteMessageEvent.getTopic());

        assertEquals(1, reactionEvents.size());
        ReactionEvent reactionEvent = reactionEvents.get(0);
        assertEquals(EventOperation.ADD, reactionEvent.getOperation());
        assertEquals(10, reactionEvent.getUserId());
        assertEquals(32, reactionEvent.getMessageId());
        assertEquals("tada", reactionEvent.getEmojiName());
        assertEquals("1f389", reactionEvent.getEmojiCode());
        assertEquals(ReactionType.UNICODE, reactionEvent.getReactionType());

        UpdateMessageFlagsEvent updateMessageFlagsEvent = updateMessageFlagsEvents.get(0);
        assertEquals(EventOperation.ADD, updateMessageFlagsEvent.getOperation());
        assertEquals(MessageFlag.STARRED, updateMessageFlagsEvent.getFlag());
        assertEquals(List.of(63L, 64L), updateMessageFlagsEvent.getMessageIds());
        assertFalse(updateMessageFlagsEvent.isAll());

        TypingEvent typingEvent = typingEvents.get(0);
        assertEquals(EventOperation.START, typingEvent.getOperation());
        assertEquals(MessageType.DIRECT, typingEvent.getMessageType());
        assertEquals(10, typingEvent.getSender().getUserId());
        assertEquals("user10@zulip.testserver", typingEvent.getSender().getEmail());
        assertEquals(2, typingEvent.getRecipients().size());
        assertEquals(8, typingEvent.getRecipients().get(0).getUserId());
        assertNull(typingEvent.getStreamId());
        assertNull(typingEvent.getTopic());

        TypingEditMessageEvent typingEditMessageEvent = typingEditMessageEvents.get(0);
        assertEquals(EventOperation.STOP, typingEditMessageEvent.getOperation());
        assertEquals(10, typingEditMessageEvent.getSenderId());
        assertEquals(31, typingEditMessageEvent.getMessageId());
        assertEquals(MessageType.CHANNEL, typingEditMessageEvent.getRecipient().getType());
        assertEquals(1, typingEditMessageEvent.getRecipient().getChannelId());
        assertEquals("test", typingEditMessageEvent.getRecipient().getTopic());
        assertTrue(typingEditMessageEvent.getRecipient().getUserIds().isEmpty());

        SubmessageEvent submessageEvent = submessageEvents.get(0);
        assertEquals("widget", submessageEvent.getMsgType());
        assertEquals("{\"type\":\"vote\"}", submessageEvent.getContent());
        assertEquals(31, submessageEvent.getMessageId());
        assertEquals(10, submessageEvent.getSenderId());
        assertEquals(42, submessageEvent.getSubmessageId());

        Event subscriptionEvent = subscriptionEvents.get(0);
        assertEquals(9, subscriptionEvent.getId());
        assertEquals("subscription", subscriptionEvent.getType());
        Map<String, Object> properties = subscriptionEvent.getProperties();
        assertEquals("peer_add", properties.get("op"));
        assertEquals(List.of(1), properties.get("stream_ids"));
        assertEquals(List.of(10), properties.get("user_ids"));
    }

    @Test
    public void captureEventsWithOptions() throws Exception {
        stubRegisterEventQueue(List.of("reaction"), true, 3600, Narrow.of("channel", "Denmark"));

        List<Event> rawEvents = new CopyOnWriteArrayList<>();
        List<ReactionEvent> reactionEvents = new CopyOnWriteArrayList<>();

        EventPoller eventPoller = zulip.events().captureEvents()
                .onReaction(reactionEvents::add)
                .on("reaction", rawEvents::add)
                .withNarrows(Narrow.of("channel", "Denmark"))
                .withAllPublicStreams(true)
                .withIdleQueueTimeout(3600)
                .build();

        try {
            eventPoller.start();
            await().atMost(EVENT_DELIVERY_TIMEOUT).until(() -> rawEvents.size() == 2);
        } finally {
            eventPoller.stop();
        }

        // The event with an unknown op cannot be mapped to ReactionEvent so is only received by the raw listener
        assertEquals(1, reactionEvents.size());
        assertInstanceOf(ReactionEvent.class, rawEvents.stream().filter(event -> event.getId() == 3).findFirst().get());
        Event invalidEvent = rawEvents.stream().filter(event -> event.getId() == 10).findFirst().get();
        assertFalse(invalidEvent instanceof ReactionEvent);
        assertEquals("invalid", invalidEvent.getProperties().get("op"));
    }

    @Test
    public void captureMessageEvents() throws Exception {
        stubRegisterEventQueue(List.of("message"), false, null);

        List<Message> messages = new CopyOnWriteArrayList<>();
        EventPoller eventPoller = zulip.events().captureMessageEvents(new MessageEventListener() {
            @Override
            public void onEvent(Message event) {
                messages.add(event);
            }
        });

        try {
            eventPoller.start();
            await().atMost(EVENT_DELIVERY_TIMEOUT).until(() -> !messages.isEmpty());
        } finally {
            eventPoller.stop();
        }

        assertEquals(1, messages.size());
        assertEquals("Test content", messages.get(0).getContent());
    }

    @Test
    public void captureEventsWithoutListeners() {
        assertThrows(IllegalStateException.class, () -> zulip.events().captureEvents().build());
    }

    @Test
    public void eventTypeClassLookup() {
        assertEquals(UpdateMessageEvent.class, EventType.getEventClass("update_message"));
        assertEquals(Event.class, EventType.getEventClass("subscription"));
        assertEquals(Event.class, EventType.getEventClass(null));
        assertEquals(UpdateMessageFlagsEvent.class, EventType.UPDATE_MESSAGE_FLAGS.getEventClass());
        assertEquals(Event.class, EventType.SUBSCRIPTION.getEventClass());
        assertEquals("realm_user_settings_defaults", EventType.REALM_USER_SETTINGS_DEFAULTS.toString());
    }

    private void stubRegisterEventQueue(List<String> eventTypes, boolean allPublicStreams, Integer idleQueueTimeout,
            Narrow... narrows) throws Exception {
        QueryParams params = QueryParams.create()
                .addAsRawJsonString(RegisterEventQueueApiRequest.EVENT_TYPES, eventTypes)
                .addAsRawJsonString(RegisterEventQueueApiRequest.FETCH_EVENT_TYPES, List.of())
                .add(RegisterEventQueueApiRequest.CLIENT_CAPABILITIES,
                        "{\"notification_settings_null\":false,\"bulk_message_deletion\":true,\"empty_topic_name\":true}")
                .add(RegisterEventQueueApiRequest.ALL_PUBLIC_STREAMS, String.valueOf(allPublicStreams));

        if (idleQueueTimeout != null) {
            params.add(RegisterEventQueueApiRequest.IDLE_QUEUE_TIMEOUT, String.valueOf(idleQueueTimeout));
        }

        if (narrows.length > 0) {
            String[][] stringNarrows = new String[narrows.length][2];
            for (int i = 0; i < narrows.length; i++) {
                stringNarrows[i] = new String[] { narrows[i].getOperator(), narrows[i].getOperand().toString() };
            }
            params.addAsRawJsonString(RegisterEventQueueApiRequest.NARROW, stringNarrows);
        }

        stubZulipResponse(POST, "/register", params.get(), "registerEventQueue.json");
    }
}
