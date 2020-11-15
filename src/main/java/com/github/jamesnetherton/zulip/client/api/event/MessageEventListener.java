package com.github.jamesnetherton.zulip.client.api.event;

import com.github.jamesnetherton.zulip.client.api.message.Message;

/**
 * {@link EventListener} implementation to capture {@link Message} events.
 */
public interface MessageEventListener extends EventListener<Message> {
}
