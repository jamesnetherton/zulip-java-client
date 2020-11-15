package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.ATTACHMENTS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserAttachment;
import com.github.jamesnetherton.zulip.client.api.user.response.GetUserAttachmentsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting information about files uploaded by the user.
 *
 * @see <a href="https://zulip.com/api/update-user-group-members">https://zulip.com/api/update-user-group-members</a>
 */
public class GetUserAttachmentsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<UserAttachment>> {

    /**
     * Constructs a {@link GetUserAttachmentsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetUserAttachmentsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting information about files uploaded by the user.
     *
     * @return                      List if {@link UserAttachment} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<UserAttachment> execute() throws ZulipClientException {
        return client().get(ATTACHMENTS, getParams(), GetUserAttachmentsApiResponse.class).getAttachments();
    }
}
