package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;

public class DataExportConsent {
    @JsonProperty
    private boolean consented;

    @JsonProperty
    private int userId;

    public boolean isConsented() {
        return consented;
    }

    public int getUserId() {
        return userId;
    }
}
