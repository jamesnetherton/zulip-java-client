package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum WebAnimateImageOption {
    ALWAYS,
    NEVER,
    ON_HOVER;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }

    @JsonCreator
    public static WebAnimateImageOption fromString(String option) {
        return WebAnimateImageOption.valueOf(option.toUpperCase());
    }
}
