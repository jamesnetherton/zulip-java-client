package com.github.jamesnetherton.zulip.client.api.navigationview;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip navigation view
 */
public class NavigationView {
    @JsonProperty
    private String fragment;

    @JsonProperty("is_pinned")
    private boolean pinned;

    @JsonProperty
    private String name;

    public String getFragment() {
        return fragment;
    }

    public boolean isPinned() {
        return pinned;
    }

    public String getName() {
        return name;
    }
}
