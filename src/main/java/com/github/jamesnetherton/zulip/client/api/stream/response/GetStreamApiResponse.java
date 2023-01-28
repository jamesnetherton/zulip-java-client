package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;

/**
 * Zulip API response class for getting a stream by id.
 *
 * @see <a href="https://zulip.com/api/get-stream-by-id#response">https://zulip.com/api/get-stream-by-id#response</a>
 */
public class GetStreamApiResponse extends ZulipApiResponse {
    @JsonProperty
    private Stream stream;

    public Stream getStream() {
        return stream;
    }
}
