package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.STREAMS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;
import com.github.jamesnetherton.zulip.client.api.stream.response.GetStreamsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all streams that the user has access to.
 *
 * @see <a href="https://zulip.com/api/get-streams">https://zulip.com/api/get-streams</a>
 */
public class GetStreamsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Stream>> {

    public static final String INCLUDE_PUBLIC = "include_public";
    public static final String INCLUDE_WEB_PUBLIC = "include_web_public";
    public static final String INCLUDE_SUBSCRIBED = "include_subscribed";
    public static final String INCLUDE_ALL_ACTIVE = "include_all_active";
    public static final String INCLUDE_DEFAULT = "include_default";
    public static final String INCLUDE_OWNER_SUBSCRIBED = "include_owner_subscribed";

    /**
     * Constructs a {@link GetStreamsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetStreamsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets whether to include public streams.
     *
     * @param  includePublic {@code true} to include public streams. {@code false} to exclude public streams.
     * @return               This {@link GetStreamsApiRequest} instance
     */
    public GetStreamsApiRequest withIncludePublic(boolean includePublic) {
        putParam(INCLUDE_PUBLIC, includePublic);
        return this;
    }

    /**
     * Sets whether to include web public streams.
     *
     * @param  includeWebPublic {@code true} to include web public streams. {@code false} to exclude web public streams.
     * @return                  This {@link GetStreamsApiRequest} instance
     */
    public GetStreamsApiRequest withIncludeWebPublic(boolean includeWebPublic) {
        putParam(INCLUDE_WEB_PUBLIC, includeWebPublic);
        return this;

    }

    /**
     * Sets whether to include all streams that the user is subscribed to.
     *
     * @param  includeSubscribed {@code true} to include all streams that the user is subscribed to. {@code false} to exclude
     *                           all streams that the user is subscribed to.
     * @return                   This {@link GetStreamsApiRequest} instance
     */
    public GetStreamsApiRequest withIncludeSubscribed(boolean includeSubscribed) {
        putParam(INCLUDE_SUBSCRIBED, includeSubscribed);
        return this;
    }

    /**
     * Sets whether to include active streams.
     *
     * @param  includeAllActive {@code true} to include active streams. {@code false} to exclude active streams.
     * @return                  This {@link GetStreamsApiRequest} instance
     */
    public GetStreamsApiRequest withIncludeAllActive(boolean includeAllActive) {
        putParam(INCLUDE_ALL_ACTIVE, includeAllActive);
        return this;
    }

    /**
     * Sets whether to include default streams.
     *
     * @param  includeDefault {@code true} to include default streams. {@code false} to exclude default streams.
     * @return                This {@link GetStreamsApiRequest} instance
     */
    public GetStreamsApiRequest withIncludeDefault(boolean includeDefault) {
        putParam(INCLUDE_DEFAULT, includeDefault);
        return this;
    }

    /**
     * If the user is a bot user, this sets whether to include streams that the owner user is subscribed to.
     *
     * @param  ownerSubscribed {@code true} to include owner subscribed streams. {@code false} to exclude owner subscribed
     *                         streams.
     * @return                 This {@link GetStreamsApiRequest} instance
     */
    public GetStreamsApiRequest withOwnerSubscribed(boolean ownerSubscribed) {
        putParam(INCLUDE_OWNER_SUBSCRIBED, ownerSubscribed);
        return this;
    }

    /**
     * Executes the Zulip API request for getting all streams that the user has access to.
     *
     * @return                      List of {@link Stream} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Stream> execute() throws ZulipClientException {
        return client().get(STREAMS, getParams(), GetStreamsApiResponse.class).getStreams();
    }
}
