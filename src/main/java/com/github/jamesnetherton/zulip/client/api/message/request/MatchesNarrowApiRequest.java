package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MATCHES_NARROW_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.MessageMatch;
import com.github.jamesnetherton.zulip.client.api.message.response.MatchesNarrowApiResponse;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.api.narrow.NarrowableApiRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * Zulip API request builder for checking if a set of messages matches a narrow.
 * 
 * @see <a href="https://zulip.com/api/check-narrow-matches">https://zulip.com/api/check-narrow-matches</a>
 * @see <a href="https://zulip.com/api/construct-narrow">https://zulip.com/api/construct-narrow</a>
 */
public class MatchesNarrowApiRequest extends ZulipApiRequest
        implements NarrowableApiRequest<MatchesNarrowApiRequest>, ExecutableApiRequest<Map<Long, MessageMatch>> {

    public static final String MESSAGE_IDS = "msg_ids";
    public static final String NARROW = "narrow";

    /**
     * Constructs a {@link MatchesNarrowApiRequest}.
     * 
     * @param client The Zulip HTTP client
     */
    public MatchesNarrowApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the mandatory message ids to check.
     *
     * @see               <a href=
     *                    "https://zulip.com/api/check-narrow-matches#parameter-msg_ids">https://zulip.com/api/check-narrow-matches#parameter-msg_ids</a>
     *
     * @param  messageIds One or message ids to check
     * @return            This {@link MatchesNarrowApiRequest} instance
     */
    public MatchesNarrowApiRequest withMessageIds(long... messageIds) {
        putParamAsJsonString(MESSAGE_IDS, messageIds);
        return this;
    }

    /**
     * Sets the narrow expressions to check.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/check-narrow-matches#parameter-narrow">https://zulip.com/api/check-narrow-matches#parameter-narrow</a>
     *
     * @param  narrows One or {@link Narrow} expressions to check
     * @return         This {@link MatchesNarrowApiRequest} instance
     */
    @Override
    public MatchesNarrowApiRequest withNarrows(Narrow... narrows) {
        putParamAsJsonString(NARROW, narrows);
        return this;
    }

    /**
     * Executes the Zulip API request for checking if a set of messages matches a narrow.
     * 
     * @return                      map keyed by message id where the value is a {@link MessageMatch}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Map<Long, MessageMatch> execute() throws ZulipClientException {
        MatchesNarrowApiResponse response = client().get(MATCHES_NARROW_API_PATH, getParams(), MatchesNarrowApiResponse.class);
        return response.getMessages();
    }
}
