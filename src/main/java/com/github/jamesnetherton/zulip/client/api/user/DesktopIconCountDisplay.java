package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines desktop icon count display settings.
 */
public enum DesktopIconCountDisplay {
    /**
     * Display count of all unread messages.
     */
    ALL_UNREADS(1),
    /**
     * Display count of all unread private messages and mentions.
     */
    PRIVATE_MESSAGES_AND_MENTIONS(2),
    /**
     * Disable displaying a count.
     */
    NONE(3),
    /**
     * An unknown icon count display value. This usually indicates an error in the response from Zulip.
     */
    UNKNOWN(0);

    private final int setting;

    DesktopIconCountDisplay(int setting) {
        this.setting = setting;
    }

    public int getSetting() {
        return setting;
    }

    @JsonCreator
    public static DesktopIconCountDisplay fromInt(int setting) {
        for (DesktopIconCountDisplay desktopIconCountDisplay : DesktopIconCountDisplay.values()) {
            if (desktopIconCountDisplay.getSetting() == setting) {
                return desktopIconCountDisplay;
            }
        }
        return UNKNOWN;
    }
}
