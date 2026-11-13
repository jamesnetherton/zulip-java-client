package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_PROFILE_FIELDS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * Zulip API request builder for updating a custom profile field.
 *
 * @see <a href="https://zulip.com/api/update-custom-profile-field">https://zulip.com/api/update-custom-profile-field</a>
 */
public class UpdateProfileFieldApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String NAME = "name";
    public static final String HINT = "hint";
    public static final String FIELD_DATA = "field_data";
    public static final String DISPLAY_IN_PROFILE_SUMMARY = "display_in_profile_summary";
    public static final String REQUIRED = "required";
    public static final String EDITABLE_BY_USER = "editable_by_user";
    public static final String USE_FOR_USER_MATCHING = "use_for_user_matching";

    private final long profileFieldId;

    /**
     * Constructs a {@link UpdateProfileFieldApiRequest}.
     *
     * @param client         The Zulip HTTP client
     * @param profileFieldId The id of the profile field to update
     */
    public UpdateProfileFieldApiRequest(ZulipHttpClient client, long profileFieldId) {
        super(client);
        this.profileFieldId = profileFieldId;
    }

    /**
     * Sets the name of the profile field.
     *
     * @param  name The name of the profile field
     * @return      This {@link UpdateProfileFieldApiRequest} instance
     */
    public UpdateProfileFieldApiRequest withName(String name) {
        putParam(NAME, name);
        return this;
    }

    /**
     * Sets the help text displayed against the profile field in the Zulip UI.
     *
     * @param  hint The help text for the profile field
     * @return      This {@link UpdateProfileFieldApiRequest} instance
     */
    public UpdateProfileFieldApiRequest withHint(String hint) {
        putParam(HINT, hint);
        return this;
    }

    /**
     * Sets the field type specific configuration data, such as the options of a list of options field.
     *
     * @see              <a href=
     *                   "https://zulip.com/api/update-custom-profile-field#parameter-field_data">https://zulip.com/api/update-custom-profile-field#parameter-field_data</a>
     *
     * @param  fieldData The field data
     * @return           This {@link UpdateProfileFieldApiRequest} instance
     */
    public UpdateProfileFieldApiRequest withFieldData(Map<String, ?> fieldData) {
        putParamAsJsonString(FIELD_DATA, fieldData);
        return this;
    }

    /**
     * Sets whether the profile field is displayed in the user profile summary.
     *
     * @param  displayInProfileSummary {@code true} to display the field in the user profile summary
     * @return                         This {@link UpdateProfileFieldApiRequest} instance
     */
    public UpdateProfileFieldApiRequest withDisplayInProfileSummary(boolean displayInProfileSummary) {
        putParam(DISPLAY_IN_PROFILE_SUMMARY, displayInProfileSummary);
        return this;
    }

    /**
     * Sets whether the profile field is required.
     *
     * @param  required {@code true} if users must provide a value for the field
     * @return          This {@link UpdateProfileFieldApiRequest} instance
     */
    public UpdateProfileFieldApiRequest withRequired(boolean required) {
        putParam(REQUIRED, required);
        return this;
    }

    /**
     * Sets whether users can edit the value of the profile field on their own account.
     *
     * @param  editableByUser {@code true} if users can edit the field
     * @return                This {@link UpdateProfileFieldApiRequest} instance
     */
    public UpdateProfileFieldApiRequest withEditableByUser(boolean editableByUser) {
        putParam(EDITABLE_BY_USER, editableByUser);
        return this;
    }

    /**
     * Sets whether the profile field can be used to match users, for example when importing users.
     *
     * @see                       <a href=
     *                            "https://zulip.com/api/update-custom-profile-field#parameter-use_for_user_matching">https://zulip.com/api/update-custom-profile-field#parameter-use_for_user_matching</a>
     *
     * @param  useForUserMatching {@code true} to use the field for user matching
     * @return                    This {@link UpdateProfileFieldApiRequest} instance
     */
    public UpdateProfileFieldApiRequest withUseForUserMatching(boolean useForUserMatching) {
        putParam(USE_FOR_USER_MATCHING, useForUserMatching);
        return this;
    }

    /**
     * Executes the Zulip API request for updating a custom profile field.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().patch(String.format(REALM_PROFILE_FIELDS_WITH_ID, profileFieldId), getParams(), ZulipApiResponse.class);
    }
}
