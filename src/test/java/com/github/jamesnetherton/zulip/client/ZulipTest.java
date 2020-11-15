package com.github.jamesnetherton.zulip.client;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import org.junit.jupiter.api.Test;

public class ZulipTest {

    @Test
    public void zulipBuilder() throws ZulipClientException {
        Zulip zulip = new Zulip.Builder()
                .email("test@test.com")
                .apiKey("abc123")
                .site("http://zulip.com")
                .insecure(true)
                .proxyUrl("http://proxy.com")
                .proxyUsername("proxy-user")
                .proxyPassword("proxy-password")
                .build();
        assertNotNull(zulip);
    }

    @Test
    public void zulipBuilderInvalid() {
        assertThrows(IllegalArgumentException.class, () -> new Zulip.Builder().email(null).build());
        assertThrows(IllegalArgumentException.class, () -> {
            new Zulip.Builder()
                    .email("test@test.com")
                    .apiKey(null)
                    .build();
        });
        assertThrows(IllegalArgumentException.class, () -> {
            new Zulip.Builder()
                    .email("test@test.com")
                    .apiKey("abc123")
                    .site(null)
                    .build();
        });
        assertThrows(IllegalArgumentException.class, () -> {
            new Zulip.Builder()
                    .email("test@test.com")
                    .apiKey("abc123")
                    .site("invalid")
                    .build();
        });
    }

    @Test
    public void invalidConfiguration() {
        assertThrows(IllegalArgumentException.class, () -> new Zulip(null));
    }

    @Test
    public void zulipCloseTest() throws Exception {
        Zulip zulip = new Zulip.Builder()
                .site("http://foo.com/bar")
                .email("test@test.com")
                .apiKey("abc123")
                .build();

        zulip.close();

        assertThrows(IllegalStateException.class, () -> zulip.users().getOwnUser().execute());
    }
}
