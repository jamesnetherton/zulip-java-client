package com.github.jamesnetherton.zulip.client.api.navigationview.request;

import static com.github.jamesnetherton.zulip.client.api.navigationview.request.NavigationViewRequestConstants.NAVIGATION_VIEW_WITH_FRAGMENT_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a navigation view.
 *
 * @see <a href="https://zulip.com/api/remove-navigation-view">https://zulip.com/api/remove-navigation-view</a>
 */
public class DeleteNavigationViewApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    private final String fragment;

    /**
     * Constructs a {@link DeleteNavigationViewApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param fragment The unique identifier of the navigation view to delete
     */
    public DeleteNavigationViewApiRequest(ZulipHttpClient client, String fragment) {
        super(client);
        this.fragment = fragment;
    }

    /**
     * Executes the Zulip API request for deleting a navigation view.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(NAVIGATION_VIEW_WITH_FRAGMENT_API_PATH, fragment);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
