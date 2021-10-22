package com.github.jamesnetherton.zulip.client.http;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.http.commons.ZulipCommonsHttpClientFactory;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;
import org.junit.jupiter.api.Test;

public class ZulipConfigurationTest {

    private static final String EMAIL = "test@test.com";
    private static final String KEY = "test-key";
    private static final String SITE = "http://zulip.localhost.net/zulip";

    @Test
    public void validConfigurationFromCustomFile() throws IOException {
        File zuliprc = createZuliprc(EMAIL, KEY, SITE);
        ZulipConfiguration configuration = ZulipConfiguration.fromZuliprc(zuliprc);
        assertEquals(EMAIL, configuration.getEmail());
        assertEquals(KEY, configuration.getApiKey());
        assertEquals(SITE, configuration.getZulipUrl().toString());
        assertTrue(configuration.isInsecure());
    }

    @Test
    public void validConfiguration() throws IOException {
        File zuliprc = createZuliprc(EMAIL, KEY, SITE);
        String oldHome = System.getProperty("user.home");
        try {
            System.setProperty("user.home", zuliprc.getParent());
            ZulipConfiguration configuration = ZulipConfiguration.fromZuliprc();
            assertEquals(EMAIL, configuration.getEmail());
            assertEquals(KEY, configuration.getApiKey());
            assertEquals(SITE, configuration.getZulipUrl().toString());
            assertTrue(configuration.isInsecure());
            assertInstanceOf(ZulipCommonsHttpClientFactory.class, configuration.getZulipHttpClientFactory());
        } finally {
            System.setProperty("user.home", oldHome);
        }
    }

    @Test
    public void missingEmail() throws IOException {
        File zuliprc = createZuliprc(null, KEY, SITE);
        assertThrows(IllegalArgumentException.class, () -> ZulipConfiguration.fromZuliprc(zuliprc));
    }

    @Test
    public void missingKey() throws IOException {
        File zuliprc = createZuliprc(EMAIL, null, SITE);
        assertThrows(IllegalArgumentException.class, () -> ZulipConfiguration.fromZuliprc(zuliprc));
    }

    @Test
    public void missingSite() throws IOException {
        File zuliprc = createZuliprc(EMAIL, KEY, null);
        assertThrows(IllegalArgumentException.class, () -> ZulipConfiguration.fromZuliprc(zuliprc));
    }

    @Test
    public void invalidSiteUrl() throws IOException {
        File zuliprc = createZuliprc(EMAIL, KEY, "invalid url");
        assertThrows(IllegalArgumentException.class, () -> ZulipConfiguration.fromZuliprc(zuliprc));
    }

    @Test
    public void invalidFile() {
        assertThrows(IllegalArgumentException.class, () -> ZulipConfiguration.fromZuliprc(null));

        File zuliprc = new File("/invalid");
        assertThrows(IllegalArgumentException.class, () -> ZulipConfiguration.fromZuliprc(zuliprc));
    }

    @Test
    public void invalidHttpClientFactory() throws MalformedURLException {
        ZulipConfiguration configuration = new ZulipConfiguration(ZulipUrlUtils.getZulipApiUrl(SITE), KEY, EMAIL);
        assertThrows(IllegalArgumentException.class, () -> configuration.setZulipHttpClientFactory(null));
    }

    @Test
    public void nullUserHome() {
        String oldHome = System.getProperty("user.home");
        try {
            System.setProperty("user.home", "/foo/bar");
            assertThrows(IllegalArgumentException.class, () -> {
                ZulipConfiguration.fromZuliprc();
            });
        } finally {
            System.setProperty("user.home", oldHome);
        }
    }

    private File createZuliprc(String email, String key, String site) throws IOException {
        Properties properties = new Properties();

        if (email != null) {
            properties.setProperty("email", email);
        }

        if (key != null) {
            properties.setProperty("key", key);
        }

        if (site != null) {
            properties.setProperty("site", site);
        }

        properties.setProperty("insecure", "true");

        Path path = Paths.get(System.getProperty("java.io.tmpdir"), "zuliprc");
        File zuliprc = path.toFile();
        try (FileOutputStream fos = new FileOutputStream(zuliprc)) {
            properties.store(fos, null);
        }
        return zuliprc;
    }

}
