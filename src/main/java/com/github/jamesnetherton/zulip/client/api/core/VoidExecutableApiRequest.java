package com.github.jamesnetherton.zulip.client.api.core;

import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;

/**
 * REST API requests to be executed that require no result to be returned to the called.
 */
public interface VoidExecutableApiRequest {

    /**
     * Invokes the HTTP client to send the request to the Zulip REST API.
     */
    void execute() throws ZulipClientException;
}
