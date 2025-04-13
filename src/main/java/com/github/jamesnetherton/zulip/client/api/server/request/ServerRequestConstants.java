package com.github.jamesnetherton.zulip.client.api.server.request;

final class ServerRequestConstants {
    public static final String CALLS_BIG_BLUE_BUTTON = "calls/bigbluebutton/create";
    public static final String DEV_FETCH_API_KEY = "dev_fetch_api_key";
    public static final String EXPORT_REALM = "export/realm";
    public static final String EXPORT_REALM_CONSENTS = "export/realm/consents";
    public static final String FETCH_API_KEY = "fetch_api_key";
    public static final String MOBILE_PUSH_TEST = "mobile_push/test_notification";
    public static final String REALM = "realm";
    public static final String REALM_EMOJI = REALM + "/emoji";
    public static final String REALM_EMOJI_WITH_NAME = REALM_EMOJI + "/%s";
    public static final String REALM_FILTERS = REALM + "/filters";
    public static final String REALM_FILTERS_WITH_ID = REALM_FILTERS + "/%d";
    public static final String REALM_LINKIFIERS = REALM + "/linkifiers";
    public static final String REALM_PLAYGROUNDS = REALM + "/playgrounds";
    public static final String REALM_PLAYGROUNDS_WITH_ID = REALM_PLAYGROUNDS + "/%d";
    public static final String REALM_PROFILE_FIELDS = REALM + "/profile_fields";
    public static final String REALM_PROFILE_FIELDS_WITH_ID = REALM_PROFILE_FIELDS + "/%d";
    public static final String REALM_USER_SETTINGS_DEFAULTS = REALM + "/user_settings_defaults";
    public static final String SERVER_SETTINGS = "server_settings";
    public static final String USERS_WITH_ME = "users/me";
    public static final String USERS_APNS_DEVICE_TOKEN = USERS_WITH_ME + "/apns_device_token";
    public static final String USERS_ANDROID_GCM_REG_ID = USERS_WITH_ME + "/android_gcm_reg_id";

    private ServerRequestConstants() {
    }
}
