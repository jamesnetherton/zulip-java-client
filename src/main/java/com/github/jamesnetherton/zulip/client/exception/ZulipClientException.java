package com.github.jamesnetherton.zulip.client.exception;

/**
 * Generic exception for any Zulip client error scenarios.
 */
public class ZulipClientException extends Exception {

    private String code;

    /**
     * Constructs a {@link ZulipClientException}.
     *
     * @param message The error message received in the Zulip API response
     */
    public ZulipClientException(String message) {
        super(message);
    }

    /**
     * Constructs a {@link ZulipClientException}.
     *
     * @param message The error message received in the Zulip API response
     * @param code    The error code received in the Zulip API response
     */
    public ZulipClientException(String message, String code) {
        this(message);
        this.code = code;
    }

    /**
     * Constructs a {@link ZulipClientException}.
     *
     * @param e The cause of the exception
     */
    public ZulipClientException(Exception e) {
        super(e);
    }

    /**
     * Gets the Zulip error code associated with the exception.
     *
     * @return The Zulip error code
     */
    public String getCode() {
        return code;
    }
}
