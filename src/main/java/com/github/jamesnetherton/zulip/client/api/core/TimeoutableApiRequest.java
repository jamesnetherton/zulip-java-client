package com.github.jamesnetherton.zulip.client.api.core;

import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;

/**
 * REST API requests to be executed and return a result of type T.
 */
public interface TimeoutableApiRequest<T> {

    /**
     * Invokes the HTTP client to send the request to the Zulip REST API and returns a response
     * as type T.
     *
     * @param  responseTimeoutSeconds The timeout value in seconds for the response to timeout
     * @return                        The response for type T
     * @throws ZulipClientException   if an error occurs for the API request
     */
    T execute(int responseTimeoutSeconds) throws ZulipClientException;
}
