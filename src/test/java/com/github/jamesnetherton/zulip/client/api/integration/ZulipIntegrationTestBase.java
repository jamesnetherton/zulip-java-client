package com.github.jamesnetherton.zulip.client.api.integration;

import static org.junit.jupiter.api.Assumptions.assumeTrue;

import com.github.jamesnetherton.zulip.client.Zulip;
import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.event.EventService;
import com.github.jamesnetherton.zulip.client.api.message.Anchor;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.MessageService;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.api.server.ProfileField;
import com.github.jamesnetherton.zulip.client.api.server.ServerService;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;
import com.github.jamesnetherton.zulip.client.api.stream.StreamService;
import com.github.jamesnetherton.zulip.client.api.user.User;
import com.github.jamesnetherton.zulip.client.api.user.UserGroup;
import com.github.jamesnetherton.zulip.client.api.user.UserService;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipConfiguration;
import java.io.File;
import java.net.InetAddress;
import java.util.List;
import java.util.function.Supplier;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;

public class ZulipIntegrationTestBase {

    protected static ZulipConfiguration configuration;
    protected static ThrottledZulip zulip;
    protected static User ownUser;

    @BeforeAll
    public static void beforeAll() throws ZulipClientException {
        File zuliprc = new File("./zuliprc");
        assumeTrue(zuliprc.exists() && zuliprc.canRead());

        configuration = ZulipConfiguration.fromZuliprc(zuliprc);

        boolean zulipAvailable = false;
        try {
            InetAddress address = InetAddress.getByName(configuration.getZulipUrl().getHost());
            zulipAvailable = address.isReachable(5000);
        } catch (Exception e) {
            // Host not available
        }

        assumeTrue(zulipAvailable);

        zulip = new ThrottledZulip(new Zulip(configuration));
        ownUser = zulip.users().getOwnUser().execute();
    }

    @AfterEach
    public void afterEach() throws Exception {
        if (zulip != null) {
            // Clean up messages
            List<Message> messages = zulip.messages().getMessages(100, 0, Anchor.NEWEST).execute();
            if (messages != null) {
                for (Message message : messages) {
                    try {
                        zulip.messages().deleteMessage(message.getId()).execute();
                    } catch (ZulipClientException e) {
                        // Ignore
                    }
                }
            }

            List<Message> privateMessages = zulip.messages()
                    .getMessages(100, 0, Anchor.NEWEST)
                    .withNarrows(Narrow.of("is", "private"))
                    .execute();
            if (privateMessages != null) {
                for (Message message : privateMessages) {
                    try {
                        zulip.messages().deleteMessage(message.getId()).execute();
                    } catch (ZulipClientException e) {
                        // Ignore
                    }
                }
            }

            // Clean up streams
            List<Stream> streams = zulip.streams().getAll().withIncludeDefault(false).execute();
            if (streams != null) {
                for (Stream stream : streams) {
                    try {
                        zulip.streams().delete(stream.getStreamId()).execute();
                    } catch (ZulipClientException e) {
                        // Ignore
                    }
                }
            }

            // Clean up user groups
            List<UserGroup> groups = zulip.users().getUserGroups().execute();
            if (groups != null) {
                for (UserGroup group : groups) {
                    try {
                        zulip.users().deleteUserGroup(group.getId()).execute();
                    } catch (ZulipClientException e) {
                        // Ignore
                    }
                }
            }

            // Clean up profile fields
            List<ProfileField> fields = zulip.server().getCustomProfileFields().execute();
            if (fields != null) {
                for (ProfileField field : fields) {
                    try {
                        zulip.server().deleteCustomProfileField(field.getId()).execute();
                    } catch (ZulipClientException e) {
                        // Ignore
                    }
                }
            }
        }
    }

    public static final class ThrottledZulip {

        private final Zulip delegate;

        ThrottledZulip(Zulip delegate) {
            this.delegate = delegate;
        }

        public EventService events() {
            return (EventService) throttle(delegate::events);
        }

        public MessageService messages() {
            return (MessageService) throttle(delegate::messages);
        }

        public ServerService server() {
            return (ServerService) throttle(delegate::server);
        }

        public StreamService streams() {
            return (StreamService) throttle(delegate::streams);
        }

        public UserService users() {
            return (UserService) throttle(delegate::users);
        }

        ZulipService throttle(Supplier<ZulipService> serviceResolver) {
            try {
                Thread.sleep(300);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } finally {
                return serviceResolver.get();
            }
        }
    }
}
