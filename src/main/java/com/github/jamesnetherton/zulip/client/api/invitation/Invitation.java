package com.github.jamesnetherton.zulip.client.api.invitation;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.user.UserRole;
import java.time.Instant;

/**
 * Defines a Zulip invitation.
 */
public class Invitation {
    @JsonProperty
    private long id;

    @JsonProperty
    private long invitedByUserId;

    @JsonProperty
    private Instant invited;

    @JsonProperty
    private Instant expiryDate;

    @JsonProperty
    private UserRole invitedAs;

    @JsonProperty
    private String email;

    @JsonProperty
    private boolean notifyReferrerOnJoin;

    @JsonProperty
    private String linkUrl;

    @JsonProperty
    private boolean isMultiuse;

    public long getId() {
        return id;
    }

    public long getInvitedByUserId() {
        return invitedByUserId;
    }

    public Instant getInvited() {
        return invited;
    }

    public Instant getExpiryDate() {
        return expiryDate;
    }

    public UserRole getInvitedAs() {
        return invitedAs;
    }

    public String getEmail() {
        return email;
    }

    public boolean isNotifyReferrerOnJoin() {
        return notifyReferrerOnJoin;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public boolean isMultiuse() {
        return isMultiuse;
    }
}
