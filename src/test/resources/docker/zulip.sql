--
-- PostgreSQL database dump
--

-- Dumped from database version 10.17
-- Dumped by pg_dump version 10.17

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
-- Name: pgroonga; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgroonga WITH SCHEMA zulip;


--
-- Name: EXTENSION pgroonga; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgroonga IS 'Super fast and all languages supported full text search index based on Groonga';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


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

SET default_with_oids = false;

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
    id integer NOT NULL,
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
    AS integer
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
    id integer NOT NULL,
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
    AS integer
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
    id integer NOT NULL,
    server_url character varying(255) NOT NULL,
    "timestamp" integer NOT NULL,
    salt character varying(65) NOT NULL
);


ALTER TABLE zulip.social_auth_nonce OWNER TO zulip;

--
-- Name: social_auth_nonce_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.social_auth_nonce_id_seq
    AS integer
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
    id integer NOT NULL,
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
    AS integer
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
    id integer NOT NULL,
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
    AS integer
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
    is_realm_public boolean NOT NULL,
    create_time timestamp with time zone NOT NULL,
    size integer NOT NULL,
    owner_id integer NOT NULL,
    realm_id integer,
    is_web_public boolean NOT NULL
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
    archive_transaction_id integer NOT NULL
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
    is_realm_public boolean NOT NULL,
    realm_id integer,
    size integer NOT NULL,
    is_web_public boolean NOT NULL
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
    hint character varying(80),
    field_data text,
    "order" integer NOT NULL,
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
    date_sent timestamp with time zone NOT NULL
);


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
-- Name: zerver_mutedtopic; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_mutedtopic (
    id integer NOT NULL,
    topic_name character varying(60) NOT NULL,
    recipient_id integer NOT NULL,
    stream_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    date_muted timestamp with time zone NOT NULL
);


ALTER TABLE zulip.zerver_mutedtopic OWNER TO zulip;

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

ALTER SEQUENCE zulip.zerver_mutedtopic_id_seq OWNED BY zulip.zerver_mutedtopic.id;


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
    name character varying(40),
    emails_restricted_to_domains boolean NOT NULL,
    invite_required boolean NOT NULL,
    mandatory_topics boolean NOT NULL,
    digest_emails_enabled boolean NOT NULL,
    name_changes_disabled boolean NOT NULL,
    date_created timestamp with time zone NOT NULL,
    deactivated boolean NOT NULL,
    notifications_stream_id integer,
    allow_message_editing boolean NOT NULL,
    message_content_edit_limit_seconds integer NOT NULL,
    default_language character varying(50) NOT NULL,
    string_id character varying(40) NOT NULL,
    org_type smallint NOT NULL,
    message_retention_days integer NOT NULL,
    authentication_methods bigint NOT NULL,
    waiting_period_threshold integer NOT NULL,
    add_emoji_by_admins_only boolean NOT NULL,
    icon_source character varying(1) NOT NULL,
    icon_version smallint NOT NULL,
    email_changes_disabled boolean NOT NULL,
    description text NOT NULL,
    inline_image_preview boolean NOT NULL,
    inline_url_embed_preview boolean NOT NULL,
    allow_edit_history boolean NOT NULL,
    allow_message_deleting boolean NOT NULL,
    signup_notifications_stream_id integer,
    max_invites integer,
    message_visibility_limit integer,
    upload_quota_gb integer,
    send_welcome_emails boolean NOT NULL,
    bot_creation_policy smallint NOT NULL,
    disallow_disposable_email_addresses boolean NOT NULL,
    allow_community_topic_editing boolean NOT NULL,
    default_twenty_four_hour_time boolean NOT NULL,
    message_content_delete_limit_seconds integer NOT NULL,
    plan_type smallint NOT NULL,
    email_address_visibility smallint NOT NULL,
    first_visible_message_id integer NOT NULL,
    logo_source character varying(1) NOT NULL,
    logo_version smallint NOT NULL,
    message_content_allowed_in_email_notifications boolean NOT NULL,
    night_logo_source character varying(1) NOT NULL,
    night_logo_version smallint NOT NULL,
    digest_weekday smallint NOT NULL,
    invite_to_stream_policy smallint NOT NULL,
    avatar_changes_disabled boolean NOT NULL,
    create_stream_policy smallint NOT NULL,
    video_chat_provider smallint NOT NULL,
    user_group_edit_policy smallint NOT NULL,
    private_message_policy smallint NOT NULL,
    default_code_block_language text,
    wildcard_mention_policy smallint NOT NULL,
    deactivated_redirect character varying(128),
    invite_to_realm_policy smallint NOT NULL,
    giphy_rating smallint NOT NULL,
    move_messages_between_streams_policy smallint NOT NULL,
    CONSTRAINT zerver_realm_bot_creation_policy_check CHECK ((bot_creation_policy >= 0)),
    CONSTRAINT zerver_realm_create_stream_policy_check CHECK ((create_stream_policy >= 0)),
    CONSTRAINT zerver_realm_email_address_visibility_check CHECK ((email_address_visibility >= 0)),
    CONSTRAINT zerver_realm_giphy_rating_check CHECK ((giphy_rating >= 0)),
    CONSTRAINT zerver_realm_icon_version_check CHECK ((icon_version >= 0)),
    CONSTRAINT zerver_realm_invite_to_realm_policy_check CHECK ((invite_to_realm_policy >= 0)),
    CONSTRAINT zerver_realm_invite_to_stream_policy_check CHECK ((invite_to_stream_policy >= 0)),
    CONSTRAINT zerver_realm_logo_version_check CHECK ((logo_version >= 0)),
    CONSTRAINT zerver_realm_move_messages_between_streams_policy_check CHECK ((move_messages_between_streams_policy >= 0)),
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
-- Name: zerver_realmemoji; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmemoji (
    id integer NOT NULL,
    name text NOT NULL,
    realm_id integer NOT NULL,
    author_id integer,
    file_name text,
    deactivated boolean NOT NULL
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
    url_format_string text NOT NULL,
    realm_id integer NOT NULL
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
    invite_only boolean,
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
    is_muted boolean,
    wildcard_mentions_notify boolean,
    role smallint NOT NULL,
    is_user_active boolean NOT NULL,
    CONSTRAINT zerver_subscription_role_check CHECK ((role >= 0))
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
    description text NOT NULL
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
    "timestamp" timestamp with time zone NOT NULL,
    status smallint NOT NULL,
    client_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    realm_id integer NOT NULL,
    CONSTRAINT zerver_userpresence_status_check CHECK ((status >= 0))
);


ALTER TABLE zulip.zerver_userpresence OWNER TO zulip;

--
-- Name: zerver_userpresence_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.zerver_userpresence_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zulip.zerver_userpresence_id_seq OWNER TO zulip;

--
-- Name: zerver_userpresence_id_seq; Type: SEQUENCE OWNED BY; Schema: zulip; Owner: zulip
--

