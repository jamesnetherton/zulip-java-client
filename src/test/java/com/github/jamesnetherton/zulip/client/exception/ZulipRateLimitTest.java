package com.github.jamesnetherton.zulip.client.exception;

import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.request;
import static com.github.tomakehurst.wiremock.client.WireMock.urlPathEqualTo;
import static org.junit.jupiter.api.Assertions.assertEquals;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.server.request.GetApiKeyApiRequest;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipRateLimitTest extends ZulipApiTestBase {

    @Test
    public void rateLimitExceeded() {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetApiKeyApiRequest.USERNAME, "test@test.com")
                .get();

        server.stubFor(request("POST", urlPathEqualTo("/" + ZulipUrlUtils.API_BASE_PATH + "/dev_fetch_api_key"))
                .withQueryParams(params)
                .willReturn(aResponse()
                        .withHeader("x-ratelimit-reset", "12345")
                        .withStatus(429)));

        try {
            zulip.server().getDevelopmentApiKey("test@test.com").execute();
        } catch (ZulipClientException e) {
            Throwable cause = e.getCause();
            if (cause instanceof ZulipRateLimitExceededException) {
                assertEquals(12345, ((ZulipRateLimitExceededException) cause).getReteLimitReset());
            }
        }
    }
}
