package com.github.jamesnetherton.zulip.client.api.invitation.request;

public class InvitationRequestConstants {
    final static String INVITATIONS_API_PATH = "invites";
    final static String INVITATIONS_WITH_ID = INVITATIONS_API_PATH + "/%d";
    final static String MULTIUSE_API_PATH = INVITATIONS_API_PATH + "/multiuse";
    final static String MULTIUSE_WITH_ID = MULTIUSE_API_PATH + "/%d";
    final static String RESEND = INVITATIONS_WITH_ID + "/resend";

    private InvitationRequestConstants() {
    }
}
