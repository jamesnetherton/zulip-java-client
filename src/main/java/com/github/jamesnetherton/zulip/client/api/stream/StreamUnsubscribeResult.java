package com.github.jamesnetherton.zulip.client.api.stream;

import com.github.jamesnetherton.zulip.client.api.stream.response.UnsubscribeStreamsApiResponse;
import java.util.List;

/**
 * Defines a Zulip stream unsubscribe result.
 */
public class StreamUnsubscribeResult {

    private final UnsubscribeStreamsApiResponse delegate;

    public StreamUnsubscribeResult(UnsubscribeStreamsApiResponse delegate) {
        this.delegate = delegate;
    }

    /**
     * Gets the stream names that the user was not unsubscribed from.
     *
     * @return List of stream names that the user was not unsubcribed from
     */
    public List<String> getNotRemoved() {
        return delegate.getNotRemoved();
    }

    /**
     * Gets the stream names that the user was unsubscribed from.
     *
     * @return List of stream names that the user was unsubcribed from
     */
    public List<String> getRemoved() {
        return delegate.getRemoved();
    }
}
