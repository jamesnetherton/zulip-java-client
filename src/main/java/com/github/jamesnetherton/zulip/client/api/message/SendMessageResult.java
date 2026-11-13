package com.github.jamesnetherton.zulip.client.api.message;

import com.github.jamesnetherton.zulip.client.api.message.response.SendMessageApiResponse;

/**
 * Defines the result of sending a Zulip message.
 */
public class SendMessageResult {

    private final SendMessageApiResponse delegate;

    public SendMessageResult(SendMessageApiResponse delegate) {
        this.delegate = delegate;
    }

    /**
     * Gets the id of the sent message.
     *
     * @return The id of the sent message
     */
    public long getId() {
        return delegate.getId();
    }

    /**
     * Gets a URL that links directly to the sent message within its conversation. Requires Zulip 13 or later.
     *
     * @return The URL of the sent message, or {@code null} if the server does not provide it
     */
    public String getMessageUrl() {
        return delegate.getMessageUrl();
    }

    /**
     * Gets a Markdown link to the sent message within its conversation, matching the web app's "Copy link to message"
     * feature. Requires Zulip 13 or later.
     *
     * @return The Markdown link to the sent message, or {@code null} if the server does not provide it
     */
    public String getMessageLink() {
        return delegate.getMessageLink();
    }
}
