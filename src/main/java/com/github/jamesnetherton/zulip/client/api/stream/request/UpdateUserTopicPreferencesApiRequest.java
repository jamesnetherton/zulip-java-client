package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.USER_TOPICS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.stream.TopicVisibilityPolicy;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating user topic preferences.
 *
 * @see <a href="https://zulip.com/api/update-user-topic">https://zulip.com/api/update-user-topic</a>
 */
public class UpdateUserTopicPreferencesApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String STREAM_ID = "stream_id";
    public static final String TOPIC = "topic";
    public static final String VISIBILITY_POLICY = "visibility_policy";

    /**
     * Constructs a {@link UpdateUserTopicPreferencesApiRequest}.
     *
     * @param client                The Zulip HTTP client
     * @param streamId              The id of the stream where the topic resides
     * @param topic                 The name of the topic to update preferences for
     * @param topicVisibilityPolicy The {@link TopicVisibilityPolicy} to apply
     */
    public UpdateUserTopicPreferencesApiRequest(ZulipHttpClient client, long streamId, String topic,
            TopicVisibilityPolicy topicVisibilityPolicy) {
        super(client);
        putParam(STREAM_ID, streamId);
        putParam(TOPIC, topic);
        putParam(VISIBILITY_POLICY, topicVisibilityPolicy.getId());
    }

    /**
     * Executes the Zulip API request for updatig user topic preferences.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(USER_TOPICS, getParams(), ZulipApiResponse.class);
    }
}