ALTER SEQUENCE zulip.zerver_userpresence_id_seq OWNED BY zulip.zerver_userpresence.id;


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
    enter_sends boolean,
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
    realm_name_in_notifications boolean NOT NULL,
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
    CONSTRAINT zerver_userprofile_avatar_version_check CHECK ((avatar_version >= 0)),
    CONSTRAINT zerver_userprofile_bot_type_check CHECK ((bot_type >= 0)),
    CONSTRAINT zerver_userprofile_color_scheme_check CHECK ((color_scheme >= 0)),
    CONSTRAINT zerver_userprofile_demote_inactive_streams_check CHECK ((demote_inactive_streams >= 0)),
    CONSTRAINT zerver_userprofile_desktop_icon_count_display_check CHECK ((desktop_icon_count_display >= 0)),
    CONSTRAINT zerver_userprofile_role_check CHECK ((role >= 0))
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
    status smallint NOT NULL,
    client_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    status_text character varying(255) NOT NULL,
    CONSTRAINT zerver_userstatus_status_check CHECK ((status >= 0))
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
-- Name: zerver_mutedtopic id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_mutedtopic ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_mutedtopic_id_seq'::regclass);


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
-- Name: zerver_userpresence id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userpresence ALTER COLUMN id SET DEFAULT nextval('zulip.zerver_userpresence_id_seq'::regclass);


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
1	2	active_users_log:is_bot:day	2021-10-19 00:00:00+00	1	False
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
1	2	8	messages_read::hour	2021-10-18 13:00:00+00	1	\N
2	2	8	messages_read_interactions::hour	2021-10-18 13:00:00+00	1	\N
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
145	Can add muted topic	37	add_mutedtopic
146	Can change muted topic	37	change_mutedtopic
147	Can delete muted topic	37	delete_mutedtopic
148	Can view muted topic	37	view_mutedtopic
149	Can add multiuse invite	38	add_multiuseinvite
150	Can change multiuse invite	38	change_multiuseinvite
151	Can delete multiuse invite	38	delete_multiuseinvite
152	Can view multiuse invite	38	view_multiuseinvite
153	Can add default stream group	39	add_defaultstreamgroup
154	Can change default stream group	39	change_defaultstreamgroup
155	Can delete default stream group	39	delete_defaultstreamgroup
156	Can view default stream group	39	view_defaultstreamgroup
157	Can add user group	40	add_usergroup
158	Can change user group	40	change_usergroup
159	Can delete user group	40	delete_usergroup
160	Can view user group	40	view_usergroup
161	Can add user group membership	41	add_usergroupmembership
162	Can change user group membership	41	change_usergroupmembership
163	Can delete user group membership	41	delete_usergroupmembership
164	Can view user group membership	41	view_usergroupmembership
165	Can add bot storage data	42	add_botstoragedata
166	Can change bot storage data	42	change_botstoragedata
167	Can delete bot storage data	42	delete_botstoragedata
168	Can view bot storage data	42	view_botstoragedata
169	Can add bot config data	43	add_botconfigdata
170	Can change bot config data	43	change_botconfigdata
171	Can delete bot config data	43	delete_botconfigdata
172	Can view bot config data	43	view_botconfigdata
173	Can add scheduled message	44	add_scheduledmessage
174	Can change scheduled message	44	change_scheduledmessage
175	Can delete scheduled message	44	delete_scheduledmessage
176	Can view scheduled message	44	view_scheduledmessage
177	Can add sub message	45	add_submessage
178	Can change sub message	45	change_submessage
179	Can delete sub message	45	delete_submessage
180	Can view sub message	45	view_submessage
181	Can add user status	46	add_userstatus
182	Can change user status	46	change_userstatus
183	Can delete user status	46	delete_userstatus
184	Can view user status	46	view_userstatus
185	Can add archived reaction	47	add_archivedreaction
186	Can change archived reaction	47	change_archivedreaction
187	Can delete archived reaction	47	delete_archivedreaction
188	Can view archived reaction	47	view_archivedreaction
189	Can add archived sub message	48	add_archivedsubmessage
190	Can change archived sub message	48	change_archivedsubmessage
191	Can delete archived sub message	48	delete_archivedsubmessage
192	Can view archived sub message	48	view_archivedsubmessage
193	Can add archive transaction	49	add_archivetransaction
194	Can change archive transaction	49	change_archivetransaction
195	Can delete archive transaction	49	delete_archivetransaction
196	Can view archive transaction	49	view_archivetransaction
197	Can add missed message email address	50	add_missedmessageemailaddress
198	Can change missed message email address	50	change_missedmessageemailaddress
199	Can delete missed message email address	50	delete_missedmessageemailaddress
200	Can view missed message email address	50	view_missedmessageemailaddress
201	Can add alert word	51	add_alertword
202	Can change alert word	51	change_alertword
203	Can delete alert word	51	delete_alertword
204	Can view alert word	51	view_alertword
205	Can add draft	52	add_draft
206	Can change draft	52	change_draft
207	Can delete draft	52	delete_draft
208	Can view draft	52	view_draft
209	Can add muted user	53	add_muteduser
210	Can change muted user	53	change_muteduser
211	Can delete muted user	53	delete_muteduser
212	Can view muted user	53	view_muteduser
213	Can add realm playground	54	add_realmplayground
214	Can change realm playground	54	change_realmplayground
215	Can delete realm playground	54	delete_realmplayground
216	Can view realm playground	54	view_realmplayground
217	Can add association	55	add_association
218	Can change association	55	change_association
219	Can delete association	55	delete_association
220	Can view association	55	view_association
221	Can add code	56	add_code
222	Can change code	56	change_code
223	Can delete code	56	delete_code
224	Can view code	56	view_code
225	Can add nonce	57	add_nonce
226	Can change nonce	57	change_nonce
227	Can delete nonce	57	delete_nonce
228	Can view nonce	57	view_nonce
229	Can add user social auth	58	add_usersocialauth
230	Can change user social auth	58	change_usersocialauth
231	Can delete user social auth	58	delete_usersocialauth
232	Can view user social auth	58	view_usersocialauth
233	Can add partial	59	add_partial
234	Can change partial	59	change_partial
235	Can delete partial	59	delete_partial
236	Can view partial	59	view_partial
237	Can add static device	60	add_staticdevice
238	Can change static device	60	change_staticdevice
239	Can delete static device	60	delete_staticdevice
240	Can view static device	60	view_staticdevice
241	Can add static token	61	add_statictoken
242	Can change static token	61	change_statictoken
243	Can delete static token	61	delete_statictoken
244	Can view static token	61	view_statictoken
245	Can add TOTP device	62	add_totpdevice
246	Can change TOTP device	62	change_totpdevice
247	Can delete TOTP device	62	delete_totpdevice
248	Can view TOTP device	62	view_totpdevice
249	Can add phone device	63	add_phonedevice
250	Can change phone device	63	change_phonedevice
251	Can delete phone device	63	delete_phonedevice
252	Can view phone device	63	view_phonedevice
253	Can add installation count	64	add_installationcount
254	Can change installation count	64	change_installationcount
255	Can delete installation count	64	delete_installationcount
256	Can view installation count	64	view_installationcount
257	Can add realm count	65	add_realmcount
258	Can change realm count	65	change_realmcount
259	Can delete realm count	65	delete_realmcount
260	Can view realm count	65	view_realmcount
261	Can add stream count	66	add_streamcount
262	Can change stream count	66	change_streamcount
263	Can delete stream count	66	delete_streamcount
264	Can view stream count	66	view_streamcount
265	Can add user count	67	add_usercount
266	Can change user count	67	change_usercount
267	Can delete user count	67	delete_usercount
268	Can view user count	67	view_usercount
269	Can add fill state	68	add_fillstate
270	Can change fill state	68	change_fillstate
271	Can delete fill state	68	delete_fillstate
272	Can view fill state	68	view_fillstate
\.


