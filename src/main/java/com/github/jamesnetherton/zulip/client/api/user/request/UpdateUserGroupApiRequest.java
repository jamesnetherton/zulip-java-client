package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * Zulip API request builder for updating a user group.
 *
 * @see <a href="https://zulip.com/api/update-user-group">https://zulip.com/api/update-user-group</a>
 */
public class UpdateUserGroupApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String NAME = "name";
    public static final String DESCRIPTION = "description";
    public static final String CAN_MENTION_GROUP = "can_mention_group";

    private final long groupId;

    /**
     * Constructs a {@link UpdateUserGroupApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param groupId The id of the group to update
     */
    public UpdateUserGroupApiRequest(ZulipHttpClient client, long groupId) {
        super(client);
        this.groupId = groupId;
    }

    /**
     * Constructs a {@link UpdateUserGroupApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param name        The updated name of the user group
     * @param description The updated description of the user group
     * @param groupId     The id of the group to update
     */
    public UpdateUserGroupApiRequest(ZulipHttpClient client, String name, String description, long groupId) {
        super(client);
        this.groupId = groupId;
        withName(name);
        withDescription(description);
    }

    /**
     * Sets the updated description of the user group.
     *
     * @param  description The new description of the user group
     * @return             This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withDescription(String description) {
        putParam(DESCRIPTION, description);
        return this;
    }

    /**
     * Sets the updated name of the user group.
     *
     * @param  name The new name of the user group
     * @return      This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withName(String name) {
        putParam(NAME, name);
        return this;
    }

    /**
     * Sets the optional ID of the user group whose members are allowed to mention the new user group.
     *
     * @param  oldGroupId The current ID of the user group whose members are allowed to mention the new user group
     * @param  newGroupId The new ID of the user group whose members are allowed to mention the new user group
     * @return            This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withCanMentionGroup(long oldGroupId, long newGroupId) {
        Map<String, Long> canMentionGroup = Map.of("old", oldGroupId, "new", newGroupId);
        putParamAsJsonString(CAN_MENTION_GROUP, canMentionGroup);
        return this;
    }

    /**
     * Executes the Zulip API request for updating a user group.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USER_GROUPS_WITH_ID, groupId);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}
