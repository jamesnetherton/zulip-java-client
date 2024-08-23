package com.github.jamesnetherton.zulip.client.http.commons;

import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.exception.ZulipRateLimitExceededException;
import com.github.jamesnetherton.zulip.client.http.ZulipConfiguration;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import javax.net.ssl.SSLContext;
import org.apache.hc.client5.http.ClientProtocolException;
import org.apache.hc.client5.http.auth.AuthCache;
import org.apache.hc.client5.http.auth.AuthScope;
import org.apache.hc.client5.http.auth.UsernamePasswordCredentials;
import org.apache.hc.client5.http.classic.methods.HttpDelete;
import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpPatch;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.entity.UrlEncodedFormEntity;
import org.apache.hc.client5.http.entity.mime.MultipartEntityBuilder;
import org.apache.hc.client5.http.impl.auth.BasicAuthCache;
import org.apache.hc.client5.http.impl.auth.BasicCredentialsProvider;
import org.apache.hc.client5.http.impl.auth.BasicScheme;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClientBuilder;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManagerBuilder;
import org.apache.hc.client5.http.io.HttpClientConnectionManager;
import org.apache.hc.client5.http.protocol.HttpClientContext;
import org.apache.hc.client5.http.ssl.NoopHostnameVerifier;
import org.apache.hc.client5.http.ssl.SSLConnectionSocketFactory;
import org.apache.hc.client5.http.ssl.TrustSelfSignedStrategy;
import org.apache.hc.core5.http.ClassicHttpRequest;
import org.apache.hc.core5.http.ClassicHttpResponse;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.NameValuePair;
import org.apache.hc.core5.http.ParseException;
import org.apache.hc.core5.http.io.HttpClientResponseHandler;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.http.message.BasicNameValuePair;
import org.apache.hc.core5.net.URIBuilder;
import org.apache.hc.core5.ssl.SSLContextBuilder;

/**
 * A {@link ZulipHttpClient} implementation that uses the Apache Commons HTTP Client.
 */
class ZulipCommonsHttpClient implements ZulipHttpClient {

    private static final Logger LOG = Logger.getLogger(ZulipCommonsHttpClient.class.getName());

    private final ZulipConfiguration configuration;
    private final ThreadLocal<HttpClientContext> context = new ThreadLocal<>();
    private CloseableHttpClient client;

    /**
     * Constructs a {@link ZulipCommonsHttpClient}.
     *
     * @param  configuration        The configuration for the HTTP client
     * @throws ZulipClientException if configuration of the HTTP client fails
     */
    public ZulipCommonsHttpClient(ZulipConfiguration configuration) throws ZulipClientException {
        if (configuration == null) {
            throw new IllegalArgumentException("ZulipConfiguration cannot be null");
        }

        this.configuration = configuration;
        configure();
    }

    /**
     * Configures the HTTP client.
     *
     * @throws ZulipClientException if configuration fails
     */
    public void configure() throws ZulipClientException {
        URL zulipUrl = configuration.getZulipUrl();
        HttpHost targetHost = new HttpHost(zulipUrl.getProtocol(), zulipUrl.getHost(), zulipUrl.getPort());

        UsernamePasswordCredentials credentials = new UsernamePasswordCredentials(configuration.getEmail(),
                configuration.getApiKey().toCharArray());
        BasicCredentialsProvider provider = new BasicCredentialsProvider();
        provider.setCredentials(new AuthScope(targetHost), credentials);

        HttpClientBuilder builder = HttpClientBuilder.create()
                .setDefaultCredentialsProvider(provider);

        AuthCache authCache = new BasicAuthCache();
        BasicScheme basicAuth = new BasicScheme();
        basicAuth.initPreemptive(credentials);
        authCache.put(targetHost, basicAuth);

        URL proxyUrl = configuration.getProxyUrl();
        if (proxyUrl != null) {
            HttpHost proxyHost = new HttpHost(proxyUrl.getProtocol(), proxyUrl.getHost(), proxyUrl.getPort());
            builder.setProxy(proxyHost);

            String proxyUsername = configuration.getProxyUsername();
            String proxyPassword = configuration.getProxyPassword();
            if (proxyUsername != null && !proxyUsername.isEmpty() && proxyPassword != null && !proxyPassword.isEmpty()) {
                provider.setCredentials(
                        new AuthScope(proxyHost.getHostName(), proxyHost.getPort()),
                        new UsernamePasswordCredentials(proxyUsername, proxyPassword.toCharArray()));
            }
        }

        HttpClientContext httpClientContext = context.get();
        if (httpClientContext == null) {
            httpClientContext = HttpClientContext.create();
            httpClientContext.setCredentialsProvider(provider);
            httpClientContext.setAuthCache(authCache);
            context.set(httpClientContext);
        }

        if (configuration.isInsecure()) {
            try {
                SSLContext sslContext = new SSLContextBuilder()
                        .loadTrustMaterial(null, TrustSelfSignedStrategy.INSTANCE)
                        .build();
                SSLConnectionSocketFactory sslConnectionSocketFactory = new SSLConnectionSocketFactory(sslContext,
                        NoopHostnameVerifier.INSTANCE);
                HttpClientConnectionManager connectionManager = PoolingHttpClientConnectionManagerBuilder
                        .create()
                        .setSSLSocketFactory(sslConnectionSocketFactory)
                        .build();
                builder.setConnectionManager(connectionManager);
            } catch (NoSuchAlgorithmException | KeyStoreException | KeyManagementException e) {
                throw new ZulipClientException(e);
            }
        }

        this.client = builder.useSystemProperties().build();
    }

