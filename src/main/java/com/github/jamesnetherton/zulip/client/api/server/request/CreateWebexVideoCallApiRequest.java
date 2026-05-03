package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.CALLS_WEBEX;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.CreateVideoCallApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a Webex video call.
 *
 * @see <a href="https://zulip.com/api/create-webex-video-call">https://zulip.com/api/create-webex-video-call</a>
 */
public class CreateWebexVideoCallApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    /**
     * Constructs a {@link CreateWebexVideoCallApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public CreateWebexVideoCallApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for creating a Webex video call.
     *
     * @return                      The URL of the Webex meeting
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().post(CALLS_WEBEX, getParams(), CreateVideoCallApiResponse.class).getUrl();
    }
}
