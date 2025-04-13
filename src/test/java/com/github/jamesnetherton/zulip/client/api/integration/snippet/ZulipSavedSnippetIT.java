package com.github.jamesnetherton.zulip.client.api.integration.snippet;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.snippet.SavedSnippet;
import java.util.List;
import org.junit.jupiter.api.Test;

public class ZulipSavedSnippetIT extends ZulipIntegrationTestBase {
    @Test
    public void savedSnippetCrud() throws Exception {
        Integer id = zulip.snippets().createSavedSnippet("Test title", "Test content").execute();
        assertTrue(id > 0);

        List<SavedSnippet> savedSnippets = zulip.snippets().getSavedSnippets().execute();
        assertEquals(1, savedSnippets.size());
        assertEquals(id, savedSnippets.get(0).getId());
        assertEquals("Test title", savedSnippets.get(0).getTitle());
        assertEquals("Test content", savedSnippets.get(0).getContent());
        assertTrue(savedSnippets.get(0).getDateCreated().toEpochMilli() > 0);

        zulip.snippets().editSavedSnippet(id)
                .withTitle("Edited title")
                .withContent("Edited content")
                .execute();

        savedSnippets = zulip.snippets().getSavedSnippets().execute();
        assertEquals("Edited title", savedSnippets.get(0).getTitle());
        assertEquals("Edited content", savedSnippets.get(0).getContent());
        assertTrue(savedSnippets.get(0).getDateCreated().toEpochMilli() > 0);

        for (SavedSnippet savedSnippet : savedSnippets) {
            zulip.snippets().deleteSavedSnippet(savedSnippet.getId()).execute();
        }

        savedSnippets = zulip.snippets().getSavedSnippets().execute();
        assertTrue(savedSnippets.isEmpty());
    }
}
