package com.github.jamesnetherton.zulip.client.api.integration.invitation;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.invitation.Invitation;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserGroup;
import com.github.jamesnetherton.zulip.client.api.user.UserRole;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;

public class ZulipInvitationIT extends ZulipIntegrationTestBase {

    @Test
    public void reusableInvitationCrudOperations() throws Exception {
        String channelName = UUID.randomUUID().toString();

        zulip.streams()
                .subscribe(StreamSubscriptionRequest.of(channelName, channelName))
                .execute();

        Long streamId = zulip.streams().getStreamId(channelName).execute();

        String groupName = UUID.randomUUID().toString();
        zulip.users().createUserGroup(groupName, groupName).execute();
        List<UserGroup> groups = zulip.users().getUserGroups().execute();
        assertFalse(groups.isEmpty());

        String invitationLink = zulip.invitations().createReusableInvitationLink()
                .withGroupIds(groups.get(groups.size() - 1).getId())
                .withIncludeRealmDefaultSubscriptions(true)
                .withInviteAs(UserRole.MEMBER)
                .inviteExpiresInMinutes(60)
                .streamIds(streamId)
                .execute();

        assertTrue(invitationLink.matches("https://localhost/join/.*/"));

        List<Invitation> invitations = zulip.invitations().getAllInvitations().execute();
        assertEquals(1, invitations.size());

        Invitation invitation = invitations.get(0);
        assertTrue(invitation.getId() > 0);
        assertEquals(ownUser.getUserId(), invitation.getInvitedByUserId());
        assertEquals(UserRole.MEMBER, invitation.getInvitedAs());
        assertTrue(invitation.getInvited().getEpochSecond() > 0);
        assertTrue(invitation.getExpiryDate().getEpochSecond() > 0);
        assertNull(invitation.getEmail());
        assertTrue(invitation.getLinkUrl().matches("https://localhost/join/.*/"));
        assertFalse(invitation.isNotifyReferrerOnJoin());
        assertTrue(invitation.isMultiuse());

        zulip.invitations().revokeReusableInvitation(invitation.getId()).execute();

        invitations = zulip.invitations().getAllInvitations().execute();
        assertTrue(invitations.isEmpty());
    }

    @Test
    public void emailInvitationCrudOperations() throws Exception {
        String channelName = UUID.randomUUID().toString();
        zulip.streams()
                .subscribe(StreamSubscriptionRequest.of(channelName, channelName))
                .execute();

        Long streamId = zulip.streams().getStreamId(channelName).execute();

        String groupName = UUID.randomUUID().toString();
        zulip.users().createUserGroup(groupName, groupName).execute();
        List<UserGroup> groups = zulip.users().getUserGroups().execute();
        assertFalse(groups.isEmpty());

        zulip.invitations().sendInvitations(List.of("foo@bar.com, cheese@wine.com"), List.of(streamId))
                .withGroupIds(groups.get(groups.size() - 1).getId())
                .withInviteAs(UserRole.MEMBER)
                .inviteExpiresInMinutes(60)
                .withNotifyReferrerOnJoin(true)
                .withIncludeRealmDefaultSubscriptions(true)
                .execute();

        List<Invitation> invitations = zulip.invitations().getAllInvitations().execute();
        assertEquals(2, invitations.size());

        Invitation invitation = invitations.stream().filter(invite -> invite.getEmail().equals("foo@bar.com")).findFirst()
                .get();
        assertTrue(invitation.getId() > 0);
        assertEquals(ownUser.getUserId(), invitation.getInvitedByUserId());
        assertEquals(UserRole.MEMBER, invitation.getInvitedAs());
        assertTrue(invitation.getInvited().getEpochSecond() > 0);
        assertTrue(invitation.getExpiryDate().getEpochSecond() > 0);
        assertEquals("foo@bar.com", invitation.getEmail());
        assertNull(invitation.getLinkUrl());
        assertTrue(invitation.isNotifyReferrerOnJoin());
        assertFalse(invitation.isMultiuse());

        invitation = invitations.stream().filter(invite -> invite.getEmail().equals("cheese@wine.com")).findFirst().get();
        assertTrue(invitation.getId() > 0);
        assertEquals(ownUser.getUserId(), invitation.getInvitedByUserId());
        assertEquals(UserRole.MEMBER, invitation.getInvitedAs());
        assertTrue(invitation.getInvited().getEpochSecond() > 0);
        assertTrue(invitation.getExpiryDate().getEpochSecond() > 0);
        assertEquals("cheese@wine.com", invitation.getEmail());
        assertNull(invitation.getLinkUrl());
        assertTrue(invitation.isNotifyReferrerOnJoin());
        assertFalse(invitation.isMultiuse());

        zulip.invitations().resendEmailInvitation(invitation.getId()).execute();

        invitations.forEach(invite -> {
            try {
                zulip.invitations().revokeEmailInvitation(invite.getId()).execute();
            } catch (ZulipClientException e) {
                throw new RuntimeException(e);
            }
        });

        invitations = zulip.invitations().getAllInvitations().execute();
        assertTrue(invitations.isEmpty());
    }
}
