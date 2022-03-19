package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.MESSAGES_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.Anchor;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.response.GetMessagesApiResponse;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.api.narrow.NarrowableApiRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for searching and getting messages.
 *
 * @see <a href="https://zulip.com/api/get-messages">https://zulip.com/api/get-messages</a>
 */
public class GetMessagesApiRequest extends ZulipApiRequest
        implements NarrowableApiRequest<GetMessagesApiRequest>, ExecutableApiRequest<List<Message>> {

    public static final String ANCHOR = "anchor";
    public static final String GRAVATAR = "gravatar";
    public static final String MARKDOWN = "apply_markdown";
    public static final String NARROW = "narrow";
    public static final String NUM_AFTER = "num_after";
    public static final String NUM_BEFORE = "num_before";

    /**
     * Constructs a {@link GetMessagesApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetMessagesApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the optional {@link Anchor} to filter and restrict messages.
     *
     * @see           <a href=
     *                "https://zulip.com/api/get-messages#parameter-anchor">https://zulip.com/api/get-messages#parameter-anchor</a>
     *
     * @param  anchor The anchor value
     * @return        This {@link GetMessagesApiRequest} instance
     */
    public GetMessagesApiRequest withAnchor(Anchor anchor) {
        putParam(ANCHOR, anchor.toString());
        return this;
    }

    /**
     * Sets the optional message id anchor to filter and restrict messages.
     *
     * @see              <a href=
     *                   "https://zulip.com/api/get-messages#parameter-anchor">https://zulip.com/api/get-messages#parameter-anchor</a>
     *
     * @param  messageId The message id anchor value
     * @return           This {@link GetMessagesApiRequest} instance
     */
    public GetMessagesApiRequest withAnchor(long messageId) {
        putParam(ANCHOR, Long.toString(messageId));
        return this;
    }

    /**
     * Sets the mandatory number of messages with ids less than the anchor to retrieve.
     *
     * @see              <a href=
     *                   "https://zulip.com/api/get-messages#parameter-num_before">https://zulip.com/api/get-messages#parameter-num_before</a>
     *
     * @param  numBefore The number of messages with ids less than the anchor to retrieve
     * @return           This {@link GetMessagesApiRequest} instance
     */
    public GetMessagesApiRequest withNumBefore(int numBefore) {
        putParam(NUM_BEFORE, numBefore);
        return this;
    }

    /**
     * Sets the mandatory number of messages with ids greater than the anchor to retrieve.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/get-messages#parameter-num_after">https://zulip.com/api/get-messages#parameter-num_after</a>
     *
     * @param  numAfter The number of messages with ids greater than the anchor to retrieve
     * @return          This {@link GetMessagesApiRequest} instance
     */
    public GetMessagesApiRequest withNumAfter(int numAfter) {
        putParam(NUM_AFTER, numAfter);
        return this;
    }

    /**
     * Sets the optional narrow to fetch messages from.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/get-messages#parameter-narrow">https://zulip.com/api/get-messages#parameter-narrow</a>
     *
     * @param  narrows One or more {@link Narrow} expressions
     * @return         This {@link GetMessagesApiRequest} instance
     */
    @Override
    public GetMessagesApiRequest withNarrows(Narrow... narrows) {
        putParamAsJsonString(NARROW, narrows);
        return this;
    }

    /**
     * Sets the optional choice of whether to return the users gravatar URL int the response.
     *
     * @see                   <a href=
     *                        "https://zulip.com/api/get-messages#parameter-client_gravatar">https://zulip.com/api/get-messages#parameter-client_gravatar</a>
     *
     * @param  clientGravatar {@code true} if the gravatar should be included in the response. {@code False} if the gravatar
     *                        should not be included
     * @return                This {@link GetMessagesApiRequest} instance
     */
    public GetMessagesApiRequest withGravatar(boolean clientGravatar) {
        putParam(GRAVATAR, clientGravatar);
        return this;
    }

    /**
     * Sets the optional choice of message content should be returned in the rendered HTML format.
     *
     * @see                  <a href=
     *                       "https://zulip.com/api/get-messages#parameter-apply_markdown">https://zulip.com/api/get-messages#parameter-apply_markdown</a>
     *
     * @param  applyMarkdown {@code true} if to return rendered HTML. {@code false} if markdown should be returned
     * @return               This {@link GetMessagesApiRequest} instance
     */
    public GetMessagesApiRequest withMarkdown(boolean applyMarkdown) {
        putParam(MARKDOWN, applyMarkdown);
        return this;
    }

    /**
     * Executes the Zulip API request for editing a message.
     *
     * @return                      List of {@link Message} objects that matched the search criteria
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Message> execute() throws ZulipClientException {
        GetMessagesApiResponse response = client().get(MESSAGES_API_PATH, getParams(), GetMessagesApiResponse.class);
        return response.getMessages();
    }
}
