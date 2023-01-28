package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.FLAGS_API_NARROW_PATH;

import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.Anchor;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlag;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlagsUpdateResult;
import com.github.jamesnetherton.zulip.client.api.message.response.UpdateMessageFlagsForNarrowApiResponse;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating message flags with a narrow.
 *
 * @see <a href=
 *      "https://zulip.com/api/update-message-flags-for-narrow">https://zulip.com/api/update-message-flags-for-narrow</a>
 */
public class UpdateMessageFlagsForNarrowApiRequest extends ZulipApiRequest
        implements ExecutableApiRequest<MessageFlagsUpdateResult> {

    public static final String ANCHOR = "anchor";
    public static final String FLAG = "flag";
    public static final String INCLUDE_ANCHOR = "include_anchor";
    public static final String NARROW = "narrow";
    public static final String NUM_AFTER = "num_after";
    public static final String NUM_BEFORE = "num_before";
    public static final String OP = "op";

    /**
     * Constructs a {@link UpdateMessageFlagsForNarrowApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param anchor    The {@link Anchor} to use
     * @param numBefore The number of messages preceding the anchor in the update range
     * @param numAfter  The number of messages following the anchor in the update range
     * @param operation The {@link Operation} to apply for the {@link MessageFlag}
     * @param flag      The {@link MessageFlag} to add or remove to the messages
     * @param narrows   The {@link Narrow} expressions to use
     */
    public UpdateMessageFlagsForNarrowApiRequest(
            ZulipHttpClient client,
            Anchor anchor,
            int numBefore,
            int numAfter,
            Operation operation,
            MessageFlag flag,
            Narrow... narrows) {
        super(client);
        putParam(ANCHOR, anchor);
        putParam(NUM_BEFORE, numBefore);
        putParam(NUM_AFTER, numAfter);
        putParam(OP, operation.toString());
        putParam(FLAG, flag.toString());
        putParamAsJsonString(NARROW, narrows);
    }

    /**
     * Constructs a {@link UpdateMessageFlagsForNarrowApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param anchor    The message id anchor to filter and restrict messages
     * @param numBefore The number of messages preceding the anchor in the update range
     * @param numAfter  The number of messages following the anchor in the update range
     * @param operation The {@link Operation} to apply for the {@link MessageFlag}
     * @param flag      The {@link MessageFlag} to add or remove to the messages
     * @param narrows   The {@link Narrow} expressions to use
     */
    public UpdateMessageFlagsForNarrowApiRequest(
            ZulipHttpClient client,
            int anchor,
            int numBefore,
            int numAfter,
            Operation operation,
            MessageFlag flag,
            Narrow... narrows) {
        super(client);
        putParam(ANCHOR, anchor);
        putParam(NUM_BEFORE, numBefore);
        putParam(NUM_AFTER, numAfter);
        putParam(OP, operation.toString());
        putParam(FLAG, flag.toString());
        putParamAsJsonString(NARROW, narrows);
    }

    /**
     * Sets whether a message with the specified ID matching the narrow should be included in the update range.
     *
     * @param  isIncludeAnchor Whether a message with the specified ID matching the narrow should be included in the update
     *                         range
     * @return                 This {@link UpdateMessageFlagsForNarrowApiRequest} instance
     */
    public UpdateMessageFlagsForNarrowApiRequest withIncludeAnchor(boolean isIncludeAnchor) {
        putParam(INCLUDE_ANCHOR, isIncludeAnchor);
        return this;
    }

    /**
     * Executes The Zulip API request for updating message flags with a narrow.
     *
     * @return                      The result of the update
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public MessageFlagsUpdateResult execute() throws ZulipClientException {
        UpdateMessageFlagsForNarrowApiResponse response = client().post(FLAGS_API_NARROW_PATH, getParams(),
                UpdateMessageFlagsForNarrowApiResponse.class);
        return response.getMessageFlagsUpdateResult();
    }
}
