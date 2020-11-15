package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * Defines a Zulip user group.
 */
public class UserGroup {

    @JsonProperty
    private long id;

    @JsonProperty
    private String description;

    @JsonProperty
    private String name;

    @JsonProperty
    private List<Long> members;

    public long getId() {
        return id;
    }

    public String getDescription() {
        return description;
    }

    public String getName() {
        return name;
    }

    public List<Long> getMembers() {
        return members;
    }
}
