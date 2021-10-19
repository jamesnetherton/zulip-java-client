package com.github.jamesnetherton.zulip.client.api.draft.request;

import static com.github.jamesnetherton.zulip.client.api.draft.request.DraftRequestConstants.DRAFT_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a draft.
 *
 * @see <a href="https://zulip.com/api/delete-draft">https://zulip.com/api/delete-draft</a>
 */
public class DeleteDraftApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final String path;

    /**
     * Constructs a {@link DeleteDraftApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param draftId The id of the draft to delete
     */
    public DeleteDraftApiRequest(ZulipHttpClient client, long draftId) {
        super(client);
        this.path = String.format(DRAFT_ID_API_PATH, draftId);
    }

    /**
     * Executes the Zulip API request for deleting a draft.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}
