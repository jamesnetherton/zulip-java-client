package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum MessageReportReason {
    HARASSMENT,
    INAPPROPRIATE,
    NORMS,
    OTHER,
    SPAM;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }

    @JsonCreator
    public static MessageReportReason fromString(String reason) {
        return MessageReportReason.valueOf(reason.toUpperCase());
    }
}
