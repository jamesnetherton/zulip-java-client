package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.ProfileField;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all custom profile fields.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-custom-profile-fields#response">https://zulip.com/api/get-custom-profile-fields#response</a>
 */
public class GetProfileFieldsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<ProfileField> customFields = new ArrayList<>();

    public List<ProfileField> getCustomFields() {
        return customFields;
    }
}
