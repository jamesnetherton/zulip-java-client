package com.github.jamesnetherton.zulip.client.api.user.request;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting an attachment.
 *
 * @see <a href="https://zulip.com/api/remove-attachment">https://zulip.com/api/remove-attachment</a>
 */
public class DeleteUserAttachmentApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    private final long attachmentId;

    /**
     * Constructs a {@link DeleteUserAttachmentApiRequest}.
     *
     * @param client       The Zulip HTTP client
     * @param attachmentId The id of the attachment to delete
     */
    public DeleteUserAttachmentApiRequest(ZulipHttpClient client, long attachmentId) {
        super(client);
        this.attachmentId = attachmentId;
    }

    /**
     * Executes the Zulip API request for deleting an attachment.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String attachmentsWithId = String.format(UserRequestConstants.ATTACHMENTS_WITH_ID, attachmentId);
        client().delete(attachmentsWithId, getParams(), ZulipApiResponse.class);
    }
}
