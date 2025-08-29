package com.github.jamesnetherton.zulip.client.api.navigationview.request;

import static com.github.jamesnetherton.zulip.client.api.navigationview.request.NavigationViewRequestConstants.NAVIGATION_VIEW_WITH_FRAGMENT_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating a navigation view.
 *
 * @see <a href="https://zulip.com/api/edit-navigation-view">https://zulip.com/api/edit-navigation-view</a>
 */
public class UpdateNavigationViewApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String IS_PINNED = "is_pinned";
    public static final String NAME = "name";
    private final String fragment;

    /**
     * Constructs a {@link ZulipApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param fragment A unique identifier for the navigation view
     */
    public UpdateNavigationViewApiRequest(ZulipHttpClient client, String fragment) {
        super(client);
        this.fragment = fragment;
    }

    /**
     * Sets Whether the view appears directly in the sidebar or is hidden.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/edit-navigation-view#parameter-name">https://zulip.com/api/edit-navigation-view#parameter-name</a>
     *
     * @param  isPinned Whether the view appears directly in the sidebar or is hidden
     * @return          This {@link AddNavigationViewApiRequest} instance
     */
    public UpdateNavigationViewApiRequest withIsPinned(boolean isPinned) {
        putParam(IS_PINNED, isPinned);
        return this;
    }

    /**
     * Sets the name for the navigation view.
     *
     * @see         <a href=
     *              "https://zulip.com/api/edit-navigation-view#parameter-name">https://zulip.com/api/edit-navigation-view#parameter-name</a>
     *
     * @param  name The name of the navigation view
     * @return      This {@link AddNavigationViewApiRequest} instance
     */
    public UpdateNavigationViewApiRequest withName(String name) {
        putParam(NAME, name);
        return this;
    }

    /**
     * Executes the Zulip API request for updating a navigation view.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(NAVIGATION_VIEW_WITH_FRAGMENT_API_PATH, fragment);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}
