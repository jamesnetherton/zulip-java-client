package com.github.jamesnetherton.zulip.client.http.jdk;

import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.exception.ZulipRateLimitExceededException;
import com.github.jamesnetherton.zulip.client.http.ZulipConfiguration;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.Authenticator;
import java.net.InetSocketAddress;
import java.net.PasswordAuthentication;
import java.net.ProxySelector;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.time.Duration;
import java.util.Base64;
import java.util.Map;
import java.util.Optional;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

/**
 * A {@link ZulipHttpClient} implementation that uses the JDK HTTP Client.
 */
class ZulipJdkHttpClient implements ZulipHttpClient {

    private final ZulipConfiguration configuration;
    private final String basicAuth;
    private HttpClient client;
    private volatile boolean closed = false;

    /**
     * Constructs a {@link ZulipJdkHttpClient}.
     *
     * @param  configuration        The configuration for the HTTP client
     * @throws ZulipClientException if configuration of the HTTP client fails
     */
    public ZulipJdkHttpClient(ZulipConfiguration configuration) throws ZulipClientException {
        if (configuration == null) {
            throw new IllegalArgumentException("ZulipConfiguration cannot be null");
        }

        this.configuration = configuration;
        String credentials = configuration.getEmail() + ":" + configuration.getApiKey();
        this.basicAuth = "Basic " + Base64.getEncoder().encodeToString(credentials.getBytes(StandardCharsets.UTF_8));
        configure();
    }

