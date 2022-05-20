package com.github.jamesnetherton.zulip.client.api.user;

/**
 * Defines Zulip UI color schemes.
 */
public enum ColorScheme {
    AUTOMATIC(1),
    DARK(2),
    LIGHT(3);

    private final int id;

    private ColorScheme(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
