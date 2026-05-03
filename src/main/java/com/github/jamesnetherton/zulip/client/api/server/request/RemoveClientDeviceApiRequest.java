package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REMOVE_CLIENT_DEVICE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for removing a registered device when the user logs out.
 *
 * @see <a href="https://zulip.com/api/remove-client-device">https://zulip.com/api/remove-client-device</a>
 */
public class RemoveClientDeviceApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String DEVICE_ID = "device_id";

    /**
     * Constructs a {@link RemoveClientDeviceApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param deviceId The ID of the device to remove
     */
    public RemoveClientDeviceApiRequest(ZulipHttpClient client, long deviceId) {
        super(client);
        putParam(DEVICE_ID, deviceId);
    }

    /**
     * Executes the Zulip API request for removing a registered device.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(REMOVE_CLIENT_DEVICE, getParams(), ZulipApiResponse.class);
    }
}
