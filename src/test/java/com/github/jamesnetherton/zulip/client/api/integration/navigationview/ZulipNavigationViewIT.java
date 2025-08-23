package com.github.jamesnetherton.zulip.client.api.integration.navigationview;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.navigationview.NavigationView;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class ZulipNavigationViewIT extends ZulipIntegrationTestBase {
    @Test
    void navigationViewCrudOperations() throws ZulipClientException {
        // Create
        String fragment = UUID.randomUUID().toString();
        zulip.navigationView().addNavigationView(fragment, true)
                .withName("Test Navigation View")
                .execute();

        // Read
        List<NavigationView> navigationViews = zulip.navigationView().getAllNavigationViews().execute();
        assertEquals(1, navigationViews.size());

        NavigationView navigationView = navigationViews.get(0);
        assertEquals(fragment, navigationView.getFragment());
        assertTrue(navigationView.isPinned());
        assertEquals("Test Navigation View", navigationView.getName());

        // Update
        zulip.navigationView().updateNavigationView(fragment)
                .withIsPinned(false)
                .withName("Updated Navigation View")
                .execute();

        navigationViews = zulip.navigationView().getAllNavigationViews().execute();
        assertEquals(1, navigationViews.size());

        navigationView = navigationViews.get(0);
        assertEquals(fragment, navigationView.getFragment());
        assertFalse(navigationView.isPinned());
        assertEquals("Updated Navigation View", navigationView.getName());

        // Delete
        zulip.navigationView().deleteNavigationView(fragment).execute();

        navigationViews = zulip.navigationView().getAllNavigationViews().execute();
        assertTrue(navigationViews.isEmpty());
    }
}
