package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip linkifier.
 */
public class Linkifier {

    @JsonProperty
    private String pattern;
    @JsonProperty
    private String urlTemplate;
    @JsonProperty
    private long id;
    @JsonProperty
    private String exampleInput;
    @JsonProperty
    private String reverseTemplate;
    @JsonProperty
    private List<String> alternativeUrlTemplates = new ArrayList<>();

    public long getId() {
        return id;
    }

    public String getPattern() {
        return pattern;
    }

    public String getUrlTemplate() {
        return urlTemplate;
    }

    /**
     * Returns an example input string that matches the linkifier's pattern. Required for reverse linkifiers.
     *
     * @return example input string, or {@code null} if not set
     */
    public String getExampleInput() {
        return exampleInput;
    }

    /**
     * Returns a template using {@code {variable}} placeholders that can be used to generate the Markdown linkifier syntax
     * given a URL matching the URL template.
     *
     * @return reverse template string, or {@code null} if not set
     */
    public String getReverseTemplate() {
        return reverseTemplate;
    }

    /**
     * Returns additional RFC 6570 compliant URL template strings used for reverse linkification.
     *
     * @return list of alternative URL templates, never {@code null}
     */
    public List<String> getAlternativeUrlTemplates() {
        return alternativeUrlTemplates;
    }
}
