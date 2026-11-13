package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.MOBILE_E2E_PUSH_TEST;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for sending E2E mobile push test notifications.
 *
 * @see <a href="https://zulip.com/api/e2ee-test-notify">https://zulip.com/api/e2ee-test-notify</a>
 */
public class SendE2EMobilePushTestNotification extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String DEVICE_ID = "device_id";

    /**
     * Constructs a {@link SendE2EMobilePushTestNotification}.
     *
     * @param client The Zulip HTTP client
     */
    public SendE2EMobilePushTestNotification(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the device to send the test notification to. If not set, test notifications are sent to all of the user's
     * registered devices.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/e2ee-test-notify#parameter-device_id">https://zulip.com/api/e2ee-test-notify#parameter-device_id</a>
     *
     * @param  deviceId The id of the device
     * @return          This {@link SendE2EMobilePushTestNotification} instance
     */
    public SendE2EMobilePushTestNotification withDeviceId(long deviceId) {
        putParam(DEVICE_ID, deviceId);
        return this;
    }

    /**
     * Executes the Zulip API request for sending E2E mobile push test notifications.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(MOBILE_E2E_PUSH_TEST, getParams(), ZulipApiResponse.class);
    }
}
