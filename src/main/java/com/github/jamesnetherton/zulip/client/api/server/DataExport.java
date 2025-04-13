package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

public class DataExport {
    @JsonProperty
    private int id;

    @JsonProperty
    private int actingUserId;

    @JsonProperty
    private Instant exportTime;

    @JsonProperty
    private Instant deletedTimestamp;

    @JsonProperty
    private Instant failedTimestamp;

    @JsonProperty
    private String exportUrl;

    @JsonProperty
    private boolean pending;

    @JsonProperty
    private DataExportType exportType;

    public int getId() {
        return id;
    }

    public int getActingUserId() {
        return actingUserId;
    }

    public Instant getExportTime() {
        return exportTime;
    }

    public Instant getDeletedTimestamp() {
        return deletedTimestamp;
    }

    public Instant getFailedTimestamp() {
        return failedTimestamp;
    }

    public String getExportUrl() {
        return exportUrl;
    }

    public boolean isPending() {
        return pending;
    }

    public DataExportType getExportType() {
        return exportType;
    }
}
