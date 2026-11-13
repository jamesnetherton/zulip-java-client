package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.RENDER_MESSAGE_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.response.RenderMessageApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for rendering message to HTML.
 *
 * @see <a href="https://zulip.com/api/render-message">https://zulip.com/api/render-message</a>
 */
public class RenderMessageApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    public static final String CONTENT = "content";
    public static final String POPULATE_URL_EMBED_DATA = "populate_url_embed_data";

    /**
     * Constructs a {@link RenderMessageApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param content The content of the message to render as HTML
     */
    public RenderMessageApiRequest(ZulipHttpClient client, String content) {
        super(client);
        putParam(CONTENT, content);
    }

    /**
     * Sets whether the server should populate URL embed data for links in the content. Data the server already has is
     * included in the rendered content. The rest is fetched asynchronously and delivered via a {@code url_embed_data}
     * event.
     *
     * @see                         <a href=
     *                              "https://zulip.com/api/render-message#parameter-populate_url_embed_data">https://zulip.com/api/render-message#parameter-populate_url_embed_data</a>
     *
     * @param  populateUrlEmbedData {@code true} to populate URL embed data for the content's links
     * @return                      This {@link RenderMessageApiRequest} instance
     */
    public RenderMessageApiRequest withPopulateUrlEmbedData(boolean populateUrlEmbedData) {
        putParam(POPULATE_URL_EMBED_DATA, populateUrlEmbedData);
        return this;
    }

    /**
     * Executes the Zulip API request for rendering message to HTML.
     *
     * @return                      The rendered message HTML
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        RenderMessageApiResponse response = client().post(RENDER_MESSAGE_API_PATH, getParams(), RenderMessageApiResponse.class);
        return response.getRendered();
    }
}
