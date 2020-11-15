package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.TYPING;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.TypingOperation;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for setting user 'typing' status.
 *
 * @see <a href="https://zulip.com/api/set-typing-status">https://zulip.com/api/set-typing-status</a>
 */
public class SetTypingStatusApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String OPERATION = "op";
    public static final String TO = "to";

    /**
     * Constructs a {@link SetTypingStatusApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param operation The typing operation to apply
     * @param userIds   Array of user ids to add to set the typing status for
     */
    public SetTypingStatusApiRequest(ZulipHttpClient client, TypingOperation operation, long... userIds) {
        super(client);
        putParam(OPERATION, operation.toString());
        putParamAsJsonString(TO, userIds);
    }

    /**
     * Executes the Zulip API request for setting user 'typing' status.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(TYPING, getParams(), ZulipApiResponse.class);
    }
}
