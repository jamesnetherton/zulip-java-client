package com.github.jamesnetherton.zulip.client.api.invitation;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.invitation.request.CreateReusableInvitationLinkApiRequest;
import com.github.jamesnetherton.zulip.client.api.invitation.request.SendInvitationsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserRole;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipInvitationApiTest extends ZulipApiTestBase {
    @Test
    public void createReusableInvitationLink() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateReusableInvitationLinkApiRequest.GROUP_IDS, "[1,2,3]")
                .add(CreateReusableInvitationLinkApiRequest.INCLUDE_REALM_DEFAULT_SUBSCRIPTIONS, "true")
                .add(CreateReusableInvitationLinkApiRequest.INVITE_AS, String.valueOf(UserRole.ORGANIZATION_ADMIN.getId()))
                .add(CreateReusableInvitationLinkApiRequest.INVITE_EXPIRES_IN_MINUTES, "60")
                .add(CreateReusableInvitationLinkApiRequest.STREAM_IDS, "[1,2,3]")
                .add(CreateReusableInvitationLinkApiRequest.WELCOME_MESSAGE_CUSTOM_TEXT, "Test welcome message")
                .get();

        stubZulipResponse(POST, "/invites/multiuse", params, "createInvitationLink.json");

        String invitationLink = zulip.invitations().createReusableInvitationLink()
                .withGroupIds(1, 2, 3)
                .withIncludeRealmDefaultSubscriptions(true)
                .withInviteAs(UserRole.ORGANIZATION_ADMIN)
                .inviteExpiresInMinutes(60)
                .streamIds(1, 2, 3)
                .withWelcomeMessageCustomText("Test welcome message")
                .execute();

        assertEquals("https://example.zulipchat.com/join/yddhtzk4jgl7rsmazc5fyyyy/", invitationLink);

        assertThrows(IllegalArgumentException.class, () -> {
            zulip.invitations().createReusableInvitationLink()
                    .withWelcomeMessageCustomText("A".repeat(8001))
                    .execute();
        });
    }

    @Test
    public void getAllInvitations() throws Exception {
        stubZulipResponse(GET, "/invites", "getAllInvitations.json");

        List<Invitation> invitations = zulip.invitations().getAllInvitations().execute();
        for (int i = 0; i < invitations.size(); i++) {
            Invitation invitation = invitations.get(i);

            UserRole role = i == 0 ? UserRole.ORGANIZATION_OWNER : UserRole.ORGANIZATION_ADMIN;
            assertEquals(i + 1, invitation.getId());
            assertEquals(i + 1, invitation.getInvitedByUserId());
            assertEquals(role, invitation.getInvitedAs());
            assertEquals(1710606654, invitation.getInvited().getEpochSecond());
            assertEquals(1710606654, invitation.getExpiryDate().getEpochSecond());
            assertEquals("example@zulip.com", invitation.getEmail());
            assertEquals("https://example.zulipchat.com/join/" + (i + 1) + "/", invitation.getLinkUrl());
            assertTrue(invitation.isNotifyReferrerOnJoin());
            assertTrue(invitation.isMultiuse());
        }
    }

    @Test
    public void resendEmailInvitation() throws Exception {
        stubZulipResponse(POST, "/invites/1/resend", SUCCESS_JSON);

        zulip.invitations().resendEmailInvitation(1).execute();
    }

    @Test
    public void revokeEmailInvitation() throws Exception {
        stubZulipResponse(DELETE, "/invites/1", SUCCESS_JSON);

        zulip.invitations().revokeEmailInvitation(1).execute();
    }

    @Test
    public void revokeReusableInvitation() throws Exception {
        stubZulipResponse(DELETE, "/invites/multiuse/1", SUCCESS_JSON);

        zulip.invitations().revokeReusableInvitation(1).execute();
    }

    @Test
    public void sendInvitations() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SendInvitationsApiRequest.GROUP_IDS, "[1,2,3]")
                .add(SendInvitationsApiRequest.INVITEE_EMAILS, "foo@bar.com, cheese@wine.com")
                .add(SendInvitationsApiRequest.INCLUDE_REALM_DEFAULT_SUBSCRIPTIONS, "true")
                .add(SendInvitationsApiRequest.INVITE_AS, String.valueOf(UserRole.MEMBER.getId()))
                .add(SendInvitationsApiRequest.INVITE_EXPIRES_IN_MINUTES, "60")
                .add(SendInvitationsApiRequest.NOTIFIY_REFERRER_ON_JOIN, "true")
                .add(SendInvitationsApiRequest.STREAM_IDS, "[1,2,3]")
                .add(SendInvitationsApiRequest.WELCOME_MESSAGE_CUSTOM_TEXT, "Test welcome message")
                .get();

        stubZulipResponse(POST, "/invites", params, SUCCESS_JSON);

        zulip.invitations().sendInvitations(List.of("foo@bar.com, cheese@wine.com"), List.of(1L, 2L, 3L))
                .withGroupIds(1L, 2L, 3L)
                .withInviteAs(UserRole.MEMBER)
                .inviteExpiresInMinutes(60)
                .withNotifyReferrerOnJoin(true)
                .withIncludeRealmDefaultSubscriptions(true)
                .withWelcomeMessageCustomText("Test welcome message")
                .execute();

        assertThrows(IllegalArgumentException.class, () -> {
            zulip.invitations().sendInvitations(List.of("foo@bar.com, cheese@wine.com"), List.of(1L, 2L, 3L))
                    .withWelcomeMessageCustomText("A".repeat(8001))
                    .execute();
        });
    }
}
