package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for registering a logged-in device.
 *
 * @see <a href="https://zulip.com/api/register-client-device">https://zulip.com/api/register-client-device</a>
 */
public class RegisterClientDeviceApiResponse extends ZulipApiResponse {

    @JsonProperty
    private long deviceId;

    public long getDeviceId() {
        return deviceId;
    }
}
