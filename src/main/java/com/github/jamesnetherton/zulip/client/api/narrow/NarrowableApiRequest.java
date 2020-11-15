package com.github.jamesnetherton.zulip.client.api.narrow;

import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;

/**
 * Interface for Zulip APIs that support narrow filters.
 *
 * @see <a href="https://www.zulipchat.com/api/construct-narrow">https://www.zulipchat.com/api/construct-narrow</a>
 */
public interface NarrowableApiRequest<T extends ZulipApiRequest> {

    T withNarrows(Narrow... narrows);
}
