package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.CALLS_BIG_BLUE_BUTTON;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.CreateBigBlueButtonVideoCallApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a BigBlueButton video call.
 *
 * @see <a href=
 *      "https://zulip.com/api/create-big-blue-button-video-call">https://zulip.com/api/create-big-blue-button-video-call</a>
 *
 */
public class CreateBigBlueButtonVideoCallApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {
    public static final String MEETING_NAME = "meeting_name";

    /**
     * Constructs a {@link CreateBigBlueButtonVideoCallApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param meetingName Meeting name for the BigBlueButton video call
     */
    public CreateBigBlueButtonVideoCallApiRequest(ZulipHttpClient client, String meetingName) {
        super(client);
        putParam(MEETING_NAME, meetingName);
    }

    /**
     * Executes the Zulip API request for creating a BigBlueButton video call.
     *
     * @return                      The URL of the created BigBlueButton video call.
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().get(CALLS_BIG_BLUE_BUTTON, getParams(), CreateBigBlueButtonVideoCallApiResponse.class).getUrl();
    }
}
