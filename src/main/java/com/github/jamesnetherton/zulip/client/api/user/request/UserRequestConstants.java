package com.github.jamesnetherton.zulip.client.api.user.request;

final class UserRequestConstants {
    public static final String ATTACHMENTS = "attachments";
    public static final String BOTS_API_KEY = "bots/%d/api_key";
    public static final String BOTS_API_KEY_REGENERATE = "bots/%d/api_key/regenerate";
    public static final String ATTACHMENTS_WITH_ID = "attachments/%d";
    public static final String SETTINGS = "settings";
    public static final String SETTINGS_NOTIFICATIONS = SETTINGS + "/notifications";
    public static final String TYPING = "typing";
    public static final String TYPING_FOR_MESSAGE_EDIT = "messages/%d/" + TYPING;
    public static final String USER_GROUPS = "user_groups";
    public static final String USER_GROUPS_CREATE = USER_GROUPS + "/create";
    public static final String USER_GROUPS_WITH_ID = USER_GROUPS + "/%d";
    public static final String USER_GROUPS_DEACTIVATE = USER_GROUPS_WITH_ID + "/deactivate";
    public static final String USER_GROUPS_MEMBERS = USER_GROUPS_WITH_ID + "/members";
    public static final String USER_GROUPS_MEMBERS_WITH_ID = USER_GROUPS_MEMBERS + "/%d";
    public static final String USER_GROUPS_SUBGROUPS = USER_GROUPS_WITH_ID + "/subgroups";
    public static final String USERS = "users";
    public static final String USERS_WITH_EMAIL = "users/%s";
    public static final String USERS_WITH_ID = "users/%d";
    public static final String USERS_WITH_ME = "users/me";
    public static final String USERS_MUTED_WITH_ID = USERS_WITH_ME + "/muted_users/%d";
    public static final String USERS_PRESENCE = "users/%s/presence";
    public static final String USERS_WITH_ME_PRESENCE = USERS_WITH_ME + "/presence";
    public static final String USERS_REACTIVATE = USERS_WITH_ID + "/reactivate";
    public static final String USERS_REALM_PRESENCE = "realm/presence";
    public static final String USERS_STATUS = USERS_WITH_ID + "/status";
    public static final String USERS_OWN_STATUS = USERS_WITH_ME + "/status";
    public static final String USERS_ALERT_WORDS = USERS_WITH_ME + "/alert_words";
    public static final String USERS_WITH_ID_CHANNELS = USERS_WITH_ID + "/channels";
    public static final String USERS_WITH_ME_API_KEY_REGENERATE = USERS_WITH_ME + "/api_key/regenerate";
    public static final String USERS_WITH_ME_PROFILE_DATA = USERS_WITH_ME + "/profile_data";

    private UserRequestConstants() {
    }
}
