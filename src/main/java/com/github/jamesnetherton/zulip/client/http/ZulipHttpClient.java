package com.github.jamesnetherton.zulip.client.http;

import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.io.File;
import java.util.Map;

/**
 * An abstraction for implementing a HTTP client for interacting with Zulip APIs.
 */
public interface ZulipHttpClient {

    /**
     * Performs a HTTP GET request on the given API endpoint pathSegments and URL parameters. The response type is
     * determined by the type provided via the responseAs argument.
     * 
     * @param  path       The base pathSegments of the API endpoint
     * @param  parameters Map of URL query parameters that should be used on the API request
     * @param  responseAs The expected class of the API response
     * @return            The {@link ZulipApiResponse}
     */
    <T extends ZulipApiResponse> T get(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException;

    /**
     * Performs a HTTP DELETE request on the given API endpoint path and URL parameters. The response type is
     * determined by the type provided via the responseAs argument.
     *
     * @param  path       The base path of the API endpoint
     * @param  parameters Map of URL query parameters that should be used on the API request
     * @param  responseAs The expected class of the API response
     * @return            The {@link ZulipApiResponse}
     */
    <T extends ZulipApiResponse> T delete(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException;

    /**
     * Performs a HTTP PATCH request on the given API endpoint path and URL parameters. The response type is
     * determined by the type provided via the responseAs argument.
     *
     * @param  path       The base path of the API endpoint
     * @param  parameters Map of URL query parameters that should be used on the API request
     * @param  responseAs The expected class of the API response
     * @return            The {@link ZulipApiResponse}
     */
    <T extends ZulipApiResponse> T patch(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException;

    /**
     * Performs a HTTP POST request on the given API endpoint path and URL parameters. The response type is
     * determined by the type provided via the responseAs argument.
     *
     * @param  path       The base path of the API endpoint
     * @param  parameters Map of URL query parameters that should be used on the API request
     * @param  responseAs The expected class of the API response
     * @return            The {@link ZulipApiResponse}
     */
    <T extends ZulipApiResponse> T post(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException;

    /**
     * Performs a HTTP Multipart form upload of the given file. The response type is
     * determined by the type provided via the responseAs argument.
     *
     * @param  path       The base path of the API endpoint
     * @param  file       The file to upload
     * @param  responseAs The expected class of the API response
     * @return            The {@link ZulipApiResponse}
     */
    <T extends ZulipApiResponse> T upload(String path, File file, Class<T> responseAs) throws ZulipClientException;

    /**
     * Closes the underlying HTTP client.
     */
    void close();
}
