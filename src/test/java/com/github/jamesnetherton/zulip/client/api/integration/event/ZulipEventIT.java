package com.github.jamesnetherton.zulip.client.api.integration.event;

import static org.awaitility.Awaitility.await;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.event.EventPoller;
import com.github.jamesnetherton.zulip.client.api.event.MessageEventListener;
import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscription;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Test;

public class ZulipEventIT extends ZulipIntegrationTestBase {

    private static final String TOPIC = "testtopic";
    private static final Duration STREAM_READY_TIMEOUT = Duration.ofSeconds(30);
    private static final Duration MESSAGE_SEND_TIMEOUT = Duration.ofSeconds(30);
    private static final Duration EVENT_DELIVERY_TIMEOUT = Duration.ofSeconds(60);

    @Test
    public void messageEvents() throws Exception {
        assertMessageEvents(null);
    }

    @Test
    public void messageEventsWithCustomExecutor() throws Exception {
        ExecutorService executorService = Executors.newFixedThreadPool(2);
        try {
            assertMessageEvents(executorService);
        } finally {
            assertFalse(executorService.isShutdown());
            executorService.shutdown();
        }
    }

    @Test
    public void messageEventsWithNarrow() throws Exception {
        List<String> messages = new CopyOnWriteArrayList<>();

        String streamA = randomStreamName();
        String streamB = randomStreamName();

        subscribeToStreams(streamA, streamB);

        EventPoller eventPoller = zulip.events().captureMessageEvents(new MessageEventListener() {
            @Override
            public void onEvent(Message event) {
                messages.add(event.getContent());
            }
        }, Narrow.of("stream", streamA), Narrow.of("is", "stream"));

        try {
            eventPoller.start();

            List<String> expected = new ArrayList<>();
            List<String> notExpected = new ArrayList<>();

            for (int i = 0; i < 5; i++) {
                notExpected.add(sendStreamMessage(streamB, "Stream " + streamB + " Content " + i));
                expected.add(sendStreamMessage(streamA, "Stream " + streamA + " Content " + i));
            }

            await().atMost(EVENT_DELIVERY_TIMEOUT)
                    .until(() -> messages.containsAll(expected));

            assertTrue(Collections.disjoint(messages, notExpected),
                    "Messages not matching the event narrow were captured: " + messages);
        } finally {
            eventPoller.stop();
        }
    }

    private void assertMessageEvents(ExecutorService executorService) throws Exception {
        List<String> messages = new CopyOnWriteArrayList<>();

        String streamName = randomStreamName();
        subscribeToStreams(streamName);

        MessageEventListener listener = new MessageEventListener() {
            @Override
            public void onEvent(Message event) {
                messages.add(event.getContent());
            }
        };

        EventPoller eventPoller;
        if (executorService != null) {
            eventPoller = zulip.events().captureMessageEvents(listener, executorService);
        } else {
            eventPoller = zulip.events().captureMessageEvents(listener);
        }

        try {
            eventPoller.start();

            List<String> expected = new ArrayList<>();
            for (int i = 0; i < 3; i++) {
                expected.add(sendStreamMessage(streamName, "Test Content " + i));
            }

            await().atMost(EVENT_DELIVERY_TIMEOUT)
                    .until(() -> messages.containsAll(expected));
        } finally {
            eventPoller.stop();
        }
    }

    private static String randomStreamName() {
        return "stream" + UUID.randomUUID().toString().split("-")[0];
    }

    private void subscribeToStreams(String... streamNames) throws ZulipClientException {
        StreamSubscriptionRequest[] subscriptionRequests = Arrays.stream(streamNames)
                .map(streamName -> StreamSubscriptionRequest.of(streamName, streamName))
                .toArray(StreamSubscriptionRequest[]::new);

        zulip.streams().subscribe(subscriptionRequests).execute();

        List<String> expectedStreams = Arrays.asList(streamNames);
        await().atMost(STREAM_READY_TIMEOUT)
                .ignoreExceptions()
                .until(() -> {
                    Set<String> subscribed = zulip.streams()
                            .getSubscribedStreams()
                            .execute()
                            .stream()
                            .map(StreamSubscription::getName)
                            .collect(Collectors.toSet());
                    return subscribed.containsAll(expectedStreams);
                });
    }

    private String sendStreamMessage(String streamName, String content) {
        await().atMost(MESSAGE_SEND_TIMEOUT)
                .pollInterval(Duration.ofSeconds(1))
                .ignoreExceptions()
                .until(() -> {
                    zulip.messages().sendStreamMessage(content, streamName, TOPIC).execute();
                    return true;
                });
        return content;
    }
}
