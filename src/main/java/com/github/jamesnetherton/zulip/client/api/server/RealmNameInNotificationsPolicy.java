package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the policy of whether to include the organization name in the subject of message notification emails.
 *
 * See <a href=
 * "https://zulip.com/api/update-settings#parameter-realm_name_in_email_notifications_policy">https://zulip.com/api/update-settings#parameter-realm_name_in_email_notifications_policy</a>
 */
public enum RealmNameInNotificationsPolicy {
    /**
     * Inclusion of the organization name is determined automatically.
     */
    AUTOMATIC(1),
    /**
     * The organization name is always included.
     */
    ALWAYS(2),
    /**
     * The organization name is never included.
     */
    NEVER(3);

    private final int id;

    RealmNameInNotificationsPolicy(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static RealmNameInNotificationsPolicy fromInt(int notificationsPolicy) {
        for (RealmNameInNotificationsPolicy realNameInNotificationsPolicy : RealmNameInNotificationsPolicy.values()) {
            if (realNameInNotificationsPolicy.getId() == notificationsPolicy) {
                return realNameInNotificationsPolicy;
            }
        }
        return ALWAYS;
    }
}
