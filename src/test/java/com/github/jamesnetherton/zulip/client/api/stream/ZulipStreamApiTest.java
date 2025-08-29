package com.github.jamesnetherton.zulip.client.api.stream;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.PATCH;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static com.github.tomakehurst.wiremock.stubbing.Scenario.STARTED;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.channel.ChannelFolder;
import com.github.jamesnetherton.zulip.client.api.channel.request.CreateChannelApiRequest;
import com.github.jamesnetherton.zulip.client.api.channel.request.CreateChannelFolderApiRequest;
import com.github.jamesnetherton.zulip.client.api.channel.request.GetChannelFoldersApiRequest;
import com.github.jamesnetherton.zulip.client.api.channel.request.ReorderChannelFoldersApiRequest;
import com.github.jamesnetherton.zulip.client.api.channel.request.UpdateChannelFolderApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.TopicPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.request.AddDefaultStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.DeleteTopicApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamIdApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamTopicsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.GetSubscribedStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.MuteTopicApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.SubscribeStreamsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UpdateStreamApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UpdateStreamSubscriptionSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.request.UpdateUserTopicPreferencesApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipStreamApiTest extends ZulipApiTestBase {

    @Test
    public void getSubscribedStreams() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetSubscribedStreamsApiRequest.INCLUDE_SUBSCRIBERS, "true")
                .get();

        stubZulipResponse(GET, "/users/me/subscriptions", params, "getSubscriptions.json");

        List<StreamSubscription> subscriptions = zulip.channels().getSubscribedStreams()
                .withIncludeSubscribers(true)
                .execute();

        assertEquals(2, subscriptions.size());

        StreamSubscription subscriptionA = subscriptions.get(0);
        assertTrue(subscriptionA.isAudibleNotifications());
        assertEquals("#e79ab5", subscriptionA.getColor());
        assertEquals(1, subscriptionA.getCreatorId());
        assertEquals("A Scandinavian country", subscriptionA.getDescription());
        assertEquals("<p>A Scandinavian country</p>", subscriptionA.getRenderedDescription());
        assertTrue(subscriptionA.isDesktopNotifications());
        assertFalse(subscriptionA.isInviteOnly());
        assertFalse(subscriptionA.isMuted());
        assertEquals("Denmark", subscriptionA.getName());
        assertFalse(subscriptionA.isPinToTop());
        assertFalse(subscriptionA.isPushNotifications());
        assertEquals(1, subscriptionA.getStreamId());
        assertTrue(subscriptionA.isWebPublic());
        assertFalse(subscriptionA.isWildcardMentionsNotify());
        assertEquals(1, subscriptionA.getStreamWeeklyTraffic());
        assertEquals(1, subscriptionA.getCanRemoveSubscribersGroup().getUserGroupId());
        assertEquals(30, subscriptionA.getMessageRetentionDays());
        assertTrue(subscriptionA.isHistoryPublicToSubscribers());
        assertEquals(1, subscriptionA.getFirstMessageId());
        assertTrue(subscriptionA.isEmailNotifications());
        assertTrue(subscriptionA.getDateCreated().toEpochMilli() > 0);
        assertEquals(5, subscriptionA.getSubscribers().size());
        assertEquals(TopicPolicy.INHERIT, subscriptionA.getTopicPolicy());
        assertEquals(1, subscriptionA.getSubscriberCount());
        assertTrue(subscriptionA.getPartialSubscribers().isEmpty());

        StreamSubscription subscriptionB = subscriptions.get(1);
        assertTrue(subscriptionB.isAudibleNotifications());
        assertEquals("#e79ab5", subscriptionB.getColor());
        assertEquals(2, subscriptionB.getCreatorId());
        assertEquals("<p>Located in the United Kingdom</p>", subscriptionB.getRenderedDescription());
        assertTrue(subscriptionB.isDesktopNotifications());
        assertFalse(subscriptionB.isInviteOnly());
        assertFalse(subscriptionB.isMuted());
        assertEquals("Scotland", subscriptionB.getName());
        assertFalse(subscriptionB.isPinToTop());
        assertFalse(subscriptionB.isPushNotifications());
        assertEquals(3, subscriptionB.getStreamId());
        assertTrue(subscriptionB.isWebPublic());
        assertFalse(subscriptionB.isWildcardMentionsNotify());
        assertEquals(1, subscriptionB.getStreamWeeklyTraffic());
        assertEquals(30, subscriptionB.getMessageRetentionDays());
        assertTrue(subscriptionB.isHistoryPublicToSubscribers());
        assertEquals(1, subscriptionB.getFirstMessageId());
        assertTrue(subscriptionB.isEmailNotifications());
        assertTrue(subscriptionB.getDateCreated().toEpochMilli() > 0);
        assertEquals(4, subscriptionB.getSubscribers().size());
        assertEquals(TopicPolicy.ALLOW_EMPTY_TOPIC, subscriptionB.getTopicPolicy());
        assertEquals(2, subscriptionB.getSubscriberCount());
        assertEquals(1, subscriptionB.getCanDeleteAnyMessageGroup().getUserGroupId());
        assertEquals(2, subscriptionB.getCanDeleteOwnMessageGroup().getUserGroupId());
        assertEquals(3, subscriptionB.getCanMoveMessagesOutOfChannelGroup().getUserGroupId());
        assertEquals(4, subscriptionB.getCanMoveMessagesWithinChannelGroup().getUserGroupId());
        assertEquals(5, subscriptionB.getCanMoveMessagesBetweenChannelsGroup().getUserGroupId());
        assertEquals(6, subscriptionB.getCanMoveMessagesBetweenTopicsGroup().getUserGroupId());
        assertEquals(7, subscriptionB.getCanResolveTopicsGroup().getUserGroupId());
        assertEquals(8, subscriptionB.getCanSendMessageGroup().getUserGroupId());
        assertEquals(9, subscriptionB.getCanSubscribeGroup().getUserGroupId());
        assertEquals(10, subscriptionB.getCanAdministerChannelGroup().getUserGroupId());
        assertEquals(11, subscriptionB.getCanRemoveSubscribersGroupId().getUserGroupId());
        assertEquals(12, subscriptionB.getCanRemoveSubscribersGroup().getUserGroupId());
        assertEquals(13, subscriptionB.getCanAddSubscribersGroup().getUserGroupId());
        assertEquals(3, subscriptionB.getPartialSubscribers().size());
    }

    @Test
    public void subscribe() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SubscribeStreamsApiRequest.ANNOUNCE, "true")
                .add(SubscribeStreamsApiRequest.AUTHORIZATION_ERRORS_FATAL, "false")
                .add(SubscribeStreamsApiRequest.CAN_ADD_SUBSCRIBERS_GROUP, "1")
                .add(SubscribeStreamsApiRequest.CAN_ADMINISTER_CHANNEL_GROUP, "2")
                .add(SubscribeStreamsApiRequest.CAN_DELETE_ANY_MESSAGE_GROUP, "3")
                .add(SubscribeStreamsApiRequest.CAN_DELETE_OWN_MESSAGE_GROUP, "4")
                .add(SubscribeStreamsApiRequest.CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP, "5")
                .add(SubscribeStreamsApiRequest.CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP, "6")
                .add(SubscribeStreamsApiRequest.CAN_SEND_MESSAGE_GROUP, "7")
                .add(SubscribeStreamsApiRequest.CAN_SUBSCRIBE_GROUP, "8")
                .add(SubscribeStreamsApiRequest.CAN_REMOVE_SUBSCRIBERS_GROUP, "9")
                .add(SubscribeStreamsApiRequest.CAN_RESOLVE_TOPICS_GROUP, "10")
                .add(SubscribeStreamsApiRequest.TOPICS_POLICY, "\"inherit\"")
                .add(SubscribeStreamsApiRequest.FOLDER_ID, "1")
                .add(SubscribeStreamsApiRequest.SEND_NEW_SUBSCRIPTION_MESSAGES, "true")
                .add(SubscribeStreamsApiRequest.HISTORY_PUBLIC_TO_SUBSCRIBERS, "true")
                .add(SubscribeStreamsApiRequest.INVITE_ONLY, "false")
                .add(SubscribeStreamsApiRequest.IS_DEFAULT_STREAM, "true")
                .add(SubscribeStreamsApiRequest.IS_WEB_PUBLIC, "true")
                .add(SubscribeStreamsApiRequest.MESSAGE_RETENTION_DAYS, "\"unlimited\"")
                .add(SubscribeStreamsApiRequest.PRINCIPALS, "[1,2,3]")
                .add(SubscribeStreamsApiRequest.SUBSCRIPTIONS,
                        "[{\"name\":\"foo\",\"description\":\"bar\"},{\"name\":\"secret\",\"description\":\"stream\"},{\"name\":\"old\",\"description\":\"stream\"},{\"name\":\"cheese\",\"description\":\"wine\"}]")
                .add(SubscribeStreamsApiRequest.STREAM_POST_POLICY, "3")
                .get();

        stubZulipResponse(POST, "/users/me/subscriptions", params, "subscribe.json");

        StreamSubscriptionResult result = zulip.channels().subscribe(
                StreamSubscriptionRequest.of("foo", "bar"),
                StreamSubscriptionRequest.of("secret", "stream"),
                StreamSubscriptionRequest.of("old", "stream"),
                StreamSubscriptionRequest.of("cheese", "wine"))
                .withAnnounce(true)
                .withAuthorizationErrorsFatal(false)
                .withCanAddSubscribersGroup(UserGroupSetting.of(1))
                .withCanAdministerChannelGroup(UserGroupSetting.of(2))
                .withCanDeleteAnyMessageGroup(UserGroupSetting.of(3))
                .withCanDeleteOwnMessageGroup(UserGroupSetting.of(4))
                .withCanMoveMessagesOutOfChannelGroup(UserGroupSetting.of(5))
                .withCanMoveMessagesWithinChannelGroup(UserGroupSetting.of(6))
                .withCanSendMessageGroup(UserGroupSetting.of(7))
                .withCanSubscribeGroup(UserGroupSetting.of(8))
                .withCanRemoveSubscribersGroup(9)
                .withCanResolveTopicsGroup(UserGroupSetting.of(10))
                .withTopicPolicy(TopicPolicy.INHERIT)
                .withFolderId(1)
                .withSendNewSubscriptionMessages(true)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withDefaultStream(true)
                .withWebPublic(true)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withPrincipals(1, 2, 3)
                .withStreamPostPolicy(StreamPostPolicy.NEW_MEMBERS_ONLY)
                .execute();

        Map<String, List<String>> subscriptions = result.getSubscribed();
        assertEquals(2, subscriptions.size());

        List<String> streamSubscriptionA = subscriptions.get("foo@bar.com");
        assertNotNull(streamSubscriptionA);
        assertEquals(1, streamSubscriptionA.size());
        assertEquals("new stream", streamSubscriptionA.get(0));

        List<String> streamSubscriptionB = subscriptions.get("cheese@wine.net");
        assertNotNull(streamSubscriptionB);
        assertEquals(1, streamSubscriptionB.size());
        assertEquals("new other stream", streamSubscriptionB.get(0));

        Map<String, List<String>> alreadySubscribed = result.getAlreadySubscribed();
        assertEquals(1, alreadySubscribed.size());

        List<String> alreadySubscribedStreams = alreadySubscribed.get("test@test.com");
        assertEquals(1, alreadySubscribedStreams.size());
        assertEquals("old stream", alreadySubscribedStreams.get(0));

        List<String> unauthorized = result.getUnauthorized();
        assertEquals(1, unauthorized.size());
        assertEquals("secret stream", unauthorized.get(0));

        assertTrue(result.isNewSubscriptionMessagesSent());
    }

    @Test
    public void subscribeWithStringPrincipals() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SubscribeStreamsApiRequest.ANNOUNCE, "true")
                .add(SubscribeStreamsApiRequest.AUTHORIZATION_ERRORS_FATAL, "false")
                .add(SubscribeStreamsApiRequest.HISTORY_PUBLIC_TO_SUBSCRIBERS, "true")
                .add(SubscribeStreamsApiRequest.INVITE_ONLY, "false")
                .add(SubscribeStreamsApiRequest.IS_WEB_PUBLIC, "false")
                .add(SubscribeStreamsApiRequest.MESSAGE_RETENTION_DAYS, "30")
                .add(SubscribeStreamsApiRequest.PRINCIPALS, "[\"test@test.com\",\"foo@bar.com\"]")
                .add(SubscribeStreamsApiRequest.SUBSCRIPTIONS,
                        "[{\"name\":\"foo\",\"description\":\"bar\"},{\"name\":\"secret\",\"description\":\"stream\"},{\"name\":\"old\",\"description\":\"stream\"},{\"name\":\"cheese\",\"description\":\"wine\"}]")
                .add(SubscribeStreamsApiRequest.STREAM_POST_POLICY, "3")
                .get();

        stubZulipResponse(POST, "/users/me/subscriptions", params, "subscribe.json");

        StreamSubscriptionResult result = zulip.channels().subscribe(
                StreamSubscriptionRequest.of("foo", "bar"),
                StreamSubscriptionRequest.of("secret", "stream"),
                StreamSubscriptionRequest.of("old", "stream"),
                StreamSubscriptionRequest.of("cheese", "wine"))
                .withAnnounce(true)
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withWebPublic(false)
                .withMessageRetention(30)
                .withPrincipals("test@test.com", "foo@bar.com")
                .withStreamPostPolicy(StreamPostPolicy.NEW_MEMBERS_ONLY)
                .execute();

        Map<String, List<String>> subscriptions = result.getSubscribed();
        assertEquals(2, subscriptions.size());

        List<String> streamSubscriptionA = subscriptions.get("foo@bar.com");
        assertNotNull(streamSubscriptionA);
        assertEquals(1, streamSubscriptionA.size());
        assertEquals("new stream", streamSubscriptionA.get(0));

        List<String> streamSubscriptionB = subscriptions.get("cheese@wine.net");
        assertNotNull(streamSubscriptionB);
        assertEquals(1, streamSubscriptionB.size());
        assertEquals("new other stream", streamSubscriptionB.get(0));

        Map<String, List<String>> alreadySubscribed = result.getAlreadySubscribed();
        assertEquals(1, alreadySubscribed.size());

        List<String> alreadySubscribedStreams = alreadySubscribed.get("test@test.com");
        assertEquals(1, alreadySubscribedStreams.size());
        assertEquals("old stream", alreadySubscribedStreams.get(0));

        List<String> unauthorized = result.getUnauthorized();
        assertEquals(1, unauthorized.size());
        assertEquals("secret stream", unauthorized.get(0));
    }

    @Test
    public void unsubscribe() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SubscribeStreamsApiRequest.PRINCIPALS, "[1,2,3]")
                .add(SubscribeStreamsApiRequest.SUBSCRIPTIONS, "[\"foo\",\"bar\"]")
                .get();

        stubZulipResponse(DELETE, "/users/me/subscriptions", params, "unsubscribe.json");

        StreamUnsubscribeResult result = zulip.channels().unsubscribe("foo", "bar")
                .withPrincipals(1, 2, 3)
                .execute();

        List<String> removed = result.getRemoved();
        assertEquals(2, removed.size());
        assertEquals("foo", removed.get(0));
        assertEquals("bar", removed.get(1));

        List<String> notRemoved = result.getNotRemoved();
        assertEquals(2, notRemoved.size());
        assertEquals("cheese", notRemoved.get(0));
        assertEquals("wine", notRemoved.get(1));
    }

    @Test
    public void unsubscribeWithStringPrincipals() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SubscribeStreamsApiRequest.PRINCIPALS, "[\"test@test.com\",\"foo@bar.com\"]")
                .add(SubscribeStreamsApiRequest.SUBSCRIPTIONS, "[\"foo\",\"bar\"]")
                .get();

        stubZulipResponse(DELETE, "/users/me/subscriptions", params, "unsubscribe.json");

        StreamUnsubscribeResult result = zulip.channels().unsubscribe("foo", "bar")
                .withPrincipals("test@test.com", "foo@bar.com")
                .execute();

        List<String> removed = result.getRemoved();
        assertEquals(2, removed.size());
        assertEquals("foo", removed.get(0));
        assertEquals("bar", removed.get(1));

        List<String> notRemoved = result.getNotRemoved();
        assertEquals(2, notRemoved.size());
        assertEquals("cheese", notRemoved.get(0));
        assertEquals("wine", notRemoved.get(1));
    }

    @Test
    public void subscriptionStatus() throws Exception {
        stubZulipResponse(GET, "/users/1/subscriptions/2", "subscriptionStatus.json");

        assertTrue(zulip.channels().isSubscribed(1, 2).execute());
    }

    @Test
    public void getStreamId() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetStreamIdApiRequest.STREAM, "foo")
                .get();

        stubZulipResponse(GET, "/get_stream_id", params, "streamId.json");

        Long streamId = zulip.channels().getStreamId("foo").execute();

        assertEquals(15, streamId);
    }

    @Test
    public void delete() throws Exception {
        stubZulipResponse(DELETE, "/streams/1", SUCCESS_JSON);

        zulip.channels().delete(1).execute();
    }

    @Test
    public void streamTopics() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetStreamTopicsApiRequest.ALLOW_EMPTY_TOPIC_NAME, "true")
                .get();

        stubZulipResponse(GET, "/users/me/1/topics", params, "streamTopics.json");

        List<Topic> topics = zulip.channels().getTopics(1)
                .allowEmptyTopicName(true)
                .execute();

        for (int i = 1; i <= topics.size(); i++) {
            Topic topic = topics.get(i - 1);
            assertEquals(i, topic.getMaxId());
            assertEquals("Topic " + i, topic.getName());
        }
    }

    @Test
    public void updateStream() throws Exception {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("direct_members", List.of(1, 2, 3));
        data.put("direct_subgroups", List.of(4, 5, 6));
        Map<String, StringValuePattern> params = QueryParams.create()
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_REMOVE_SUBSCRIBERS_GROUP, Map.of("new", 1))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_ADD_SUBSCRIBERS_GROUP, Map.of("new", 2))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_ADMINISTER_CHANNEL_GROUP, Map.of("new", 3))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_SUBSCRIBE_GROUP, Map.of("new", 4))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_SEND_MESSAGE_GROUP, Map.of("new", data))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_DELETE_ANY_MESSAGE_GROUP, Map.of("new", 5))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_DELETE_OWN_MESSAGE_GROUP, Map.of("new", 6))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP, Map.of("new", 7))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP, Map.of("new", 8))
                .addAsRawJsonString(UpdateStreamApiRequest.CAN_RESOLVE_TOPICS_GROUP, Map.of("new", 9))
                .add(UpdateStreamApiRequest.DESCRIPTION, "New description")
                .add(UpdateStreamApiRequest.HISTORY_PUBLIC_TO_SUBSCRIBERS, "true")
                .add(UpdateStreamApiRequest.MESSAGE_RETENTION_DAYS, "30")
                .add(UpdateStreamApiRequest.NEW_NAME, "New name")
                .add(UpdateStreamApiRequest.IS_PRIVATE, "true")
                .add(UpdateStreamApiRequest.IS_DEFAULT_STREAM, "true")
                .add(UpdateStreamApiRequest.IS_WEB_PUBLIC, "true")
                .add(UpdateStreamApiRequest.FOLDER_ID, "1")
                .add(UpdateStreamApiRequest.TOPICS_POLICY, "inherit")
                .add(UpdateStreamApiRequest.IS_ARCHIVED, "true")
                .get();

        stubZulipResponse(PATCH, "/streams/1", params);

        zulip.channels().updateStream(1)
                .withCanRemoveSubscribersGroup(UserGroupSetting.of(1))
                .withCanAddSubscribersGroup(UserGroupSetting.of(2))
                .withCanAdministerChannelGroup(UserGroupSetting.of(3))
                .withCanSubscribeGroup(UserGroupSetting.of(4))
                .withCanSendMessageGroup(UserGroupSetting.of(List.of(1L, 2L, 3L), List.of(4L, 5L, 6L)))
                .withCanDeleteAnyMessageGroup(UserGroupSetting.of(5))
                .withCanDeleteOwnMessageGroup(UserGroupSetting.of(6))
                .withCanMoveMessagesOutOfChannelGroup(UserGroupSetting.of(7))
                .withCanMoveMessagesWithinChannelGroup(UserGroupSetting.of(8))
                .withCanResolveTopicsGroup(UserGroupSetting.of(9))
                .withDescription("New description")
                .withHistoryPublicToSubscribers(true)
                .withMessageRetention(30)
                .withName("New name")
                .withIsPrivate(true)
                .withDefaultStream(true)
                .withWebPublic(true)
                .withIsArchived(true)
                .withFolderId(1)
                .withTopicPolicy(TopicPolicy.INHERIT)
                .execute();
    }

    @Test
    public void updateStreamWithMessageRetentionPolicy() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateStreamApiRequest.DESCRIPTION, "New description")
                .add(UpdateStreamApiRequest.HISTORY_PUBLIC_TO_SUBSCRIBERS, "true")
                .add(UpdateStreamApiRequest.MESSAGE_RETENTION_DAYS, "\"unlimited\"")
                .add(UpdateStreamApiRequest.NEW_NAME, "New name")
                .add(UpdateStreamApiRequest.IS_PRIVATE, "true")
                .get();

        stubZulipResponse(PATCH, "/streams/1", params);

        zulip.channels().updateStream(1)
                .withDescription("New description")
                .withHistoryPublicToSubscribers(true)
                .withMessageRetention(RetentionPolicy.UNLIMITED)
                .withName("New name")
                .withIsPrivate(true)
                .execute();
    }

    @Test
    public void getAll() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetStreamsApiRequest.INCLUDE_ALL, "true")
                .add(GetStreamsApiRequest.INCLUDE_DEFAULT, "true")
                .add(GetStreamsApiRequest.INCLUDE_OWNER_SUBSCRIBED, "true")
                .add(GetStreamsApiRequest.INCLUDE_SUBSCRIBED, "true")
                .add(GetStreamsApiRequest.INCLUDE_PUBLIC, "true")
                .add(GetStreamsApiRequest.INCLUDE_WEB_PUBLIC, "true")
                .get();

        stubZulipResponse(GET, "/streams", params, "streams.json");

        List<Stream> streams = zulip.channels().getAll()
                .withIncludeAll(true)
                .withIncludeDefault(true)
                .withOwnerSubscribed(true)
                .withIncludeSubscribed(true)
                .withIncludePublic(true)
                .withIncludeWebPublic(true)
                .execute();

        for (int i = 1; i < streams.size(); i++) {
            Stream stream = streams.get(i - 1);
            assertEquals("Test Stream Description " + i, stream.getDescription());
            assertEquals("<p>Test Stream Description " + i + "</p>", stream.getRenderedDescription());
            assertEquals(i, stream.getCreatorId());
            assertTrue(stream.getDateCreated().toEpochMilli() > 0);
            assertTrue(stream.isInviteOnly());
            assertEquals("Test Stream Name " + i, stream.getName());
            assertEquals(i, stream.getStreamId());
            assertFalse(stream.isWebPublic());
            assertFalse(stream.isHistoryPublicToSubscribers());
            assertEquals(i, stream.getMessageRetentionDays());
            assertTrue(stream.isDefault());
            assertFalse(stream.isAnnouncementOnly());
            assertEquals(1, stream.getCanDeleteAnyMessageGroup().getUserGroupId());
            assertEquals(2, stream.getCanDeleteOwnMessageGroup().getUserGroupId());
            assertEquals(3, stream.getCanMoveMessagesOutOfChannelGroup().getUserGroupId());
            assertEquals(4, stream.getCanMoveMessagesWithinChannelGroup().getUserGroupId());
            assertEquals(5, stream.getCanMoveMessagesBetweenChannelsGroup().getUserGroupId());
            assertEquals(6, stream.getCanMoveMessagesBetweenTopicsGroup().getUserGroupId());
            assertEquals(7, stream.getCanResolveTopicsGroup().getUserGroupId());
            assertEquals(8, stream.getCanSendMessageGroup().getUserGroupId());
            assertEquals(i, stream.getSubscriberCount());
            assertEquals(i, stream.getStreamWeeklyTraffic());
            assertEquals(i, stream.getFolderId());

            if (i < 3) {
                assertEquals(StreamPostPolicy.fromInt(i), stream.getStreamPostPolicy());
                assertEquals(9, stream.getCanSubscribeGroup().getUserGroupId());
                assertEquals(10, stream.getCanAdministerChannelGroup().getUserGroupId());
                assertEquals(11, stream.getCanRemoveSubscribersGroup().getUserGroupId());
                assertEquals(12, stream.getCanAddSubscribersGroup().getUserGroupId());
                assertEquals(TopicPolicy.INHERIT, stream.getTopicPolicy());
            } else {
                assertEquals(StreamPostPolicy.UNKNOWN, stream.getStreamPostPolicy());
                assertTrue(stream.isArchived());
                assertTrue(stream.isRecentlyActive());
                assertEquals(List.of(1L, 2L, 3L), stream.getCanSubscribeGroup().getDirectMembers());
                assertEquals(List.of(4L, 5L, 6L), stream.getCanSubscribeGroup().getDirectSubGroups());
                assertEquals(9, stream.getCanAdministerChannelGroup().getUserGroupId());
                assertEquals(10, stream.getCanRemoveSubscribersGroup().getUserGroupId());
                assertEquals(11, stream.getCanAddSubscribersGroup().getUserGroupId());
                assertEquals(TopicPolicy.EMPTY_TOPIC_ONLY, stream.getTopicPolicy());
            }
        }
    }

    @Test
    public void getStreamById() throws Exception {
        stubZulipResponse(GET, "/streams/1", "getStreamById.json");

        Stream stream = zulip.channels().getStream(1).execute();
        assertEquals("Test Stream Description", stream.getDescription());
        assertEquals("<p>Test Stream Description</p>", stream.getRenderedDescription());
        assertEquals(1, stream.getCreatorId());
        assertTrue(stream.getDateCreated().toEpochMilli() > 0);
        assertTrue(stream.isInviteOnly());
        assertEquals("Test Stream Name", stream.getName());
        assertEquals(1, stream.getStreamId());
        assertTrue(stream.isWebPublic());
        assertTrue(stream.isHistoryPublicToSubscribers());
        assertEquals(10, stream.getMessageRetentionDays());
        assertFalse(stream.isDefault());
        assertTrue(stream.isAnnouncementOnly());
        assertEquals(1, stream.getStreamWeeklyTraffic());
        assertTrue(stream.isArchived());
        assertTrue(stream.isRecentlyActive());
        assertEquals(List.of(1L, 2L, 3L), stream.getCanSubscribeGroup().getDirectMembers());
        assertEquals(List.of(4L, 5L, 6L), stream.getCanSubscribeGroup().getDirectSubGroups());
        assertEquals(1, stream.getCanDeleteAnyMessageGroup().getUserGroupId());
        assertEquals(2, stream.getCanDeleteOwnMessageGroup().getUserGroupId());
        assertEquals(3, stream.getCanMoveMessagesOutOfChannelGroup().getUserGroupId());
        assertEquals(4, stream.getCanMoveMessagesWithinChannelGroup().getUserGroupId());
        assertEquals(5, stream.getCanMoveMessagesBetweenChannelsGroup().getUserGroupId());
        assertEquals(6, stream.getCanMoveMessagesBetweenTopicsGroup().getUserGroupId());
        assertEquals(7, stream.getCanResolveTopicsGroup().getUserGroupId());
        assertEquals(8, stream.getCanSendMessageGroup().getUserGroupId());
        assertEquals(9, stream.getCanAdministerChannelGroup().getUserGroupId());
        assertEquals(10, stream.getCanRemoveSubscribersGroup().getUserGroupId());
        assertEquals(11, stream.getCanAddSubscribersGroup().getUserGroupId());
        assertEquals(1, stream.getSubscriberCount());
        assertEquals(1, stream.getStreamWeeklyTraffic());
        assertEquals(1, stream.getFolderId());
        assertEquals(TopicPolicy.INHERIT, stream.getTopicPolicy());
    }

    @Test
    public void muteTopic() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(MuteTopicApiRequest.STREAM, "Test Stream")
                .add(MuteTopicApiRequest.STREAM_ID, "1")
                .add(MuteTopicApiRequest.TOPIC, "Test Topic")
                .add(MuteTopicApiRequest.OPERATION, "add")
                .get();

        stubZulipResponse(PATCH, "/users/me/subscriptions/muted_topics", params);

        zulip.channels().muteTopic("Test Topic")
                .withStream("Test Stream")
                .withStreamId(1)
                .execute();
    }

    @Test
    public void unmuteTopic() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(MuteTopicApiRequest.STREAM, "Test Stream")
                .add(MuteTopicApiRequest.STREAM_ID, "1")
                .add(MuteTopicApiRequest.TOPIC, "Test Topic")
                .add(MuteTopicApiRequest.OPERATION, "remove")
                .get();

        stubZulipResponse(PATCH, "/users/me/subscriptions/muted_topics", params);

        zulip.channels().unmuteTopic("Test Topic")
                .withStream("Test Stream")
                .withStreamId(1)
                .execute();
    }

    @Test
    public void updateSubscriptionSettings() throws Exception {
        StreamSubscriptionSetting[] settings = new StreamSubscriptionSetting[] {
                new StreamSubscriptionSetting(1, UpdateStreamSubscriptionSettingsApiRequest.COLOR, "#000000"),
                new StreamSubscriptionSetting(1, UpdateStreamSubscriptionSettingsApiRequest.AUDIBLE_NOTIFICATIONS, true),
                new StreamSubscriptionSetting(1, UpdateStreamSubscriptionSettingsApiRequest.DESKTOP_NOTIFICATIONS, true),
                new StreamSubscriptionSetting(1, UpdateStreamSubscriptionSettingsApiRequest.EMAIL_NOTIFICATIONS, true),
                new StreamSubscriptionSetting(1, UpdateStreamSubscriptionSettingsApiRequest.IS_MUTED, true),
                new StreamSubscriptionSetting(1, UpdateStreamSubscriptionSettingsApiRequest.PIN_TO_TOP, true),
                new StreamSubscriptionSetting(1, UpdateStreamSubscriptionSettingsApiRequest.PUSH_NOTIFICATIONS, true),
                new StreamSubscriptionSetting(1, UpdateStreamSubscriptionSettingsApiRequest.WILDCARD_MENTIONS_NOTIFY, true)
        };

        // Test subscription settings equality
        assertNotEquals(settings[0], settings[1]);
        assertEquals(settings[0], settings[0]);
        assertNotEquals(null, settings[0]);
        assertNotEquals("some wrong value", settings[0]);

        String subscriptionData = JsonUtils.getMapper().writeValueAsString(settings);

        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateStreamSubscriptionSettingsApiRequest.SUBSCRIPTION_DATA,
                        subscriptionData)
                .get();

        stubZulipResponse(POST, "/users/me/subscriptions/properties", params, "subscriptionSettings.json");

        List<String> result = zulip.channels().updateSubscriptionSettings()
                .withColor(1, "#000000")
                .withAudibleNotifications(1, true)
                .withDesktopNotifications(1, true)
                .withEmailNotifications(1, true)
                .withIsMuted(1, true)
                .withPinToTop(1, true)
                .withPushNotifications(1, false)
                // Test that setting overrides work
                .withPushNotifications(1, true)
                .withWildcardMentionsNotify(1, true)
                .execute();

        assertEquals(2, result.size());
        assertEquals("invalid_parameter_1", result.get(0));
        assertEquals("invalid_parameter_2", result.get(1));
    }

    @Test
    public void updateUserTopicPreferences() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateUserTopicPreferencesApiRequest.STREAM_ID, "1")
                .add(UpdateUserTopicPreferencesApiRequest.TOPIC, "Test Topic")
                .add(UpdateUserTopicPreferencesApiRequest.VISIBILITY_POLICY,
                        String.valueOf(TopicVisibilityPolicy.MUTED.getId()))
                .get();

        stubZulipResponse(POST, "/user_topics", params);

        zulip.channels().updateUserTopicPreferences(1, "Test Topic", TopicVisibilityPolicy.MUTED).execute();
    }

    @Test
    public void deleteTopicPartiallyCompleted() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(DeleteTopicApiRequest.TOPIC_NAME, "Test Topic")
                .get();

        String scenarioName = "deleteTopicPartiallyCompleted";
        stubZulipResponse(POST, "/streams/1/delete_topic", params, "deleteTopicPartiallyCompleted.json", scenarioName, STARTED,
                "retry");
        stubZulipResponse(POST, "/streams/1/delete_topic", params, "deleteTopicIncomplete.json", scenarioName, "retry",
                "incomplete");
        stubZulipResponse(POST, "/streams/1/delete_topic", params, "deleteTopicComplete.json", scenarioName, "incomplete",
                "success");

        zulip.channels().deleteTopic(1, "Test Topic").execute();
    }

    @Test
    public void deleteTopic() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(DeleteTopicApiRequest.TOPIC_NAME, "Test Topic")
                .get();

        String scenarioName = "deleteTopic";
        stubZulipResponse(POST, "/streams/1/delete_topic", params, "deleteTopicIncomplete.json", scenarioName, STARTED,
                "retry");
        stubZulipResponse(POST, "/streams/1/delete_topic", params, "deleteTopicComplete.json", scenarioName, "retry",
                "success");

        zulip.channels().deleteTopic(1, "Test Topic").execute();
    }

    @Test
    public void archiveStream() throws Exception {
        stubZulipResponse(DELETE, "/streams/1", Collections.emptyMap());

        zulip.channels().archiveStream(1).execute();
    }

    @Test
    public void addDefaultStream() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddDefaultStreamApiRequest.STREAM_ID, "1")
                .get();

        stubZulipResponse(POST, "/default_streams", params);

        zulip.channels().addDefaultStream(1).execute();
    }

    @Test
    public void removeDefaultStream() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddDefaultStreamApiRequest.STREAM_ID, "1")
                .get();

        stubZulipResponse(DELETE, "/default_streams", params);

        zulip.channels().removeDefaultStream(1).execute();
    }

    @Test
    public void streamSubscribers() throws Exception {
        stubZulipResponse(GET, "/streams/1/members", Collections.emptyMap(), "streamSubscribers.json");

        List<Long> streamSubscribers = zulip.channels().getStreamSubscribers(1).execute();
        assertEquals(2, streamSubscribers.size());
        assertEquals(5, streamSubscribers.get(0));
        assertEquals(6, streamSubscribers.get(1));
    }

    @Test
    public void getStreamEmailAddress() throws Exception {
        stubZulipResponse(GET, "/streams/1/email_address", Collections.emptyMap(), "streamEmailAddress.json");

        String email = zulip.channels().getStreamEmailAddress(1)
                .withSenderId(1)
                .execute();
        assertEquals("test@test.com", email);
    }

    @Test
    public void createChannel() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateChannelApiRequest.NAME, "Test Channel")
                .add(CreateChannelApiRequest.SUBSCRIBERS, "[1,2,3]")
                .add(CreateChannelApiRequest.DESCRIPTION, "Test Channel Description")
                .add(CreateChannelApiRequest.ANNOUNCE, "true")
                .add(CreateChannelApiRequest.INVITE_ONLY, "true")
                .add(CreateChannelApiRequest.IS_WEB_PUBLIC, "true")
                .add(CreateChannelApiRequest.IS_DEFAULT_STREAM, "true")
                .add(CreateChannelApiRequest.FOLDER_ID, "1")
                .add(CreateChannelApiRequest.SEND_NEW_SUBSCRIPTION_MESSAGES, "true")
                .add(CreateChannelApiRequest.TOPICS_POLICY, "\"allow_empty_topic\"")
                .add(CreateChannelApiRequest.HISTORY_PUBLIC_TO_SUBSCRIBERS, "true")
                .add(CreateChannelApiRequest.MESSAGE_RETENTION_DAYS, "30")
                .add(CreateChannelApiRequest.CAN_ADD_SUBSCRIBERS_GROUP, "1")
                .add(CreateChannelApiRequest.CAN_DELETE_ANY_MESSAGE_GROUP, "2")
                .add(CreateChannelApiRequest.CAN_DELETE_OWN_MESSAGE_GROUP, "3")
                .add(CreateChannelApiRequest.CAN_REMOVE_SUBSCRIBERS_GROUP, "4")
                .add(CreateChannelApiRequest.CAN_ADMINISTER_CHANNEL_GROUP, "5")
                .add(CreateChannelApiRequest.CAN_MOVE_MESSAGES_OUT_OF_CHANNEL_GROUP, "6")
                .add(CreateChannelApiRequest.CAN_MOVE_MESSAGES_WITHIN_CHANNEL_GROUP, "7")
                .add(CreateChannelApiRequest.CAN_SEND_MESSAGE_GROUP, "8")
                .add(CreateChannelApiRequest.CAN_SUBSCRIBE_GROUP, "9")
                .add(CreateChannelApiRequest.CAN_RESOLVE_TOPICS_GROUP, "10")
                .get();

        stubZulipResponse(POST, "/channels/create", params, "createChannel.json");

        long channelId = zulip.channels().createChannel("Test Channel", 1L, 2L, 3L)
                .withDescription("Test Channel Description")
                .withAnnounce(true)
                .withInviteOnly(true)
                .withIsWebPublic(true)
                .withIsDefaultStream(true)
                .withFolderId(1)
                .withSendNewSubscriptionMessages(true)
                .withTopicPolicy(TopicPolicy.ALLOW_EMPTY_TOPIC)
                .withHistoryPublicToSubscribers(true)
                .withMessageRetentionDays(30)
                .withCanAddSubscribersGroup(UserGroupSetting.of(1))
                .withCanDeleteAnyMessageGroup(UserGroupSetting.of(2))
                .withCanDeleteOwnMessageGroup(UserGroupSetting.of(3))
                .withCanRemoveSubscribersGroup(UserGroupSetting.of(4))
                .withCanAdministerChannelGroup(UserGroupSetting.of(5))
                .withCanMoveMessagesOutOfChannelGroup(UserGroupSetting.of(6))
                .withCanMoveMessagesWithinChannelGroup(UserGroupSetting.of(7))
                .withCanSendMessageGroup(UserGroupSetting.of(8))
                .withCanSubscribeGroup(UserGroupSetting.of(9))
                .withCanResolveTopicsGroup(UserGroupSetting.of(10))
                .execute();

        assertEquals(123, channelId);
    }

    @Test
    public void createChannelFolder() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateChannelFolderApiRequest.NAME, "Test Channel Folder")
                .add(CreateChannelFolderApiRequest.DESCRIPTION, "Test Channel Folder Description")
                .get();

        stubZulipResponse(POST, "/channel_folders/create", params, "createChannelFolder.json");

        Integer channelFolderID = zulip.channels().createChannelFolder("Test Channel Folder")
                .withDescription("Test Channel Folder Description")
                .execute();

        assertEquals(123, channelFolderID);
    }

    @Test
    public void getChannelFolders() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetChannelFoldersApiRequest.INCLUDE_ARCHIVED, "true")
                .get();

        stubZulipResponse(GET, "/channel_folders", params, "getChannelFolders.json");

        List<ChannelFolder> channelFolders = zulip.channels().getChannelFolders()
                .withIncludeArchived(true)
                .execute();

        assertEquals(2, channelFolders.size());

        for (int i = 1; i <= channelFolders.size(); i++) {
            ChannelFolder channelFolder = channelFolders.get(i - 1);
            assertEquals(i, channelFolder.getId());
            assertEquals(i, channelFolder.getCreatorId());
            assertEquals("Channel folder " + i, channelFolder.getName());
            assertEquals("Channel folder description " + i, channelFolder.getDescription());
            assertEquals("<p>Channel folder " + i + "</p>", channelFolder.getRenderedDescription());
            assertTrue(channelFolder.getDateCreated().toEpochMilli() > 0);
            assertEquals(i, channelFolder.getOrder());

            if (i == 1) {
                assertFalse(channelFolder.isArchived());
            } else {
                assertTrue(channelFolder.isArchived());
            }
        }

    }

    @Test
    public void reorderChannelFolders() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(ReorderChannelFoldersApiRequest.ORDER, "[1,2,3]")
                .get();

        stubZulipResponse(PATCH, "/channel_folders", params, "getChannelFolders.json");

        zulip.channels().reorderChannelFolders(1, 2, 3).execute();
    }

    @Test
    public void updateChannelFolders() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateChannelFolderApiRequest.NAME, "Test Channel Folder")
                .add(UpdateChannelFolderApiRequest.DESCRIPTION, "Test Channel Folder Description")
                .add(UpdateChannelFolderApiRequest.IS_ARCHIVED, "true")
                .get();

        stubZulipResponse(PATCH, "/channel_folders/1", params);

        zulip.channels().updateChannelFolder(1)
                .withName("Test Channel Folder")
                .withDescription("Test Channel Folder Description")
                .withIsArchived(true)
                .execute();
    }
}
