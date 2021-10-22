package com.github.jamesnetherton.zulip.client;

import static com.github.tomakehurst.wiremock.client.WireMock.aMultipart;
import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.equalTo;
import static com.github.tomakehurst.wiremock.client.WireMock.request;
import static com.github.tomakehurst.wiremock.client.WireMock.urlPathEqualTo;
import static com.github.tomakehurst.wiremock.core.WireMockConfiguration.options;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import com.github.tomakehurst.wiremock.WireMockServer;
import com.github.tomakehurst.wiremock.common.ConsoleNotifier;
import com.github.tomakehurst.wiremock.matching.RegexPattern;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import org.apache.commons.io.IOUtils;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;

public class ZulipApiTestBase {

    protected static final String SUCCESS_JSON = "/com/github/jamesnetherton/zulip/client/success.json";
    protected static WireMockServer server;
    protected static Zulip zulip;

    @BeforeAll
    public static void beforeAll() throws ZulipClientException {
        server = new WireMockServer(options()
                .dynamicPort()
                .stubRequestLoggingDisabled(false)
                .notifier(new ConsoleNotifier(false)));
        server.start();

        zulip = new Zulip.Builder()
                .email("test@test.com")
                .apiKey("test-key")
                .site("http://localhost:" + server.port())
                .build();
    }

    @AfterAll
    public static void afterAll() {
        if (server != null) {
            server.stop();
        }

        if (zulip != null) {
            zulip.close();
        }
    }

    protected void stubZulipResponse(HttpMethod method, String path, Map<String, StringValuePattern> params)
            throws IOException {
        stubZulipResponse(method, path, params, SUCCESS_JSON);
    }

    protected void stubZulipResponse(HttpMethod method, String path, String stubbedResponse) throws IOException {
        stubZulipResponse(method, path, new HashMap<>(), stubbedResponse);
    }

    protected void stubZulipResponse(HttpMethod method, String path, Map<String, StringValuePattern> params,
            String stubbedResponse) throws IOException {
        server.stubFor(request(method.name(), urlPathEqualTo("/" + ZulipUrlUtils.API_BASE_PATH + path))
                .withQueryParams(params)
                .willReturn(aResponse()
                        .withHeader("Content-Type", "application/json")
                        .withBody(getStubbedResponse(stubbedResponse))));
    }

    protected void stubMultiPartZulipResponse(HttpMethod method, String path, String stubbedResponse) throws IOException {
        server.stubFor(request(method.name(), urlPathEqualTo("/" + ZulipUrlUtils.API_BASE_PATH + path))
                .withMultipartRequestBody(
                        aMultipart()
                                .withName("files")
                                .withHeader("Content-Type", equalTo("application/octet-stream"))
                                .withBody(equalTo("test content")))
                .willReturn(aResponse()
                        .withHeader("Content-Type", "application/json")
                        .withBody(getStubbedResponse(stubbedResponse))));
    }

    protected byte[] getStubbedResponse(String resourceName) throws IOException {
        InputStream resourceAsStream = getClass().getResourceAsStream(resourceName);
        if (resourceAsStream == null) {
            throw new IllegalStateException("Resource: " + resourceName + " could not be found");
        }

        return IOUtils.toByteArray(resourceAsStream);
    }

    protected static final class QueryParams {
        private Map<String, StringValuePattern> params = new HashMap<>();

        public static QueryParams create() {
            return new QueryParams();
        }

        public QueryParams add(String name, String value) {
            params.put(name, new RegexPattern(value));
            return this;
        }

        public QueryParams addAsJsonString(String name, Object value) throws JsonProcessingException {
            String json = JsonUtils.getMapper().writeValueAsString(value);
            String sanitized = json.replace("[", "\\[")
                    .replace("]", "\\]")
                    .replace("{", "\\{")
                    .replace("}", "\\}");
            params.put(name, new RegexPattern(sanitized));
            return this;
        }

        public Map<String, StringValuePattern> get() {
            return params;
        }
    }

    public enum HttpMethod {
        DELETE,
        GET,
        PATCH,
        POST,
    }
}
