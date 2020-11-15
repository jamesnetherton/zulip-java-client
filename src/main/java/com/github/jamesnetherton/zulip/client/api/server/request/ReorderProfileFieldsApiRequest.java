package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_PROFILE_FIELDS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for reordering custom profile fields.
 *
 * @see <a href="https://zulip.com/api/reorder-custom-profile-fields">https://zulip.com/api/reorder-custom-profile-fields</a>
 */
public class ReorderProfileFieldsApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String ORDER = "order";

    /**
     * Constructs a {@link ReorderProfileFieldsApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param order  The array of custom profile field ids in the order that they should appear on the Zulip UI
     */
    public ReorderProfileFieldsApiRequest(ZulipHttpClient client, int... order) {
        super(client);
        putParamAsJsonString(ORDER, order);
    }

    /**
     * Executes the Zulip API request for reordering custom profile fields.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().patch(REALM_PROFILE_FIELDS, getParams(), ZulipApiResponse.class);
    }
}
