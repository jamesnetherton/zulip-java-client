package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.RealmDomain;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting realm allowed domains.
 *
 * @see <a href="https://zulip.com/api/get-realm-domains">https://zulip.com/api/get-realm-domains</a>
 */
public class GetRealmDomainsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<RealmDomain> domains = new ArrayList<>();

    public List<RealmDomain> getDomains() {
        return domains;
    }
}
