package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.REPORT_MESSAGE_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.MessageReportReason;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for reporting a message for moderation.
 *
 * @see <a href="https://zulip.com/api/report-message">https://zulip.com/api/report-message</a>
 */
public class ReportMessageApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String DESCRIPTION = "description";
    public static final String REPORT_TYPE = "report_type";
    private static final int DESCRIPTION_CHAR_LIMIT = 100;
    private final long messageId;
    private final MessageReportReason reportReason;

    /**
     * Constructs a {@link RenderMessageApiRequest}.
     *
     * @param client       The Zulip HTTP client
     * @param messageId    The id of the message to report
     * @param reportReason The reason for the message report
     */
    public ReportMessageApiRequest(ZulipHttpClient client, long messageId, MessageReportReason reportReason) {
        super(client);
        this.messageId = messageId;
        this.reportReason = reportReason;
        putParam(REPORT_TYPE, reportReason.toString());
    }

    /**
     * Sets a short description with additional context about why the current user is reporting the target message for
     * moderation.
     * If the given {@link MessageReportReason} is {@link MessageReportReason#OTHER} then a description is required.
     *
     * @param  description Short description
     * @return             This {@link ReportMessageApiRequest} instance
     */
    public ReportMessageApiRequest withDescription(String description) {
        putParam(DESCRIPTION, description);
        return this;
    }

    /**
     * Executes the Zulip API request for reporting a message for moderation.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String description = getParam(DESCRIPTION, String.class);
        if (this.reportReason == MessageReportReason.OTHER && (description == null || description.trim().isEmpty())) {
            throw new IllegalArgumentException("Description cannot be null or empty for MessageReportReason.OTHER");
        }

        if (description != null && description.trim().length() > DESCRIPTION_CHAR_LIMIT) {
            throw new IllegalArgumentException("Description cannot exceed " + DESCRIPTION_CHAR_LIMIT + " characters");
        }

        String path = String.format(REPORT_MESSAGE_API_PATH, messageId);
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}
