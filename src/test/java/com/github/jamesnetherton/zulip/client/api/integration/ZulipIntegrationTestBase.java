package com.github.jamesnetherton.zulip.client.api.integration;

import static org.junit.jupiter.api.Assumptions.assumeTrue;

import com.github.jamesnetherton.zulip.client.Zulip;
import com.github.jamesnetherton.zulip.client.api.channel.ChannelFolder;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.draft.Draft;
import com.github.jamesnetherton.zulip.client.api.invitation.Invitation;
import com.github.jamesnetherton.zulip.client.api.message.Anchor;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.MessageReminder;
import com.github.jamesnetherton.zulip.client.api.message.ScheduledMessage;
import com.github.jamesnetherton.zulip.client.api.narrow.Narrow;
import com.github.jamesnetherton.zulip.client.api.navigationview.NavigationView;
import com.github.jamesnetherton.zulip.client.api.server.ProfileField;
import com.github.jamesnetherton.zulip.client.api.snippet.SavedSnippet;
import com.github.jamesnetherton.zulip.client.api.stream.Stream;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscription;
import com.github.jamesnetherton.zulip.client.api.user.User;
import com.github.jamesnetherton.zulip.client.api.user.UserGroup;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipConfiguration;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import com.github.jamesnetherton.zulip.client.http.commons.ZulipCommonsHttpClientFactory;
import java.io.File;
import java.net.HttpURLConnection;
import java.util.List;
import java.util.Map;
import javax.net.ssl.SSLHandshakeException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;

public class ZulipIntegrationTestBase {

    protected static boolean failOnIgnoredParametersUnsupported = Boolean.getBoolean("test.ignoredParametersUnsupported");
    protected static ZulipConfiguration configuration;
    protected static Zulip zulip;
    protected static User ownUser;

