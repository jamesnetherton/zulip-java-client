package com.github.jamesnetherton.zulip.client.http.commons;

import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipConfiguration;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClientFactory;

/**
 * An {@link ZulipHttpClientFactory} implementation that creates a {@link ZulipHttpClient} based on
 * the Apache Commons HTTP Client.
 */
public class ZulipCommonsHttpClientFactory implements ZulipHttpClientFactory {

    @Override
    public ZulipHttpClient createZulipHttpClient(ZulipConfiguration configuration) throws ZulipClientException {
        return new ZulipCommonsHttpClient(configuration);
    }
}
