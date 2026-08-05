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

    /**
     * Verifies that a value destined for a single Zulip API request path segment cannot modify the structure of that path.
     *
     * @param  value The value to be interpolated into the request path
     * @return       The unmodified value
     */
    public static String pathSegment(String value) {
        if (value != null && (value.indexOf('/') > -1 || value.indexOf('\\') > -1)) {
            throw new IllegalArgumentException("Zulip API request path value must not contain a path separator: " + value);
        }
        return pathSegments(value);
    }

    /**
     * Verifies that a value destined for one or more Zulip API request path segments cannot traverse outside of the request
     * path that it is interpolated into.
     *
     * @param  value The value to be interpolated into the request path
     * @return       The unmodified value
     */
    public static String pathSegments(String value) {
        if (value == null) {
            return null;
        }

        if (value.indexOf('\\') > -1) {
            throw new IllegalArgumentException("Zulip API request path value must not contain a backslash: " + value);
        }

        if (containsRelativePathSegment(value)) {
            throw new IllegalArgumentException(
                    "Zulip API request path value must not contain relative path segments: " + value);
        }

        return value;
    }

    /**
     * Determines whether a request path contains a segment that a server could resolve to a different path.
     *
     * @param  path The request path to check
     * @return      {@code true} if the path contains a relative path segment. {@code false} otherwise
     */
    public static boolean containsRelativePathSegment(String path) {
        for (String segment : path.split("/", -1)) {
            if (segment.equals(".") || segment.equals("..")) {
                return true;
            }
        }
        return false;
    }
}
