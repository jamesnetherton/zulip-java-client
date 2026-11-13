package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

public class DataExport {
    @JsonProperty
    private long id;

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

    @JsonProperty
    private boolean exportFromPriorServer;

    public long getId() {
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

    /**
     * Returns whether the export was carried across a realm import from a previous server, in which case its data is not
     * stored on this server. Requires Zulip 13 or later, or Zulip 12.1 or later.
     *
     * @return {@code true} if the export happened on a previous server
     */
    public boolean isExportFromPriorServer() {
        return exportFromPriorServer;
    }
}
