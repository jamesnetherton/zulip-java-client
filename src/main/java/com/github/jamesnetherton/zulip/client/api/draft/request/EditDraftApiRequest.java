package com.github.jamesnetherton.zulip.client.api.draft.request;

import static com.github.jamesnetherton.zulip.client.api.draft.request.DraftRequestConstants.DRAFT_ID_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.draft.Draft;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for editing a draft.
 *
 * @see <a href="https://zulip.com/api/edit-draft">https://zulip.com/api/edit-draft</a>
 */
public class EditDraftApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String DRAFT = "draft";
    private final String path;

    /**
     * Constructs a {@link EditDraftApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param draft  The draft to edit
     */
    public EditDraftApiRequest(ZulipHttpClient client, Draft draft) {
        super(client);
        long draftId = draft.getId();
        this.path = String.format(DRAFT_ID_API_PATH, draftId);
        try {
            // Avoid serializing the id field on edit
            draft.setId(0);
            putParamAsJsonString(DRAFT, draft);
        } finally {
            draft.setId(draftId);
        }
    }

    /**
     * Executes the Zulip API request for editing a draft.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().patch(this.path, getParams(), ZulipApiResponse.class);
    }
}
