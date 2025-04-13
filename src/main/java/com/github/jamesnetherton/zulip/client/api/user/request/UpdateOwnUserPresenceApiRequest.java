package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ME_PRESENCE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetail;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceStatus;
import com.github.jamesnetherton.zulip.client.api.user.response.UpdateOwnUserPresenceApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * Zulip API request builder for updating own user presence.
 *
 * @see <a href="https://zulip.com/api/update-presence">https://zulip.com/api/update-presence</a>
 */
public class UpdateOwnUserPresenceApiRequest extends ZulipApiRequest
        implements ExecutableApiRequest<Map<Long, UserPresenceDetail>> {
    public static final String HISTORY_LIMIT_DAYS = "history_limit_days";
    public static final String LAST_UPDATE_ID = "last_update_id";
    public static final String NEW_USER_INPUT = "new_user_input";
    public static final String PING_ONLY = "ping_only";
    public static final String STATUS = "status";

    /**
     * Constructs a {@link UpdateOwnUserPresenceApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param status The status of the user
     */
    public UpdateOwnUserPresenceApiRequest(ZulipHttpClient client, UserPresenceStatus status) {
        super(client);
        if (!status.equals(UserPresenceStatus.ACTIVE) && !status.equals(UserPresenceStatus.IDLE)) {
            throw new IllegalArgumentException("Status must be one of ACTIVE or IDLE");
        }

        putParam(STATUS, status.name().toLowerCase());
        putParam(LAST_UPDATE_ID, -1);
    }

    /**
     * Sets how far back in time to fetch user presence data.
     *
     * @see                     <a href=
     *                          "https://zulip.com/api/update-presence#parameter-history_limit_days">https://zulip.com/api/update-presence#parameter-history_limit_days</a>
     *
     * @param  historyLimitDays how far back in time to fetch user presence data
     * @return                  This {@link UpdateOwnUserPresenceApiRequest} instance
     */
    public UpdateOwnUserPresenceApiRequest withHistoryLimitDays(int historyLimitDays) {
        putParam(HISTORY_LIMIT_DAYS, historyLimitDays);
        return this;
    }

    /**
     * Sets the identifier that specifies what presence data the client already has received.
     *
     * @see                 <a href=
     *                      "https://zulip.com/api/update-presence#parameter-last_update_id">https://zulip.com/api/update-presence#parameter-last_update_id</a>
     *
     * @param  lastUpdateId The identifier that specifies what presence data the client already has received
     * @return              This {@link UpdateOwnUserPresenceApiRequest} instance
     */
    public UpdateOwnUserPresenceApiRequest withLastUpdateId(int lastUpdateId) {
        putParam(LAST_UPDATE_ID, lastUpdateId);
        return this;
    }

    /**
     * Sets whether new user interaction has occurred.
     *
     * @see                 <a href=
     *                      "https://zulip.com/api/update-presence#parameter-new_user_input">https://zulip.com/api/update-presence#parameter-new_user_input</a>
     *
     * @param  newUserInput whether new user interaction has occurred
     * @return              This {@link UpdateOwnUserPresenceApiRequest} instance
     */
    public UpdateOwnUserPresenceApiRequest withNewUserInput(boolean newUserInput) {
        putParam(NEW_USER_INPUT, newUserInput);
        return this;
    }

    /**
     * Sets whether the client is sending a ping-only request.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/update-presence#parameter-ping_only">https://zulip.com/api/update-presence#parameter-ping_only</a>
     *
     * @param  pingOnly whether this is ping-only request
     * @return          This {@link UpdateOwnUserPresenceApiRequest} instance
     */
    public UpdateOwnUserPresenceApiRequest withPingOnly(boolean pingOnly) {
        putParam(PING_ONLY, pingOnly);
        return this;
    }

    /**
     * Executes the Zulip API request for updating own user presence.
     *
     * @return                      Map of {@link UserPresenceDetail} keyed by user id
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Map<Long, UserPresenceDetail> execute() throws ZulipClientException {
        return client().post(USERS_WITH_ME_PRESENCE, getParams(), UpdateOwnUserPresenceApiResponse.class).getPresences();
    }
}
