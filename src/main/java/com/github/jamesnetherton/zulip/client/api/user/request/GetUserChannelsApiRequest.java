package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ID_CHANNELS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.GetUserChannelsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting the list of channels a user is subscribed to.
 *
 * @see <a href="https://zulip.com/api/get-user-channels">https://zulip.com/api/get-user-channels</a>
 */
public class GetUserChannelsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Long>> {

    private final long userId;

    /**
     * Constructs a {@link GetUserChannelsApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param userId The ID of the user to get channels for
     */
    public GetUserChannelsApiRequest(ZulipHttpClient client, long userId) {
        super(client);
        this.userId = userId;
    }

    /**
     * Executes the Zulip API request for getting a user's subscribed channels.
     *
     * @return                      List of channel IDs the user is subscribed to
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Long> execute() throws ZulipClientException {
        String path = String.format(USERS_WITH_ID_CHANNELS, userId);
        return client().get(path, getParams(), GetUserChannelsApiResponse.class).getSubscribedChannelIds();
    }
}
