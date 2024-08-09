package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for deleting a topic.
 *
 * @see <a href="https://zulip.com/api/delete-topic#response">https://zulip.com/api/delete-topic#response</a>
 */
public class DeleteTopicApiResponse extends ZulipApiResponse {
    @JsonProperty
    boolean complete;

    public boolean isComplete() {
        return complete;
    }
}
