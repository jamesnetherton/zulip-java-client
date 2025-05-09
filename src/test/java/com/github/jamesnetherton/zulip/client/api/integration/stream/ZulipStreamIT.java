package com.github.jamesnetherton.zulip.client.api.integration.stream;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.stream.RetentionPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;
import com.github.jamesnetherton.zulip.client.api.stream.StreamPostPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscription;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionResult;
import com.github.jamesnetherton.zulip.client.api.stream.Topic;
import com.github.jamesnetherton.zulip.client.api.stream.TopicVisibilityPolicy;
import com.github.jamesnetherton.zulip.client.api.user.UserGroup;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Test;

public class ZulipStreamIT extends ZulipIntegrationTestBase {

    @Test
    public void streamCrudOperations() throws Exception {
        List<UserGroup> groups = zulip.users().getUserGroups().execute();
        long groupIdA = groups.get(3).getId();
        long groupIdB = groups.get(4).getId();

        List<String> streamNames = java.util.stream.Stream.of(
                "Test Stream " + UUID.randomUUID(),
                "Test Stream " + UUID.randomUUID(),
                "Test Stream " + UUID.randomUUID())
                .sorted()
                .collect(Collectors.toList());

        // Create
        StreamSubscriptionResult result = zulip.channels().subscribe(
                StreamSubscriptionRequest.of(streamNames.get(0), streamNames.get(0)),
                StreamSubscriptionRequest.of(streamNames.get(1), streamNames.get(1)),
                StreamSubscriptionRequest.of(streamNames.get(2), streamNames.get(2)))
                .withAuthorizationErrorsFatal(false)
                .withCanRemoveSubscribersGroup(groupIdA)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withDefaultStream(false)
                .withWebPublic(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Map<String, List<String>> created = result.getSubscribed();
        assertTrue(created.containsKey(ownUser.getUserId().toString()));
        assertEquals(3, created.get(ownUser.getUserId().toString()).size());

        // Read
        List<Stream> streams = zulip.channels().getAll()
                .withIncludeDefault(true)
                .execute();

        List<Stream> createdStreams = streams.stream()
                .filter(stream -> stream.getDescription().startsWith("Test Stream"))
                .collect(Collectors.toList());

        for (int i = 1; i < createdStreams.size(); i++) {
            Stream stream = createdStreams.get(i - 1);
            assertEquals(streamNames.get(i - 1), stream.getDescription());
            assertEquals("<p>" + streamNames.get(i - 1) + "</p>", stream.getRenderedDescription());
            assertEquals(ownUser.getUserId(), stream.getCreatorId());
            assertTrue(stream.getDateCreated().toEpochMilli() > 0);
            assertFalse(stream.isInviteOnly());
            assertEquals(streamNames.get(i - 1), stream.getName());
            assertTrue(stream.getStreamId() > 0);
            assertFalse(stream.isWebPublic());
            assertEquals(StreamPostPolicy.ANY, stream.getStreamPostPolicy());
            assertTrue(stream.isHistoryPublicToSubscribers());
            assertEquals(-1, stream.getMessageRetentionDays());
            assertFalse(stream.isDefault());
            assertFalse(stream.isAnnouncementOnly());
            assertEquals(groupIdA, stream.canRemoveSubscribersGroup().getUserGroupId());
            assertEquals(0, stream.getStreamWeeklyTraffic());
        }

        // Get stream by ID
        for (int i = 1; i < createdStreams.size(); i++) {
            Stream stream = zulip.channels().getStream(createdStreams.get(i - 1).getStreamId()).execute();
            assertEquals(streamNames.get(i - 1), stream.getDescription());
            assertEquals("<p>" + streamNames.get(i - 1) + "</p>", stream.getRenderedDescription());
            assertEquals(ownUser.getUserId(), stream.getCreatorId());
            assertTrue(stream.getDateCreated().toEpochMilli() > 0);
            assertFalse(stream.isInviteOnly());
            assertEquals(streamNames.get(i - 1), stream.getName());
            assertTrue(stream.getStreamId() > 0);
            assertFalse(stream.isWebPublic());
            assertEquals(StreamPostPolicy.ANY, stream.getStreamPostPolicy());
            assertTrue(stream.isHistoryPublicToSubscribers());
            assertEquals(-1, stream.getMessageRetentionDays());
            assertFalse(stream.isDefault());
            assertFalse(stream.isAnnouncementOnly());
            assertEquals(groupIdA, stream.canRemoveSubscribersGroup().getUserGroupId());
        }

        long firstStreamId = createdStreams.get(0).getStreamId();

        // Update
        String updatedDescription = "Updated Description " + UUID.randomUUID();
        String updatedName = "Updated Name " + UUID.randomUUID();
        zulip.channels().updateStream(firstStreamId)
                .withCanRemoveSubscribersGroup(UserGroupSetting.of((int) groupIdB))
                .withDescription(updatedDescription)
                .withName(updatedName)
                .withMessageRetention(30)
                .withHistoryPublicToSubscribers(true)
                .withIsPrivate(false)
                .withDefaultStream(false)
                .withWebPublic(false)
                .withCanSendMessageGroup(UserGroupSetting.of((int) groupIdA))
                .execute();

        Optional<Stream> updatedStreamOptional = zulip.channels().getAll()
                .execute()
                .stream().filter(stream -> stream.getStreamId() == firstStreamId)
                .findFirst();

        Stream updatedStream = updatedStreamOptional.get();
        assertEquals(updatedDescription, updatedStream.getDescription());
        assertEquals("<p>" + updatedDescription + "</p>", updatedStream.getRenderedDescription());
        if (updatedStream.getDateCreated() != null) {
            assertTrue(updatedStream.getDateCreated().toEpochMilli() > 0);
        }
        assertFalse(updatedStream.isInviteOnly());
        assertEquals(updatedName, updatedStream.getName());
        assertEquals(firstStreamId, updatedStream.getStreamId());
        assertFalse(updatedStream.isWebPublic());
        assertEquals(StreamPostPolicy.UNKNOWN, updatedStream.getStreamPostPolicy());
        assertEquals(groupIdA, updatedStream.getCanSendMessageGroup().getUserGroupId());
        assertTrue(updatedStream.isHistoryPublicToSubscribers());
        assertEquals(30, updatedStream.getMessageRetentionDays());
        assertFalse(updatedStream.isDefault());
        assertFalse(updatedStream.isAnnouncementOnly());
        assertEquals(groupIdB, updatedStream.canRemoveSubscribersGroup().getUserGroupId());

        List<String> subscriptionSettings = zulip.channels().updateSubscriptionSettings()
                .withColor(updatedStream.getStreamId(), "#000000")
                .withAudibleNotifications(updatedStream.getStreamId(), true)
                .withDesktopNotifications(updatedStream.getStreamId(), true)
                .withEmailNotifications(updatedStream.getStreamId(), true)
                .withIsMuted(updatedStream.getStreamId(), true)
                .withPinToTop(updatedStream.getStreamId(), true)
                .withPushNotifications(updatedStream.getStreamId(), false)
                .execute();

        assertNotNull(subscriptionSettings);
        assertTrue(subscriptionSettings.isEmpty());

        // Delete
        zulip.channels().delete(firstStreamId).execute();

        // Verify deletion
        streams = zulip.channels().getAll()
                .withIncludeDefault(true)
                .execute();
        assertEquals(2, streams.size());
    }

    @Test
    public void streamTopics() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();

        // Create
        zulip.channels().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        // Get ID
        Long streamId = zulip.channels().getStreamId(streamName).execute();

        List<Topic> topics = zulip.channels().getTopics(streamId).allowEmptyTopicName(true).execute();
        assertEquals(1, topics.size());

        Topic topic = topics.get(0);
        assertEquals("channel events", topic.getName());
        assertTrue(topic.getMaxId() > 0);
    }