--
-- Data for Name: confirmation_confirmation; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.confirmation_confirmation (id, object_id, date_sent, confirmation_key, content_type_id, type, realm_id) FROM stdin;
1	1	2021-10-18 12:39:00.468114+00	xczimjo5qpsfyhtb33llcs7j	12	7	\N
2	8	2021-10-18 12:39:24.217039+00	jtcefpmdclgdrecypwatig6c	7	4	2
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
37	zerver	mutedtopic
38	zerver	multiuseinvite
39	zerver	defaultstreamgroup
40	zerver	usergroup
41	zerver	usergroupmembership
42	zerver	botstoragedata
43	zerver	botconfigdata
44	zerver	scheduledmessage
45	zerver	submessage
46	zerver	userstatus
47	zerver	archivedreaction
48	zerver	archivedsubmessage
49	zerver	archivetransaction
50	zerver	missedmessageemailaddress
51	zerver	alertword
52	zerver	draft
53	zerver	muteduser
54	zerver	realmplayground
55	social_django	association
56	social_django	code
57	social_django	nonce
58	social_django	usersocialauth
59	social_django	partial
60	otp_static	staticdevice
61	otp_static	statictoken
62	otp_totp	totpdevice
63	two_factor	phonedevice
64	analytics	installationcount
65	analytics	realmcount
66	analytics	streamcount
67	analytics	usercount
68	analytics	fillstate
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2021-10-18 12:36:53.525768+00
2	auth	0001_initial	2021-10-18 12:36:53.610359+00
3	zerver	0001_initial	2021-10-18 12:36:56.034932+00
4	zerver	0029_realm_subdomain	2021-10-18 12:36:56.165777+00
5	zerver	0030_realm_org_type	2021-10-18 12:36:56.242605+00
6	zerver	0031_remove_system_avatar_source	2021-10-18 12:36:56.312225+00
7	zerver	0032_verify_all_medium_avatar_images	2021-10-18 12:36:56.3802+00
8	zerver	0033_migrate_domain_to_realmalias	2021-10-18 12:36:56.438757+00
9	zerver	0034_userprofile_enable_online_push_notifications	2021-10-18 12:36:56.534229+00
10	zerver	0035_realm_message_retention_period_days	2021-10-18 12:36:56.57175+00
11	zerver	0036_rename_subdomain_to_string_id	2021-10-18 12:36:56.610776+00
12	zerver	0037_disallow_null_string_id	2021-10-18 12:36:56.680535+00
13	zerver	0038_realm_change_to_community_defaults	2021-10-18 12:36:56.741893+00
14	zerver	0039_realmalias_drop_uniqueness	2021-10-18 12:36:56.802865+00
15	zerver	0040_realm_authentication_methods	2021-10-18 12:36:56.961638+00
16	zerver	0041_create_attachments_for_old_messages	2021-10-18 12:36:57.046655+00
17	zerver	0042_attachment_file_name_length	2021-10-18 12:36:57.084951+00
18	zerver	0043_realm_filter_validators	2021-10-18 12:36:57.127737+00
19	zerver	0044_reaction	2021-10-18 12:36:57.22076+00
20	zerver	0045_realm_waiting_period_threshold	2021-10-18 12:36:57.272958+00
21	zerver	0046_realmemoji_author	2021-10-18 12:36:57.331069+00
22	zerver	0047_realm_add_emoji_by_admins_only	2021-10-18 12:36:57.389386+00
23	zerver	0048_enter_sends_default_to_false	2021-10-18 12:36:57.439576+00
24	zerver	0049_userprofile_pm_content_in_desktop_notifications	2021-10-18 12:36:57.53714+00
25	zerver	0050_userprofile_avatar_version	2021-10-18 12:36:57.662598+00
26	analytics	0001_initial	2021-10-18 12:36:58.182132+00
27	analytics	0002_remove_huddlecount	2021-10-18 12:36:58.556748+00
28	analytics	0003_fillstate	2021-10-18 12:36:58.590376+00
29	analytics	0004_add_subgroup	2021-10-18 12:36:58.714373+00
30	analytics	0005_alter_field_size	2021-10-18 12:36:59.080013+00
31	analytics	0006_add_subgroup_to_unique_constraints	2021-10-18 12:36:59.288221+00
32	analytics	0007_remove_interval	2021-10-18 12:36:59.64568+00
33	analytics	0008_add_count_indexes	2021-10-18 12:36:59.853153+00
34	analytics	0009_remove_messages_to_stream_stat	2021-10-18 12:36:59.908228+00
35	analytics	0010_clear_messages_sent_values	2021-10-18 12:36:59.9593+00
36	analytics	0011_clear_analytics_tables	2021-10-18 12:37:00.007307+00
37	analytics	0012_add_on_delete	2021-10-18 12:37:00.13437+00
38	analytics	0013_remove_anomaly	2021-10-18 12:37:00.360272+00
39	analytics	0014_remove_fillstate_last_modified	2021-10-18 12:37:00.378243+00
40	analytics	0015_clear_duplicate_counts	2021-10-18 12:37:00.449292+00
41	analytics	0016_unique_constraint_when_subgroup_null	2021-10-18 12:37:00.826349+00
42	contenttypes	0002_remove_content_type_name	2021-10-18 12:37:00.980843+00
43	auth	0002_alter_permission_name_max_length	2021-10-18 12:37:01.025254+00
44	auth	0003_alter_user_email_max_length	2021-10-18 12:37:01.046598+00
45	auth	0004_alter_user_username_opts	2021-10-18 12:37:01.067727+00
46	auth	0005_alter_user_last_login_null	2021-10-18 12:37:01.08899+00
47	auth	0006_require_contenttypes_0002	2021-10-18 12:37:01.097005+00
48	auth	0007_alter_validators_add_error_messages	2021-10-18 12:37:01.117269+00
49	auth	0008_alter_user_username_max_length	2021-10-18 12:37:01.140555+00
50	auth	0009_alter_user_last_name_max_length	2021-10-18 12:37:01.163899+00
51	auth	0010_alter_group_name_max_length	2021-10-18 12:37:01.212665+00
52	auth	0011_update_proxy_permissions	2021-10-18 12:37:01.260037+00
53	auth	0012_alter_user_first_name_max_length	2021-10-18 12:37:01.279317+00
54	zerver	0051_realmalias_add_allow_subdomains	2021-10-18 12:37:01.351865+00
55	zerver	0052_auto_fix_realmalias_realm_nullable	2021-10-18 12:37:01.427299+00
56	zerver	0053_emailchangestatus	2021-10-18 12:37:01.507897+00
57	zerver	0054_realm_icon	2021-10-18 12:37:01.623203+00
58	zerver	0055_attachment_size	2021-10-18 12:37:01.681763+00
59	zerver	0056_userprofile_emoji_alt_code	2021-10-18 12:37:01.784778+00
60	zerver	0057_realmauditlog	2021-10-18 12:37:01.961556+00
61	zerver	0058_realm_email_changes_disabled	2021-10-18 12:37:02.043602+00
62	zerver	0059_userprofile_quota	2021-10-18 12:37:02.16141+00
63	zerver	0060_move_avatars_to_be_uid_based	2021-10-18 12:37:02.170458+00
64	zerver	0061_userprofile_timezone	2021-10-18 12:37:02.308977+00
65	zerver	0062_default_timezone	2021-10-18 12:37:02.376589+00
66	zerver	0063_realm_description	2021-10-18 12:37:02.424167+00
67	zerver	0064_sync_uploads_filesize_with_db	2021-10-18 12:37:02.429705+00
68	zerver	0065_realm_inline_image_preview	2021-10-18 12:37:02.5857+00
69	zerver	0066_realm_inline_url_embed_preview	2021-10-18 12:37:02.652535+00
70	zerver	0067_archived_models	2021-10-18 12:37:03.083964+00
71	zerver	0068_remove_realm_domain	2021-10-18 12:37:03.152229+00
72	zerver	0069_realmauditlog_extra_data	2021-10-18 12:37:03.219395+00
73	zerver	0070_userhotspot	2021-10-18 12:37:03.337593+00
74	zerver	0071_rename_realmalias_to_realmdomain	2021-10-18 12:37:03.417709+00
75	zerver	0072_realmauditlog_add_index_event_time	2021-10-18 12:37:03.4687+00
76	zerver	0073_custom_profile_fields	2021-10-18 12:37:03.777081+00
77	zerver	0074_fix_duplicate_attachments	2021-10-18 12:37:03.82911+00
78	zerver	0075_attachment_path_id_unique	2021-10-18 12:37:03.986611+00
79	zerver	0076_userprofile_emojiset	2021-10-18 12:37:04.101567+00
80	zerver	0077_add_file_name_field_to_realm_emoji	2021-10-18 12:37:04.232045+00
81	zerver	0078_service	2021-10-18 12:37:04.311798+00
82	zerver	0079_remove_old_scheduled_jobs	2021-10-18 12:37:04.369571+00
83	zerver	0080_realm_description_length	2021-10-18 12:37:04.403043+00
84	zerver	0081_make_emoji_lowercase	2021-10-18 12:37:04.496468+00
85	zerver	0082_index_starred_user_messages	2021-10-18 12:37:04.514947+00
86	zerver	0083_index_mentioned_user_messages	2021-10-18 12:37:04.530627+00
87	zerver	0084_realmemoji_deactivated	2021-10-18 12:37:04.612901+00
88	zerver	0085_fix_bots_with_none_bot_type	2021-10-18 12:37:04.681105+00
89	zerver	0086_realm_alter_default_org_type	2021-10-18 12:37:04.721345+00
90	zerver	0087_remove_old_scheduled_jobs	2021-10-18 12:37:04.777769+00
91	zerver	0088_remove_referral_and_invites	2021-10-18 12:37:05.036151+00
92	zerver	0089_auto_20170710_1353	2021-10-18 12:37:05.186427+00
93	zerver	0090_userprofile_high_contrast_mode	2021-10-18 12:37:05.313245+00
94	zerver	0091_realm_allow_edit_history	2021-10-18 12:37:05.406674+00
95	zerver	0092_create_scheduledemail	2021-10-18 12:37:05.53558+00
96	zerver	0093_subscription_event_log_backfill	2021-10-18 12:37:05.666284+00
97	zerver	0094_realm_filter_url_validator	2021-10-18 12:37:05.702234+00
98	zerver	0095_index_unread_user_messages	2021-10-18 12:37:05.716752+00
99	zerver	0096_add_password_required	2021-10-18 12:37:05.782746+00
100	zerver	0097_reactions_emoji_code	2021-10-18 12:37:05.95811+00
101	zerver	0098_index_has_alert_word_user_messages	2021-10-18 12:37:05.976757+00
102	zerver	0099_index_wildcard_mentioned_user_messages	2021-10-18 12:37:05.988492+00
103	zerver	0100_usermessage_remove_is_me_message	2021-10-18 12:37:06.177962+00
104	zerver	0101_muted_topic	2021-10-18 12:37:06.303752+00
105	zerver	0102_convert_muted_topic	2021-10-18 12:37:06.366979+00
106	zerver	0103_remove_userprofile_muted_topics	2021-10-18 12:37:06.422028+00
107	zerver	0104_fix_unreads	2021-10-18 12:37:06.479605+00
108	zerver	0105_userprofile_enable_stream_push_notifications	2021-10-18 12:37:06.583874+00
109	zerver	0106_subscription_push_notifications	2021-10-18 12:37:06.657841+00
110	zerver	0107_multiuseinvite	2021-10-18 12:37:06.760113+00
111	zerver	0108_fix_default_string_id	2021-10-18 12:37:06.826499+00
112	zerver	0109_mark_tutorial_status_finished	2021-10-18 12:37:06.890718+00
113	zerver	0110_stream_is_in_zephyr_realm	2021-10-18 12:37:07.006916+00
114	zerver	0111_botuserstatedata	2021-10-18 12:37:07.256768+00
115	zerver	0112_index_muted_topics	2021-10-18 12:37:07.267379+00
116	zerver	0113_default_stream_group	2021-10-18 12:37:07.41608+00
117	zerver	0114_preregistrationuser_invited_as_admin	2021-10-18 12:37:07.502969+00
118	zerver	0115_user_groups	2021-10-18 12:37:07.781011+00
119	zerver	0116_realm_allow_message_deleting	2021-10-18 12:37:07.845611+00
120	zerver	0117_add_desc_to_user_group	2021-10-18 12:37:07.931106+00
121	zerver	0118_defaultstreamgroup_description	2021-10-18 12:37:08.000997+00
122	zerver	0119_userprofile_night_mode	2021-10-18 12:37:08.126205+00
123	zerver	0120_botuserconfigdata	2021-10-18 12:37:08.40232+00
124	zerver	0121_realm_signup_notifications_stream	2021-10-18 12:37:08.527061+00
125	zerver	0122_rename_botuserstatedata_botstoragedata	2021-10-18 12:37:08.624705+00
126	zerver	0123_userprofile_make_realm_email_pair_unique	2021-10-18 12:37:08.762692+00
127	zerver	0124_stream_enable_notifications	2021-10-18 12:37:08.945971+00
128	confirmation	0001_initial	2021-10-18 12:37:09.04952+00
129	confirmation	0002_realmcreationkey	2021-10-18 12:37:09.065244+00
130	confirmation	0003_emailchangeconfirmation	2021-10-18 12:37:09.077621+00
131	confirmation	0004_remove_confirmationmanager	2021-10-18 12:37:09.142957+00
132	confirmation	0005_confirmation_realm	2021-10-18 12:37:09.236917+00
133	confirmation	0006_realmcreationkey_presume_email_valid	2021-10-18 12:37:09.262015+00
134	confirmation	0007_add_indexes	2021-10-18 12:37:09.553849+00
135	otp_static	0001_initial	2021-10-18 12:37:09.703831+00
136	otp_static	0002_throttling	2021-10-18 12:37:09.8171+00
137	otp_totp	0001_initial	2021-10-18 12:37:09.900355+00
138	otp_totp	0002_auto_20190420_0723	2021-10-18 12:37:10.008736+00
139	sessions	0001_initial	2021-10-18 12:37:10.035232+00
140	default	0001_initial	2021-10-18 12:37:10.21845+00
141	social_auth	0001_initial	2021-10-18 12:37:10.223071+00
142	default	0002_add_related_name	2021-10-18 12:37:10.293091+00
143	social_auth	0002_add_related_name	2021-10-18 12:37:10.297697+00
144	default	0003_alter_email_max_length	2021-10-18 12:37:10.315261+00
145	social_auth	0003_alter_email_max_length	2021-10-18 12:37:10.319816+00
146	default	0004_auto_20160423_0400	2021-10-18 12:37:10.38003+00
147	social_auth	0004_auto_20160423_0400	2021-10-18 12:37:10.384631+00
148	social_auth	0005_auto_20160727_2333	2021-10-18 12:37:10.404929+00
149	social_django	0006_partial	2021-10-18 12:37:10.451609+00
150	social_django	0007_code_timestamp	2021-10-18 12:37:10.494685+00
151	social_django	0008_partial_timestamp	2021-10-18 12:37:10.538803+00
152	social_django	0009_auto_20191118_0520	2021-10-18 12:37:10.831347+00
153	social_django	0010_uid_db_index	2021-10-18 12:37:10.896568+00
154	two_factor	0001_initial	2021-10-18 12:37:10.987561+00
155	two_factor	0002_auto_20150110_0810	2021-10-18 12:37:11.04463+00
156	two_factor	0003_auto_20150817_1733	2021-10-18 12:37:11.151655+00
157	two_factor	0004_auto_20160205_1827	2021-10-18 12:37:11.206949+00
158	two_factor	0005_auto_20160224_0450	2021-10-18 12:37:11.429889+00
159	two_factor	0006_phonedevice_key_default	2021-10-18 12:37:11.598179+00
160	two_factor	0007_auto_20201201_1019	2021-10-18 12:37:11.708216+00
161	zerver	0125_realm_max_invites	2021-10-18 12:37:11.779666+00
162	zerver	0126_prereg_remove_users_without_realm	2021-10-18 12:37:11.850686+00
163	zerver	0127_disallow_chars_in_stream_and_user_name	2021-10-18 12:37:11.860952+00
164	zerver	0128_scheduledemail_realm	2021-10-18 12:37:12.078627+00
165	zerver	0129_remove_userprofile_autoscroll_forever	2021-10-18 12:37:12.147075+00
166	zerver	0130_text_choice_in_emojiset	2021-10-18 12:37:12.319413+00
167	zerver	0131_realm_create_generic_bot_by_admins_only	2021-10-18 12:37:12.497001+00
168	zerver	0132_realm_message_visibility_limit	2021-10-18 12:37:12.542234+00
169	zerver	0133_rename_botuserconfigdata_botconfigdata	2021-10-18 12:37:12.654823+00
170	zerver	0134_scheduledmessage	2021-10-18 12:37:12.790127+00
171	zerver	0135_scheduledmessage_delivery_type	2021-10-18 12:37:12.909232+00
172	zerver	0136_remove_userprofile_quota	2021-10-18 12:37:12.996928+00
173	zerver	0137_realm_upload_quota_gb	2021-10-18 12:37:13.053976+00
174	zerver	0138_userprofile_realm_name_in_notifications	2021-10-18 12:37:13.183158+00
175	zerver	0139_fill_last_message_id_in_subscription_logs	2021-10-18 12:37:13.279716+00
176	zerver	0140_realm_send_welcome_emails	2021-10-18 12:37:13.366942+00
177	zerver	0141_change_usergroup_description_to_textfield	2021-10-18 12:37:13.446822+00
178	zerver	0142_userprofile_translate_emoticons	2021-10-18 12:37:13.695166+00
179	zerver	0143_realm_bot_creation_policy	2021-10-18 12:37:13.867233+00
180	zerver	0144_remove_realm_create_generic_bot_by_admins_only	2021-10-18 12:37:13.924067+00
181	zerver	0145_reactions_realm_emoji_name_to_id	2021-10-18 12:37:13.997715+00
182	zerver	0146_userprofile_message_content_in_email_notifications	2021-10-18 12:37:14.132441+00
183	zerver	0147_realm_disallow_disposable_email_addresses	2021-10-18 12:37:14.234533+00
184	zerver	0148_max_invites_forget_default	2021-10-18 12:37:14.34261+00
185	zerver	0149_realm_emoji_drop_unique_constraint	2021-10-18 12:37:14.528618+00
186	zerver	0150_realm_allow_community_topic_editing	2021-10-18 12:37:14.607105+00
187	zerver	0151_last_reminder_default_none	2021-10-18 12:37:14.796599+00
188	zerver	0152_realm_default_twenty_four_hour_time	2021-10-18 12:37:14.879048+00
189	zerver	0153_remove_int_float_custom_fields	2021-10-18 12:37:14.937915+00
190	zerver	0154_fix_invalid_bot_owner	2021-10-18 12:37:15.018148+00
191	zerver	0155_change_default_realm_description	2021-10-18 12:37:15.074792+00
192	zerver	0156_add_hint_to_profile_field	2021-10-18 12:37:15.13837+00
193	zerver	0157_userprofile_is_guest	2021-10-18 12:37:15.289613+00
194	zerver	0158_realm_video_chat_provider	2021-10-18 12:37:15.396638+00
195	zerver	0159_realm_google_hangouts_domain	2021-10-18 12:37:15.509022+00
196	zerver	0160_add_choice_field	2021-10-18 12:37:15.675796+00
197	zerver	0161_realm_message_content_delete_limit_seconds	2021-10-18 12:37:15.778029+00
198	zerver	0162_change_default_community_topic_editing	2021-10-18 12:37:15.836411+00
199	zerver	0163_remove_userprofile_default_desktop_notifications	2021-10-18 12:37:15.909397+00
200	zerver	0164_stream_history_public_to_subscribers	2021-10-18 12:37:16.156525+00
201	zerver	0165_add_date_to_profile_field	2021-10-18 12:37:16.206339+00
202	zerver	0166_add_url_to_profile_field	2021-10-18 12:37:16.249527+00
203	zerver	0167_custom_profile_fields_sort_order	2021-10-18 12:37:16.377504+00
204	zerver	0168_stream_is_web_public	2021-10-18 12:37:16.452175+00
205	zerver	0169_stream_is_announcement_only	2021-10-18 12:37:16.537917+00
206	zerver	0170_submessage	2021-10-18 12:37:16.651645+00
207	zerver	0171_userprofile_dense_mode	2021-10-18 12:37:16.790464+00
208	zerver	0172_add_user_type_of_custom_profile_field	2021-10-18 12:37:16.860542+00
209	zerver	0173_support_seat_based_plans	2021-10-18 12:37:17.043138+00
210	zerver	0174_userprofile_delivery_email	2021-10-18 12:37:17.401607+00
211	zerver	0175_change_realm_audit_log_event_type_tense	2021-10-18 12:37:17.476845+00
212	zerver	0176_remove_subscription_notifications	2021-10-18 12:37:17.536217+00
213	zerver	0177_user_message_add_and_index_is_private_flag	2021-10-18 12:37:17.714317+00
214	zerver	0178_rename_to_emails_restricted_to_domains	2021-10-18 12:37:17.761227+00
215	zerver	0179_rename_to_digest_emails_enabled	2021-10-18 12:37:17.805473+00
216	zerver	0180_usermessage_add_active_mobile_push_notification	2021-10-18 12:37:17.917858+00
217	zerver	0181_userprofile_change_emojiset	2021-10-18 12:37:18.042692+00
218	zerver	0182_set_initial_value_is_private_flag	2021-10-18 12:37:18.2249+00
219	zerver	0183_change_custom_field_name_max_length	2021-10-18 12:37:18.299174+00
220	zerver	0184_rename_custom_field_types	2021-10-18 12:37:18.348807+00
221	zerver	0185_realm_plan_type	2021-10-18 12:37:18.422315+00
222	zerver	0186_userprofile_starred_message_counts	2021-10-18 12:37:18.564152+00
223	zerver	0187_userprofile_is_billing_admin	2021-10-18 12:37:18.746633+00
224	zerver	0188_userprofile_enable_login_emails	2021-10-18 12:37:18.928304+00
225	zerver	0189_userprofile_add_some_emojisets	2021-10-18 12:37:19.103401+00
226	zerver	0190_cleanup_pushdevicetoken	2021-10-18 12:37:19.25697+00
227	zerver	0191_realm_seat_limit	2021-10-18 12:37:19.306389+00
228	zerver	0192_customprofilefieldvalue_rendered_value	2021-10-18 12:37:19.464848+00
229	zerver	0193_realm_email_address_visibility	2021-10-18 12:37:19.550967+00
230	zerver	0194_userprofile_notification_sound	2021-10-18 12:37:19.701232+00
231	zerver	0195_realm_first_visible_message_id	2021-10-18 12:37:19.804445+00
232	zerver	0196_add_realm_logo_fields	2021-10-18 12:37:20.003472+00
233	zerver	0197_azure_active_directory_auth	2021-10-18 12:37:20.06827+00
234	zerver	0198_preregistrationuser_invited_as	2021-10-18 12:37:20.223364+00
235	zerver	0199_userstatus	2021-10-18 12:37:20.319304+00
236	zerver	0200_remove_preregistrationuser_invited_as_admin	2021-10-18 12:37:20.387901+00
237	zerver	0201_zoom_video_chat	2021-10-18 12:37:20.606079+00
238	zerver	0202_add_user_status_info	2021-10-18 12:37:20.852011+00
239	zerver	0203_realm_message_content_allowed_in_email_notifications	2021-10-18 12:37:20.939164+00
240	zerver	0204_remove_realm_billing_fields	2021-10-18 12:37:21.036337+00
241	zerver	0205_remove_realmauditlog_requires_billing_update	2021-10-18 12:37:21.104304+00
242	zerver	0206_stream_rendered_description	2021-10-18 12:37:21.239117+00
243	zerver	0207_multiuseinvite_invited_as	2021-10-18 12:37:21.329083+00
244	zerver	0208_add_realm_night_logo_fields	2021-10-18 12:37:21.482236+00
245	zerver	0209_stream_first_message_id	2021-10-18 12:37:21.551568+00
246	zerver	0210_stream_first_message_id	2021-10-18 12:37:21.632433+00
247	zerver	0211_add_users_field_to_scheduled_email	2021-10-18 12:37:21.974903+00
248	zerver	0212_make_stream_email_token_unique	2021-10-18 12:37:22.061016+00
249	zerver	0213_realm_digest_weekday	2021-10-18 12:37:22.140997+00
250	zerver	0214_realm_invite_to_stream_policy	2021-10-18 12:37:22.294762+00
251	zerver	0215_realm_avatar_changes_disabled	2021-10-18 12:37:22.382106+00
252	zerver	0216_add_create_stream_policy	2021-10-18 12:37:22.478594+00
253	zerver	0217_migrate_create_stream_policy	2021-10-18 12:37:22.578733+00
254	zerver	0218_remove_create_stream_by_admins_only	2021-10-18 12:37:22.637255+00
255	zerver	0219_toggle_realm_digest_emails_enabled_default	2021-10-18 12:37:22.87312+00
256	zerver	0220_subscription_notification_settings	2021-10-18 12:37:23.076145+00
257	zerver	0221_subscription_notifications_data_migration	2021-10-18 12:37:23.19538+00
258	zerver	0222_userprofile_fluid_layout_width	2021-10-18 12:37:23.348935+00
259	zerver	0223_rename_to_is_muted	2021-10-18 12:37:23.599292+00
260	zerver	0224_alter_field_realm_video_chat_provider	2021-10-18 12:37:23.923263+00
261	zerver	0225_archived_reaction_model	2021-10-18 12:37:24.094694+00
262	zerver	0226_archived_submessage_model	2021-10-18 12:37:24.219183+00
263	zerver	0227_inline_url_embed_preview_default_off	2021-10-18 12:37:24.346664+00
264	zerver	0228_userprofile_demote_inactive_streams	2021-10-18 12:37:24.491999+00
265	zerver	0229_stream_message_retention_days	2021-10-18 12:37:24.564973+00
266	zerver	0230_rename_to_enable_stream_audible_notifications	2021-10-18 12:37:24.654568+00
267	zerver	0231_add_archive_transaction_model	2021-10-18 12:37:25.219855+00
268	zerver	0232_make_archive_transaction_field_not_nullable	2021-10-18 12:37:25.340801+00
269	zerver	0233_userprofile_avatar_hash	2021-10-18 12:37:25.420213+00
270	zerver	0234_add_external_account_custom_profile_field	2021-10-18 12:37:25.47147+00
271	zerver	0235_userprofile_desktop_icon_count_display	2021-10-18 12:37:25.717987+00
272	zerver	0236_remove_illegal_characters_email_full	2021-10-18 12:37:25.815366+00
273	zerver	0237_rename_zulip_realm_to_zulipinternal	2021-10-18 12:37:25.894672+00
274	zerver	0238_usermessage_bigint_id	2021-10-18 12:37:26.008932+00
275	zerver	0239_usermessage_copy_id_to_bigint_id	2021-10-18 12:37:26.108349+00
276	zerver	0240_usermessage_migrate_bigint_id_into_id	2021-10-18 12:37:26.226104+00
277	zerver	0241_usermessage_bigint_id_migration_finalize	2021-10-18 12:37:26.369027+00
278	zerver	0242_fix_bot_email_property	2021-10-18 12:37:26.556247+00
279	zerver	0243_message_add_date_sent_column	2021-10-18 12:37:26.668733+00
280	zerver	0244_message_copy_pub_date_to_date_sent	2021-10-18 12:37:26.759787+00
281	zerver	0245_message_date_sent_finalize_part1	2021-10-18 12:37:26.833378+00
282	zerver	0246_message_date_sent_finalize_part2	2021-10-18 12:37:27.0741+00
283	zerver	0247_realmauditlog_event_type_to_int	2021-10-18 12:37:27.564603+00
284	zerver	0248_userprofile_role_start	2021-10-18 12:37:27.708411+00
285	zerver	0249_userprofile_role_finish	2021-10-18 12:37:27.908134+00
286	zerver	0250_saml_auth	2021-10-18 12:37:28.074826+00
287	zerver	0251_prereg_user_add_full_name	2021-10-18 12:37:28.223362+00
288	zerver	0252_realm_user_group_edit_policy	2021-10-18 12:37:28.313639+00
289	zerver	0253_userprofile_wildcard_mentions_notify	2021-10-18 12:37:28.53026+00
290	zerver	0209_user_profile_no_empty_password	2021-10-18 12:37:28.625774+00
291	zerver	0254_merge_0209_0253	2021-10-18 12:37:28.636767+00
292	zerver	0255_userprofile_stream_add_recipient_column	2021-10-18 12:37:28.79673+00
293	zerver	0256_userprofile_stream_set_recipient_column_values	2021-10-18 12:37:28.814616+00
294	zerver	0257_fix_has_link_attribute	2021-10-18 12:37:28.895176+00
295	zerver	0258_enable_online_push_notifications_default	2021-10-18 12:37:29.076879+00
296	zerver	0259_missedmessageemailaddress	2021-10-18 12:37:29.198741+00
297	zerver	0260_missed_message_addresses_from_redis_to_db	2021-10-18 12:37:29.288182+00
298	zerver	0261_realm_private_message_policy	2021-10-18 12:37:29.369489+00
299	zerver	0262_mutedtopic_date_muted	2021-10-18 12:37:29.476045+00
300	zerver	0263_stream_stream_post_policy	2021-10-18 12:37:29.584336+00
301	zerver	0264_migrate_is_announcement_only	2021-10-18 12:37:29.687086+00
302	zerver	0265_remove_stream_is_announcement_only	2021-10-18 12:37:29.749365+00
303	zerver	0266_userpresence_realm	2021-10-18 12:37:29.840818+00
304	zerver	0267_backfill_userpresence_realm_id	2021-10-18 12:37:29.849187+00
305	zerver	0268_add_userpresence_realm_timestamp_index	2021-10-18 12:37:30.124182+00
306	zerver	0269_gitlab_auth	2021-10-18 12:37:30.17412+00
307	zerver	0270_huddle_recipient	2021-10-18 12:37:30.258889+00
308	zerver	0271_huddle_set_recipient_column_values	2021-10-18 12:37:30.271176+00
309	zerver	0272_realm_default_code_block_language	2021-10-18 12:37:30.325206+00
310	zerver	0273_migrate_old_bot_messages	2021-10-18 12:37:30.405863+00
311	zerver	0274_nullbooleanfield_to_booleanfield	2021-10-18 12:37:30.943775+00
312	zerver	0275_remove_userprofile_last_pointer_updater	2021-10-18 12:37:31.023089+00
313	zerver	0276_alertword	2021-10-18 12:37:31.132642+00
314	zerver	0277_migrate_alert_word	2021-10-18 12:37:31.217925+00
315	zerver	0278_remove_userprofile_alert_words	2021-10-18 12:37:31.293865+00
316	zerver	0279_message_recipient_subject_indexes	2021-10-18 12:37:31.332221+00
317	zerver	0280_userprofile_presence_enabled	2021-10-18 12:37:31.486452+00
318	zerver	0281_zoom_oauth	2021-10-18 12:37:31.584617+00
319	zerver	0282_remove_zoom_video_chat	2021-10-18 12:37:31.828942+00
320	zerver	0283_apple_auth	2021-10-18 12:37:31.881502+00
321	zerver	0284_convert_realm_admins_to_realm_owners	2021-10-18 12:37:31.963334+00
322	zerver	0285_remove_realm_google_hangouts_domain	2021-10-18 12:37:32.082849+00
323	zerver	0261_pregistrationuser_clear_invited_as_admin	2021-10-18 12:37:32.163503+00
324	zerver	0286_merge_0260_0285	2021-10-18 12:37:32.174605+00
325	zerver	0287_clear_duplicate_reactions	2021-10-18 12:37:32.253508+00
326	zerver	0288_reaction_unique_on_emoji_code	2021-10-18 12:37:32.384089+00
327	zerver	0289_tighten_attachment_size	2021-10-18 12:37:32.631577+00
328	zerver	0290_remove_night_mode_add_color_scheme	2021-10-18 12:37:32.930809+00
329	zerver	0291_realm_retention_days_not_null	2021-10-18 12:37:32.989209+00
330	zerver	0292_update_default_value_of_invited_as	2021-10-18 12:37:33.1184+00
331	zerver	0293_update_invite_as_dict_values	2021-10-18 12:37:33.208147+00
332	zerver	0294_remove_userprofile_pointer	2021-10-18 12:37:33.285698+00
333	zerver	0295_case_insensitive_email_indexes	2021-10-18 12:37:33.518638+00
334	zerver	0296_remove_userprofile_short_name	2021-10-18 12:37:33.598096+00
335	zerver	0297_draft	2021-10-18 12:37:33.714642+00
336	zerver	0298_fix_realmauditlog_format	2021-10-18 12:37:33.80332+00
337	zerver	0299_subscription_role	2021-10-18 12:37:33.899423+00
338	zerver	0300_add_attachment_is_web_public	2021-10-18 12:37:34.107485+00
339	zerver	0301_fix_unread_messages_in_deactivated_streams	2021-10-18 12:37:34.12034+00
340	zerver	0302_case_insensitive_stream_name_index	2021-10-18 12:37:34.21524+00
341	zerver	0303_realm_wildcard_mention_policy	2021-10-18 12:37:34.314551+00
342	zerver	0304_remove_default_status_of_default_private_streams	2021-10-18 12:37:34.419909+00
343	zerver	0305_realm_deactivated_redirect	2021-10-18 12:37:34.479625+00
344	zerver	0306_custom_profile_field_date_format	2021-10-18 12:37:34.63248+00
345	zerver	0307_rename_api_super_user_to_can_forge_sender	2021-10-18 12:37:34.712889+00
346	zerver	0308_remove_reduntant_realm_meta_permissions	2021-10-18 12:37:34.765658+00
347	zerver	0309_userprofile_can_create_users	2021-10-18 12:37:34.924848+00
348	zerver	0310_jsonfield	2021-10-18 12:37:34.930825+00
349	zerver	0311_userprofile_default_view	2021-10-18 12:37:35.120341+00
350	zerver	0312_subscription_is_user_active	2021-10-18 12:37:35.230187+00
351	zerver	0313_finish_is_user_active_migration	2021-10-18 12:37:35.448505+00
352	zerver	0314_muted_user	2021-10-18 12:37:35.604146+00
353	zerver	0315_realmplayground	2021-10-18 12:37:35.85709+00
354	zerver	0316_realm_invite_to_realm_policy	2021-10-18 12:37:35.951429+00
355	zerver	0317_migrate_to_invite_to_realm_policy	2021-10-18 12:37:36.050226+00
356	zerver	0318_remove_realm_invite_by_admins_only	2021-10-18 12:37:36.109103+00
357	zerver	0319_realm_giphy_rating	2021-10-18 12:37:36.198326+00
358	zerver	0320_realm_move_messages_between_streams_policy	2021-10-18 12:37:36.297153+00
359	zerver	0321_userprofile_enable_marketing_emails	2021-10-18 12:37:36.467528+00
360	zerver	0322_realm_create_audit_log_backfill	2021-10-18 12:37:36.585982+00
361	zerver	0323_show_starred_message_counts	2021-10-18 12:37:36.747995+00
362	zerver	0324_fix_deletion_cascade_behavior	2021-10-18 12:37:37.128145+00
363	zerver	0325_alter_realmplayground_unique_together	2021-10-18 12:37:37.208473+00
364	zerver	0359_re2_linkifiers	2021-10-18 12:37:37.295903+00
365	social_django	0003_alter_email_max_length	2021-10-18 12:37:37.315879+00
366	social_django	0002_add_related_name	2021-10-18 12:37:37.32164+00
367	social_django	0005_auto_20160727_2333	2021-10-18 12:37:37.326367+00
368	social_django	0001_initial	2021-10-18 12:37:37.331058+00
369	social_django	0004_auto_20160423_0400	2021-10-18 12:37:37.335458+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_session (session_key, session_data, expire_date) FROM stdin;
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

