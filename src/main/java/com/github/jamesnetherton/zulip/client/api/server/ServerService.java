package com.github.jamesnetherton.zulip.client.api.server;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.server.request.AddCodePlaygroundApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.AddLinkifierApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.CreateProfileFieldApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.DeleteLinkifierApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.DeleteProfileFieldApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.GetAllEmojiApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.GetApiKeyApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.GetLinkifiersApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.GetProfileFieldsApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.GetServerSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.RemoveCodePlaygroundApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.ReorderProfileFieldsApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.UpdateRealmNewUserDefaultSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.UploadEmojiApiRequest;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.io.File;

/**
 * Zulip server management APIs.
 */
public class ServerService implements ZulipService {

    private final ZulipHttpClient client;

    /**
     * Constructs a {@link ServerService}.
     *
     * @param client The Zulip HTTP client
     */
    public ServerService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Adds a linkifier.
     *
     * @see                <a href="https://zulip.com/api/add-linkifier">https://zulip.com/api/add-linkifier</a>
     *
     * @param  pattern     The The regular expression that should trigger the linkifier
     * @param  urlTemplate The RFC 6570 compliant URL template used for the link
     * @return             The {@link AddLinkifierApiRequest} builder object
     */
    public AddLinkifierApiRequest addLinkifier(String pattern, String urlTemplate) {
        return new AddLinkifierApiRequest(this.client, pattern, urlTemplate);
    }

    /**
     * Deletes a linkifier.
     *
     * @see       <a href="https://zulip.com/api/remove-linkifier">https://zulip.com/api/remove-linkifier</a>
     *
     * @param  id The id of the linkifier to delete
     * @return    The {@link DeleteLinkifierApiRequest} builder object
     */
    public DeleteLinkifierApiRequest deleteLinkifier(long id) {
        return new DeleteLinkifierApiRequest(this.client, id);
    }

    /**
     * Gets all linkifiers.
     *
     * @see    <a href="https://zulip.com/api/get-linkifiers">https://zulip.com/api/get-linkifiers</a>
     *
     * @return The {@link GetLinkifiersApiRequest} builder object
     */
    public GetLinkifiersApiRequest getLinkifiers() {
        return new GetLinkifiersApiRequest(this.client);
    }

    /**
     * Uploads a custom emoji image file.
     *
     * @see              <a href="https://zulip.com/help/add-custom-emoji">https://zulip.com/help/add-custom-emoji</a>
     *
     * @param  name      The name of the emoji
     * @param  emojiFile The file containing the emoji image to be uploaded
     * @return           The {@link UploadEmojiApiRequest} builder object
     */
    public UploadEmojiApiRequest uploadEmoji(String name, File emojiFile) {
        return new UploadEmojiApiRequest(this.client, name, emojiFile);
    }

    /**
     * Gets all custom emoji.
     *
     * @see    <a href="https://zulip.com/api/get-custom-emoji">https://zulip.com/api/get-custom-emoji</a>
     *
     * @return The {@link GetAllEmojiApiRequest} builder object
     */
    public GetAllEmojiApiRequest getEmoji() {
        return new GetAllEmojiApiRequest(this.client);
    }

    /**
     * Gets Zulip server organization settings.
     *
     * @see    <a href="https://zulip.com/api/get-server-settings">https://zulip.com/api/get-server-settings</a>
     *
     * @return The {@link GetServerSettingsApiRequest} builder object
     */
    public GetServerSettingsApiRequest getServerSettings() {
        return new GetServerSettingsApiRequest(this.client);
    }

    /**
     * Gets all custom profile fields.
     *
     * @see    <a href="https://zulip.com/api/get-custom-profile-fields">https://zulip.com/api/get-custom-profile-fields</a>
     *
     * @return The {@link GetProfileFieldsApiRequest} builder object
     */
    public GetProfileFieldsApiRequest getCustomProfileFields() {
        return new GetProfileFieldsApiRequest(this.client);
    }

