package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.MOBILE_PUSH_TEST;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for sending mobile push test notifications.
 *
 * @see <a href="https://zulip.com/api/test-notify">https://zulip.com/api/test-notify</a>
 *
 */
public class SendMobilePushTestNotification extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String TOKEN = "token";

    /**
     * Constructs a {@link SendMobilePushTestNotification}.
     *
     * @param client The Zulip HTTP client
     */
    public SendMobilePushTestNotification(ZulipHttpClient client) {
        super(client);
    }

    /**
     * The push token for the device to which to send the test notification.
     *
     * @see          <a href=
     *               "https://zulip.com/api/test-notify#parameter-token">https://zulip.com/api/test-notify#parameter-token</a>
     *
     * @param  token The mobile device token
     * @return       This {@link SendMobilePushTestNotification} instance
     */
    public SendMobilePushTestNotification withToken(String token) {
        putParam(TOKEN, token);
        return this;
    }

    /**
     * Executes the Zulip API request for sending mobile push test notifications.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(MOBILE_PUSH_TEST, getParams(), ZulipApiResponse.class);
    }
}
