package com.github.jamesnetherton.zulip.client.http.commons;

import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.request;
import static com.github.tomakehurst.wiremock.client.WireMock.urlPathEqualTo;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.Zulip;
import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.exception.ZulipRateLimitExceededException;
import com.github.jamesnetherton.zulip.client.http.ZulipConfiguration;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import org.apache.commons.io.IOUtils;
import org.junit.jupiter.api.Test;

public class ZulipCommonsHttpClientTest extends ZulipApiTestBase {

    @Test
    public void errorResponseCodethrowsZulipClientException() throws Exception {
        server.stubFor(request("GET", urlPathEqualTo("/api/v1/"))
                .willReturn(aResponse()
                        .withStatus(500)
                        .withBody((String) null)));

        URL zulipUrl = new URL(server.baseUrl());

        ZulipConfiguration configuration = new ZulipConfiguration(zulipUrl, "test@test.com", "abc123");
        ZulipCommonsHttpClient client = new ZulipCommonsHttpClient(configuration);

        assertThrows(ZulipClientException.class, () -> {
            client.get("/", Collections.emptyMap(), ZulipApiResponse.class);
        });
    }

    @Test
    public void invalidRateLimitReset() throws Exception {
        server.stubFor(request("GET", urlPathEqualTo("/api/v1/"))
                .willReturn(aResponse()
                        .withStatus(429)
                        .withHeader("x-ratelimit-reset", "")
                        .withBody((String) null)));

        URL zulipUrl = new URL(server.baseUrl());

        ZulipConfiguration configuration = new ZulipConfiguration(zulipUrl, "test@test.com", "abc123");
        ZulipCommonsHttpClient client = new ZulipCommonsHttpClient(configuration);

        try {
            client.get("/", Collections.emptyMap(), ZulipApiResponse.class);
        } catch (ZulipClientException e) {
            ZulipRateLimitExceededException cause = (ZulipRateLimitExceededException) e.getCause();
            assertEquals(0, cause.getReteLimitReset());
        }
    }

    @Test
    public void proxyServer() throws Exception {
        CountDownLatch latch = new CountDownLatch(1);
        FakeServer fakeServer = new FakeServer(latch, false);
        fakeServer.start();

        try {
            Zulip zulip = new Zulip.Builder()
                    .site("http://foo.bar.com")
                    .email("test@test.com")
                    .apiKey("abc123")
                    .proxyUrl("http://localhost:" + fakeServer.getPort())
                    .build();

            zulip.messages().markAllAsRead().execute();

            assertTrue(latch.await(5, TimeUnit.SECONDS));
        } finally {
            fakeServer.stop();
        }
    }

    @Test
    public void proxyServerAuthentication() throws Exception {
        CountDownLatch latch = new CountDownLatch(3);
        FakeServer server = new FakeServer(latch, true);
        server.start();

        try {
            Zulip zulip = new Zulip.Builder()
                    .site("http://foo.bar.com")
                    .email("test@test.com")
                    .apiKey("abc123")
                    .proxyUrl("http://localhost:" + server.getPort())
                    .proxyUsername("foo")
                    .proxyPassword("bar")
                    .build();

            zulip.messages().markAllAsRead().execute();

            assertTrue(latch.await(5, TimeUnit.SECONDS));
        } finally {
            server.stop();
        }
    }

    private class FakeServer {
        private final ServerSocket serverSocket;
        private final ExecutorService executor;
        private final boolean secure;
        private final CountDownLatch latch;
        private boolean proxyAuthHeaderSent;

        private FakeServer(CountDownLatch latch, boolean secure) throws IOException {
            this.serverSocket = new ServerSocket(0);
            this.executor = Executors.newSingleThreadExecutor();
            this.secure = secure;
            this.latch = latch;
        }

        void start() {
            executor.submit(() -> {
                while (true) {
                    try (Socket accept = serverSocket.accept()) {
                        InputStreamReader isr = new InputStreamReader(accept.getInputStream());
                        BufferedReader reader = new BufferedReader(isr);
                        String line = reader.readLine();
                        while (!line.isEmpty()) {
                            if (secure && proxyAuthHeaderSent && line.startsWith("Proxy-Authorization")) {
                                latch.countDown();
                            }

                            if (line.startsWith("Proxy-Connection")) {
                                latch.countDown();
                            }

                            line = reader.readLine();
                        }

                        byte[] response = getStubbedResponse(SUCCESS_JSON);

                        OutputStream outputStream = accept.getOutputStream();

                        if (secure && !proxyAuthHeaderSent) {
                            IOUtils.write("HTTP/1.1 407 Proxy Authentication Required\r\n", outputStream,
                                    StandardCharsets.UTF_8.name());
                            IOUtils.write("Proxy-Authenticate: Basic\r\n", outputStream, StandardCharsets.UTF_8.name());
                            proxyAuthHeaderSent = true;
                            continue;
                        }

                        IOUtils.write("HTTP/1.1 200 OK\r\n", outputStream, StandardCharsets.UTF_8.name());
                        IOUtils.write("Content-Length: " + response.length + "\r\n", outputStream,
                                StandardCharsets.UTF_8.name());
                        IOUtils.write("Content-Type: Application/json\r\n\r\n", outputStream, StandardCharsets.UTF_8.name());
                        IOUtils.write(new String(response), outputStream, StandardCharsets.UTF_8.name());
                    } catch (IOException e) {
                        return;
                    }
                }
            });
        }

        void stop() throws Exception {
            executor.shutdownNow();
            serverSocket.close();
        }

        int getPort() {
            return serverSocket.getLocalPort();
        }
    }
}
