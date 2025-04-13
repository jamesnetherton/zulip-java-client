package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.DataExportConsent;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting users that have consented to their private data being exported.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-realm-export-consents#response">https://zulip.com/api/get-realm-export-consents#response</a>
 */
public class GetDataExportConsentStateApiResponse extends ZulipApiResponse {
    @JsonProperty
    private List<DataExportConsent> exportConsents = new ArrayList<>();

    public List<DataExportConsent> getExportConsents() {
        return exportConsents;
    }
}
