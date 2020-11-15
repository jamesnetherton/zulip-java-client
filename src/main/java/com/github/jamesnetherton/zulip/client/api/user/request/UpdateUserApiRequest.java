package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ID;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserRole;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API request builder to update a user.
 *
 * @see <a href="https://zulip.com/api/update-user">https://zulip.com/api/update-user</a>
 */
public class UpdateUserApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String FULL_NAME = "full_name";
    public static final String PROFILE_DATA = "profile_data";
    public static final String ROLE = "role";

    private final long userId;
    private final List<ProfileData> profileData = new ArrayList<>();

    /**
     * Constructs a {@link UpdateUserApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param userId The id of the user to update
     */
    public UpdateUserApiRequest(ZulipHttpClient client, long userId) {
        super(client);
        this.userId = userId;
    }

    /**
     * Sets the updated name of the user.
     *
     * @param  fullName The updated user name
     * @return          This {@link UpdateUserApiRequest} instance
     */
    public UpdateUserApiRequest withFullName(String fullName) {
        putParamAsJsonString(FULL_NAME, fullName);
        return this;
    }

    /**
     * Sets the updated role of the user.
     *
     * @param  role The updated {@link UserRole}
     * @return      This {@link UpdateUserApiRequest} instance
     */
    public UpdateUserApiRequest withRole(UserRole role) {
        putParam(ROLE, role.getId());
        return this;
    }

    /**
     * Sets updated custom profile data for the user.
     *
     * @param  id    The id of the custom profile field
     * @param  value The updated value for the custom profile field
     * @return       This {@link UpdateUserApiRequest} instance
     */
    public UpdateUserApiRequest withProfileData(int id, String value) {
        profileData.add(new ProfileData(id, value));
        return this;
    }

    /**
     * Executes the Zulip API request for updating a user.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        if (!profileData.isEmpty()) {
            putParamAsJsonString(PROFILE_DATA, profileData);
        }

        String path = String.format(USERS_WITH_ID, userId);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }

    private static final class ProfileData {

        @JsonProperty
        private int id;

        @JsonProperty
        private String value;

        public ProfileData() {
        }

        public ProfileData(int id, String value) {
            this.id = id;
            this.value = value;
        }

        public int getId() {
            return id;
        }

        public String getValue() {
            return value;
        }
    }
}
