package com.github.jamesnetherton.zulip.client.api.integration.http;

import static org.junit.jupiter.api.Assertions.assertThrows;

import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import org.junit.jupiter.api.Test;

/**
 * Verifies that the client refuses to send relative path segments interpolated into an API request path, since the server
 * resolves them and serves a different endpoint.
 */
public class ZulipPathTraversalIT extends ZulipIntegrationTestBase {

    @Test
    public void clientRejectsRelativePathSegments() {
        assertThrows(IllegalArgumentException.class,
                () -> zulip.server().deactivateEmoji("../../users/" + ownUser.getUserId()).execute());
        assertThrows(IllegalArgumentException.class,
                () -> zulip.users().getUser("../../json/users/me/subscriptions").execute());
    }
}
