package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * Data export types.
 */
public enum DataExportType {
    /**
     * Public data only export.
     */
    PUBLIC("public"),
    /**
     * Public and private data export including private data for users who have granted consent.
     */
    FULL_WITH_CONSENT("full_with_consent"),
    /**
     * Full data export including private data for all users. Requires the organization to have the
     * {@code owner_full_content_access} feature enabled.
     */
    FULL_WITHOUT_CONSENT("full_without_consent"),
    /**
     * Unknown data export type. Indicates an API response error.
     */
    UNKNOWN("unknown");

    private final String value;

    DataExportType(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }

    @JsonCreator
    public static DataExportType fromString(String value) {
        for (DataExportType type : DataExportType.values()) {
            if (type.getValue().equals(value)) {
                return type;
            }
        }
        return UNKNOWN;
    }
}
