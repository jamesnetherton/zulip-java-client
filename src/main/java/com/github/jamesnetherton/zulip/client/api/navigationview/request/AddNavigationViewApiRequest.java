package com.github.jamesnetherton.zulip.client.api.navigationview.request;

import static com.github.jamesnetherton.zulip.client.api.navigationview.request.NavigationViewRequestConstants.NAVIGATION_VIEW_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for adding a navigation view.
 *
 * @see <a href="https://zulip.com/api/add-navigation-view">https://zulip.com/api/add-navigation-view</a>
 */
public class AddNavigationViewApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String FRAGMENT = "fragment";
    public static final String IS_PINNED = "is_pinned";
    public static final String NAME = "name";

    /**
     * Constructs a {@link AddNavigationViewApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param fragment A unique identifier for the navigation view
     * @param isPinned Whether the view appears directly in the sidebar or is hidden
     */
    public AddNavigationViewApiRequest(ZulipHttpClient client, String fragment, boolean isPinned) {
        super(client);
        putParam(FRAGMENT, fragment);
        putParam(IS_PINNED, isPinned);
    }

    /**
     * Sets the name for the navigation view.
     *
     * @see         <a href=
     *              "https://zulip.com/api/add-navigation-view#parameter-name">https://zulip.com/api/add-navigation-view#parameter-name</a>
     *
     * @param  name The name of the navigation view
     * @return      This {@link AddNavigationViewApiRequest} instance
     */
    public AddNavigationViewApiRequest withName(String name) {
        putParam(NAME, name);
        return this;
    }

    /**
     * Executes the Zulip API request for adding a navigation view.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(NAVIGATION_VIEW_API_PATH, getParams(), ZulipApiResponse.class);
    }
}
