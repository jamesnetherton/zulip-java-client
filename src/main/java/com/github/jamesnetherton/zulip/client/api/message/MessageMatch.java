package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines message matches based on a search via a {@link com.github.jamesnetherton.zulip.client.api.narrow.Narrow}.
 */
public class MessageMatch {

    @JsonProperty("match_content")
    String content;

    @JsonProperty("match_subject")
    String subject;

    public String getContent() {
        return content;
    }

    public String getSubject() {
        return subject;
    }
}
