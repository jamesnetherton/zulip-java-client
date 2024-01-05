package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.EMAIL_ADDRESS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.response.GetStreamEmailAddressApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting the email address of a stream.
 *
 * @see <a href="https://zulip.com/api/get-subscribers">https://zulip.com/api/get-subscribers</a>
 */
public class GetStreamEmailAddressApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {
    private final long streamId;

    /**
     * Constructs a {@link GetStreamEmailAddressApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param streamId The id of the stream to get the email address for
     */
    public GetStreamEmailAddressApiRequest(ZulipHttpClient client, long streamId) {
        super(client);
        this.streamId = streamId;
    }

    @Override
    public String execute() throws ZulipClientException {
        String path = String.format(EMAIL_ADDRESS, streamId);
        return client().get(path, getParams(), GetStreamEmailAddressApiResponse.class).getEmail();
    }
}
