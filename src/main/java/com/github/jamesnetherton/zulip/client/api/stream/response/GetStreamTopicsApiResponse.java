package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.stream.Topic;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting stream topics.
 *
 * @see <a href="https://zulip.com/api/get-stream-topics#response">https://zulip.com/api/get-stream-topics#response</a>
 */
public class GetStreamTopicsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Topic> topics = new ArrayList<>();

    public List<Topic> getTopics() {
        return topics;
    }
}
