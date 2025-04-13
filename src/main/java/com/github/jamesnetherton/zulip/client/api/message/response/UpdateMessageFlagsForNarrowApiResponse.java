package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlagsUpdateResult;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for updating message flags with a narrow.
 *
 * @see <a href=
 *      "https://zulip.com/api/update-message-flags-for-narrow#response">https://zulip.com/api/update-message-flags-for-narrow#response</a>
 */
public class UpdateMessageFlagsForNarrowApiResponse extends ZulipApiResponse {

    @JsonProperty
    private int firstProcessedId;
    @JsonProperty
    private int lastProcessedId;
    @JsonProperty
    private int processedCount;
    @JsonProperty
    private int updatedCount;
    @JsonProperty
    private boolean foundNewest;
    @JsonProperty
    private boolean foundOldest;
    @JsonProperty
    private List<Integer> ignoredBecauseNotSubscribedChannels = new ArrayList<>();

    public int getFirstProcessedId() {
        return firstProcessedId;
    }

    public boolean isFoundNewest() {
        return foundNewest;
    }

    public boolean isFoundOldest() {
        return foundOldest;
    }

    public int getLastProcessedId() {
        return lastProcessedId;
    }

    public int getProcessedCount() {
        return processedCount;
    }

    public int getUpdatedCount() {
        return updatedCount;
    }

    public List<Integer> getIgnoredBecauseNotSubscribedChannels() {
        return ignoredBecauseNotSubscribedChannels;
    }

    public MessageFlagsUpdateResult getMessageFlagsUpdateResult() {
        return new MessageFlagsUpdateResult(this);
    }
}
