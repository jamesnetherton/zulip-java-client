package com.github.jamesnetherton.zulip.client.http;

import com.github.jamesnetherton.zulip.client.http.commons.ZulipCommonsHttpClientFactory;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

/**
 * Provides configuration options for the Zulip HTTP client library.
 */
public class ZulipConfiguration {

    private String apiKey;
    private String email;
    private boolean insecure;
    private URL proxyUrl;
    private String proxyUsername;
    private String proxyPassword;
    private ZulipHttpClientFactory zulipHttpClientFactory = new ZulipCommonsHttpClientFactory();
    private URL zulipUrl;

    /**
     * Constructs a {@link ZulipConfiguration}
     * 
     * @param zulipUrl The URL of the Zulip server
     * @param email    The user email address to use for authentication
     * @param apiKey   The user API key to use for authentication
     */
    public ZulipConfiguration(URL zulipUrl, String email, String apiKey) {
        if (zulipUrl == null) {
            throw new IllegalArgumentException("Zulip site url cannot be null");
        }

        if (email == null) {
            throw new IllegalArgumentException("Zulip email cannot be null");
        }

        if (apiKey == null) {
            throw new IllegalArgumentException("Zulip api key cannot be null");
        }

        this.zulipUrl = zulipUrl;
        this.email = email;
        this.apiKey = apiKey;
    }

    private ZulipConfiguration() {
    }

    public String getApiKey() {
        return apiKey;
    }

    /**
     * Sets the API key to use for authenticating with the Zulip server
     * 
     * @param apiKey The user API key
     */
    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    /**
     * Sets the email address to use for authenticating with the Zulip server
     * 
     * @param email The user email address
     */
    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    /**
     * Whether to trust all SSL certificates. <b>NOT</b> recommended for production usage.
     *
     * @param insecure {@code true} if unknown certificates should be trusted. {@code false} to not trust unknown certificates
     *                 and to receive an exception
     */
    public void setInsecure(boolean insecure) {
        this.insecure = insecure;
    }

    public boolean isInsecure() {
        return insecure;
    }

    /**
     * The full URL to the proxy server that is to be used for Zulip API requests.
     * 
     * @param proxyUrl The {@link URL} representing the proxy server URL
     */
    public void setProxyUrl(URL proxyUrl) {
        this.proxyUrl = proxyUrl;
    }

    public URL getProxyUrl() {
        return proxyUrl;
    }

    /**
     * The proxy server username to authenticate with the proxy server when making Zulip API requests.
     * 
     * @param proxyUsername The proxy server username
     */
    public void setProxyUsername(String proxyUsername) {
        this.proxyUsername = proxyUsername;
    }

    public String getProxyUsername() {
        return proxyUsername;
    }

    /**
     * The proxy server password to authenticate with the proxy server when making Zulip API requests.
     * 
     * @param proxyPassword The proxy server password
     */
    public void setProxyPassword(String proxyPassword) {
        this.proxyPassword = proxyPassword;
    }

    public String getProxyPassword() {
        return proxyPassword;
    }

    /**
     * The {@link ZulipHttpClientFactory} to use for configuring the {@link ZulipHttpClient}.
     *
     * @param zulipHttpClientFactory The client factory implementation to use
     */
    public void setZulipHttpClientFactory(ZulipHttpClientFactory zulipHttpClientFactory) {
        if (zulipHttpClientFactory == null) {
            throw new IllegalArgumentException("Zulip HTTP client factory cannot be null");
        }
        this.zulipHttpClientFactory = zulipHttpClientFactory;
    }

    public ZulipHttpClientFactory getZulipHttpClientFactory() {
        return zulipHttpClientFactory;
    }

    /**
     * The {@link URL} for the Zulip server. Note this should be the base url without the /api/v1 suffix.
     * 
     * @param zulipUrl The Zulip server URL
     */
    public void setZulipUrl(URL zulipUrl) {
        this.zulipUrl = zulipUrl;
    }

    public URL getZulipUrl() {
        return zulipUrl;
    }

    /**
     * Creates a {@link ZulipConfiguration} instance from a zuliprc properties file that is stored
     * within the user home directory.
     *
     * @return The {@link ZulipConfiguration} created from the properties within the zuliprc file
     */
    public static ZulipConfiguration fromZuliprc() {
        String home = System.getProperty("user.home");
        if (home == null) {
            throw new IllegalStateException("Unable to create configuration. The user.home system property is not available");
        }

        File file = Paths.get(home, "zuliprc").toFile();
        return fromZuliprc(file);
    }

    /**
     * Creates a {@link ZulipConfiguration} instance from the specified zuliprc properties file.
     *
     * @return The {@link ZulipConfiguration} created from the properties within the zuliprc file
     */
    public static ZulipConfiguration fromZuliprc(File zulipRcFile) {
        if (zulipRcFile == null) {
            throw new IllegalArgumentException("zulipRcFile cannot be null");
        }

        if (!zulipRcFile.exists() || !zulipRcFile.canRead()) {
            throw new IllegalArgumentException("zuliprc file does not exist or is not writable");
        }

        Properties zulipProperties = new Properties();
        try {
            zulipProperties.load(Files.newBufferedReader(zulipRcFile.toPath()));
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }

        String key = (String) zulipProperties.get("key");
        String email = (String) zulipProperties.get("email");
        String site = (String) zulipProperties.get("site");
        String insecureProperty = (String) zulipProperties.get("insecure");

        if (email == null) {
            throw new IllegalArgumentException("email property is not present in zuliprc");
        }

        if (key == null) {
            throw new IllegalArgumentException("key property is not present in zuliprc");
        }

        if (site == null) {
            throw new IllegalArgumentException("site property is not present in zuliprc");
        }

        boolean insecure = false;
        if (insecureProperty != null) {
            insecure = Boolean.parseBoolean(insecureProperty);
        }

        try {
            ZulipConfiguration configuration = new ZulipConfiguration();
            configuration.setEmail(email);
            configuration.setApiKey(key);
            configuration.setZulipUrl(ZulipUrlUtils.getZulipApiUrl(site));
            configuration.setInsecure(insecure);
            return configuration;
        } catch (MalformedURLException e) {
            throw new IllegalArgumentException("Site must be a valid URL");
        }
    }
}