COPY zulip.zerver_archivedmessage (id, subject, content, rendered_content, rendered_content_version, date_sent, last_edit_time, edit_history, has_attachment, has_image, has_link, recipient_id, sender_id, sending_client_id, archive_transaction_id) FROM stdin;
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

COPY zulip.zerver_customprofilefield (id, name, field_type, realm_id, hint, field_data, "order") FROM stdin;
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
-- Data for Name: zerver_huddle; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_huddle (id, huddle_hash, recipient_id) FROM stdin;
\.


--
-- Data for Name: zerver_message; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_message (id, subject, content, rendered_content, rendered_content_version, last_edit_time, edit_history, has_attachment, has_image, has_link, recipient_id, sender_id, sending_client_id, search_tsvector, date_sent) FROM stdin;
1		Hello, and welcome to Zulip!\n\nThis is a private message from me, Welcome Bot. Here are some tips to get you started:\n* Download our [Desktop and mobile apps](/apps)\n* Customize your account and notifications on your [Settings page](#settings)\n* Type `?` to check out Zulip's keyboard shortcuts\n* [Read the guide](https://localhost/help/getting-your-organization-started-with-zulip) for getting your organisation started with Zulip\n\nThe most important shortcut is `r` to reply.\n\nPractice sending a few messages by replying to this conversation. If you're not into keyboards, that's okay too; clicking anywhere on this message will also do the trick!	<p>Hello, and welcome to Zulip!</p>\n<p>This is a private message from me, Welcome Bot. Here are some tips to get you started:</p>\n<ul>\n<li>Download our <a href="/apps">Desktop and mobile apps</a></li>\n<li>Customize your account and notifications on your <a href="#settings">Settings page</a></li>\n<li>Type <code>?</code> to check out Zulip's keyboard shortcuts</li>\n<li><a href="help/getting-your-organization-started-with-zulip">Read the guide</a> for getting your organisation started with Zulip</li>\n</ul>\n<p>The most important shortcut is <code>r</code> to reply.</p>\n<p>Practice sending a few messages by replying to this conversation. If you're not into keyboards, that's okay too; clicking anywhere on this message will also do the trick!</p>	1	\N	\N	f	f	t	10	7	4	'account':31 'also':90 'anywhere':85 'app':28 'bot':14 'check':40 'click':84 'conversation':73 'customize':29 'desktop':25 'download':23 'get':20 'getting':50 'guide':48 'hello':1 'important':58 'keyboard':44,79 'message':10,68,88 'mobile':27 'notify':33 'okay':82 'organis':52 'page':37 'ply':63,70 'practice':64 'private':9 're':76 'read':46 'send':65 'sett':36 'shortcut':45,59 'start':22,53 'tip':18 'trick':93 'type':38 'welcome':3,13 'zulip':5,42,55	2021-10-18 12:39:24.296316+00
2	private streams	This is a private stream, as indicated by the lock icon next to the stream name. Private streams are only visible to stream members.\n\nTo manage this stream, go to [Stream settings](#streams/subscribed) and click on `core team`.	<p>This is a private stream, as indicated by the lock icon next to the stream name. Private streams are only visible to stream members.</p>\n<p>To manage this stream, go to <a href="#streams/subscribed">Stream settings</a> and click on <code>core team</code>.</p>	1	\N	\N	f	f	t	9	7	4	'click':36 'core':38 'go':31 'icon':13 'indicate':9 'lock':12 'manage':28 'member':26 'name':18 'next':14 'private':1,6,19 'sett':34 'stream':2,7,17,20,25,30,33 'team':39 'visible':23	2021-10-18 12:39:24.457003+00
3	topic demonstration	This is a message on stream #**general** with the topic `topic demonstration`.	<p>This is a message on stream <a class="stream" data-stream-id="1" href="/#narrow/stream/1-general">#general</a> with the topic <code>topic demonstration</code>.</p>	1	\N	\N	f	f	t	8	7	4	'demonstrate':2,14 'demonstration':2,14 'general':9 'message':6 'stream':8 'topic':1,12,13	2021-10-18 12:39:24.473937+00
4	topic demonstration	Topics are a lightweight tool to keep conversations organised. You can learn more about topics at [Streams and topics](/help/about-streams-and-topics).	<p>Topics are a lightweight tool to keep conversations organised. You can learn more about topics at <a href="/help/about-streams-and-topics">Streams and topics</a>.</p>	1	\N	\N	f	f	t	8	7	4	'conversation':10 'demonstrate':2 'demonstration':2 'keep':9 'learn':14 'lightweight':6 'organis':11 'stream':19 'tool':7 'topic':1,3,17,21	2021-10-18 12:39:24.491053+00
5	swimming turtles	This is a message on stream #**general** with the topic `swimming turtles`.\n\n[](/static/images/cute/turtle.png)\n\n[Start a new topic](/help/start-a-new-topic) any time you're not replying to a         previous message.	<p>This is a message on stream <a class="stream" data-stream-id="1" href="/#narrow/stream/1-general">#general</a> with the topic <code>swimming turtles</code>.</p>\n<div class="message_inline_image"><a href="/static/images/cute/turtle.png"><img src="/static/images/cute/turtle.png"></a></div><p><a href="/help/start-a-new-topic">Start a new topic</a> any time you're not replying to a         previous message.</p>	1	\N	\N	f	t	t	8	7	4	'general':9 'message':6,28 'new':17 'ply':24 'previous':27 're':22 'start':15 'stream':8 'swimming':1,13 'time':20 'topic':12,18 'turtle':2,14	2021-10-18 12:39:24.507077+00
\.


--
-- Data for Name: zerver_missedmessageemailaddress; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_missedmessageemailaddress (id, email_token, "timestamp", times_used, message_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_multiuseinvite; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_multiuseinvite (id, realm_id, referred_by_id, invited_as) FROM stdin;
\.


--
-- Data for Name: zerver_multiuseinvite_streams; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_multiuseinvite_streams (id, multiuseinvite_id, stream_id) FROM stdin;
\.


--
-- Data for Name: zerver_mutedtopic; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_mutedtopic (id, topic_name, recipient_id, stream_id, user_profile_id, date_muted) FROM stdin;
\.


--
-- Data for Name: zerver_muteduser; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_muteduser (id, date_muted, muted_user_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_preregistrationuser; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationuser (id, email, invited_at, status, realm_id, referred_by_id, realm_creation, password_required, invited_as, full_name, full_name_validated) FROM stdin;
1	test@test.com	2021-10-18 12:39:00.460693+00	1	\N	\N	t	t	400	\N	f
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

COPY zulip.zerver_realm (id, name, emails_restricted_to_domains, invite_required, mandatory_topics, digest_emails_enabled, name_changes_disabled, date_created, deactivated, notifications_stream_id, allow_message_editing, message_content_edit_limit_seconds, default_language, string_id, org_type, message_retention_days, authentication_methods, waiting_period_threshold, add_emoji_by_admins_only, icon_source, icon_version, email_changes_disabled, description, inline_image_preview, inline_url_embed_preview, allow_edit_history, allow_message_deleting, signup_notifications_stream_id, max_invites, message_visibility_limit, upload_quota_gb, send_welcome_emails, bot_creation_policy, disallow_disposable_email_addresses, allow_community_topic_editing, default_twenty_four_hour_time, message_content_delete_limit_seconds, plan_type, email_address_visibility, first_visible_message_id, logo_source, logo_version, message_content_allowed_in_email_notifications, night_logo_source, night_logo_version, digest_weekday, invite_to_stream_policy, avatar_changes_disabled, create_stream_policy, video_chat_provider, user_group_edit_policy, private_message_policy, default_code_block_language, wildcard_mention_policy, deactivated_redirect, invite_to_realm_policy, giphy_rating, move_messages_between_streams_policy) FROM stdin;
1	\N	f	t	f	f	f	2021-10-18 12:39:23.110527+00	f	\N	t	600	en	zulipinternal	1	-1	2147483647	0	f	G	1	f		t	f	t	f	\N	\N	\N	\N	t	1	t	t	f	600	1	1	0	D	1	t	D	1	1	1	f	1	1	1	1	\N	4	\N	1	2	2
2	testing	f	t	f	f	f	2021-10-18 12:39:23.643283+00	f	1	t	600	en		1	-1	2147483647	0	f	G	1	f		t	f	t	f	2	\N	\N	\N	t	1	t	t	f	600	1	1	0	D	1	t	D	1	1	1	f	1	1	1	1	\N	4	\N	1	2	2
\.


--
-- Data for Name: zerver_realmauditlog; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmauditlog (id, backfilled, event_time, acting_user_id, modified_stream_id, modified_user_id, realm_id, extra_data, event_last_message_id, event_type) FROM stdin;
1	f	2021-10-18 12:39:23.110527+00	\N	\N	\N	1	\N	\N	215
2	f	2021-10-18 12:39:23.230823+00	\N	\N	1	1	\N	\N	101
3	f	2021-10-18 12:39:23.233546+00	\N	\N	2	1	\N	\N	101
4	f	2021-10-18 12:39:23.23513+00	\N	\N	3	1	\N	\N	101
5	f	2021-10-18 12:39:23.236589+00	\N	\N	4	1	\N	\N	101
6	f	2021-10-18 12:39:23.238022+00	\N	\N	5	1	\N	\N	101
7	f	2021-10-18 12:39:23.239498+00	\N	\N	6	1	\N	\N	101
8	f	2021-10-18 12:39:23.240761+00	\N	\N	7	1	\N	\N	101
10	f	2021-10-18 12:39:23.856612+00	\N	1	\N	2	\N	\N	601
11	f	2021-10-18 12:39:23.909965+00	\N	2	\N	2	\N	\N	601
12	f	2021-10-18 12:39:23.97129+00	8	\N	8	2	{"10":{"11":{"200":0,"100":1,"300":0,"400":0,"600":0},"12":0}}	\N	101
9	f	2021-10-18 12:39:23.643283+00	8	\N	\N	2	\N	\N	215
13	f	2021-10-18 12:39:24.170088+00	\N	1	8	2	\N	-1	301
14	f	2021-10-18 12:39:24.422786+00	\N	2	8	2	\N	1	301
\.


--
-- Data for Name: zerver_realmdomain; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmdomain (id, domain, realm_id, allow_subdomains) FROM stdin;
\.


--
-- Data for Name: zerver_realmemoji; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmemoji (id, name, realm_id, author_id, file_name, deactivated) FROM stdin;
\.


--
-- Data for Name: zerver_realmfilter; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmfilter (id, pattern, url_format_string, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmplayground; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmplayground (id, url_prefix, name, pygments_language, realm_id) FROM stdin;
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
2	2021-10-20 11:39:24.251463+00	{"template_prefix":"zerver/emails/followup_day2","from_name":null,"from_address":"SUPPORT","language":null,"context":{"realm_uri":"https://localhost","realm_name":"testing","root_domain_uri":"https://localhost","external_uri_scheme":"https://","external_host":"localhost","user_name":"tester","unsubscribe_link":"https://localhost/accounts/unsubscribe/welcome/jtcefpmdclgdrecypwatig6c","keyboard_shortcuts_link":"https://localhost/help/keyboard-shortcuts","realm_creation":true,"email":"test@test.com","is_realm_admin":true,"getting_started_link":"https://localhost/help/getting-your-organization-started-with-zulip"}}	\N	1	2
\.


--
-- Data for Name: zerver_scheduledemail_users; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledemail_users (id, scheduledemail_id, userprofile_id) FROM stdin;
2	2	8
\.


--
-- Data for Name: zerver_scheduledmessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledmessage (id, subject, content, scheduled_timestamp, delivered, realm_id, recipient_id, sender_id, sending_client_id, stream_id, delivery_type) FROM stdin;
\.


--
-- Data for Name: zerver_service; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_service (id, name, base_url, token, interface, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_stream; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_stream (id, name, invite_only, email_token, description, date_created, deactivated, realm_id, is_in_zephyr_realm, history_public_to_subscribers, is_web_public, rendered_description, first_message_id, message_retention_days, recipient_id, stream_post_policy) FROM stdin;
2	core team	t	3c7e3f3e0ed66093447566127d6ce873	A private stream for core team members.	2021-10-18 12:39:23.877338+00	f	2	f	f	f	<p>A private stream for core team members.</p>	2	\N	9	1
1	general	f	d3917e28280e92709ff59a61cff90f59	Everyone is added to this stream by default. Welcome! :octopus:	2021-10-18 12:39:23.690287+00	f	2	f	t	f	<p>Everyone is added to this stream by default. Welcome! <span aria-label="octopus" class="emoji emoji-1f419" role="img" title="octopus">:octopus:</span></p>	5	\N	8	1
\.


--
-- Data for Name: zerver_submessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_submessage (id, msg_type, content, message_id, sender_id) FROM stdin;
\.


--
-- Data for Name: zerver_subscription; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_subscription (id, active, color, desktop_notifications, audible_notifications, recipient_id, user_profile_id, pin_to_top, push_notifications, email_notifications, is_muted, wildcard_mentions_notify, role, is_user_active) FROM stdin;
1	t	#c2c2c2	\N	\N	1	1	f	\N	\N	f	\N	50	t
2	t	#c2c2c2	\N	\N	2	2	f	\N	\N	f	\N	50	t
3	t	#c2c2c2	\N	\N	3	3	f	\N	\N	f	\N	50	t
4	t	#c2c2c2	\N	\N	4	4	f	\N	\N	f	\N	50	t
5	t	#c2c2c2	\N	\N	5	5	f	\N	\N	f	\N	50	t
6	t	#c2c2c2	\N	\N	6	6	f	\N	\N	f	\N	50	t
7	t	#c2c2c2	\N	\N	7	7	f	\N	\N	f	\N	50	t
8	t	#c2c2c2	\N	\N	10	8	f	\N	\N	f	\N	50	t
9	t	#76ce90	\N	\N	8	8	f	\N	\N	f	\N	50	t
10	t	#fae589	\N	\N	9	8	f	\N	\N	f	\N	50	t
\.


--
-- Data for Name: zerver_useractivity; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_useractivity (id, query, count, last_visit, client_id, user_profile_id) FROM stdin;
1	log_into_subdomain	1	2021-10-18 12:39:26+00	1	8
6	update_message_flags	1	2021-10-18 12:39:27+00	1	8
7	report_narrow_times	1	2021-10-18 12:39:27+00	1	8
8	set_tutorial_status	1	2021-10-18 12:39:28+00	1	8
2	home_real	2	2021-10-18 12:39:49+00	1	8
3	/api/v1/events/internal	4	2021-10-18 12:39:50+00	5	8
4	get_events	4	2021-10-18 12:39:51+00	1	8
5	get_messages_backend	6	2021-10-18 12:39:51+00	1	8
9	cleanup_event_queue	2	2021-10-18 12:39:56+00	1	8
\.


--
-- Data for Name: zerver_useractivityinterval; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_useractivityinterval (id, start, "end", user_profile_id) FROM stdin;
1	2021-10-18 12:39:27+00	2021-10-18 12:54:51+00	8
\.


--
-- Data for Name: zerver_usergroup; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usergroup (id, name, realm_id, description) FROM stdin;
\.


--
-- Data for Name: zerver_usergroupmembership; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usergroupmembership (id, user_group_id, user_profile_id) FROM stdin;
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

COPY zulip.zerver_userpresence (id, "timestamp", status, client_id, user_profile_id, realm_id) FROM stdin;
1	2021-10-18 12:39:51+00	1	1	8	2
\.


--
-- Data for Name: zerver_userprofile; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userprofile (id, password, last_login, is_superuser, email, is_staff, is_active, is_bot, date_joined, is_mirror_dummy, full_name, api_key, enable_stream_desktop_notifications, enable_stream_audible_notifications, enable_desktop_notifications, enable_sounds, enable_offline_email_notifications, enable_offline_push_notifications, enable_digest_emails, last_reminder, rate_limits, default_all_public_streams, enter_sends, twenty_four_hour_time, avatar_source, tutorial_status, onboarding_steps, bot_owner_id, default_events_register_stream_id, default_sending_stream_id, realm_id, left_side_userlist, can_forge_sender, bot_type, default_language, tos_version, enable_online_push_notifications, pm_content_in_desktop_notifications, avatar_version, timezone, emojiset, last_active_message_id, long_term_idle, high_contrast_mode, enable_stream_push_notifications, enable_stream_email_notifications, realm_name_in_notifications, translate_emoticons, message_content_in_email_notifications, dense_mode, delivery_email, starred_message_counts, is_billing_admin, enable_login_emails, notification_sound, fluid_layout_width, demote_inactive_streams, avatar_hash, desktop_icon_count_display, role, wildcard_mentions_notify, recipient_id, presence_enabled, zoom_token, color_scheme, can_create_users, default_view, enable_marketing_emails) FROM stdin;
2	!rNpv6AaSl78JEAnuYi8DgVrx3rljmMApN1gtSeOZ	2021-10-18 12:39:23.233546+00	f	nagios-receive-bot@zulip.com	f	t	t	2021-10-18 12:39:23.233546+00	f	Nagios Receive Bot	ZfKSD0PdoTdb8nq8dePgMswKGNaCnVWD	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	2	\N	\N	1	f	f	1	en	\N	t	t	1		google-blob	\N	f	f	f	f	f	f	t	t	nagios-receive-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	2	t	\N	1	f	recent_topics	t
3	!f5tjx7GeSfEOu76WARugwyvCUslvpIt3PlPLVV0P	2021-10-18 12:39:23.23513+00	f	nagios-send-bot@zulip.com	f	t	t	2021-10-18 12:39:23.23513+00	f	Nagios Send Bot	baAQqRKPhrQLbpTnFNqm9ZeTEDjrdKqr	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	3	\N	\N	1	f	f	1	en	\N	t	t	1		google-blob	\N	f	f	f	f	f	f	t	t	nagios-send-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	3	t	\N	1	f	recent_topics	t
4	!swlflED8qS5mPp4urlJZueakBciNQ1r4l5G8YmUg	2021-10-18 12:39:23.236589+00	f	nagios-staging-receive-bot@zulip.com	f	t	t	2021-10-18 12:39:23.236589+00	f	Nagios Staging Receive Bot	01Tvu4EnbUEbOIpl2x4YzSzBqz75uOkz	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	4	\N	\N	1	f	f	1	en	\N	t	t	1		google-blob	\N	f	f	f	f	f	f	t	t	nagios-staging-receive-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	4	t	\N	1	f	recent_topics	t
5	!gxx2r0fbV8JI3Mh54iprhna89hiC6D4eikQAXBuI	2021-10-18 12:39:23.238022+00	f	nagios-staging-send-bot@zulip.com	f	t	t	2021-10-18 12:39:23.238022+00	f	Nagios Staging Send Bot	upivXfhgENdsDtrKZTSTs9ZNSAkC7M7C	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	5	\N	\N	1	f	f	1	en	\N	t	t	1		google-blob	\N	f	f	f	f	f	f	t	t	nagios-staging-send-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	5	t	\N	1	f	recent_topics	t
6	!E5ckeuzBet2ANhIId7HS8UxosSPYfGUDkS9aeska	2021-10-18 12:39:23.239498+00	f	notification-bot@zulip.com	f	t	t	2021-10-18 12:39:23.239498+00	f	Notification Bot	eUEDCHwxV3ozUVnfrwZnei74EGm02SnW	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	6	\N	\N	1	f	f	1	en	\N	t	t	1		google-blob	\N	f	f	f	f	f	f	t	t	notification-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	6	t	\N	1	f	recent_topics	t
7	!SPXePfBVwrSUDJiZtfxxVpiVbWNkdAmm8WjogNKP	2021-10-18 12:39:23.240761+00	f	welcome-bot@zulip.com	f	t	t	2021-10-18 12:39:23.240761+00	f	Welcome Bot	Y9bq3c7zaFMVn7QQpwHuBc5DIOp0ZNqc	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	7	\N	\N	1	f	f	1	en	\N	t	t	1		google-blob	\N	f	f	f	f	f	f	t	t	welcome-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	7	t	\N	1	f	recent_topics	t
1	!0dYPlXvR6YojAdKekMuxrpW37sRnROwEVMkAozIC	2021-10-18 12:39:23.230823+00	f	emailgateway@zulip.com	f	t	t	2021-10-18 12:39:23.230823+00	f	Email Gateway	6P0AVv7sSRSffWp8njjChVCOr2WGk2Sa	f	f	t	t	t	t	t	\N		f	t	f	G	F	[]	1	\N	\N	1	f	t	1	en	\N	t	t	1		google-blob	\N	f	f	f	f	f	f	t	t	emailgateway@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	1	t	\N	1	f	recent_topics	t
8	argon2$argon2id$v=19$m=102400,t=2,p=8$aWVoNjNVV1MwOFFIMWVCQm1VV1VYMA$/H/8yWumuwqAIihEy+5z/Q	2021-10-18 12:39:49.95814+00	f	test@test.com	f	t	f	2021-10-18 12:39:23.97129+00	f	tester	o91T8fOkBRLxoknLd0wuPD52g0ojj8hg	f	f	t	t	t	t	t	\N		f	f	f	G	S	[]	\N	\N	\N	2	f	f	\N	en	\N	t	t	1	Europe/London	google-blob	\N	f	f	f	f	f	f	t	t	test@test.com	t	f	t	zulip	f	1	\N	1	100	t	10	t	\N	1	t	recent_topics	t
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

COPY zulip.zerver_userstatus (id, "timestamp", status, client_id, user_profile_id, status_text) FROM stdin;
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

SELECT pg_catalog.setval('zulip.auth_permission_id_seq', 272, true);


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

SELECT pg_catalog.setval('zulip.django_content_type_id_seq', 68, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.django_migrations_id_seq', 369, true);


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

SELECT pg_catalog.setval('zulip.zerver_usergroup_id_seq', 1, false);


--
-- Name: zerver_usergroupmembership_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_usergroupmembership_id_seq', 1, false);


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
-- Name: zerver_archivedreaction zerver_archivedreaction_user_profile_id_message__5892ae9e_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedreaction
    ADD CONSTRAINT zerver_archivedreaction_user_profile_id_message__5892ae9e_uniq UNIQUE (user_profile_id, message_id, emoji_name);


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
-- Name: zerver_mutedtopic zerver_mutedtopic_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_mutedtopic
    ADD CONSTRAINT zerver_mutedtopic_pkey PRIMARY KEY (id);


--
-- Name: zerver_mutedtopic zerver_mutedtopic_user_profile_id_stream_i_2cb30f72_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_mutedtopic
    ADD CONSTRAINT zerver_mutedtopic_user_profile_id_stream_i_2cb30f72_uniq UNIQUE (user_profile_id, stream_id, topic_name);


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
-- Name: zerver_reaction zerver_reaction_user_profile_id_message__7d47bf38_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_reaction
    ADD CONSTRAINT zerver_reaction_user_profile_id_message__7d47bf38_uniq UNIQUE (user_profile_id, message_id, emoji_name);


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
-- Name: zerver_userpresence zerver_userpresence_user_profile_id_client_id_5fdcf4f4_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userpresence
    ADD CONSTRAINT zerver_userpresence_user_profile_id_client_id_5fdcf4f4_uniq UNIQUE (user_profile_id, client_id);


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

CREATE INDEX zerver_mutedtopic_recipient_id_e1901302 ON zulip.zerver_mutedtopic USING btree (recipient_id);


--
-- Name: zerver_mutedtopic_stream_id_acbff20e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_mutedtopic_stream_id_acbff20e ON zulip.zerver_mutedtopic USING btree (stream_id);


--
-- Name: zerver_mutedtopic_stream_topic; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_mutedtopic_stream_topic ON zulip.zerver_mutedtopic USING btree (stream_id, upper((topic_name)::text));


--
-- Name: zerver_mutedtopic_user_profile_id_4f8a692c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_mutedtopic_user_profile_id_4f8a692c ON zulip.zerver_mutedtopic USING btree (user_profile_id);


--
-- Name: zerver_muteduser_muted_user_id_d4b66dff; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_muteduser_muted_user_id_d4b66dff ON zulip.zerver_muteduser USING btree (muted_user_id);


--
-- Name: zerver_muteduser_user_profile_id_aeb57a40; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_muteduser_user_profile_id_aeb57a40 ON zulip.zerver_muteduser USING btree (user_profile_id);


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
-- Name: zerver_service_user_profile_id_111b0c49; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_service_user_profile_id_111b0c49 ON zulip.zerver_service USING btree (user_profile_id);


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
-- Name: zerver_subscription_role_6523b199; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_subscription_role_6523b199 ON zulip.zerver_subscription USING btree (role);


--
-- Name: zerver_subscription_user_profile_id_1773aa42; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_subscription_user_profile_id_1773aa42 ON zulip.zerver_subscription USING btree (user_profile_id);


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
-- Name: zerver_userpresence_client_id_ed703e94; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_client_id_ed703e94 ON zulip.zerver_userpresence USING btree (client_id);


--
-- Name: zerver_userpresence_realm_id_5c4ef5a9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_realm_id_5c4ef5a9 ON zulip.zerver_userpresence USING btree (realm_id);


--
-- Name: zerver_userpresence_realm_id_timestamp_25f410da_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_realm_id_timestamp_25f410da_idx ON zulip.zerver_userpresence USING btree (realm_id, "timestamp");


--
-- Name: zerver_userpresence_user_profile_id_b67b4092; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_user_profile_id_b67b4092 ON zulip.zerver_userpresence USING btree (user_profile_id);


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
-- Name: fts_update_log fts_update_log_notify; Type: TRIGGER; Schema: zulip; Owner: zulip
--

CREATE TRIGGER fts_update_log_notify AFTER INSERT ON zulip.fts_update_log FOR EACH STATEMENT EXECUTE PROCEDURE zulip.do_notify_fts_update_log();


--
-- Name: zerver_message zerver_message_update_search_tsvector_async; Type: TRIGGER; Schema: zulip; Owner: zulip
--

CREATE TRIGGER zerver_message_update_search_tsvector_async BEFORE INSERT OR UPDATE OF subject, rendered_content ON zulip.zerver_message FOR EACH ROW EXECUTE PROCEDURE zulip.append_to_fts_update_log();


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
-- Name: zerver_huddle zerver_huddle_recipient_id_e3e1fadc_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_huddle
    ADD CONSTRAINT zerver_huddle_recipient_id_e3e1fadc_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_mutedtopic zerver_mutedtopic_recipient_id_e1901302_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_mutedtopic
    ADD CONSTRAINT zerver_mutedtopic_recipient_id_e1901302_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_mutedtopic zerver_mutedtopic_stream_id_acbff20e_fk_zerver_stream_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_mutedtopic
    ADD CONSTRAINT zerver_mutedtopic_stream_id_acbff20e_fk_zerver_stream_id FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_mutedtopic zerver_mutedtopic_user_profile_id_4f8a692c_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_mutedtopic
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
-- Name: zerver_userpresence zerver_userpresence_client_id_ed703e94_fk_zerver_client_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userpresence
    ADD CONSTRAINT zerver_userpresence_client_id_ed703e94_fk_zerver_client_id FOREIGN KEY (client_id) REFERENCES zulip.zerver_client(id) DEFERRABLE INITIALLY DEFERRED;


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

