package com.github.jamesnetherton.zulip.client.api.integration.server;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.server.AuthenticationSettings;
import com.github.jamesnetherton.zulip.client.api.server.CustomEmoji;
import com.github.jamesnetherton.zulip.client.api.server.Linkifier;
import com.github.jamesnetherton.zulip.client.api.server.ProfileField;
import com.github.jamesnetherton.zulip.client.api.server.ProfileFieldType;
import com.github.jamesnetherton.zulip.client.api.server.ServerSettings;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Test;

public class ZulipServerIT extends ZulipIntegrationTestBase {

    @Test
    public void linkifierCrud() throws ZulipClientException {
        // Create linikifier
        Long id = zulip.server().addLinkifier("#(?P<id>[0-9]+)", "https://github.com/zulip/zulip/issues/%(id)s").execute();
        assertTrue(id > 0);

        try {
            // Get linkifiers
            List<Linkifier> linkifiers = zulip.server().getLinkifiers().execute();
            assertEquals(1, linkifiers.size());

            Linkifier linkifier = linkifiers.get(0);
            assertEquals(id, linkifier.getId());
            assertEquals("#(?P<id>[0-9]+)", linkifier.getPattern());
            assertEquals("https://github.com/zulip/zulip/issues/%(id)s", linkifier.getUrlFormatString());

            // Delete linkifiers
            zulip.server().deleteLinkifier(id).execute();
        } catch (Throwable t) {
            try {
                zulip.server().deleteLinkifier(id).execute();
            } catch (Throwable t2) {
                // Ignore
            }
            throw t;
        }

        List<Linkifier> linkifiers = zulip.server().getLinkifiers().execute();
        assertTrue(linkifiers.isEmpty());
    }

    @Test
    public void emoji() throws ZulipClientException {
        File file = new File("./src/test/resources/com/github/jamesnetherton/zulip/client/api/server/emoji/smile.png");

        String emojiName = UUID.randomUUID().toString().split("-")[0];
        zulip.server().uploadEmoji(emojiName, file).execute();

        List<CustomEmoji> emojis = zulip.server().getEmoji().execute();
        Optional<CustomEmoji> optional = emojis.stream()
                .filter(e -> e.getName().equals(emojiName))
                .findFirst();

        assertTrue(optional.isPresent());

        CustomEmoji emoji = optional.get();
        assertEquals(emojiName, emoji.getName());
        assertTrue(emoji.getSourceUrl().endsWith(emoji.getId() + ".png"));
        assertTrue(emoji.getAuthorId() > 0);
        assertTrue(emoji.getId() > 0);
        assertFalse(emoji.isDeactivated());
    }

    @Test
    public void serverSettings() throws ZulipClientException {
        ServerSettings settings = zulip.server().getServerSettings().execute();

        assertTrue(settings.isEmailAuthEnabled());
        assertTrue(settings.isRequireEmailFormatUsernames());
        assertFalse(settings.isIncompatible());
        assertFalse(settings.isPushNotificationsEnabled());
        assertEquals("testing", settings.getRealmName());
        assertEquals("<p>The coolest place in the universe.</p>", settings.getRealmDescription());
        assertTrue(settings.getRealmIcon().startsWith("https://secure.gravatar.com"));

        AuthenticationSettings authenticationMethods = settings.getAuthenticationMethods();
        assertFalse(authenticationMethods.isAzuread());
        assertFalse(authenticationMethods.isDev());
        assertTrue(authenticationMethods.isEmail());
        assertFalse(authenticationMethods.isGithub());
        assertFalse(authenticationMethods.isGoogle());
        assertFalse(authenticationMethods.isLdap());
        assertTrue(authenticationMethods.isPassword());
        assertFalse(authenticationMethods.isRemoteuser());
        assertFalse(authenticationMethods.isSaml());

        assertTrue(settings.getExternalAuthenticationMethods().isEmpty());
    }

    @SuppressWarnings("unchecked")
    @Test
    public void customProfileFieldsCrud() throws ZulipClientException {
        long simpleId = zulip.server().createCustomProfileField()
                .withSimpleFieldType(ProfileFieldType.LONG_TEXT, "Test Long Name", "Test Long Hint")
                .execute();
        assertTrue(simpleId > 0);

        Map<String, Map<String, String>> listData = new LinkedHashMap<>();
        Map<String, String> child = new LinkedHashMap<>();
        child.put("text", "Vim");
        child.put("order", "1");
        listData.put("vim", child);

        long listId = zulip.server().createCustomProfileField()
                .withListOfOptionsFieldType("Test List Name", "Test List Hint", listData)
                .execute();
        assertTrue(listId > 0);

        Map<String, String> externalData = new LinkedHashMap<>();
        externalData.put("subtype", "github");

        long externalId = zulip.server().createCustomProfileField()
                .withExternalAccountFieldType(externalData)
                .execute();
        assertTrue(externalId > 0);

        List<ProfileField> profileFields = zulip.server().getCustomProfileFields().execute();
        assertEquals(3, profileFields.size());

        List<Integer> order = new ArrayList<>();

        for (ProfileField field : profileFields) {
            if (field.getId() == simpleId) {
                assertEquals("Test Long Hint", field.getHint());
                assertEquals("Test Long Name", field.getName());
                assertTrue(field.getOrder() > 0);
                assertEquals(ProfileFieldType.LONG_TEXT, field.getType());
                assertEquals("", field.getFieldData());
                order.add(field.getOrder());
            } else if (field.getId() == listId) {
                assertEquals("Test List Hint", field.getHint());
                assertEquals("Test List Name", field.getName());
                assertTrue(field.getOrder() > 0);
                assertEquals(ProfileFieldType.LIST_OF_OPTIONS, field.getType());

                Map<String, Map<String, String>> data = (Map<String, Map<String, String>>) field.getFieldData();
                assertEquals(1, data.size());

                Map<String, String> vim = data.get("vim");
                assertNotNull(vim);
                assertEquals(2, vim.size());
                assertEquals("Vim", vim.get("text"));
                assertEquals("1", vim.get("order"));
                order.add(field.getOrder());
            } else if (field.getId() == externalId) {
                assertEquals("Enter your GitHub username", field.getHint());
                assertEquals("GitHub", field.getName());
                assertTrue(field.getOrder() > 0);
                assertEquals(ProfileFieldType.EXTERNAL_ACCOUNT, field.getType());

                Map<String, String> data = (Map<String, String>) field.getFieldData();
                assertEquals(1, data.size());
                assertEquals("github", data.get("subtype"));
                order.add(field.getOrder());
            } else {
                fail("Unexpected profile entry found");
            }
        }

        Collections.reverse(order);
        zulip.server().reorderCustomProfileFields(order.get(0), order.get(1), order.get(2)).execute();

        zulip.server().deleteCustomProfileField(simpleId).execute();
        zulip.server().deleteCustomProfileField(listId).execute();
        zulip.server().deleteCustomProfileField(externalId).execute();
    }

    @Test
    public void getApiKey() throws Exception {
        try {
            String key = zulip.server().getDevelopmentApiKey("test@test.com").execute();
            assertFalse(key.isEmpty());
        } catch (ZulipClientException e) {
            // Ignore if dev not enabled
            if (!e.getMessage().equals("Dev environment not enabled.")) {
                throw e;
            }
        }
    }
}
