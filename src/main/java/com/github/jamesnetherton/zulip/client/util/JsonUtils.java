package com.github.jamesnetherton.zulip.client.util;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

/**
 * A utility class to configure and get the Jackson {@link ObjectMapper}.
 */
public class JsonUtils {

    private static final ObjectMapper mapper;

    static {
        mapper = new ObjectMapper();
        mapper.findAndRegisterModules();
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
    }

    /**
     * Gets the globally configured singleton Jackson {@link ObjectMapper}.
     *
     * @return The Jackson {@link ObjectMapper}
     */
    public static ObjectMapper getMapper() {
        return mapper;
    }
}