    /**
     * Configures the HTTP client.
     *
     * @throws ZulipClientException if configuration fails
     */
    public void configure() throws ZulipClientException {
        HttpClient.Builder builder = HttpClient.newBuilder();

        URL proxyUrl = configuration.getProxyUrl();
        if (proxyUrl != null) {
            int proxyPort = proxyUrl.getPort();
            if (proxyPort == -1) {
                proxyPort = proxyUrl.getProtocol().equals("https") ? 443 : 80;
            }
            InetSocketAddress proxyAddress = new InetSocketAddress(proxyUrl.getHost(), proxyPort);
            builder.proxy(ProxySelector.of(proxyAddress));

            String proxyUsername = configuration.getProxyUsername();
            String proxyPassword = configuration.getProxyPassword();
            if (proxyUsername != null && !proxyUsername.isEmpty() && proxyPassword != null && !proxyPassword.isEmpty()) {
                builder.authenticator(new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(proxyUsername, proxyPassword.toCharArray());
                    }
                });
            }
        }

        if (configuration.isInsecure()) {
            try {
                TrustManager[] trustAllCerts = new TrustManager[] {
                        new X509TrustManager() {
                            @Override
                            public void checkClientTrusted(X509Certificate[] chain, String authType) {
                            }

                            @Override
                            public void checkServerTrusted(X509Certificate[] chain, String authType) {
                            }

                            @Override
                            public X509Certificate[] getAcceptedIssuers() {
                                return new X509Certificate[0];
                            }
                        }
                };
                SSLContext sslContext = SSLContext.getInstance("TLS");
                sslContext.init(null, trustAllCerts, new SecureRandom());
                SSLParameters sslParameters = new SSLParameters();
                sslParameters.setEndpointIdentificationAlgorithm("");
                builder.sslContext(sslContext).sslParameters(sslParameters);
            } catch (NoSuchAlgorithmException | KeyManagementException e) {
                throw new ZulipClientException(e);
            }
        }

        this.client = builder.build();
    }

    @Override
    public <T extends ZulipApiResponse> T get(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        HttpRequest request = HttpRequest.newBuilder()
                .GET()
                .uri(getRequestUri(path, parameters))
                .header("Authorization", basicAuth)
                .build();
        return doRequest(request, responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T get(String path, Map<String, Object> parameters, int responseTimeoutSeconds,
            Class<T> responseAs) throws ZulipClientException {
        HttpRequest request = HttpRequest.newBuilder()
                .GET()
                .uri(getRequestUri(path, parameters))
                .header("Authorization", basicAuth)
                .timeout(Duration.ofSeconds(responseTimeoutSeconds))
                .build();
        return doRequest(request, responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T delete(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        HttpRequest request = HttpRequest.newBuilder()
                .DELETE()
                .uri(getRequestUri(path, parameters))
                .header("Authorization", basicAuth)
                .build();
        return doRequest(request, responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T patch(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        HttpRequest request = HttpRequest.newBuilder()
                .method("PATCH", buildFormBody(parameters))
                .uri(getRequestUri(path, null))
                .header("Authorization", basicAuth)
                .header("Content-Type", "application/x-www-form-urlencoded")
                .build();
        return doRequest(request, responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T post(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        HttpRequest request = HttpRequest.newBuilder()
                .POST(buildFormBody(parameters))
                .uri(getRequestUri(path, null))
                .header("Authorization", basicAuth)
                .header("Content-Type", "application/x-www-form-urlencoded")
                .build();
        return doRequest(request, responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T upload(String path, File file, Class<T> responseAs) throws ZulipClientException {
        String boundary = "----ZulipBoundary" + System.currentTimeMillis();
        String contentType;
        try {
            String probed = Files.probeContentType(file.toPath());
            contentType = (probed != null) ? probed : "application/octet-stream";
        } catch (IOException e) {
            contentType = "application/octet-stream";
        }

        byte[] body;
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            baos.write(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
            baos.write(("Content-Disposition: form-data; name=\"files\"; filename=\"" + file.getName() + "\"\r\n")
                    .getBytes(StandardCharsets.UTF_8));
            baos.write(("Content-Type: " + contentType + "\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            baos.write(Files.readAllBytes(file.toPath()));
            baos.write(("\r\n--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));
            body = baos.toByteArray();
        } catch (IOException e) {
            throw new ZulipClientException(e);
        }

        HttpRequest request = HttpRequest.newBuilder()
                .POST(HttpRequest.BodyPublishers.ofByteArray(body))
                .uri(getRequestUri(path, null))
                .header("Authorization", basicAuth)
                .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                .build();
        return doRequest(request, responseAs);
    }

    private <T extends ZulipApiResponse> T doRequest(HttpRequest request, Class<T> responseAs)
            throws ZulipClientException {
        if (closed) {
            throw new IllegalStateException("HTTP client is closed");
        }

        try {
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            int status = response.statusCode();

            if (status == 429) {
                long reset = 0;
                Optional<String> rateLimitHeader = response.headers().firstValue("x-ratelimit-reset");
                if (rateLimitHeader.isPresent() && !rateLimitHeader.get().isEmpty()) {
                    try {
                        reset = Long.parseLong(rateLimitHeader.get());
                    } catch (NumberFormatException ignored) {
                    }
                }
                throw new ZulipClientException(new ZulipRateLimitExceededException(reset));
            }

            if ((status >= 200 && status < 300) || status == 400) {
                String body = response.body();
                ZulipApiResponse zulipApiResponse;
                try {
                    zulipApiResponse = (body != null && !body.isEmpty())
                            ? JsonUtils.getMapper().readValue(body, responseAs)
                            : null;
                } catch (IOException e) {
                    zulipApiResponse = new ZulipApiResponse();
                }

                if (zulipApiResponse == null) {
                    throw new ZulipClientException("Response was empty");
                }

                if (!zulipApiResponse.isSuccess() && !zulipApiResponse.isPartiallyCompleted()) {
                    throw new ZulipClientException(zulipApiResponse.getResponseMessage(), zulipApiResponse.getResponseCode());
                }

                return responseAs.cast(zulipApiResponse);
            }

            throw new ZulipClientException("Unexpected response status: " + status);
        } catch (IOException | InterruptedException e) {
            throw new ZulipClientException(e);
        }
    }

    private URI getRequestUri(String path, Map<String, Object> parameters) throws ZulipClientException {
        URL zulipUrl = configuration.getZulipUrl();
        StringBuilder sb = new StringBuilder();
        sb.append(zulipUrl.getProtocol()).append("://").append(zulipUrl.getHost());
        if (zulipUrl.getPort() != -1) {
            sb.append(":").append(zulipUrl.getPort());
        }
        sb.append("/").append(ZulipUrlUtils.API_BASE_PATH).append("/");

        String[] segments = path.split("/", -1);
        for (int i = 0; i < segments.length; i++) {
            if (i > 0) {
                sb.append("/");
            }
            sb.append(URLEncoder.encode(segments[i], StandardCharsets.UTF_8).replace("+", "%20"));
        }

        String queryString = buildQueryString(parameters);
        if (queryString != null) {
            sb.append("?").append(queryString);
        }

        try {
            return new URI(sb.toString());
        } catch (URISyntaxException e) {
            throw new ZulipClientException(e);
        }
    }

    private String buildQueryString(Map<String, Object> parameters) {
        if (parameters == null || parameters.isEmpty()) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        boolean first = true;
        for (Map.Entry<String, Object> entry : parameters.entrySet()) {
            if (entry.getValue() != null) {
                if (!first) {
                    sb.append("&");
                }
                sb.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8));
                sb.append("=");
                sb.append(URLEncoder.encode(entry.getValue().toString(), StandardCharsets.UTF_8));
                first = false;
            }
        }
        return sb.length() > 0 ? sb.toString() : null;
    }

    private HttpRequest.BodyPublisher buildFormBody(Map<String, Object> parameters) {
        if (parameters == null || parameters.isEmpty()) {
            return HttpRequest.BodyPublishers.noBody();
        }

        StringBuilder sb = new StringBuilder();
        boolean first = true;
        for (Map.Entry<String, Object> entry : parameters.entrySet()) {
            if (entry.getValue() != null) {
                if (!first) {
                    sb.append("&");
                }
                sb.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8));
                sb.append("=");
                sb.append(URLEncoder.encode(entry.getValue().toString(), StandardCharsets.UTF_8));
                first = false;
            }
        }
        return HttpRequest.BodyPublishers.ofString(sb.toString());
    }

    @Override
    public void close() {
        this.closed = true;
    }
}
