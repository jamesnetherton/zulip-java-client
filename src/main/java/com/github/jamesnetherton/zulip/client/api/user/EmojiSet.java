package com.github.jamesnetherton.zulip.client.api.user;

public enum EmojiSet {
    GOOGLE,
    GOOGLE_BLOB,
    TWITTER,
    TEXT;

    @Override
    public String toString() {
        String name = this.name().toLowerCase();
        if (this.equals(GOOGLE_BLOB)) {
            return name.replace('_', '-');
        }
        return name;
    }
}
