package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_FILTERS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating a linkifier.
 *
 * @see <a href="https://zulip.com/api/update-linkifier">https://zulip.com/api/update-linkifier</a>
 */
public class UpdateLinkifierApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String PATTERN = "pattern";
    public static final String URL_TEMPLATE = "url_template";

    private final long id;

    /**
     * Constrtucts a {@link UpdateLinkifierApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param id          The id of the linkifier to update
     * @param pattern     The regular expression that should trigger the linkifier
     * @param urlTemplate The RFC 6570 compliant URL template used for the link
     */
    public UpdateLinkifierApiRequest(ZulipHttpClient client, long id, String pattern, String urlTemplate) {
        super(client);
        putParam(PATTERN, pattern);
        putParam(URL_TEMPLATE, urlTemplate);
        this.id = id;
    }

    /**
     * Executes the Zulip API request for updating a linkifier.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(REALM_FILTERS_WITH_ID, this.id);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}
