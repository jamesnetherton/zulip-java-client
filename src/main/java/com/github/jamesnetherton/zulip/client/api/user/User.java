package com.github.jamesnetherton.zulip.client.api.user;

import com.github.jamesnetherton.zulip.client.api.user.response.UserApiResponse;
import java.util.Map;

/**
 * Defines a Zulip user.
 */
public class User {

    private final UserApiResponse delegate;

    public User(UserApiResponse delegate) {
        this.delegate = delegate;
    }

    public String getAvatarUrl() {
        return delegate.getAvatarUrl();
    }

    public int getAvatarVersion() {
        return delegate.getAvatarVersion();
    }

    public String getEmail() {
        return delegate.getEmail();
    }

    public String getFullName() {
        return delegate.getFullName();
    }

    public boolean isAdmin() {
        return delegate.isAdmin();
    }

    public boolean isOwner() {
        return delegate.isOwner();
    }

    public boolean isGuest() {
        return delegate.isGuest();
    }

    public boolean isBillingAdmin() {
        return delegate.isBillingAdmin();
    }

    public boolean isBot() {
        return delegate.isBot();
    }

    public boolean isActive() {
        return delegate.isActive();
    }

    public String getTimezone() {
        return delegate.getTimezone();
    }

    public String getDateJoined() {
        return delegate.getDateJoined();
    }

    public Long getUserId() {
        return delegate.getUserId();
    }

    public String getDeliveryEmail() {
        return delegate.getDeliveryEmail();
    }

    public Map<String, ProfileData> getProfileData() {
        return delegate.getProfileData();
    }
}
