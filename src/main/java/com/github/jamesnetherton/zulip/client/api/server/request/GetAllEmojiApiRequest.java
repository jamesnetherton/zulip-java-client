package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_EMOJI;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.CustomEmoji;
import com.github.jamesnetherton.zulip.client.api.server.response.GetAllEmojiApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Zulip API request builder for getting all custom emoji.
 *
 * @see <a href="https://zulip.com/api/get-custom-emoji">https://zulip.com/api/get-custom-emoji</a>
 */
public class GetAllEmojiApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<CustomEmoji>> {

    /**
     * Constructs a {@link GetAllEmojiApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetAllEmojiApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all custom emoji.
     *
     * @return                      List of all custom {@link CustomEmoji}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<CustomEmoji> execute() throws ZulipClientException {
        GetAllEmojiApiResponse response = client().get(REALM_EMOJI, getParams(), GetAllEmojiApiResponse.class);

        List<CustomEmoji> emojis = new ArrayList<>();

        Map<String, CustomEmoji> emojiMap = response.getEmoji();
        emojiMap.keySet()
                .stream()
                .map(emojiMap::get)
                .forEach(emojis::add);

        return emojis;
    }
}
