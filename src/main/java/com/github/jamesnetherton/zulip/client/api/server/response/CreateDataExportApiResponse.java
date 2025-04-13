package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for creating a data export.
 *
 * @see <a href="https://zulip.com/api/export-realm#response">https://zulip.com/api/export-realm#response</a>
 */
public class CreateDataExportApiResponse extends ZulipApiResponse {
    @JsonProperty
    private int id;

    public int getId() {
        return id;
    }
}
