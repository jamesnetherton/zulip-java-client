package com.github.jamesnetherton.zulip.client.api.core;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The default Zulip REST API response object.
 *
 * Some API responses add additional information hence this class can be extended with additional fields.
 *
 * @see <a href="https://zulip.com/api/rest-error-handling">https://zulip.com/api/rest-error-handling</a>
 */
public class ZulipApiResponse {

    @JsonProperty
    private String msg;

    @JsonProperty
    private String result;

    @JsonProperty
    private String code;

    /**
     * Gets the message from the Zulip API response. Usually empty for a successful response.
     *
     * When the response is not successful, the message usually provides additional information
     * about the error.
     *
     * @return The response message
     */
    public String getResponseMessage() {
        return msg;
    }

    /**
     * Gets the code from the Zulip API response. Usually empty for a successful response.
     *
     * When the response is not successful, the code provides additional information
     * about the error.
     *
     * @return The response code
     */
    public String getResponseCode() {
        return code;
    }

    /**
     * Determines whether the Zulip API request was successful.
     *
     * HTTP response codes in the range 40x - 50x will are considered unsuccessful.
     *
     * @return {@code true} if the Zulip API request was successful. {code false} otherwise
     */
    public boolean isSuccess() {
        return result.equals("success");
    }

    /**
     * Determines whether the Zulip API request was partially completed due to a request timeout.
     *
     * @return {@code true} if the Zulip API request was partially completed. {code false} otherwise
     */
    public boolean isPartiallyCompleted() {
        return code != null && code.equals("REQUEST_TIMEOUT") && result.equals("partially_completed");
    }
}
