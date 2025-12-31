package com.github.jamesnetherton.zulip.client.api.integration.event;

import static org.awaitility.Awaitility.await;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.event.EventPoller;
import com.github.jamesnetherton.zulip.client.api.event.MessageEventListener;
import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.MessageService;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import org.junit.jupiter.api.Test;

public class ZulipEventIT extends ZulipIntegrationTestBase {

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
        List<String> messages = Collections.synchronizedList(new ArrayList<>());

        String streamA = UUID.randomUUID().toString().split("-")[0];
        String streamB = UUID.randomUUID().toString().split("-")[0];

        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamA, streamA),
                StreamSubscriptionRequest.of(streamB, streamB)).execute();

        await().atMost(30, TimeUnit.SECONDS)
                .ignoreExceptions()
                .until(() -> {
                    zulip.streams().getStreamId(streamA).execute();
                    zulip.streams().getStreamId(streamB).execute();
                    return true;
                });

        EventPoller eventPoller = zulip.events().captureMessageEvents(new MessageEventListener() {
            @Override
            public void onEvent(Message event) {
                messages.add(event.getContent());
            }
        }, Narrow.of("stream", streamA), Narrow.of("is", "stream"));

        try {
            eventPoller.start();

            MessageService messageService = zulip.messages();
            for (int i = 0; i < 10; i++) {
                String streamName = i % 2 == 0 ? streamA : streamB;
                int finalI = i;
                await().atMost(10, TimeUnit.SECONDS)
                        .pollInterval(1, TimeUnit.SECONDS)
                        .ignoreExceptions()
                        .until(() -> {
                            messageService
                                    .sendStreamMessage("Stream " + streamName + " Content " + finalI, streamName, "testtopic")
                                    .execute();
                            return true;
                        });
            }

            await().atMost(30, TimeUnit.SECONDS).until(() -> messages.size() == 5);

            int count = 0;
            for (int i = 0; i < 5; i++) {
                int finalCount = count;
                assertTrue(
                        messages.stream().anyMatch(message -> message.equals("Stream " + streamA + " Content " + finalCount)));

                count += 2;
            }
        } finally {
            eventPoller.stop();
        }
    }

    private void assertMessageEvents(ExecutorService executorService) throws Exception {
        List<String> messages = Collections.synchronizedList(new ArrayList<>());

        String streamName = "stream" + UUID.randomUUID().toString().split("-")[0];
        StreamSubscriptionRequest subscriptionRequest = StreamSubscriptionRequest.of(streamName, streamName);
        zulip.streams().subscribe(subscriptionRequest).execute();

        await().atMost(30, TimeUnit.SECONDS).until(() -> zulip.streams().getAll()
                .execute()
                .stream()
                .anyMatch(stream -> stream.getName().equals(streamName)));

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

            MessageService messageService = zulip.messages();
            for (int i = 0; i < 3; i++) {
                messageService.sendStreamMessage("Test Content " + i, streamName, "testtopic").execute();
            }

            await().atMost(30, TimeUnit.SECONDS).until(() -> messages.size() == 3);

            for (int i = 0; i < 3; i++) {
                int finalI = i;
                assertTrue(messages.stream().anyMatch(message -> message.equals("Test Content " + finalI)));
            }
        } catch (ZulipClientException e) {
            e.printStackTrace();
            throw e;
        } finally {
            eventPoller.stop();
        }
    }
}
