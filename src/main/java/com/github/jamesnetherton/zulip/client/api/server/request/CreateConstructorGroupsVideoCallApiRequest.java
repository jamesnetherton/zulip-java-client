package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.CALLS_CONSTRUCTOR_GROUPS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.CreateVideoCallApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a Constructor Groups video call.
 *
 * @see <a href=
 *      "https://zulip.com/api/create-constructor-groups-video-call">https://zulip.com/api/create-constructor-groups-video-call</a>
 */
public class CreateConstructorGroupsVideoCallApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    /**
     * Constructs a {@link CreateConstructorGroupsVideoCallApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public CreateConstructorGroupsVideoCallApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for creating a Constructor Groups video call.
     *
     * @return                      The URL of the Constructor Groups video call
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().post(CALLS_CONSTRUCTOR_GROUPS, getParams(), CreateVideoCallApiResponse.class).getUrl();
    }
}
