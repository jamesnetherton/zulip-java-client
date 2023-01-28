package com.github.jamesnetherton.zulip.client.api.user.request;

final class UserRequestConstants {
    public static final String ATTACHMENTS = "attachments";
    public static final String SETTINGS = "settings";
    public static final String SETTINGS_NOTIFICATIONS = SETTINGS + "/notifications";
    public static final String TYPING = "typing";
    public static final String USER_GROUPS = "user_groups";
    public static final String USER_GROUPS_CREATE = USER_GROUPS + "/create";
    public static final String USER_GROUPS_WITH_ID = USER_GROUPS + "/%d";
    public static final String USER_GROUPS_MEMBERS = USER_GROUPS_WITH_ID + "/members";
    public static final String USER_GROUPS_MEMBERS_WITH_ID = USER_GROUPS_MEMBERS + "/%d";
    public static final String USER_GROUPS_SUBGROUPS = USER_GROUPS_WITH_ID + "/subgroups";
    public static final String USERS = "users";
    public static final String USERS_WITH_EMAIL = "users/%s";
    public static final String USERS_WITH_ID = "users/%d";
    public static final String USERS_WITH_ME = "users/me";
    public static final String USERS_MUTED_WITH_ID = USERS_WITH_ME + "/muted_users/%d";
    public static final String USERS_PRESENCE = "users/%s/presence";
    public static final String USERS_REACTIVATE = USERS_WITH_ID + "/reactivate";
    public static final String USERS_STATUS = USERS_WITH_ME + "/status";

    private UserRequestConstants() {
    }
}
