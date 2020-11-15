package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines Zulip server external authentication settings.
 */
public class ExternalAuthenticationSettings {

    @JsonProperty
    private String displayIcon;

    @JsonProperty
    private String displayName;

    @JsonProperty
    private String loginUrl;

    @JsonProperty
    private String name;

    @JsonProperty
    private String signupUrl;

    public String getDisplayIcon() {
        return displayIcon;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getLoginUrl() {
        return loginUrl;
    }

    public String getName() {
        return name;
    }

    public String getSignupUrl() {
        return signupUrl;
    }
}
