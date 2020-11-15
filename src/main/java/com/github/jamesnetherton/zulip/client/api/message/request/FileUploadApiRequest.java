package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.USER_UPLOADS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.response.FileUploadApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.io.File;

/**
 * Zulip API request builder for uploading a file to the Zulip server.
 *
 * @see <a href="https://zulip.com/api/upload-file">https://zulip.com/api/upload-file</a>
 */
public class FileUploadApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    private final File file;

    /**
     * Constructs a {@link FileUploadApiRequest}.
     * 
     * @param client The Zulip HTTP client
     * @param file   The file to upload
     */
    public FileUploadApiRequest(ZulipHttpClient client, File file) {
        super(client);
        this.file = file;
    }

    /**
     * Executes the Zulip API request for uploading a file.
     * 
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        FileUploadApiResponse response = client().upload(USER_UPLOADS_API_PATH, file, FileUploadApiResponse.class);
        return response.getUri();
    }
}
