package com.github.jamesnetherton.zulip.client.api.stream;

import com.github.jamesnetherton.zulip.client.api.stream.response.SubscribeStreamsApiResponse;
import java.util.List;
import java.util.Map;

/**
 * Defines a Zulip stream subscription result.
 */
public class StreamSubscriptionResult {

    private final SubscribeStreamsApiResponse delegate;

    public StreamSubscriptionResult(SubscribeStreamsApiResponse delegate) {
        this.delegate = delegate;
    }

    /**
     * Gets the streams that were subscribed to.
     *
     * @return Map of user ids and streams that they were subscribed to
     */
    public Map<String, List<String>> getSubscribed() {
        return delegate.getSubscribed();
    }

    /**
     * Gets the streams that were already subscribed to.
     *
     * @return Map of user ids and streams that they were already subscribed to
     */
    public Map<String, List<String>> getAlreadySubscribed() {
        return delegate.getAlreadySubscribed();
    }

    /**
     * Gets the streams that users were not authorized to subscribe to.
     *
     * @return Map of user ids and streams that they were not authorized to subscribe to
     */
    public List<String> getUnauthorized() {
        return delegate.getUnauthorized();
    }
}
