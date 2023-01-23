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
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import javax.net.ssl.SSLContext;
import org.apache.http.Consts;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpHost;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.AuthCache;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpEntityEnclosingRequestBase;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPatch;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustSelfSignedStrategy;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.auth.BasicScheme;
import org.apache.http.impl.client.BasicAuthCache;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.ssl.SSLContextBuilder;
import org.apache.http.util.EntityUtils;

/**
 * A {@link ZulipHttpClient} implementation that uses the Apache Commons HTTP Client.
 */
public class ZulipCommonsHttpClient implements ZulipHttpClient {

    private static final Logger LOG = Logger.getLogger(ZulipCommonsHttpClient.class.getName());

    private final ZulipConfiguration configuration;
    private CloseableHttpClient client;
    private HttpClientContext context;

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
        UsernamePasswordCredentials credentials = new UsernamePasswordCredentials(configuration.getEmail(),
                configuration.getApiKey());
        CredentialsProvider provider = new BasicCredentialsProvider();
        provider.setCredentials(AuthScope.ANY, credentials);

        HttpClientBuilder builder = HttpClientBuilder.create()
                .setDefaultCredentialsProvider(provider);

        URL zulipUrl = configuration.getZulipUrl();
        HttpHost targetHost = new HttpHost(zulipUrl.getHost(), zulipUrl.getPort(), zulipUrl.getProtocol());
        AuthCache authCache = new BasicAuthCache();
        BasicScheme basicAuth = new BasicScheme();
        authCache.put(targetHost, basicAuth);

        URL proxyUrl = configuration.getProxyUrl();
        if (proxyUrl != null) {
            HttpHost proxyHost = new HttpHost(proxyUrl.getHost(), proxyUrl.getPort(), proxyUrl.getProtocol());
            builder.setProxy(proxyHost);

            String proxyUsername = configuration.getProxyUsername();
            String proxyPassword = configuration.getProxyPassword();
            if (proxyUsername != null && !proxyUsername.isEmpty() && proxyPassword != null && !proxyPassword.isEmpty()) {
                provider.setCredentials(
                        new AuthScope(proxyHost.getHostName(), proxyHost.getPort()),
                        new UsernamePasswordCredentials(proxyUsername, proxyPassword));
            }
        }

        context = HttpClientContext.create();
        context.setCredentialsProvider(provider);
        context.setAuthCache(authCache);

        if (configuration.isInsecure()) {
            try {
                SSLContextBuilder sslContextBuilder = new SSLContextBuilder();
                sslContextBuilder.loadTrustMaterial(null, new TrustSelfSignedStrategy());
                SSLContext sslContext = sslContextBuilder.build();
                SSLConnectionSocketFactory sslConnectionSocketFactory = new SSLConnectionSocketFactory(sslContext,
                        NoopHostnameVerifier.INSTANCE);
                builder.setSSLSocketFactory(sslConnectionSocketFactory);
            } catch (NoSuchAlgorithmException | KeyStoreException | KeyManagementException e) {
                throw new ZulipClientException(e);
            }
        }

        this.client = builder.build();
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
    	URI requestUri = getRequestUri(path, null);

        HttpPatch request = new HttpPatch(requestUri);
        request = (HttpPatch) setFormData(request, parameters);
        return doRequest(new HttpPatch(requestUri), responseAs);
    }

    @Override
    public <T extends ZulipApiResponse> T post(String path, Map<String, Object> parameters, Class<T> responseAs)
            throws ZulipClientException {
        URI requestUri = getRequestUri(path, null);
        HttpPost request = new HttpPost(requestUri);
        request = (HttpPost) setFormData(request, parameters);

        return doRequest(request, responseAs);
    }

    private HttpEntityEnclosingRequestBase setFormData(
        HttpEntityEnclosingRequestBase request, Map<String, Object> parameters)
        throws ZulipClientException {
      if (parameters != null) {
        List<NameValuePair> urlParameters = new ArrayList<>();
        for (Map.Entry<String, Object> entry : parameters.entrySet()) {
          if (entry.getValue() != null) {
            urlParameters.add(new BasicNameValuePair(entry.getKey(),
                entry.getValue().toString()));
          }
        }

        try {
          request.setEntity(new UrlEncodedFormEntity(urlParameters, Consts.UTF_8));
        } catch (UnsupportedEncodingException e) {
          throw new ZulipClientException(e);
        }
      }
      return request;
    }

    @Override
    public <T extends ZulipApiResponse> T upload(String path, File file, Class<T> responseAs) throws ZulipClientException {
        HttpEntity entity = MultipartEntityBuilder.create()
                .addBinaryBody("files", file)
                .build();

        HttpPost httpPost = new HttpPost(getRequestUri(path, null));
        httpPost.setEntity(entity);

        return doRequest(httpPost, responseAs);
    }

    private <T extends ZulipApiResponse> T doRequest(HttpUriRequest request, Class<T> responseAs) throws ZulipClientException {
        try {
            ResponseHolder response = client.execute(request, new ResponseHandler<ResponseHolder>() {
                @Override
                public ResponseHolder handleResponse(HttpResponse response) throws IOException {
                    Header header = response.getFirstHeader("x-ratelimit-reset");
                    int status = response.getStatusLine().getStatusCode();
                    if ((status >= 200 && status < 300) || (status == 400)) {
                        HttpEntity entity = response.getEntity();
                        if (entity != null) {
                            String json = EntityUtils.toString(entity);
                            ZulipApiResponse zulipApiResponse = JsonUtils.getMapper().readValue(json, responseAs);
                            return new ResponseHolder(zulipApiResponse, status, header);
                        } else {
                            return new ResponseHolder(null, status, header);
                        }
                    } else if (status == 429) {
                        return new ResponseHolder(null, status, header);
                    } else {
                        throw new ClientProtocolException("Unexpected response status: " + status);
                    }
                }
            }, context);

            if (response.getStatusCode() == 429) {
                ZulipRateLimitExceededException rateLimitExceededException = new ZulipRateLimitExceededException(
                        response.getRateLimitReset());
                throw new ZulipClientException(rateLimitExceededException);
            }

            ZulipApiResponse zulipApiResponse = response.getResponse();
            if (zulipApiResponse == null) {
                throw new ZulipClientException("Response was empty");
            }

            if (!zulipApiResponse.isSuccess()) {
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
