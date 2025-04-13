package com.github.jamesnetherton.zulip.client.api.message;

import com.github.jamesnetherton.zulip.client.api.message.response.UpdateMessageFlagsForNarrowApiResponse;
import java.util.List;

/**
 * Defines the result of a Zulip add or remove personal message flags request.
 */
public class MessageFlagsUpdateResult {

    private UpdateMessageFlagsForNarrowApiResponse delegate;

    public MessageFlagsUpdateResult(UpdateMessageFlagsForNarrowApiResponse delegate) {
        this.delegate = delegate;
    }

    public int getFirstProcessedId() {
        return delegate.getFirstProcessedId();
    }

    public boolean isFoundNewest() {
        return delegate.isFoundNewest();
    }

    public boolean isFoundOldest() {
        return delegate.isFoundOldest();
    }

    public int getLastProcessedId() {
        return delegate.getLastProcessedId();
    }

    public int getProcessedCount() {
        return delegate.getProcessedCount();
    }

    public int getUpdatedCount() {
        return delegate.getUpdatedCount();
    }

    public List<Integer> getIgnoredBecauseNotSubscribedChannels() {
        return delegate.getIgnoredBecauseNotSubscribedChannels();
    }
}