    @Test
    public void streamSubscribeUnsubscribe() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();

        // Create
        zulip.channels().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .execute();

        // Check subscriptions
        List<StreamSubscription> subscriptions = zulip.channels().getSubscribedStreams()
                .withIncludeSubscribers(true)
                .execute();
        assertEquals(1, subscriptions.size());

        StreamSubscription streamSubscription = subscriptions.get(0);
        assertFalse(streamSubscription.isAudibleNotifications());
        assertFalse(streamSubscription.isDesktopNotifications());
        assertTrue(streamSubscription.isHistoryPublicToSubscribers());
        assertFalse(streamSubscription.isInviteOnly());
        assertFalse(streamSubscription.isMuted());
        assertFalse(streamSubscription.isPinToTop());
        assertFalse(streamSubscription.isPushNotifications());
        assertFalse(streamSubscription.isWebPublic());
        assertFalse(streamSubscription.isWildcardMentionsNotify());
        assertNotNull(streamSubscription.getColor());
        assertTrue(streamSubscription.getColor().matches("#[a-z0-9]+"));
        assertEquals(ownUser.getUserId(), streamSubscription.getCreatorId());
        assertEquals(streamName, streamSubscription.getDescription());
        assertTrue(streamSubscription.getFirstMessageId() > 0);
        assertEquals(0, streamSubscription.getMessageRetentionDays());
        assertEquals(streamName, streamSubscription.getName());
        assertEquals("<p>" + streamName + "</p>", streamSubscription.getRenderedDescription());
        assertTrue(streamSubscription.getStreamId() > 0);
        assertEquals(0, streamSubscription.getStreamWeeklyTraffic());
        assertEquals(11, streamSubscription.getCanRemoveSubscribersGroup());

