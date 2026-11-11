package com.github.jamesnetherton.zulip.client.util;

import tools.jackson.databind.DeserializationFeature;
import tools.jackson.databind.ObjectMapper;
import tools.jackson.databind.PropertyNamingStrategies;
import tools.jackson.databind.json.JsonMapper;

/**
 * A utility class to configure and get the Jackson {@link ObjectMapper}.
 */
public class JsonUtils {

    private static final ObjectMapper mapper;

    static {
        mapper = JsonMapper.builderWithJackson2Defaults()
                .findAndAddModules()
                .disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES)
                .propertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE)
                .build();
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
