package com.github.jamesnetherton.zulip.client.exception;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.server.request.GetApiKeyApiRequest;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipResponseFailureTest extends ZulipApiTestBase {

    @Test
    public void errorResponse() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetApiKeyApiRequest.USERNAME, "test@test.com")
                .get();

        stubZulipResponse(HttpMethod.POST, "/dev_fetch_api_key", params, "failure.json");

        try {
            zulip.server().getDevelopmentApiKey("test@test.com").execute();
        } catch (ZulipClientException e) {
            assertEquals("BAD_REQUEST", e.getCode());
            assertEquals("Invalid email 'test@test.com'", e.getMessage());
        }
    }
}
