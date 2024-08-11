package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.USERS_APNS_DEVICE_TOKEN;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for removing an APNs device token.
 *
 * @see <a href="https://zulip.com/api/remove-apns-token">https://zulip.com/api/remove-apns-token</a>
 *
 */
public class RemoveApnsDeviceTokenApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String TOKEN = "token";

    /**
     * Constructs a {@link RemoveApnsDeviceTokenApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param token  The token provided by the device
     */
    public RemoveApnsDeviceTokenApiRequest(ZulipHttpClient client, String token) {
        super(client);
        putParam(TOKEN, token);
    }

    /**
     * Executes the Zulip API request for removing an APNs device token.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(USERS_APNS_DEVICE_TOKEN, getParams(), ZulipApiResponse.class);
    }
}
