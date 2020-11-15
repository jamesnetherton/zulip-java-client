package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.databind.JsonNode;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.Linkifier;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Zulip API response class for getting all linkifiers.
 *
 * @see <a href="https://zulip.com/api/get-linkifiers#response">https://zulip.com/api/get-linkifiers#response</a>
 */
public class GetLinkifiersApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<List<Linkifier>> filters = new ArrayList<>();

    public List<List<Linkifier>> getFilters() {
        return filters;
    }

    @JsonSetter
    public void setFilters(JsonNode node) {
        if (node != null) {
            List<Linkifier> linkifiers = new ArrayList<>();
            Iterator<JsonNode> elements = node.elements();
            while (elements.hasNext()) {
                JsonNode next = elements.next();
                if (next.size() == 3) {
                    Linkifier linkifier = new Linkifier(next.get(0).asText(), next.get(1).asText(), next.get(2).asLong());
                    linkifiers.add(linkifier);
                }
            }
            filters.add(linkifiers);
        }
    }
}
