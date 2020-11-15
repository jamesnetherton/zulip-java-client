package com.github.jamesnetherton.zulip.client.util;

import java.net.MalformedURLException;
import java.net.URL;

/**
 * A utility class to resolve API endpoint.
 */
public class ZulipUrlUtils {

    public static final String API = "api";
    public static final String V1 = "v1";
    public static final String API_BASE_PATH = API + "/" + V1;

    private ZulipUrlUtils() {
        // Utility class
    }

    /**
     * Returns the URL to a Zulip API endpoint.
     *
     * @param  baseUrl               The base URL of the Zulip server
     * @return                       The {@link URL} of the Zulip API
     * @throws MalformedURLException if the URL is invalid
     */
    public static URL getZulipApiUrl(String baseUrl) throws MalformedURLException {
        return new URL(baseUrl);
    }
}
