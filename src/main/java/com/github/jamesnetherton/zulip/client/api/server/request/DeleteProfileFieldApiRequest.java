package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_PROFILE_FIELDS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a custom profile field.
 */
public class DeleteProfileFieldApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long profileFieldId;

    /**
     * Constructs a {@link DeleteProfileFieldApiRequest}.
     *
     * @param client         The Zulip HTTP client
     * @param profileFieldId The id of the profile field to delete
     */
    public DeleteProfileFieldApiRequest(ZulipHttpClient client, long profileFieldId) {
        super(client);
        this.profileFieldId = profileFieldId;
    }

    /**
     * Executes the Zulip API request for deleting a custom profile field.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(REALM_PROFILE_FIELDS_WITH_ID, profileFieldId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
