package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.List;

/**
 * Zulip API response class for searching and getting message receipts.
 *
 * @see <a href="https://zulip.com/api/get-read-receipts#response">https://zulip.com/api/get-read-receipts#response</a>
 */
public class GetMessageReadReceiptsApiResponse extends ZulipApiResponse {
    @JsonProperty
    private List<Long> userIds;

    public List<Long> getUserIds() {
        return userIds;
    }
}
