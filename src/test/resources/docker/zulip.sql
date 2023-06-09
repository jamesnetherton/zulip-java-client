--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: zulip; Type: SCHEMA; Schema: -; Owner: zulip
--

DROP SCHEMA IF EXISTS zulip CASCADE;
CREATE SCHEMA zulip;


ALTER SCHEMA zulip OWNER TO zulip;

--
-- Name: pgroonga; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgroonga WITH SCHEMA zulip;


--
-- Name: EXTENSION pgroonga; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgroonga IS 'Super fast and all languages supported full text search index based on Groonga';


--
-- Name: append_to_fts_update_log(); Type: FUNCTION; Schema: zulip; Owner: zulip
--

CREATE FUNCTION zulip.append_to_fts_update_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN INSERT INTO fts_update_log (message_id) VALUES (NEW.id); RETURN NEW; END $$;


ALTER FUNCTION zulip.append_to_fts_update_log() OWNER TO zulip;

--
-- Name: do_notify_fts_update_log(); Type: FUNCTION; Schema: zulip; Owner: zulip
--

CREATE FUNCTION zulip.do_notify_fts_update_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN NOTIFY fts_update_log; RETURN NEW; END $$;


ALTER FUNCTION zulip.do_notify_fts_update_log() OWNER TO zulip;

--
-- Name: escape_html(text); Type: FUNCTION; Schema: zulip; Owner: zulip
--