        List<String> subscribers = streamSubscription.getSubscribers();
        assertEquals(1, subscribers.size());

        String subscriberId = subscribers.get(0);
        assertEquals("8", subscriberId);

        // Get ID
        Long streamId = zulip.channels().getStreamId(streamName).execute();

        // Verify subscribed
        assertTrue(zulip.channels().isSubscribed(ownUser.getUserId(), streamId).execute());

        // Unsubscribe
        zulip.channels().unsubscribe(streamName).execute();
        assertFalse(zulip.channels().isSubscribed(ownUser.getUserId(), streamId).execute());
    }

    @Test
    public void deleteStreamTopic() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();

        // Create stream & topic
        zulip.channels().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Long streamId = zulip.channels().getStreamId(streamName).execute();

        List<Topic> topics = zulip.channels().getTopics(streamId).execute();
        assertEquals(1, topics.size());

        Topic topic = topics.get(0);
        assertEquals("channel events", topic.getName());
        assertTrue(topic.getMaxId() > 0);

        // Delete topic
        zulip.channels().deleteTopic(streamId, topic.getName()).execute();

        // Verify deletion
        topics = zulip.channels().getTopics(streamId).execute();
        assertTrue(topics.isEmpty());
    }

    @Test
    public void archiveStream() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();

        // Create stream & topic
        zulip.channels().subscribe(
                StreamSubscriptionRequest.of(streamName, streamName))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Long streamId = zulip.channels().getStreamId(streamName).execute();

        // Archive stream
        zulip.channels().archiveStream(streamId).execute();

        // Verify archival
        List<Stream> streams = zulip.channels().getAll().execute();
        assertTrue(streams.isEmpty());
    }

    @Test
    public void updateUserTopicPreferences() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();

        StreamSubscriptionResult result = zulip.channels()
                .subscribe(StreamSubscriptionRequest.of(streamName, streamName)).execute();
        Map<String, List<String>> subscribed = result.getSubscribed();
        assertEquals(1, subscribed.size());

        Long streamId = zulip.channels().getStreamId(streamName).execute();

        zulip.channels().muteTopic(streamName)
                .withStreamId(streamId)
                .execute();
        zulip.channels().unmuteTopic(streamName)
                .withStreamId(streamId)
                .execute();

        for (TopicVisibilityPolicy topicVisibilityPolicy : TopicVisibilityPolicy.values()) {
            zulip.channels().updateUserTopicPreferences(streamId, streamName, topicVisibilityPolicy).execute();
        }
    }

    @Test
    public void defaultStreams() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();

        StreamSubscriptionResult result = zulip.channels()
                .subscribe(StreamSubscriptionRequest.of(streamName, streamName))
                .execute();

        Map<String, List<String>> subscribed = result.getSubscribed();
        assertEquals(1, subscribed.size());

        Long streamId = zulip.channels().getStreamId(streamName).execute();

        zulip.channels().addDefaultStream(streamId).execute();

        String uuid = UUID.randomUUID().toString().substring(0, 5);

        long userIdA = zulip.users().createUser("foo@" + uuid + ".com", "Foo Bar", "f00B4r").execute();

        List<Long> subscribers = zulip.channels().getStreamSubscribers(streamId).execute();
        assertTrue(subscribers.contains(userIdA));

        zulip.channels().removeDefaultStream(streamId).execute();

        long userIdB = zulip.users().createUser("bar@" + uuid + ".com", "Bar Foo", "f00B4r").execute();

        subscribers = zulip.channels().getStreamSubscribers(streamId).execute();
        assertFalse(subscribers.contains(userIdB));
    }

    @Test
    public void streamEmailAddress() throws ZulipClientException {
        String streamName = UUID.randomUUID().toString();

        StreamSubscriptionResult result = zulip.channels()
                .subscribe(StreamSubscriptionRequest.of(streamName, streamName))
                .execute();

        Map<String, List<String>> subscribed = result.getSubscribed();
        assertEquals(1, subscribed.size());

        Long streamId = zulip.channels().getStreamId(streamName).execute();
        String email = zulip.channels().getStreamEmailAddress(streamId).execute();
        assertNotNull(email);
    }
}
