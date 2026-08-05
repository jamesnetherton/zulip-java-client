package com.github.jamesnetherton.zulip.client.http;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

import com.github.jamesnetherton.zulip.client.http.commons.ZulipCommonsHttpClientFactory;
import com.github.jamesnetherton.zulip.client.util.ZulipUrlUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.PosixFileAttributeView;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Handler;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
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
    public void warnsWhenZuliprcIsAccessibleToOtherUsers() throws IOException {
        File zuliprc = createZuliprc(EMAIL, KEY, SITE);
        assumeTrue(Files.getFileStore(zuliprc.toPath()).supportsFileAttributeView(PosixFileAttributeView.class));

        List<LogRecord> logRecords = new ArrayList<>();
        Logger logger = Logger.getLogger(ZulipConfiguration.class.getName());
        Handler handler = new Handler() {
            @Override
            public void publish(LogRecord record) {
                logRecords.add(record);
            }

            @Override
            public void flush() {
            }

            @Override
            public void close() {
            }
        };
        logger.addHandler(handler);

        try {
            Files.setPosixFilePermissions(zuliprc.toPath(), PosixFilePermissions.fromString("rw-------"));
            ZulipConfiguration.fromZuliprc(zuliprc);
            assertTrue(logRecords.isEmpty(), "Expected no warning for a file only the owner can read");

            Files.setPosixFilePermissions(zuliprc.toPath(), PosixFilePermissions.fromString("rw-r--r--"));
            ZulipConfiguration.fromZuliprc(zuliprc);
            assertEquals(1, logRecords.size());
            assertTrue(logRecords.get(0).getMessage().contains("is accessible to other users"));
        } finally {
            logger.removeHandler(handler);
        }
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
    public void certBundle() throws IOException {
        File zuliprc = createZuliprc(EMAIL, KEY, SITE, "/path/to/cert.pem");
        ZulipConfiguration configuration = ZulipConfiguration.fromZuliprc(zuliprc);
        assertEquals("/path/to/cert.pem", configuration.getCertBundle());
    }

    @Test
    public void certBundleNotSet() throws IOException {
        File zuliprc = createZuliprc(EMAIL, KEY, SITE);
        ZulipConfiguration configuration = ZulipConfiguration.fromZuliprc(zuliprc);
        assertNull(configuration.getCertBundle());
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
        return createZuliprc(email, key, site, null);
    }

    private File createZuliprc(String email, String key, String site, String certBundle) throws IOException {
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

        if (certBundle != null) {
            properties.setProperty("cert_bundle", certBundle);
        }

        properties.setProperty("insecure", "true");

        Path path = Paths.get(System.getProperty("java.io.tmpdir"), "zuliprc");
        File zuliprc = path.toFile();
        try (FileOutputStream fos = new FileOutputStream(zuliprc)) {
            properties.store(fos, null);
        }

        try {
            Files.setPosixFilePermissions(path, PosixFilePermissions.fromString("rw-------"));
        } catch (UnsupportedOperationException e) {
            // Not a POSIX file system
        }

        return zuliprc;
    }

}
