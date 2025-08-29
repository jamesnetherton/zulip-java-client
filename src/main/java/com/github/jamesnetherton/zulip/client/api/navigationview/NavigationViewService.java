package com.github.jamesnetherton.zulip.client.api.navigationview;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.navigationview.request.AddNavigationViewApiRequest;
import com.github.jamesnetherton.zulip.client.api.navigationview.request.DeleteNavigationViewApiRequest;
import com.github.jamesnetherton.zulip.client.api.navigationview.request.GetAllNavigationViewsApiRequest;
import com.github.jamesnetherton.zulip.client.api.navigationview.request.UpdateNavigationViewApiRequest;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip navigation view APIs.
 */
public class NavigationViewService implements ZulipService {
    private final ZulipHttpClient client;

    /**
     * Constructs a {@link NavigationViewService}.
     *
     * @param client The Zulip HTTP client
     */
    public NavigationViewService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Adds a new navigation view.
     *
     * @see             <a href="https://zulip.com/api/add-navigation-view">https://zulip.com/api/add-navigation-view</a>
     *
     * @param  fragment A unique identifier for the navigation view
     * @param  isPinned Whether the view appears directly in the sidebar or is hidden
     * @return          The {@link AddNavigationViewApiRequest} builder object
     */
    public AddNavigationViewApiRequest addNavigationView(String fragment, boolean isPinned) {
        return new AddNavigationViewApiRequest(this.client, fragment, isPinned);
    }

    /**
     * Deletes a navigation view.
     *
     * @see             <a href="https://zulip.com/api/remove-navigation-view">https://zulip.com/api/remove-navigation-view</a>
     *
     * @param  fragment The unique identifier of the navigation view to be deleted
     * @return          The {@link DeleteNavigationViewApiRequest} builder object
     */
    public DeleteNavigationViewApiRequest deleteNavigationView(String fragment) {
        return new DeleteNavigationViewApiRequest(this.client, fragment);
    }

    /**
     * Gets all navigation views.
     *
     * @see    <a href="https://zulip.com/api/get-navigation-views">https://zulip.com/api/get-navigation-views</a>
     *
     * @return The {@link GetAllNavigationViewsApiRequest} builder object
     */
    public GetAllNavigationViewsApiRequest getAllNavigationViews() {
        return new GetAllNavigationViewsApiRequest(this.client);
    }

    /**
     * Updates a navigation view.
     *
     * @see             <a href="https://zulip.com/api/edit-navigation-view">https://zulip.com/api/edit-navigation-view</a>
     *
     * @param  fragment The unique identifier of the navigation view to update
     * @return          The {@link UpdateNavigationViewApiRequest} builder object
     */
    public UpdateNavigationViewApiRequest updateNavigationView(String fragment) {
        return new UpdateNavigationViewApiRequest(this.client, fragment);
    }
}
