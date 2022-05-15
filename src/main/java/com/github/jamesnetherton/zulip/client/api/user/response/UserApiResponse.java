package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.ProfileData;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API response class for getting a user.
 *
 * @see <a href="https://zulip.com/api/get-user">https://zulip.com/api/get-user</a>
 */
public class UserApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String avatarUrl;

    @JsonProperty
    private int avatarVersion;

    @JsonProperty
    private String email;

    @JsonProperty
    private String fullName;

    @JsonProperty
    private boolean isAdmin;

    @JsonProperty
    private boolean isOwner;

    @JsonProperty
    private boolean isGuest;

    @JsonProperty
    private boolean isBillingAdmin;

    @JsonProperty
    private boolean isBot;

    @JsonProperty
    private boolean isActive;

    @JsonProperty
    private String timezone;

    @JsonProperty
    private String dateJoined;

    @JsonProperty
    private long userId;

    @JsonProperty
    private String deliveryEmail;

    @JsonProperty
    private Map<String, ProfileData> profileData = new HashMap<>();

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public int getAvatarVersion() {
        return avatarVersion;
    }

    public String getEmail() {
        return email;
    }

    public String getFullName() {
        return fullName;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public boolean isOwner() {
        return isOwner;
    }

    public boolean isGuest() {
        return isGuest;
    }

    public boolean isBillingAdmin() {
        return isBillingAdmin;
    }

    public boolean isBot() {
        return isBot;
    }

    public boolean isActive() {
        return isActive;
    }

    public String getTimezone() {
        return timezone;
    }

    public String getDateJoined() {
        return dateJoined;
    }

    public long getUserId() {
        return userId;
    }

    public String getDeliveryEmail() {
        return deliveryEmail;
    }

    public Map<String, ProfileData> getProfileData() {
        return profileData;
    }
}
