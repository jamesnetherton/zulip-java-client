package com.github.jamesnetherton.zulip.client;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.draft.DraftService;
import com.github.jamesnetherton.zulip.client.api.event.EventService;
import com.github.jamesnetherton.zulip.client.api.message.MessageService;
import com.github.jamesnetherton.zulip.client.api.server.ServerService;
import com.github.jamesnetherton.zulip.client.api.stream.StreamService;
import com.github.jamesnetherton.zulip.client.api.user.UserService;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipConfiguration;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClientFactory;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import java.io.Closeable;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * The Zulip client. The entrypoint to accessing Zulip REST APIs.
 */
public final class Zulip implements Closeable {

    private final Map<Class<? extends ZulipService>, ZulipService> services = new HashMap<>();
    private final ZulipHttpClient client;

    /**
     * Constructs a new {@link Zulip} instance.
     *
     * @param  email                The email address to use for authentication with the Zulip server
     * @param  apiKey               The API key to use for authentication with the Zulip server
     * @param  site                 The URL of the Zulip server
     * @throws ZulipClientException If there was a problem constructing the Zulip client
     */
    public Zulip(String email, String apiKey, String site) throws ZulipClientException {
        try {
            if (email == null) {
                throw new IllegalArgumentException("Zulip email cannot be null");
            }

            if (apiKey == null) {
                throw new IllegalArgumentException("Zulip api key cannot be null");
            }

            if (site == null) {
                throw new IllegalArgumentException("Zulip site url cannot be null");
            }

            URL zulipApiUrl = ZulipUrlUtils.getZulipApiUrl(site);

            ZulipConfiguration configuration = new ZulipConfiguration(zulipApiUrl, email, apiKey);
            ZulipHttpClientFactory factory = configuration.getZulipHttpClientFactory();
            this.client = factory.createZulipHttpClient(configuration);
        } catch (MalformedURLException e) {
            throw new IllegalArgumentException("Site must be a valid URL");
        }
    }

    /**
     * Constructs a new {@link Zulip} instance with the provided {@link ZulipConfiguration}.
     *
     * @param  configuration        The {@link ZulipConfiguration} to use for configuring the Zulip client
     * @throws ZulipClientException If there was a problem constructing the Zulip client
     */
    public Zulip(ZulipConfiguration configuration) throws ZulipClientException {
        if (configuration == null) {
            throw new IllegalArgumentException("Zulip configuration cannot be null");
        }
        ZulipHttpClientFactory factory = configuration.getZulipHttpClientFactory();
        this.client = factory.createZulipHttpClient(configuration);
    }

    /**
     * Access the collection of draft Zulip APIs.
     *
     * @return The {@link DraftService} Zulip draft APIs
     */
    public DraftService drafts() {
        return (DraftService) services.computeIfAbsent(DraftService.class, key -> new DraftService(this.client));
    }

    /**
     * Access the collection of event Zulip APIs.
     *
     * @return The {@link EventService} Zulip event APIs
     */
    public EventService events() {
        return (EventService) services.computeIfAbsent(EventService.class, key -> new EventService(this.client));
    }

    /**
     * Access the collection of message Zulip APIs.
     * 
     * @return The {@link MessageService} Zulip message APIs
     */
    public MessageService messages() {
        return (MessageService) services.computeIfAbsent(MessageService.class, key -> new MessageService(this.client));
    }

    /**
     * Access the collection of server and organization Zulip APIs.
     * 
     * @return The {@link ServerService} Zulip server and organization APIs
     */
    public ServerService server() {
        return (ServerService) services.computeIfAbsent(ServerService.class, key -> new ServerService(this.client));
    }

    /**
     * Access the collection of stream Zulip APIs.
     * 
     * @return The {@link StreamService} Zulip stream APIs
     */
    public StreamService streams() {
        return (StreamService) services.computeIfAbsent(StreamService.class, key -> new StreamService(this.client));
    }

    /**
     * Access the collection of user Zulip APIs.
     * 
     * @return The {@link UserService} Zulip user APIs
     */
    public UserService users() {
        return (UserService) services.computeIfAbsent(UserService.class, key -> new UserService(this.client));
    }

    /**
     * Closes the underlying HTTP client and frees up resources.
     */
    public void close() {
        this.client.close();
    }

