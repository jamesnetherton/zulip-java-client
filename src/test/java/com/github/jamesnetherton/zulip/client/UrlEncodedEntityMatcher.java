package com.github.jamesnetherton.zulip.client;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.tomakehurst.wiremock.matching.EqualToPattern;
import com.github.tomakehurst.wiremock.matching.MatchResult;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class UrlEncodedEntityMatcher extends EqualToPattern {
    public UrlEncodedEntityMatcher(@JsonProperty("equalTo") String expectedValue) {
        super(expectedValue);
    }

    @Override
    public MatchResult match(String value) {
        boolean match = getParams(value).equals(getParams(getExpected()));
        return MatchResult.of(match);
    }

    private List<String> getParams(String value) {
        List<String> params = new ArrayList<>();
        if (value != null) {
            for (String elem : value.split("&")) {
                String[] param = elem.split("=");
                params.add(param[0] + "=" + param[1]);
            }
        }
        Collections.sort(params);
        return params;
    }
}
