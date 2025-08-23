package com.github.jamesnetherton.zulip.client.api.navigationview.request;

import static com.github.jamesnetherton.zulip.client.api.navigationview.request.NavigationViewRequestConstants.NAVIGATION_VIEW_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.navigationview.NavigationView;
import com.github.jamesnetherton.zulip.client.api.navigationview.response.GetAllNavigationViewsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all navigation views.
 *
 * @see <a href="https://zulip.com/api/get-navigation-views">https://zulip.com/api/get-navigation-views</a>
 */
public class GetAllNavigationViewsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<NavigationView>> {
    /**
     * Constructs a {@link GetAllNavigationViewsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetAllNavigationViewsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all navigation views.
     *
     * @return                      List of {@link NavigationView}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<NavigationView> execute() throws ZulipClientException {
        return client().get(NAVIGATION_VIEW_API_PATH, getParams(), GetAllNavigationViewsApiResponse.class).getNavigationViews();
    }
}
