package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the type of custom profile field.
 *
 * See <a href=
 * "https://zulip.com/help/add-custom-profile-fields#profile-field-types">https://zulip.com/help/add-custom-profile-fields#profile-field-types</a>
 */
public enum ProfileFieldType {
    /**
     * Profile field for one line responses limited to 50 characters.
     */
    SHORT_TEXT(1),
    /**
     * Profile field for multiline responses.
     */
    LONG_TEXT(2),
    /**
     * Profile field with a list of options to choose from.
     */
    LIST_OF_OPTIONS(3),
    /**
     * Profile field with a date picker.
     */
    DATE_PICKER(4),
    /**
     * Profile field for a web site hyperlink.
     */
    LINK(5),
    /**
     * Profile field with a person picker.
     */
    PERSON_PICKER(6),
    /**
     * Profile field to for linking to GitHub, Twitter etc.
     */
    EXTERNAL_ACCOUNT(7),
    /**
     * Profile field for pronouns.
     */
    PRONOUNS(8),
    /**
     * An unknown profile field type. This usually indicates an error in the response from Zulip.
     */
    UNKNOWN(0);

    private final int id;

    ProfileFieldType(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static ProfileFieldType fromInt(int fieldType) {
        for (ProfileFieldType profileFieldType : ProfileFieldType.values()) {
            if (profileFieldType.getId() == fieldType) {
                return profileFieldType;
            }
        }
        return UNKNOWN;
    }
}
