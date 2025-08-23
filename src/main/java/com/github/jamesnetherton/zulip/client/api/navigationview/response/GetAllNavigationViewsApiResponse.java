package com.github.jamesnetherton.zulip.client.api.navigationview.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.navigationview.NavigationView;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all navigation views.
 *
 * @see <a href="https://zulip.com/api/edit-navigation-view#response">https://zulip.com/api/edit-navigation-view#response</a>
 */
public class GetAllNavigationViewsApiResponse extends ZulipApiResponse {
    @JsonProperty
    private List<NavigationView> navigationViews = new ArrayList<>();

    public List<NavigationView> getNavigationViews() {
        return navigationViews;
    }
}
