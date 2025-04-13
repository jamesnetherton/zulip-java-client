package com.github.jamesnetherton.zulip.client.api.snippet;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.PATCH;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.snippet.request.CreateSavedSnippetApiRequest;
import com.github.jamesnetherton.zulip.client.api.snippet.request.EditSavedSnippetApiRequest;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipSavedSnippetApiTest extends ZulipApiTestBase {
    @Test
    public void createSavedSnippet() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateSavedSnippetApiRequest.TITLE, "Test title")
                .add(CreateSavedSnippetApiRequest.CONTENT, "Test content")
                .get();

        stubZulipResponse(POST, "/saved_snippets", params, "createSavedSnippet.json");

        int id = zulip.snippets().createSavedSnippet("Test title", "Test content").execute();

        assertEquals(1, id);
    }

    @Test
    public void deleteSavedSnippet() throws Exception {
        stubZulipResponse(DELETE, "/saved_snippets/1", Collections.emptyMap());

        zulip.snippets().deleteSavedSnippet(1).execute();
    }

    @Test
    public void editSavedSnippet() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(EditSavedSnippetApiRequest.CONTENT, "Edited content")
                .add(EditSavedSnippetApiRequest.TITLE, "Edited title")
                .get();

        stubZulipResponse(PATCH, "/saved_snippets/1", params);

        zulip.snippets().editSavedSnippet(1)
                .withContent("Edited content")
                .withTitle("Edited title")
                .execute();
    }

    @Test
    public void getSavedSnippets() throws Exception {
        stubZulipResponse(GET, "/saved_snippets", Collections.emptyMap(), "getSavedSnippets.json");

        List<SavedSnippet> execute = zulip.snippets().getSavedSnippets().execute();
        assertEquals(3, execute.size());
        for (int i = 0; i < execute.size(); i++) {
            int index = i + 1;
            SavedSnippet savedSnippet = execute.get(i);
            assertEquals(index, savedSnippet.getId());
            assertEquals("Title " + index, savedSnippet.getTitle());
            assertEquals("Content " + index, savedSnippet.getContent());
            assertTrue(savedSnippet.getDateCreated().toEpochMilli() > 0);
        }
    }
}
