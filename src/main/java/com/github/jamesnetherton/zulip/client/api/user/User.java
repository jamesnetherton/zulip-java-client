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

    /**
     * Returns whether this user account is a stub account imported from another chat system.
     *
     * @return {@code true} if this is an imported stub account, {@code false} otherwise
     */
    public boolean isImportedStub() {
        return delegate.isImportedStub();
    }

    /**
     * Returns whether this user has been permanently deleted. Only present when {@code true}; permanently deleted users
     * are a subset of deactivated users ({@code isActive=false}) who have had their account data removed.
     *
     * @return {@code true} if this user has been permanently deleted, {@code false} otherwise
     */
    public boolean isDeleted() {
        return delegate.isDeleted();
    }
}
