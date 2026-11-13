package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_DEACTIVATE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deactivating the organization.
 *
 * @see <a href="https://zulip.com/api/deactivate-realm">https://zulip.com/api/deactivate-realm</a>
 */
public class DeactivateRealmApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String DELETION_DELAY_DAYS = "deletion_delay_days";

    /**
     * Constructs a {@link DeactivateRealmApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public DeactivateRealmApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the number of days to wait before permanently deleting the deactivated organization's data. The permitted range is
     * determined by the server.
     *
     * @see                      <a href=
     *                           "https://zulip.com/api/deactivate-realm#parameter-deletion_delay_days">https://zulip.com/api/deactivate-realm#parameter-deletion_delay_days</a>
     *
     * @param  deletionDelayDays The number of days before the data is deleted. {@code 0} deletes it immediately, meaning the
     *                           organization cannot be reactivated. {@code null} retains the data indefinitely
     * @return                   This {@link DeactivateRealmApiRequest} instance
     */
    public DeactivateRealmApiRequest withDeletionDelayDays(Integer deletionDelayDays) {
        putParamAsJsonString(DELETION_DELAY_DAYS, deletionDelayDays);
        return this;
    }

    /**
     * Executes the Zulip API request for deactivating the organization.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(REALM_DEACTIVATE, getParams(), ZulipApiResponse.class);
    }
}
