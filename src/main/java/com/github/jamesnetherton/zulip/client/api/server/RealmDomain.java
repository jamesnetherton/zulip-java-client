package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip realm allowed email domain.
 */
public class RealmDomain {

    @JsonProperty
    private String domain;

    @JsonProperty
    private boolean allowSubdomains;

    public String getDomain() {
        return domain;
    }

    public boolean isAllowSubdomains() {
        return allowSubdomains;
    }
}