    /**
     * Builder class for constructing the Zulip Client.
     */
    public static final class Builder {

        private String apiKey;
        private String email;
        private boolean insecure;
        private String proxyUrl;
        private String proxyUsername;
        private String proxyPassword;
        private String site;
        private ZulipHttpClientFactory httpClientFactory;

        /**
         * Sets the Zulip API key to use for authentication with the Zulip server.
         *
         * @see           <a href="https://zulip.com/api/api-keys">https://zulip.com/api/api-keys</a>
         *
         * @param  apiKey The user API key
         * @return        This {@link Builder} object
         */
        public Builder apiKey(String apiKey) {
            this.apiKey = apiKey;
            return this;
        }

        /**
         * Sets the Zulip email address to use for authentication with the Zulip server.
         * 
         * @param  email The user email address
         * @return       This {@link Builder} object
         */
        public Builder email(String email) {
            this.email = email;
            return this;
        }

        /**
         * Sets a custom {@link ZulipHttpClientFactory} to enable the Zulip client to use an HTTP client other
         * than the default Apache Commons HTTP client.
         *
         * @param  httpClientFactory The {@link ZulipHttpClientFactory} implementation
         * @return                   This {@link Builder} object
         */
        public Builder httpClientFactory(ZulipHttpClientFactory httpClientFactory) {
            this.httpClientFactory = httpClientFactory;
            return this;
        }

        /**
         * Sets whether the Zulip HTTP client should ignore SSL certificate validation errors.
         *
         * This is not recommended for production use.
         * 
         * @param  insecure {@code true} if unknown certificates should be trusted. {@code false} to not trust unknown
         *                  certificates and to receive an exception
         * @return          This {@link Builder} object
         */
        public Builder insecure(boolean insecure) {
            this.insecure = insecure;
            return this;
        }

        /**
         * Sets the proxy server URL that the Zulip HTTP client should use when making requests to
         * the Zulip server.
         * 
         * @param  proxyUrl The proxy server URL
         * @return          This {@link Builder} object
         */
        public Builder proxyUrl(String proxyUrl) {
            this.proxyUrl = proxyUrl;
            return this;
        }

        /**
         * Sets the proxy server user name that the Zulip HTTP client should use when making requests to
         * the Zulip server.
         * 
         * @param  proxyUsername The proxy server username
         * @return               This {@link Builder} object
         */
        public Builder proxyUsername(String proxyUsername) {
            this.proxyUsername = proxyUsername;
            return this;
        }

        /**
         * Sets the proxy server password that the Zulip HTTP client should use when making requests to
         * the Zulip server.
         * 
         * @param  proxyPassword The proxy server password
         * @return               This {@link Builder} object
         */
        public Builder proxyPassword(String proxyPassword) {
            this.proxyPassword = proxyPassword;
            return this;
        }

        /**
         * Sets the URL of the Zulip server.
         * 
         * @param  site The URL of the Zulip server. Note this should be without the /api/v1 suffix.
         * @return      This {@link Builder} object
         */
        public Builder site(String site) {
            this.site = site;
            return this;
        }

        /**
         * Builds a new {@link Zulip} instance.
         * 
         * @return A new {@link Zulip} client object
         */
        public Zulip build() throws ZulipClientException {
            try {
                if (email == null) {
                    throw new IllegalArgumentException("Zulip email cannot be null");
                }

                if (apiKey == null) {
                    throw new IllegalArgumentException("Zulip api key cannot be null");
                }

                if (site == null) {
                    throw new IllegalArgumentException("Zulip site url cannot be null");
                }

                URL zulipApiUrl = ZulipUrlUtils.getZulipApiUrl(site);

                ZulipConfiguration configuration = new ZulipConfiguration(zulipApiUrl, email, apiKey);
                configuration.setInsecure(insecure);

                if (proxyUrl != null) {
                    configuration.setProxyUrl(new URL(proxyUrl));
                    configuration.setProxyPassword(proxyPassword);
                    configuration.setProxyUsername(proxyUsername);
                }

                if (httpClientFactory != null) {
                    configuration.setZulipHttpClientFactory(httpClientFactory);
                }

                return new Zulip(configuration);
            } catch (MalformedURLException e) {
                throw new IllegalArgumentException("Site must be a valid URL");
            }
        }
    }
}
