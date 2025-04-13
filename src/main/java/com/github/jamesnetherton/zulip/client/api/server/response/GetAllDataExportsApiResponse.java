package com.github.jamesnetherton.zulip.client.api.server.response;

import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.DataExport;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all data exports.
 *
 * @see <a href="https://zulip.com/api/get-realm-exports#response">https://zulip.com/api/get-realm-exports#response</a>
 */
public class GetAllDataExportsApiResponse extends ZulipApiResponse {
    private final List<DataExport> exports = new ArrayList<>();

    public List<DataExport> getExports() {
        return exports;
    }
}
