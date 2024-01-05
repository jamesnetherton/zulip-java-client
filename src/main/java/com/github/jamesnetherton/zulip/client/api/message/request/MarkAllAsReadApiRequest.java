package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MARK_ALL_AS_READ;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for marking all messages as read.
 *
 * @see <a href="https://zulip.com/api/mark-all-as-read">https://zulip.com/api/mark-all-as-read</a>
 */
@Deprecated
public class MarkAllAsReadApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    /**
     * Constructs a {@link MarkAllAsReadApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public MarkAllAsReadApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for marking all messages as read.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        ZulipApiResponse response = null;
        while (response == null || response.isPartiallyCompleted()) {
            response = client().post(MARK_ALL_AS_READ, getParams(), ZulipApiResponse.class);
        }
    }
}