    @BeforeAll
    public static void beforeAll() throws ZulipClientException {
        File zuliprc = new File("./zuliprc");
        assumeTrue(zuliprc.exists() && zuliprc.canRead());

        configuration = ZulipConfiguration.fromZuliprc(zuliprc);

        HttpURLConnection connection = null;
        boolean zulipAvailable = true;
        try {
            connection = (HttpURLConnection) configuration.getZulipUrl().openConnection();
            connection.setConnectTimeout(5000);
            connection.connect();
        } catch (Exception e) {
            if (!(e instanceof SSLHandshakeException)) {
                zulipAvailable = false;
            }
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }

        assumeTrue(zulipAvailable);

        if (failOnIgnoredParametersUnsupported) {
            configuration.setZulipHttpClientFactory(configuration -> {
                final ZulipHttpClient delegate = new ZulipCommonsHttpClientFactory().createZulipHttpClient(configuration);
                return new ZulipHttpClient() {
                    @Override
                    public <T extends ZulipApiResponse> T get(String path, Map<String, Object> parameters, Class<T> responseAs)
                            throws ZulipClientException {
                        return handleResponse(delegate.get(path, parameters, responseAs));
                    }

                    @Override
                    public <T extends ZulipApiResponse> T get(String path, Map<String, Object> parameters,
                            int responseTimeoutSeconds, Class<T> responseAs) throws ZulipClientException {
                        return handleResponse(delegate.get(path, parameters, 10, responseAs));
                    }

                    @Override
                    public <T extends ZulipApiResponse> T delete(String path, Map<String, Object> parameters,
                            Class<T> responseAs) throws ZulipClientException {
                        return handleResponse(delegate.delete(path, parameters, responseAs));
                    }

                    @Override
                    public <T extends ZulipApiResponse> T patch(String path, Map<String, Object> parameters,
                            Class<T> responseAs) throws ZulipClientException {
                        return handleResponse(delegate.patch(path, parameters, responseAs));
                    }

                    @Override
                    public <T extends ZulipApiResponse> T post(String path, Map<String, Object> parameters, Class<T> responseAs)
                            throws ZulipClientException {
                        return handleResponse(delegate.post(path, parameters, responseAs));
                    }

                    @Override
                    public <T extends ZulipApiResponse> T upload(String path, File file, Class<T> responseAs)
                            throws ZulipClientException {
                        return handleResponse(delegate.upload(path, file, responseAs));
                    }

                    @Override
                    public void close() {
                        delegate.close();
                    }

                    private <T extends ZulipApiResponse> T handleResponse(T response) {
                        List<String> ignoredParametersUnsupported = response.getIgnoredParametersUnsupported();
                        if (ignoredParametersUnsupported != null && !ignoredParametersUnsupported.isEmpty()) {
                            throw new IllegalStateException("Unsupported parameters detected in the request");
                        }
                        return response;
                    }
                };
            });
        }

        zulip = new Zulip(configuration);
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

            List<ScheduledMessage> scheduledMessages = zulip.messages().getScheduledMessages().execute();
            if (scheduledMessages != null) {
                for (ScheduledMessage message : scheduledMessages) {
                    try {
                        zulip.messages().deleteScheduledMessage(message.getScheduledMessageId()).execute();
                    } catch (ZulipClientException e) {
                        // Ignore
                    }
                }
            }

            // Unsubscribe from streams
            List<StreamSubscription> streamSubscriptions = zulip.channels().getSubscribedStreams().execute();
            if (streamSubscriptions != null) {
                String[] streams = streamSubscriptions.stream()
                        .map(StreamSubscription::getName)
                        .distinct()
                        .toArray(String[]::new);
                zulip.channels().unsubscribe(streams);
            }

            // Clean up streams
            List<Stream> streams = zulip.channels().getAll().withIncludeDefault(false).execute();
            if (streams != null) {
                for (Stream stream : streams) {
                    try {
                        zulip.channels().delete(stream.getStreamId()).execute();
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
                        if (!group.isSystemGroup() && !group.isDeactivated()) {
                            zulip.users().deactivateUserGroup(group.getId()).execute();
                        }
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

            // Clean up drafts
            List<Draft> drafts = zulip.drafts().getDrafts().execute();
            if (drafts != null) {
                for (Draft draft : drafts) {
                    try {
                        zulip.drafts().deleteDraft(draft.getId()).execute();
                    } catch (ZulipClientException e) {
                        // Ignore
                    }
                }
            }

            // Clean up alert words
            List<String> alertWords = zulip.users().getAllAlertWords().execute();
            if (!alertWords.isEmpty()) {
                zulip.users().removeAlertWords(alertWords.toArray(new String[0]));
            }

            // Clean up invites
            List<Invitation> invitations = zulip.invitations().getAllInvitations().execute();
            invitations.forEach(invite -> {
                try {
                    if (invite.isMultiuse()) {
                        zulip.invitations().revokeReusableInvitation(invite.getId()).execute();
                    } else {
                        zulip.invitations().revokeEmailInvitation(invite.getId()).execute();
                    }
                } catch (ZulipClientException e) {
                    // ignore
                }
            });

            // Clean up saved snippets
            List<SavedSnippet> savedSnippets = zulip.snippets().getSavedSnippets().execute();
            savedSnippets.forEach(snippet -> {
                try {
                    zulip.snippets().deleteSavedSnippet(snippet.getId()).execute();
                } catch (ZulipClientException e) {
                    // ignore
                }
            });

            // Clean up message reminders
            List<MessageReminder> messageReminders = zulip.messages().getMessageReminders().execute();
            messageReminders.forEach(messageReminder -> {
                try {
                    zulip.messages().deleteMessageReminder(messageReminder.getReminderId()).execute();
                } catch (ZulipClientException e) {
                    // Ignore
                }
            });

            // Clean up navigation views
            List<NavigationView> navigationViews = zulip.navigationView().getAllNavigationViews().execute();
            navigationViews.forEach(navigationView -> {
                try {
                    zulip.navigationView().deleteNavigationView(navigationView.getFragment()).execute();
                } catch (ZulipClientException e) {
                    // Ignore
                }
            });

            // Clean up channel folders
            List<ChannelFolder> channelFolders = zulip.channels().getChannelFolders().execute();
            for (ChannelFolder channelFolder : channelFolders) {
                if (!channelFolder.isArchived()) {
                    zulip.channels().updateChannelFolder(channelFolder.getId())
                            .withIsArchived(true)
                            .execute();
                }
            }
        }
    }
}