CREATE FUNCTION zulip.escape_html(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
  SELECT replace(replace(replace(replace(replace($1, '&', '&amp;'), '<', '&lt;'),
                                 '>', '&gt;'), '"', '&quot;'), '''', '&#39;');
$_$;


ALTER FUNCTION zulip.escape_html(text) OWNER TO zulip;

--
-- Name: english_us_hunspell; Type: TEXT SEARCH DICTIONARY; Schema: zulip; Owner: zulip
--

CREATE TEXT SEARCH DICTIONARY zulip.english_us_hunspell (
    TEMPLATE = pg_catalog.ispell,
    dictfile = 'en_us', afffile = 'en_us', stopwords = 'zulip_english' );


ALTER TEXT SEARCH DICTIONARY zulip.english_us_hunspell OWNER TO zulip;

--
-- Name: english_us_search; Type: TEXT SEARCH CONFIGURATION; Schema: zulip; Owner: zulip
--

CREATE TEXT SEARCH CONFIGURATION zulip.english_us_search (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR asciiword WITH zulip.english_us_hunspell, english_stem;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR word WITH zulip.english_us_hunspell, english_stem;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR hword_part WITH zulip.english_us_hunspell, english_stem;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR hword_asciipart WITH zulip.english_us_hunspell, english_stem;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR asciihword WITH zulip.english_us_hunspell, english_stem;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR hword WITH zulip.english_us_hunspell, english_stem;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search
    ADD MAPPING FOR uint WITH simple;


ALTER TEXT SEARCH CONFIGURATION zulip.english_us_search OWNER TO zulip;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: analytics_fillstate; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_fillstate (
    id integer NOT NULL,
    property character varying(40) NOT NULL,
    end_time timestamp with time zone NOT NULL,
    state smallint NOT NULL,
    CONSTRAINT analytics_fillstate_state_check CHECK ((state >= 0))
);


ALTER TABLE zulip.analytics_fillstate OWNER TO zulip;

--
-- Name: analytics_fillstate_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.analytics_fillstate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.analytics_fillstate_id_seq OWNER TO zulip;

--
-- Name: analytics_fillstate_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.analytics_fillstate_id_seq OWNED BY zulip.analytics_fillstate.id;


--
-- Name: analytics_installationcount; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_installationcount (
    id integer NOT NULL,
    property character varying(32) NOT NULL,
    end_time timestamp with time zone NOT NULL,
    value bigint NOT NULL,
    subgroup character varying(16)
);


ALTER TABLE zulip.analytics_installationcount OWNER TO zulip;

--
-- Name: analytics_installationcount_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.analytics_installationcount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.analytics_installationcount_id_seq OWNER TO zulip;

--
-- Name: analytics_installationcount_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.analytics_installationcount_id_seq OWNED BY zulip.analytics_installationcount.id;


--
-- Name: analytics_realmcount; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_realmcount (
    id integer NOT NULL,
    realm_id integer NOT NULL,
    property character varying(32) NOT NULL,
    end_time timestamp with time zone NOT NULL,
    value bigint NOT NULL,
    subgroup character varying(16)
);


ALTER TABLE zulip.analytics_realmcount OWNER TO zulip;

--
-- Name: analytics_realmcount_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.analytics_realmcount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.analytics_realmcount_id_seq OWNER TO zulip;

--
-- Name: analytics_realmcount_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.analytics_realmcount_id_seq OWNED BY zulip.analytics_realmcount.id;


--
-- Name: analytics_streamcount; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_streamcount (
    id integer NOT NULL,
    realm_id integer NOT NULL,
    stream_id integer NOT NULL,
    property character varying(32) NOT NULL,
    end_time timestamp with time zone NOT NULL,
    value bigint NOT NULL,
    subgroup character varying(16)
);


ALTER TABLE zulip.analytics_streamcount OWNER TO zulip;

--
-- Name: analytics_streamcount_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.analytics_streamcount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.analytics_streamcount_id_seq OWNER TO zulip;

--
-- Name: analytics_streamcount_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.analytics_streamcount_id_seq OWNED BY zulip.analytics_streamcount.id;


--
-- Name: analytics_usercount; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_usercount (
    id integer NOT NULL,
    realm_id integer NOT NULL,
    user_id integer NOT NULL,
    property character varying(32) NOT NULL,
    end_time timestamp with time zone NOT NULL,
    value bigint NOT NULL,
    subgroup character varying(16)
);


ALTER TABLE zulip.analytics_usercount OWNER TO zulip;

--
-- Name: analytics_usercount_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.analytics_usercount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.analytics_usercount_id_seq OWNER TO zulip;

--
-- Name: analytics_usercount_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.analytics_usercount_id_seq OWNED BY zulip.analytics_usercount.id;


--
-- Name: auth_group; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE zulip.auth_group OWNER TO zulip;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.auth_group_id_seq OWNER TO zulip;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.auth_group_id_seq OWNED BY zulip.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE zulip.auth_group_permissions OWNER TO zulip;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.auth_group_permissions_id_seq OWNER TO zulip;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.auth_group_permissions_id_seq OWNED BY zulip.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE zulip.auth_permission OWNER TO zulip;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.auth_permission_id_seq OWNER TO zulip;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.auth_permission_id_seq OWNED BY zulip.auth_permission.id;


--
-- Name: confirmation_confirmation; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.confirmation_confirmation (
    id integer NOT NULL,
    object_id integer NOT NULL,
    date_sent timestamp with time zone NOT NULL,
    confirmation_key character varying(40) NOT NULL,
    content_type_id integer NOT NULL,
    type smallint NOT NULL,
    realm_id integer,
    expiry_date timestamp with time zone,
    CONSTRAINT confirmation_confirmation_object_id_check CHECK ((object_id >= 0)),
    CONSTRAINT confirmation_confirmation_type_check CHECK ((type >= 0))
);


ALTER TABLE zulip.confirmation_confirmation OWNER TO zulip;

--
-- Name: confirmation_confirmation_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.confirmation_confirmation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.confirmation_confirmation_id_seq OWNER TO zulip;

--
-- Name: confirmation_confirmation_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.confirmation_confirmation_id_seq OWNED BY zulip.confirmation_confirmation.id;


--
-- Name: confirmation_realmcreationkey; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.confirmation_realmcreationkey (
    id integer NOT NULL,
    creation_key character varying(40) NOT NULL,
    date_created timestamp with time zone NOT NULL,
    presume_email_valid boolean NOT NULL
);


ALTER TABLE zulip.confirmation_realmcreationkey OWNER TO zulip;

--
-- Name: confirmation_realmcreationkey_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.confirmation_realmcreationkey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.confirmation_realmcreationkey_id_seq OWNER TO zulip;

--
-- Name: confirmation_realmcreationkey_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.confirmation_realmcreationkey_id_seq OWNED BY zulip.confirmation_realmcreationkey.id;


--
-- Name: django_content_type; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE zulip.django_content_type OWNER TO zulip;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.django_content_type_id_seq OWNER TO zulip;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.django_content_type_id_seq OWNED BY zulip.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE zulip.django_migrations OWNER TO zulip;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.django_migrations_id_seq OWNER TO zulip;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.django_migrations_id_seq OWNED BY zulip.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE zulip.django_session OWNER TO zulip;

--
-- Name: fts_update_log; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.fts_update_log (
    id integer NOT NULL,
    message_id integer NOT NULL
);


ALTER TABLE zulip.fts_update_log OWNER TO zulip;

--
-- Name: fts_update_log_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.fts_update_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.fts_update_log_id_seq OWNER TO zulip;

--
-- Name: fts_update_log_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.fts_update_log_id_seq OWNED BY zulip.fts_update_log.id;


--
-- Name: otp_static_staticdevice; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.otp_static_staticdevice (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    confirmed boolean NOT NULL,
    user_id integer NOT NULL,
    throttling_failure_count integer NOT NULL,
    throttling_failure_timestamp timestamp with time zone,
    CONSTRAINT otp_static_staticdevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0))
);


ALTER TABLE zulip.otp_static_staticdevice OWNER TO zulip;

--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.otp_static_staticdevice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.otp_static_staticdevice_id_seq OWNER TO zulip;

--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.otp_static_staticdevice_id_seq OWNED BY zulip.otp_static_staticdevice.id;


--
-- Name: otp_static_statictoken; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.otp_static_statictoken (
    id integer NOT NULL,
    token character varying(16) NOT NULL,
    device_id integer NOT NULL
);


ALTER TABLE zulip.otp_static_statictoken OWNER TO zulip;

--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.otp_static_statictoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.otp_static_statictoken_id_seq OWNER TO zulip;

--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.otp_static_statictoken_id_seq OWNED BY zulip.otp_static_statictoken.id;


--
-- Name: otp_totp_totpdevice; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.otp_totp_totpdevice (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    confirmed boolean NOT NULL,
    key character varying(80) NOT NULL,
    step smallint NOT NULL,
    t0 bigint NOT NULL,
    digits smallint NOT NULL,
    tolerance smallint NOT NULL,
    drift smallint NOT NULL,
    last_t bigint NOT NULL,
    user_id integer NOT NULL,
    throttling_failure_count integer NOT NULL,
    throttling_failure_timestamp timestamp with time zone,
    CONSTRAINT otp_totp_totpdevice_digits_check CHECK ((digits >= 0)),
    CONSTRAINT otp_totp_totpdevice_step_check CHECK ((step >= 0)),
    CONSTRAINT otp_totp_totpdevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0)),
    CONSTRAINT otp_totp_totpdevice_tolerance_check CHECK ((tolerance >= 0))
);


ALTER TABLE zulip.otp_totp_totpdevice OWNER TO zulip;

--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.otp_totp_totpdevice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.otp_totp_totpdevice_id_seq OWNER TO zulip;

--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.otp_totp_totpdevice_id_seq OWNED BY zulip.otp_totp_totpdevice.id;


--
-- Name: social_auth_association; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.social_auth_association (
    id bigint NOT NULL,
    server_url character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    issued integer NOT NULL,
    lifetime integer NOT NULL,
    assoc_type character varying(64) NOT NULL
);


ALTER TABLE zulip.social_auth_association OWNER TO zulip;

--
-- Name: social_auth_association_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.social_auth_association_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.social_auth_association_id_seq OWNER TO zulip;

--
-- Name: social_auth_association_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.social_auth_association_id_seq OWNED BY zulip.social_auth_association.id;


--
-- Name: social_auth_code; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.social_auth_code (
    id bigint NOT NULL,
    email character varying(254) NOT NULL,
    code character varying(32) NOT NULL,
    verified boolean NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE zulip.social_auth_code OWNER TO zulip;

--
-- Name: social_auth_code_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.social_auth_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.social_auth_code_id_seq OWNER TO zulip;

--
-- Name: social_auth_code_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.social_auth_code_id_seq OWNED BY zulip.social_auth_code.id;


--
-- Name: social_auth_nonce; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.social_auth_nonce (
    id bigint NOT NULL,
    server_url character varying(255) NOT NULL,
    "timestamp" integer NOT NULL,
    salt character varying(65) NOT NULL
);


ALTER TABLE zulip.social_auth_nonce OWNER TO zulip;

--
-- Name: social_auth_nonce_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.social_auth_nonce_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.social_auth_nonce_id_seq OWNER TO zulip;

--
-- Name: social_auth_nonce_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.social_auth_nonce_id_seq OWNED BY zulip.social_auth_nonce.id;


--
-- Name: social_auth_partial; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.social_auth_partial (
    id bigint NOT NULL,
    token character varying(32) NOT NULL,
    next_step smallint NOT NULL,
    backend character varying(32) NOT NULL,
    data text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    CONSTRAINT social_auth_partial_next_step_check CHECK ((next_step >= 0))
);


ALTER TABLE zulip.social_auth_partial OWNER TO zulip;

--
-- Name: social_auth_partial_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.social_auth_partial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.social_auth_partial_id_seq OWNER TO zulip;

--
-- Name: social_auth_partial_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.social_auth_partial_id_seq OWNED BY zulip.social_auth_partial.id;


--
-- Name: social_auth_usersocialauth; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.social_auth_usersocialauth (
    id bigint NOT NULL,
    provider character varying(32) NOT NULL,
    uid character varying(255) NOT NULL,
    extra_data text NOT NULL,
    user_id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL
);


ALTER TABLE zulip.social_auth_usersocialauth OWNER TO zulip;

--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.social_auth_usersocialauth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.social_auth_usersocialauth_id_seq OWNER TO zulip;

--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.social_auth_usersocialauth_id_seq OWNED BY zulip.social_auth_usersocialauth.id;


--
-- Name: third_party_api_results; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.third_party_api_results (
    cache_key character varying(255) NOT NULL,
    value text NOT NULL,
    expires timestamp with time zone NOT NULL
);


ALTER TABLE zulip.third_party_api_results OWNER TO zulip;

--
-- Name: two_factor_phonedevice; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.two_factor_phonedevice (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    confirmed boolean NOT NULL,
    number character varying(128) NOT NULL,
    key character varying(40) NOT NULL,
    method character varying(4) NOT NULL,
    user_id integer NOT NULL,
    throttling_failure_count integer NOT NULL,
    throttling_failure_timestamp timestamp with time zone,
    CONSTRAINT two_factor_phonedevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0))
);


ALTER TABLE zulip.two_factor_phonedevice OWNER TO zulip;

--
-- Name: two_factor_phonedevice_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.two_factor_phonedevice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.two_factor_phonedevice_id_seq OWNER TO zulip;

--
-- Name: two_factor_phonedevice_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.two_factor_phonedevice_id_seq OWNED BY zulip.two_factor_phonedevice.id;


--
-- Name: zerver_alertword; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_alertword (
    id integer NOT NULL,
    word text NOT NULL,
    realm_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_alertword OWNER TO zulip;

--
-- Name: zerver_alertword_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_alertword_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_alertword_id_seq OWNER TO zulip;

--
-- Name: zerver_alertword_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_alertword_id_seq OWNED BY zulip.zerver_alertword.id;


--
-- Name: zerver_archivedattachment; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedattachment (
    id integer NOT NULL,
    file_name text NOT NULL,
    path_id text NOT NULL,
    is_realm_public boolean,
    create_time timestamp with time zone NOT NULL,
    size integer NOT NULL,
    owner_id integer NOT NULL,
    realm_id integer NOT NULL,
    is_web_public boolean
);


ALTER TABLE zulip.zerver_archivedattachment OWNER TO zulip;

--
-- Name: zerver_archivedattachment_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_archivedattachment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_archivedattachment_id_seq OWNER TO zulip;

--
-- Name: zerver_archivedattachment_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_archivedattachment_id_seq OWNED BY zulip.zerver_archivedattachment.id;


--
-- Name: zerver_archivedattachment_messages; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedattachment_messages (
    id integer NOT NULL,
    archivedattachment_id integer NOT NULL,
    archivedmessage_id integer NOT NULL
);


ALTER TABLE zulip.zerver_archivedattachment_messages OWNER TO zulip;

--
-- Name: zerver_archivedattachment_messages_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_archivedattachment_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_archivedattachment_messages_id_seq OWNER TO zulip;

--
-- Name: zerver_archivedattachment_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_archivedattachment_messages_id_seq OWNED BY zulip.zerver_archivedattachment_messages.id;


--
-- Name: zerver_archivedmessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedmessage (
    id integer NOT NULL,
    subject character varying(60) NOT NULL,
    content text NOT NULL,
    rendered_content text,
    rendered_content_version integer,
    date_sent timestamp with time zone NOT NULL,
    last_edit_time timestamp with time zone,
    edit_history text,
    has_attachment boolean NOT NULL,
    has_image boolean NOT NULL,
    has_link boolean NOT NULL,
    recipient_id integer NOT NULL,
    sender_id integer NOT NULL,
    sending_client_id integer NOT NULL,
    archive_transaction_id integer NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_archivedmessage OWNER TO zulip;

--
-- Name: zerver_archivedmessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_archivedmessage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_archivedmessage_id_seq OWNER TO zulip;

--
-- Name: zerver_archivedmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_archivedmessage_id_seq OWNED BY zulip.zerver_archivedmessage.id;


--
-- Name: zerver_archivedreaction; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedreaction (
    id integer NOT NULL,
    emoji_name text NOT NULL,
    reaction_type character varying(30) NOT NULL,
    emoji_code text NOT NULL,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_archivedreaction OWNER TO zulip;

--
-- Name: zerver_archivedreaction_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_archivedreaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_archivedreaction_id_seq OWNER TO zulip;

--
-- Name: zerver_archivedreaction_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_archivedreaction_id_seq OWNED BY zulip.zerver_archivedreaction.id;


--
-- Name: zerver_archivedsubmessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedsubmessage (
    id integer NOT NULL,
    msg_type text NOT NULL,
    content text NOT NULL,
    message_id integer NOT NULL,
    sender_id integer NOT NULL
);


ALTER TABLE zulip.zerver_archivedsubmessage OWNER TO zulip;

--
-- Name: zerver_archivedsubmessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_archivedsubmessage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_archivedsubmessage_id_seq OWNER TO zulip;

--
-- Name: zerver_archivedsubmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_archivedsubmessage_id_seq OWNED BY zulip.zerver_archivedsubmessage.id;


--
-- Name: zerver_archivedusermessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedusermessage (
    id bigint NOT NULL,
    flags bigint NOT NULL,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_archivedusermessage OWNER TO zulip;

--
-- Name: zerver_archivedusermessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_archivedusermessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_archivedusermessage_id_seq OWNER TO zulip;

--
-- Name: zerver_archivedusermessage_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_archivedusermessage_id_seq OWNED BY zulip.zerver_archivedusermessage.id;


--
-- Name: zerver_archivetransaction; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivetransaction (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    restored boolean NOT NULL,
    type smallint NOT NULL,
    realm_id integer,
    CONSTRAINT zerver_archivetransaction_type_check CHECK ((type >= 0))
);


ALTER TABLE zulip.zerver_archivetransaction OWNER TO zulip;

--
-- Name: zerver_archivetransaction_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_archivetransaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_archivetransaction_id_seq OWNER TO zulip;

--
-- Name: zerver_archivetransaction_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_archivetransaction_id_seq OWNED BY zulip.zerver_archivetransaction.id;


--
-- Name: zerver_attachment; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_attachment (
    id integer NOT NULL,
    file_name text NOT NULL,
    path_id text NOT NULL,
    create_time timestamp with time zone NOT NULL,
    owner_id integer NOT NULL,
    is_realm_public boolean,
    realm_id integer NOT NULL,
    size integer NOT NULL,
    is_web_public boolean
);


ALTER TABLE zulip.zerver_attachment OWNER TO zulip;

--
-- Name: zerver_attachment_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_attachment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_attachment_id_seq OWNER TO zulip;

--
-- Name: zerver_attachment_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_attachment_id_seq OWNED BY zulip.zerver_attachment.id;


--
-- Name: zerver_attachment_messages; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_attachment_messages (
    id integer NOT NULL,
    attachment_id integer NOT NULL,
    message_id integer NOT NULL
);


ALTER TABLE zulip.zerver_attachment_messages OWNER TO zulip;

--
-- Name: zerver_attachment_messages_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_attachment_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_attachment_messages_id_seq OWNER TO zulip;

--
-- Name: zerver_attachment_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_attachment_messages_id_seq OWNED BY zulip.zerver_attachment_messages.id;


--
-- Name: zerver_attachment_scheduled_messages; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_attachment_scheduled_messages (
    id integer NOT NULL,
    attachment_id integer NOT NULL,
    scheduledmessage_id integer NOT NULL
);


ALTER TABLE zulip.zerver_attachment_scheduled_messages OWNER TO zulip;

--
-- Name: zerver_attachment_scheduled_messages_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_attachment_scheduled_messages ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_attachment_scheduled_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_botconfigdata; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_botconfigdata (
    id integer NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    bot_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_botconfigdata OWNER TO zulip;

--
-- Name: zerver_botstoragedata; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_botstoragedata (
    id integer NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    bot_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_botstoragedata OWNER TO zulip;

--
-- Name: zerver_botuserconfigdata_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_botuserconfigdata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_botuserconfigdata_id_seq OWNER TO zulip;

--
-- Name: zerver_botuserconfigdata_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_botuserconfigdata_id_seq OWNED BY zulip.zerver_botconfigdata.id;


--
-- Name: zerver_botuserstatedata_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_botuserstatedata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_botuserstatedata_id_seq OWNER TO zulip;

--
-- Name: zerver_botuserstatedata_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_botuserstatedata_id_seq OWNED BY zulip.zerver_botstoragedata.id;


--
-- Name: zerver_client; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_client (
    id integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE zulip.zerver_client OWNER TO zulip;

--
-- Name: zerver_client_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_client_id_seq OWNER TO zulip;

--
-- Name: zerver_client_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_client_id_seq OWNED BY zulip.zerver_client.id;


--
-- Name: zerver_customprofilefield; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_customprofilefield (
    id integer NOT NULL,
    name character varying(40) NOT NULL,
    field_type smallint NOT NULL,
    realm_id integer NOT NULL,
    hint character varying(80) NOT NULL,
    field_data text NOT NULL,
    "order" integer NOT NULL,
    display_in_profile_summary boolean NOT NULL,
    CONSTRAINT zerver_customprofilefield_field_type_check CHECK ((field_type >= 0))
);


ALTER TABLE zulip.zerver_customprofilefield OWNER TO zulip;

--
-- Name: zerver_customprofilefield_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_customprofilefield_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_customprofilefield_id_seq OWNER TO zulip;

--
-- Name: zerver_customprofilefield_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_customprofilefield_id_seq OWNED BY zulip.zerver_customprofilefield.id;


--
-- Name: zerver_customprofilefieldvalue; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_customprofilefieldvalue (
    id integer NOT NULL,
    value text NOT NULL,
    field_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    rendered_value text
);


ALTER TABLE zulip.zerver_customprofilefieldvalue OWNER TO zulip;

--
-- Name: zerver_customprofilefieldvalue_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_customprofilefieldvalue_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_customprofilefieldvalue_id_seq OWNER TO zulip;

--
-- Name: zerver_customprofilefieldvalue_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_customprofilefieldvalue_id_seq OWNED BY zulip.zerver_customprofilefieldvalue.id;


--
-- Name: zerver_defaultstream; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_defaultstream (
    id integer NOT NULL,
    realm_id integer NOT NULL,
    stream_id integer NOT NULL
);


ALTER TABLE zulip.zerver_defaultstream OWNER TO zulip;

--
-- Name: zerver_defaultstream_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_defaultstream_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_defaultstream_id_seq OWNER TO zulip;

--
-- Name: zerver_defaultstream_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_defaultstream_id_seq OWNED BY zulip.zerver_defaultstream.id;


--
-- Name: zerver_defaultstreamgroup; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_defaultstreamgroup (
    id integer NOT NULL,
    name character varying(60) NOT NULL,
    realm_id integer NOT NULL,
    description character varying(1024) NOT NULL
);


ALTER TABLE zulip.zerver_defaultstreamgroup OWNER TO zulip;

--
-- Name: zerver_defaultstreamgroup_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_defaultstreamgroup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_defaultstreamgroup_id_seq OWNER TO zulip;

--
-- Name: zerver_defaultstreamgroup_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_defaultstreamgroup_id_seq OWNED BY zulip.zerver_defaultstreamgroup.id;


--
-- Name: zerver_defaultstreamgroup_streams; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_defaultstreamgroup_streams (
    id integer NOT NULL,
    defaultstreamgroup_id integer NOT NULL,
    stream_id integer NOT NULL
);


ALTER TABLE zulip.zerver_defaultstreamgroup_streams OWNER TO zulip;

--
-- Name: zerver_defaultstreamgroup_streams_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_defaultstreamgroup_streams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_defaultstreamgroup_streams_id_seq OWNER TO zulip;

--
-- Name: zerver_defaultstreamgroup_streams_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_defaultstreamgroup_streams_id_seq OWNED BY zulip.zerver_defaultstreamgroup_streams.id;


--
-- Name: zerver_draft; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_draft (
    id integer NOT NULL,
    topic character varying(60) NOT NULL,
    content text NOT NULL,
    last_edit_time timestamp with time zone NOT NULL,
    recipient_id integer,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_draft OWNER TO zulip;

--
-- Name: zerver_draft_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_draft_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_draft_id_seq OWNER TO zulip;

--
-- Name: zerver_draft_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_draft_id_seq OWNED BY zulip.zerver_draft.id;


--
-- Name: zerver_emailchangestatus; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_emailchangestatus (
    id integer NOT NULL,
    new_email character varying(254) NOT NULL,
    old_email character varying(254) NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status integer NOT NULL,
    realm_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_emailchangestatus OWNER TO zulip;

--
-- Name: zerver_emailchangestatus_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_emailchangestatus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_emailchangestatus_id_seq OWNER TO zulip;

--
-- Name: zerver_emailchangestatus_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_emailchangestatus_id_seq OWNED BY zulip.zerver_emailchangestatus.id;


--
-- Name: zerver_groupgroupmembership; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_groupgroupmembership (
    id integer NOT NULL,
    subgroup_id integer NOT NULL,
    supergroup_id integer NOT NULL
);


ALTER TABLE zulip.zerver_groupgroupmembership OWNER TO zulip;

--
-- Name: zerver_groupgroupmembership_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_groupgroupmembership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_groupgroupmembership_id_seq OWNER TO zulip;

--
-- Name: zerver_groupgroupmembership_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_groupgroupmembership_id_seq OWNED BY zulip.zerver_groupgroupmembership.id;


--
-- Name: zerver_huddle; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_huddle (
    id integer NOT NULL,
    huddle_hash character varying(40) NOT NULL,
    recipient_id integer
);


ALTER TABLE zulip.zerver_huddle OWNER TO zulip;

--
-- Name: zerver_huddle_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_huddle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_huddle_id_seq OWNER TO zulip;

--
-- Name: zerver_huddle_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_huddle_id_seq OWNED BY zulip.zerver_huddle.id;


--
-- Name: zerver_message; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_message (
    id integer NOT NULL,
    subject character varying(60) NOT NULL,
    content text NOT NULL,
    rendered_content text,
    rendered_content_version integer,
    last_edit_time timestamp with time zone,
    edit_history text,
    has_attachment boolean NOT NULL,
    has_image boolean NOT NULL,
    has_link boolean NOT NULL,
    recipient_id integer NOT NULL,
    sender_id integer NOT NULL,
    sending_client_id integer NOT NULL,
    search_tsvector tsvector,
    date_sent timestamp with time zone NOT NULL,
    realm_id integer NOT NULL
);
ALTER TABLE ONLY zulip.zerver_message ALTER COLUMN search_tsvector SET STATISTICS 10000;


ALTER TABLE zulip.zerver_message OWNER TO zulip;

--
-- Name: zerver_message_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_message_id_seq OWNER TO zulip;

--
-- Name: zerver_message_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_message_id_seq OWNED BY zulip.zerver_message.id;


--
-- Name: zerver_missedmessageemailaddress; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_missedmessageemailaddress (
    id integer NOT NULL,
    email_token character varying(34) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    times_used integer NOT NULL,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    CONSTRAINT zerver_missedmessageemailaddress_times_used_check CHECK ((times_used >= 0))
);


ALTER TABLE zulip.zerver_missedmessageemailaddress OWNER TO zulip;

--
-- Name: zerver_missedmessageemailaddress_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_missedmessageemailaddress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_missedmessageemailaddress_id_seq OWNER TO zulip;

--
-- Name: zerver_missedmessageemailaddress_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_missedmessageemailaddress_id_seq OWNED BY zulip.zerver_missedmessageemailaddress.id;


--
-- Name: zerver_multiuseinvite; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_multiuseinvite (
    id integer NOT NULL,
    realm_id integer NOT NULL,
    referred_by_id integer NOT NULL,
    invited_as smallint NOT NULL,
    status integer NOT NULL,
    CONSTRAINT zerver_multiuseinvite_invited_as_check CHECK ((invited_as >= 0))
);


ALTER TABLE zulip.zerver_multiuseinvite OWNER TO zulip;

--
-- Name: zerver_multiuseinvite_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_multiuseinvite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_multiuseinvite_id_seq OWNER TO zulip;

--
-- Name: zerver_multiuseinvite_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_multiuseinvite_id_seq OWNED BY zulip.zerver_multiuseinvite.id;


--
-- Name: zerver_multiuseinvite_streams; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_multiuseinvite_streams (
    id integer NOT NULL,
    multiuseinvite_id integer NOT NULL,
    stream_id integer NOT NULL
);


ALTER TABLE zulip.zerver_multiuseinvite_streams OWNER TO zulip;

--
-- Name: zerver_multiuseinvite_streams_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_multiuseinvite_streams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_multiuseinvite_streams_id_seq OWNER TO zulip;

--
-- Name: zerver_multiuseinvite_streams_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_multiuseinvite_streams_id_seq OWNED BY zulip.zerver_multiuseinvite_streams.id;


--
-- Name: zerver_usertopic; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usertopic (
    id integer NOT NULL,
    topic_name character varying(60) NOT NULL,
    recipient_id integer NOT NULL,
    stream_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    last_updated timestamp with time zone NOT NULL,
    visibility_policy smallint NOT NULL
);


ALTER TABLE zulip.zerver_usertopic OWNER TO zulip;

--
-- Name: zerver_mutedtopic_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_mutedtopic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_mutedtopic_id_seq OWNER TO zulip;

--
-- Name: zerver_mutedtopic_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_mutedtopic_id_seq OWNED BY zulip.zerver_usertopic.id;


--
-- Name: zerver_muteduser; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_muteduser (
    id integer NOT NULL,
    date_muted timestamp with time zone NOT NULL,
    muted_user_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_muteduser OWNER TO zulip;

--
-- Name: zerver_muteduser_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_muteduser_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_muteduser_id_seq OWNER TO zulip;

--
-- Name: zerver_muteduser_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_muteduser_id_seq OWNED BY zulip.zerver_muteduser.id;


--
-- Name: zerver_preregistrationrealm; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_preregistrationrealm (
    id integer NOT NULL,
    name character varying(40) NOT NULL,
    org_type smallint NOT NULL,
    string_id character varying(40) NOT NULL,
    email character varying(254) NOT NULL,
    status integer NOT NULL,
    created_realm_id integer,
    created_user_id integer,
    CONSTRAINT zerver_preregistrationrealm_org_type_check CHECK ((org_type >= 0))
);


ALTER TABLE zulip.zerver_preregistrationrealm OWNER TO zulip;

--
-- Name: zerver_preregistrationrealm_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_preregistrationrealm ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_preregistrationrealm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_preregistrationuser; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_preregistrationuser (
    id integer NOT NULL,
    email character varying(254) NOT NULL,
    invited_at timestamp with time zone NOT NULL,
    status integer NOT NULL,
    realm_id integer,
    referred_by_id integer,
    realm_creation boolean NOT NULL,
    password_required boolean NOT NULL,
    invited_as smallint NOT NULL,
    full_name character varying(100),
    full_name_validated boolean NOT NULL,
    created_user_id integer,
    multiuse_invite_id integer,
    CONSTRAINT zerver_preregistrationuser_invited_as_check CHECK ((invited_as >= 0))
);


ALTER TABLE zulip.zerver_preregistrationuser OWNER TO zulip;

--
-- Name: zerver_preregistrationuser_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_preregistrationuser_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_preregistrationuser_id_seq OWNER TO zulip;

--
-- Name: zerver_preregistrationuser_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_preregistrationuser_id_seq OWNED BY zulip.zerver_preregistrationuser.id;


--
-- Name: zerver_preregistrationuser_streams; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_preregistrationuser_streams (
    id integer NOT NULL,
    preregistrationuser_id integer NOT NULL,
    stream_id integer NOT NULL
);


ALTER TABLE zulip.zerver_preregistrationuser_streams OWNER TO zulip;

--
-- Name: zerver_preregistrationuser_streams_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_preregistrationuser_streams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_preregistrationuser_streams_id_seq OWNER TO zulip;

--
-- Name: zerver_preregistrationuser_streams_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_preregistrationuser_streams_id_seq OWNED BY zulip.zerver_preregistrationuser_streams.id;


--
-- Name: zerver_pushdevicetoken; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_pushdevicetoken (
    id integer NOT NULL,
    kind smallint NOT NULL,
    token character varying(4096) NOT NULL,
    last_updated timestamp with time zone NOT NULL,
    ios_app_id text,
    user_id integer NOT NULL,
    CONSTRAINT zerver_pushdevicetoken_kind_check CHECK ((kind >= 0))
);


ALTER TABLE zulip.zerver_pushdevicetoken OWNER TO zulip;

--
-- Name: zerver_pushdevicetoken_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_pushdevicetoken_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_pushdevicetoken_id_seq OWNER TO zulip;

--
-- Name: zerver_pushdevicetoken_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_pushdevicetoken_id_seq OWNED BY zulip.zerver_pushdevicetoken.id;


--
-- Name: zerver_reaction; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_reaction (
    id integer NOT NULL,
    user_profile_id integer NOT NULL,
    message_id integer NOT NULL,
    emoji_name text NOT NULL,
    emoji_code text NOT NULL,
    reaction_type character varying(30) NOT NULL
);


ALTER TABLE zulip.zerver_reaction OWNER TO zulip;

--
-- Name: zerver_reaction_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_reaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_reaction_id_seq OWNER TO zulip;

--
-- Name: zerver_reaction_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_reaction_id_seq OWNED BY zulip.zerver_reaction.id;


--
-- Name: zerver_realm; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realm (
    id integer NOT NULL,
    name character varying(40) NOT NULL,
    emails_restricted_to_domains boolean NOT NULL,
    invite_required boolean NOT NULL,
    mandatory_topics boolean NOT NULL,
    digest_emails_enabled boolean NOT NULL,
    name_changes_disabled boolean NOT NULL,
    date_created timestamp with time zone NOT NULL,
    deactivated boolean NOT NULL,
    notifications_stream_id integer,
    allow_message_editing boolean NOT NULL,
    message_content_edit_limit_seconds integer,
    default_language character varying(50) NOT NULL,
    string_id character varying(40) NOT NULL,
    org_type smallint NOT NULL,
    message_retention_days integer NOT NULL,
    waiting_period_threshold integer NOT NULL,
    icon_source character varying(1) NOT NULL,
    icon_version smallint NOT NULL,
    email_changes_disabled boolean NOT NULL,
    description text NOT NULL,
    inline_image_preview boolean NOT NULL,
    inline_url_embed_preview boolean NOT NULL,
    allow_edit_history boolean NOT NULL,
    signup_notifications_stream_id integer,
    max_invites integer,
    message_visibility_limit integer,
    upload_quota_gb integer,
    send_welcome_emails boolean NOT NULL,
    bot_creation_policy smallint NOT NULL,
    disallow_disposable_email_addresses boolean NOT NULL,
    message_content_delete_limit_seconds integer,
    plan_type smallint NOT NULL,
    first_visible_message_id integer NOT NULL,
    logo_source character varying(1) NOT NULL,
    logo_version smallint NOT NULL,
    message_content_allowed_in_email_notifications boolean NOT NULL,
    night_logo_source character varying(1) NOT NULL,
    night_logo_version smallint NOT NULL,
    digest_weekday smallint NOT NULL,
    invite_to_stream_policy smallint NOT NULL,
    avatar_changes_disabled boolean NOT NULL,
    video_chat_provider smallint NOT NULL,
    user_group_edit_policy smallint NOT NULL,
    private_message_policy smallint NOT NULL,
    default_code_block_language text,
    wildcard_mention_policy smallint NOT NULL,
    deactivated_redirect character varying(128),
    invite_to_realm_policy smallint NOT NULL,
    giphy_rating smallint NOT NULL,
    move_messages_between_streams_policy smallint NOT NULL,
    edit_topic_policy smallint NOT NULL,
    add_custom_emoji_policy smallint NOT NULL,
    demo_organization_scheduled_deletion_date timestamp with time zone,
    delete_own_message_policy smallint NOT NULL,
    create_private_stream_policy smallint NOT NULL,
    create_public_stream_policy smallint NOT NULL,
    create_web_public_stream_policy smallint NOT NULL,
    enable_spectator_access boolean NOT NULL,
    want_advertise_in_communities_directory boolean NOT NULL,
    enable_read_receipts boolean NOT NULL,
    move_messages_within_stream_limit_seconds integer,
    move_messages_between_streams_limit_seconds integer,
    CONSTRAINT zerver_realm_add_custom_emoji_policy_check CHECK ((add_custom_emoji_policy >= 0)),
    CONSTRAINT zerver_realm_bot_creation_policy_check CHECK ((bot_creation_policy >= 0)),
    CONSTRAINT zerver_realm_create_private_stream_policy_check CHECK ((create_private_stream_policy >= 0)),
    CONSTRAINT zerver_realm_create_public_stream_policy_check CHECK ((create_public_stream_policy >= 0)),
    CONSTRAINT zerver_realm_create_web_public_stream_policy_check CHECK ((create_web_public_stream_policy >= 0)),
    CONSTRAINT zerver_realm_delete_own_message_policy_check CHECK ((delete_own_message_policy >= 0)),
    CONSTRAINT zerver_realm_edit_topic_policy_check CHECK ((edit_topic_policy >= 0)),
    CONSTRAINT zerver_realm_giphy_rating_check CHECK ((giphy_rating >= 0)),
    CONSTRAINT zerver_realm_icon_version_check CHECK ((icon_version >= 0)),
    CONSTRAINT zerver_realm_invite_to_realm_policy_check CHECK ((invite_to_realm_policy >= 0)),
    CONSTRAINT zerver_realm_invite_to_stream_policy_check CHECK ((invite_to_stream_policy >= 0)),
    CONSTRAINT zerver_realm_logo_version_check CHECK ((logo_version >= 0)),
    CONSTRAINT zerver_realm_message_content_delete__0ae52b60_check CHECK ((message_content_delete_limit_seconds >= 0)),
    CONSTRAINT zerver_realm_message_content_edit_limit_seconds_0e3c9837_check CHECK ((message_content_edit_limit_seconds >= 0)),
    CONSTRAINT zerver_realm_move_messages_between_streams_limit_seconds_check CHECK ((move_messages_between_streams_limit_seconds >= 0)),
    CONSTRAINT zerver_realm_move_messages_between_streams_policy_check CHECK ((move_messages_between_streams_policy >= 0)),
    CONSTRAINT zerver_realm_move_messages_within_stream_limit_seconds_check CHECK ((move_messages_within_stream_limit_seconds >= 0)),
    CONSTRAINT zerver_realm_night_logo_version_check CHECK ((night_logo_version >= 0)),
    CONSTRAINT zerver_realm_org_type_check CHECK ((org_type >= 0)),
    CONSTRAINT zerver_realm_plan_type_check CHECK ((plan_type >= 0)),
    CONSTRAINT zerver_realm_private_message_policy_check CHECK ((private_message_policy >= 0)),
    CONSTRAINT zerver_realm_user_group_edit_policy_check CHECK ((user_group_edit_policy >= 0)),
    CONSTRAINT zerver_realm_video_chat_provider_check CHECK ((video_chat_provider >= 0)),
    CONSTRAINT zerver_realm_waiting_period_threshold_check CHECK ((waiting_period_threshold >= 0)),
    CONSTRAINT zerver_realm_wildcard_mention_policy_check CHECK ((wildcard_mention_policy >= 0))
);


ALTER TABLE zulip.zerver_realm OWNER TO zulip;

--
-- Name: zerver_realm_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_realm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_realm_id_seq OWNER TO zulip;

--
-- Name: zerver_realm_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_realm_id_seq OWNED BY zulip.zerver_realm.id;


--
-- Name: zerver_realmdomain; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmdomain (
    id integer NOT NULL,
    domain character varying(80) NOT NULL,
    realm_id integer NOT NULL,
    allow_subdomains boolean NOT NULL
);


ALTER TABLE zulip.zerver_realmdomain OWNER TO zulip;

--
-- Name: zerver_realmalias_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_realmalias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_realmalias_id_seq OWNER TO zulip;

--
-- Name: zerver_realmalias_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_realmalias_id_seq OWNED BY zulip.zerver_realmdomain.id;


--
-- Name: zerver_realmauditlog; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmauditlog (
    id integer NOT NULL,
    backfilled boolean NOT NULL,
    event_time timestamp with time zone NOT NULL,
    acting_user_id integer,
    modified_stream_id integer,
    modified_user_id integer,
    realm_id integer NOT NULL,
    extra_data text,
    event_last_message_id integer,
    event_type smallint NOT NULL,
    CONSTRAINT zerver_realmauditlog_event_type_bd8f3978_check CHECK ((event_type >= 0))
);


ALTER TABLE zulip.zerver_realmauditlog OWNER TO zulip;

--
-- Name: zerver_realmauditlog_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_realmauditlog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_realmauditlog_id_seq OWNER TO zulip;

--
-- Name: zerver_realmauditlog_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_realmauditlog_id_seq OWNED BY zulip.zerver_realmauditlog.id;


--
-- Name: zerver_realmauthenticationmethod; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmauthenticationmethod (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_realmauthenticationmethod OWNER TO zulip;

--
-- Name: zerver_realmauthenticationmethod_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmauthenticationmethod ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmauthenticationmethod_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_realmemoji; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmemoji (
    id integer NOT NULL,
    name text NOT NULL,
    realm_id integer NOT NULL,
    author_id integer,
    file_name text,
    deactivated boolean NOT NULL,
    is_animated boolean NOT NULL
);


ALTER TABLE zulip.zerver_realmemoji OWNER TO zulip;

--
-- Name: zerver_realmemoji_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_realmemoji_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_realmemoji_id_seq OWNER TO zulip;

--
-- Name: zerver_realmemoji_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_realmemoji_id_seq OWNED BY zulip.zerver_realmemoji.id;


--
-- Name: zerver_realmfilter; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmfilter (
    id integer NOT NULL,
    pattern text NOT NULL,
    realm_id integer NOT NULL,
    url_template text NOT NULL
);


ALTER TABLE zulip.zerver_realmfilter OWNER TO zulip;

--
-- Name: zerver_realmfilter_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_realmfilter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_realmfilter_id_seq OWNER TO zulip;

--
-- Name: zerver_realmfilter_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_realmfilter_id_seq OWNED BY zulip.zerver_realmfilter.id;


--
-- Name: zerver_realmplayground; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmplayground (
    id integer NOT NULL,
    url_prefix text NOT NULL,
    name text NOT NULL,
    pygments_language character varying(40) NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_realmplayground OWNER TO zulip;

--
-- Name: zerver_realmplayground_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_realmplayground_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_realmplayground_id_seq OWNER TO zulip;

--
-- Name: zerver_realmplayground_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_realmplayground_id_seq OWNED BY zulip.zerver_realmplayground.id;


--
-- Name: zerver_realmreactivationstatus; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmreactivationstatus (
    id integer NOT NULL,
    status integer NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_realmreactivationstatus OWNER TO zulip;

--
-- Name: zerver_realmreactivationstatus_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmreactivationstatus ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmreactivationstatus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_realmuserdefault; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmuserdefault (
    id integer NOT NULL,
    enter_sends boolean NOT NULL,
    left_side_userlist boolean NOT NULL,
    default_language character varying(50) NOT NULL,
    default_view text NOT NULL,
    dense_mode boolean NOT NULL,
    fluid_layout_width boolean NOT NULL,
    high_contrast_mode boolean NOT NULL,
    translate_emoticons boolean NOT NULL,
    twenty_four_hour_time boolean NOT NULL,
    starred_message_counts boolean NOT NULL,
    color_scheme smallint NOT NULL,
    demote_inactive_streams smallint NOT NULL,
    emojiset character varying(20) NOT NULL,
    enable_stream_desktop_notifications boolean NOT NULL,
    enable_stream_email_notifications boolean NOT NULL,
    enable_stream_push_notifications boolean NOT NULL,
    enable_stream_audible_notifications boolean NOT NULL,
    notification_sound character varying(20) NOT NULL,
    wildcard_mentions_notify boolean NOT NULL,
    enable_desktop_notifications boolean NOT NULL,
    pm_content_in_desktop_notifications boolean NOT NULL,
    enable_sounds boolean NOT NULL,
    enable_offline_email_notifications boolean NOT NULL,
    message_content_in_email_notifications boolean NOT NULL,
    enable_offline_push_notifications boolean NOT NULL,
    enable_online_push_notifications boolean NOT NULL,
    desktop_icon_count_display smallint NOT NULL,
    enable_digest_emails boolean NOT NULL,
    enable_login_emails boolean NOT NULL,
    enable_marketing_emails boolean NOT NULL,
    presence_enabled boolean NOT NULL,
    realm_id integer NOT NULL,
    email_notifications_batching_period_seconds integer NOT NULL,
    enable_drafts_synchronization boolean NOT NULL,
    send_private_typing_notifications boolean NOT NULL,
    send_stream_typing_notifications boolean NOT NULL,
    send_read_receipts boolean NOT NULL,
    escape_navigates_to_default_view boolean NOT NULL,
    display_emoji_reaction_users boolean NOT NULL,
    user_list_style smallint NOT NULL,
    email_address_visibility smallint NOT NULL,
    realm_name_in_email_notifications_policy smallint NOT NULL,
    web_mark_read_on_scroll_policy smallint NOT NULL,
    CONSTRAINT zerver_realmuserdefault_color_scheme_check CHECK ((color_scheme >= 0)),
    CONSTRAINT zerver_realmuserdefault_demote_inactive_streams_check CHECK ((demote_inactive_streams >= 0)),
    CONSTRAINT zerver_realmuserdefault_desktop_icon_count_display_check CHECK ((desktop_icon_count_display >= 0)),
    CONSTRAINT zerver_realmuserdefault_email_address_visibility_check CHECK ((email_address_visibility >= 0)),
    CONSTRAINT zerver_realmuserdefault_realm_name_in_email_notifications_check CHECK ((realm_name_in_email_notifications_policy >= 0)),
    CONSTRAINT zerver_realmuserdefault_user_list_style_check CHECK ((user_list_style >= 0))
);


ALTER TABLE zulip.zerver_realmuserdefault OWNER TO zulip;

--
-- Name: zerver_realmuserdefault_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_realmuserdefault_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_realmuserdefault_id_seq OWNER TO zulip;

--
-- Name: zerver_realmuserdefault_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_realmuserdefault_id_seq OWNED BY zulip.zerver_realmuserdefault.id;


--
-- Name: zerver_recipient; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_recipient (
    id integer NOT NULL,
    type_id integer NOT NULL,
    type smallint NOT NULL,
    CONSTRAINT zerver_recipient_type_check CHECK ((type >= 0))
);


ALTER TABLE zulip.zerver_recipient OWNER TO zulip;

--
-- Name: zerver_recipient_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_recipient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_recipient_id_seq OWNER TO zulip;

--
-- Name: zerver_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_recipient_id_seq OWNED BY zulip.zerver_recipient.id;


--
-- Name: zerver_scheduledemail; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_scheduledemail (
    id integer NOT NULL,
    scheduled_timestamp timestamp with time zone NOT NULL,
    data text NOT NULL,
    address character varying(254),
    type smallint NOT NULL,
    realm_id integer NOT NULL,
    CONSTRAINT zerver_scheduledemail_type_check CHECK ((type >= 0))
);


ALTER TABLE zulip.zerver_scheduledemail OWNER TO zulip;

--
-- Name: zerver_scheduledemail_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_scheduledemail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_scheduledemail_id_seq OWNER TO zulip;

--
-- Name: zerver_scheduledemail_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_scheduledemail_id_seq OWNED BY zulip.zerver_scheduledemail.id;


--
-- Name: zerver_scheduledemail_users; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_scheduledemail_users (
    id integer NOT NULL,
    scheduledemail_id integer NOT NULL,
    userprofile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_scheduledemail_users OWNER TO zulip;

--
-- Name: zerver_scheduledemail_users_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_scheduledemail_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_scheduledemail_users_id_seq OWNER TO zulip;

--
-- Name: zerver_scheduledemail_users_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_scheduledemail_users_id_seq OWNED BY zulip.zerver_scheduledemail_users.id;


--
-- Name: zerver_scheduledmessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_scheduledmessage (
    id integer NOT NULL,
    subject character varying(60) NOT NULL,
    content text NOT NULL,
    scheduled_timestamp timestamp with time zone NOT NULL,
    delivered boolean NOT NULL,
    realm_id integer NOT NULL,
    recipient_id integer NOT NULL,
    sender_id integer NOT NULL,
    sending_client_id integer NOT NULL,
    stream_id integer,
    delivery_type smallint NOT NULL,
    rendered_content text NOT NULL,
    has_attachment boolean NOT NULL,
    failed boolean NOT NULL,
    failure_message text,
    delivered_message_id integer,
    CONSTRAINT zerver_scheduledmessage_delivery_type_check CHECK ((delivery_type >= 0))
);


ALTER TABLE zulip.zerver_scheduledmessage OWNER TO zulip;

--
-- Name: zerver_scheduledmessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_scheduledmessage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_scheduledmessage_id_seq OWNER TO zulip;

--
-- Name: zerver_scheduledmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_scheduledmessage_id_seq OWNED BY zulip.zerver_scheduledmessage.id;


--
-- Name: zerver_scheduledmessagenotificationemail; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_scheduledmessagenotificationemail (
    id integer NOT NULL,
    trigger text NOT NULL,
    scheduled_timestamp timestamp with time zone NOT NULL,
    mentioned_user_group_id integer,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_scheduledmessagenotificationemail OWNER TO zulip;

--
-- Name: zerver_scheduledmessagenotificationemail_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_scheduledmessagenotificationemail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_scheduledmessagenotificationemail_id_seq OWNER TO zulip;

--
-- Name: zerver_scheduledmessagenotificationemail_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_scheduledmessagenotificationemail_id_seq OWNED BY zulip.zerver_scheduledmessagenotificationemail.id;


--
-- Name: zerver_service; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_service (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    base_url text NOT NULL,
    token text NOT NULL,
    interface smallint NOT NULL,
    user_profile_id integer NOT NULL,
    CONSTRAINT zerver_service_interface_check CHECK ((interface >= 0))
);


ALTER TABLE zulip.zerver_service OWNER TO zulip;

--
-- Name: zerver_service_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_service_id_seq OWNER TO zulip;

--
-- Name: zerver_service_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_service_id_seq OWNED BY zulip.zerver_service.id;


--
-- Name: zerver_stream; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_stream (
    id integer NOT NULL,
    name character varying(60) NOT NULL,
    invite_only boolean NOT NULL,
    email_token character varying(32) NOT NULL,
    description character varying(1024) NOT NULL,
    date_created timestamp with time zone NOT NULL,
    deactivated boolean NOT NULL,
    realm_id integer NOT NULL,
    is_in_zephyr_realm boolean NOT NULL,
    history_public_to_subscribers boolean NOT NULL,
    is_web_public boolean NOT NULL,
    rendered_description text NOT NULL,
    first_message_id integer,
    message_retention_days integer,
    recipient_id integer,
    stream_post_policy smallint NOT NULL,
    can_remove_subscribers_group_id integer NOT NULL,
    CONSTRAINT zerver_stream_stream_post_policy_check CHECK ((stream_post_policy >= 0))
);


ALTER TABLE zulip.zerver_stream OWNER TO zulip;

--
-- Name: zerver_stream_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_stream_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_stream_id_seq OWNER TO zulip;

--
-- Name: zerver_stream_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_stream_id_seq OWNED BY zulip.zerver_stream.id;


--
-- Name: zerver_submessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_submessage (
    id integer NOT NULL,
    msg_type text NOT NULL,
    content text NOT NULL,
    message_id integer NOT NULL,
    sender_id integer NOT NULL
);


ALTER TABLE zulip.zerver_submessage OWNER TO zulip;

--
-- Name: zerver_submessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_submessage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_submessage_id_seq OWNER TO zulip;

--
-- Name: zerver_submessage_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_submessage_id_seq OWNED BY zulip.zerver_submessage.id;


--
-- Name: zerver_subscription; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_subscription (
    id integer NOT NULL,
    active boolean NOT NULL,
    color character varying(10) NOT NULL,
    desktop_notifications boolean,
    audible_notifications boolean,
    recipient_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    pin_to_top boolean NOT NULL,
    push_notifications boolean,
    email_notifications boolean,
    is_muted boolean NOT NULL,
    wildcard_mentions_notify boolean,
    is_user_active boolean NOT NULL
);


ALTER TABLE zulip.zerver_subscription OWNER TO zulip;

--
-- Name: zerver_subscription_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_subscription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_subscription_id_seq OWNER TO zulip;

--
-- Name: zerver_subscription_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_subscription_id_seq OWNED BY zulip.zerver_subscription.id;


--
-- Name: zerver_useractivity; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_useractivity (
    id integer NOT NULL,
    query character varying(50) NOT NULL,
    count integer NOT NULL,
    last_visit timestamp with time zone NOT NULL,
    client_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_useractivity OWNER TO zulip;

--
-- Name: zerver_useractivity_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_useractivity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_useractivity_id_seq OWNER TO zulip;

--
-- Name: zerver_useractivity_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_useractivity_id_seq OWNED BY zulip.zerver_useractivity.id;


--
-- Name: zerver_useractivityinterval; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_useractivityinterval (
    id integer NOT NULL,
    start timestamp with time zone NOT NULL,
    "end" timestamp with time zone NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_useractivityinterval OWNER TO zulip;

--
-- Name: zerver_useractivityinterval_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_useractivityinterval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_useractivityinterval_id_seq OWNER TO zulip;

--
-- Name: zerver_useractivityinterval_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_useractivityinterval_id_seq OWNED BY zulip.zerver_useractivityinterval.id;


--
-- Name: zerver_usergroup; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usergroup (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    realm_id integer NOT NULL,
    description text NOT NULL,
    is_system_group boolean NOT NULL
);


ALTER TABLE zulip.zerver_usergroup OWNER TO zulip;

--
-- Name: zerver_usergroup_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_usergroup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_usergroup_id_seq OWNER TO zulip;

--
-- Name: zerver_usergroup_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_usergroup_id_seq OWNED BY zulip.zerver_usergroup.id;


--
-- Name: zerver_usergroupmembership; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usergroupmembership (
    id integer NOT NULL,
    user_group_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_usergroupmembership OWNER TO zulip;

--
-- Name: zerver_usergroupmembership_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_usergroupmembership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_usergroupmembership_id_seq OWNER TO zulip;

--
-- Name: zerver_usergroupmembership_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_usergroupmembership_id_seq OWNED BY zulip.zerver_usergroupmembership.id;


--
-- Name: zerver_userhotspot; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userhotspot (
    id integer NOT NULL,
    hotspot character varying(30) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE zulip.zerver_userhotspot OWNER TO zulip;

--
-- Name: zerver_userhotspot_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_userhotspot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_userhotspot_id_seq OWNER TO zulip;

--
-- Name: zerver_userhotspot_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_userhotspot_id_seq OWNED BY zulip.zerver_userhotspot.id;


--
-- Name: zerver_usermessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_usermessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_usermessage_id_seq OWNER TO zulip;

--
-- Name: zerver_usermessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usermessage (
    flags bigint NOT NULL,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    id bigint DEFAULT nextval('zulip.zerver_usermessage_id_seq'::regclass) NOT NULL
);


ALTER TABLE zulip.zerver_usermessage OWNER TO zulip;

--
-- Name: zerver_userpresence; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userpresence (
    id integer NOT NULL,
    last_connected_time timestamp with time zone,
    last_active_time timestamp with time zone,
    realm_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_userpresence OWNER TO zulip;

--
-- Name: zerver_userpresence_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_userpresence ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_userpresence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_userprofile; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userprofile (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    is_bot boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    is_mirror_dummy boolean NOT NULL,
    full_name character varying(100) NOT NULL,
    api_key character varying(32) NOT NULL,
    enable_stream_desktop_notifications boolean NOT NULL,
    enable_stream_audible_notifications boolean NOT NULL,
    enable_desktop_notifications boolean NOT NULL,
    enable_sounds boolean NOT NULL,
    enable_offline_email_notifications boolean NOT NULL,
    enable_offline_push_notifications boolean NOT NULL,
    enable_digest_emails boolean NOT NULL,
    last_reminder timestamp with time zone,
    rate_limits character varying(100) NOT NULL,
    default_all_public_streams boolean NOT NULL,
    enter_sends boolean NOT NULL,
    twenty_four_hour_time boolean NOT NULL,
    avatar_source character varying(1) NOT NULL,
    tutorial_status character varying(1) NOT NULL,
    onboarding_steps text NOT NULL,
    bot_owner_id integer,
    default_events_register_stream_id integer,
    default_sending_stream_id integer,
    realm_id integer NOT NULL,
    left_side_userlist boolean NOT NULL,
    can_forge_sender boolean NOT NULL,
    bot_type smallint,
    default_language character varying(50) NOT NULL,
    tos_version character varying(10),
    enable_online_push_notifications boolean NOT NULL,
    pm_content_in_desktop_notifications boolean NOT NULL,
    avatar_version smallint NOT NULL,
    timezone character varying(40) NOT NULL,
    emojiset character varying(20) NOT NULL,
    last_active_message_id integer,
    long_term_idle boolean NOT NULL,
    high_contrast_mode boolean NOT NULL,
    enable_stream_push_notifications boolean NOT NULL,
    enable_stream_email_notifications boolean NOT NULL,
    translate_emoticons boolean NOT NULL,
    message_content_in_email_notifications boolean NOT NULL,
    dense_mode boolean NOT NULL,
    delivery_email character varying(254) NOT NULL,
    starred_message_counts boolean NOT NULL,
    is_billing_admin boolean NOT NULL,
    enable_login_emails boolean NOT NULL,
    notification_sound character varying(20) NOT NULL,
    fluid_layout_width boolean NOT NULL,
    demote_inactive_streams smallint NOT NULL,
    avatar_hash character varying(64),
    desktop_icon_count_display smallint NOT NULL,
    role smallint NOT NULL,
    wildcard_mentions_notify boolean NOT NULL,
    recipient_id integer,
    presence_enabled boolean NOT NULL,
    zoom_token jsonb,
    color_scheme smallint NOT NULL,
    can_create_users boolean NOT NULL,
    default_view text NOT NULL,
    enable_marketing_emails boolean NOT NULL,
    email_notifications_batching_period_seconds integer NOT NULL,
    enable_drafts_synchronization boolean NOT NULL,
    send_private_typing_notifications boolean NOT NULL,
    send_stream_typing_notifications boolean NOT NULL,
    send_read_receipts boolean NOT NULL,
    escape_navigates_to_default_view boolean NOT NULL,
    uuid uuid NOT NULL,
    display_emoji_reaction_users boolean NOT NULL,
    user_list_style smallint NOT NULL,
    email_address_visibility smallint NOT NULL,
    realm_name_in_email_notifications_policy smallint NOT NULL,
    web_mark_read_on_scroll_policy smallint NOT NULL,
    CONSTRAINT zerver_userprofile_avatar_version_check CHECK ((avatar_version >= 0)),
    CONSTRAINT zerver_userprofile_bot_type_check CHECK ((bot_type >= 0)),
    CONSTRAINT zerver_userprofile_color_scheme_check CHECK ((color_scheme >= 0)),
    CONSTRAINT zerver_userprofile_demote_inactive_streams_check CHECK ((demote_inactive_streams >= 0)),
    CONSTRAINT zerver_userprofile_desktop_icon_count_display_check CHECK ((desktop_icon_count_display >= 0)),
    CONSTRAINT zerver_userprofile_email_address_visibility_check CHECK ((email_address_visibility >= 0)),
    CONSTRAINT zerver_userprofile_realm_name_in_email_notifications_poli_check CHECK ((realm_name_in_email_notifications_policy >= 0)),
    CONSTRAINT zerver_userprofile_role_check CHECK ((role >= 0)),
    CONSTRAINT zerver_userprofile_user_list_style_check CHECK ((user_list_style >= 0))
);


ALTER TABLE zulip.zerver_userprofile OWNER TO zulip;

--
-- Name: zerver_userprofile_groups; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userprofile_groups (
    id integer NOT NULL,
    userprofile_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE zulip.zerver_userprofile_groups OWNER TO zulip;

--
-- Name: zerver_userprofile_groups_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_userprofile_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_userprofile_groups_id_seq OWNER TO zulip;

--
-- Name: zerver_userprofile_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_userprofile_groups_id_seq OWNED BY zulip.zerver_userprofile_groups.id;


--
-- Name: zerver_userprofile_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_userprofile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_userprofile_id_seq OWNER TO zulip;

--
-- Name: zerver_userprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_userprofile_id_seq OWNED BY zulip.zerver_userprofile.id;


--
-- Name: zerver_userprofile_user_permissions; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userprofile_user_permissions (
    id integer NOT NULL,
    userprofile_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE zulip.zerver_userprofile_user_permissions OWNER TO zulip;

--
-- Name: zerver_userprofile_user_permissions_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_userprofile_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_userprofile_user_permissions_id_seq OWNER TO zulip;

--
-- Name: zerver_userprofile_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_userprofile_user_permissions_id_seq OWNED BY zulip.zerver_userprofile_user_permissions.id;


--
-- Name: zerver_userstatus; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userstatus (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    client_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    status_text character varying(255) NOT NULL,
    emoji_code text NOT NULL,
    emoji_name text NOT NULL,
    reaction_type character varying(30) NOT NULL
);


ALTER TABLE zulip.zerver_userstatus OWNER TO zulip;

--
-- Name: zerver_userstatus_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_userstatus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_userstatus_id_seq OWNER TO zulip;

--
-- Name: zerver_userstatus_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_userstatus_id_seq OWNED BY zulip.zerver_userstatus.id;


--
-- Name: analytics_fillstate id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_fillstate ALTER COLUMN id SET DEFAULT nextval('zulip.analytics_fillstate_id_seq'::regclass);


--
-- Name: analytics_installationcount id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_installationcount ALTER COLUMN id SET DEFAULT nextval('zulip.analytics_installationcount_id_seq'::regclass);


--
-- Name: analytics_realmcount id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_realmcount ALTER COLUMN id SET DEFAULT nextval('zulip.analytics_realmcount_id_seq'::regclass);


--
-- Name: analytics_streamcount id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_streamcount ALTER COLUMN id SET DEFAULT nextval('zulip.analytics_streamcount_id_seq'::regclass);


--
-- Name: analytics_usercount id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_usercount ALTER COLUMN id SET DEFAULT nextval('zulip.analytics_usercount_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_group ALTER COLUMN id SET DEFAULT nextval('zulip.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('zulip.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_permission ALTER COLUMN id SET DEFAULT nextval('zulip.auth_permission_id_seq'::regclass);


--
-- Name: confirmation_confirmation id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.confirmation_confirmation ALTER COLUMN id SET DEFAULT nextval('zulip.confirmation_confirmation_id_seq'::regclass);


--
-- Name: confirmation_realmcreationkey id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.confirmation_realmcreationkey ALTER COLUMN id SET DEFAULT nextval('zulip.confirmation_realmcreationkey_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.django_content_type ALTER COLUMN id SET DEFAULT nextval('zulip.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.django_migrations ALTER COLUMN id SET DEFAULT nextval('zulip.django_migrations_id_seq'::regclass);


--
-- Name: fts_update_log id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.fts_update_log ALTER COLUMN id SET DEFAULT nextval('zulip.fts_update_log_id_seq'::regclass);


--
-- Name: otp_static_staticdevice id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_static_staticdevice ALTER COLUMN id SET DEFAULT nextval('zulip.otp_static_staticdevice_id_seq'::regclass);


--
-- Name: otp_static_statictoken id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_static_statictoken ALTER COLUMN id SET DEFAULT nextval('zulip.otp_static_statictoken_id_seq'::regclass);


--
-- Name: otp_totp_totpdevice id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_totp_totpdevice ALTER COLUMN id SET DEFAULT nextval('zulip.otp_totp_totpdevice_id_seq'::regclass);


--
-- Name: social_auth_association id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_association ALTER COLUMN id SET DEFAULT nextval('zulip.social_auth_association_id_seq'::regclass);


--
-- Name: social_auth_code id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_code ALTER COLUMN id SET DEFAULT nextval('zulip.social_auth_code_id_seq'::regclass);


--
-- Name: social_auth_nonce id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_nonce ALTER COLUMN id SET DEFAULT nextval('zulip.social_auth_nonce_id_seq'::regclass);


--
-- Name: social_auth_partial id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_partial ALTER COLUMN id SET DEFAULT nextval('zulip.social_auth_partial_id_seq'::regclass);


--
-- Name: social_auth_usersocialauth id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_usersocialauth ALTER COLUMN id SET DEFAULT nextval('zulip.social_auth_usersocialauth_id_seq'::regclass);


--
-- Name: two_factor_phonedevice id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.two_factor_phonedevice ALTER COLUMN id SET DEFAULT nextval('zulip.two_factor_phonedevice_id_seq'::regclass);


--
-- Name: zerver_alertword id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_alertword ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_alertword_id_seq'::regclass);


--
-- Name: zerver_archivedattachment id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_archivedattachment_id_seq'::regclass);


--
-- Name: zerver_archivedattachment_messages id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment_messages ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_archivedattachment_messages_id_seq'::regclass);


--
-- Name: zerver_archivedmessage id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedmessage ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_archivedmessage_id_seq'::regclass);


--
-- Name: zerver_archivedreaction id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedreaction ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_archivedreaction_id_seq'::regclass);


--
-- Name: zerver_archivedsubmessage id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedsubmessage ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_archivedsubmessage_id_seq'::regclass);


--
-- Name: zerver_archivedusermessage id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedusermessage ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_archivedusermessage_id_seq'::regclass);


--
-- Name: zerver_archivetransaction id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivetransaction ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_archivetransaction_id_seq'::regclass);


--
-- Name: zerver_attachment id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_attachment_id_seq'::regclass);


--
-- Name: zerver_attachment_messages id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_messages ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_attachment_messages_id_seq'::regclass);


--
-- Name: zerver_botconfigdata id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botconfigdata ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_botuserconfigdata_id_seq'::regclass);


--
-- Name: zerver_botstoragedata id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botstoragedata ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_botuserstatedata_id_seq'::regclass);


--
-- Name: zerver_client id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_client ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_client_id_seq'::regclass);


--
-- Name: zerver_customprofilefield id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefield ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_customprofilefield_id_seq'::regclass);


--
-- Name: zerver_customprofilefieldvalue id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefieldvalue ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_customprofilefieldvalue_id_seq'::regclass);


--
-- Name: zerver_defaultstream id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstream ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_defaultstream_id_seq'::regclass);


--
-- Name: zerver_defaultstreamgroup id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_defaultstreamgroup_id_seq'::regclass);


--
-- Name: zerver_defaultstreamgroup_streams id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup_streams ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_defaultstreamgroup_streams_id_seq'::regclass);


--
-- Name: zerver_draft id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_draft ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_draft_id_seq'::regclass);


--
-- Name: zerver_emailchangestatus id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_emailchangestatus ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_emailchangestatus_id_seq'::regclass);


--
-- Name: zerver_groupgroupmembership id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_groupgroupmembership ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_groupgroupmembership_id_seq'::regclass);


--
-- Name: zerver_huddle id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_huddle ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_huddle_id_seq'::regclass);


--
-- Name: zerver_message id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_message ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_message_id_seq'::regclass);


--
-- Name: zerver_missedmessageemailaddress id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_missedmessageemailaddress ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_missedmessageemailaddress_id_seq'::regclass);


--
-- Name: zerver_multiuseinvite id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_multiuseinvite_id_seq'::regclass);


--
-- Name: zerver_multiuseinvite_streams id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_streams ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_multiuseinvite_streams_id_seq'::regclass);


--
-- Name: zerver_muteduser id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_muteduser ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_muteduser_id_seq'::regclass);


--
-- Name: zerver_preregistrationuser id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_preregistrationuser_id_seq'::regclass);


--
-- Name: zerver_preregistrationuser_streams id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_preregistrationuser_streams_id_seq'::regclass);


--
-- Name: zerver_pushdevicetoken id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_pushdevicetoken ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_pushdevicetoken_id_seq'::regclass);


--
-- Name: zerver_reaction id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_reaction ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_reaction_id_seq'::regclass);


--
-- Name: zerver_realm id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_realm_id_seq'::regclass);


--
-- Name: zerver_realmauditlog id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_realmauditlog_id_seq'::regclass);


--
-- Name: zerver_realmdomain id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmdomain ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_realmalias_id_seq'::regclass);


--
-- Name: zerver_realmemoji id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmemoji ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_realmemoji_id_seq'::regclass);


--
-- Name: zerver_realmfilter id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmfilter ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_realmfilter_id_seq'::regclass);


--
-- Name: zerver_realmplayground id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmplayground ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_realmplayground_id_seq'::regclass);


--
-- Name: zerver_realmuserdefault id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmuserdefault ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_realmuserdefault_id_seq'::regclass);


--
-- Name: zerver_recipient id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_recipient ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_recipient_id_seq'::regclass);


--
-- Name: zerver_scheduledemail id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_scheduledemail_id_seq'::regclass);


--
-- Name: zerver_scheduledemail_users id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail_users ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_scheduledemail_users_id_seq'::regclass);


--
-- Name: zerver_scheduledmessage id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_scheduledmessage_id_seq'::regclass);


--
-- Name: zerver_scheduledmessagenotificationemail id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessagenotificationemail ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_scheduledmessagenotificationemail_id_seq'::regclass);


--
-- Name: zerver_service id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_service ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_service_id_seq'::regclass);


--
-- Name: zerver_stream id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_stream_id_seq'::regclass);


--
-- Name: zerver_submessage id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_submessage ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_submessage_id_seq'::regclass);


--
-- Name: zerver_subscription id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_subscription ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_subscription_id_seq'::regclass);


--
-- Name: zerver_useractivity id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_useractivity ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_useractivity_id_seq'::regclass);


--
-- Name: zerver_useractivityinterval id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_useractivityinterval ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_useractivityinterval_id_seq'::regclass);


--
-- Name: zerver_usergroup id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroup ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_usergroup_id_seq'::regclass);


--
-- Name: zerver_usergroupmembership id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroupmembership ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_usergroupmembership_id_seq'::regclass);


--
-- Name: zerver_userhotspot id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userhotspot ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_userhotspot_id_seq'::regclass);


--
-- Name: zerver_userprofile id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_userprofile_id_seq'::regclass);


--
-- Name: zerver_userprofile_groups id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_groups ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_userprofile_groups_id_seq'::regclass);


--
-- Name: zerver_userprofile_user_permissions id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_user_permissions ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_userprofile_user_permissions_id_seq'::regclass);


--
-- Name: zerver_userstatus id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userstatus ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_userstatus_id_seq'::regclass);


--
-- Name: zerver_usertopic id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_mutedtopic_id_seq'::regclass);


--
-- Data for Name: analytics_fillstate; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.analytics_fillstate (id, property, end_time, state) FROM stdin;
\.


--
-- Data for Name: analytics_installationcount; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.analytics_installationcount (id, property, end_time, value, subgroup) FROM stdin;
\.


--
-- Data for Name: analytics_realmcount; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.analytics_realmcount (id, realm_id, property, end_time, value, subgroup) FROM stdin;
1	2	active_users_log:is_bot:day	2022-04-24 00:00:00+00	1	False
\.


--
-- Data for Name: analytics_streamcount; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.analytics_streamcount (id, realm_id, stream_id, property, end_time, value, subgroup) FROM stdin;
\.


--
-- Data for Name: analytics_usercount; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.analytics_usercount (id, realm_id, user_id, property, end_time, value, subgroup) FROM stdin;
1	2	8	messages_read::hour	2022-04-23 09:00:00+00	1	\N
2	2	8	messages_read_interactions::hour	2022-04-23 09:00:00+00	1	\N
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can view permission	1	view_permission
5	Can add group	2	add_group
6	Can change group	2	change_group
7	Can delete group	2	delete_group
8	Can view group	2	view_group
9	Can add content type	3	add_contenttype
10	Can change content type	3	change_contenttype
11	Can delete content type	3	delete_contenttype
12	Can view content type	3	view_contenttype
13	Can add session	4	add_session
14	Can change session	4	change_session
15	Can delete session	4	delete_session
16	Can view session	4	view_session
17	Can add confirmation	5	add_confirmation
18	Can change confirmation	5	change_confirmation
19	Can delete confirmation	5	delete_confirmation
20	Can view confirmation	5	view_confirmation
21	Can add realm creation key	6	add_realmcreationkey
22	Can change realm creation key	6	change_realmcreationkey
23	Can delete realm creation key	6	delete_realmcreationkey
24	Can view realm creation key	6	view_realmcreationkey
25	Can add user profile	7	add_userprofile
26	Can change user profile	7	change_userprofile
27	Can delete user profile	7	delete_userprofile
28	Can view user profile	7	view_userprofile
29	Can add client	8	add_client
30	Can change client	8	change_client
31	Can delete client	8	delete_client
32	Can view client	8	view_client
33	Can add default stream	9	add_defaultstream
34	Can change default stream	9	change_defaultstream
35	Can delete default stream	9	delete_defaultstream
36	Can view default stream	9	view_defaultstream
37	Can add huddle	10	add_huddle
38	Can change huddle	10	change_huddle
39	Can delete huddle	10	delete_huddle
40	Can view huddle	10	view_huddle
41	Can add message	11	add_message
42	Can change message	11	change_message
43	Can delete message	11	delete_message
44	Can view message	11	view_message
45	Can add preregistration user	12	add_preregistrationuser
46	Can change preregistration user	12	change_preregistrationuser
47	Can delete preregistration user	12	delete_preregistrationuser
48	Can view preregistration user	12	view_preregistrationuser
49	Can add push device token	13	add_pushdevicetoken
50	Can change push device token	13	change_pushdevicetoken
51	Can delete push device token	13	delete_pushdevicetoken
52	Can view push device token	13	view_pushdevicetoken
53	Can add realm	14	add_realm
54	Can change realm	14	change_realm
55	Can delete realm	14	delete_realm
56	Can view realm	14	view_realm
57	Can add realm emoji	15	add_realmemoji
58	Can change realm emoji	15	change_realmemoji
59	Can delete realm emoji	15	delete_realmemoji
60	Can view realm emoji	15	view_realmemoji
61	Can add realm filter	16	add_realmfilter
62	Can change realm filter	16	change_realmfilter
63	Can delete realm filter	16	delete_realmfilter
64	Can view realm filter	16	view_realmfilter
65	Can add recipient	17	add_recipient
66	Can change recipient	17	change_recipient
67	Can delete recipient	17	delete_recipient
68	Can view recipient	17	view_recipient
69	Can add stream	18	add_stream
70	Can change stream	18	change_stream
71	Can delete stream	18	delete_stream
72	Can view stream	18	view_stream
73	Can add subscription	19	add_subscription
74	Can change subscription	19	change_subscription
75	Can delete subscription	19	delete_subscription
76	Can view subscription	19	view_subscription
77	Can add user activity	20	add_useractivity
78	Can change user activity	20	change_useractivity
79	Can delete user activity	20	delete_useractivity
80	Can view user activity	20	view_useractivity
81	Can add user activity interval	21	add_useractivityinterval
82	Can change user activity interval	21	change_useractivityinterval
83	Can delete user activity interval	21	delete_useractivityinterval
84	Can view user activity interval	21	view_useractivityinterval
85	Can add user message	22	add_usermessage
86	Can change user message	22	change_usermessage
87	Can delete user message	22	delete_usermessage
88	Can view user message	22	view_usermessage
89	Can add user presence	23	add_userpresence
90	Can change user presence	23	change_userpresence
91	Can delete user presence	23	delete_userpresence
92	Can view user presence	23	view_userpresence
93	Can add attachment	24	add_attachment
94	Can change attachment	24	change_attachment
95	Can delete attachment	24	delete_attachment
96	Can view attachment	24	view_attachment
97	Can add reaction	25	add_reaction
98	Can change reaction	25	change_reaction
99	Can delete reaction	25	delete_reaction
100	Can view reaction	25	view_reaction
101	Can add email change status	26	add_emailchangestatus
102	Can change email change status	26	change_emailchangestatus
103	Can delete email change status	26	delete_emailchangestatus
104	Can view email change status	26	view_emailchangestatus
105	Can add realm audit log	27	add_realmauditlog
106	Can change realm audit log	27	change_realmauditlog
107	Can delete realm audit log	27	delete_realmauditlog
108	Can view realm audit log	27	view_realmauditlog
109	Can add archived attachment	28	add_archivedattachment
110	Can change archived attachment	28	change_archivedattachment
111	Can delete archived attachment	28	delete_archivedattachment
112	Can view archived attachment	28	view_archivedattachment
113	Can add archived message	29	add_archivedmessage
114	Can change archived message	29	change_archivedmessage
115	Can delete archived message	29	delete_archivedmessage
116	Can view archived message	29	view_archivedmessage
117	Can add archived user message	30	add_archivedusermessage
118	Can change archived user message	30	change_archivedusermessage
119	Can delete archived user message	30	delete_archivedusermessage
120	Can view archived user message	30	view_archivedusermessage
121	Can add user hotspot	31	add_userhotspot
122	Can change user hotspot	31	change_userhotspot
123	Can delete user hotspot	31	delete_userhotspot
124	Can view user hotspot	31	view_userhotspot
125	Can add realm domain	32	add_realmdomain
126	Can change realm domain	32	change_realmdomain
127	Can delete realm domain	32	delete_realmdomain
128	Can view realm domain	32	view_realmdomain
129	Can add custom profile field	33	add_customprofilefield
130	Can change custom profile field	33	change_customprofilefield
131	Can delete custom profile field	33	delete_customprofilefield
132	Can view custom profile field	33	view_customprofilefield
133	Can add custom profile field value	34	add_customprofilefieldvalue
134	Can change custom profile field value	34	change_customprofilefieldvalue
135	Can delete custom profile field value	34	delete_customprofilefieldvalue
136	Can view custom profile field value	34	view_customprofilefieldvalue
137	Can add service	35	add_service
138	Can change service	35	change_service
139	Can delete service	35	delete_service
140	Can view service	35	view_service
141	Can add scheduled email	36	add_scheduledemail
142	Can change scheduled email	36	change_scheduledemail
143	Can delete scheduled email	36	delete_scheduledemail
144	Can view scheduled email	36	view_scheduledemail
145	Can add multiuse invite	37	add_multiuseinvite
146	Can change multiuse invite	37	change_multiuseinvite
147	Can delete multiuse invite	37	delete_multiuseinvite
148	Can view multiuse invite	37	view_multiuseinvite
149	Can add default stream group	38	add_defaultstreamgroup
150	Can change default stream group	38	change_defaultstreamgroup
151	Can delete default stream group	38	delete_defaultstreamgroup
152	Can view default stream group	38	view_defaultstreamgroup
153	Can add user group	39	add_usergroup
154	Can change user group	39	change_usergroup
155	Can delete user group	39	delete_usergroup
156	Can view user group	39	view_usergroup
157	Can add user group membership	40	add_usergroupmembership
158	Can change user group membership	40	change_usergroupmembership
159	Can delete user group membership	40	delete_usergroupmembership
160	Can view user group membership	40	view_usergroupmembership
161	Can add bot storage data	41	add_botstoragedata
162	Can change bot storage data	41	change_botstoragedata
163	Can delete bot storage data	41	delete_botstoragedata
164	Can view bot storage data	41	view_botstoragedata
165	Can add bot config data	42	add_botconfigdata
166	Can change bot config data	42	change_botconfigdata
167	Can delete bot config data	42	delete_botconfigdata
168	Can view bot config data	42	view_botconfigdata
169	Can add scheduled message	43	add_scheduledmessage
170	Can change scheduled message	43	change_scheduledmessage
171	Can delete scheduled message	43	delete_scheduledmessage
172	Can view scheduled message	43	view_scheduledmessage
173	Can add sub message	44	add_submessage
174	Can change sub message	44	change_submessage
175	Can delete sub message	44	delete_submessage
176	Can view sub message	44	view_submessage
177	Can add user status	45	add_userstatus
178	Can change user status	45	change_userstatus
179	Can delete user status	45	delete_userstatus
180	Can view user status	45	view_userstatus
181	Can add archived reaction	46	add_archivedreaction
182	Can change archived reaction	46	change_archivedreaction
183	Can delete archived reaction	46	delete_archivedreaction
184	Can view archived reaction	46	view_archivedreaction
185	Can add archived sub message	47	add_archivedsubmessage
186	Can change archived sub message	47	change_archivedsubmessage
187	Can delete archived sub message	47	delete_archivedsubmessage
188	Can view archived sub message	47	view_archivedsubmessage
189	Can add archive transaction	48	add_archivetransaction
190	Can change archive transaction	48	change_archivetransaction
191	Can delete archive transaction	48	delete_archivetransaction
192	Can view archive transaction	48	view_archivetransaction
193	Can add missed message email address	49	add_missedmessageemailaddress
194	Can change missed message email address	49	change_missedmessageemailaddress
195	Can delete missed message email address	49	delete_missedmessageemailaddress
196	Can view missed message email address	49	view_missedmessageemailaddress
197	Can add alert word	50	add_alertword
198	Can change alert word	50	change_alertword
199	Can delete alert word	50	delete_alertword
200	Can view alert word	50	view_alertword
201	Can add draft	51	add_draft
202	Can change draft	51	change_draft
203	Can delete draft	51	delete_draft
204	Can view draft	51	view_draft
205	Can add muted user	52	add_muteduser
206	Can change muted user	52	change_muteduser
207	Can delete muted user	52	delete_muteduser
208	Can view muted user	52	view_muteduser
209	Can add realm playground	53	add_realmplayground
210	Can change realm playground	53	change_realmplayground
211	Can delete realm playground	53	delete_realmplayground
212	Can view realm playground	53	view_realmplayground
213	Can add scheduled message notification email	54	add_scheduledmessagenotificationemail
214	Can change scheduled message notification email	54	change_scheduledmessagenotificationemail
215	Can delete scheduled message notification email	54	delete_scheduledmessagenotificationemail
216	Can view scheduled message notification email	54	view_scheduledmessagenotificationemail
217	Can add realm user default	55	add_realmuserdefault
218	Can change realm user default	55	change_realmuserdefault
219	Can delete realm user default	55	delete_realmuserdefault
220	Can view realm user default	55	view_realmuserdefault
221	Can add user topic	56	add_usertopic
222	Can change user topic	56	change_usertopic
223	Can delete user topic	56	delete_usertopic
224	Can view user topic	56	view_usertopic
225	Can add group group membership	57	add_groupgroupmembership
226	Can change group group membership	57	change_groupgroupmembership
227	Can delete group group membership	57	delete_groupgroupmembership
228	Can view group group membership	57	view_groupgroupmembership
229	Can add scim client	58	add_scimclient
230	Can change scim client	58	change_scimclient
231	Can delete scim client	58	delete_scimclient
232	Can view scim client	58	view_scimclient
233	Can add association	59	add_association
234	Can change association	59	change_association
235	Can delete association	59	delete_association
236	Can view association	59	view_association
237	Can add code	60	add_code
238	Can change code	60	change_code
239	Can delete code	60	delete_code
240	Can view code	60	view_code
241	Can add nonce	61	add_nonce
242	Can change nonce	61	change_nonce
243	Can delete nonce	61	delete_nonce
244	Can view nonce	61	view_nonce
245	Can add user social auth	62	add_usersocialauth
246	Can change user social auth	62	change_usersocialauth
247	Can delete user social auth	62	delete_usersocialauth
248	Can view user social auth	62	view_usersocialauth
249	Can add partial	63	add_partial
250	Can change partial	63	change_partial
251	Can delete partial	63	delete_partial
252	Can view partial	63	view_partial
253	Can add static device	64	add_staticdevice
254	Can change static device	64	change_staticdevice
255	Can delete static device	64	delete_staticdevice
256	Can view static device	64	view_staticdevice
257	Can add static token	65	add_statictoken
258	Can change static token	65	change_statictoken
259	Can delete static token	65	delete_statictoken
260	Can view static token	65	view_statictoken
261	Can add TOTP device	66	add_totpdevice
262	Can change TOTP device	66	change_totpdevice
263	Can delete TOTP device	66	delete_totpdevice
264	Can view TOTP device	66	view_totpdevice
265	Can add phone device	67	add_phonedevice
266	Can change phone device	67	change_phonedevice
267	Can delete phone device	67	delete_phonedevice
268	Can view phone device	67	view_phonedevice
269	Can add installation count	68	add_installationcount
270	Can change installation count	68	change_installationcount
271	Can delete installation count	68	delete_installationcount
272	Can view installation count	68	view_installationcount
273	Can add realm count	69	add_realmcount
274	Can change realm count	69	change_realmcount
275	Can delete realm count	69	delete_realmcount
276	Can view realm count	69	view_realmcount
277	Can add stream count	70	add_streamcount
278	Can change stream count	70	change_streamcount
279	Can delete stream count	70	delete_streamcount
280	Can view stream count	70	view_streamcount
281	Can add user count	71	add_usercount
282	Can change user count	71	change_usercount
283	Can delete user count	71	delete_usercount
284	Can view user count	71	view_usercount
285	Can add fill state	72	add_fillstate
286	Can change fill state	72	change_fillstate
287	Can delete fill state	72	delete_fillstate
288	Can view fill state	72	view_fillstate
289	Can add realm reactivation status	73	add_realmreactivationstatus
290	Can change realm reactivation status	73	change_realmreactivationstatus
291	Can delete realm reactivation status	73	delete_realmreactivationstatus
292	Can view realm reactivation status	73	view_realmreactivationstatus
293	Can add preregistration realm	74	add_preregistrationrealm
294	Can change preregistration realm	74	change_preregistrationrealm
295	Can delete preregistration realm	74	delete_preregistrationrealm
296	Can view preregistration realm	74	view_preregistrationrealm
297	Can add realm authentication method	75	add_realmauthenticationmethod
298	Can change realm authentication method	75	change_realmauthenticationmethod
299	Can delete realm authentication method	75	delete_realmauthenticationmethod
300	Can view realm authentication method	75	view_realmauthenticationmethod
301	Can add phone device	76	add_phonedevice
302	Can change phone device	76	change_phonedevice
303	Can delete phone device	76	delete_phonedevice
304	Can view phone device	76	view_phonedevice
\.


--
-- Data for Name: confirmation_confirmation; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.confirmation_confirmation (id, object_id, date_sent, confirmation_key, content_type_id, type, realm_id, expiry_date) FROM stdin;
1	1	2022-04-23 08:50:40.197722+00	lyzxxh4m7jh64dzod7vpi4dh	12	7	\N	2022-04-24 08:50:40.197722+00
2	8	2022-04-23 08:50:55.265124+00	5rzmtckx3ggc52j6e5c5o232	7	4	2	4760-03-20 08:50:55.265124+00
\.


--
-- Data for Name: confirmation_realmcreationkey; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.confirmation_realmcreationkey (id, creation_key, date_created, presume_email_valid) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_content_type (id, app_label, model) FROM stdin;
1	auth	permission
2	auth	group
3	contenttypes	contenttype
4	sessions	session
5	confirmation	confirmation
6	confirmation	realmcreationkey
7	zerver	userprofile
8	zerver	client
9	zerver	defaultstream
10	zerver	huddle
11	zerver	message
12	zerver	preregistrationuser
13	zerver	pushdevicetoken
14	zerver	realm
15	zerver	realmemoji
16	zerver	realmfilter
17	zerver	recipient
18	zerver	stream
19	zerver	subscription
20	zerver	useractivity
21	zerver	useractivityinterval
22	zerver	usermessage
23	zerver	userpresence
24	zerver	attachment
25	zerver	reaction
26	zerver	emailchangestatus
27	zerver	realmauditlog
28	zerver	archivedattachment
29	zerver	archivedmessage
30	zerver	archivedusermessage
31	zerver	userhotspot
32	zerver	realmdomain
33	zerver	customprofilefield
34	zerver	customprofilefieldvalue
35	zerver	service
36	zerver	scheduledemail
37	zerver	multiuseinvite
38	zerver	defaultstreamgroup
39	zerver	usergroup
40	zerver	usergroupmembership
41	zerver	botstoragedata
42	zerver	botconfigdata
43	zerver	scheduledmessage
44	zerver	submessage
45	zerver	userstatus
46	zerver	archivedreaction
47	zerver	archivedsubmessage
48	zerver	archivetransaction
49	zerver	missedmessageemailaddress
50	zerver	alertword
51	zerver	draft
52	zerver	muteduser
53	zerver	realmplayground
54	zerver	scheduledmessagenotificationemail
55	zerver	realmuserdefault
56	zerver	usertopic
57	zerver	groupgroupmembership
58	zerver	scimclient
59	social_django	association
60	social_django	code
61	social_django	nonce
62	social_django	usersocialauth
63	social_django	partial
64	otp_static	staticdevice
65	otp_static	statictoken
66	otp_totp	totpdevice
67	two_factor	phonedevice
68	analytics	installationcount
69	analytics	realmcount
70	analytics	streamcount
71	analytics	usercount
72	analytics	fillstate
73	zerver	realmreactivationstatus
74	zerver	preregistrationrealm
75	zerver	realmauthenticationmethod
76	phonenumber	phonedevice
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2022-04-23 08:49:05.875385+00
2	auth	0001_initial	2022-04-23 08:49:05.964763+00
3	zerver	0001_initial	2022-04-23 08:49:07.660394+00
4	zerver	0029_realm_subdomain	2022-04-23 08:49:07.711932+00
5	zerver	0030_realm_org_type	2022-04-23 08:49:07.751215+00
6	zerver	0031_remove_system_avatar_source	2022-04-23 08:49:07.801125+00
7	zerver	0032_verify_all_medium_avatar_images	2022-04-23 08:49:07.836548+00
8	zerver	0033_migrate_domain_to_realmalias	2022-04-23 08:49:07.889044+00
9	zerver	0034_userprofile_enable_online_push_notifications	2022-04-23 08:49:08.008293+00
10	zerver	0035_realm_message_retention_period_days	2022-04-23 08:49:08.055983+00
11	zerver	0036_rename_subdomain_to_string_id	2022-04-23 08:49:08.109711+00
12	zerver	0037_disallow_null_string_id	2022-04-23 08:49:08.20461+00
13	zerver	0038_realm_change_to_community_defaults	2022-04-23 08:49:08.289382+00
14	zerver	0039_realmalias_drop_uniqueness	2022-04-23 08:49:08.340489+00
15	zerver	0040_realm_authentication_methods	2022-04-23 08:49:08.400731+00
16	zerver	0041_create_attachments_for_old_messages	2022-04-23 08:49:08.496266+00
17	zerver	0042_attachment_file_name_length	2022-04-23 08:49:08.542861+00
18	zerver	0043_realm_filter_validators	2022-04-23 08:49:09.203142+00
19	zerver	0044_reaction	2022-04-23 08:49:09.308432+00
20	zerver	0045_realm_waiting_period_threshold	2022-04-23 08:49:09.351883+00
21	zerver	0046_realmemoji_author	2022-04-23 08:49:09.409408+00
22	zerver	0047_realm_add_emoji_by_admins_only	2022-04-23 08:49:09.469574+00
23	zerver	0048_enter_sends_default_to_false	2022-04-23 08:49:09.521878+00
24	zerver	0049_userprofile_pm_content_in_desktop_notifications	2022-04-23 08:49:09.643586+00
25	zerver	0050_userprofile_avatar_version	2022-04-23 08:49:09.744018+00
26	analytics	0001_initial	2022-04-23 08:49:10.232292+00
27	analytics	0002_remove_huddlecount	2022-04-23 08:49:10.361795+00
28	analytics	0003_fillstate	2022-04-23 08:49:10.382309+00
29	analytics	0004_add_subgroup	2022-04-23 08:49:10.591541+00
30	analytics	0005_alter_field_size	2022-04-23 08:49:10.853519+00
31	analytics	0006_add_subgroup_to_unique_constraints	2022-04-23 08:49:10.962437+00
32	analytics	0007_remove_interval	2022-04-23 08:49:11.1048+00
33	analytics	0008_add_count_indexes	2022-04-23 08:49:11.178832+00
34	analytics	0009_remove_messages_to_stream_stat	2022-04-23 08:49:11.221615+00
35	analytics	0010_clear_messages_sent_values	2022-04-23 08:49:11.261406+00
36	analytics	0011_clear_analytics_tables	2022-04-23 08:49:11.413395+00
37	analytics	0012_add_on_delete	2022-04-23 08:49:11.526933+00
38	analytics	0013_remove_anomaly	2022-04-23 08:49:11.642528+00
39	analytics	0014_remove_fillstate_last_modified	2022-04-23 08:49:11.648734+00
40	analytics	0015_clear_duplicate_counts	2022-04-23 08:49:11.688268+00
41	analytics	0016_unique_constraint_when_subgroup_null	2022-04-23 08:49:11.944176+00
42	contenttypes	0002_remove_content_type_name	2022-04-23 08:49:12.014792+00
43	auth	0002_alter_permission_name_max_length	2022-04-23 08:49:12.068711+00
44	auth	0003_alter_user_email_max_length	2022-04-23 08:49:12.092364+00
45	auth	0004_alter_user_username_opts	2022-04-23 08:49:12.122844+00
46	auth	0005_alter_user_last_login_null	2022-04-23 08:49:12.155937+00
47	auth	0006_require_contenttypes_0002	2022-04-23 08:49:12.161503+00
48	auth	0007_alter_validators_add_error_messages	2022-04-23 08:49:12.195422+00
49	auth	0008_alter_user_username_max_length	2022-04-23 08:49:12.223434+00
50	auth	0009_alter_user_last_name_max_length	2022-04-23 08:49:12.247289+00
51	auth	0010_alter_group_name_max_length	2022-04-23 08:49:12.307742+00
52	auth	0011_update_proxy_permissions	2022-04-23 08:49:12.807748+00
53	auth	0012_alter_user_first_name_max_length	2022-04-23 08:49:12.821265+00
54	zerver	0051_realmalias_add_allow_subdomains	2022-04-23 08:49:12.897907+00
55	zerver	0052_auto_fix_realmalias_realm_nullable	2022-04-23 08:49:12.95736+00
56	zerver	0053_emailchangestatus	2022-04-23 08:49:13.035347+00
57	zerver	0054_realm_icon	2022-04-23 08:49:13.153454+00
58	zerver	0055_attachment_size	2022-04-23 08:49:13.213572+00
59	zerver	0056_userprofile_emoji_alt_code	2022-04-23 08:49:13.332286+00
60	zerver	0057_realmauditlog	2022-04-23 08:49:13.501242+00
61	zerver	0058_realm_email_changes_disabled	2022-04-23 08:49:13.565295+00
62	zerver	0059_userprofile_quota	2022-04-23 08:49:13.651258+00
63	zerver	0060_move_avatars_to_be_uid_based	2022-04-23 08:49:13.655572+00
64	zerver	0061_userprofile_timezone	2022-04-23 08:49:13.733766+00
65	zerver	0062_default_timezone	2022-04-23 08:49:13.797844+00
66	zerver	0063_realm_description	2022-04-23 08:49:13.847491+00
67	zerver	0064_sync_uploads_filesize_with_db	2022-04-23 08:49:13.853315+00
68	zerver	0065_realm_inline_image_preview	2022-04-23 08:49:13.927255+00
69	zerver	0066_realm_inline_url_embed_preview	2022-04-23 08:49:14.012396+00
70	zerver	0067_archived_models	2022-04-23 08:49:15.161201+00
71	zerver	0068_remove_realm_domain	2022-04-23 08:49:15.197286+00
72	zerver	0069_realmauditlog_extra_data	2022-04-23 08:49:15.260612+00
73	zerver	0070_userhotspot	2022-04-23 08:49:15.390937+00
74	zerver	0071_rename_realmalias_to_realmdomain	2022-04-23 08:49:15.498341+00
75	zerver	0072_realmauditlog_add_index_event_time	2022-04-23 08:49:15.601502+00
76	zerver	0073_custom_profile_fields	2022-04-23 08:49:15.905825+00
77	zerver	0074_fix_duplicate_attachments	2022-04-23 08:49:15.991703+00
78	zerver	0075_attachment_path_id_unique	2022-04-23 08:49:16.173592+00
79	zerver	0076_userprofile_emojiset	2022-04-23 08:49:16.443494+00
80	zerver	0077_add_file_name_field_to_realm_emoji	2022-04-23 08:49:16.587514+00
81	zerver	0078_service	2022-04-23 08:49:16.667519+00
82	zerver	0079_remove_old_scheduled_jobs	2022-04-23 08:49:16.713669+00
83	zerver	0080_realm_description_length	2022-04-23 08:49:16.742047+00
84	zerver	0081_make_emoji_lowercase	2022-04-23 08:49:16.849985+00
85	zerver	0082_index_starred_user_messages	2022-04-23 08:49:16.924284+00
86	zerver	0083_index_mentioned_user_messages	2022-04-23 08:49:16.9876+00
87	zerver	0084_realmemoji_deactivated	2022-04-23 08:49:17.074565+00
88	zerver	0085_fix_bots_with_none_bot_type	2022-04-23 08:49:17.127326+00
89	zerver	0086_realm_alter_default_org_type	2022-04-23 08:49:17.15616+00
90	zerver	0087_remove_old_scheduled_jobs	2022-04-23 08:49:17.215496+00
91	zerver	0088_remove_referral_and_invites	2022-04-23 08:49:17.866631+00
92	zerver	0089_auto_20170710_1353	2022-04-23 08:49:17.981993+00
93	zerver	0090_userprofile_high_contrast_mode	2022-04-23 08:49:18.064155+00
94	zerver	0091_realm_allow_edit_history	2022-04-23 08:49:18.158395+00
95	zerver	0092_create_scheduledemail	2022-04-23 08:49:18.270516+00
96	zerver	0093_subscription_event_log_backfill	2022-04-23 08:49:18.384957+00
97	zerver	0094_realm_filter_url_validator	2022-04-23 08:49:18.414373+00
98	zerver	0095_index_unread_user_messages	2022-04-23 08:49:18.468665+00
99	zerver	0096_add_password_required	2022-04-23 08:49:18.522819+00
100	zerver	0097_reactions_emoji_code	2022-04-23 08:49:18.736127+00
101	zerver	0098_index_has_alert_word_user_messages	2022-04-23 08:49:18.815434+00
102	zerver	0099_index_wildcard_mentioned_user_messages	2022-04-23 08:49:18.883351+00
103	zerver	0100_usermessage_remove_is_me_message	2022-04-23 08:49:19.222074+00
104	zerver	0101_muted_topic	2022-04-23 08:49:19.411497+00
105	zerver	0102_convert_muted_topic	2022-04-23 08:49:19.50301+00
106	zerver	0103_remove_userprofile_muted_topics	2022-04-23 08:49:19.586407+00
107	zerver	0104_fix_unreads	2022-04-23 08:49:19.6595+00
108	zerver	0105_userprofile_enable_stream_push_notifications	2022-04-23 08:49:19.770912+00
109	zerver	0106_subscription_push_notifications	2022-04-23 08:49:19.856765+00
110	zerver	0107_multiuseinvite	2022-04-23 08:49:20.01832+00
111	zerver	0108_fix_default_string_id	2022-04-23 08:49:20.09868+00
112	zerver	0109_mark_tutorial_status_finished	2022-04-23 08:49:20.189124+00
113	zerver	0110_stream_is_in_zephyr_realm	2022-04-23 08:49:20.369579+00
114	zerver	0111_botuserstatedata	2022-04-23 08:49:20.56416+00
115	zerver	0112_index_muted_topics	2022-04-23 08:49:21.222342+00
116	zerver	0113_default_stream_group	2022-04-23 08:49:21.322562+00
117	zerver	0114_preregistrationuser_invited_as_admin	2022-04-23 08:49:21.376417+00
118	zerver	0115_user_groups	2022-04-23 08:49:21.576443+00
119	zerver	0116_realm_allow_message_deleting	2022-04-23 08:49:21.622315+00
120	zerver	0117_add_desc_to_user_group	2022-04-23 08:49:21.67961+00
121	zerver	0118_defaultstreamgroup_description	2022-04-23 08:49:21.725442+00
122	zerver	0119_userprofile_night_mode	2022-04-23 08:49:21.836316+00
123	zerver	0120_botuserconfigdata	2022-04-23 08:49:22.644638+00
124	zerver	0121_realm_signup_notifications_stream	2022-04-23 08:49:22.770799+00
125	zerver	0122_rename_botuserstatedata_botstoragedata	2022-04-23 08:49:22.852298+00
126	zerver	0123_userprofile_make_realm_email_pair_unique	2022-04-23 08:49:22.996397+00
127	zerver	0124_stream_enable_notifications	2022-04-23 08:49:23.212148+00
128	confirmation	0001_initial	2022-04-23 08:49:23.323412+00
129	confirmation	0002_realmcreationkey	2022-04-23 08:49:23.341577+00
130	confirmation	0003_emailchangeconfirmation	2022-04-23 08:49:23.353803+00
131	confirmation	0004_remove_confirmationmanager	2022-04-23 08:49:23.420155+00
132	confirmation	0005_confirmation_realm	2022-04-23 08:49:23.535205+00
133	confirmation	0006_realmcreationkey_presume_email_valid	2022-04-23 08:49:23.560842+00
134	confirmation	0007_add_indexes	2022-04-23 08:49:24.15086+00
135	confirmation	0008_confirmation_expiry_date	2022-04-23 08:49:24.213399+00
136	confirmation	0009_confirmation_expiry_date_backfill	2022-04-23 08:49:24.301262+00
137	confirmation	0010_alter_confirmation_expiry_date	2022-04-23 08:49:24.353482+00
138	confirmation	0011_alter_confirmation_expiry_date	2022-04-23 08:49:24.416109+00
139	otp_static	0001_initial	2022-04-23 08:49:24.652705+00
140	otp_static	0002_throttling	2022-04-23 08:49:24.830187+00
141	otp_totp	0001_initial	2022-04-23 08:49:24.962627+00
142	otp_totp	0002_auto_20190420_0723	2022-04-23 08:49:25.117131+00
143	sessions	0001_initial	2022-04-23 08:49:25.148427+00
144	default	0001_initial	2022-04-23 08:49:26.030406+00
145	social_auth	0001_initial	2022-04-23 08:49:26.034858+00
146	default	0002_add_related_name	2022-04-23 08:49:26.133669+00
147	social_auth	0002_add_related_name	2022-04-23 08:49:26.137415+00
148	default	0003_alter_email_max_length	2022-04-23 08:49:26.158526+00
149	social_auth	0003_alter_email_max_length	2022-04-23 08:49:26.162922+00
150	default	0004_auto_20160423_0400	2022-04-23 08:49:26.243909+00
151	social_auth	0004_auto_20160423_0400	2022-04-23 08:49:26.248195+00
152	social_auth	0005_auto_20160727_2333	2022-04-23 08:49:26.268298+00
153	social_django	0006_partial	2022-04-23 08:49:26.307188+00
154	social_django	0007_code_timestamp	2022-04-23 08:49:26.3461+00
155	social_django	0008_partial_timestamp	2022-04-23 08:49:26.384714+00
156	social_django	0009_auto_20191118_0520	2022-04-23 08:49:26.569175+00
157	social_django	0010_uid_db_index	2022-04-23 08:49:26.665563+00
158	two_factor	0001_initial	2022-04-23 08:49:26.779471+00
159	two_factor	0002_auto_20150110_0810	2022-04-23 08:49:26.866085+00
160	two_factor	0003_auto_20150817_1733	2022-04-23 08:49:27.029979+00
161	two_factor	0004_auto_20160205_1827	2022-04-23 08:49:27.11787+00
162	two_factor	0005_auto_20160224_0450	2022-04-23 08:49:27.952698+00
163	two_factor	0006_phonedevice_key_default	2022-04-23 08:49:28.008459+00
164	two_factor	0007_auto_20201201_1019	2022-04-23 08:49:28.113385+00
165	zerver	0125_realm_max_invites	2022-04-23 08:49:28.168766+00
166	zerver	0126_prereg_remove_users_without_realm	2022-04-23 08:49:28.226518+00
167	zerver	0127_disallow_chars_in_stream_and_user_name	2022-04-23 08:49:28.228964+00
168	zerver	0128_scheduledemail_realm	2022-04-23 08:49:28.389957+00
169	zerver	0129_remove_userprofile_autoscroll_forever	2022-04-23 08:49:28.487596+00
170	zerver	0130_text_choice_in_emojiset	2022-04-23 08:49:29.134691+00
171	zerver	0131_realm_create_generic_bot_by_admins_only	2022-04-23 08:49:29.213858+00
172	zerver	0132_realm_message_visibility_limit	2022-04-23 08:49:29.261904+00
173	zerver	0133_rename_botuserconfigdata_botconfigdata	2022-04-23 08:49:29.36721+00
174	zerver	0134_scheduledmessage	2022-04-23 08:49:29.459119+00
175	zerver	0135_scheduledmessage_delivery_type	2022-04-23 08:49:29.548496+00
176	zerver	0136_remove_userprofile_quota	2022-04-23 08:49:29.601346+00
177	zerver	0137_realm_upload_quota_gb	2022-04-23 08:49:29.639572+00
178	zerver	0138_userprofile_realm_name_in_notifications	2022-04-23 08:49:29.726322+00
179	zerver	0139_fill_last_message_id_in_subscription_logs	2022-04-23 08:49:29.912522+00
180	zerver	0140_realm_send_welcome_emails	2022-04-23 08:49:29.970078+00
181	zerver	0141_change_usergroup_description_to_textfield	2022-04-23 08:49:30.035538+00
182	zerver	0142_userprofile_translate_emoticons	2022-04-23 08:49:30.126014+00
183	zerver	0143_realm_bot_creation_policy	2022-04-23 08:49:30.314382+00
184	zerver	0144_remove_realm_create_generic_bot_by_admins_only	2022-04-23 08:49:30.381137+00
185	zerver	0145_reactions_realm_emoji_name_to_id	2022-04-23 08:49:30.484309+00
186	zerver	0146_userprofile_message_content_in_email_notifications	2022-04-23 08:49:30.614169+00
187	zerver	0147_realm_disallow_disposable_email_addresses	2022-04-23 08:49:30.666961+00
188	zerver	0148_max_invites_forget_default	2022-04-23 08:49:30.765283+00
189	zerver	0149_realm_emoji_drop_unique_constraint	2022-04-23 08:49:31.202057+00
190	zerver	0150_realm_allow_community_topic_editing	2022-04-23 08:49:31.258122+00
191	zerver	0151_last_reminder_default_none	2022-04-23 08:49:31.320369+00
192	zerver	0152_realm_default_twenty_four_hour_time	2022-04-23 08:49:31.380374+00
193	zerver	0153_remove_int_float_custom_fields	2022-04-23 08:49:31.458037+00
194	zerver	0154_fix_invalid_bot_owner	2022-04-23 08:49:31.570241+00
195	zerver	0155_change_default_realm_description	2022-04-23 08:49:31.639816+00
196	zerver	0156_add_hint_to_profile_field	2022-04-23 08:49:31.707319+00
197	zerver	0157_userprofile_is_guest	2022-04-23 08:49:31.814672+00
198	zerver	0158_realm_video_chat_provider	2022-04-23 08:49:31.876404+00
199	zerver	0159_realm_google_hangouts_domain	2022-04-23 08:49:31.957813+00
200	zerver	0160_add_choice_field	2022-04-23 08:49:32.314066+00
201	zerver	0161_realm_message_content_delete_limit_seconds	2022-04-23 08:49:32.378273+00
202	zerver	0162_change_default_community_topic_editing	2022-04-23 08:49:32.432214+00
203	zerver	0163_remove_userprofile_default_desktop_notifications	2022-04-23 08:49:32.485591+00
204	zerver	0164_stream_history_public_to_subscribers	2022-04-23 08:49:32.585629+00
205	zerver	0165_add_date_to_profile_field	2022-04-23 08:49:32.623583+00
206	zerver	0166_add_url_to_profile_field	2022-04-23 08:49:32.665627+00
207	zerver	0167_custom_profile_fields_sort_order	2022-04-23 08:49:32.759549+00
208	zerver	0168_stream_is_web_public	2022-04-23 08:49:32.81007+00
209	zerver	0169_stream_is_announcement_only	2022-04-23 08:49:32.865483+00
210	zerver	0170_submessage	2022-04-23 08:49:32.938969+00
211	zerver	0171_userprofile_dense_mode	2022-04-23 08:49:33.056744+00
212	zerver	0172_add_user_type_of_custom_profile_field	2022-04-23 08:49:33.232948+00
213	zerver	0173_support_seat_based_plans	2022-04-23 08:49:33.372527+00
214	zerver	0174_userprofile_delivery_email	2022-04-23 08:49:33.521157+00
215	zerver	0175_change_realm_audit_log_event_type_tense	2022-04-23 08:49:33.57476+00
216	zerver	0176_remove_subscription_notifications	2022-04-23 08:49:33.62117+00
217	zerver	0177_user_message_add_and_index_is_private_flag	2022-04-23 08:49:33.777515+00
218	zerver	0178_rename_to_emails_restricted_to_domains	2022-04-23 08:49:33.810283+00
219	zerver	0179_rename_to_digest_emails_enabled	2022-04-23 08:49:33.990089+00
220	zerver	0180_usermessage_add_active_mobile_push_notification	2022-04-23 08:49:34.109125+00
221	zerver	0181_userprofile_change_emojiset	2022-04-23 08:49:34.202096+00
222	zerver	0182_set_initial_value_is_private_flag	2022-04-23 08:49:34.254887+00
223	zerver	0183_change_custom_field_name_max_length	2022-04-23 08:49:34.303372+00
224	zerver	0184_rename_custom_field_types	2022-04-23 08:49:34.336625+00
225	zerver	0185_realm_plan_type	2022-04-23 08:49:34.392815+00
226	zerver	0186_userprofile_starred_message_counts	2022-04-23 08:49:34.490562+00
227	zerver	0187_userprofile_is_billing_admin	2022-04-23 08:49:34.589674+00
228	zerver	0188_userprofile_enable_login_emails	2022-04-23 08:49:34.830038+00
229	zerver	0189_userprofile_add_some_emojisets	2022-04-23 08:49:34.94495+00
230	zerver	0190_cleanup_pushdevicetoken	2022-04-23 08:49:35.029954+00
231	zerver	0191_realm_seat_limit	2022-04-23 08:49:35.062459+00
232	zerver	0192_customprofilefieldvalue_rendered_value	2022-04-23 08:49:35.110971+00
233	zerver	0193_realm_email_address_visibility	2022-04-23 08:49:35.168292+00
234	zerver	0194_userprofile_notification_sound	2022-04-23 08:49:35.285847+00
235	zerver	0195_realm_first_visible_message_id	2022-04-23 08:49:35.338936+00
236	zerver	0196_add_realm_logo_fields	2022-04-23 08:49:35.439036+00
237	zerver	0197_azure_active_directory_auth	2022-04-23 08:49:35.495525+00
238	zerver	0198_preregistrationuser_invited_as	2022-04-23 08:49:35.722511+00
239	zerver	0199_userstatus	2022-04-23 08:49:35.786527+00
240	zerver	0200_remove_preregistrationuser_invited_as_admin	2022-04-23 08:49:35.835015+00
241	zerver	0201_zoom_video_chat	2022-04-23 08:49:36.000396+00
242	zerver	0202_add_user_status_info	2022-04-23 08:49:36.096564+00
243	zerver	0203_realm_message_content_allowed_in_email_notifications	2022-04-23 08:49:36.148786+00
244	zerver	0204_remove_realm_billing_fields	2022-04-23 08:49:36.213848+00
245	zerver	0205_remove_realmauditlog_requires_billing_update	2022-04-23 08:49:36.263945+00
246	zerver	0206_stream_rendered_description	2022-04-23 08:49:36.515678+00
247	zerver	0207_multiuseinvite_invited_as	2022-04-23 08:49:36.589194+00
248	zerver	0208_add_realm_night_logo_fields	2022-04-23 08:49:36.691363+00
249	zerver	0209_stream_first_message_id	2022-04-23 08:49:36.733441+00
250	zerver	0210_stream_first_message_id	2022-04-23 08:49:36.792488+00
251	zerver	0211_add_users_field_to_scheduled_email	2022-04-23 08:49:36.950292+00
252	zerver	0212_make_stream_email_token_unique	2022-04-23 08:49:37.007405+00
253	zerver	0213_realm_digest_weekday	2022-04-23 08:49:37.189656+00
254	zerver	0214_realm_invite_to_stream_policy	2022-04-23 08:49:37.308308+00
255	zerver	0215_realm_avatar_changes_disabled	2022-04-23 08:49:37.358738+00
256	zerver	0216_add_create_stream_policy	2022-04-23 08:49:37.42109+00
257	zerver	0217_migrate_create_stream_policy	2022-04-23 08:49:37.493649+00
258	zerver	0218_remove_create_stream_by_admins_only	2022-04-23 08:49:37.531092+00
259	zerver	0219_toggle_realm_digest_emails_enabled_default	2022-04-23 08:49:37.615482+00
260	zerver	0220_subscription_notification_settings	2022-04-23 08:49:37.767117+00
261	zerver	0221_subscription_notifications_data_migration	2022-04-23 08:49:38.316172+00
262	zerver	0222_userprofile_fluid_layout_width	2022-04-23 08:49:38.439806+00
263	zerver	0223_rename_to_is_muted	2022-04-23 08:49:38.59067+00
264	zerver	0224_alter_field_realm_video_chat_provider	2022-04-23 08:49:38.768663+00
265	zerver	0225_archived_reaction_model	2022-04-23 08:49:38.888066+00
266	zerver	0226_archived_submessage_model	2022-04-23 08:49:39.092796+00
267	zerver	0227_inline_url_embed_preview_default_off	2022-04-23 08:49:39.175159+00
268	zerver	0228_userprofile_demote_inactive_streams	2022-04-23 08:49:39.271792+00
269	zerver	0229_stream_message_retention_days	2022-04-23 08:49:39.305998+00
270	zerver	0230_rename_to_enable_stream_audible_notifications	2022-04-23 08:49:39.366634+00
271	zerver	0231_add_archive_transaction_model	2022-04-23 08:49:39.779859+00
272	zerver	0232_make_archive_transaction_field_not_nullable	2022-04-23 08:49:39.848156+00
273	zerver	0233_userprofile_avatar_hash	2022-04-23 08:49:39.90435+00
274	zerver	0234_add_external_account_custom_profile_field	2022-04-23 08:49:39.948442+00
275	zerver	0235_userprofile_desktop_icon_count_display	2022-04-23 08:49:40.082211+00
276	zerver	0236_remove_illegal_characters_email_full	2022-04-23 08:49:40.162316+00
277	zerver	0237_rename_zulip_realm_to_zulipinternal	2022-04-23 08:49:40.220213+00
278	zerver	0238_usermessage_bigint_id	2022-04-23 08:49:40.418522+00
279	zerver	0239_usermessage_copy_id_to_bigint_id	2022-04-23 08:49:40.491751+00
280	zerver	0240_usermessage_migrate_bigint_id_into_id	2022-04-23 08:49:40.582554+00
281	zerver	0241_usermessage_bigint_id_migration_finalize	2022-04-23 08:49:40.683177+00
282	zerver	0242_fix_bot_email_property	2022-04-23 08:49:40.76144+00
283	zerver	0243_message_add_date_sent_column	2022-04-23 08:49:40.924201+00
284	zerver	0244_message_copy_pub_date_to_date_sent	2022-04-23 08:49:41.239308+00
285	zerver	0245_message_date_sent_finalize_part1	2022-04-23 08:49:41.301208+00
286	zerver	0246_message_date_sent_finalize_part2	2022-04-23 08:49:41.468538+00
287	zerver	0247_realmauditlog_event_type_to_int	2022-04-23 08:49:42.235663+00
288	zerver	0248_userprofile_role_start	2022-04-23 08:49:42.341038+00
289	zerver	0249_userprofile_role_finish	2022-04-23 08:49:42.546634+00
290	zerver	0250_saml_auth	2022-04-23 08:49:42.618925+00
291	zerver	0251_prereg_user_add_full_name	2022-04-23 08:49:42.817824+00
292	zerver	0252_realm_user_group_edit_policy	2022-04-23 08:49:43.029708+00
293	zerver	0253_userprofile_wildcard_mentions_notify	2022-04-23 08:49:43.171827+00
294	zerver	0209_user_profile_no_empty_password	2022-04-23 08:49:43.252944+00
295	zerver	0254_merge_0209_0253	2022-04-23 08:49:43.259375+00
296	zerver	0255_userprofile_stream_add_recipient_column	2022-04-23 08:49:43.482227+00
297	zerver	0256_userprofile_stream_set_recipient_column_values	2022-04-23 08:49:43.505622+00
298	zerver	0257_fix_has_link_attribute	2022-04-23 08:49:43.615514+00
299	zerver	0258_enable_online_push_notifications_default	2022-04-23 08:49:43.70549+00
300	zerver	0259_missedmessageemailaddress	2022-04-23 08:49:43.823887+00
301	zerver	0260_missed_message_addresses_from_redis_to_db	2022-04-23 08:49:43.88586+00
302	zerver	0261_realm_private_message_policy	2022-04-23 08:49:44.069857+00
303	zerver	0262_mutedtopic_date_muted	2022-04-23 08:49:44.136999+00
304	zerver	0263_stream_stream_post_policy	2022-04-23 08:49:44.201795+00
305	zerver	0264_migrate_is_announcement_only	2022-04-23 08:49:44.263054+00
306	zerver	0265_remove_stream_is_announcement_only	2022-04-23 08:49:44.302955+00
307	zerver	0266_userpresence_realm	2022-04-23 08:49:44.373617+00
308	zerver	0267_backfill_userpresence_realm_id	2022-04-23 08:49:44.378414+00
309	zerver	0268_add_userpresence_realm_timestamp_index	2022-04-23 08:49:44.492234+00
310	zerver	0269_gitlab_auth	2022-04-23 08:49:44.542188+00
311	zerver	0270_huddle_recipient	2022-04-23 08:49:44.609312+00
312	zerver	0271_huddle_set_recipient_column_values	2022-04-23 08:49:44.613626+00
313	zerver	0272_realm_default_code_block_language	2022-04-23 08:49:44.762696+00
314	zerver	0273_migrate_old_bot_messages	2022-04-23 08:49:44.82912+00
315	zerver	0274_nullbooleanfield_to_booleanfield	2022-04-23 08:49:45.14514+00
316	zerver	0275_remove_userprofile_last_pointer_updater	2022-04-23 08:49:45.302631+00
317	zerver	0276_alertword	2022-04-23 08:49:45.383177+00
318	zerver	0277_migrate_alert_word	2022-04-23 08:49:45.458565+00
319	zerver	0278_remove_userprofile_alert_words	2022-04-23 08:49:45.515872+00
320	zerver	0279_message_recipient_subject_indexes	2022-04-23 08:49:45.615026+00
321	zerver	0280_userprofile_presence_enabled	2022-04-23 08:49:45.746931+00
322	zerver	0281_zoom_oauth	2022-04-23 08:49:45.815729+00
323	zerver	0282_remove_zoom_video_chat	2022-04-23 08:49:45.909811+00
324	zerver	0283_apple_auth	2022-04-23 08:49:46.073679+00
325	zerver	0284_convert_realm_admins_to_realm_owners	2022-04-23 08:49:46.138313+00
326	zerver	0285_remove_realm_google_hangouts_domain	2022-04-23 08:49:46.225971+00
327	zerver	0261_pregistrationuser_clear_invited_as_admin	2022-04-23 08:49:46.282454+00
328	zerver	0286_merge_0260_0285	2022-04-23 08:49:46.285126+00
329	zerver	0287_clear_duplicate_reactions	2022-04-23 08:49:46.345376+00
330	zerver	0288_reaction_unique_on_emoji_code	2022-04-23 08:49:46.439237+00
331	zerver	0289_tighten_attachment_size	2022-04-23 08:49:46.644264+00
332	zerver	0290_remove_night_mode_add_color_scheme	2022-04-23 08:49:46.841871+00
333	zerver	0291_realm_retention_days_not_null	2022-04-23 08:49:46.875298+00
334	zerver	0292_update_default_value_of_invited_as	2022-04-23 08:49:46.980184+00
335	zerver	0293_update_invite_as_dict_values	2022-04-23 08:49:47.040758+00
336	zerver	0294_remove_userprofile_pointer	2022-04-23 08:49:47.095292+00
337	zerver	0295_case_insensitive_email_indexes	2022-04-23 08:49:47.171294+00
338	zerver	0296_remove_userprofile_short_name	2022-04-23 08:49:47.224211+00
339	zerver	0297_draft	2022-04-23 08:49:47.454975+00
340	zerver	0298_fix_realmauditlog_format	2022-04-23 08:49:47.530158+00
341	zerver	0299_subscription_role	2022-04-23 08:49:47.593648+00
342	zerver	0300_add_attachment_is_web_public	2022-04-23 08:49:47.772071+00
343	zerver	0301_fix_unread_messages_in_deactivated_streams	2022-04-23 08:49:47.78494+00
344	zerver	0302_case_insensitive_stream_name_index	2022-04-23 08:49:47.837582+00
345	zerver	0303_realm_wildcard_mention_policy	2022-04-23 08:49:47.890381+00
346	zerver	0304_remove_default_status_of_default_private_streams	2022-04-23 08:49:47.951886+00
347	zerver	0305_realm_deactivated_redirect	2022-04-23 08:49:47.986549+00
348	zerver	0306_custom_profile_field_date_format	2022-04-23 08:49:47.993057+00
349	zerver	0307_rename_api_super_user_to_can_forge_sender	2022-04-23 08:49:48.052387+00
350	zerver	0308_remove_reduntant_realm_meta_permissions	2022-04-23 08:49:48.095608+00
351	zerver	0309_userprofile_can_create_users	2022-04-23 08:49:48.363213+00
352	zerver	0310_jsonfield	2022-04-23 08:49:48.366817+00
353	zerver	0311_userprofile_default_view	2022-04-23 08:49:48.469249+00
354	zerver	0312_subscription_is_user_active	2022-04-23 08:49:48.522425+00
355	zerver	0313_finish_is_user_active_migration	2022-04-23 08:49:48.664713+00
356	zerver	0314_muted_user	2022-04-23 08:49:48.736277+00
357	zerver	0315_realmplayground	2022-04-23 08:49:48.863474+00
358	zerver	0316_realm_invite_to_realm_policy	2022-04-23 08:49:48.927227+00
359	zerver	0317_migrate_to_invite_to_realm_policy	2022-04-23 08:49:49.100939+00
360	zerver	0318_remove_realm_invite_by_admins_only	2022-04-23 08:49:49.141981+00
361	zerver	0319_realm_giphy_rating	2022-04-23 08:49:49.208516+00
362	zerver	0320_realm_move_messages_between_streams_policy	2022-04-23 08:49:49.284209+00
363	zerver	0321_userprofile_enable_marketing_emails	2022-04-23 08:49:49.407218+00
364	zerver	0322_realm_create_audit_log_backfill	2022-04-23 08:49:49.486213+00
365	zerver	0323_show_starred_message_counts	2022-04-23 08:49:49.592684+00
366	zerver	0324_fix_deletion_cascade_behavior	2022-04-23 08:49:49.903204+00
367	zerver	0325_alter_realmplayground_unique_together	2022-04-23 08:49:49.950556+00
368	zerver	0359_re2_linkifiers	2022-04-23 08:49:50.016613+00
369	zerver	0326_alter_realm_authentication_methods	2022-04-23 08:49:50.058041+00
370	zerver	0327_realm_edit_topic_policy	2022-04-23 08:49:50.113735+00
371	zerver	0328_migrate_to_edit_topic_policy	2022-04-23 08:49:50.17885+00
372	zerver	0329_remove_realm_allow_community_topic_editing	2022-04-23 08:49:50.219635+00
373	zerver	0330_linkifier_pattern_validator	2022-04-23 08:49:50.258399+00
374	zerver	0331_scheduledmessagenotificationemail	2022-04-23 08:49:50.3787+00
375	zerver	0332_realmuserdefault	2022-04-23 08:49:50.934343+00
376	zerver	0333_alter_realm_org_type	2022-04-23 08:49:51.031983+00
377	zerver	0334_email_notifications_batching_period	2022-04-23 08:49:51.174231+00
378	zerver	0335_add_draft_sync_field	2022-04-23 08:49:51.331266+00
379	zerver	0336_userstatus_status_emoji	2022-04-23 08:49:51.528997+00
380	zerver	0337_realm_add_custom_emoji_policy	2022-04-23 08:49:51.599884+00
381	zerver	0338_migrate_to_add_custom_emoji_policy	2022-04-23 08:49:51.797376+00
382	zerver	0339_remove_realm_add_emoji_by_admins_only	2022-04-23 08:49:51.847104+00
383	zerver	0340_rename_mutedtopic_to_usertopic	2022-04-23 08:49:52.0519+00
384	zerver	0341_usergroup_is_system_group	2022-04-23 08:49:52.125081+00
385	zerver	0342_realm_demo_organization_scheduled_deletion_date	2022-04-23 08:49:52.171609+00
386	zerver	0343_alter_useractivityinterval_index_together	2022-04-23 08:49:52.232237+00
387	zerver	0344_alter_emojiset_default_value	2022-04-23 08:49:52.444784+00
388	zerver	0345_alter_realm_name	2022-04-23 08:49:52.54687+00
389	zerver	0346_create_realm_user_default_table	2022-04-23 08:49:52.612501+00
390	zerver	0347_realm_emoji_animated	2022-04-23 08:49:52.698981+00
391	zerver	0348_rename_date_muted_usertopic_last_updated	2022-04-23 08:49:52.769813+00
392	zerver	0349_alter_usertopic_table	2022-04-23 08:49:52.824661+00
393	zerver	0350_usertopic_visibility_policy	2022-04-23 08:49:52.892279+00
394	zerver	0351_user_topic_visibility_indexes	2022-04-23 08:49:53.026695+00
395	zerver	0352_migrate_twenty_four_hour_time_to_realmuserdefault	2022-04-23 08:49:53.304181+00
396	zerver	0353_remove_realm_default_twenty_four_hour_time	2022-04-23 08:49:53.352983+00
397	zerver	0354_alter_realm_message_content_delete_limit_seconds	2022-04-23 08:49:53.509485+00
398	zerver	0355_realm_delete_own_message_policy	2022-04-23 08:49:53.567748+00
399	zerver	0356_migrate_to_delete_own_message_policy	2022-04-23 08:49:53.63838+00
400	zerver	0357_remove_realm_allow_message_deleting	2022-04-23 08:49:53.679691+00
401	zerver	0358_split_create_stream_policy	2022-04-23 08:49:54.327937+00
402	zerver	0360_merge_0358_0359	2022-04-23 08:49:54.334311+00
403	zerver	0361_realm_create_web_public_stream_policy	2022-04-23 08:49:54.427638+00
404	zerver	0362_send_typing_notifications_user_setting	2022-04-23 08:49:54.898649+00
405	zerver	0363_send_read_receipts_user_setting	2022-04-23 08:49:55.057935+00
406	zerver	0364_rename_members_usergroup_direct_members	2022-04-23 08:49:55.117643+00
407	zerver	0365_alter_user_group_related_fields	2022-04-23 08:49:55.403503+00
408	zerver	0366_group_group_membership	2022-04-23 08:49:55.543727+00
409	zerver	0367_scimclient	2022-04-23 08:49:55.618136+00
410	zerver	0368_alter_realmfilter_url_format_string	2022-04-23 08:49:55.657783+00
411	zerver	0369_add_escnav_default_display_user_setting	2022-04-23 08:49:55.853095+00
412	zerver	0370_realm_enable_spectator_access	2022-04-23 08:49:55.974053+00
413	zerver	0371_invalid_characters_in_topics	2022-04-23 08:49:56.396561+00
414	zerver	0372_realmemoji_unique_realm_emoji_when_false_deactivated	2022-04-23 08:49:56.492538+00
415	zerver	0373_fix_deleteduser_dummies	2022-04-23 08:49:56.585197+00
416	zerver	0374_backfill_user_delete_realmauditlog	2022-04-23 08:49:56.660042+00
417	zerver	0375_invalid_characters_in_stream_names	2022-04-23 08:49:56.726223+00
418	zerver	0376_set_realmemoji_author_and_reupload_realmemoji	2022-04-23 08:49:56.797362+00
419	zerver	0377_message_edit_history_format	2022-04-23 08:49:56.864081+00
420	zerver	0378_alter_realmuserdefault_realm	2022-04-23 08:49:56.945719+00
421	zerver	0379_userprofile_uuid	2022-04-23 08:49:57.163057+00
422	zerver	0380_userprofile_uuid_backfill	2022-04-23 08:49:57.22681+00
423	zerver	0381_alter_userprofile_uuid	2022-04-23 08:49:57.295768+00
424	zerver	0382_create_role_based_system_groups	2022-04-23 08:49:57.35996+00
425	zerver	0383_revoke_invitations_from_deactivated_users	2022-04-23 08:49:57.425643+00
426	zerver	0384_alter_realm_not_null	2022-04-23 08:49:57.548365+00
427	zerver	0385_attachment_flags_cache	2022-04-23 08:49:57.852923+00
428	zerver	0386_fix_attachment_caches	2022-04-23 08:49:57.971896+00
429	zerver	0387_reupload_realmemoji_again	2022-04-23 08:49:58.034642+00
430	social_django	0005_auto_20160727_2333	2022-04-23 08:49:58.041652+00
431	social_django	0004_auto_20160423_0400	2022-04-23 08:49:58.044505+00
432	social_django	0001_initial	2022-04-23 08:49:58.047485+00
433	social_django	0002_add_related_name	2022-04-23 08:49:58.051499+00
434	social_django	0003_alter_email_max_length	2022-04-23 08:49:58.056361+00
435	zerver	0388_preregistrationuser_created_user	2022-12-16 08:52:51.010081+00
436	zerver	0389_userprofile_display_emoji_reaction_users	2022-12-16 08:52:51.069474+00
437	zerver	0390_fix_stream_history_public_to_subscribers	2022-12-16 08:52:51.189947+00
438	zerver	0391_alter_stream_history_public_to_subscribers	2022-12-16 08:52:51.229303+00
439	zerver	0392_non_nullable_fields	2022-12-16 08:52:51.398906+00
440	zerver	0393_realm_want_advertise_in_communities_directory	2022-12-16 08:52:51.42705+00
441	zerver	0394_alter_realm_want_advertise_in_communities_directory	2022-12-16 08:52:51.459809+00
442	zerver	0395_alter_realm_wildcard_mention_policy	2022-12-16 08:52:51.649249+00
443	zerver	0396_remove_subscription_role	2022-12-16 08:52:51.682954+00
444	zerver	0397_remove_custom_field_values_for_deleted_options	2022-12-16 08:52:51.725285+00
445	zerver	0398_tsvector_statistics	2022-12-16 08:52:51.734833+00
446	zerver	0399_preregistrationuser_multiuse_invite	2022-12-16 08:52:51.784105+00
447	zerver	0400_realmreactivationstatus	2022-12-16 08:52:51.841136+00
448	zerver	0401_migrate_old_realm_reactivation_links	2022-12-16 08:52:51.885124+00
449	zerver	0402_alter_usertopic_visibility_policy	2022-12-16 08:52:51.919123+00
450	zerver	0403_create_role_based_groups_for_internal_realms	2022-12-16 08:52:51.968455+00
451	zerver	0404_realm_enable_read_receipts	2022-12-16 08:52:52.109299+00
452	zerver	0405_set_default_for_enable_read_receipts	2022-12-16 08:52:52.151054+00
453	zerver	0406_alter_realm_message_content_edit_limit_seconds	2022-12-16 08:52:52.24003+00
454	zerver	0407_userprofile_user_list_style	2022-12-16 08:52:52.302283+00
455	zerver	0408_stream_can_remove_subscribers_group	2022-12-16 08:52:52.357559+00
456	zerver	0409_set_default_for_can_remove_subscribers_group	2022-12-16 08:52:52.403804+00
457	zerver	0410_alter_stream_can_remove_subscribers_group	2022-12-16 08:52:52.580363+00
458	zerver	0411_alter_muteduser_muted_user_and_more	2022-12-16 08:52:52.652784+00
459	zerver	0412_customprofilefield_display_in_profile_summary	2022-12-16 08:52:52.677828+00
460	zerver	0413_set_presence_enabled_false_for_user_status_away	2022-12-16 08:52:52.71955+00
461	zerver	0414_remove_userstatus_status	2022-12-16 08:52:52.754601+00
462	zerver	0415_delete_scimclient	2022-12-16 08:52:52.762918+00
463	zerver	0416_set_default_emoji_style	2022-12-16 08:52:52.803677+00
464	zerver	0417_alter_customprofilefield_field_type	2022-12-16 08:52:52.827816+00
465	zerver	0418_archivedmessage_realm_message_realm	2022-12-16 08:52:53.022112+00
466	zerver	0419_backfill_message_realm	2022-12-16 08:52:53.080725+00
467	zerver	0420_alter_archivedmessage_realm_alter_message_realm	2022-12-16 08:52:53.165982+00
468	zerver	0421_migrate_pronouns_custom_profile_fields	2022-12-16 08:52:53.206795+00
469	zerver	0422_multiuseinvite_status	2022-12-16 08:52:53.2437+00
470	two_factor	0008_delete_phonedevice	2023-06-09 13:23:00.696734+00
471	phonenumber	0001_initial	2023-06-09 13:23:00.761132+00
472	social_django	0011_alter_id_fields	2023-06-09 13:23:00.903004+00
473	zerver	0423_fix_email_gateway_attachment_owner	2023-06-09 13:23:00.97452+00
474	zerver	0424_realm_move_messages_within_stream_limit_seconds	2023-06-09 13:23:01.010252+00
475	zerver	0425_realm_move_messages_between_streams_limit_seconds	2023-06-09 13:23:01.129346+00
476	zerver	0426_add_email_address_visibility_setting	2023-06-09 13:23:01.217277+00
477	zerver	0427_migrate_to_user_level_email_address_visibility_setting	2023-06-09 13:23:01.277542+00
478	zerver	0428_remove_realm_email_address_visibility	2023-06-09 13:23:01.307848+00
479	zerver	0429_user_topic_case_insensitive_unique_toghether	2023-06-09 13:23:01.392622+00
480	zerver	0430_fix_audit_log_objects_for_group_based_stream_settings	2023-06-09 13:23:01.440558+00
481	zerver	0431_alter_archivedreaction_unique_together_and_more	2023-06-09 13:23:01.518376+00
482	zerver	0432_alter_and_migrate_realm_name_in_notifications	2023-06-09 13:23:01.856089+00
483	zerver	0433_preregistrationrealm	2023-06-09 13:23:01.91606+00
484	zerver	0434_create_nobody_system_group	2023-06-09 13:23:01.966991+00
485	zerver	0435_scheduledmessage_rendered_content	2023-06-09 13:23:02.012274+00
486	zerver	0436_realmauthenticationmethods	2023-06-09 13:23:02.270707+00
487	zerver	0437_remove_realm_authentication_methods	2023-06-09 13:23:02.308274+00
488	zerver	0438_add_web_mark_read_on_scroll_policy_setting	2023-06-09 13:23:02.385539+00
489	zerver	0439_fix_deleteduser_email	2023-06-09 13:23:02.437636+00
490	zerver	0440_realmfilter_url_template	2023-06-09 13:23:02.494878+00
491	zerver	0441_backfill_realmfilter_url_template	2023-06-09 13:23:02.542798+00
492	zerver	0442_remove_realmfilter_url_format_string	2023-06-09 13:23:02.709597+00
493	zerver	0443_userpresence_new_table_schema	2023-06-09 13:23:02.881575+00
494	zerver	0444_userpresence_fill_data	2023-06-09 13:23:02.954052+00
495	zerver	0445_drop_userpresenceold	2023-06-09 13:23:02.962851+00
496	zerver	0446_realmauditlog_zerver_realmauditlog_user_subscriptions_idx	2023-06-09 13:23:03.008691+00
497	zerver	0447_attachment_scheduled_messages_and_more	2023-06-09 13:23:03.112574+00
498	zerver	0448_scheduledmessage_new_fields	2023-06-09 13:23:03.377179+00
499	zerver	0449_scheduledmessage_zerver_unsent_scheduled_messages_indexes	2023-06-09 13:23:03.471585+00
500	zerver	0450_backfill_subscription_auditlogs	2023-06-09 13:23:03.530409+00
501	zerver	0451_add_userprofile_api_key_index	2023-06-09 13:23:03.583924+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_session (session_key, session_data, expire_date) FROM stdin;
0w669y0rlizhj4xlch9ydfg9rkpaqx2f	.eJxVjEEOgjAQRe_StSGMnaHg0ngKN02nnaaoKKF0oca7CwkL3b73338r68qcbMky2T6og2rV7pex81e5r-I1To-L-LnaUK7O5daPpzIMz-O2-kuTy2k9NARBEOvgllIaA9FHpNZ4oKjrSISadceeURgcN_sAnUSUBQG1Wn2-trU2ww:1niBTj:aTHXPb2BqNSd82N-gkqCMwyjb3SDaEaanoeIDc7VbT4	2022-05-07 08:50:55.845995+00
\.


--
-- Data for Name: fts_update_log; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.fts_update_log (id, message_id) FROM stdin;
\.


--
-- Data for Name: otp_static_staticdevice; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.otp_static_staticdevice (id, name, confirmed, user_id, throttling_failure_count, throttling_failure_timestamp) FROM stdin;
\.


--
-- Data for Name: otp_static_statictoken; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.otp_static_statictoken (id, token, device_id) FROM stdin;
\.


--
-- Data for Name: otp_totp_totpdevice; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.otp_totp_totpdevice (id, name, confirmed, key, step, t0, digits, tolerance, drift, last_t, user_id, throttling_failure_count, throttling_failure_timestamp) FROM stdin;
\.


--
-- Data for Name: social_auth_association; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.social_auth_association (id, server_url, handle, secret, issued, lifetime, assoc_type) FROM stdin;
\.


--
-- Data for Name: social_auth_code; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.social_auth_code (id, email, code, verified, "timestamp") FROM stdin;
\.


--
-- Data for Name: social_auth_nonce; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.social_auth_nonce (id, server_url, "timestamp", salt) FROM stdin;
\.


--
-- Data for Name: social_auth_partial; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.social_auth_partial (id, token, next_step, backend, data, "timestamp") FROM stdin;
\.


--
-- Data for Name: social_auth_usersocialauth; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.social_auth_usersocialauth (id, provider, uid, extra_data, user_id, created, modified) FROM stdin;
\.


--
-- Data for Name: third_party_api_results; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.third_party_api_results (cache_key, value, expires) FROM stdin;
\.


--
-- Data for Name: two_factor_phonedevice; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.two_factor_phonedevice (id, name, confirmed, number, key, method, user_id, throttling_failure_count, throttling_failure_timestamp) FROM stdin;
\.


--
-- Data for Name: zerver_alertword; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_alertword (id, word, realm_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedattachment; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedattachment (id, file_name, path_id, is_realm_public, create_time, size, owner_id, realm_id, is_web_public) FROM stdin;
\.


--
-- Data for Name: zerver_archivedattachment_messages; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedattachment_messages (id, archivedattachment_id, archivedmessage_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedmessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedmessage (id, subject, content, rendered_content, rendered_content_version, date_sent, last_edit_time, edit_history, has_attachment, has_image, has_link, recipient_id, sender_id, sending_client_id, archive_transaction_id, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedreaction; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedreaction (id, emoji_name, reaction_type, emoji_code, message_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedsubmessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedsubmessage (id, msg_type, content, message_id, sender_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedusermessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedusermessage (id, flags, message_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivetransaction; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivetransaction (id, "timestamp", restored, type, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_attachment; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_attachment (id, file_name, path_id, create_time, owner_id, is_realm_public, realm_id, size, is_web_public) FROM stdin;
\.


--
-- Data for Name: zerver_attachment_messages; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_attachment_messages (id, attachment_id, message_id) FROM stdin;
\.


--
-- Data for Name: zerver_attachment_scheduled_messages; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_attachment_scheduled_messages (id, attachment_id, scheduledmessage_id) FROM stdin;
\.


--
-- Data for Name: zerver_botconfigdata; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_botconfigdata (id, key, value, bot_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_botstoragedata; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_botstoragedata (id, key, value, bot_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_client; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_client (id, name) FROM stdin;
1	website
2	ZulipMobile
3	ZulipElectron
4	Internal
5	internal
\.


--
-- Data for Name: zerver_customprofilefield; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_customprofilefield (id, name, field_type, realm_id, hint, field_data, "order", display_in_profile_summary) FROM stdin;
\.


--
-- Data for Name: zerver_customprofilefieldvalue; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_customprofilefieldvalue (id, value, field_id, user_profile_id, rendered_value) FROM stdin;
\.


--
-- Data for Name: zerver_defaultstream; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_defaultstream (id, realm_id, stream_id) FROM stdin;
1	2	1
\.


--
-- Data for Name: zerver_defaultstreamgroup; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_defaultstreamgroup (id, name, realm_id, description) FROM stdin;
\.


--
-- Data for Name: zerver_defaultstreamgroup_streams; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_defaultstreamgroup_streams (id, defaultstreamgroup_id, stream_id) FROM stdin;
\.


--
-- Data for Name: zerver_draft; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_draft (id, topic, content, last_edit_time, recipient_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_emailchangestatus; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_emailchangestatus (id, new_email, old_email, updated_at, status, realm_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_groupgroupmembership; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_groupgroupmembership (id, subgroup_id, supergroup_id) FROM stdin;
1	1	2
2	2	3
3	3	4
4	4	5
5	5	6
6	6	7
7	8	9
8	9	10
9	10	11
10	11	12
11	12	13
12	13	14
\.


--
-- Data for Name: zerver_huddle; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_huddle (id, huddle_hash, recipient_id) FROM stdin;
\.


--
-- Data for Name: zerver_message; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_message (id, subject, content, rendered_content, rendered_content_version, last_edit_time, edit_history, has_attachment, has_image, has_link, recipient_id, sender_id, sending_client_id, search_tsvector, date_sent, realm_id) FROM stdin;
2	private streams	This is a private stream, as indicated by the lock icon next to the stream name. Private streams are only visible to stream members.\n\nTo manage this stream, go to [Stream settings](#streams/subscribed) and click on `core team`.	<p>This is a private stream, as indicated by the lock icon next to the stream name. Private streams are only visible to stream members.</p>\n<p>To manage this stream, go to <a href="#streams/subscribed">Stream settings</a> and click on <code>core team</code>.</p>	1	\N	\N	f	f	t	9	7	4	'click':36 'core':38 'go':31 'icon':13 'indicate':9 'lock':12 'manage':28 'member':26 'name':18 'next':14 'private':1,6,19 'sett':34 'stream':2,7,17,20,25,30,33 'team':39 'visible':23	2022-04-23 08:50:55.400754+00	2
3	topic demonstration	This is a message on stream #**general** with the topic `topic demonstration`.	<p>This is a message on stream <a class="stream" data-stream-id="1" href="/#narrow/stream/1-general">#general</a> with the topic <code>topic demonstration</code>.</p>	1	\N	\N	f	f	t	8	7	4	'demonstrate':2,14 'demonstration':2,14 'general':9 'message':6 'stream':8 'topic':1,12,13	2022-04-23 08:50:55.431721+00	2
4	topic demonstration	Topics are a lightweight tool to keep conversations organised. You can learn more about topics at [Streams and topics](/help/streams-and-topics).	<p>Topics are a lightweight tool to keep conversations organised. You can learn more about topics at <a href="/help/streams-and-topics">Streams and topics</a>.</p>	1	\N	\N	f	f	t	8	7	4	'conversation':10 'demonstrate':2 'demonstration':2 'keep':9 'learn':14 'lightweight':6 'organis':11 'stream':19 'tool':7 'topic':1,3,17,21	2022-04-23 08:50:55.459067+00	2
5	swimming turtles	This is a message on stream #**general** with the topic `swimming turtles`.\n\n[](/static/images/cute/turtle.png)\n\n[Start a new topic](/help/start-a-new-topic) any time you're not replying to a         previous message.	<p>This is a message on stream <a class="stream" data-stream-id="1" href="/#narrow/stream/1-general">#general</a> with the topic <code>swimming turtles</code>.</p>\n<div class="message_inline_image"><a href="/static/images/cute/turtle.png"><img src="/static/images/cute/turtle.png"></a></div><p><a href="/help/start-a-new-topic">Start a new topic</a> any time you're not replying to a         previous message.</p>	1	\N	\N	f	t	t	8	7	4	'general':9 'message':6,28 'new':17 'ply':24 'previous':27 're':22 'start':15 'stream':8 'swimming':1,13 'time':20 'topic':12,18 'turtle':2,14	2022-04-23 08:50:55.48362+00	2
1		Hello, and welcome to Zulip!👋 This is a private message from me, Welcome Bot.\n\nIf you are new to Zulip, check out our [Getting started guide](/help/getting-started-with-zulip)! We also have a guide for [Setting up your organisation](https://localhost/help/getting-your-organization-started-with-zulip).\n\nI can also help you get set up! Just click anywhere on this message or press `r` to reply.\n\nHere are a few messages I understand: `apps`, `profile`, `theme`, `streams`, `topics`, `message formatting`, `keyboard shortcuts`, `help`.	<p>Hello, and welcome to Zulip!<span aria-label="wave" class="emoji emoji-1f44b" role="img" title="wave">:wave:</span> This is a private message from me, Welcome Bot.</p>\n<p>If you are new to Zulip, check out our <a href="/help/getting-started-with-zulip">Getting started guide</a>! We also have a guide for <a href="help/getting-your-organization-started-with-zulip">Setting up your organisation</a>.</p>\n<p>I can also help you get set up! Just click anywhere on this message or press <code>r</code> to reply.</p>\n<p>Here are a few messages I understand: <code>apps</code>, <code>profile</code>, <code>theme</code>, <code>streams</code>, <code>topics</code>, <code>message formatting</code>, <code>keyboard shortcuts</code>, <code>help</code>.</p>	1	\N	\N	f	f	t	10	7	4	'also':29,40 'anywhere':48 'app':64 'bot':15 'check':22 'click':47 'file':65 'formatting':70 'get':43 'getting':25 'guide':27,32 'hello':1 'help':41,73 'keyboard':71 'message':11,51,61,69 'new':19 'organis':37 'ply':56 'press':53 'private':10 'set':44 'sett':34 'setting':34 'shortcut':72 'start':26 'stream':67 'theme':66 'topic':68 'understand':63 'wave':6 'welcome':3,14 'zulip':5,21	2022-04-23 08:50:55.289481+00	2
\.


--
-- Data for Name: zerver_missedmessageemailaddress; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_missedmessageemailaddress (id, email_token, "timestamp", times_used, message_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_multiuseinvite; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_multiuseinvite (id, realm_id, referred_by_id, invited_as, status) FROM stdin;
\.


--
-- Data for Name: zerver_multiuseinvite_streams; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_multiuseinvite_streams (id, multiuseinvite_id, stream_id) FROM stdin;
\.


--
-- Data for Name: zerver_muteduser; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_muteduser (id, date_muted, muted_user_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_preregistrationrealm; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationrealm (id, name, org_type, string_id, email, status, created_realm_id, created_user_id) FROM stdin;
\.


--
-- Data for Name: zerver_preregistrationuser; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationuser (id, email, invited_at, status, realm_id, referred_by_id, realm_creation, password_required, invited_as, full_name, full_name_validated, created_user_id, multiuse_invite_id) FROM stdin;
1	test@test.com	2022-04-23 08:50:40.19388+00	1	\N	\N	t	t	400	\N	f	\N	\N
\.


--
-- Data for Name: zerver_preregistrationuser_streams; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationuser_streams (id, preregistrationuser_id, stream_id) FROM stdin;
\.


--
-- Data for Name: zerver_pushdevicetoken; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_pushdevicetoken (id, kind, token, last_updated, ios_app_id, user_id) FROM stdin;
\.


--
-- Data for Name: zerver_reaction; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_reaction (id, user_profile_id, message_id, emoji_name, emoji_code, reaction_type) FROM stdin;
1	7	5	turtle	1f422	unicode_emoji
\.


--
-- Data for Name: zerver_realm; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realm (id, name, emails_restricted_to_domains, invite_required, mandatory_topics, digest_emails_enabled, name_changes_disabled, date_created, deactivated, notifications_stream_id, allow_message_editing, message_content_edit_limit_seconds, default_language, string_id, org_type, message_retention_days, waiting_period_threshold, icon_source, icon_version, email_changes_disabled, description, inline_image_preview, inline_url_embed_preview, allow_edit_history, signup_notifications_stream_id, max_invites, message_visibility_limit, upload_quota_gb, send_welcome_emails, bot_creation_policy, disallow_disposable_email_addresses, message_content_delete_limit_seconds, plan_type, first_visible_message_id, logo_source, logo_version, message_content_allowed_in_email_notifications, night_logo_source, night_logo_version, digest_weekday, invite_to_stream_policy, avatar_changes_disabled, video_chat_provider, user_group_edit_policy, private_message_policy, default_code_block_language, wildcard_mention_policy, deactivated_redirect, invite_to_realm_policy, giphy_rating, move_messages_between_streams_policy, edit_topic_policy, add_custom_emoji_policy, demo_organization_scheduled_deletion_date, delete_own_message_policy, create_private_stream_policy, create_public_stream_policy, create_web_public_stream_policy, enable_spectator_access, want_advertise_in_communities_directory, enable_read_receipts, move_messages_within_stream_limit_seconds, move_messages_between_streams_limit_seconds) FROM stdin;
1	System bot realm	f	t	f	f	f	2022-04-23 08:50:54.621821+00	f	\N	t	600	en	zulipinternal	0	-1	0	G	1	f		t	f	t	\N	\N	\N	\N	t	1	t	600	1	0	D	1	t	D	1	1	1	f	1	1	1	\N	5	\N	1	2	2	5	1	\N	2	1	1	7	f	f	t	604800	604800
2	testing	f	t	f	f	f	2022-04-23 08:50:54.873981+00	f	1	t	600	en		10	-1	0	G	1	f		t	f	t	2	\N	\N	\N	t	1	t	600	1	0	D	1	t	D	1	1	1	f	1	1	1	\N	5	\N	1	2	2	5	1	\N	2	1	1	7	f	f	t	604800	604800
\.


--
-- Data for Name: zerver_realmauditlog; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmauditlog (id, backfilled, event_time, acting_user_id, modified_stream_id, modified_user_id, realm_id, extra_data, event_last_message_id, event_type) FROM stdin;
1	f	2022-04-23 08:50:54.621821+00	\N	\N	\N	1	\N	\N	215
2	f	2022-04-23 08:50:54.676975+00	\N	\N	1	1	\N	\N	101
3	f	2022-04-23 08:50:54.677875+00	\N	\N	2	1	\N	\N	101
4	f	2022-04-23 08:50:54.67837+00	\N	\N	3	1	\N	\N	101
5	f	2022-04-23 08:50:54.678796+00	\N	\N	4	1	\N	\N	101
6	f	2022-04-23 08:50:54.679357+00	\N	\N	5	1	\N	\N	101
7	f	2022-04-23 08:50:54.680045+00	\N	\N	6	1	\N	\N	101
8	f	2022-04-23 08:50:54.680469+00	\N	\N	7	1	\N	\N	101
10	f	2022-04-23 08:50:54.977232+00	\N	1	\N	2	\N	\N	601
11	f	2022-04-23 08:50:55.010443+00	\N	2	\N	2	\N	\N	601
12	f	2022-04-23 08:50:55.05282+00	8	\N	8	2	{"10":{"11":{"200":0,"100":1,"300":0,"400":0,"600":0},"12":0}}	\N	101
9	f	2022-04-23 08:50:54.873981+00	8	\N	\N	2	\N	\N	215
13	f	2022-04-23 08:50:55.246779+00	\N	1	8	2	\N	-1	301
14	f	2022-04-23 08:50:55.349274+00	\N	2	8	2	\N	1	301
\.


--
-- Data for Name: zerver_realmauthenticationmethod; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmauthenticationmethod (id, name, realm_id) FROM stdin;
1	Google	1
2	Email	1
3	GitHub	1
4	LDAP	1
5	Dev	1
6	RemoteUser	1
7	AzureAD	1
8	SAML	1
9	GitLab	1
10	Apple	1
11	OpenID Connect	1
12	Google	2
13	Email	2
14	GitHub	2
15	LDAP	2
16	Dev	2
17	RemoteUser	2
18	AzureAD	2
19	SAML	2
20	GitLab	2
21	Apple	2
22	OpenID Connect	2
\.


--
-- Data for Name: zerver_realmdomain; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmdomain (id, domain, realm_id, allow_subdomains) FROM stdin;
\.


--
-- Data for Name: zerver_realmemoji; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmemoji (id, name, realm_id, author_id, file_name, deactivated, is_animated) FROM stdin;
\.


--
-- Data for Name: zerver_realmfilter; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmfilter (id, pattern, realm_id, url_template) FROM stdin;
\.


--
-- Data for Name: zerver_realmplayground; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmplayground (id, url_prefix, name, pygments_language, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmreactivationstatus; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmreactivationstatus (id, status, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmuserdefault; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmuserdefault (id, enter_sends, left_side_userlist, default_language, default_view, dense_mode, fluid_layout_width, high_contrast_mode, translate_emoticons, twenty_four_hour_time, starred_message_counts, color_scheme, demote_inactive_streams, emojiset, enable_stream_desktop_notifications, enable_stream_email_notifications, enable_stream_push_notifications, enable_stream_audible_notifications, notification_sound, wildcard_mentions_notify, enable_desktop_notifications, pm_content_in_desktop_notifications, enable_sounds, enable_offline_email_notifications, message_content_in_email_notifications, enable_offline_push_notifications, enable_online_push_notifications, desktop_icon_count_display, enable_digest_emails, enable_login_emails, enable_marketing_emails, presence_enabled, realm_id, email_notifications_batching_period_seconds, enable_drafts_synchronization, send_private_typing_notifications, send_stream_typing_notifications, send_read_receipts, escape_navigates_to_default_view, display_emoji_reaction_users, user_list_style, email_address_visibility, realm_name_in_email_notifications_policy, web_mark_read_on_scroll_policy) FROM stdin;
1	f	f	en	recent_topics	t	f	f	f	f	t	1	1	google	f	f	f	f	zulip	t	t	t	t	t	t	t	t	1	t	t	t	t	1	120	t	t	t	t	t	t	2	1	1	1
2	f	f	en	recent_topics	t	f	f	f	f	t	1	1	google	f	f	f	f	zulip	t	t	t	t	t	t	t	t	1	t	t	t	t	2	120	t	t	t	t	t	t	2	1	1	1
\.


--
-- Data for Name: zerver_recipient; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_recipient (id, type_id, type) FROM stdin;
1	1	1
2	2	1
3	3	1
4	4	1
5	5	1
6	6	1
7	7	1
8	1	2
9	2	2
10	8	1
\.


--
-- Data for Name: zerver_scheduledemail; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledemail (id, scheduled_timestamp, data, address, type, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_scheduledemail_users; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledemail_users (id, scheduledemail_id, userprofile_id) FROM stdin;
\.


--
-- Data for Name: zerver_scheduledmessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledmessage (id, subject, content, scheduled_timestamp, delivered, realm_id, recipient_id, sender_id, sending_client_id, stream_id, delivery_type, rendered_content, has_attachment, failed, failure_message, delivered_message_id) FROM stdin;
\.


--
-- Data for Name: zerver_scheduledmessagenotificationemail; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledmessagenotificationemail (id, trigger, scheduled_timestamp, mentioned_user_group_id, message_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_service; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_service (id, name, base_url, token, interface, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_stream; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_stream (id, name, invite_only, email_token, description, date_created, deactivated, realm_id, is_in_zephyr_realm, history_public_to_subscribers, is_web_public, rendered_description, first_message_id, message_retention_days, recipient_id, stream_post_policy, can_remove_subscribers_group_id) FROM stdin;
2	core team	t	e10c7ab67caf282fd32d3ef041ab812a	A private stream for core team members.	2022-04-23 08:50:55.000878+00	f	2	f	f	f	<p>A private stream for core team members.</p>	2	\N	9	1	2
1	general	f	9a384e15320de677d25cc2b3932ee218	Everyone is added to this stream by default. Welcome! :octopus:	2022-04-23 08:50:54.907375+00	f	2	f	t	f	<p>Everyone is added to this stream by default. Welcome! <span aria-label="octopus" class="emoji emoji-1f419" role="img" title="octopus">:octopus:</span></p>	5	\N	8	1	2
\.


--
-- Data for Name: zerver_submessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_submessage (id, msg_type, content, message_id, sender_id) FROM stdin;
\.


--
-- Data for Name: zerver_subscription; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_subscription (id, active, color, desktop_notifications, audible_notifications, recipient_id, user_profile_id, pin_to_top, push_notifications, email_notifications, is_muted, wildcard_mentions_notify, is_user_active) FROM stdin;
1	t	#c2c2c2	\N	\N	1	1	f	\N	\N	f	\N	t
2	t	#c2c2c2	\N	\N	2	2	f	\N	\N	f	\N	t
3	t	#c2c2c2	\N	\N	3	3	f	\N	\N	f	\N	t
4	t	#c2c2c2	\N	\N	4	4	f	\N	\N	f	\N	t
5	t	#c2c2c2	\N	\N	5	5	f	\N	\N	f	\N	t
6	t	#c2c2c2	\N	\N	6	6	f	\N	\N	f	\N	t
7	t	#c2c2c2	\N	\N	7	7	f	\N	\N	f	\N	t
8	t	#c2c2c2	\N	\N	10	8	f	\N	\N	f	\N	t
9	t	#76ce90	\N	\N	8	8	f	\N	\N	f	\N	t
10	t	#fae589	\N	\N	9	8	f	\N	\N	f	\N	t
\.


--
-- Data for Name: zerver_useractivity; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_useractivity (id, query, count, last_visit, client_id, user_profile_id) FROM stdin;
1	log_into_subdomain	1	2022-04-23 08:50:55+00	1	8
2	home_real	1	2022-04-23 08:50:55+00	1	8
3	/api/v1/events/internal	2	2022-04-23 08:50:55+00	5	8
6	update_message_flags	1	2022-04-23 08:50:57+00	1	8
7	report_narrow_times	1	2022-04-23 08:50:57+00	1	8
8	set_tutorial_status	1	2022-04-23 08:50:58+00	1	8
9	json_fetch_api_key	1	2022-04-23 08:51:28+00	1	8
5	get_messages_backend	5	2022-04-23 08:51:43+00	1	8
4	get_events	4	2022-04-23 08:51:45+00	1	8
\.


--
-- Data for Name: zerver_useractivityinterval; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_useractivityinterval (id, start, "end", user_profile_id) FROM stdin;
1	2022-04-23 08:50:56+00	2022-04-23 09:06:46+00	8
\.


--
-- Data for Name: zerver_usergroup; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usergroup (id, name, realm_id, description, is_system_group) FROM stdin;
1	@role:owners	2	Owners of this organization	t
2	@role:administrators	2	Administrators of this organization, including owners	t
3	@role:moderators	2	Moderators of this organization, including administrators	t
4	@role:fullmembers	2	Members of this organization, not including new accounts and guests	t
5	@role:members	2	Members of this organization, not including guests	t
6	@role:everyone	2	Everyone in this organization, including guests	t
7	@role:internet	2	Everyone on the Internet	t
8	@role:owners	1	Owners of this organization	t
9	@role:administrators	1	Administrators of this organization, including owners	t
10	@role:moderators	1	Moderators of this organization, including administrators	t
11	@role:fullmembers	1	Members of this organization, not including new accounts and guests	t
12	@role:members	1	Members of this organization, not including guests	t
13	@role:everyone	1	Everyone in this organization, including guests	t
14	@role:internet	1	Everyone on the Internet	t
15	@role:nobody	1	Nobody	t
16	@role:nobody	2	Nobody	t
\.


--
-- Data for Name: zerver_usergroupmembership; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usergroupmembership (id, user_group_id, user_profile_id) FROM stdin;
1	1	8
2	12	2
3	11	2
4	12	3
5	11	3
6	12	4
7	11	4
8	12	5
9	11	5
10	12	6
11	11	6
12	12	7
13	11	7
14	12	1
15	11	1
\.


--
-- Data for Name: zerver_userhotspot; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userhotspot (id, hotspot, "timestamp", user_id) FROM stdin;
\.


--
-- Data for Name: zerver_usermessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usermessage (flags, message_id, user_profile_id, id) FROM stdin;
2048	1	7	2
0	2	8	3
0	3	8	4
0	4	8	5
0	5	8	6
2049	1	8	1
\.


--
-- Data for Name: zerver_userpresence; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userpresence (id, last_connected_time, last_active_time, realm_id, user_profile_id) FROM stdin;
1	2022-04-23 08:51:46+00	2022-04-23 08:51:46+00	2	8
\.


--
-- Data for Name: zerver_userprofile; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userprofile (id, password, last_login, is_superuser, email, is_staff, is_active, is_bot, date_joined, is_mirror_dummy, full_name, api_key, enable_stream_desktop_notifications, enable_stream_audible_notifications, enable_desktop_notifications, enable_sounds, enable_offline_email_notifications, enable_offline_push_notifications, enable_digest_emails, last_reminder, rate_limits, default_all_public_streams, enter_sends, twenty_four_hour_time, avatar_source, tutorial_status, onboarding_steps, bot_owner_id, default_events_register_stream_id, default_sending_stream_id, realm_id, left_side_userlist, can_forge_sender, bot_type, default_language, tos_version, enable_online_push_notifications, pm_content_in_desktop_notifications, avatar_version, timezone, emojiset, last_active_message_id, long_term_idle, high_contrast_mode, enable_stream_push_notifications, enable_stream_email_notifications, translate_emoticons, message_content_in_email_notifications, dense_mode, delivery_email, starred_message_counts, is_billing_admin, enable_login_emails, notification_sound, fluid_layout_width, demote_inactive_streams, avatar_hash, desktop_icon_count_display, role, wildcard_mentions_notify, recipient_id, presence_enabled, zoom_token, color_scheme, can_create_users, default_view, enable_marketing_emails, email_notifications_batching_period_seconds, enable_drafts_synchronization, send_private_typing_notifications, send_stream_typing_notifications, send_read_receipts, escape_navigates_to_default_view, uuid, display_emoji_reaction_users, user_list_style, email_address_visibility, realm_name_in_email_notifications_policy, web_mark_read_on_scroll_policy) FROM stdin;
2	!1AwW0LFTkP1PYjZNnpG6gTUYsjjftwaBSw1Y3pji	2022-04-23 08:50:54.677875+00	f	nagios-receive-bot@zulip.com	f	t	t	2022-04-23 08:50:54.677875+00	f	Nagios Receive Bot	nTG8r6uvvJGKdQ3tV4NsxO9jZSCV1gXj	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	2	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	t	nagios-receive-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	2	t	\N	1	f	recent_topics	t	120	t	t	t	t	t	289855e5-91b4-4845-b01a-78406555b931	t	2	1	1	1
3	!ff2cIWnT6MjrPBpFSVtvcCxwwZzNVhmeepcp4pnI	2022-04-23 08:50:54.67837+00	f	nagios-send-bot@zulip.com	f	t	t	2022-04-23 08:50:54.67837+00	f	Nagios Send Bot	mw1VGjZT3zeQ17El1sywsemzYPzUyYSt	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	3	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	t	nagios-send-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	3	t	\N	1	f	recent_topics	t	120	t	t	t	t	t	60274dc7-ae4a-4cd4-aa11-4e177ad780e3	t	2	1	1	1
4	!NggBYBvz38U1RnOrZtf3sQ40EaN4LBg7tIwDc0R6	2022-04-23 08:50:54.678796+00	f	nagios-staging-receive-bot@zulip.com	f	t	t	2022-04-23 08:50:54.678796+00	f	Nagios Staging Receive Bot	eS5XwAqTjUTpUw2v7s3pVowhNIn07HOu	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	4	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	t	nagios-staging-receive-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	4	t	\N	1	f	recent_topics	t	120	t	t	t	t	t	e2ab3224-ad6c-4fc9-b323-a44dc5918e18	t	2	1	1	1
5	!7R52jbBS4vVwKOWdXqhOICksp9jNnUpGxbgoD5AP	2022-04-23 08:50:54.679357+00	f	nagios-staging-send-bot@zulip.com	f	t	t	2022-04-23 08:50:54.679357+00	f	Nagios Staging Send Bot	pGlFFp5w5w9aBLAk06PXtKr0AkcRDHrQ	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	5	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	t	nagios-staging-send-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	5	t	\N	1	f	recent_topics	t	120	t	t	t	t	t	5623963e-64d6-494e-b7d6-7408232916a2	t	2	1	1	1
6	!F3iJjkzRFqkbnJkl08GayNQ9t7GpUGD4lQ4U0JMc	2022-04-23 08:50:54.680045+00	f	notification-bot@zulip.com	f	t	t	2022-04-23 08:50:54.680045+00	f	Notification Bot	9W6kY8jUdnsFFauTtsKsHJr6Z74xg8Al	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	6	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	t	notification-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	6	t	\N	1	f	recent_topics	t	120	t	t	t	t	t	12e9f3dd-03aa-471d-9a3f-a0dbe1f2efb4	t	2	1	1	1
7	!oqgN6KFWZxwfI3O1JKFvXdxXCReo6OgcYgAAB5Al	2022-04-23 08:50:54.680469+00	f	welcome-bot@zulip.com	f	t	t	2022-04-23 08:50:54.680469+00	f	Welcome Bot	9yEPZTOPbO6k7UHwrHMmHQjEYRD5MtHw	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	7	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	t	welcome-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	7	t	\N	1	f	recent_topics	t	120	t	t	t	t	t	fcab4980-2a19-4374-a082-6f017554e060	t	2	1	1	1
1	!rxck8AsPDDQDFqVPjn0jmIRLqgWBzlSgoN54f9OB	2022-04-23 08:50:54.676975+00	f	emailgateway@zulip.com	f	t	t	2022-04-23 08:50:54.676975+00	f	Email Gateway	xJ0BENMQQtlU6sMFqhzKwZ7bMVABxY2q	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	1	\N	\N	1	f	t	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	t	emailgateway@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	1	t	\N	1	f	recent_topics	t	120	t	t	t	t	t	8b6d6cee-47f5-4551-bc1f-f334cd24a4a6	t	2	1	1	1
8	argon2$argon2id$v=19$m=102400,t=2,p=8$VjFZUWpPTllFdDVESEg4SkdCbEc5ZQ$m+ST6Xde1vvG3CEgsll1qSL2dVKf1fFFGiQvqWcsI9s	2022-04-23 08:50:55.636819+00	f	test@test.com	f	t	f	2022-04-23 08:50:55.05282+00	f	tester	lDxDG5uoqwOhCdeA2d9iHvboTYAcOlVb	f	f	t	t	t	t	t	\N		f	f	f	G	S	[]	\N	\N	\N	2	f	f	\N	en	\N	t	t	1	Europe/London	google	\N	f	f	f	f	f	t	t	test@test.com	t	f	t	zulip	f	1	\N	1	100	t	10	t	\N	1	t	recent_topics	f	120	t	t	t	t	t	6f58568b-d24c-4400-86a5-2c89c327d275	t	2	1	1	1
\.


--
-- Data for Name: zerver_userprofile_groups; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userprofile_groups (id, userprofile_id, group_id) FROM stdin;
\.


--
-- Data for Name: zerver_userprofile_user_permissions; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userprofile_user_permissions (id, userprofile_id, permission_id) FROM stdin;
\.


--
-- Data for Name: zerver_userstatus; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userstatus (id, "timestamp", client_id, user_profile_id, status_text, emoji_code, emoji_name, reaction_type) FROM stdin;
\.


--
-- Data for Name: zerver_usertopic; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usertopic (id, topic_name, recipient_id, stream_id, user_profile_id, last_updated, visibility_policy) FROM stdin;
\.


--
-- Name: analytics_fillstate_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.analytics_fillstate_id_seq', 1, false);


--
-- Name: analytics_installationcount_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.analytics_installationcount_id_seq', 1, false);


--
-- Name: analytics_realmcount_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.analytics_realmcount_id_seq', 1, true);


--
-- Name: analytics_streamcount_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.analytics_streamcount_id_seq', 1, false);


--
-- Name: analytics_usercount_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.analytics_usercount_id_seq', 2, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.auth_permission_id_seq', 304, true);


--
-- Name: confirmation_confirmation_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.confirmation_confirmation_id_seq', 2, true);


--
-- Name: confirmation_realmcreationkey_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.confirmation_realmcreationkey_id_seq', 1, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.django_content_type_id_seq', 76, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.django_migrations_id_seq', 501, true);


--
-- Name: fts_update_log_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.fts_update_log_id_seq', 5, true);


--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.otp_static_staticdevice_id_seq', 1, false);


--
-- Name: otp_static_statictoken_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.otp_static_statictoken_id_seq', 1, false);


--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.otp_totp_totpdevice_id_seq', 1, false);


--
-- Name: social_auth_association_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.social_auth_association_id_seq', 1, false);


--
-- Name: social_auth_code_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.social_auth_code_id_seq', 1, false);


--
-- Name: social_auth_nonce_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.social_auth_nonce_id_seq', 1, false);


--
-- Name: social_auth_partial_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.social_auth_partial_id_seq', 1, false);


--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.social_auth_usersocialauth_id_seq', 1, false);


--
-- Name: two_factor_phonedevice_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.two_factor_phonedevice_id_seq', 1, false);


--
-- Name: zerver_alertword_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_alertword_id_seq', 1, false);


--
-- Name: zerver_archivedattachment_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_archivedattachment_id_seq', 1, false);


--
-- Name: zerver_archivedattachment_messages_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_archivedattachment_messages_id_seq', 1, false);


--
-- Name: zerver_archivedmessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_archivedmessage_id_seq', 1, false);


--
-- Name: zerver_archivedreaction_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_archivedreaction_id_seq', 1, false);


--
-- Name: zerver_archivedsubmessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_archivedsubmessage_id_seq', 1, false);


--
-- Name: zerver_archivedusermessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_archivedusermessage_id_seq', 1, false);


--
-- Name: zerver_archivetransaction_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_archivetransaction_id_seq', 1, false);


--
-- Name: zerver_attachment_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_attachment_id_seq', 1, false);


--
-- Name: zerver_attachment_messages_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_attachment_messages_id_seq', 1, false);


--
-- Name: zerver_attachment_scheduled_messages_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_attachment_scheduled_messages_id_seq', 1, false);


--
-- Name: zerver_botuserconfigdata_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_botuserconfigdata_id_seq', 1, false);


--
-- Name: zerver_botuserstatedata_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_botuserstatedata_id_seq', 1, false);


--
-- Name: zerver_client_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_client_id_seq', 5, true);


--
-- Name: zerver_customprofilefield_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_customprofilefield_id_seq', 1, false);


--
-- Name: zerver_customprofilefieldvalue_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_customprofilefieldvalue_id_seq', 1, false);


--
-- Name: zerver_defaultstream_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_defaultstream_id_seq', 1, true);


--
-- Name: zerver_defaultstreamgroup_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_defaultstreamgroup_id_seq', 1, false);


--
-- Name: zerver_defaultstreamgroup_streams_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_defaultstreamgroup_streams_id_seq', 1, false);


--
-- Name: zerver_draft_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_draft_id_seq', 1, false);


--
-- Name: zerver_emailchangestatus_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_emailchangestatus_id_seq', 1, false);


--
-- Name: zerver_groupgroupmembership_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_groupgroupmembership_id_seq', 12, true);


--
-- Name: zerver_huddle_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_huddle_id_seq', 1, false);


--
-- Name: zerver_message_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_message_id_seq', 5, true);


--
-- Name: zerver_missedmessageemailaddress_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_missedmessageemailaddress_id_seq', 1, false);


--
-- Name: zerver_multiuseinvite_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_multiuseinvite_id_seq', 1, false);


--
-- Name: zerver_multiuseinvite_streams_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_multiuseinvite_streams_id_seq', 1, false);


--
-- Name: zerver_mutedtopic_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_mutedtopic_id_seq', 1, false);


--
-- Name: zerver_muteduser_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_muteduser_id_seq', 1, false);


--
-- Name: zerver_preregistrationrealm_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_preregistrationrealm_id_seq', 1, false);


--
-- Name: zerver_preregistrationuser_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_preregistrationuser_id_seq', 1, true);


--
-- Name: zerver_preregistrationuser_streams_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_preregistrationuser_streams_id_seq', 1, false);


--
-- Name: zerver_pushdevicetoken_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_pushdevicetoken_id_seq', 1, false);


--
-- Name: zerver_reaction_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_reaction_id_seq', 1, true);


--
-- Name: zerver_realm_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realm_id_seq', 2, true);


--
-- Name: zerver_realmalias_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmalias_id_seq', 1, false);


--
-- Name: zerver_realmauditlog_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmauditlog_id_seq', 14, true);


--
-- Name: zerver_realmauthenticationmethod_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmauthenticationmethod_id_seq', 22, true);


--
-- Name: zerver_realmemoji_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmemoji_id_seq', 1, false);


--
-- Name: zerver_realmfilter_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmfilter_id_seq', 1, false);


--
-- Name: zerver_realmplayground_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmplayground_id_seq', 1, false);


--
-- Name: zerver_realmreactivationstatus_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmreactivationstatus_id_seq', 1, false);


--
-- Name: zerver_realmuserdefault_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmuserdefault_id_seq', 2, true);


--
-- Name: zerver_recipient_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_recipient_id_seq', 10, true);


--
-- Name: zerver_scheduledemail_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledemail_id_seq', 2, true);


--
-- Name: zerver_scheduledemail_users_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledemail_users_id_seq', 2, true);


--
-- Name: zerver_scheduledmessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledmessage_id_seq', 1, false);


--
-- Name: zerver_scheduledmessagenotificationemail_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledmessagenotificationemail_id_seq', 1, true);


--
-- Name: zerver_service_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_service_id_seq', 1, false);


--
-- Name: zerver_stream_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_stream_id_seq', 2, true);


--
-- Name: zerver_submessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_submessage_id_seq', 1, false);


--
-- Name: zerver_subscription_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_subscription_id_seq', 10, true);


--
-- Name: zerver_useractivity_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_useractivity_id_seq', 9, true);


--
-- Name: zerver_useractivityinterval_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_useractivityinterval_id_seq', 1, true);


--
-- Name: zerver_usergroup_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_usergroup_id_seq', 16, true);


--
-- Name: zerver_usergroupmembership_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_usergroupmembership_id_seq', 15, true);


--
-- Name: zerver_userhotspot_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_userhotspot_id_seq', 1, false);


--
-- Name: zerver_usermessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_usermessage_id_seq', 6, true);


--
-- Name: zerver_userpresence_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_userpresence_id_seq', 1, true);


--
-- Name: zerver_userprofile_groups_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_userprofile_groups_id_seq', 1, false);


--
-- Name: zerver_userprofile_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_userprofile_id_seq', 8, true);


--
-- Name: zerver_userprofile_user_permissions_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_userprofile_user_permissions_id_seq', 1, false);


--
-- Name: zerver_userstatus_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_userstatus_id_seq', 1, false);


--
-- Name: analytics_fillstate analytics_fillstate_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_fillstate
    ADD CONSTRAINT analytics_fillstate_pkey PRIMARY KEY (id);


--
-- Name: analytics_fillstate analytics_fillstate_property_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_fillstate
    ADD CONSTRAINT analytics_fillstate_property_key UNIQUE (property);


--
-- Name: analytics_installationcount analytics_installationcount_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_installationcount
    ADD CONSTRAINT analytics_installationcount_pkey PRIMARY KEY (id);


--
-- Name: analytics_realmcount analytics_realmcount_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_realmcount
    ADD CONSTRAINT analytics_realmcount_pkey PRIMARY KEY (id);


--
-- Name: analytics_streamcount analytics_streamcount_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_streamcount
    ADD CONSTRAINT analytics_streamcount_pkey PRIMARY KEY (id);


--
-- Name: analytics_usercount analytics_usercount_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_usercount
    ADD CONSTRAINT analytics_usercount_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: confirmation_confirmation confirmation_confirmation_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.confirmation_confirmation
    ADD CONSTRAINT confirmation_confirmation_pkey PRIMARY KEY (id);


--
-- Name: confirmation_confirmation confirmation_confirmation_type_confirmation_key_134e405d_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.confirmation_confirmation
    ADD CONSTRAINT confirmation_confirmation_type_confirmation_key_134e405d_uniq UNIQUE (type, confirmation_key);


--
-- Name: confirmation_realmcreationkey confirmation_realmcreationkey_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.confirmation_realmcreationkey
    ADD CONSTRAINT confirmation_realmcreationkey_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: fts_update_log fts_update_log_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.fts_update_log
    ADD CONSTRAINT fts_update_log_pkey PRIMARY KEY (id);


--
-- Name: otp_static_staticdevice otp_static_staticdevice_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_static_staticdevice
    ADD CONSTRAINT otp_static_staticdevice_pkey PRIMARY KEY (id);


--
-- Name: otp_static_statictoken otp_static_statictoken_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_static_statictoken
    ADD CONSTRAINT otp_static_statictoken_pkey PRIMARY KEY (id);


--
-- Name: otp_totp_totpdevice otp_totp_totpdevice_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_totp_totpdevice
    ADD CONSTRAINT otp_totp_totpdevice_pkey PRIMARY KEY (id);


--
-- Name: social_auth_association social_auth_association_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_association
    ADD CONSTRAINT social_auth_association_pkey PRIMARY KEY (id);


--
-- Name: social_auth_association social_auth_association_server_url_handle_078befa2_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_association
    ADD CONSTRAINT social_auth_association_server_url_handle_078befa2_uniq UNIQUE (server_url, handle);


--
-- Name: social_auth_code social_auth_code_email_code_801b2d02_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_code
    ADD CONSTRAINT social_auth_code_email_code_801b2d02_uniq UNIQUE (email, code);


--
-- Name: social_auth_code social_auth_code_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_code
    ADD CONSTRAINT social_auth_code_pkey PRIMARY KEY (id);


--
-- Name: social_auth_nonce social_auth_nonce_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_nonce
    ADD CONSTRAINT social_auth_nonce_pkey PRIMARY KEY (id);


--
-- Name: social_auth_nonce social_auth_nonce_server_url_timestamp_salt_f6284463_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_nonce
    ADD CONSTRAINT social_auth_nonce_server_url_timestamp_salt_f6284463_uniq UNIQUE (server_url, "timestamp", salt);


--
-- Name: social_auth_partial social_auth_partial_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_partial
    ADD CONSTRAINT social_auth_partial_pkey PRIMARY KEY (id);


--
-- Name: social_auth_usersocialauth social_auth_usersocialauth_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_usersocialauth
    ADD CONSTRAINT social_auth_usersocialauth_pkey PRIMARY KEY (id);


--
-- Name: social_auth_usersocialauth social_auth_usersocialauth_provider_uid_e6b5e668_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_usersocialauth
    ADD CONSTRAINT social_auth_usersocialauth_provider_uid_e6b5e668_uniq UNIQUE (provider, uid);


--
-- Name: third_party_api_results third_party_api_results_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.third_party_api_results
    ADD CONSTRAINT third_party_api_results_pkey PRIMARY KEY (cache_key);


--
-- Name: two_factor_phonedevice two_factor_phonedevice_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.two_factor_phonedevice
    ADD CONSTRAINT two_factor_phonedevice_pkey PRIMARY KEY (id);


--
-- Name: zerver_alertword zerver_alertword_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_alertword
    ADD CONSTRAINT zerver_alertword_pkey PRIMARY KEY (id);


--
-- Name: zerver_alertword zerver_alertword_user_profile_id_word_5ef8400f_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_alertword
    ADD CONSTRAINT zerver_alertword_user_profile_id_word_5ef8400f_uniq UNIQUE (user_profile_id, word);


--
-- Name: zerver_archivedattachment_messages zerver_archivedattachmen_archivedattachment_id_ar_7e5b0a4e_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment_messages
    ADD CONSTRAINT zerver_archivedattachmen_archivedattachment_id_ar_7e5b0a4e_uniq UNIQUE (archivedattachment_id, archivedmessage_id);


--
-- Name: zerver_archivedattachment_messages zerver_archivedattachment_messages_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment_messages
    ADD CONSTRAINT zerver_archivedattachment_messages_pkey PRIMARY KEY (id);


--
-- Name: zerver_archivedattachment zerver_archivedattachment_path_id_b556fcf2_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment
    ADD CONSTRAINT zerver_archivedattachment_path_id_b556fcf2_uniq UNIQUE (path_id);


--
-- Name: zerver_archivedattachment zerver_archivedattachment_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment
    ADD CONSTRAINT zerver_archivedattachment_pkey PRIMARY KEY (id);


--
-- Name: zerver_archivedmessage zerver_archivedmessage_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedmessage
    ADD CONSTRAINT zerver_archivedmessage_pkey PRIMARY KEY (id);


--
-- Name: zerver_archivedreaction zerver_archivedreaction_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedreaction
    ADD CONSTRAINT zerver_archivedreaction_pkey PRIMARY KEY (id);


--
-- Name: zerver_archivedreaction zerver_archivedreaction_user_profile_id_message__03511ba4_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedreaction
    ADD CONSTRAINT zerver_archivedreaction_user_profile_id_message__03511ba4_uniq UNIQUE (user_profile_id, message_id, reaction_type, emoji_code);


--
-- Name: zerver_archivedsubmessage zerver_archivedsubmessage_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedsubmessage
    ADD CONSTRAINT zerver_archivedsubmessage_pkey PRIMARY KEY (id);


--
-- Name: zerver_archivedusermessage zerver_archivedusermessa_user_profile_id_message__80b625d2_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedusermessage
    ADD CONSTRAINT zerver_archivedusermessa_user_profile_id_message__80b625d2_uniq UNIQUE (user_profile_id, message_id);


--
-- Name: zerver_archivedusermessage zerver_archivedusermessage_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedusermessage
    ADD CONSTRAINT zerver_archivedusermessage_pkey PRIMARY KEY (id);


--
-- Name: zerver_archivetransaction zerver_archivetransaction_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivetransaction
    ADD CONSTRAINT zerver_archivetransaction_pkey PRIMARY KEY (id);


--
-- Name: zerver_attachment_messages zerver_attachment_messag_attachment_id_message_id_02062772_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_messages
    ADD CONSTRAINT zerver_attachment_messag_attachment_id_message_id_02062772_uniq UNIQUE (attachment_id, message_id);


--
-- Name: zerver_attachment_messages zerver_attachment_messages_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_messages
    ADD CONSTRAINT zerver_attachment_messages_pkey PRIMARY KEY (id);


--
-- Name: zerver_attachment zerver_attachment_path_id_eb61103a_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment
    ADD CONSTRAINT zerver_attachment_path_id_eb61103a_uniq UNIQUE (path_id);


--
-- Name: zerver_attachment zerver_attachment_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment
    ADD CONSTRAINT zerver_attachment_pkey PRIMARY KEY (id);


--
-- Name: zerver_attachment_scheduled_messages zerver_attachment_schedu_attachment_id_scheduledm_20edb9b1_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_scheduled_messages
    ADD CONSTRAINT zerver_attachment_schedu_attachment_id_scheduledm_20edb9b1_uniq UNIQUE (attachment_id, scheduledmessage_id);


--
-- Name: zerver_attachment_scheduled_messages zerver_attachment_scheduled_messages_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_scheduled_messages
    ADD CONSTRAINT zerver_attachment_scheduled_messages_pkey PRIMARY KEY (id);


--
-- Name: zerver_botconfigdata zerver_botuserconfigdata_bot_profile_id_key_438e568d_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botconfigdata
    ADD CONSTRAINT zerver_botuserconfigdata_bot_profile_id_key_438e568d_uniq UNIQUE (bot_profile_id, key);


--
-- Name: zerver_botconfigdata zerver_botuserconfigdata_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botconfigdata
    ADD CONSTRAINT zerver_botuserconfigdata_pkey PRIMARY KEY (id);


--
-- Name: zerver_botstoragedata zerver_botuserstatedata_bot_profile_id_key_1c7769b4_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botstoragedata
    ADD CONSTRAINT zerver_botuserstatedata_bot_profile_id_key_1c7769b4_uniq UNIQUE (bot_profile_id, key);


--
-- Name: zerver_botstoragedata zerver_botuserstatedata_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botstoragedata
    ADD CONSTRAINT zerver_botuserstatedata_pkey PRIMARY KEY (id);


--
-- Name: zerver_client zerver_client_name_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_client
    ADD CONSTRAINT zerver_client_name_key UNIQUE (name);


--
-- Name: zerver_client zerver_client_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_client
    ADD CONSTRAINT zerver_client_pkey PRIMARY KEY (id);


--
-- Name: zerver_customprofilefieldvalue zerver_customprofilefiel_user_profile_id_field_id_02f3d266_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefieldvalue
    ADD CONSTRAINT zerver_customprofilefiel_user_profile_id_field_id_02f3d266_uniq UNIQUE (user_profile_id, field_id);


--
-- Name: zerver_customprofilefield zerver_customprofilefield_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefield
    ADD CONSTRAINT zerver_customprofilefield_pkey PRIMARY KEY (id);


--
-- Name: zerver_customprofilefield zerver_customprofilefield_realm_id_name_a2c5787c_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefield
    ADD CONSTRAINT zerver_customprofilefield_realm_id_name_a2c5787c_uniq UNIQUE (realm_id, name);


--
-- Name: zerver_customprofilefieldvalue zerver_customprofilefieldvalue_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefieldvalue
    ADD CONSTRAINT zerver_customprofilefieldvalue_pkey PRIMARY KEY (id);


--
-- Name: zerver_defaultstream zerver_defaultstream_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstream
    ADD CONSTRAINT zerver_defaultstream_pkey PRIMARY KEY (id);


--
-- Name: zerver_defaultstream zerver_defaultstream_realm_id_stream_id_c34840a1_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstream
    ADD CONSTRAINT zerver_defaultstream_realm_id_stream_id_c34840a1_uniq UNIQUE (realm_id, stream_id);


--
-- Name: zerver_defaultstreamgroup_streams zerver_defaultstreamgrou_defaultstreamgroup_id_st_726e2497_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup_streams
    ADD CONSTRAINT zerver_defaultstreamgrou_defaultstreamgroup_id_st_726e2497_uniq UNIQUE (defaultstreamgroup_id, stream_id);


--
-- Name: zerver_defaultstreamgroup zerver_defaultstreamgroup_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup
    ADD CONSTRAINT zerver_defaultstreamgroup_pkey PRIMARY KEY (id);


--
-- Name: zerver_defaultstreamgroup zerver_defaultstreamgroup_realm_id_name_060565f4_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup
    ADD CONSTRAINT zerver_defaultstreamgroup_realm_id_name_060565f4_uniq UNIQUE (realm_id, name);


--
-- Name: zerver_defaultstreamgroup_streams zerver_defaultstreamgroup_streams_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup_streams
    ADD CONSTRAINT zerver_defaultstreamgroup_streams_pkey PRIMARY KEY (id);


--
-- Name: zerver_draft zerver_draft_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_draft
    ADD CONSTRAINT zerver_draft_pkey PRIMARY KEY (id);


--
-- Name: zerver_emailchangestatus zerver_emailchangestatus_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_emailchangestatus
    ADD CONSTRAINT zerver_emailchangestatus_pkey PRIMARY KEY (id);


--
-- Name: zerver_groupgroupmembership zerver_groupgroupmembership_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_groupgroupmembership
    ADD CONSTRAINT zerver_groupgroupmembership_pkey PRIMARY KEY (id);


--
-- Name: zerver_groupgroupmembership zerver_groupgroupmembership_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_groupgroupmembership
    ADD CONSTRAINT zerver_groupgroupmembership_uniq UNIQUE (supergroup_id, subgroup_id);


--
-- Name: zerver_huddle zerver_huddle_huddle_hash_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_huddle
    ADD CONSTRAINT zerver_huddle_huddle_hash_key UNIQUE (huddle_hash);


--
-- Name: zerver_huddle zerver_huddle_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_huddle
    ADD CONSTRAINT zerver_huddle_pkey PRIMARY KEY (id);


--
-- Name: zerver_message zerver_message_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_message
    ADD CONSTRAINT zerver_message_pkey PRIMARY KEY (id);


--
-- Name: zerver_missedmessageemailaddress zerver_missedmessageemailaddress_email_token_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_missedmessageemailaddress
    ADD CONSTRAINT zerver_missedmessageemailaddress_email_token_key UNIQUE (email_token);


--
-- Name: zerver_missedmessageemailaddress zerver_missedmessageemailaddress_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_missedmessageemailaddress
    ADD CONSTRAINT zerver_missedmessageemailaddress_pkey PRIMARY KEY (id);


--
-- Name: zerver_multiuseinvite zerver_multiuseinvite_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite
    ADD CONSTRAINT zerver_multiuseinvite_pkey PRIMARY KEY (id);


--
-- Name: zerver_multiuseinvite_streams zerver_multiuseinvite_st_multiuseinvite_id_stream_407c06d6_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_streams
    ADD CONSTRAINT zerver_multiuseinvite_st_multiuseinvite_id_stream_407c06d6_uniq UNIQUE (multiuseinvite_id, stream_id);


--
-- Name: zerver_multiuseinvite_streams zerver_multiuseinvite_streams_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_streams
    ADD CONSTRAINT zerver_multiuseinvite_streams_pkey PRIMARY KEY (id);


--
-- Name: zerver_usertopic zerver_mutedtopic_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_mutedtopic_pkey PRIMARY KEY (id);


--
-- Name: zerver_muteduser zerver_muteduser_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_muteduser
    ADD CONSTRAINT zerver_muteduser_pkey PRIMARY KEY (id);


--
-- Name: zerver_muteduser zerver_muteduser_user_profile_id_muted_user_id_5bfc6940_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_muteduser
    ADD CONSTRAINT zerver_muteduser_user_profile_id_muted_user_id_5bfc6940_uniq UNIQUE (user_profile_id, muted_user_id);


--
-- Name: zerver_preregistrationrealm zerver_preregistrationrealm_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationrealm
    ADD CONSTRAINT zerver_preregistrationrealm_pkey PRIMARY KEY (id);


--
-- Name: zerver_preregistrationuser_streams zerver_preregistrationus_preregistrationuser_id_s_d8befabf_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams
    ADD CONSTRAINT zerver_preregistrationus_preregistrationuser_id_s_d8befabf_uniq UNIQUE (preregistrationuser_id, stream_id);


--
-- Name: zerver_preregistrationuser zerver_preregistrationuser_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrationuser_pkey PRIMARY KEY (id);


--
-- Name: zerver_preregistrationuser_streams zerver_preregistrationuser_streams_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams
    ADD CONSTRAINT zerver_preregistrationuser_streams_pkey PRIMARY KEY (id);


--
-- Name: zerver_pushdevicetoken zerver_pushdevicetoken_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_pushdevicetoken
    ADD CONSTRAINT zerver_pushdevicetoken_pkey PRIMARY KEY (id);


--
-- Name: zerver_pushdevicetoken zerver_pushdevicetoken_user_id_kind_token_f0fc92a0_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_pushdevicetoken
    ADD CONSTRAINT zerver_pushdevicetoken_user_id_kind_token_f0fc92a0_uniq UNIQUE (user_id, kind, token);


--
-- Name: zerver_reaction zerver_reaction_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_reaction
    ADD CONSTRAINT zerver_reaction_pkey PRIMARY KEY (id);


--
-- Name: zerver_reaction zerver_reaction_user_profile_id_message__c0f00e70_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_reaction
    ADD CONSTRAINT zerver_reaction_user_profile_id_message__c0f00e70_uniq UNIQUE (user_profile_id, message_id, reaction_type, emoji_code);


--
-- Name: zerver_realm zerver_realm_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_pkey PRIMARY KEY (id);


--
-- Name: zerver_realm zerver_realm_subdomain_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_subdomain_key UNIQUE (string_id);


--
-- Name: zerver_realmdomain zerver_realmalias_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmdomain
    ADD CONSTRAINT zerver_realmalias_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmdomain zerver_realmalias_realm_id_domain_2b212741_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmdomain
    ADD CONSTRAINT zerver_realmalias_realm_id_domain_2b212741_uniq UNIQUE (realm_id, domain);


--
-- Name: zerver_realmauditlog zerver_realmauditlog_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog
    ADD CONSTRAINT zerver_realmauditlog_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmauthenticationmethod zerver_realmauthenticationmethod_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauthenticationmethod
    ADD CONSTRAINT zerver_realmauthenticationmethod_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmauthenticationmethod zerver_realmauthenticationmethod_realm_id_name_ba5c43a7_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauthenticationmethod
    ADD CONSTRAINT zerver_realmauthenticationmethod_realm_id_name_ba5c43a7_uniq UNIQUE (realm_id, name);


--
-- Name: zerver_realmemoji zerver_realmemoji_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmemoji
    ADD CONSTRAINT zerver_realmemoji_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmfilter zerver_realmfilter_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmfilter
    ADD CONSTRAINT zerver_realmfilter_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmfilter zerver_realmfilter_realm_id_pattern_0f3790a0_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmfilter
    ADD CONSTRAINT zerver_realmfilter_realm_id_pattern_0f3790a0_uniq UNIQUE (realm_id, pattern);


--
-- Name: zerver_realmplayground zerver_realmplayground_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmplayground
    ADD CONSTRAINT zerver_realmplayground_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmplayground zerver_realmplayground_realm_id_pygments_langua_1f277901_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmplayground
    ADD CONSTRAINT zerver_realmplayground_realm_id_pygments_langua_1f277901_uniq UNIQUE (realm_id, pygments_language, name);


--
-- Name: zerver_realmreactivationstatus zerver_realmreactivationstatus_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmreactivationstatus
    ADD CONSTRAINT zerver_realmreactivationstatus_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmuserdefault zerver_realmuserdefault_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmuserdefault
    ADD CONSTRAINT zerver_realmuserdefault_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmuserdefault zerver_realmuserdefault_realm_id_0cb9cdb9_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmuserdefault
    ADD CONSTRAINT zerver_realmuserdefault_realm_id_0cb9cdb9_uniq UNIQUE (realm_id);


--
-- Name: zerver_recipient zerver_recipient_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_recipient
    ADD CONSTRAINT zerver_recipient_pkey PRIMARY KEY (id);


--
-- Name: zerver_recipient zerver_recipient_type_type_id_29712363_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_recipient
    ADD CONSTRAINT zerver_recipient_type_type_id_29712363_uniq UNIQUE (type, type_id);


--
-- Name: zerver_scheduledemail zerver_scheduledemail_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail
    ADD CONSTRAINT zerver_scheduledemail_pkey PRIMARY KEY (id);


--
-- Name: zerver_scheduledemail_users zerver_scheduledemail_us_scheduledemail_id_userpr_a826ec4f_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail_users
    ADD CONSTRAINT zerver_scheduledemail_us_scheduledemail_id_userpr_a826ec4f_uniq UNIQUE (scheduledemail_id, userprofile_id);


--
-- Name: zerver_scheduledemail_users zerver_scheduledemail_users_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail_users
    ADD CONSTRAINT zerver_scheduledemail_users_pkey PRIMARY KEY (id);


--
-- Name: zerver_scheduledmessage zerver_scheduledmessage_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmessage_pkey PRIMARY KEY (id);


--
-- Name: zerver_scheduledmessagenotificationemail zerver_scheduledmessagenotificationemail_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessagenotificationemail
    ADD CONSTRAINT zerver_scheduledmessagenotificationemail_pkey PRIMARY KEY (id);


--
-- Name: zerver_service zerver_service_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_service
    ADD CONSTRAINT zerver_service_pkey PRIMARY KEY (id);


--
-- Name: zerver_stream zerver_stream_email_token_8a608bf8_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_email_token_8a608bf8_uniq UNIQUE (email_token);


--
-- Name: zerver_stream zerver_stream_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_pkey PRIMARY KEY (id);


--
-- Name: zerver_submessage zerver_submessage_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_submessage
    ADD CONSTRAINT zerver_submessage_pkey PRIMARY KEY (id);


--
-- Name: zerver_subscription zerver_subscription_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_subscription
    ADD CONSTRAINT zerver_subscription_pkey PRIMARY KEY (id);


--
-- Name: zerver_subscription zerver_subscription_user_profile_id_recipient_id_6051164b_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_subscription
    ADD CONSTRAINT zerver_subscription_user_profile_id_recipient_id_6051164b_uniq UNIQUE (user_profile_id, recipient_id);


--
-- Name: zerver_useractivity zerver_useractivity_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_useractivity
    ADD CONSTRAINT zerver_useractivity_pkey PRIMARY KEY (id);


--
-- Name: zerver_useractivity zerver_useractivity_user_profile_id_client_i_7a77114d_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_useractivity
    ADD CONSTRAINT zerver_useractivity_user_profile_id_client_i_7a77114d_uniq UNIQUE (user_profile_id, client_id, query);


--
-- Name: zerver_useractivityinterval zerver_useractivityinterval_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_useractivityinterval
    ADD CONSTRAINT zerver_useractivityinterval_pkey PRIMARY KEY (id);


--
-- Name: zerver_usergroup zerver_usergroup_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroup
    ADD CONSTRAINT zerver_usergroup_pkey PRIMARY KEY (id);


--
-- Name: zerver_usergroup zerver_usergroup_realm_id_name_951f766d_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroup
    ADD CONSTRAINT zerver_usergroup_realm_id_name_951f766d_uniq UNIQUE (realm_id, name);


--
-- Name: zerver_usergroupmembership zerver_usergroupmembersh_user_group_id_user_profi_5b32ea4b_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroupmembership
    ADD CONSTRAINT zerver_usergroupmembersh_user_group_id_user_profi_5b32ea4b_uniq UNIQUE (user_group_id, user_profile_id);


--
-- Name: zerver_usergroupmembership zerver_usergroupmembership_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroupmembership
    ADD CONSTRAINT zerver_usergroupmembership_pkey PRIMARY KEY (id);


--
-- Name: zerver_userhotspot zerver_userhotspot_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userhotspot
    ADD CONSTRAINT zerver_userhotspot_pkey PRIMARY KEY (id);


--
-- Name: zerver_userhotspot zerver_userhotspot_user_id_hotspot_9292d57f_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userhotspot
    ADD CONSTRAINT zerver_userhotspot_user_id_hotspot_9292d57f_uniq UNIQUE (user_id, hotspot);


--
-- Name: zerver_usermessage zerver_usermessage_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usermessage
    ADD CONSTRAINT zerver_usermessage_pkey PRIMARY KEY (id);


--
-- Name: zerver_usermessage zerver_usermessage_user_profile_id_message_id_4936d0df_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usermessage
    ADD CONSTRAINT zerver_usermessage_user_profile_id_message_id_4936d0df_uniq UNIQUE (user_profile_id, message_id);


--
-- Name: zerver_userpresence zerver_userpresence_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userpresence
    ADD CONSTRAINT zerver_userpresence_pkey PRIMARY KEY (id);


--
-- Name: zerver_userpresence zerver_userpresence_user_profile_id_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userpresence
    ADD CONSTRAINT zerver_userpresence_user_profile_id_key UNIQUE (user_profile_id);


--
-- Name: zerver_userprofile zerver_userprofile_api_key_63599ac6_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_api_key_63599ac6_uniq UNIQUE (api_key);


--
-- Name: zerver_userprofile_groups zerver_userprofile_groups_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_groups
    ADD CONSTRAINT zerver_userprofile_groups_pkey PRIMARY KEY (id);


--
-- Name: zerver_userprofile_groups zerver_userprofile_groups_userprofile_id_group_id_70dd6ca4_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_groups
    ADD CONSTRAINT zerver_userprofile_groups_userprofile_id_group_id_70dd6ca4_uniq UNIQUE (userprofile_id, group_id);


--
-- Name: zerver_userprofile zerver_userprofile_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_pkey PRIMARY KEY (id);


--
-- Name: zerver_userprofile_user_permissions zerver_userprofile_user__userprofile_id_permissio_a8b239b6_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_user_permissions
    ADD CONSTRAINT zerver_userprofile_user__userprofile_id_permissio_a8b239b6_uniq UNIQUE (userprofile_id, permission_id);


--
-- Name: zerver_userprofile_user_permissions zerver_userprofile_user_permissions_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_user_permissions
    ADD CONSTRAINT zerver_userprofile_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: zerver_userprofile zerver_userprofile_uuid_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_uuid_key UNIQUE (uuid);


--
-- Name: zerver_userstatus zerver_userstatus_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userstatus
    ADD CONSTRAINT zerver_userstatus_pkey PRIMARY KEY (id);


--
-- Name: zerver_userstatus zerver_userstatus_user_profile_id_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userstatus
    ADD CONSTRAINT zerver_userstatus_user_profile_id_key UNIQUE (user_profile_id);


--
-- Name: analytics_fillstate_property_69206ce5_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_fillstate_property_69206ce5_like ON zulip.analytics_fillstate USING btree (property varchar_pattern_ops);


--
-- Name: analytics_realmcount_property_end_time_3b60396b_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_realmcount_property_end_time_3b60396b_idx ON zulip.analytics_realmcount USING btree (property, end_time);


--
-- Name: analytics_realmcount_realm_id_9fccfcfb; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_realmcount_realm_id_9fccfcfb ON zulip.analytics_realmcount USING btree (realm_id);


--
-- Name: analytics_streamcount_property_realm_id_end_time_155ae930_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_streamcount_property_realm_id_end_time_155ae930_idx ON zulip.analytics_streamcount USING btree (property, realm_id, end_time);


--
-- Name: analytics_streamcount_realm_id_2e51c13a; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_streamcount_realm_id_2e51c13a ON zulip.analytics_streamcount USING btree (realm_id);


--
-- Name: analytics_streamcount_stream_id_e1168935; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_streamcount_stream_id_e1168935 ON zulip.analytics_streamcount USING btree (stream_id);


--
-- Name: analytics_usercount_property_realm_id_end_time_591dbec1_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_usercount_property_realm_id_end_time_591dbec1_idx ON zulip.analytics_usercount USING btree (property, realm_id, end_time);


--
-- Name: analytics_usercount_realm_id_7215e926; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_usercount_realm_id_7215e926 ON zulip.analytics_usercount USING btree (realm_id);


--
-- Name: analytics_usercount_user_id_2e9aca8a; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX analytics_usercount_user_id_2e9aca8a ON zulip.analytics_usercount USING btree (user_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX auth_group_name_a6ea08ec_like ON zulip.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON zulip.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON zulip.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON zulip.auth_permission USING btree (content_type_id);


--
-- Name: confirmation_confirmation_confirmation_key_c1ba29ff; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_confirmation_confirmation_key_c1ba29ff ON zulip.confirmation_confirmation USING btree (confirmation_key);


--
-- Name: confirmation_confirmation_confirmation_key_c1ba29ff_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_confirmation_confirmation_key_c1ba29ff_like ON zulip.confirmation_confirmation USING btree (confirmation_key varchar_pattern_ops);


--
-- Name: confirmation_confirmation_content_type_id_a55c95ef; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_confirmation_content_type_id_a55c95ef ON zulip.confirmation_confirmation USING btree (content_type_id);


--
-- Name: confirmation_confirmation_date_sent_561a7d87; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_confirmation_date_sent_561a7d87 ON zulip.confirmation_confirmation USING btree (date_sent);


--
-- Name: confirmation_confirmation_expiry_date_c6560e53; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_confirmation_expiry_date_c6560e53 ON zulip.confirmation_confirmation USING btree (expiry_date);


--
-- Name: confirmation_confirmation_object_id_55a77954; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_confirmation_object_id_55a77954 ON zulip.confirmation_confirmation USING btree (object_id);


--
-- Name: confirmation_confirmation_realm_id_80c5f350; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_confirmation_realm_id_80c5f350 ON zulip.confirmation_confirmation USING btree (realm_id);


--
-- Name: confirmation_realmcreationkey_creation_key_b134749a; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_realmcreationkey_creation_key_b134749a ON zulip.confirmation_realmcreationkey USING btree (creation_key);


--
-- Name: confirmation_realmcreationkey_creation_key_b134749a_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmation_realmcreationkey_creation_key_b134749a_like ON zulip.confirmation_realmcreationkey USING btree (creation_key varchar_pattern_ops);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX django_session_expire_date_a5c62663 ON zulip.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX django_session_session_key_c0390e0f_like ON zulip.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: otp_static_staticdevice_user_id_7f9cff2b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX otp_static_staticdevice_user_id_7f9cff2b ON zulip.otp_static_staticdevice USING btree (user_id);


--
-- Name: otp_static_statictoken_device_id_74b7c7d1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX otp_static_statictoken_device_id_74b7c7d1 ON zulip.otp_static_statictoken USING btree (device_id);


--
-- Name: otp_static_statictoken_token_d0a51866; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX otp_static_statictoken_token_d0a51866 ON zulip.otp_static_statictoken USING btree (token);


--
-- Name: otp_static_statictoken_token_d0a51866_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX otp_static_statictoken_token_d0a51866_like ON zulip.otp_static_statictoken USING btree (token varchar_pattern_ops);


--
-- Name: otp_totp_totpdevice_user_id_0fb18292; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX otp_totp_totpdevice_user_id_0fb18292 ON zulip.otp_totp_totpdevice USING btree (user_id);


--
-- Name: social_auth_code_code_a2393167; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_code_code_a2393167 ON zulip.social_auth_code USING btree (code);


--
-- Name: social_auth_code_code_a2393167_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_code_code_a2393167_like ON zulip.social_auth_code USING btree (code varchar_pattern_ops);


--
-- Name: social_auth_code_timestamp_176b341f; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_code_timestamp_176b341f ON zulip.social_auth_code USING btree ("timestamp");


--
-- Name: social_auth_partial_timestamp_50f2119f; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_partial_timestamp_50f2119f ON zulip.social_auth_partial USING btree ("timestamp");


--
-- Name: social_auth_partial_token_3017fea3; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_partial_token_3017fea3 ON zulip.social_auth_partial USING btree (token);


--
-- Name: social_auth_partial_token_3017fea3_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_partial_token_3017fea3_like ON zulip.social_auth_partial USING btree (token varchar_pattern_ops);


--
-- Name: social_auth_usersocialauth_uid_796e51dc; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_usersocialauth_uid_796e51dc ON zulip.social_auth_usersocialauth USING btree (uid);


--
-- Name: social_auth_usersocialauth_uid_796e51dc_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_usersocialauth_uid_796e51dc_like ON zulip.social_auth_usersocialauth USING btree (uid varchar_pattern_ops);


--
-- Name: social_auth_usersocialauth_user_id_17d28448; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX social_auth_usersocialauth_user_id_17d28448 ON zulip.social_auth_usersocialauth USING btree (user_id);


--
-- Name: third_party_api_results_expires; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX third_party_api_results_expires ON zulip.third_party_api_results USING btree (expires);


--
-- Name: two_factor_phonedevice_user_id_54718003; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX two_factor_phonedevice_user_id_54718003 ON zulip.two_factor_phonedevice USING btree (user_id);


--
-- Name: unique_installation_count; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_installation_count ON zulip.analytics_installationcount USING btree (property, subgroup, end_time) WHERE (subgroup IS NOT NULL);


--
-- Name: unique_installation_count_null_subgroup; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_installation_count_null_subgroup ON zulip.analytics_installationcount USING btree (property, end_time) WHERE (subgroup IS NULL);


--
-- Name: unique_realm_count; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_realm_count ON zulip.analytics_realmcount USING btree (realm_id, property, subgroup, end_time) WHERE (subgroup IS NOT NULL);


--
-- Name: unique_realm_count_null_subgroup; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_realm_count_null_subgroup ON zulip.analytics_realmcount USING btree (realm_id, property, end_time) WHERE (subgroup IS NULL);


--
-- Name: unique_realm_emoji_when_false_deactivated; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_realm_emoji_when_false_deactivated ON zulip.zerver_realmemoji USING btree (realm_id, name) WHERE (NOT deactivated);


--
-- Name: unique_stream_count; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_stream_count ON zulip.analytics_streamcount USING btree (stream_id, property, subgroup, end_time) WHERE (subgroup IS NOT NULL);


--
-- Name: unique_stream_count_null_subgroup; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_stream_count_null_subgroup ON zulip.analytics_streamcount USING btree (stream_id, property, end_time) WHERE (subgroup IS NULL);


--
-- Name: unique_user_count; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_user_count ON zulip.analytics_usercount USING btree (user_id, property, subgroup, end_time) WHERE (subgroup IS NOT NULL);


--
-- Name: unique_user_count_null_subgroup; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX unique_user_count_null_subgroup ON zulip.analytics_usercount USING btree (user_id, property, end_time) WHERE (subgroup IS NULL);


--
-- Name: upper_preregistration_email_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX upper_preregistration_email_idx ON zulip.zerver_preregistrationuser USING btree (upper((email)::text));


--
-- Name: upper_stream_name_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX upper_stream_name_idx ON zulip.zerver_stream USING btree (upper((name)::text));


--
-- Name: upper_subject_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX upper_subject_idx ON zulip.zerver_message USING btree (upper((subject)::text));


--
-- Name: upper_userprofile_email_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX upper_userprofile_email_idx ON zulip.zerver_userprofile USING btree (upper((email)::text));


--
-- Name: usertopic_case_insensitive_topic_uniq; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX usertopic_case_insensitive_topic_uniq ON zulip.zerver_usertopic USING btree (user_profile_id, stream_id, lower((topic_name)::text));


--
-- Name: zerver_alertword_realm_id_feaa54a2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_alertword_realm_id_feaa54a2 ON zulip.zerver_alertword USING btree (realm_id);


--
-- Name: zerver_alertword_user_profile_id_03150ab2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_alertword_user_profile_id_03150ab2 ON zulip.zerver_alertword USING btree (user_profile_id);


--
-- Name: zerver_archivedattachment__archivedattachment_id_1b7d6694; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedattachment__archivedattachment_id_1b7d6694 ON zulip.zerver_archivedattachment_messages USING btree (archivedattachment_id);


--
-- Name: zerver_archivedattachment_create_time_699c56ce; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedattachment_create_time_699c56ce ON zulip.zerver_archivedattachment USING btree (create_time);


--
-- Name: zerver_archivedattachment_file_name_47581e0b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedattachment_file_name_47581e0b ON zulip.zerver_archivedattachment USING btree (file_name);


--
-- Name: zerver_archivedattachment_file_name_47581e0b_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedattachment_file_name_47581e0b_like ON zulip.zerver_archivedattachment USING btree (file_name text_pattern_ops);


--
-- Name: zerver_archivedattachment_messages_archivedmessage_id_e67eb490; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedattachment_messages_archivedmessage_id_e67eb490 ON zulip.zerver_archivedattachment_messages USING btree (archivedmessage_id);


--
-- Name: zerver_archivedattachment_owner_id_abd89ced; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedattachment_owner_id_abd89ced ON zulip.zerver_archivedattachment USING btree (owner_id);


--
-- Name: zerver_archivedattachment_path_id_b556fcf2_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedattachment_path_id_b556fcf2_like ON zulip.zerver_archivedattachment USING btree (path_id text_pattern_ops);


--
-- Name: zerver_archivedattachment_realm_id_95fb78cc; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedattachment_realm_id_95fb78cc ON zulip.zerver_archivedattachment USING btree (realm_id);


--
-- Name: zerver_archivedmessage_archive_transaction_id_3f0a7f7b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_archive_transaction_id_3f0a7f7b ON zulip.zerver_archivedmessage USING btree (archive_transaction_id);


--
-- Name: zerver_archivedmessage_date_sent_509062c8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_date_sent_509062c8 ON zulip.zerver_archivedmessage USING btree (date_sent);


--
-- Name: zerver_archivedmessage_has_attachment_241447ff; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_has_attachment_241447ff ON zulip.zerver_archivedmessage USING btree (has_attachment);


--
-- Name: zerver_archivedmessage_has_image_eda172f6; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_has_image_eda172f6 ON zulip.zerver_archivedmessage USING btree (has_image);


--
-- Name: zerver_archivedmessage_has_link_9a376bd8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_has_link_9a376bd8 ON zulip.zerver_archivedmessage USING btree (has_link);


--
-- Name: zerver_archivedmessage_realm_id_fab86889; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_realm_id_fab86889 ON zulip.zerver_archivedmessage USING btree (realm_id);


--
-- Name: zerver_archivedmessage_recipient_id_2d004795; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_recipient_id_2d004795 ON zulip.zerver_archivedmessage USING btree (recipient_id);


--
-- Name: zerver_archivedmessage_sender_id_1bb891e6; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_sender_id_1bb891e6 ON zulip.zerver_archivedmessage USING btree (sender_id);


--
-- Name: zerver_archivedmessage_sending_client_id_0f31bdd0; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_sending_client_id_0f31bdd0 ON zulip.zerver_archivedmessage USING btree (sending_client_id);


--
-- Name: zerver_archivedmessage_subject_1c8bbb5e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_subject_1c8bbb5e ON zulip.zerver_archivedmessage USING btree (subject);


--
-- Name: zerver_archivedmessage_subject_1c8bbb5e_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_subject_1c8bbb5e_like ON zulip.zerver_archivedmessage USING btree (subject varchar_pattern_ops);


--
-- Name: zerver_archivedreaction_message_id_080a41fe; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedreaction_message_id_080a41fe ON zulip.zerver_archivedreaction USING btree (message_id);


--
-- Name: zerver_archivedreaction_user_profile_id_4cb7a2cc; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedreaction_user_profile_id_4cb7a2cc ON zulip.zerver_archivedreaction USING btree (user_profile_id);


--
-- Name: zerver_archivedsubmessage_message_id_e20a2a2d; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedsubmessage_message_id_e20a2a2d ON zulip.zerver_archivedsubmessage USING btree (message_id);


--
-- Name: zerver_archivedsubmessage_sender_id_c197a583; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedsubmessage_sender_id_c197a583 ON zulip.zerver_archivedsubmessage USING btree (sender_id);


--
-- Name: zerver_archivedusermessage_message_id_5ef4f254; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedusermessage_message_id_5ef4f254 ON zulip.zerver_archivedusermessage USING btree (message_id);


--
-- Name: zerver_archivedusermessage_user_profile_id_1fe3817a; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedusermessage_user_profile_id_1fe3817a ON zulip.zerver_archivedusermessage USING btree (user_profile_id);


--
-- Name: zerver_archivetransaction_realm_id_81a3b8dd; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivetransaction_realm_id_81a3b8dd ON zulip.zerver_archivetransaction USING btree (realm_id);


--
-- Name: zerver_archivetransaction_restored_caf08584; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivetransaction_restored_caf08584 ON zulip.zerver_archivetransaction USING btree (restored);


--
-- Name: zerver_archivetransaction_timestamp_95500014; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivetransaction_timestamp_95500014 ON zulip.zerver_archivetransaction USING btree ("timestamp");


--
-- Name: zerver_archivetransaction_type_424c350b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivetransaction_type_424c350b ON zulip.zerver_archivetransaction USING btree (type);


--
-- Name: zerver_attachment_create_time_c6bc68e6; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_create_time_c6bc68e6 ON zulip.zerver_attachment USING btree (create_time);


--
-- Name: zerver_attachment_file_name_25dddc06; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_file_name_25dddc06 ON zulip.zerver_attachment USING btree (file_name);


--
-- Name: zerver_attachment_messages_attachment_id_eb4e59c0; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_messages_attachment_id_eb4e59c0 ON zulip.zerver_attachment_messages USING btree (attachment_id);


--
-- Name: zerver_attachment_messages_message_id_c5e566fb; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_messages_message_id_c5e566fb ON zulip.zerver_attachment_messages USING btree (message_id);


--
-- Name: zerver_attachment_owner_id_b40072c4; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_owner_id_b40072c4 ON zulip.zerver_attachment USING btree (owner_id);


--
-- Name: zerver_attachment_path_id_eb61103a_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_path_id_eb61103a_like ON zulip.zerver_attachment USING btree (path_id text_pattern_ops);


--
-- Name: zerver_attachment_realm_id_f8e3c906; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_realm_id_f8e3c906 ON zulip.zerver_attachment USING btree (realm_id);


--
-- Name: zerver_attachment_schedule_scheduledmessage_id_27c3f026; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_schedule_scheduledmessage_id_27c3f026 ON zulip.zerver_attachment_scheduled_messages USING btree (scheduledmessage_id);


--
-- Name: zerver_attachment_scheduled_messages_attachment_id_03da128c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_scheduled_messages_attachment_id_03da128c ON zulip.zerver_attachment_scheduled_messages USING btree (attachment_id);


--
-- Name: zerver_botuserconfigdata_bot_profile_id_7055bf8c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botuserconfigdata_bot_profile_id_7055bf8c ON zulip.zerver_botconfigdata USING btree (bot_profile_id);


--
-- Name: zerver_botuserconfigdata_key_db3c0c80; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botuserconfigdata_key_db3c0c80 ON zulip.zerver_botconfigdata USING btree (key);


--
-- Name: zerver_botuserconfigdata_key_db3c0c80_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botuserconfigdata_key_db3c0c80_like ON zulip.zerver_botconfigdata USING btree (key text_pattern_ops);


--
-- Name: zerver_botuserstatedata_bot_profile_id_861ccb8a; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botuserstatedata_bot_profile_id_861ccb8a ON zulip.zerver_botstoragedata USING btree (bot_profile_id);


--
-- Name: zerver_botuserstatedata_key_4a125656; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botuserstatedata_key_4a125656 ON zulip.zerver_botstoragedata USING btree (key);


--
-- Name: zerver_botuserstatedata_key_4a125656_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botuserstatedata_key_4a125656_like ON zulip.zerver_botstoragedata USING btree (key text_pattern_ops);


--
-- Name: zerver_client_name_16461016_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_client_name_16461016_like ON zulip.zerver_client USING btree (name varchar_pattern_ops);


--
-- Name: zerver_customprofilefield_realm_id_b0de0439; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_customprofilefield_realm_id_b0de0439 ON zulip.zerver_customprofilefield USING btree (realm_id);


--
-- Name: zerver_customprofilefieldvalue_field_id_00409129; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_customprofilefieldvalue_field_id_00409129 ON zulip.zerver_customprofilefieldvalue USING btree (field_id);


--
-- Name: zerver_customprofilefieldvalue_user_profile_id_24d4820f; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_customprofilefieldvalue_user_profile_id_24d4820f ON zulip.zerver_customprofilefieldvalue USING btree (user_profile_id);


--
-- Name: zerver_defaultstream_realm_id_b5f0faf3; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_defaultstream_realm_id_b5f0faf3 ON zulip.zerver_defaultstream USING btree (realm_id);


--
-- Name: zerver_defaultstream_stream_id_9a8e0616; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_defaultstream_stream_id_9a8e0616 ON zulip.zerver_defaultstream USING btree (stream_id);


--
-- Name: zerver_defaultstreamgroup__defaultstreamgroup_id_bd9739b9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_defaultstreamgroup__defaultstreamgroup_id_bd9739b9 ON zulip.zerver_defaultstreamgroup_streams USING btree (defaultstreamgroup_id);


--
-- Name: zerver_defaultstreamgroup_name_9d9ad13f; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_defaultstreamgroup_name_9d9ad13f ON zulip.zerver_defaultstreamgroup USING btree (name);


--
-- Name: zerver_defaultstreamgroup_name_9d9ad13f_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_defaultstreamgroup_name_9d9ad13f_like ON zulip.zerver_defaultstreamgroup USING btree (name varchar_pattern_ops);


--
-- Name: zerver_defaultstreamgroup_realm_id_b15f3495; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_defaultstreamgroup_realm_id_b15f3495 ON zulip.zerver_defaultstreamgroup USING btree (realm_id);


--
-- Name: zerver_defaultstreamgroup_streams_stream_id_9844331d; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_defaultstreamgroup_streams_stream_id_9844331d ON zulip.zerver_defaultstreamgroup_streams USING btree (stream_id);


--
-- Name: zerver_draft_last_edit_time_da238c24; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_draft_last_edit_time_da238c24 ON zulip.zerver_draft USING btree (last_edit_time);


--
-- Name: zerver_draft_recipient_id_b9b91732; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_draft_recipient_id_b9b91732 ON zulip.zerver_draft USING btree (recipient_id);


--
-- Name: zerver_draft_topic_d26ca08b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_draft_topic_d26ca08b ON zulip.zerver_draft USING btree (topic);


--
-- Name: zerver_draft_topic_d26ca08b_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_draft_topic_d26ca08b_like ON zulip.zerver_draft USING btree (topic varchar_pattern_ops);


--
-- Name: zerver_draft_user_profile_id_4a215f11; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_draft_user_profile_id_4a215f11 ON zulip.zerver_draft USING btree (user_profile_id);


--
-- Name: zerver_emailchangestatus_realm_id_a68b9be8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_emailchangestatus_realm_id_a68b9be8 ON zulip.zerver_emailchangestatus USING btree (realm_id);


--
-- Name: zerver_emailchangestatus_user_profile_id_908b1af2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_emailchangestatus_user_profile_id_908b1af2 ON zulip.zerver_emailchangestatus USING btree (user_profile_id);


--
-- Name: zerver_groupgroupmembership_subgroup_id_3ec521bb; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_groupgroupmembership_subgroup_id_3ec521bb ON zulip.zerver_groupgroupmembership USING btree (subgroup_id);


--
-- Name: zerver_groupgroupmembership_supergroup_id_3874b6ef; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_groupgroupmembership_supergroup_id_3874b6ef ON zulip.zerver_groupgroupmembership USING btree (supergroup_id);


--
-- Name: zerver_huddle_huddle_hash_085f5549_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_huddle_huddle_hash_085f5549_like ON zulip.zerver_huddle USING btree (huddle_hash varchar_pattern_ops);


--
-- Name: zerver_huddle_recipient_id_e3e1fadc; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_huddle_recipient_id_e3e1fadc ON zulip.zerver_huddle USING btree (recipient_id);


--
-- Name: zerver_message_date_sent_3b5b05d8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_date_sent_3b5b05d8 ON zulip.zerver_message USING btree (date_sent);


--
-- Name: zerver_message_has_attachment_a3fd5bf6; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_has_attachment_a3fd5bf6 ON zulip.zerver_message USING btree (has_attachment);


--
-- Name: zerver_message_has_image_ff9a0b90; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_has_image_ff9a0b90 ON zulip.zerver_message USING btree (has_image);


--
-- Name: zerver_message_has_link_4171c207; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_has_link_4171c207 ON zulip.zerver_message USING btree (has_link);


--
-- Name: zerver_message_realm_id_849a39c8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_id_849a39c8 ON zulip.zerver_message USING btree (realm_id);


--
-- Name: zerver_message_recipient_id_5a7b6f03; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_recipient_id_5a7b6f03 ON zulip.zerver_message USING btree (recipient_id);


--
-- Name: zerver_message_recipient_subject; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_recipient_subject ON zulip.zerver_message USING btree (recipient_id, subject, id DESC NULLS LAST);


--
-- Name: zerver_message_recipient_upper_subject; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_recipient_upper_subject ON zulip.zerver_message USING btree (recipient_id, upper((subject)::text), id DESC NULLS LAST);


--
-- Name: zerver_message_search_tsvector; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_search_tsvector ON zulip.zerver_message USING gin (search_tsvector) WITH (fastupdate=off);


--
-- Name: zerver_message_sender_id_77b89151; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_sender_id_77b89151 ON zulip.zerver_message USING btree (sender_id);


--
-- Name: zerver_message_sending_client_id_1c38413f; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_sending_client_id_1c38413f ON zulip.zerver_message USING btree (sending_client_id);


--
-- Name: zerver_message_subject_cbe8c4b9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_subject_cbe8c4b9 ON zulip.zerver_message USING btree (subject);


--
-- Name: zerver_message_subject_cbe8c4b9_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_subject_cbe8c4b9_like ON zulip.zerver_message USING btree (subject varchar_pattern_ops);


--
-- Name: zerver_missedmessageemailaddress_email_token_de69d603_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_missedmessageemailaddress_email_token_de69d603_like ON zulip.zerver_missedmessageemailaddress USING btree (email_token varchar_pattern_ops);


--
-- Name: zerver_missedmessageemailaddress_message_id_98361e8c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_missedmessageemailaddress_message_id_98361e8c ON zulip.zerver_missedmessageemailaddress USING btree (message_id);


--
-- Name: zerver_missedmessageemailaddress_times_used_4c24b14d; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_missedmessageemailaddress_times_used_4c24b14d ON zulip.zerver_missedmessageemailaddress USING btree (times_used);


--
-- Name: zerver_missedmessageemailaddress_timestamp_71041597; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_missedmessageemailaddress_timestamp_71041597 ON zulip.zerver_missedmessageemailaddress USING btree ("timestamp");


--
-- Name: zerver_missedmessageemailaddress_user_profile_id_2d530260; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_missedmessageemailaddress_user_profile_id_2d530260 ON zulip.zerver_missedmessageemailaddress USING btree (user_profile_id);


--
-- Name: zerver_multiuseinvite_realm_id_8eb19d52; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_multiuseinvite_realm_id_8eb19d52 ON zulip.zerver_multiuseinvite USING btree (realm_id);


--
-- Name: zerver_multiuseinvite_referred_by_id_8970bd5c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_multiuseinvite_referred_by_id_8970bd5c ON zulip.zerver_multiuseinvite USING btree (referred_by_id);


--
-- Name: zerver_multiuseinvite_streams_multiuseinvite_id_be033d7f; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_multiuseinvite_streams_multiuseinvite_id_be033d7f ON zulip.zerver_multiuseinvite_streams USING btree (multiuseinvite_id);


--
-- Name: zerver_multiuseinvite_streams_stream_id_2cb97168; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_multiuseinvite_streams_stream_id_2cb97168 ON zulip.zerver_multiuseinvite_streams USING btree (stream_id);


--
-- Name: zerver_mutedtopic_recipient_id_e1901302; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_mutedtopic_recipient_id_e1901302 ON zulip.zerver_usertopic USING btree (recipient_id);


--
-- Name: zerver_mutedtopic_stream_id_acbff20e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_mutedtopic_stream_id_acbff20e ON zulip.zerver_usertopic USING btree (stream_id);


--
-- Name: zerver_mutedtopic_stream_topic; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_mutedtopic_stream_topic ON zulip.zerver_usertopic USING btree (stream_id, upper((topic_name)::text));


--
-- Name: zerver_mutedtopic_user_profile_id_4f8a692c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_mutedtopic_user_profile_id_4f8a692c ON zulip.zerver_usertopic USING btree (user_profile_id);


--
-- Name: zerver_muteduser_muted_user_id_d4b66dff; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_muteduser_muted_user_id_d4b66dff ON zulip.zerver_muteduser USING btree (muted_user_id);


--
-- Name: zerver_muteduser_user_profile_id_aeb57a40; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_muteduser_user_profile_id_aeb57a40 ON zulip.zerver_muteduser USING btree (user_profile_id);


--
-- Name: zerver_preregistrationrealm_created_realm_id_0c7c7c75; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationrealm_created_realm_id_0c7c7c75 ON zulip.zerver_preregistrationrealm USING btree (created_realm_id);


--
-- Name: zerver_preregistrationrealm_created_user_id_6d6d4d55; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationrealm_created_user_id_6d6d4d55 ON zulip.zerver_preregistrationrealm USING btree (created_user_id);


--
-- Name: zerver_preregistrationuser_created_user_id_2c23181e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_created_user_id_2c23181e ON zulip.zerver_preregistrationuser USING btree (created_user_id);


--
-- Name: zerver_preregistrationuser_multiuse_invite_id_7747603e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_multiuse_invite_id_7747603e ON zulip.zerver_preregistrationuser USING btree (multiuse_invite_id);


--
-- Name: zerver_preregistrationuser_preregistrationuser_id_332ca855; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_preregistrationuser_id_332ca855 ON zulip.zerver_preregistrationuser_streams USING btree (preregistrationuser_id);


--
-- Name: zerver_preregistrationuser_realm_id_fd5aff83; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_realm_id_fd5aff83 ON zulip.zerver_preregistrationuser USING btree (realm_id);


--
-- Name: zerver_preregistrationuser_referred_by_id_51f0a793; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_referred_by_id_51f0a793 ON zulip.zerver_preregistrationuser USING btree (referred_by_id);


--
-- Name: zerver_preregistrationuser_streams_stream_id_29da6767; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_streams_stream_id_29da6767 ON zulip.zerver_preregistrationuser_streams USING btree (stream_id);


--
-- Name: zerver_pushdevicetoken_token_24d13308; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_pushdevicetoken_token_24d13308 ON zulip.zerver_pushdevicetoken USING btree (token);


--
-- Name: zerver_pushdevicetoken_token_24d13308_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_pushdevicetoken_token_24d13308_like ON zulip.zerver_pushdevicetoken USING btree (token varchar_pattern_ops);


--
-- Name: zerver_pushdevicetoken_user_id_015e5dc1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_pushdevicetoken_user_id_015e5dc1 ON zulip.zerver_pushdevicetoken USING btree (user_id);


--
-- Name: zerver_reaction_message_id_e5e820a6; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_reaction_message_id_e5e820a6 ON zulip.zerver_reaction USING btree (message_id);


--
-- Name: zerver_reaction_user_profile_id_468ce1ef; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_reaction_user_profile_id_468ce1ef ON zulip.zerver_reaction USING btree (user_profile_id);


--
-- Name: zerver_realm_notifications_stream_id_f07609e9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_notifications_stream_id_f07609e9 ON zulip.zerver_realm USING btree (notifications_stream_id);


--
-- Name: zerver_realm_signup_notifications_stream_id_1e735af4; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_signup_notifications_stream_id_1e735af4 ON zulip.zerver_realm USING btree (signup_notifications_stream_id);


--
-- Name: zerver_realm_subdomain_375be8b1_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_subdomain_375be8b1_like ON zulip.zerver_realm USING btree (string_id varchar_pattern_ops);


--
-- Name: zerver_realm_want_advertise_in_communities_directory_0776d2a9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_want_advertise_in_communities_directory_0776d2a9 ON zulip.zerver_realm USING btree (want_advertise_in_communities_directory);


--
-- Name: zerver_realmalias_domain_6f7958a4; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmalias_domain_6f7958a4 ON zulip.zerver_realmdomain USING btree (domain);


--
-- Name: zerver_realmalias_domain_6f7958a4_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmalias_domain_6f7958a4_like ON zulip.zerver_realmdomain USING btree (domain varchar_pattern_ops);


--
-- Name: zerver_realmalias_realm_id_637779d9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmalias_realm_id_637779d9 ON zulip.zerver_realmdomain USING btree (realm_id);


--
-- Name: zerver_realmauditlog_acting_user_id_6d709cd1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_acting_user_id_6d709cd1 ON zulip.zerver_realmauditlog USING btree (acting_user_id);


--
-- Name: zerver_realmauditlog_event_time_799bd0ca; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_event_time_799bd0ca ON zulip.zerver_realmauditlog USING btree (event_time);


--
-- Name: zerver_realmauditlog_modified_stream_id_4de0252c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_modified_stream_id_4de0252c ON zulip.zerver_realmauditlog USING btree (modified_stream_id);


--
-- Name: zerver_realmauditlog_modified_user_id_fa063d3c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_modified_user_id_fa063d3c ON zulip.zerver_realmauditlog USING btree (modified_user_id);


--
-- Name: zerver_realmauditlog_realm_id_7d25fe8b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_realm_id_7d25fe8b ON zulip.zerver_realmauditlog USING btree (realm_id);


--
-- Name: zerver_realmauditlog_user_subscriptions_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_user_subscriptions_idx ON zulip.zerver_realmauditlog USING btree (modified_user_id, modified_stream_id) WHERE (event_type = ANY (ARRAY[301, 302, 303]));


--
-- Name: zerver_realmauthenticationmethod_realm_id_0ca07cff; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauthenticationmethod_realm_id_0ca07cff ON zulip.zerver_realmauthenticationmethod USING btree (realm_id);


--
-- Name: zerver_realmemoji_author_id_8a97bf3a; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmemoji_author_id_8a97bf3a ON zulip.zerver_realmemoji USING btree (author_id);


--
-- Name: zerver_realmemoji_file_name_90ccc2f4; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmemoji_file_name_90ccc2f4 ON zulip.zerver_realmemoji USING btree (file_name);


--
-- Name: zerver_realmemoji_file_name_90ccc2f4_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmemoji_file_name_90ccc2f4_like ON zulip.zerver_realmemoji USING btree (file_name text_pattern_ops);


--
-- Name: zerver_realmemoji_realm_id_2cd3dbd2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmemoji_realm_id_2cd3dbd2 ON zulip.zerver_realmemoji USING btree (realm_id);


--
-- Name: zerver_realmfilter_realm_id_7ea85a40; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmfilter_realm_id_7ea85a40 ON zulip.zerver_realmfilter USING btree (realm_id);


--
-- Name: zerver_realmplayground_name_018f9229; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmplayground_name_018f9229 ON zulip.zerver_realmplayground USING btree (name);


--
-- Name: zerver_realmplayground_name_018f9229_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmplayground_name_018f9229_like ON zulip.zerver_realmplayground USING btree (name text_pattern_ops);


--
-- Name: zerver_realmplayground_pygments_language_56f2a2b1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmplayground_pygments_language_56f2a2b1 ON zulip.zerver_realmplayground USING btree (pygments_language);


--
-- Name: zerver_realmplayground_pygments_language_56f2a2b1_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmplayground_pygments_language_56f2a2b1_like ON zulip.zerver_realmplayground USING btree (pygments_language varchar_pattern_ops);


--
-- Name: zerver_realmplayground_realm_id_094eff63; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmplayground_realm_id_094eff63 ON zulip.zerver_realmplayground USING btree (realm_id);


--
-- Name: zerver_realmreactivationstatus_realm_id_05a03673; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmreactivationstatus_realm_id_05a03673 ON zulip.zerver_realmreactivationstatus USING btree (realm_id);


--
-- Name: zerver_recipient_type_139dd891; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_recipient_type_139dd891 ON zulip.zerver_recipient USING btree (type);


--
-- Name: zerver_recipient_type_id_dbad0d89; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_recipient_type_id_dbad0d89 ON zulip.zerver_recipient USING btree (type_id);


--
-- Name: zerver_scheduledemail_address_13dadd43; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledemail_address_13dadd43 ON zulip.zerver_scheduledemail USING btree (address);


--
-- Name: zerver_scheduledemail_address_13dadd43_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledemail_address_13dadd43_like ON zulip.zerver_scheduledemail USING btree (address varchar_pattern_ops);


--
-- Name: zerver_scheduledemail_realm_id_b5fdb998; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledemail_realm_id_b5fdb998 ON zulip.zerver_scheduledemail USING btree (realm_id);


--
-- Name: zerver_scheduledemail_scheduled_timestamp_fc942cc1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledemail_scheduled_timestamp_fc942cc1 ON zulip.zerver_scheduledemail USING btree (scheduled_timestamp);


--
-- Name: zerver_scheduledemail_users_scheduledemail_id_792d525e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledemail_users_scheduledemail_id_792d525e ON zulip.zerver_scheduledemail_users USING btree (scheduledemail_id);


--
-- Name: zerver_scheduledemail_users_userprofile_id_7e3109ee; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledemail_users_userprofile_id_7e3109ee ON zulip.zerver_scheduledemail_users USING btree (userprofile_id);


--
-- Name: zerver_scheduledmessage_delivered_message_id_e971c426; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessage_delivered_message_id_e971c426 ON zulip.zerver_scheduledmessage USING btree (delivered_message_id);


--
-- Name: zerver_scheduledmessage_has_attachment_99be5ced; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessage_has_attachment_99be5ced ON zulip.zerver_scheduledmessage USING btree (has_attachment);


--
-- Name: zerver_scheduledmessage_realm_id_9111bebd; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessage_realm_id_9111bebd ON zulip.zerver_scheduledmessage USING btree (realm_id);


--
-- Name: zerver_scheduledmessage_recipient_id_3eeb838b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessage_recipient_id_3eeb838b ON zulip.zerver_scheduledmessage USING btree (recipient_id);


--
-- Name: zerver_scheduledmessage_scheduled_timestamp_bdc67eab; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessage_scheduled_timestamp_bdc67eab ON zulip.zerver_scheduledmessage USING btree (scheduled_timestamp);


--
-- Name: zerver_scheduledmessage_sender_id_59505f98; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessage_sender_id_59505f98 ON zulip.zerver_scheduledmessage USING btree (sender_id);


--
-- Name: zerver_scheduledmessage_sending_client_id_5e82bf79; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessage_sending_client_id_5e82bf79 ON zulip.zerver_scheduledmessage USING btree (sending_client_id);


--
-- Name: zerver_scheduledmessage_stream_id_45dc289f; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessage_stream_id_45dc289f ON zulip.zerver_scheduledmessage USING btree (stream_id);


--
-- Name: zerver_scheduledmessagenot_mentioned_user_group_id_6c2b438d; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessagenot_mentioned_user_group_id_6c2b438d ON zulip.zerver_scheduledmessagenotificationemail USING btree (mentioned_user_group_id);


--
-- Name: zerver_scheduledmessagenot_scheduled_timestamp_2efaaa06; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessagenot_scheduled_timestamp_2efaaa06 ON zulip.zerver_scheduledmessagenotificationemail USING btree (scheduled_timestamp);


--
-- Name: zerver_scheduledmessagenot_user_profile_id_2afc4b4e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessagenot_user_profile_id_2afc4b4e ON zulip.zerver_scheduledmessagenotificationemail USING btree (user_profile_id);


--
-- Name: zerver_scheduledmessagenotificationemail_message_id_532f475c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_scheduledmessagenotificationemail_message_id_532f475c ON zulip.zerver_scheduledmessagenotificationemail USING btree (message_id);


--
-- Name: zerver_service_user_profile_id_111b0c49; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_service_user_profile_id_111b0c49 ON zulip.zerver_service USING btree (user_profile_id);


--
-- Name: zerver_stream_can_remove_subscribers_group_id_ce4fe4b7; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_can_remove_subscribers_group_id_ce4fe4b7 ON zulip.zerver_stream USING btree (can_remove_subscribers_group_id);


--
-- Name: zerver_stream_email_token_8a608bf8_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_email_token_8a608bf8_like ON zulip.zerver_stream USING btree (email_token varchar_pattern_ops);


--
-- Name: zerver_stream_first_message_id_9fa3a185; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_first_message_id_9fa3a185 ON zulip.zerver_stream USING btree (first_message_id);


--
-- Name: zerver_stream_name_2e0a6cd8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_name_2e0a6cd8 ON zulip.zerver_stream USING btree (name);


--
-- Name: zerver_stream_name_2e0a6cd8_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_name_2e0a6cd8_like ON zulip.zerver_stream USING btree (name varchar_pattern_ops);


--
-- Name: zerver_stream_realm_id_0d562dbb; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_realm_id_0d562dbb ON zulip.zerver_stream USING btree (realm_id);


--
-- Name: zerver_stream_realm_id_name_uniq; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX zerver_stream_realm_id_name_uniq ON zulip.zerver_stream USING btree (realm_id, upper((name)::text));


--
-- Name: zerver_stream_recipient_id_85263e1b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_recipient_id_85263e1b ON zulip.zerver_stream USING btree (recipient_id);


--
-- Name: zerver_submessage_message_id_6d3b8d8e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_submessage_message_id_6d3b8d8e ON zulip.zerver_submessage USING btree (message_id);


--
-- Name: zerver_submessage_sender_id_b1aa97b8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_submessage_sender_id_b1aa97b8 ON zulip.zerver_submessage USING btree (sender_id);


--
-- Name: zerver_subscription_recipient_id_1e90e2cc; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_subscription_recipient_id_1e90e2cc ON zulip.zerver_subscription USING btree (recipient_id);


--
-- Name: zerver_subscription_recipient_id_user_profile_id_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_subscription_recipient_id_user_profile_id_idx ON zulip.zerver_subscription USING btree (recipient_id, user_profile_id) WHERE (active AND is_user_active);


--
-- Name: zerver_subscription_user_profile_id_1773aa42; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_subscription_user_profile_id_1773aa42 ON zulip.zerver_subscription USING btree (user_profile_id);


--
-- Name: zerver_unsent_scheduled_messages_by_time; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_unsent_scheduled_messages_by_time ON zulip.zerver_scheduledmessage USING btree (scheduled_timestamp) WHERE ((NOT delivered) AND (NOT failed));


--
-- Name: zerver_unsent_scheduled_messages_by_user; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_unsent_scheduled_messages_by_user ON zulip.zerver_scheduledmessage USING btree (sender_id, delivery_type, scheduled_timestamp) WHERE (NOT delivered);


--
-- Name: zerver_useractivity_client_id_bb848fef; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_useractivity_client_id_bb848fef ON zulip.zerver_useractivity USING btree (client_id);


--
-- Name: zerver_useractivity_query_31cd9b6d; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_useractivity_query_31cd9b6d ON zulip.zerver_useractivity USING btree (query);


--
-- Name: zerver_useractivity_query_31cd9b6d_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_useractivity_query_31cd9b6d_like ON zulip.zerver_useractivity USING btree (query varchar_pattern_ops);


--
-- Name: zerver_useractivity_user_profile_id_3f3c3ea8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_useractivity_user_profile_id_3f3c3ea8 ON zulip.zerver_useractivity USING btree (user_profile_id);


--
-- Name: zerver_useractivityinterval_end_4a0219d2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_useractivityinterval_end_4a0219d2 ON zulip.zerver_useractivityinterval USING btree ("end");


--
-- Name: zerver_useractivityinterval_start_d5797442; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_useractivityinterval_start_d5797442 ON zulip.zerver_useractivityinterval USING btree (start);


--
-- Name: zerver_useractivityinterval_user_profile_id_634623af; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_useractivityinterval_user_profile_id_634623af ON zulip.zerver_useractivityinterval USING btree (user_profile_id);


--
-- Name: zerver_useractivityinterval_user_profile_id_end_bb3bfc37_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_useractivityinterval_user_profile_id_end_bb3bfc37_idx ON zulip.zerver_useractivityinterval USING btree (user_profile_id, "end");


--
-- Name: zerver_usergroup_realm_id_8b78d3b3; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usergroup_realm_id_8b78d3b3 ON zulip.zerver_usergroup USING btree (realm_id);


--
-- Name: zerver_usergroupmembership_user_group_id_7722d5a1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usergroupmembership_user_group_id_7722d5a1 ON zulip.zerver_usergroupmembership USING btree (user_group_id);


--
-- Name: zerver_usergroupmembership_user_profile_id_6aa688e2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usergroupmembership_user_profile_id_6aa688e2 ON zulip.zerver_usergroupmembership USING btree (user_profile_id);


--
-- Name: zerver_userhotspot_user_id_26216f4c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userhotspot_user_id_26216f4c ON zulip.zerver_userhotspot USING btree (user_id);


--
-- Name: zerver_usermessage_active_mobile_push_notification_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_active_mobile_push_notification_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE ((flags & (4096)::bigint) <> 0);


--
-- Name: zerver_usermessage_has_alert_word_message_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_has_alert_word_message_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE ((flags & (512)::bigint) <> 0);


--
-- Name: zerver_usermessage_is_private_message_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_is_private_message_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE ((flags & (2048)::bigint) <> 0);


--
-- Name: zerver_usermessage_mentioned_message_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_mentioned_message_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE ((flags & (8)::bigint) <> 0);


--
-- Name: zerver_usermessage_message_id_f6e63a33; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_message_id_f6e63a33 ON zulip.zerver_usermessage USING btree (message_id);


--
-- Name: zerver_usermessage_starred_message_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_starred_message_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE ((flags & (2)::bigint) <> 0);


--
-- Name: zerver_usermessage_unread_message_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_unread_message_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE ((flags & (1)::bigint) = 0);


--
-- Name: zerver_usermessage_user_profile_id_e901f3b7; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_user_profile_id_e901f3b7 ON zulip.zerver_usermessage USING btree (user_profile_id);


--
-- Name: zerver_usermessage_wildcard_mentioned_message_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_wildcard_mentioned_message_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE (((flags & (8)::bigint) <> 0) OR ((flags & (16)::bigint) <> 0));


--
-- Name: zerver_userpresence_last_active_time_208e334b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_last_active_time_208e334b ON zulip.zerver_userpresence USING btree (last_active_time);


--
-- Name: zerver_userpresence_last_connected_time_19294af2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_last_connected_time_19294af2 ON zulip.zerver_userpresence USING btree (last_connected_time);


--
-- Name: zerver_userpresence_realm_id_5c4ef5a9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_realm_id_5c4ef5a9 ON zulip.zerver_userpresence USING btree (realm_id);


--
-- Name: zerver_userpresence_realm_id_last_active_time_1c5aa9a2_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_realm_id_last_active_time_1c5aa9a2_idx ON zulip.zerver_userpresence USING btree (realm_id, last_active_time);


--
-- Name: zerver_userpresence_realm_id_last_connected_time_98d2fc9f_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_realm_id_last_connected_time_98d2fc9f_idx ON zulip.zerver_userpresence USING btree (realm_id, last_connected_time);


--
-- Name: zerver_userprofile_api_key_63599ac6_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_api_key_63599ac6_like ON zulip.zerver_userprofile USING btree (api_key varchar_pattern_ops);


--
-- Name: zerver_userprofile_bot_owner_id_01a815f5; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_bot_owner_id_01a815f5 ON zulip.zerver_userprofile USING btree (bot_owner_id);


--
-- Name: zerver_userprofile_bot_type_9ad9b625; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_bot_type_9ad9b625 ON zulip.zerver_userprofile USING btree (bot_type);


--
-- Name: zerver_userprofile_can_create_users_7a0f136d; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_can_create_users_7a0f136d ON zulip.zerver_userprofile USING btree (can_create_users);


--
-- Name: zerver_userprofile_default_events_register_stream_id_40e28493; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_default_events_register_stream_id_40e28493 ON zulip.zerver_userprofile USING btree (default_events_register_stream_id);


--
-- Name: zerver_userprofile_default_sending_stream_id_3ba7368b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_default_sending_stream_id_3ba7368b ON zulip.zerver_userprofile USING btree (default_sending_stream_id);


--
-- Name: zerver_userprofile_delivery_email_d4f2145b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_delivery_email_d4f2145b ON zulip.zerver_userprofile USING btree (delivery_email);


--
-- Name: zerver_userprofile_delivery_email_d4f2145b_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_delivery_email_d4f2145b_like ON zulip.zerver_userprofile USING btree (delivery_email varchar_pattern_ops);


--
-- Name: zerver_userprofile_email_d1230b80; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_email_d1230b80 ON zulip.zerver_userprofile USING btree (email);


--
-- Name: zerver_userprofile_email_d1230b80_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_email_d1230b80_like ON zulip.zerver_userprofile USING btree (email varchar_pattern_ops);


--
-- Name: zerver_userprofile_groups_group_id_4ffff873; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_groups_group_id_4ffff873 ON zulip.zerver_userprofile_groups USING btree (group_id);


--
-- Name: zerver_userprofile_groups_userprofile_id_340abcf4; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_groups_userprofile_id_340abcf4 ON zulip.zerver_userprofile_groups USING btree (userprofile_id);


--
-- Name: zerver_userprofile_is_active_d6236522; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_is_active_d6236522 ON zulip.zerver_userprofile USING btree (is_active);


--
-- Name: zerver_userprofile_is_api_super_user_002d4edd; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_is_api_super_user_002d4edd ON zulip.zerver_userprofile USING btree (can_forge_sender);


--
-- Name: zerver_userprofile_is_billing_admin_97c068c8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_is_billing_admin_97c068c8 ON zulip.zerver_userprofile USING btree (is_billing_admin);


--
-- Name: zerver_userprofile_is_bot_a00f598e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_is_bot_a00f598e ON zulip.zerver_userprofile USING btree (is_bot);


--
-- Name: zerver_userprofile_long_term_idle_5c9c49af; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_long_term_idle_5c9c49af ON zulip.zerver_userprofile USING btree (long_term_idle);


--
-- Name: zerver_userprofile_realm_id_d8908535; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_realm_id_d8908535 ON zulip.zerver_userprofile USING btree (realm_id);


--
-- Name: zerver_userprofile_realm_id_delivery_email_uniq; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX zerver_userprofile_realm_id_delivery_email_uniq ON zulip.zerver_userprofile USING btree (realm_id, upper((delivery_email)::text));


--
-- Name: zerver_userprofile_realm_id_email_uniq; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE UNIQUE INDEX zerver_userprofile_realm_id_email_uniq ON zulip.zerver_userprofile USING btree (realm_id, upper((email)::text));


--
-- Name: zerver_userprofile_recipient_id_d5853e31; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_recipient_id_d5853e31 ON zulip.zerver_userprofile USING btree (recipient_id);


--
-- Name: zerver_userprofile_role_c0a137e0; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_role_c0a137e0 ON zulip.zerver_userprofile USING btree (role);


--
-- Name: zerver_userprofile_user_permissions_permission_id_5dd655ef; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_user_permissions_permission_id_5dd655ef ON zulip.zerver_userprofile_user_permissions USING btree (permission_id);


--
-- Name: zerver_userprofile_user_permissions_userprofile_id_b508a4b1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_user_permissions_userprofile_id_b508a4b1 ON zulip.zerver_userprofile_user_permissions USING btree (userprofile_id);


--
-- Name: zerver_userstatus_client_id_9010b464; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userstatus_client_id_9010b464 ON zulip.zerver_userstatus USING btree (client_id);


--
-- Name: zerver_usertopic_stream_topic_user_visibility_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usertopic_stream_topic_user_visibility_idx ON zulip.zerver_usertopic USING btree (stream_id, topic_name, visibility_policy, user_profile_id);


--
-- Name: zerver_usertopic_user_visibility_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usertopic_user_visibility_idx ON zulip.zerver_usertopic USING btree (user_profile_id, visibility_policy, stream_id, topic_name);


--
-- Name: fts_update_log fts_update_log_notify; Type: TRIGGER; Schema: zulip; Owner: zulip
--

CREATE TRIGGER fts_update_log_notify AFTER INSERT ON zulip.fts_update_log FOR EACH STATEMENT EXECUTE FUNCTION zulip.do_notify_fts_update_log();


--
-- Name: zerver_message zerver_message_update_search_tsvector_async; Type: TRIGGER; Schema: zulip; Owner: zulip
--

CREATE TRIGGER zerver_message_update_search_tsvector_async BEFORE INSERT OR UPDATE OF subject, rendered_content ON zulip.zerver_message FOR EACH ROW EXECUTE FUNCTION zulip.append_to_fts_update_log();


--
-- Name: analytics_realmcount analytics_realmcount_realm_id_9fccfcfb_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_realmcount
    ADD CONSTRAINT analytics_realmcount_realm_id_9fccfcfb_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: analytics_streamcount analytics_streamcount_realm_id_2e51c13a_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_streamcount
    ADD CONSTRAINT analytics_streamcount_realm_id_2e51c13a_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: analytics_streamcount analytics_streamcount_stream_id_e1168935_fk_zerver_stream_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_streamcount
    ADD CONSTRAINT analytics_streamcount_stream_id_e1168935_fk_zerver_stream_id FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: analytics_usercount analytics_usercount_realm_id_7215e926_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_usercount
    ADD CONSTRAINT analytics_usercount_realm_id_7215e926_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: analytics_usercount analytics_usercount_user_id_2e9aca8a_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_usercount
    ADD CONSTRAINT analytics_usercount_user_id_2e9aca8a_fk_zerver_userprofile_id FOREIGN KEY (user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES zulip.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES zulip.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES zulip.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: confirmation_confirmation confirmation_confirm_content_type_id_a55c95ef_fk_django_co; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.confirmation_confirmation
    ADD CONSTRAINT confirmation_confirm_content_type_id_a55c95ef_fk_django_co FOREIGN KEY (content_type_id) REFERENCES zulip.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: confirmation_confirmation confirmation_confirmation_realm_id_80c5f350_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.confirmation_confirmation
    ADD CONSTRAINT confirmation_confirmation_realm_id_80c5f350_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_static_staticdevice otp_static_staticdev_user_id_7f9cff2b_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_static_staticdevice
    ADD CONSTRAINT otp_static_staticdev_user_id_7f9cff2b_fk_zerver_us FOREIGN KEY (user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_static_statictoken otp_static_statictok_device_id_74b7c7d1_fk_otp_stati; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_static_statictoken
    ADD CONSTRAINT otp_static_statictok_device_id_74b7c7d1_fk_otp_stati FOREIGN KEY (device_id) REFERENCES zulip.otp_static_staticdevice(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: otp_totp_totpdevice otp_totp_totpdevice_user_id_0fb18292_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.otp_totp_totpdevice
    ADD CONSTRAINT otp_totp_totpdevice_user_id_0fb18292_fk_zerver_userprofile_id FOREIGN KEY (user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: social_auth_usersocialauth social_auth_usersoci_user_id_17d28448_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.social_auth_usersocialauth
    ADD CONSTRAINT social_auth_usersoci_user_id_17d28448_fk_zerver_us FOREIGN KEY (user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: two_factor_phonedevice two_factor_phonedevi_user_id_54718003_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.two_factor_phonedevice
    ADD CONSTRAINT two_factor_phonedevi_user_id_54718003_fk_zerver_us FOREIGN KEY (user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_alertword zerver_alertword_realm_id_feaa54a2_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_alertword
    ADD CONSTRAINT zerver_alertword_realm_id_feaa54a2_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_alertword zerver_alertword_user_profile_id_03150ab2_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_alertword
    ADD CONSTRAINT zerver_alertword_user_profile_id_03150ab2_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedattachment_messages zerver_archivedattac_archivedattachment_i_1b7d6694_fk_zerver_ar; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment_messages
    ADD CONSTRAINT zerver_archivedattac_archivedattachment_i_1b7d6694_fk_zerver_ar FOREIGN KEY (archivedattachment_id) REFERENCES zulip.zerver_archivedattachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedattachment_messages zerver_archivedattac_archivedmessage_id_e67eb490_fk_zerver_ar; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment_messages
    ADD CONSTRAINT zerver_archivedattac_archivedmessage_id_e67eb490_fk_zerver_ar FOREIGN KEY (archivedmessage_id) REFERENCES zulip.zerver_archivedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedattachment zerver_archivedattac_owner_id_abd89ced_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment
    ADD CONSTRAINT zerver_archivedattac_owner_id_abd89ced_fk_zerver_us FOREIGN KEY (owner_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedattachment zerver_archivedattachment_realm_id_95fb78cc_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment
    ADD CONSTRAINT zerver_archivedattachment_realm_id_95fb78cc_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedmessage zerver_archivedmessa_archive_transaction__3f0a7f7b_fk_zerver_ar; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedmessage
    ADD CONSTRAINT zerver_archivedmessa_archive_transaction__3f0a7f7b_fk_zerver_ar FOREIGN KEY (archive_transaction_id) REFERENCES zulip.zerver_archivetransaction(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedmessage zerver_archivedmessa_recipient_id_2d004795_fk_zerver_re; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedmessage
    ADD CONSTRAINT zerver_archivedmessa_recipient_id_2d004795_fk_zerver_re FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedmessage zerver_archivedmessa_sender_id_1bb891e6_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedmessage
    ADD CONSTRAINT zerver_archivedmessa_sender_id_1bb891e6_fk_zerver_us FOREIGN KEY (sender_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedmessage zerver_archivedmessa_sending_client_id_0f31bdd0_fk_zerver_cl; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedmessage
    ADD CONSTRAINT zerver_archivedmessa_sending_client_id_0f31bdd0_fk_zerver_cl FOREIGN KEY (sending_client_id) REFERENCES zulip.zerver_client(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedmessage zerver_archivedmessage_realm_id_fab86889_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedmessage
    ADD CONSTRAINT zerver_archivedmessage_realm_id_fab86889_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedreaction zerver_archivedreact_message_id_080a41fe_fk_zerver_ar; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedreaction
    ADD CONSTRAINT zerver_archivedreact_message_id_080a41fe_fk_zerver_ar FOREIGN KEY (message_id) REFERENCES zulip.zerver_archivedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedreaction zerver_archivedreact_user_profile_id_4cb7a2cc_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedreaction
    ADD CONSTRAINT zerver_archivedreact_user_profile_id_4cb7a2cc_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedsubmessage zerver_archivedsubme_message_id_e20a2a2d_fk_zerver_ar; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedsubmessage
    ADD CONSTRAINT zerver_archivedsubme_message_id_e20a2a2d_fk_zerver_ar FOREIGN KEY (message_id) REFERENCES zulip.zerver_archivedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedsubmessage zerver_archivedsubme_sender_id_c197a583_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedsubmessage
    ADD CONSTRAINT zerver_archivedsubme_sender_id_c197a583_fk_zerver_us FOREIGN KEY (sender_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedusermessage zerver_archiveduserm_message_id_5ef4f254_fk_zerver_ar; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedusermessage
    ADD CONSTRAINT zerver_archiveduserm_message_id_5ef4f254_fk_zerver_ar FOREIGN KEY (message_id) REFERENCES zulip.zerver_archivedmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedusermessage zerver_archiveduserm_user_profile_id_1fe3817a_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedusermessage
    ADD CONSTRAINT zerver_archiveduserm_user_profile_id_1fe3817a_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivetransaction zerver_archivetransaction_realm_id_81a3b8dd_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivetransaction
    ADD CONSTRAINT zerver_archivetransaction_realm_id_81a3b8dd_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_attachment_messages zerver_attachment_me_attachment_id_eb4e59c0_fk_zerver_at; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_messages
    ADD CONSTRAINT zerver_attachment_me_attachment_id_eb4e59c0_fk_zerver_at FOREIGN KEY (attachment_id) REFERENCES zulip.zerver_attachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_attachment_messages zerver_attachment_me_message_id_c5e566fb_fk_zerver_me; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_messages
    ADD CONSTRAINT zerver_attachment_me_message_id_c5e566fb_fk_zerver_me FOREIGN KEY (message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_attachment zerver_attachment_owner_id_b40072c4_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment
    ADD CONSTRAINT zerver_attachment_owner_id_b40072c4_fk_zerver_userprofile_id FOREIGN KEY (owner_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_attachment zerver_attachment_realm_id_f8e3c906_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment
    ADD CONSTRAINT zerver_attachment_realm_id_f8e3c906_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_attachment_scheduled_messages zerver_attachment_sc_attachment_id_03da128c_fk_zerver_at; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_scheduled_messages
    ADD CONSTRAINT zerver_attachment_sc_attachment_id_03da128c_fk_zerver_at FOREIGN KEY (attachment_id) REFERENCES zulip.zerver_attachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_attachment_scheduled_messages zerver_attachment_sc_scheduledmessage_id_27c3f026_fk_zerver_sc; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_scheduled_messages
    ADD CONSTRAINT zerver_attachment_sc_scheduledmessage_id_27c3f026_fk_zerver_sc FOREIGN KEY (scheduledmessage_id) REFERENCES zulip.zerver_scheduledmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_botconfigdata zerver_botuserconfig_bot_profile_id_7055bf8c_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botconfigdata
    ADD CONSTRAINT zerver_botuserconfig_bot_profile_id_7055bf8c_fk_zerver_us FOREIGN KEY (bot_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_botstoragedata zerver_botuserstated_bot_profile_id_861ccb8a_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botstoragedata
    ADD CONSTRAINT zerver_botuserstated_bot_profile_id_861ccb8a_fk_zerver_us FOREIGN KEY (bot_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_customprofilefieldvalue zerver_customprofile_field_id_00409129_fk_zerver_cu; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefieldvalue
    ADD CONSTRAINT zerver_customprofile_field_id_00409129_fk_zerver_cu FOREIGN KEY (field_id) REFERENCES zulip.zerver_customprofilefield(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_customprofilefieldvalue zerver_customprofile_user_profile_id_24d4820f_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefieldvalue
    ADD CONSTRAINT zerver_customprofile_user_profile_id_24d4820f_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_customprofilefield zerver_customprofilefield_realm_id_b0de0439_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefield
    ADD CONSTRAINT zerver_customprofilefield_realm_id_b0de0439_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstreamgroup_streams zerver_defaultstream_defaultstreamgroup_i_bd9739b9_fk_zerver_de; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup_streams
    ADD CONSTRAINT zerver_defaultstream_defaultstreamgroup_i_bd9739b9_fk_zerver_de FOREIGN KEY (defaultstreamgroup_id) REFERENCES zulip.zerver_defaultstreamgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstream zerver_defaultstream_realm_id_b5f0faf3_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstream
    ADD CONSTRAINT zerver_defaultstream_realm_id_b5f0faf3_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstreamgroup_streams zerver_defaultstream_stream_id_9844331d_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup_streams
    ADD CONSTRAINT zerver_defaultstream_stream_id_9844331d_fk_zerver_st FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstream zerver_defaultstream_stream_id_9a8e0616_fk_zerver_stream_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstream
    ADD CONSTRAINT zerver_defaultstream_stream_id_9a8e0616_fk_zerver_stream_id FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstreamgroup zerver_defaultstreamgroup_realm_id_b15f3495_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup
    ADD CONSTRAINT zerver_defaultstreamgroup_realm_id_b15f3495_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_draft zerver_draft_recipient_id_b9b91732_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_draft
    ADD CONSTRAINT zerver_draft_recipient_id_b9b91732_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_draft zerver_draft_user_profile_id_4a215f11_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_draft
    ADD CONSTRAINT zerver_draft_user_profile_id_4a215f11_fk_zerver_userprofile_id FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_emailchangestatus zerver_emailchangest_user_profile_id_908b1af2_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_emailchangestatus
    ADD CONSTRAINT zerver_emailchangest_user_profile_id_908b1af2_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_emailchangestatus zerver_emailchangestatus_realm_id_a68b9be8_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_emailchangestatus
    ADD CONSTRAINT zerver_emailchangestatus_realm_id_a68b9be8_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_groupgroupmembership zerver_groupgroupmem_subgroup_id_3ec521bb_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_groupgroupmembership
    ADD CONSTRAINT zerver_groupgroupmem_subgroup_id_3ec521bb_fk_zerver_us FOREIGN KEY (subgroup_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_groupgroupmembership zerver_groupgroupmem_supergroup_id_3874b6ef_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_groupgroupmembership
    ADD CONSTRAINT zerver_groupgroupmem_supergroup_id_3874b6ef_fk_zerver_us FOREIGN KEY (supergroup_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_huddle zerver_huddle_recipient_id_e3e1fadc_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_huddle
    ADD CONSTRAINT zerver_huddle_recipient_id_e3e1fadc_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_message zerver_message_realm_id_849a39c8_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_message
    ADD CONSTRAINT zerver_message_realm_id_849a39c8_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_message zerver_message_recipient_id_5a7b6f03_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_message
    ADD CONSTRAINT zerver_message_recipient_id_5a7b6f03_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_message zerver_message_sender_id_77b89151_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_message
    ADD CONSTRAINT zerver_message_sender_id_77b89151_fk_zerver_userprofile_id FOREIGN KEY (sender_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_message zerver_message_sending_client_id_1c38413f_fk_zerver_client_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_message
    ADD CONSTRAINT zerver_message_sending_client_id_1c38413f_fk_zerver_client_id FOREIGN KEY (sending_client_id) REFERENCES zulip.zerver_client(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_missedmessageemailaddress zerver_missedmessage_message_id_98361e8c_fk_zerver_me; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_missedmessageemailaddress
    ADD CONSTRAINT zerver_missedmessage_message_id_98361e8c_fk_zerver_me FOREIGN KEY (message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_missedmessageemailaddress zerver_missedmessage_user_profile_id_2d530260_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_missedmessageemailaddress
    ADD CONSTRAINT zerver_missedmessage_user_profile_id_2d530260_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite_streams zerver_multiuseinvit_multiuseinvite_id_be033d7f_fk_zerver_mu; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_streams
    ADD CONSTRAINT zerver_multiuseinvit_multiuseinvite_id_be033d7f_fk_zerver_mu FOREIGN KEY (multiuseinvite_id) REFERENCES zulip.zerver_multiuseinvite(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite zerver_multiuseinvit_referred_by_id_8970bd5c_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite
    ADD CONSTRAINT zerver_multiuseinvit_referred_by_id_8970bd5c_fk_zerver_us FOREIGN KEY (referred_by_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite_streams zerver_multiuseinvit_stream_id_2cb97168_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_streams
    ADD CONSTRAINT zerver_multiuseinvit_stream_id_2cb97168_fk_zerver_st FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite zerver_multiuseinvite_realm_id_8eb19d52_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite
    ADD CONSTRAINT zerver_multiuseinvite_realm_id_8eb19d52_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usertopic zerver_mutedtopic_recipient_id_e1901302_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_mutedtopic_recipient_id_e1901302_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usertopic zerver_mutedtopic_stream_id_acbff20e_fk_zerver_stream_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_mutedtopic_stream_id_acbff20e_fk_zerver_stream_id FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usertopic zerver_mutedtopic_user_profile_id_4f8a692c_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_mutedtopic_user_profile_id_4f8a692c_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_muteduser zerver_muteduser_muted_user_id_d4b66dff_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_muteduser
    ADD CONSTRAINT zerver_muteduser_muted_user_id_d4b66dff_fk_zerver_us FOREIGN KEY (muted_user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_muteduser zerver_muteduser_user_profile_id_aeb57a40_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_muteduser
    ADD CONSTRAINT zerver_muteduser_user_profile_id_aeb57a40_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationrealm zerver_preregistrati_created_realm_id_0c7c7c75_fk_zerver_re; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationrealm
    ADD CONSTRAINT zerver_preregistrati_created_realm_id_0c7c7c75_fk_zerver_re FOREIGN KEY (created_realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser zerver_preregistrati_created_user_id_2c23181e_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrati_created_user_id_2c23181e_fk_zerver_us FOREIGN KEY (created_user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationrealm zerver_preregistrati_created_user_id_6d6d4d55_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationrealm
    ADD CONSTRAINT zerver_preregistrati_created_user_id_6d6d4d55_fk_zerver_us FOREIGN KEY (created_user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser zerver_preregistrati_multiuse_invite_id_7747603e_fk_zerver_mu; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrati_multiuse_invite_id_7747603e_fk_zerver_mu FOREIGN KEY (multiuse_invite_id) REFERENCES zulip.zerver_multiuseinvite(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser_streams zerver_preregistrati_preregistrationuser__332ca855_fk_zerver_pr; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams
    ADD CONSTRAINT zerver_preregistrati_preregistrationuser__332ca855_fk_zerver_pr FOREIGN KEY (preregistrationuser_id) REFERENCES zulip.zerver_preregistrationuser(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser zerver_preregistrati_referred_by_id_51f0a793_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrati_referred_by_id_51f0a793_fk_zerver_us FOREIGN KEY (referred_by_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser_streams zerver_preregistrati_stream_id_29da6767_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams
    ADD CONSTRAINT zerver_preregistrati_stream_id_29da6767_fk_zerver_st FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser zerver_preregistrationuser_realm_id_fd5aff83_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrationuser_realm_id_fd5aff83_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_pushdevicetoken zerver_pushdevicetok_user_id_015e5dc1_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_pushdevicetoken
    ADD CONSTRAINT zerver_pushdevicetok_user_id_015e5dc1_fk_zerver_us FOREIGN KEY (user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_reaction zerver_reaction_message_id_e5e820a6_fk_zerver_message_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_reaction
    ADD CONSTRAINT zerver_reaction_message_id_e5e820a6_fk_zerver_message_id FOREIGN KEY (message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_reaction zerver_reaction_user_profile_id_468ce1ef_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_reaction
    ADD CONSTRAINT zerver_reaction_user_profile_id_468ce1ef_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_notifications_stream_f07609e9_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_notifications_stream_f07609e9_fk_zerver_st FOREIGN KEY (notifications_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_signup_notifications_1e735af4_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_signup_notifications_1e735af4_fk_zerver_st FOREIGN KEY (signup_notifications_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmdomain zerver_realmalias_realm_id_637779d9_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmdomain
    ADD CONSTRAINT zerver_realmalias_realm_id_637779d9_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmauditlog zerver_realmauditlog_acting_user_id_6d709cd1_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog
    ADD CONSTRAINT zerver_realmauditlog_acting_user_id_6d709cd1_fk_zerver_us FOREIGN KEY (acting_user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmauditlog zerver_realmauditlog_modified_stream_id_4de0252c_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog
    ADD CONSTRAINT zerver_realmauditlog_modified_stream_id_4de0252c_fk_zerver_st FOREIGN KEY (modified_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmauditlog zerver_realmauditlog_modified_user_id_fa063d3c_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog
    ADD CONSTRAINT zerver_realmauditlog_modified_user_id_fa063d3c_fk_zerver_us FOREIGN KEY (modified_user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmauditlog zerver_realmauditlog_realm_id_7d25fe8b_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog
    ADD CONSTRAINT zerver_realmauditlog_realm_id_7d25fe8b_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmauthenticationmethod zerver_realmauthenti_realm_id_0ca07cff_fk_zerver_re; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauthenticationmethod
    ADD CONSTRAINT zerver_realmauthenti_realm_id_0ca07cff_fk_zerver_re FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmemoji zerver_realmemoji_author_id_8a97bf3a_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmemoji
    ADD CONSTRAINT zerver_realmemoji_author_id_8a97bf3a_fk_zerver_userprofile_id FOREIGN KEY (author_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmemoji zerver_realmemoji_realm_id_2cd3dbd2_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmemoji
    ADD CONSTRAINT zerver_realmemoji_realm_id_2cd3dbd2_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmfilter zerver_realmfilter_realm_id_7ea85a40_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmfilter
    ADD CONSTRAINT zerver_realmfilter_realm_id_7ea85a40_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmplayground zerver_realmplayground_realm_id_094eff63_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmplayground
    ADD CONSTRAINT zerver_realmplayground_realm_id_094eff63_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmreactivationstatus zerver_realmreactiva_realm_id_05a03673_fk_zerver_re; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmreactivationstatus
    ADD CONSTRAINT zerver_realmreactiva_realm_id_05a03673_fk_zerver_re FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmuserdefault zerver_realmuserdefault_realm_id_0cb9cdb9_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmuserdefault
    ADD CONSTRAINT zerver_realmuserdefault_realm_id_0cb9cdb9_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledemail_users zerver_scheduledemai_scheduledemail_id_792d525e_fk_zerver_sc; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail_users
    ADD CONSTRAINT zerver_scheduledemai_scheduledemail_id_792d525e_fk_zerver_sc FOREIGN KEY (scheduledemail_id) REFERENCES zulip.zerver_scheduledemail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledemail_users zerver_scheduledemai_userprofile_id_7e3109ee_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail_users
    ADD CONSTRAINT zerver_scheduledemai_userprofile_id_7e3109ee_fk_zerver_us FOREIGN KEY (userprofile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledemail zerver_scheduledemail_realm_id_b5fdb998_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail
    ADD CONSTRAINT zerver_scheduledemail_realm_id_b5fdb998_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessage zerver_scheduledmess_delivered_message_id_e971c426_fk_zerver_me; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmess_delivered_message_id_e971c426_fk_zerver_me FOREIGN KEY (delivered_message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessagenotificationemail zerver_scheduledmess_mentioned_user_group_6c2b438d_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessagenotificationemail
    ADD CONSTRAINT zerver_scheduledmess_mentioned_user_group_6c2b438d_fk_zerver_us FOREIGN KEY (mentioned_user_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessagenotificationemail zerver_scheduledmess_message_id_532f475c_fk_zerver_me; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessagenotificationemail
    ADD CONSTRAINT zerver_scheduledmess_message_id_532f475c_fk_zerver_me FOREIGN KEY (message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessage zerver_scheduledmess_recipient_id_3eeb838b_fk_zerver_re; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmess_recipient_id_3eeb838b_fk_zerver_re FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessage zerver_scheduledmess_sender_id_59505f98_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmess_sender_id_59505f98_fk_zerver_us FOREIGN KEY (sender_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessage zerver_scheduledmess_sending_client_id_5e82bf79_fk_zerver_cl; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmess_sending_client_id_5e82bf79_fk_zerver_cl FOREIGN KEY (sending_client_id) REFERENCES zulip.zerver_client(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessagenotificationemail zerver_scheduledmess_user_profile_id_2afc4b4e_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessagenotificationemail
    ADD CONSTRAINT zerver_scheduledmess_user_profile_id_2afc4b4e_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessage zerver_scheduledmessage_realm_id_9111bebd_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmessage_realm_id_9111bebd_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessage zerver_scheduledmessage_stream_id_45dc289f_fk_zerver_stream_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmessage_stream_id_45dc289f_fk_zerver_stream_id FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_service zerver_service_user_profile_id_111b0c49_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_service
    ADD CONSTRAINT zerver_service_user_profile_id_111b0c49_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_can_remove_subscribe_ce4fe4b7_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_can_remove_subscribe_ce4fe4b7_fk_zerver_us FOREIGN KEY (can_remove_subscribers_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_realm_id_0d562dbb_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_realm_id_0d562dbb_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_recipient_id_85263e1b_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_recipient_id_85263e1b_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_submessage zerver_submessage_message_id_6d3b8d8e_fk_zerver_message_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_submessage
    ADD CONSTRAINT zerver_submessage_message_id_6d3b8d8e_fk_zerver_message_id FOREIGN KEY (message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_submessage zerver_submessage_sender_id_b1aa97b8_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_submessage
    ADD CONSTRAINT zerver_submessage_sender_id_b1aa97b8_fk_zerver_userprofile_id FOREIGN KEY (sender_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_subscription zerver_subscription_recipient_id_1e90e2cc_fk_zerver_re; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_subscription
    ADD CONSTRAINT zerver_subscription_recipient_id_1e90e2cc_fk_zerver_re FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_subscription zerver_subscription_user_profile_id_1773aa42_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_subscription
    ADD CONSTRAINT zerver_subscription_user_profile_id_1773aa42_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_useractivity zerver_useractivity_client_id_bb848fef_fk_zerver_client_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_useractivity
    ADD CONSTRAINT zerver_useractivity_client_id_bb848fef_fk_zerver_client_id FOREIGN KEY (client_id) REFERENCES zulip.zerver_client(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_useractivity zerver_useractivity_user_profile_id_3f3c3ea8_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_useractivity
    ADD CONSTRAINT zerver_useractivity_user_profile_id_3f3c3ea8_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_useractivityinterval zerver_useractivityi_user_profile_id_634623af_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_useractivityinterval
    ADD CONSTRAINT zerver_useractivityi_user_profile_id_634623af_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usergroup zerver_usergroup_realm_id_8b78d3b3_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroup
    ADD CONSTRAINT zerver_usergroup_realm_id_8b78d3b3_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usergroupmembership zerver_usergroupmemb_user_group_id_7722d5a1_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroupmembership
    ADD CONSTRAINT zerver_usergroupmemb_user_group_id_7722d5a1_fk_zerver_us FOREIGN KEY (user_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usergroupmembership zerver_usergroupmemb_user_profile_id_6aa688e2_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroupmembership
    ADD CONSTRAINT zerver_usergroupmemb_user_profile_id_6aa688e2_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userhotspot zerver_userhotspot_user_id_26216f4c_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userhotspot
    ADD CONSTRAINT zerver_userhotspot_user_id_26216f4c_fk_zerver_userprofile_id FOREIGN KEY (user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usermessage zerver_usermessage_message_id_f6e63a33_fk_zerver_message_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usermessage
    ADD CONSTRAINT zerver_usermessage_message_id_f6e63a33_fk_zerver_message_id FOREIGN KEY (message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usermessage zerver_usermessage_user_profile_id_e901f3b7_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usermessage
    ADD CONSTRAINT zerver_usermessage_user_profile_id_e901f3b7_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userpresence zerver_userpresence_realm_id_5c4ef5a9_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userpresence
    ADD CONSTRAINT zerver_userpresence_realm_id_5c4ef5a9_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userpresence zerver_userpresence_user_profile_id_b67b4092_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userpresence
    ADD CONSTRAINT zerver_userpresence_user_profile_id_b67b4092_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile zerver_userprofile_bot_owner_id_01a815f5_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_bot_owner_id_01a815f5_fk_zerver_us FOREIGN KEY (bot_owner_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile zerver_userprofile_default_events_regis_40e28493_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_default_events_regis_40e28493_fk_zerver_st FOREIGN KEY (default_events_register_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile zerver_userprofile_default_sending_stre_3ba7368b_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_default_sending_stre_3ba7368b_fk_zerver_st FOREIGN KEY (default_sending_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile_groups zerver_userprofile_g_userprofile_id_340abcf4_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_groups
    ADD CONSTRAINT zerver_userprofile_g_userprofile_id_340abcf4_fk_zerver_us FOREIGN KEY (userprofile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile_groups zerver_userprofile_groups_group_id_4ffff873_fk_auth_group_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_groups
    ADD CONSTRAINT zerver_userprofile_groups_group_id_4ffff873_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES zulip.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile zerver_userprofile_realm_id_d8908535_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_realm_id_d8908535_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile zerver_userprofile_recipient_id_d5853e31_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_recipient_id_d5853e31_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile_user_permissions zerver_userprofile_u_permission_id_5dd655ef_fk_auth_perm; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_user_permissions
    ADD CONSTRAINT zerver_userprofile_u_permission_id_5dd655ef_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES zulip.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile_user_permissions zerver_userprofile_u_userprofile_id_b508a4b1_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile_user_permissions
    ADD CONSTRAINT zerver_userprofile_u_userprofile_id_b508a4b1_fk_zerver_us FOREIGN KEY (userprofile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userstatus zerver_userstatus_client_id_9010b464_fk_zerver_client_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userstatus
    ADD CONSTRAINT zerver_userstatus_client_id_9010b464_fk_zerver_client_id FOREIGN KEY (client_id) REFERENCES zulip.zerver_client(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userstatus zerver_userstatus_user_profile_id_bbe3876b_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userstatus
    ADD CONSTRAINT zerver_userstatus_user_profile_id_bbe3876b_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

