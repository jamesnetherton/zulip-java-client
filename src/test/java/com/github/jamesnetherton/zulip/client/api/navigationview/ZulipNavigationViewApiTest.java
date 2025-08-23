package com.github.jamesnetherton.zulip.client.api.navigationview;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.PATCH;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.navigationview.request.AddNavigationViewApiRequest;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

class ZulipNavigationViewApiTest extends ZulipApiTestBase {
    @Test
    void addNavigationView() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddNavigationViewApiRequest.FRAGMENT, "test_fragment")
                .add(AddNavigationViewApiRequest.IS_PINNED, "true")
                .add(AddNavigationViewApiRequest.NAME, "Test Name")
                .get();

        stubZulipResponse(POST, "/navigation_views", params);

        zulip.navigationView().addNavigationView("test_fragment", true)
                .withName("Test Name")
                .execute();

    }

    @Test
    void deleteNavigationView() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create().get();

        stubZulipResponse(DELETE, "/navigation_views/test_fragment", params);

        zulip.navigationView().deleteNavigationView("test_fragment").execute();
    }

    @Test
    void getAllNavigationViews() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create().get();

        stubZulipResponse(GET, "/navigation_views", params, "getAllNavigationViews.json");

        List<NavigationView> navigationViews = zulip.navigationView().getAllNavigationViews().execute();
        assertEquals(2, navigationViews.size());

        for (int i = 1; i <= navigationViews.size(); i++) {
            NavigationView navigationView = navigationViews.get(i - 1);
            assertEquals("fragment/" + i, navigationView.getFragment());
            assertEquals("Test " + i, navigationView.getName());
            if (i == 1) {
                assertFalse(navigationView.isPinned());
            } else {
                assertTrue(navigationView.isPinned());
            }
        }
    }

    @Test
    void updateNavigationView() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddNavigationViewApiRequest.IS_PINNED, "true")
                .add(AddNavigationViewApiRequest.NAME, "Test Name")
                .get();

        stubZulipResponse(PATCH, "/navigation_views/test_fragment", params);

        zulip.navigationView().updateNavigationView("test_fragment")
                .withIsPinned(true)
                .withName("Test Name")
                .execute();

    }
}
