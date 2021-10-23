package com.github.jamesnetherton.zulip.client.http;

import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;

/**
 * Factory class for creating {@link ZulipHttpClient} implementations.
 *
 * Provides a way to use HTTP client libraries other than the default Apache Commons HTTP Client.
 */
public interface ZulipHttpClientFactory {
    ZulipHttpClient createZulipHttpClient(ZulipConfiguration configuration) throws ZulipClientException;
}
