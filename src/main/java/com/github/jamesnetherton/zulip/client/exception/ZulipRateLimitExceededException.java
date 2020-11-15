package com.github.jamesnetherton.zulip.client.exception;

/**
 * Thrown when the Zulip server returns an HTTP response code of 429. Indicating that the
 * request rate limit has been reached.
 */
public class ZulipRateLimitExceededException extends Exception {

    private final long reteLimitReset;

    /**
     * Constructs a {@link ZulipRateLimitExceededException}.
     * 
     * @param rateLimitReset The time represented as a Unix time, at which the Zulip rate limit will be reset
     */
    public ZulipRateLimitExceededException(long rateLimitReset) {
        super("Rate limit exceeded");
        this.reteLimitReset = rateLimitReset;
    }

    /**
     * Gets the time at which the Zulip rate limit will be reset. The time is in the format of
     * <a href="https://en.wikipedia.org/wiki/Unix_time">Unix epoch</a>.
     *
     * @return The rate limit reset time
     */
    public long getReteLimitReset() {
        return reteLimitReset;
    }
}
