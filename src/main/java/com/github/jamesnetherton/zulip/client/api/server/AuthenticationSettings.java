package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines Zulip server authentication settings.
 */
public class AuthenticationSettings {

    @JsonProperty
    private boolean azuread;

    @JsonProperty
    private boolean dev;

    @JsonProperty
    private boolean email;

    @JsonProperty
    private boolean github;

    @JsonProperty
    private boolean google;

    @JsonProperty
    private boolean ldap;

    @JsonProperty
    private boolean password;

    @JsonProperty
    private boolean remoteuser;

    @JsonProperty
    private boolean saml;

    public boolean isAzuread() {
        return azuread;
    }

    public boolean isDev() {
        return dev;
    }

    public boolean isEmail() {
        return email;
    }

    public boolean isGithub() {
        return github;
    }

    public boolean isGoogle() {
        return google;
    }

    public boolean isLdap() {
        return ldap;
    }

    public boolean isPassword() {
        return password;
    }

    public boolean isRemoteuser() {
        return remoteuser;
    }

    public boolean isSaml() {
        return saml;
    }
}
