package com.github.jamesnetherton.zulip.client.api.stream;

import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.stream.request.DeleteStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamIdApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamTopicsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetSubscribedStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetSubscriptionStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.MuteTopicApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.SubscribeStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UnsubscribeStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UpdateStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UpdateStreamSubscriptionSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip stream APIs.
 */
public class StreamService implements ZulipService {

    private final ZulipHttpClient client;

    /**
     * Constructs a {@link StreamService}.
     *
     * @param client The Zulip HTTP client
     */
    public StreamService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Gets users subscribed streams.
     *
     * @see    <a href="https://zulip.com/api/get-subscriptions">https://zulip.com/api/get-subscriptions</a>
     *
     * @return The {@link GetSubscribedStreamsApiRequest} builder object
     */
    public GetSubscribedStreamsApiRequest getSubscribedStreams() {
        return new GetSubscribedStreamsApiRequest(this.client);
    }

    /**
     * Subscribe to streams.
     *
     * @see                       <a href="https://zulip.com/api/subscribe">https://zulip.com/api/subscribe</a>
     *
     * @param  streamsToSubscribe An array of {@link StreamSubscriptionRequest} objects detailing the stream name and
     *                            description
     * @return                    The {@link SubscribeStreamsApiRequest} builder object
     */
    public SubscribeStreamsApiRequest subscribe(StreamSubscriptionRequest... streamsToSubscribe) {
        return new SubscribeStreamsApiRequest(this.client, streamsToSubscribe);
    }

    /**
     * Unsubscribe from streams.
     *
     * @see            <a href="https://zulip.com/api/unsubscribe">https://zulip.com/api/unsubscribe</a>
     *
     * @param  streams An array of stream names to unsubscribe from
     * @return         The {@link UnsubscribeStreamsApiRequest} builder object
     */
    public UnsubscribeStreamsApiRequest unsubscribe(String... streams) {
        return new UnsubscribeStreamsApiRequest(this.client, streams);
    }

    /**
     * Gets stream subscription status.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/get-subscription-status">https://zulip.com/api/get-subscription-status</a>
     *
     * @param  userId   The user id to check if it is subscribed to the specified stream
     * @param  streamId The id of the stream to check if the specified user is subscribed
     * @return          The {@link GetSubscriptionStatusApiRequest} builder object
     */
    public GetSubscriptionStatusApiRequest isSubscribed(long userId, long streamId) {
        return new GetSubscriptionStatusApiRequest(this.client, userId, streamId);
    }

    /**
     * Gets all streams that the user has access to.
     *
     * @see    <a href="https://zulip.com/api/get-streams">https://zulip.com/api/get-streams</a>
     *
     * @return The {@link GetStreamsApiRequest} builder object
     */
    public GetStreamsApiRequest getAll() {
        return new GetStreamsApiRequest(this.client);
    }

    /**
     * Gets the id of a stream.
     *
     * @see           <a href="https://zulip.com/api/get-stream-id">https://zulip.com/api/get-stream-id</a>
     *
     * @param  stream The name of the stream
     * @return        The {@link GetStreamIdApiRequest} builder object
     */
    public GetStreamIdApiRequest getStreamId(String stream) {
        return new GetStreamIdApiRequest(this.client, stream);
    }

    /**
     * Deletes a stream.
     *
     * @see             <a href="https://zulip.com/api/delete-stream">https://zulip.com/api/delete-stream</a>
     *
     * @param  streamId The id of the stream to delete
     * @return          The {@link DeleteStreamApiRequest} builder object
     */
    public DeleteStreamApiRequest delete(long streamId) {
        return new DeleteStreamApiRequest(this.client, streamId);
    }

    /**
     * Gets stream topics.
     *
     * @see             <a href="https://zulip.com/api/get-stream-topics">https://zulip.com/api/get-stream-topics</a>
     *
     * @param  streamId The id of the stream to get topics from
     * @return          The {@link GetStreamTopicsApiRequest} builder object
     */
    public GetStreamTopicsApiRequest getTopics(long streamId) {
        return new GetStreamTopicsApiRequest(this.client, streamId);
    }

    /**
     * Updates a stream.
     *
     * @see             <a href="https://zulip.com/api/update-stream">https://zulip.com/api/update-stream</a>
     *
     * @param  streamId The id of the stream to update
     * @return          The {@link UpdateStreamApiRequest} builder object
     */
    public UpdateStreamApiRequest updateStream(long streamId) {
        return new UpdateStreamApiRequest(this.client, streamId);
    }

    /**
     * Mutes a topic.
     *
     * @see          <a href="https://zulip.com/api/mute-topic">https://zulip.com/api/mute-topic</a>
     *
     * @param  topic The name of the topic to mute
     * @return       The {@link MuteTopicApiRequest} builder object
     */
    public MuteTopicApiRequest muteTopic(String topic) {
        return new MuteTopicApiRequest(this.client, topic, Operation.ADD);
    }

    /**
     * Unmutes a topic.
     *
     * @see          <a href="https://zulip.com/api/mute-topic">https://zulip.com/api/mute-topic</a>
     *
     * @param  topic The name of the topic to unmute
     * @return       The {@link MuteTopicApiRequest} builder object
     */
    public MuteTopicApiRequest unmuteTopic(String topic) {
        return new MuteTopicApiRequest(this.client, topic, Operation.REMOVE);
    }

    /**
     * Updates stream subscription settings.
     *
     * @see    <a href=
     *         "https://zulip.com/api/update-subscription-settings">https://zulip.com/api/update-subscription-settings</a>
     *
     * @return The {@link UpdateStreamSubscriptionSettingsApiRequest} builder object
     */
    public UpdateStreamSubscriptionSettingsApiRequest updateSubscriptionSettings() {
        return new UpdateStreamSubscriptionSettingsApiRequest(this.client);
    }
}
