package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.SERVER_SETTINGS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.ServerSettings;
import com.github.jamesnetherton.zulip.client.api.server.response.GetServerSettingsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting server settings.
 *
 * @see <a href="https://zulip.com/api/get-server-settings">https://zulip.com/api/get-server-settings</a>
 */
public class GetServerSettingsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<ServerSettings> {

    /**
     * Constructs a {@link GetServerSettingsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetServerSettingsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting server settings.
     *
     * @return                      A {@link ServerSettings}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public ServerSettings execute() throws ZulipClientException {
        GetServerSettingsApiResponse response = client().get(SERVER_SETTINGS, getParams(), GetServerSettingsApiResponse.class);
        return new ServerSettings(response);
    }
}
