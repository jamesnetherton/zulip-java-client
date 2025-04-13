package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents a user group setting. Depending on the Zulip API response either the userGroupId will be populated or one / both
 * of directMembers or directSubGroups.
 *
 * @see <a href="https://zulip.com/api/group-setting-values">https://zulip.com/api/group-setting-values</a>
 */
@JsonSerialize(using = UserGroupSettingSerializer.class)
@JsonDeserialize(using = UserGroupSettingDeserializer.class)
public class UserGroupSetting {
    private long userGroupId;
    private final List<Long> directMembers = new ArrayList<>();
    private final List<Long> directSubGroups = new ArrayList<>();

    /**
     * Creates a UserGroupSetting with the given user group ID.
     *
     * @param  userGroupId The ID of the user group
     * @return             A @link UserGroupSetting} configured to use the given user group ID
     */
    public static UserGroupSetting of(long userGroupId) {
        return new UserGroupSetting(userGroupId);
    }

    /**
     * Creates a UserGroupSetting with the given user group direct members or direct subgroups.
     *
     * @param  directMembers   The list of direct member group ids. Can be an empty collection.
     * @param  directSubGroups The list of direct member group ids. Can be an empty collection.
     * @return                 A @link UserGroupSetting} configured to use the given user group direct members or direct
     *                         subgroups
     */
    public static UserGroupSetting of(List<Long> directMembers, List<Long> directSubGroups) {
        return new UserGroupSetting(directMembers, directSubGroups);
    }

    UserGroupSetting(long userGroupId) {
        this.userGroupId = userGroupId;
    }

    UserGroupSetting(List<Long> directMembers, List<Long> directSubGroups) {
        if (directMembers != null) {
            this.directMembers.addAll(directMembers);
        }

        if (directSubGroups != null) {
            this.directSubGroups.addAll(directSubGroups);
        }
    }

    public long getUserGroupId() {
        return userGroupId;
    }

    public List<Long> getDirectMembers() {
        return directMembers;
    }

    public List<Long> getDirectSubGroups() {
        return directSubGroups;
    }
}
