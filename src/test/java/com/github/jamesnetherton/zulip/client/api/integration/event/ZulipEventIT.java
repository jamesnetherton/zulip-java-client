package com.github.jamesnetherton.zulip.client.api.integration.event;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.event.EventPoller;
import com.github.jamesnetherton.zulip.client.api.event.MessageEventListener;
import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.MessageService;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;
import com.github.jamesnetherton.zulip.client.api.stream.StreamService;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
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
        CountDownLatch latch = new CountDownLatch(5);
        List<String> messages = new ArrayList<>();

        String streamA = UUID.randomUUID().toString().split("-")[0];
        String streamB = UUID.randomUUID().toString().split("-")[0];

        zulip.streams().subscribe(
                StreamSubscriptionRequest.of(streamA, streamA),
                StreamSubscriptionRequest.of(streamB, streamB)).execute();

        for (int i = 0; i < 10; i++) {
            List<Stream> streams = zulip.streams().getAll().execute();
            List<Stream> matches = streams.stream()
                    .filter(stream -> stream.getName().equals(streamA) || stream.getName().equals(streamB))
                    .collect(Collectors.toList());
            if (matches.size() == 2) {
                break;
            }
            Thread.sleep(500);
        }

        EventPoller eventPoller = zulip.events().captureMessageEvents(new MessageEventListener() {
            @Override
            public void onEvent(Message event) {
                messages.add(event.getContent());
                latch.countDown();
            }
        }, Narrow.of("stream", streamA), Narrow.of("is", "stream"));

        try {
            eventPoller.start();

            MessageService messageService = zulip.messages();
            for (int i = 0; i < 10; i++) {
                String streamName = i % 2 == 0 ? streamA : streamB;
                messageService.sendStreamMessage("Stream " + streamName + " Content " + i, streamName, "testtopic").execute();
            }

            assertTrue(latch.await(30, TimeUnit.SECONDS));

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
        CountDownLatch latch = new CountDownLatch(3);
        List<String> messages = new ArrayList<>();

        String streamName = "stream" + UUID.randomUUID().toString().split("-")[0];
        StreamSubscriptionRequest subscriptionRequest = StreamSubscriptionRequest.of(streamName, streamName);
        StreamService streamService = zulip.streams();
        streamService.subscribe(subscriptionRequest).execute();

        for (int i = 0; i < 50; i++) {
            boolean match = streamService.getAll()
                    .execute()
                    .stream()
                    .anyMatch(stream -> stream.getName().equals(streamName));
            if (match) {
                break;
            }
            Thread.sleep(500);
        }

        MessageEventListener listener = new MessageEventListener() {
            @Override
            public void onEvent(Message event) {
                messages.add(event.getContent());
                latch.countDown();
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

            assertTrue(latch.await(30, TimeUnit.SECONDS));

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
