package com.github.jamesnetherton.zulip.client.util;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

public class ZulipUrlUtilsTest {

    @Test
    public void pathSegmentAllowsOrdinaryValues() {
        assertEquals("test@test.com", ZulipUrlUtils.pathSegment("test@test.com"));
        assertEquals("smiley face", ZulipUrlUtils.pathSegment("smiley face"));
        assertEquals("zulip.com", ZulipUrlUtils.pathSegment("zulip.com"));
        assertNull(ZulipUrlUtils.pathSegment(null));
    }

    @ParameterizedTest
    @ValueSource(strings = { "users/me", "..", "../../json/users/me", "foo/../bar", "." })
    public void pathSegmentRejectsPathManipulation(String value) {
        assertThrows(IllegalArgumentException.class, () -> ZulipUrlUtils.pathSegment(value));
    }

    @Test
    public void pathSegmentsAllowsMultipleSegments() {
        assertEquals("4e/m2A3MSqFnWRLUf9SaPzQ0Up_/zulip.txt",
                ZulipUrlUtils.pathSegments("4e/m2A3MSqFnWRLUf9SaPzQ0Up_/zulip.txt"));
        assertNull(ZulipUrlUtils.pathSegments(null));
    }

    @ParameterizedTest
    @ValueSource(strings = { "../../json/users/me", "4e/../../../etc/passwd", "..", "foo/./bar", "foo\\bar" })
    public void pathSegmentsRejectsTraversal(String value) {
        assertThrows(IllegalArgumentException.class, () -> ZulipUrlUtils.pathSegments(value));
    }

    @Test
    public void containsRelativePathSegment() {
        assertTrue(ZulipUrlUtils.containsRelativePathSegment("users/../../admin"));
        assertTrue(ZulipUrlUtils.containsRelativePathSegment(".."));
        assertFalse(ZulipUrlUtils.containsRelativePathSegment("users/test@test.com"));
        assertFalse(ZulipUrlUtils.containsRelativePathSegment("realm/emoji/..dots.."));
    }
}
