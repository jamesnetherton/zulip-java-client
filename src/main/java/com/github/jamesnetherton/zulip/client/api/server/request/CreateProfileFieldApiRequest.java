package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_PROFILE_FIELDS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.ProfileFieldType;
import com.github.jamesnetherton.zulip.client.api.server.response.CreateProfileFieldApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * <p>
 * Zulip API request builder for creating a custom profile field.
 * </p>
 * <p>
 * This endpoint is only available to organization administrators.
 * </p>
 *
 * @see <a href="https://zulip.com/api/create-custom-profile-field">https://zulip.com/api/create-custom-profile-field</a>
 */
public class CreateProfileFieldApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {

    public static final String NAME = "name";
    public static final String HINT = "hint";
    public static final String FIELD_TYPE = "field_type";
    public static final String FIELD_DATA = "field_data";
    public static final String DISPLAY_IN_PROFILE_SUMMARY = "display_in_profile_summary";

    /**
     * Constructs a {@link CreateProfileFieldApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public CreateProfileFieldApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Creates a simple profile field determined by the provided {@link ProfileFieldType}.
     *
     * @param  type The field type to create
     * @param  name The name of the profile field
     * @param  hint The help text displayed against the custom field in the Zulip UI
     * @return      This {@link CreateProfileFieldApiRequest} instance
     */
    public CreateProfileFieldApiRequest withSimpleFieldType(ProfileFieldType type, String name, String hint) {
        putParam(NAME, name);
        putParam(HINT, hint);
        putParam(FIELD_TYPE, type.getId());
        return this;
    }

    /**
     * Creates a list of options profile field.
     *
     * @param  name The name of the profile field
     * @param  hint The help text displayed against the custom field in the Zulip UI
     * @param  data The map that determines the available list options and their order
     *
     *              <pre>
     *              Map&#60;String, Map&#60;String, String&#62;&#62; options = new LinkedHashMap&#60;&#62;();
     *              Map&#60;String, String&#62; option = new LinkedHashMap&#60;&#62;();
     *              option.put("text", "Test Field");
     *              option.put("order", "1");
     *              options.put("test", option);
     *              </pre>
     *
     * @return      This {@link CreateProfileFieldApiRequest} instance
     */
    public CreateProfileFieldApiRequest withListOfOptionsFieldType(String name, String hint,
            Map<String, Map<String, String>> data) {
        putParam(NAME, name);
        putParam(HINT, hint);
        putParam(FIELD_TYPE, ProfileFieldType.LIST_OF_OPTIONS.getId());
        putParamAsJsonString(FIELD_DATA, data);
        return this;
    }

    /**
     * Creates a external account filed type. Zulip labels this field structure for this field type
     * as not being stable, so this API is best avoided unless you know what you are doing.
     *
     * @param  data The mao that determines the external account type configuration
     *
     *              <pre>
     *              Map&#60;String, String&#62; externalData = new LinkedHashMap&#60;&#62;();
     *              externalData.put("subtype", "github");
     *              </pre>
     *
     * @return      This {@link CreateProfileFieldApiRequest} instance
     */
    public CreateProfileFieldApiRequest withExternalAccountFieldType(Map<String, String> data) {
        putParam(FIELD_TYPE, ProfileFieldType.EXTERNAL_ACCOUNT.getId());
        putParamAsJsonString(FIELD_DATA, data);
        return this;
    }

    /**
     * Sets whether clients should display this profile field in a summary section of a users profile.
     *
     * @param  isDisplayInProfileSummary Whether clients should display this profile field in a summary section of a users
     *                                   profile
     * @return                           This {@link CreateProfileFieldApiRequest} instance
     */
    public CreateProfileFieldApiRequest withDisplayInProfileSummary(boolean isDisplayInProfileSummary) {
        putParam(DISPLAY_IN_PROFILE_SUMMARY, isDisplayInProfileSummary);
        return this;
    }

    /**
     * Executes the Zulip API request for creating a custom profile field.
     *
     * @return                      The id of the created profile field
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        CreateProfileFieldApiResponse response = client().post(REALM_PROFILE_FIELDS, getParams(),
                CreateProfileFieldApiResponse.class);
        return response.getId();
    }
}
