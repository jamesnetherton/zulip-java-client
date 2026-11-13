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
    public static final String EXAMPLE_INPUT = "example_input";
    public static final String REVERSE_TEMPLATE = "reverse_template";
    public static final String ALTERNATIVE_URL_TEMPLATES = "alternative_url_templates";

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
     * Sets an example input string that matches the linkifier pattern. Required when setting a reverse template.
     *
     * @see                 <a href=
     *                      "https://zulip.com/api/add-linkifier#parameter-example_input">https://zulip.com/api/add-linkifier#parameter-example_input</a>
     *
     * @param  exampleInput The example input
     * @return              This {@link AddLinkifierApiRequest} instance
     */
    public AddLinkifierApiRequest withExampleInput(String exampleInput) {
        putParam(EXAMPLE_INPUT, exampleInput);
        return this;
    }

    /**
     * Sets the template used to convert a URL back into the text that the linkifier pattern matches.
     *
     * @see                    <a href=
     *                         "https://zulip.com/api/add-linkifier#parameter-reverse_template">https://zulip.com/api/add-linkifier#parameter-reverse_template</a>
     *
     * @param  reverseTemplate The reverse template
     * @return                 This {@link AddLinkifierApiRequest} instance
     */
    public AddLinkifierApiRequest withReverseTemplate(String reverseTemplate) {
        putParam(REVERSE_TEMPLATE, reverseTemplate);
        return this;
    }

    /**
     * Sets additional RFC 6570 compliant URL templates used for reverse linkification.
     *
     * @see                            <a href=
     *                                 "https://zulip.com/api/add-linkifier#parameter-alternative_url_templates">https://zulip.com/api/add-linkifier#parameter-alternative_url_templates</a>
     *
     * @param  alternativeUrlTemplates The alternative URL templates
     * @return                         This {@link AddLinkifierApiRequest} instance
     */
    public AddLinkifierApiRequest withAlternativeUrlTemplates(String... alternativeUrlTemplates) {
        putParamAsJsonString(ALTERNATIVE_URL_TEMPLATES, alternativeUrlTemplates);
        return this;
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
