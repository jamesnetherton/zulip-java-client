package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_PLAYGROUNDS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.AddCodePlaygroundApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for adding a code playground.
 *
 * @see <a href="https://zulip.com/api/add-code-playground">https://zulip.com/api/add-code-playground</a>
 */
public class AddCodePlaygroundApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {

    public static final String NAME = "name";
    public static final String PYGMENTS_LANGUAGE = "pygments_language";
    public static final String URL_TEMPLATE = "url_template";

    /**
     * Constructs a {@link AddCodePlaygroundApiRequest}.
     *
     * @param client           The Zulip HTTP client
     * @param name             The name of the playground
     * @param pygmentsLanguage The name of the Pygments language lexer for that programming language
     * @param urlTemplate      The URL template for the playground
     */
    public AddCodePlaygroundApiRequest(ZulipHttpClient client, String name, String pygmentsLanguage, String urlTemplate) {
        super(client);
        putParam(NAME, name);
        putParam(PYGMENTS_LANGUAGE, pygmentsLanguage);
        putParam(URL_TEMPLATE, urlTemplate);
    }

    /**
     * Executes the Zulip API request for adding a code playground.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        AddCodePlaygroundApiResponse response = client().post(REALM_PLAYGROUNDS, getParams(),
                AddCodePlaygroundApiResponse.class);
        return response.getId();
    }
}
