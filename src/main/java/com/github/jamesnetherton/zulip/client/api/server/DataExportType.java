package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Data export types.
 */
public enum DataExportType {
    /**
     * Public data export.
     */
    PUBLIC(1),
    /**
     * Standard data export.
     */
    STANDARD(2),
    /**
     * Unknown data export. Indicates an API response error.
     */
    UNKNOWN(0);

    private final int id;

    DataExportType(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static DataExportType fromInt(int dataExportTypeId) {
        for (DataExportType dataExportType : DataExportType.values()) {
            if (dataExportType.getId() == dataExportTypeId) {
                return dataExportType;
            }
        }
        return UNKNOWN;
    }
}
