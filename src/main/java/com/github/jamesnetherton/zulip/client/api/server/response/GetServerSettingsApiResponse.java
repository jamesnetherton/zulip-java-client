package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.AuthenticationSettings;
import com.github.jamesnetherton.zulip.client.api.server.ExternalAuthenticationSettings;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all server settings.
 *
 * @see <a href="https://zulip.com/api/get-server-settings#response">https://zulip.com/api/get-server-settings#response</a>
 */
public class GetServerSettingsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private AuthenticationSettings authenticationMethods;

    @JsonProperty
    private boolean emailAuthEnabled;

    @JsonProperty
    List<ExternalAuthenticationSettings> externalAuthenticationMethods = new ArrayList<>();

    @JsonProperty
    private boolean incompatible;

    @JsonProperty
    private boolean pushNotificationsEnabled;

    @JsonProperty
    private String realmDescription;

    @JsonProperty
    private String realmIcon;

    @JsonProperty
    private String realmName;

    @JsonProperty
    private String realmUri;

    @JsonProperty
    private boolean requireEmailFormatUsernames;

    @JsonProperty
    private String zulipVersion;

    public AuthenticationSettings getAuthenticationMethods() {
        return authenticationMethods;
    }

    public boolean isEmailAuthEnabled() {
        return emailAuthEnabled;
    }

    public List<ExternalAuthenticationSettings> getExternalAuthenticationMethods() {
        return externalAuthenticationMethods;
    }

    public boolean isIncompatible() {
        return incompatible;
    }

    public boolean isPushNotificationsEnabled() {
        return pushNotificationsEnabled;
    }

    public String getRealmDescription() {
        return realmDescription;
    }

    public String getRealmIcon() {
        return realmIcon;
    }

    public String getRealmName() {
        return realmName;
    }

    public String getRealmUri() {
        return realmUri;
    }

    public boolean isRequireEmailFormatUsernames() {
        return requireEmailFormatUsernames;
    }

    public String getZulipVersion() {
        return zulipVersion;
    }
}
