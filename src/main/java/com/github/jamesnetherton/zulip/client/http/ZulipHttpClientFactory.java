package com.github.jamesnetherton.zulip.client.http;

import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;

public interface ZulipHttpClientFactory {
    ZulipHttpClient createZulipHttpClient(ZulipConfiguration configuration) throws ZulipClientException;
}