    @Override
    public <T extends ZulipApiResponse> T get(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        return doRequest(new HttpGet(getRequestUri(path, parameters)), responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T delete(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        return doRequest(new HttpDelete(getRequestUri(path, parameters)), responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T patch(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        HttpPatch request = new HttpPatch(getRequestUri(path, null));
        configureFormEntity(request, parameters);
        return doRequest(request, responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T post(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        HttpPost request = new HttpPost(getRequestUri(path, null));
        configureFormEntity(request, parameters);
        return doRequest(request, responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T upload(String path, File file, Class<T> responseAs) throws ZulipClientException {
        ContentType contentType;
        try {
            contentType = ContentType.create(Files.probeContentType(file.toPath()));
        } catch (IOException e) {
            contentType = ContentType.DEFAULT_BINARY;
        }
        HttpEntity entity = MultipartEntityBuilder.create()
                .addBinaryBody("files", file, contentType, file.getName())
                .build();

        HttpPost httpPost = new HttpPost(getRequestUri(path, null));
        httpPost.setEntity(entity);

        return doRequest(httpPost, responseAs);
    }

    private <T extends ZulipApiResponse> T doRequest(ClassicHttpRequest request, Class<T> responseAs)
            throws ZulipClientException {
        try {
            ResponseHolder response = client.execute(request, context.get(), new HttpClientResponseHandler<ResponseHolder>() {
                @Override
                public ResponseHolder handleResponse(ClassicHttpResponse response) throws IOException {
                    Header header = response.getFirstHeader("x-ratelimit-reset");
                    int status = response.getCode();
                    if ((status >= 200 && status < 300) || (status == 400)) {
                        HttpEntity entity = response.getEntity();
                        if (entity != null) {
                            try {
                                String json = EntityUtils.toString(entity);
                                ZulipApiResponse zulipApiResponse = JsonUtils.getMapper().readValue(json, responseAs);
                                return new ResponseHolder(zulipApiResponse, status, header);
                            } catch (ParseException e) {
                                return new ResponseHolder(new ZulipApiResponse(), status, header);
                            }
                        } else {
                            return new ResponseHolder(null, status, header);
                        }
                    } else if (status == 429) {
                        return new ResponseHolder(null, status, header);
                    } else {
                        throw new ClientProtocolException("Unexpected response status: " + status);
                    }
                }
            });

            if (response.getStatusCode() == 429) {
                ZulipRateLimitExceededException rateLimitExceededException = new ZulipRateLimitExceededException(
                        response.getRateLimitReset());
                throw new ZulipClientException(rateLimitExceededException);
            }

            ZulipApiResponse zulipApiResponse = response.getResponse();
            if (zulipApiResponse == null) {
                throw new ZulipClientException("Response was empty");
            }

            if (!zulipApiResponse.isSuccess() && !zulipApiResponse.isPartiallyCompleted()) {
                throw new ZulipClientException(zulipApiResponse.getResponseMessage(), zulipApiResponse.getResponseCode());
            }

            return responseAs.cast(zulipApiResponse);
        } catch (IOException e) {
            throw new ZulipClientException(e);
        }
    }

    private URI getRequestUri(String path, Map<String, Object> parameters) throws ZulipClientException {
        URL zulipUrl = configuration.getZulipUrl();
        URIBuilder builder = new URIBuilder()
                .setScheme(zulipUrl.getProtocol())
                .setHost(zulipUrl.getHost())
                .setPort(zulipUrl.getPort())
                .setPath(ZulipUrlUtils.API_BASE_PATH + "/" + path);

        if (parameters != null) {
            for (Map.Entry<String, Object> entry : parameters.entrySet()) {
                if (entry.getValue() != null) {
                    builder.addParameter(entry.getKey(), entry.getValue().toString());
                }
            }
        }

        try {
            return builder.build();
        } catch (URISyntaxException e) {
            throw new ZulipClientException(e);
        }
    }

    private void configureFormEntity(ClassicHttpRequest request, Map<String, Object> parameters) {
        List<NameValuePair> urlParameters = new ArrayList<>();
        if (!parameters.isEmpty()) {
            for (Map.Entry<String, Object> entry : parameters.entrySet()) {
                if (entry.getValue() != null) {
                    urlParameters.add(new BasicNameValuePair(entry.getKey(), entry.getValue().toString()));
                }
            }
            request.setEntity(new UrlEncodedFormEntity(urlParameters, StandardCharsets.UTF_8));
        }
    }

    @Override
    public void close() {
        if (this.client != null) {
            try {
                this.client.close();
            } catch (IOException e) {
                LOG.warning(e.getMessage());
            }
        }
    }

    private static final class ResponseHolder {
        private final ZulipApiResponse response;
        private final int statusCode;
        private final Header header;

        private ResponseHolder(ZulipApiResponse response, int statusCode, Header header) {
            this.response = response;
            this.statusCode = statusCode;
            this.header = header;
        }

        public ZulipApiResponse getResponse() {
            return response;
        }

        public int getStatusCode() {
            return statusCode;
        }

        public long getRateLimitReset() {
            long reset = 0;
            if (header != null) {
                String headerValue = header.getValue();
                if (headerValue != null) {
                    try {
                        reset = Long.parseLong(headerValue);
                    } catch (NumberFormatException e) {
                        // Ignored
                    }
                }
            }
            return reset;
        }
    }
}
