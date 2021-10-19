package com.github.jamesnetherton.zulip.client.api.draft;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.PATCH;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static com.github.jamesnetherton.zulip.client.api.draft.request.CreateDraftsApiRequest.DRAFTS;
import static com.github.jamesnetherton.zulip.client.api.draft.request.EditDraftApiRequest.DRAFT;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.junit.jupiter.api.Test;

public class ZulipDraftApiTest extends ZulipApiTestBase {

    @Test
    public void createDrafts() throws Exception {
        List<Draft> drafts = Stream.of(1, 2, 3)
                .map(id -> {
                    Draft draft = new Draft();
                    draft.setTimestamp(Instant.now());
                    draft.setContent("Draft " + id);

                    if (id % 2 == 0) {
                        draft.setTopic("Topic " + 1);
                        draft.setType(DraftType.STREAM);
                    } else {
                        ArrayList<Long> to = new ArrayList<>();
                        to.add(1L);
                        to.add(2L);
                        draft.setTo(to);
                        draft.setType(DraftType.PRIVATE);
                    }

                    return draft;
                })
                .collect(Collectors.toList());

        Map<String, StringValuePattern> params = QueryParams.create()
                .addAsJsonString(DRAFTS, drafts)
                .get();

        stubZulipResponse(POST, "/drafts", params, "createDrafts.json");

        List<Long> draftIds = zulip.drafts().createDrafts(drafts).execute();
        assertEquals(3, draftIds.size());
    }

    @Test
    public void deleteDraft() throws Exception {
        stubZulipResponse(DELETE, "/drafts/1", Collections.emptyMap());
        zulip.drafts().deleteDraft(1).execute();
    }

    @Test
    public void editDraft() throws Exception {
        Draft draft = new Draft();
        draft.setContent("Edited Draft");
        draft.setTopic("Edited Topic");
        draft.setTimestamp(Instant.now());
        draft.setType(DraftType.PRIVATE);

        ArrayList<Long> to = new ArrayList<>();
        to.add(3L);
        to.add(4L);
        draft.setTo(to);

        draft.setId(0);
        Map<String, StringValuePattern> params = QueryParams.create()
                .addAsJsonString(DRAFT, draft)
                .get();
        draft.setId(1);

        stubZulipResponse(PATCH, "/drafts/1", params);

        zulip.drafts().editDraft(draft).execute();
    }

    @Test
    public void getDrafts() throws Exception {
        stubZulipResponse(GET, "/drafts", Collections.emptyMap(), "getDrafts.json");

        List<Draft> drafts = zulip.drafts().getDrafts().execute();
        assertEquals(3, drafts.size());

        Draft draft = drafts.get(0);
        assertEquals("Draft 1", draft.getContent());
        assertEquals(1, draft.getId());
        assertEquals("Topic 1", draft.getTopic());
        assertEquals(DraftType.STREAM, draft.getType());
        assertTrue(draft.getTo().contains(1L));
        assertTrue(draft.getTimestamp().toEpochMilli() > 0);

        draft = drafts.get(1);
        assertEquals("Draft 2", draft.getContent());
        assertEquals(2, draft.getId());
        assertEquals("Topic 2", draft.getTopic());
        assertEquals(DraftType.PRIVATE, draft.getType());
        assertTrue(draft.getTo().contains(2L));
        assertTrue(draft.getTimestamp().toEpochMilli() > 0);

        draft = drafts.get(2);
        assertEquals("Draft 3", draft.getContent());
        assertEquals(3, draft.getId());
        assertEquals("", draft.getTopic());
        assertEquals(DraftType.PRIVATE, draft.getType());
        assertTrue(draft.getTo().contains(3L));
        assertTrue(draft.getTimestamp().toEpochMilli() > 0);
    }
}
