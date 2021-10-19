package com.github.jamesnetherton.zulip.client.api.integration.draft;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.draft.Draft;
import com.github.jamesnetherton.zulip.client.api.draft.DraftType;
import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.stream.RetentionPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;
import com.github.jamesnetherton.zulip.client.api.stream.StreamPostPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionResult;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipDraftIT extends ZulipIntegrationTestBase {

    @Test
    public void draftCrudOperations() throws Exception {
        // Create stream
        StreamSubscriptionResult result = zulip.streams().subscribe(
                StreamSubscriptionRequest.of("Test Stream For Draft", "Test Stream For Draft"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withMessageRetention(RetentionPolicy.FOREVER)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Map<String, List<String>> created = result.getSubscribed();
        assertEquals(1, created.get("test@test.com").size());

        List<Stream> streams = zulip.streams().getAll()
                .withIncludeDefault(true)
                .execute();

        Stream stream = streams.stream()
                .filter(s -> s.getName().equals("Test Stream For Draft"))
                .findFirst()
                .get();

        // Create drafts
        List<Draft> drafts = new ArrayList<>();
        for (int i = 1; i <= 3; i++) {
            Draft draft = new Draft();
            draft.setTimestamp(Instant.now());
            draft.setContent("Draft Content " + i);
            draft.setTopic("Test Draft Topic " + i);

            if (i < 3) {
                draft.setType(DraftType.STREAM);
                draft.setTo(Arrays.asList(stream.getStreamId()));
            } else {
                draft.setType(DraftType.PRIVATE);
                draft.setTo(Arrays.asList(ownUser.getUserId()));
            }
            drafts.add(draft);
        }

        List<Long> createdIds = zulip.drafts().createDrafts(drafts).execute();
        assertEquals(3, createdIds.size());

        // Read drafts
        List<Draft> createdDrafts = zulip.drafts().getDrafts().execute();
        assertEquals(3, createdDrafts.size());
        for (int i = 1; i <= createdDrafts.size(); i++) {
            Draft draft = createdDrafts.get(i - 1);
            assertTrue(draft.getTimestamp().toEpochMilli() > 0);
            assertEquals("Draft Content " + i, draft.getContent());

            if (i < 3) {
                assertEquals(DraftType.STREAM, draft.getType());
                assertEquals("Test Draft Topic " + i, draft.getTopic());
                assertTrue(draft.getTo().contains(stream.getStreamId()));
            } else {
                assertEquals(DraftType.PRIVATE, draft.getType());
                assertTrue(draft.getTo().contains(ownUser.getUserId()));
            }
        }

        // Update drafts
        for (int i = 1; i <= createdDrafts.size(); i++) {
            Draft draft = createdDrafts.get(i - 1);
            draft.setContent("Updated Draft " + i);
            draft.setTopic("Updated Topic " + i);

            if (i < 3) {
                draft.setType(DraftType.PRIVATE);
                draft.setTo(Arrays.asList(ownUser.getUserId()));
                draft.setTopic("");
            } else {
                draft.setType(DraftType.STREAM);
                draft.setTo(Arrays.asList(stream.getStreamId()));
            }

            zulip.drafts().editDraft(draft).execute();
        }

        // Verify updates
        List<Draft> updatedDrafts = zulip.drafts().getDrafts().execute();
        assertEquals(3, updatedDrafts.size());
        for (int i = 1; i <= updatedDrafts.size(); i++) {
            Draft draft = updatedDrafts.get(i - 1);
            assertTrue(draft.getTimestamp().toEpochMilli() > 0);
            assertEquals("Updated Draft " + i, draft.getContent());

            if (i < 3) {
                assertEquals(DraftType.PRIVATE, draft.getType());
                assertTrue(draft.getTo().contains(ownUser.getUserId()));
            } else {
                assertEquals(DraftType.STREAM, draft.getType());
                assertEquals("Updated Topic " + i, draft.getTopic());
                assertTrue(draft.getTo().contains(stream.getStreamId()));
            }
        }

        // Delete drafts
        for (Draft draft : updatedDrafts) {
            zulip.drafts().deleteDraft(draft.getId()).execute();
        }

        // Verify deletion
        drafts = zulip.drafts().getDrafts().execute();
        assertEquals(0, drafts.size());
    }
}
