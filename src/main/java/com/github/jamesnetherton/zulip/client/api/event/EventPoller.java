package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.event.request.DeleteEventQueueApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.request.GetMessageEventsApiRequest;
import com.github.jamesnetherton.zulip.client.api.event.request.RegisterEventQueueApiRequest;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Comparator;
import java.util.List;
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

    private final MessageEventListener listener;
    private final ZulipHttpClient client;
    private final Narrow[] narrows;
    private volatile EventQueue queue;
    private volatile ExecutorService executor;
    private volatile Status status = Status.STOPPED;

    /**
     * Constructs a {@link EventPoller}.
     *
     * @param client   The Zulip HTTP client
     * @param listener The {@link MessageEventListener} to be invoked on each message event
     * @param narrows  optional {@link Narrow} expressions to filter which message events are captured. E.g messages from a
     *                 specific stream
     */
    public EventPoller(ZulipHttpClient client, MessageEventListener listener, Narrow[] narrows) {
        this.client = client;
        this.listener = listener;
        this.narrows = narrows;
    }

    /**
     * Starts event message polling.
     *
     * @throws ZulipClientException if the event polling request was not successful
     */
    public void start() throws ZulipClientException {
        if (status.equals(Status.STOPPED)) {
            LOG.info("EventPoller starting");
            status = Status.STARTING;

            RegisterEventQueueApiRequest createQueue = new RegisterEventQueueApiRequest(this.client, narrows);
            GetMessageEventsApiRequest getEvents = new GetMessageEventsApiRequest(this.client);

            queue = createQueue.execute();
            executor = Executors.newSingleThreadExecutor();

            executor.submit(new Runnable() {
                private long lastEventId = queue.getLastEventId();

                @Override
                public void run() {
                    while (status.equals(Status.STARTING) || status.equals(Status.STARTED)) {
                        try {
                            getEvents.withQueueId(queue.getQueueId());
                            getEvents.withLastEventId(lastEventId);

                            List<MessageEvent> messageEvents = getEvents.execute();
                            for (MessageEvent event : messageEvents) {
                                listener.onEvent(event.getMessage());
                            }

                            lastEventId = messageEvents.stream().max(Comparator.comparing(o -> Long.valueOf(o.getId()))).get()
                                    .getId();

                            Thread.sleep(5000);
                        } catch (ZulipClientException e) {
                            LOG.warning("Error processing events - " + e.getMessage());
                            if (e.getCode().equals("BAD_EVENT_QUEUE_ID")) {
                                // Queue may have been garbage collected so recreate it
                                try {
                                    queue = createQueue.execute();
                                } catch (ZulipClientException zulipClientException) {
                                    LOG.warning("Error recreating message queue - " + e.getMessage());
                                }
                            }
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    }
                }
            });

            LOG.info("EventPoller started");
            status = Status.STARTED;
        }
    }

    /**
     * Stops message polling.
     */
    public void stop() {
        if (status.equals(Status.STARTING) || status.equals(Status.STARTED)) {
            try {
                LOG.info("EventPoller stopping");
                status = Status.STOPPING;
                executor.shutdown();
                DeleteEventQueueApiRequest deleteQueue = new DeleteEventQueueApiRequest(this.client, queue.getQueueId());
                deleteQueue.execute();
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
