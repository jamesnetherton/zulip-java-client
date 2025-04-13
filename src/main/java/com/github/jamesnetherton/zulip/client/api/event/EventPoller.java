package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.event.request.DeleteEventQueueApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.request.GetMessageEventsApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.request.RegisterEventQueueApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Logger;

/**
 * Polls Zulip for real-time events. At present this is limited to consuming new message events.
 *
 * Note that this implementation is highly experimental and subject to change or removal.
 *
 * @see <a href="https://zulip.com/api/real-time-events">https://zulip.com/api/real-time-events</a>
 */
public class EventPoller {

    private static final Logger LOG = Logger.getLogger(EventPoller.class.getName());

    private final EventPollerConfiguration configuration;
    private volatile ExecutorService eventListenerExecutorService;
    private volatile EventQueue queue;
    private volatile ExecutorService executor;
    private volatile Status status = Status.STOPPED;

    /**
     * Constructs a {@link EventPoller}.
     *
     * @param configuration The {@link EventPollerConfiguration} instance
     *
     */
    EventPoller(EventPollerConfiguration configuration) {
        this.configuration = configuration;
    }

    /**
     * Starts event message polling.
     *
     * @throws ZulipClientException if the event polling request was not successful
     */
    public synchronized void start() throws ZulipClientException {
        if (status.equals(Status.STOPPED)) {
            LOG.info("EventPoller starting");
            status = Status.STARTING;

            CountDownLatch latch = new CountDownLatch(1);
            RegisterEventQueueApiRequest createQueue = new RegisterEventQueueApiRequest(configuration.getClient(),
                    configuration.getNarrows());
            GetMessageEventsApiRequest getEvents = new GetMessageEventsApiRequest(configuration.getClient());

            queue = createQueue.execute();
            executor = Executors.newSingleThreadExecutor();

            if (eventListenerExecutorService == null) {
                eventListenerExecutorService = Executors.newCachedThreadPool();
            }

            executor.submit(new Runnable() {
                private long lastEventId = queue.getLastEventId();

                @Override
                public void run() {
                    while (status.equals(Status.STARTING) || status.equals(Status.STARTED)) {
                        try {
                            getEvents.withQueueId(queue.getQueueId());
                            getEvents.withLastEventId(lastEventId);
                            latch.countDown();

                            List<MessageEvent> messageEvents = getEvents.execute(queue.getTimeout());
                            for (MessageEvent event : messageEvents) {
                                eventListenerExecutorService.submit(() -> {
                                    Message message = event.getMessage();
                                    if (message == null
                                            || (message.getContent() != null && message.getContent().equals("heartbeat"))) {
                                        return;
                                    }
                                    configuration.getListener().onEvent(message);
                                });
                            }

                            lastEventId = messageEvents.stream().max(Comparator.comparing(Event::getId))
                                    .get()
                                    .getId();

                            Thread.sleep(5000);
                        } catch (ZulipClientException e) {
                            LOG.fine("Error processing events - " + e.getMessage());
                            if (e.getCode() != null && e.getCode().equals("BAD_EVENT_QUEUE_ID")) {
                                // Queue may have been garbage collected so recreate it
                                try {
                                    queue = createQueue.execute();
                                } catch (ZulipClientException zulipClientException) {
                                    LOG.warning("Error recreating message queue - " + e.getMessage());
                                }
                            }

                            try {
                                Thread.sleep(5000);
                            } catch (InterruptedException ex) {
                                Thread.currentThread().interrupt();
                            }
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    }
                }
            });

            try {
                latch.await();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }

            LOG.info("EventPoller started");
            status = Status.STARTED;
        }
    }

    /**
     * Stops message polling.
     */
    public synchronized void stop() {
        if (status.equals(Status.STARTING) || status.equals(Status.STARTED)) {
            try {
                LOG.info("EventPoller stopping");
                status = Status.STOPPING;

                if (executor != null) {
                    executor.shutdown();
                }

                if (configuration.getEventListenerExecutorService() == null) {
                    eventListenerExecutorService.shutdown();
                    eventListenerExecutorService = null;
                }

                if (queue != null) {
                    DeleteEventQueueApiRequest deleteQueue = new DeleteEventQueueApiRequest(configuration.getClient(),
                            queue.getQueueId());
                    deleteQueue.execute();
                }
            } catch (ZulipClientException e) {
                LOG.warning("Error deleting event queue - " + e.getMessage());
            } finally {
                LOG.info("EventPoller stopped");
                executor = null;
                status = Status.STOPPED;
            }
        }
    }

    public boolean isStarted() {
        return status.equals(Status.STARTED);
    }

    private enum Status {
        STARTING,
        STARTED,
        STOPPING,
        STOPPED
    }
}
