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
    public static final String PUSH_ACCOUNT_ID = "push_account_id";

    /**
     * Constructs a {@link SendE2EMobilePushTestNotification}.
     *
     * @param client The Zulip HTTP client
     */
    public SendE2EMobilePushTestNotification(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the push account id for the device to send the test notification.
     *
     * @see                  <a href="https://zulip.com/api/e2ee-test-notify">https://zulip.com/api/e2ee-test-notify</a>
     *
     * @param  pushAccountId The push account id
     * @return               This {@link SendE2EMobilePushTestNotification} instance
     */
    public SendE2EMobilePushTestNotification pushAccountId(String pushAccountId) {
        putParam(PUSH_ACCOUNT_ID, pushAccountId);
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