    /**
     * Reorders custom profile fields.
     *
     * @see          <a href=
     *               "https://zulip.com/api/reorder-custom-profile-fields">https://zulip.com/api/reorder-custom-profile-fields</a>
     *
     * @param  order The array of custom profile field ids in the order that they should appear on the Zulip UI
     * @return       The {@link ReorderProfileFieldsApiRequest} builder object
     */
    public ReorderProfileFieldsApiRequest reorderCustomProfileFields(int... order) {
        return new ReorderProfileFieldsApiRequest(this.client, order);
    }

    /**
     * Deletes a custom profile field.
     *
     * @param  profileFieldId The id of the profile field to delete
     * @return                The {@link DeleteProfileFieldApiRequest} builder object.
     */
    public DeleteProfileFieldApiRequest deleteCustomProfileField(long profileFieldId) {
        return new DeleteProfileFieldApiRequest(this.client, profileFieldId);
    }

    /**
     * <p>
     * Creates a custom profile field.
     * </p>
     * <p>
     * This API is only available to organization administrators.
     * </p>
     *
     * @see    <a href="https://zulip.com/api/create-custom-profile-field">https://zulip.com/api/create-custom-profile-field</a>
     *
     * @return The {@link CreateProfileFieldApiRequest} builder object
     */
    public CreateProfileFieldApiRequest createCustomProfileField() {
        return new CreateProfileFieldApiRequest(this.client);
    }

    /**
     * Gets a user development API key. Only available for development servers.
     * This endpoint is not available on production servers.
     *
     * @param  username The username to fetch the development API key for
     * @return          The {@link GetApiKeyApiRequest} builder object
     */
    public GetApiKeyApiRequest getDevelopmentApiKey(String username) {
        return new GetApiKeyApiRequest(this.client, username);
    }

    /**
     * Gets a user development API key. Only available for production servers.
     * This endpoint is not available on development servers.
     *
     * @param  username The username to fetch the development API key for
     * @param  password The password to fetch the development API key for
     * @return          The {@link GetApiKeyApiRequest} builder object
     */
    public GetApiKeyApiRequest getApiKey(String username, String password) {
        return new GetApiKeyApiRequest(this.client, username, password);
    }

    /**
     * Adds a code playground.
     *
     * @see                     <a href=
     *                          "https://zulip.com/api/add-code-playground">https://zulip.com/api/add-code-playground</a>
     *
     * @param  name             The name of the playground
     * @param  pygmentsLanguage The name of the Pygments language lexer for that programming language
     * @param  urlPrefix        The URL prefix for the playground
     * @return                  The {@link AddCodePlaygroundApiRequest} builder object
     */
    public AddCodePlaygroundApiRequest addCodePlayground(String name, String pygmentsLanguage, String urlPrefix) {
        return new AddCodePlaygroundApiRequest(this.client, name, pygmentsLanguage, urlPrefix);
    }

    /**
     * Removes a code playground.
     *
     * @see                     <a href=
     *                          "https://zulip.com/api/remove-code-playground">https://zulip.com/api/remove-code-playground</a>
     *
     * @param  codePlaygroundId The id of the code playground to remove
     * @return                  The {@link RemoveCodePlaygroundApiRequest} builder object
     */
    public RemoveCodePlaygroundApiRequest removeCodePlayground(long codePlaygroundId) {
        return new RemoveCodePlaygroundApiRequest(this.client, codePlaygroundId);
    }

    /**
     * Updates realm level default settings for new users.
     *
     * @see    <a href=
     *         "https://zulip.com/api/update-realm-user-settings-defaults">https://zulip.com/api/update-realm-user-settings-defaults</a>
     *
     * @return The {@link UpdateRealmNewUserDefaultSettingsApiRequest} builder object
     */
    public UpdateRealmNewUserDefaultSettingsApiRequest updateRealmNewUserDefaultSettings() {
        return new UpdateRealmNewUserDefaultSettingsApiRequest(this.client);
    }
}
