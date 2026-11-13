package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.CALLS_GOOGLE_MEET;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.CreateVideoCallApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a Google Meet video call.
 *
 * @see <a href="https://zulip.com/api/create-google-meet-video-call">https://zulip.com/api/create-google-meet-video-call</a>
 */
public class CreateGoogleMeetVideoCallApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    /**
     * Constructs a {@link CreateGoogleMeetVideoCallApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public CreateGoogleMeetVideoCallApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for creating a Google Meet video call.
     *
     * @return                      The URL of the Google Meet meeting
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().post(CALLS_GOOGLE_MEET, getParams(), CreateVideoCallApiResponse.class).getUrl();
    }
}
