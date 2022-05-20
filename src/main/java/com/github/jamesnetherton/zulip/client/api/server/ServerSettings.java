package com.github.jamesnetherton.zulip.client.api.server;

import com.github.jamesnetherton.zulip.client.api.server.response.GetServerSettingsApiResponse;
import java.util.List;

/**
 * Defines Zulip server settings.
 */
public class ServerSettings {

    private final GetServerSettingsApiResponse delegate;

    public ServerSettings(GetServerSettingsApiResponse delegate) {
        this.delegate = delegate;
    }

    public AuthenticationSettings getAuthenticationMethods() {
        return delegate.getAuthenticationMethods();
    }

    public boolean isEmailAuthEnabled() {
        return delegate.isEmailAuthEnabled();
    }

    public List<ExternalAuthenticationSettings> getExternalAuthenticationMethods() {
        return delegate.getExternalAuthenticationMethods();
    }

    public boolean isIncompatible() {
        return delegate.isIncompatible();
    }

    public boolean isPushNotificationsEnabled() {
        return delegate.isPushNotificationsEnabled();
    }

    public String getRealmDescription() {
        return delegate.getRealmDescription();
    }

    public String getRealmIcon() {
        return delegate.getRealmIcon();
    }

    public String getRealmName() {
        return delegate.getRealmName();
    }

    public String getRealmUri() {
        return delegate.getRealmUri();
    }

    public boolean isRealmWebPublicAccessEnabled() {
        return delegate.isRealmWebPublicAccessEnabled();
    }

    public boolean isRequireEmailFormatUsernames() {
        return delegate.isRequireEmailFormatUsernames();
    }

    public String getZulipMergeBase() {
        return delegate.getZulipMergeBase();
    }

    public String getZulipVersion() {
        return delegate.getZulipVersion();
    }
}
