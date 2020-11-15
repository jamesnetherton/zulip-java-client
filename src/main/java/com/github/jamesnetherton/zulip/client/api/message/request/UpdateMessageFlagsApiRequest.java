package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.FLAGS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlag;
import com.github.jamesnetherton.zulip.client.api.message.response.UpdateMessageFlagsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for updating message flags.
 *
 * @see <a href="https://zulip.com/api/update-message-flags">https://zulip.com/api/update-message-flags</a>
 */
public class UpdateMessageFlagsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Long>> {

    public static final String FLAG = "flag";
    public static final String MESSAGES = "messages";
    public static final String OP = "op";

    /**
     * Constructs a {@link UpdateMessageFlagsApiRequest}.
     * 
     * @param client     The Zulip HTTP client
     * @param flag       The {@link MessageFlag} to add or remove to the messages
     * @param operation  The {@link Operation} to apply for the {@link MessageFlag}
     * @param messageIds The message ids for which to update flags for
     */
    public UpdateMessageFlagsApiRequest(ZulipHttpClient client, MessageFlag flag, Operation operation, long... messageIds) {
        super(client);
        putParam(FLAG, flag.toString());
        putParam(OP, operation.toString());
        putParamAsJsonString(MESSAGES, messageIds);
    }

    /**
     * Executes The Zulip API request for updating message flags.
     * 
     * @return                      List of ids for messages that were modified
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Long> execute() throws ZulipClientException {
        UpdateMessageFlagsApiResponse response = client().post(FLAGS_API_PATH, getParams(),
                UpdateMessageFlagsApiResponse.class);
        return response.getMessages();
    }
}
