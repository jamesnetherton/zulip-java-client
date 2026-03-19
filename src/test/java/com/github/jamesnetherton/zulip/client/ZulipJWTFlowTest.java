package com.github.jamesnetherton.zulip.client;

import com.github.jamesnetherton.zulip.client.api.server.response.JwtFetchApiKeyResponse;
import com.github.jamesnetherton.zulip.client.api.user.User;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.util.JwtUtils;
import org.junit.jupiter.api.Test;

public class ZulipJWTFlowTest {

    private static final String SITE = "https://garten-schule.localhost.localdomain";
    private static final String ADMIN_EMAIL = "zulip@example.com";
    private static final String ADMIN_API_KEY = "JVKoRLEG0VVpli8EaDkwUkIbl7iSV7HH";
    private static final String TEST_USER_EMAIL = "member@example.com";
    private static final String JWT_SECRET = "p7K9xQ2mV8rL4nT6wY1cF3hJ5uB0sD8eR2kM7qN1zX4aC6v";

    @Test
    public void createJwtSecretKey() throws ZulipClientException {
        String secret = JwtUtils.createRandomJwtSecret();
        System.out.println(secret);
    }


    @Test
    public void createAdminZulipClient() throws ZulipClientException {

        // 1. create zulip instance with admin credentials
        Zulip adminZulip = new Zulip.Builder()
                .site(SITE)
                .email(ADMIN_EMAIL)
                .apiKey(ADMIN_API_KEY)
                .insecure(true)
                .build();

        // 1.1 execute request to check if creating zulip instance worked
        User adminUser = adminZulip.users().getOwnUser().execute();

        System.out.println("Admin log-in was successful");

        // 2. create a jwt for test user
        String jwt = JwtUtils.createJwtForEmail(TEST_USER_EMAIL, JWT_SECRET);

        System.out.println("JWT: " + jwt);

        // 3. use JWT request to get user API key
        JwtFetchApiKeyResponse jwtResponse = adminZulip.server()
                .jwtFetchApiKey(jwt)
                .withIncludeProfile(false)
                .execute();

        System.out.println("member ApiKey: " + jwtResponse.getApiKey());

        // 4. create new zulip instance with user
        Zulip memberZulip = new Zulip.Builder()
                .site(SITE)
                .email(jwtResponse.getEmail())
                .apiKey(jwtResponse.getApiKey())
                .insecure(true)
                .build();

        // 4.1 execute request to check if creating zulip instance worked
        User memberUser = memberZulip.users().getOwnUser().execute();

        System.out.println("Member log-in was successful");
    }
}