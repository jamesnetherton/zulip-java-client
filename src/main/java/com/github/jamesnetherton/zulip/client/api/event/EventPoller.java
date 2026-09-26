package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.event.request.DeleteEventQueueApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.request.GetEventsApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.request.RegisterEventQueueApiRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Logger;

/**
 * Polls Zulip for real-time events and dispatches them to the configured {@link EventListener} instances.
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
                    configuration.getNarrows())
                            .withEventTypes(configuration.getListeners().keySet())
                            .withAllPublicStreams(configuration.isAllPublicStreams());
            if (configuration.getIdleQueueTimeout() != null) {
                createQueue.withIdleQueueTimeout(configuration.getIdleQueueTimeout());
            }
            GetEventsApiRequest getEvents = new GetEventsApiRequest(configuration.getClient());

            try {
                queue = createQueue.execute();
            } catch (ZulipClientException e) {
                status = Status.STOPPED;
                throw e;
            }

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

                            List<Event> events = getEvents.execute(queue.getTimeout());
                            for (Event event : events) {
                                List<EventListener<Event>> listeners = configuration.getListeners().get(event.getType());
                                if (listeners != null) {
                                    for (EventListener<Event> listener : listeners) {
                                        eventListenerExecutorService.submit(() -> listener.onEvent(event));
                                    }
                                }
                            }

                            events.stream()
                                    .max(Comparator.comparing(Event::getId))
                                    .ifPresent(event -> lastEventId = event.getId());
                        } catch (ZulipClientException e) {
                            LOG.fine("Error processing events - " + e.getMessage());
                            if (e.getCode() != null && e.getCode().equals("BAD_EVENT_QUEUE_ID")) {
                                // Queue may have been garbage collected so recreate it
                                try {
                                    queue = createQueue.execute();
                                    lastEventId = queue.getLastEventId();
                                } catch (ZulipClientException zulipClientException) {
                                    LOG.warning("Error recreating message queue - " + e.getMessage());
                                }
                            }

                            try {
                                Thread.sleep(5000);
                            } catch (InterruptedException ex) {
                                Thread.currentThread().interrupt();
                            }
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

                if (configuration.getEventListenerExecutorService() == null && eventListenerExecutorService != null) {
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
