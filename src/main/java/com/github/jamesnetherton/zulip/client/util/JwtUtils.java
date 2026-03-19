package com.github.jamesnetherton.zulip.client.util;

import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * A utility class to create a JWT for an email and create a secret key.
 */
public class JwtUtils {

    private JwtUtils() {
    }

    /**
     * Creates a random JWT secret.
     */
    public static String createRandomJwtSecret() {
        byte[] secret = new byte[32];
        new SecureRandom().nextBytes(secret);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(secret);
    }

    /**
     * Creates a signed JWT for the given email.
     */
    public static String createJwtForEmail(String email, String secret) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("email cannot be null or blank");
        }

        if (secret == null || secret.isBlank()) {
            throw new IllegalArgumentException("secret cannot be null or blank");
        }

        try {
            JWSSigner signer = new MACSigner(secret.getBytes(StandardCharsets.UTF_8));

            JWTClaimsSet claimsSet = new JWTClaimsSet.Builder()
                    .claim("email", email)
                    .build();

            SignedJWT signedJWT = new SignedJWT(
                    new JWSHeader.Builder(JWSAlgorithm.HS256)
                            .type(JOSEObjectType.JWT)
                            .build(),
                    claimsSet);

            signedJWT.sign(signer);
            return signedJWT.serialize();
        } catch (JOSEException e) {
            throw new IllegalStateException("Failed to create JWT", e);
        }
    }
}