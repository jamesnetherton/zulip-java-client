package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.USERS_ANDROID_GCM_REG_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for removing an FCM registration token.
 *
 * @see <a href="https://zulip.com/api/remove-fcm-token">https://zulip.com/api/remove-fcm-token</a>
 *
 */
public class RemoveFcmRegistrationTokenApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String TOKEN = "token";

    /**
     * Constructs a {@link RemoveFcmRegistrationTokenApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param token  The token provided by the device
     */
    public RemoveFcmRegistrationTokenApiRequest(ZulipHttpClient client, String token) {
        super(client);
        putParam(TOKEN, token);
    }

    /**
     * Executes the Zulip API request for removing an FCM registration token.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(USERS_ANDROID_GCM_REG_ID, getParams(), ZulipApiResponse.class);
    }
}
