package com.github.jamesnetherton.zulip.client.api.draft.request;

import static com.github.jamesnetherton.zulip.client.api.draft.request.DraftRequestConstants.DRAFTS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.draft.Draft;
import com.github.jamesnetherton.zulip.client.api.draft.response.CreateDraftsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for creating drafts.
 *
 * @see <a href="https://zulip.com/api/create-drafts">https://zulip.com/api/create-drafts</a>
 */
public class CreateDraftsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Long>> {

    public static final String DRAFTS = "drafts";

    /**
     * Constructs a {@link CreateDraftsApiRequest}.
     * 
     * @param client The Zulip HTTP client
     * @param drafts The drafts to create
     */
    public CreateDraftsApiRequest(ZulipHttpClient client, List<Draft> drafts) {
        super(client);
        putParamAsJsonString(DRAFTS, drafts);
    }

    /**
     * Executes the Zulip API request for creating drafts.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Long> execute() throws ZulipClientException {
        CreateDraftsApiResponse response = client().post(DRAFTS_API_PATH, getParams(), CreateDraftsApiResponse.class);
        return response.getIds();
    }
}
