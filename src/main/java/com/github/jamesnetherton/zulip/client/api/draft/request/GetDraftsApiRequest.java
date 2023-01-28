package com.github.jamesnetherton.zulip.client.api.draft.request;

import static com.github.jamesnetherton.zulip.client.api.draft.request.DraftRequestConstants.DRAFTS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.draft.Draft;
import com.github.jamesnetherton.zulip.client.api.draft.response.GetDraftsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

public class GetDraftsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Draft>> {

    /**
     * Constructs a {@link GetDraftsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetDraftsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for fetching drafts.
     *
     * @return                      The list of drafts
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Draft> execute() throws ZulipClientException {
        GetDraftsApiResponse response = client().get(DRAFTS_API_PATH, getParams(), GetDraftsApiResponse.class);
        return response.getDrafts();
    }
}
