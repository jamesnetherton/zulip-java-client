package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting a stream id.
 *
 * @see <a href="https://zulip.com/api/get-stream-id#response">https://zulip.com/api/get-stream-id#response</a>
 */
public class GetStreamIdApiResponse extends ZulipApiResponse {

    @JsonProperty
    private long streamId;

    public long getStreamId() {
        return streamId;
    }
}
