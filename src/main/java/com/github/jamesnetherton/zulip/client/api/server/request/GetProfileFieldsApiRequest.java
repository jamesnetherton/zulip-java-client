package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_PROFILE_FIELDS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.ProfileField;
import com.github.jamesnetherton.zulip.client.api.server.response.GetProfileFieldsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all custom profile fields.
 *
 * @see <a href="https://zulip.com/api/get-custom-profile-fields">https://zulip.com/api/get-custom-profile-fields</a>
 */
public class GetProfileFieldsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<ProfileField>> {

    /**
     * Constructs a {@link GetProfileFieldsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetProfileFieldsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all custom profile fields.
     *
     * @return                      List of {@link ProfileField} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<ProfileField> execute() throws ZulipClientException {
        GetProfileFieldsApiResponse response = client().get(REALM_PROFILE_FIELDS, getParams(),
                GetProfileFieldsApiResponse.class);
        return response.getCustomFields();
    }
}
