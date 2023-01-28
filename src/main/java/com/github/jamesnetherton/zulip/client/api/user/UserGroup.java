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

    @JsonProperty
    private List<Long> directSubgroupIds;

    @JsonProperty
    private boolean isSystemGroup;

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

    public List<Long> getDirectSubgroupIds() {
        return directSubgroupIds;
    }

    public boolean isSystemGroup() {
        return isSystemGroup;
    }
}
