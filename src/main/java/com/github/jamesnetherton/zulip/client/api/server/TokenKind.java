package com.github.jamesnetherton.zulip.client.api.server;

/**
 * Token kind for registering an E2E mobile push device
 */
public enum TokenKind {
    APNS,
    FCM;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}
