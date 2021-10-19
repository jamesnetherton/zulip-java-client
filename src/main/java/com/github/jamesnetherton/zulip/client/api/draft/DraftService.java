package com.github.jamesnetherton.zulip.client.api.draft;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.draft.request.CreateDraftsApiRequest;
import com.github.jamesnetherton.zulip.client.api.draft.request.DeleteDraftApiRequest;
import com.github.jamesnetherton.zulip.client.api.draft.request.EditDraftApiRequest;
import com.github.jamesnetherton.zulip.client.api.draft.request.GetDraftsApiRequest;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

public class DraftService implements ZulipService {

    private final ZulipHttpClient client;

    /**
     * Constructs a {@link DraftService}.
     *
     * @param client The Zulip HTTP client
     */
    public DraftService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Creates one or more drafts.
     *
     * @see           <a href="https://www.zulipchat.com/api/create-drafts">https://www.zulipchat.com/api/create-drafts</a>
     *
     * @param  drafts The drafts to create
     * @return        The {@link CreateDraftsApiRequest} builder object
     */
    public CreateDraftsApiRequest createDrafts(List<Draft> drafts) {
        return new CreateDraftsApiRequest(this.client, drafts);
    }

    /**
     * Deletes a draft.
     *
     * @see            <a href="https://www.zulipchat.com/api/delete-draft">https://www.zulipchat.com/api/delete-draft</a>
     *
     * @param  draftId The id of the draft to delete
     * @return         The {@link DeleteDraftApiRequest} builder object
     */
    public DeleteDraftApiRequest deleteDraft(long draftId) {
        return new DeleteDraftApiRequest(this.client, draftId);
    }

    /**
     * Edit a draft.
     *
     * @see          <a href="https://www.zulipchat.com/api/edit-draft">https://www.zulipchat.com/api/edit-draft</a>
     *
     * @param  draft The draft to edit
     * @return       The {@link EditDraftApiRequest} builder object
     */
    public EditDraftApiRequest editDraft(Draft draft) {
        return new EditDraftApiRequest(this.client, draft);
    }

    /**
     * Fetches all drafts for the current user.
     *
     * @see    <a href="https://www.zulipchat.com/api/get-drafts">https://www.zulipchat.com/api/get-drafts</a>
     *
     * @return The {@link GetDraftsApiRequest} builder object
     */
    public GetDraftsApiRequest getDrafts() {
        return new GetDraftsApiRequest(this.client);
    }
}
