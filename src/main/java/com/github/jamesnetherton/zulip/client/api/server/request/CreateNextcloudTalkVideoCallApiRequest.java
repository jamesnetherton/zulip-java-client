package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.CALLS_NEXTCLOUD_TALK;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.CreateVideoCallApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a Nextcloud Talk video call.
 *
 * @see <a href=
 *      "https://zulip.com/api/create-nextcloud-talk-video-call">https://zulip.com/api/create-nextcloud-talk-video-call</a>
 */
public class CreateNextcloudTalkVideoCallApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    public static final String ROOM_NAME = "room_name";

    /**
     * Constructs a {@link CreateNextcloudTalkVideoCallApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param roomName Room name for the Nextcloud Talk conversation
     */
    public CreateNextcloudTalkVideoCallApiRequest(ZulipHttpClient client, String roomName) {
        super(client);
        putParam(ROOM_NAME, roomName);
    }

    /**
     * Executes the Zulip API request for creating a Nextcloud Talk video call.
     *
     * @return                      The URL of the Nextcloud Talk conversation
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().post(CALLS_NEXTCLOUD_TALK, getParams(), CreateVideoCallApiResponse.class).getUrl();
    }
}
