package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_AVATAR;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.AvatarApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.io.File;

/**
 * Zulip API request builder for uploading an avatar image for the user.
 *
 * @see <a href="https://zulip.com/api/upload-avatar">https://zulip.com/api/upload-avatar</a>
 */
public class UploadAvatarApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    private final File avatarFile;

    /**
     * Constructs a {@link UploadAvatarApiRequest}.
     *
     * @param client     The Zulip HTTP client
     * @param avatarFile The avatar image file to upload
     */
    public UploadAvatarApiRequest(ZulipHttpClient client, File avatarFile) {
        super(client);
        this.avatarFile = avatarFile;
    }

    /**
     * Executes the Zulip API request for uploading an avatar image.
     *
     * @return                      The URL of the new avatar
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().upload(USERS_AVATAR, avatarFile, AvatarApiResponse.class).getAvatarUrl();
    }
}
