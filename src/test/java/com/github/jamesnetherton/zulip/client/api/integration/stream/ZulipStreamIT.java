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
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import org.junit.jupiter.api.Test;

public class ZulipStreamIT extends ZulipIntegrationTestBase {

    @Test
    public void streamCrudOperations() throws Exception {
        // Create
        StreamSubscriptionResult result = zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Test Stream 1", "Test Stream 1"),
                StreamSubscriptionRequest.of("Test Stream 2", "Test Stream 2"),
                StreamSubscriptionRequest.of("Test Stream 3", "Test Stream 3"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withWebPublic(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Map<String, List<String>> created = result.getSubscribed();
        assertTrue(created.containsKey("test@test.com"));
        assertEquals(3, created.get("test@test.com").size());

        // Read
        List<Stream> streams = zulip.streams().getAll()
                .withIncludeDefault(true)
                .execute();

        List<Stream> createdStreams = streams.stream()
                .filter(stream -> stream.getDescription().startsWith("Test Stream"))
                .collect(Collectors.toList());

        for (int i = 1; i < createdStreams.size(); i++) {
            Stream stream = createdStreams.get(i - 1);
            assertEquals("Test Stream " + i, stream.getDescription());
            assertEquals("<p>Test Stream " + i + "</p>", stream.getRenderedDescription());
            assertTrue(stream.getDateCreated().toEpochMilli() > 0);
            assertFalse(stream.isInviteOnly());
            assertEquals("Test Stream " + i, stream.getName());
            assertTrue(stream.getStreamId() > 0);
            assertFalse(stream.isWebPublic());
            assertEquals(StreamPostPolicy.ANY, stream.getStreamPostPolicy());
            assertTrue(stream.isHistoryPublicToSubscribers());
            assertEquals(-1, stream.getMessageRetentionDays());
            assertFalse(stream.isDefault());
            assertFalse(stream.isAnnouncementOnly());
        }

        long firstStreamId = createdStreams.get(0).getStreamId();

        // Update
        zulip.streams().updateStream(firstStreamId)
                .withDescription("Updated Description")
                .withName("Updated Name")
                .withMessageRetention(30)
                .withHistoryPublicToSubscribers(true)
                .withIsPrivate(false)
                .withWebPublic(false)
                .withStreamPostPolicy(StreamPostPolicy.ADMIN_ONLY)
                .execute();

        Optional<Stream> updatedStreamOptional = zulip.streams().getAll()
                .execute()
                .stream().filter(stream -> stream.getStreamId() == firstStreamId)
                .findFirst();

        Stream updatedStream = updatedStreamOptional.get();
        assertEquals("Updated Description", updatedStream.getDescription());
        assertEquals("<p>Updated Description</p>", updatedStream.getRenderedDescription());
        if (updatedStream.getDateCreated() != null) {
            assertTrue(updatedStream.getDateCreated().toEpochMilli() > 0);
        }
        assertFalse(updatedStream.isInviteOnly());
        assertEquals("Updated Name", updatedStream.getName());
        assertEquals(firstStreamId, updatedStream.getStreamId());
        assertFalse(updatedStream.isWebPublic());
        assertEquals(StreamPostPolicy.ADMIN_ONLY, updatedStream.getStreamPostPolicy());
        assertTrue(updatedStream.isHistoryPublicToSubscribers());
        assertEquals(30, updatedStream.getMessageRetentionDays());
        assertFalse(updatedStream.isDefault());
        assertTrue(updatedStream.isAnnouncementOnly());

        List<String> subscriptionSettings = zulip.streams().updateSubscriptionSettings()
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
        zulip.streams().delete(firstStreamId).execute();

        // Verify deletion
        streams = zulip.streams().getAll()
                .withIncludeDefault(true)
                .execute();
        assertEquals(2, streams.size());
    }

    @Test
    public void streamTopics() throws ZulipClientException {
        // Create
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Test Stream For Topic", "Test Stream For Topic"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        // Get ID
        Long streamId = zulip.streams().getStreamId("Test Stream For Topic").execute();

        List<Topic> topics = zulip.streams().getTopics(streamId).execute();
        assertEquals(1, topics.size());

        Topic topic = topics.get(0);
        assertEquals("stream events", topic.getName());
        assertTrue(topic.getMaxId() > 0);
    }

    @Test
    public void streamSubscribeUnsubscribe() throws ZulipClientException {
        // Create
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Test Subscribed", "Test Subscribed"))
                .execute();

        // Check subscriptions
        List<StreamSubscription> subscriptions = zulip.streams().getSubscribedStreams()
                .withIncludeSubscribers(true)
                .execute();
        assertEquals(1, subscriptions.size());

        StreamSubscription streamSubscription = subscriptions.get(0);
        List<String> subscribers = streamSubscription.getSubscribers();
        assertEquals(1, subscribers.size());

        String email = subscribers.get(0);
        assertEquals("8", email);

        // Get ID
        Long streamId = zulip.streams().getStreamId("Test Subscribed").execute();

        // Verify subscribed
        assertTrue(zulip.streams().isSubscribed(ownUser.getUserId(), streamId).execute());

        // Unsubscribe
        zulip.streams().unsubscribe("Test Subscribed").execute();
        assertFalse(zulip.streams().isSubscribed(ownUser.getUserId(), streamId).execute());
    }

    @Test
    public void deleteStreamTopic() throws ZulipClientException {
        // Create stream & topic
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Test Stream For Topic", "Test Stream For Topic"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Long streamId = zulip.streams().getStreamId("Test Stream For Topic").execute();

        List<Topic> topics = zulip.streams().getTopics(streamId).execute();
        assertEquals(1, topics.size());

        Topic topic = topics.get(0);
        assertEquals("stream events", topic.getName());
        assertTrue(topic.getMaxId() > 0);

        // Delete topic
        zulip.streams().deleteTopic(streamId, topic.getName()).execute();

        // Verify deletion
        topics = zulip.streams().getTopics(streamId).execute();
        assertTrue(topics.isEmpty());
    }

    @Test
    public void archiveStream() throws ZulipClientException {
        // Create stream & topic
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Test Stream For Topic", "Test Stream For Topic"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Long streamId = zulip.streams().getStreamId("Test Stream For Topic").execute();

        // Archive stream
        zulip.streams().archiveStream(streamId).execute();

        // Verify archival
        List<Stream> streams = zulip.streams().getAll().execute();
        assertTrue(streams.isEmpty());
    }
}
