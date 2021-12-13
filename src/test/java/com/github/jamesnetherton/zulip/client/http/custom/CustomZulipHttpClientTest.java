package com.github.jamesnetherton.zulip.client.http.custom;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.Zulip;
import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.server.request.GetApiKeyApiRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipConfiguration;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClientFactory;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import org.junit.jupiter.api.Test;

public class CustomZulipHttpClientTest extends ZulipApiTestBase {

    @Test
    public void customHttpClientFactory() throws Exception {
        CountDownLatch latch = new CountDownLatch(1);
        Zulip customZulip = new Zulip.Builder()
                .email("test@test.com")
                .apiKey("test-key")
                .site("http://localhost:" + server.port())
                .httpClientFactory(new ZulipJdkHttpClientFactory(latch))
                .build();

        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetApiKeyApiRequest.USERNAME, "test@test.com")
                .add(GetApiKeyApiRequest.PASSWORD, "test")
                .get();

        stubZulipResponse(POST, "/fetch_api_key", params, "/com/github/jamesnetherton/zulip/client/api/server/getApiKey.json");

        String key = customZulip.server().getApiKey("test@test.com", "test").execute();

        assertTrue(latch.await(1, TimeUnit.SECONDS));
        assertEquals("abc123zxy", key);
    }

    static final class ZulipJdkHttpClientFactory implements ZulipHttpClientFactory {
        private final CountDownLatch latch;

        public ZulipJdkHttpClientFactory(CountDownLatch latch) {
            this.latch = latch;
        }

        @Override
        public ZulipHttpClient createZulipHttpClient(ZulipConfiguration configuration) {
            return new ZulipJdkHttpClient(configuration, latch);
        }
    }

    static final class ZulipJdkHttpClient implements ZulipHttpClient {

        private final ZulipConfiguration configuration;
        private final CountDownLatch latch;

        ZulipJdkHttpClient(ZulipConfiguration configuration, CountDownLatch latch) {
            this.configuration = configuration;
            this.latch = latch;
        }

        @Override
        public <T extends ZulipApiResponse> T get(String path, Map<String, Object> parameters, Class<T> responseAs)
                throws ZulipClientException {
            // Noop
            return null;
        }

        @Override
        public <T extends ZulipApiResponse> T delete(String path, Map<String, Object> parameters, Class<T> responseAs)
                throws ZulipClientException {
            // Noop
            return null;
        }

        @Override
        public <T extends ZulipApiResponse> T patch(String path, Map<String, Object> parameters, Class<T> responseAs)
                throws ZulipClientException {
            // Noop
            return null;
        }

        @Override
        public <T extends ZulipApiResponse> T post(String path, Map<String, Object> parameters, Class<T> responseAs)
                throws ZulipClientException {
            latch.countDown();

            StringBuilder builder = new StringBuilder();
            try {
                String credentials = configuration.getEmail() + ":" + configuration.getApiKey();
                String basicAuth = new String(Base64.getEncoder().encode(credentials.getBytes(StandardCharsets.UTF_8)));
                StringBuilder endpoint = new StringBuilder();

                endpoint.append(configuration.getZulipUrl().toString()).append("/api/v1/").append(path).append("?");
                parameters.forEach((key, value) -> {
                    endpoint.append("&");
                    endpoint.append(key);
                    endpoint.append("=");
                    endpoint.append(value);
                });

                URL url = new URL(endpoint.toString());
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setDoOutput(true);
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Authorization", "Basic " + basicAuth);

                try (InputStream stream = connection.getInputStream()) {
                    InputStreamReader reader = new InputStreamReader(stream);
                    BufferedReader bufferedReader = new BufferedReader(reader);
                    String line;
                    while ((line = bufferedReader.readLine()) != null) {
                        builder.append(line);
                    }
                }
                return JsonUtils.getMapper().readValue(builder.toString(), responseAs);
            } catch (Exception e) {
                throw new ZulipClientException(e);
            }
        }

        @Override
        public <T extends ZulipApiResponse> T upload(String path, File file, Class<T> responseAs) throws ZulipClientException {
            // Noop
            return null;
        }

        @Override
        public void close() {
            // Noop
        }
    }
}
