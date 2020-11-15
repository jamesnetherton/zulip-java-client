package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines Zulip profile data.
 */
public class ProfileData {

    @JsonProperty
    private String renderedValue;

    @JsonProperty
    private String value;

    public String getRenderedValue() {
        return renderedValue;
    }

    public String getValue() {
        return value;
    }
}
