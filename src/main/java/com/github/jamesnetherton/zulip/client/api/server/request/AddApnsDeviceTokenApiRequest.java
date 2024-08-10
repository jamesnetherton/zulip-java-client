package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.USERS_APNS_DEVICE_TOKEN;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for adding APNs device token to register for iOS push notifications.
 *
 * @see <a href="https://zulip.com/api/add-apns-token">https://zulip.com/api/add-apns-token</a>
 *
 */
public class AddApnsDeviceTokenApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String APP_ID = "appid";
    public static final String TOKEN = "token";

    /**
     * Constructs a {@link AddApnsDeviceTokenApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param token  The token provided by the device
     * @param appId  The ID of the Zulip app that is making the request
     */
    public AddApnsDeviceTokenApiRequest(ZulipHttpClient client, String token, String appId) {
        super(client);
        putParam(TOKEN, token);
        putParam(APP_ID, appId);
    }

    /**
     * Executes the Zulip API request for for adding APNs device token to register for iOS push notifications.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(USERS_APNS_DEVICE_TOKEN, getParams(), ZulipApiResponse.class);
    }
}
