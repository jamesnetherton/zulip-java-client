package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REGISTER_CLIENT_DEVICE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.RegisterClientDeviceApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for registering a logged-in device as an initial step before registering for E2EE push
 * notifications.
 *
 * @see <a href="https://zulip.com/api/register-client-device">https://zulip.com/api/register-client-device</a>
 */
public class RegisterClientDeviceApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {

    /**
     * Constructs a {@link RegisterClientDeviceApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public RegisterClientDeviceApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for registering a logged-in device.
     *
     * @return                      The ID of the newly registered device
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        return client().post(REGISTER_CLIENT_DEVICE, getParams(), RegisterClientDeviceApiResponse.class).getDeviceId();
    }
}
