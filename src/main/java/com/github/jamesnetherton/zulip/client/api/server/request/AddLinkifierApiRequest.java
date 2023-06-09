package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_FILTERS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.AddLinkifierApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for adding a linkifier.
 *
 * @see <a href="https://zulip.com/api/add-linkifier">https://zulip.com/api/add-linkifier</a>
 */
public class AddLinkifierApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {

    public static final String PATTERN = "pattern";
    public static final String URL_TEMPLATE = "url_template";

    /**
     * Constrtucts a {@link AddLinkifierApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param pattern     The The regular expression that should trigger the linkifier
     * @param urlTemplate The RFC 6570 compliant URL template used for the link
     */
    public AddLinkifierApiRequest(ZulipHttpClient client, String pattern, String urlTemplate) {
        super(client);
        putParam(PATTERN, pattern);
        putParam(URL_TEMPLATE, urlTemplate);
    }

    /**
     * Executes the Zulip API request for adding a linkifier.
     *
     * @return                      The id of the created linkifier
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        AddLinkifierApiResponse response = client().post(REALM_FILTERS, getParams(), AddLinkifierApiResponse.class);
        return response.getId();
    }
}
