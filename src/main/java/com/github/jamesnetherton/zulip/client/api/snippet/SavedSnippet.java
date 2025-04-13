package com.github.jamesnetherton.zulip.client.api.snippet;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

public class SavedSnippet {
    @JsonProperty
    private int id;

    @JsonProperty
    private String title;

    @JsonProperty
    private String content;

    @JsonProperty
    private Instant dateCreated;

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public Instant getDateCreated() {
        return dateCreated;
    }
}
