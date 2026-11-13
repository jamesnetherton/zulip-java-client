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
    public static final String EXAMPLE_INPUT = "example_input";
    public static final String REVERSE_TEMPLATE = "reverse_template";
    public static final String ALTERNATIVE_URL_TEMPLATES = "alternative_url_templates";

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
     * Sets an example input string that matches the linkifier pattern. Required when setting a reverse template.
     *
     * @see                 <a href=
     *                      "https://zulip.com/api/update-linkifier#parameter-example_input">https://zulip.com/api/update-linkifier#parameter-example_input</a>
     *
     * @param  exampleInput The example input
     * @return              This {@link UpdateLinkifierApiRequest} instance
     */
    public UpdateLinkifierApiRequest withExampleInput(String exampleInput) {
        putParam(EXAMPLE_INPUT, exampleInput);
        return this;
    }

    /**
     * Sets the template used to convert a URL back into the text that the linkifier pattern matches.
     *
     * @see                    <a href=
     *                         "https://zulip.com/api/update-linkifier#parameter-reverse_template">https://zulip.com/api/update-linkifier#parameter-reverse_template</a>
     *
     * @param  reverseTemplate The reverse template
     * @return                 This {@link UpdateLinkifierApiRequest} instance
     */
    public UpdateLinkifierApiRequest withReverseTemplate(String reverseTemplate) {
        putParam(REVERSE_TEMPLATE, reverseTemplate);
        return this;
    }

    /**
     * Sets additional RFC 6570 compliant URL templates used for reverse linkification.
     *
     * @see                            <a href=
     *                                 "https://zulip.com/api/update-linkifier#parameter-alternative_url_templates">https://zulip.com/api/update-linkifier#parameter-alternative_url_templates</a>
     *
     * @param  alternativeUrlTemplates The alternative URL templates
     * @return                         This {@link UpdateLinkifierApiRequest} instance
     */
    public UpdateLinkifierApiRequest withAlternativeUrlTemplates(String... alternativeUrlTemplates) {
        putParamAsJsonString(ALTERNATIVE_URL_TEMPLATES, alternativeUrlTemplates);
        return this;
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
