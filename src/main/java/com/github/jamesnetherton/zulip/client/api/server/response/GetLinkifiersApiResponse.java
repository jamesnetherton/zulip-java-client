package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.Linkifier;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all linkifiers.
 *
 * @see <a href="https://zulip.com/api/get-linkifiers#response">https://zulip.com/api/get-linkifiers#response</a>
 */
public class GetLinkifiersApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Linkifier> linkifiers = new ArrayList<>();

    public List<Linkifier> getLinkifiers() {
        return linkifiers;
    }
}
