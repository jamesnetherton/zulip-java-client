package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserAttachment;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting user attachment details.
 *
 * @see <a href="https://zulip.com/api/get-attachments#response">https://zulip.com/api/get-attachments#response</a>
 */
public class GetUserAttachmentsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<UserAttachment> attachments = new ArrayList<>();

    public List<UserAttachment> getAttachments() {
        return attachments;
    }
}
