package com.github.jamesnetherton.zulip.client.api.stream;

import com.github.jamesnetherton.zulip.client.api.channel.request.CreateChannelApiRequest;
import com.github.jamesnetherton.zulip.client.api.channel.request.CreateChannelFolderApiRequest;
import com.github.jamesnetherton.zulip.client.api.channel.request.GetChannelFoldersApiRequest;
import com.github.jamesnetherton.zulip.client.api.channel.request.ReorderChannelFoldersApiRequest;
import com.github.jamesnetherton.zulip.client.api.channel.request.UpdateChannelFolderApiRequest;
import com.github.jamesnetherton.zulip.client.api.common.Operation;
import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.stream.request.AddDefaultStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.ArchiveStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.DeleteStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.DeleteTopicApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamEmailAddressApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamIdApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamSubscribersApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamTopicsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetSubscribedStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetSubscriptionStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.MuteTopicApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.RemoveDefaultStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.SubscribeStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UnsubscribeStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UpdateStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UpdateStreamSubscriptionSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UpdateUserTopicPreferencesApiRequest;
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
     * Gets a stream for the given stream ID.
     *
     * @see    <a href="https://zulip.com/api/get-stream-by-id">https://zulip.com/api/get-stream-by-id</a>
     *
     * @return The {@link GetStreamApiRequest} builder object
     */
    public GetStreamApiRequest getStream(long streamId) {
        return new GetStreamApiRequest(this.client, streamId);
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
     * Gets the email address of a stream.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/get-stream-email-address">https://zulip.com/api/get-stream-email-address</a>
     *
     * @param  streamId The id of the stream to fetch the email address for
     * @return          The {@link GetStreamEmailAddressApiRequest} builder object
     */
    public GetStreamEmailAddressApiRequest getStreamEmailAddress(long streamId) {
        return new GetStreamEmailAddressApiRequest(this.client, streamId);
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
     * @see              <a href="https://zulip.com/api/mute-topic">https://zulip.com/api/mute-topic</a>
     *
     * @param      topic The name of the topic to mute
     * @return           The {@link MuteTopicApiRequest} builder object
     * @deprecated       Use updateUserTopicPreferences instead
     */
    @Deprecated(forRemoval = true)
    public MuteTopicApiRequest muteTopic(String topic) {
        return new MuteTopicApiRequest(this.client, topic, Operation.ADD);
    }

    /**
     * Unmutes a topic.
     *
     * @see              <a href="https://zulip.com/api/mute-topic">https://zulip.com/api/mute-topic</a>
     *
     * @param      topic The name of the topic to unmute
     * @return           The {@link MuteTopicApiRequest} builder object
     * @deprecated       Use updateUserTopicPreferences instead
     */
    @Deprecated(forRemoval = true)
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

    /**
     * Deletes a topic.
     *
     * @see              <a href="https://zulip.com/api/delete-topic">https://zulip.com/api/delete-topic</a>
     *
     * @param  streamId  The id of the stream containing the topic to delete
     * @param  topicName The name of the topic to delete
     * @return           The {@link DeleteTopicApiRequest} builder object
     */
    public DeleteTopicApiRequest deleteTopic(long streamId, String topicName) {
        return new DeleteTopicApiRequest(this.client, streamId, topicName);
    }

    /**
     * Archives a stream.
     *
     * @see             <a href="https://zulip.com/api/archive-stream">https://zulip.com/api/archive-stream</a>
     *
     * @param  streamId The id of the stream to archive
     * @return          The {@link ArchiveStreamApiRequest} builder object
     */
    public ArchiveStreamApiRequest archiveStream(long streamId) {
        return new ArchiveStreamApiRequest(this.client, streamId);
    }

    /**
     * Updates personal preferences for a topic.
     *
     * @see                          <a href=
     *                               "https://zulip.com/api/update-user-topic">https://zulip.com/api/update-user-topic</a>
     *
     * @param  streamId              The id of the stream where the topic resides
     * @param  topic                 The name of the topic to update preferences for
     * @param  topicVisibilityPolicy The {@link TopicVisibilityPolicy} to apply
     * @return                       The {@link UpdateUserTopicPreferencesApiRequest} builder object
     */
    public UpdateUserTopicPreferencesApiRequest updateUserTopicPreferences(long streamId, String topic,
            TopicVisibilityPolicy topicVisibilityPolicy) {
        return new UpdateUserTopicPreferencesApiRequest(this.client, streamId, topic, topicVisibilityPolicy);
    }

    /**
     * Adds a default stream for new users joining the organization.
     *
     * @see             <a href="https://zulip.com/api/add-default-stream">https://zulip.com/api/add-default-stream</a>
     *
     * @param  streamId The id of the stream to make a default for new users joining the organization
     * @return          The {@link AddDefaultStreamApiRequest} builder object
     */
    public AddDefaultStreamApiRequest addDefaultStream(long streamId) {
        return new AddDefaultStreamApiRequest(this.client, streamId);
    }

    /**
     * Removes a default stream for new users joining the organization.
     *
     * @see             <a href="https://zulip.com/api/remove-default-stream">https://zulip.com/api/remove-default-stream</a>
     *
     * @param  streamId The id of the stream to remove as a default for new users joining the organization
     * @return          The {@link RemoveDefaultStreamApiRequest} builder object
     */
    public RemoveDefaultStreamApiRequest removeDefaultStream(long streamId) {
        return new RemoveDefaultStreamApiRequest(this.client, streamId);
    }

    /**
     * Gets all users subscribed to a stream.
     *
     * @see             <a href="https://zulip.com/api/get-subscribers">https://zulip.com/api/get-subscribers</a>
     *
     * @param  streamId The id of the stream to get subscribers for
     * @return          The {@link GetStreamSubscribersApiRequest} builder object
     */
    public GetStreamSubscribersApiRequest getStreamSubscribers(long streamId) {
        return new GetStreamSubscribersApiRequest(this.client, streamId);
    }

    /**
     * Creates a new channel.
     *
     * @see                <a href="https://zulip.com/api/create-channel">https://zulip.com/api/create-channel</a>
     *
     * @param  name        The name of the channel
     * @param  subscribers The user ids that should be subscribed to the channel
     * @return             The {@link CreateChannelApiRequest} builder object
     */
    public CreateChannelApiRequest createChannel(String name, Long... subscribers) {
        return new CreateChannelApiRequest(this.client, name, subscribers);
    }

    /**
     * Creates a new channel folder.
     *
     * @see         <a href="https://zulip.com/api/create-channel-folder">https://zulip.com/api/create-channel-folder</a>
     *
     * @param  name The name of the channel folder
     * @return      The {@link CreateChannelFolderApiRequest} builder object
     */
    public CreateChannelFolderApiRequest createChannelFolder(String name) {
        return new CreateChannelFolderApiRequest(this.client, name);
    }

    /**
     * Gets all channel folders.
     *
     * @see    <a href="https://zulip.com/api/get-channel-folders">https://zulip.com/api/get-channel-folders</a>
     *
     * @return The {@link GetChannelFoldersApiRequest} builder object
     */
    public GetChannelFoldersApiRequest getChannelFolders() {
        return new GetChannelFoldersApiRequest(this.client);
    }

    /**
     * Reorders channel folders.
     *
     * @see                         <a href=
     *                              "https://zulip.com/api/get-channel-folders">https://zulip.com/api/get-channel-folders</a>
     *
     * @param  channelFolderIdOrder The order of the channel folder ids
     * @return                      The {@link GetChannelFoldersApiRequest} builder object
     */
    public ReorderChannelFoldersApiRequest reorderChannelFolders(Integer... channelFolderIdOrder) {
        return new ReorderChannelFoldersApiRequest(this.client, channelFolderIdOrder);
    }

    /**
     * Updates a channel folder.
     *
     * @see                    <a href=
     *                         "https://zulip.com/api/update-channel-folder">https://zulip.com/api/update-channel-folder</a>
     *
     * @param  channelFolderId The id of the channel folder to update
     * @return                 The {@link UpdateChannelFolderApiRequest} builder object
     */
    public UpdateChannelFolderApiRequest updateChannelFolder(int channelFolderId) {
        return new UpdateChannelFolderApiRequest(this.client, channelFolderId);
    }
}
