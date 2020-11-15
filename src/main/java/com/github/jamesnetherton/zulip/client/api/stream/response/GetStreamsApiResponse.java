package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all streams.
 *
 * @see <a href="https://zulip.com/api/get-streams#response">https://zulip.com/api/get-streams#response</a>
 */
public class GetStreamsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Stream> streams = new ArrayList<>();

    public List<Stream> getStreams() {
        return streams;
    }
}
