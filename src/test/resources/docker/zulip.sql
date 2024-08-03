--
-- PostgreSQL database dump
--

-- Dumped from database version 14.10
-- Dumped by pg_dump version 14.10

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
    id bigint NOT NULL,
    property character varying(40) NOT NULL,
    end_time timestamp with time zone NOT NULL,
    state smallint NOT NULL,
    CONSTRAINT analytics_fillstate_state_check CHECK ((state >= 0))
);


ALTER TABLE zulip.analytics_fillstate OWNER TO zulip;

--
-- Name: analytics_fillstate_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.analytics_fillstate ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.analytics_fillstate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: analytics_installationcount; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_installationcount (
    id bigint NOT NULL,
    property character varying(32) NOT NULL,
    end_time timestamp with time zone NOT NULL,
    value bigint NOT NULL,
    subgroup character varying(16)
);


ALTER TABLE zulip.analytics_installationcount OWNER TO zulip;

--
-- Name: analytics_installationcount_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.analytics_installationcount ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.analytics_installationcount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: analytics_realmcount; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_realmcount (
    id bigint NOT NULL,
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

ALTER TABLE zulip.analytics_realmcount ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.analytics_realmcount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: analytics_streamcount; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_streamcount (
    id bigint NOT NULL,
    realm_id integer NOT NULL,
    stream_id bigint NOT NULL,
    property character varying(32) NOT NULL,
    end_time timestamp with time zone NOT NULL,
    value bigint NOT NULL,
    subgroup character varying(16)
);


ALTER TABLE zulip.analytics_streamcount OWNER TO zulip;

--
-- Name: analytics_streamcount_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.analytics_streamcount ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.analytics_streamcount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: analytics_usercount; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.analytics_usercount (
    id bigint NOT NULL,
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

ALTER TABLE zulip.analytics_usercount ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.analytics_usercount_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE zulip.auth_group_permissions OWNER TO zulip;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: confirmation_confirmation; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.confirmation_confirmation (
    id bigint NOT NULL,
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

ALTER TABLE zulip.confirmation_confirmation ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.confirmation_confirmation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: confirmation_realmcreationkey; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.confirmation_realmcreationkey (
    id bigint NOT NULL,
    creation_key character varying(40) NOT NULL,
    date_created timestamp with time zone NOT NULL,
    presume_email_valid boolean NOT NULL
);


ALTER TABLE zulip.confirmation_realmcreationkey OWNER TO zulip;

--
-- Name: confirmation_realmcreationkey_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.confirmation_realmcreationkey ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.confirmation_realmcreationkey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE zulip.django_migrations OWNER TO zulip;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    id bigint NOT NULL,
    message_id integer NOT NULL
);


ALTER TABLE zulip.fts_update_log OWNER TO zulip;

--
-- Name: fts_update_log_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

CREATE SEQUENCE zulip.fts_update_log_id_seq
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
    created_at timestamp with time zone,
    last_used_at timestamp with time zone,
    CONSTRAINT otp_static_staticdevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0))
);


ALTER TABLE zulip.otp_static_staticdevice OWNER TO zulip;

--
-- Name: otp_static_staticdevice_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.otp_static_staticdevice ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.otp_static_staticdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.otp_static_statictoken ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.otp_static_statictoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    created_at timestamp with time zone,
    last_used_at timestamp with time zone,
    CONSTRAINT otp_totp_totpdevice_digits_check CHECK ((digits >= 0)),
    CONSTRAINT otp_totp_totpdevice_step_check CHECK ((step >= 0)),
    CONSTRAINT otp_totp_totpdevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0)),
    CONSTRAINT otp_totp_totpdevice_tolerance_check CHECK ((tolerance >= 0))
);


ALTER TABLE zulip.otp_totp_totpdevice OWNER TO zulip;

--
-- Name: otp_totp_totpdevice_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.otp_totp_totpdevice ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.otp_totp_totpdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.social_auth_association ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.social_auth_association_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.social_auth_code ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.social_auth_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.social_auth_nonce ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.social_auth_nonce_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: social_auth_partial; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.social_auth_partial (
    id bigint NOT NULL,
    token character varying(32) NOT NULL,
    next_step smallint NOT NULL,
    backend character varying(32) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    data jsonb NOT NULL,
    CONSTRAINT social_auth_partial_next_step_check CHECK ((next_step >= 0))
);


ALTER TABLE zulip.social_auth_partial OWNER TO zulip;

--
-- Name: social_auth_partial_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.social_auth_partial ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.social_auth_partial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: social_auth_usersocialauth; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.social_auth_usersocialauth (
    id bigint NOT NULL,
    provider character varying(32) NOT NULL,
    uid character varying(255) NOT NULL,
    user_id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    extra_data jsonb NOT NULL
);


ALTER TABLE zulip.social_auth_usersocialauth OWNER TO zulip;

--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.social_auth_usersocialauth ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.social_auth_usersocialauth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    throttling_failure_timestamp timestamp with time zone,
    throttling_failure_count integer NOT NULL,
    number character varying(128) NOT NULL,
    key character varying(40) NOT NULL,
    method character varying(4) NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT two_factor_phonedevice_throttling_failure_count_check CHECK ((throttling_failure_count >= 0))
);


ALTER TABLE zulip.two_factor_phonedevice OWNER TO zulip;

--
-- Name: two_factor_phonedevice_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.two_factor_phonedevice ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.two_factor_phonedevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_alertword; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_alertword (
    id bigint NOT NULL,
    word text NOT NULL,
    realm_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_alertword OWNER TO zulip;

--
-- Name: zerver_alertword_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_alertword ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_alertword_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_archivedattachment; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedattachment (
    id bigint NOT NULL,
    file_name text NOT NULL,
    path_id text NOT NULL,
    is_realm_public boolean,
    create_time timestamp with time zone NOT NULL,
    size integer NOT NULL,
    owner_id integer NOT NULL,
    realm_id integer NOT NULL,
    is_web_public boolean,
    content_type text
);


ALTER TABLE zulip.zerver_archivedattachment OWNER TO zulip;

--
-- Name: zerver_archivedattachment_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_archivedattachment ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_archivedattachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_archivedattachment_messages; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedattachment_messages (
    id bigint NOT NULL,
    archivedattachment_id bigint NOT NULL,
    archivedmessage_id integer NOT NULL
);


ALTER TABLE zulip.zerver_archivedattachment_messages OWNER TO zulip;

--
-- Name: zerver_archivedattachment_messages_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_archivedattachment_messages ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_archivedattachment_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    archive_transaction_id bigint NOT NULL,
    realm_id integer NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    CONSTRAINT zerver_archivedmessage_type_check CHECK ((type >= 0))
);


ALTER TABLE zulip.zerver_archivedmessage OWNER TO zulip;

--
-- Name: zerver_archivedmessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_archivedmessage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_archivedmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_archivedreaction; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedreaction (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_archivedreaction ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_archivedreaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_archivedsubmessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivedsubmessage (
    id bigint NOT NULL,
    msg_type text NOT NULL,
    content text NOT NULL,
    message_id integer NOT NULL,
    sender_id integer NOT NULL
);


ALTER TABLE zulip.zerver_archivedsubmessage OWNER TO zulip;

--
-- Name: zerver_archivedsubmessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_archivedsubmessage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_archivedsubmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.zerver_archivedusermessage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_archivedusermessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_archivetransaction; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_archivetransaction (
    id bigint NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    restored boolean NOT NULL,
    type smallint NOT NULL,
    realm_id integer,
    restored_timestamp timestamp with time zone,
    CONSTRAINT zerver_archivetransaction_type_check CHECK ((type >= 0))
);


ALTER TABLE zulip.zerver_archivetransaction OWNER TO zulip;

--
-- Name: zerver_archivetransaction_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_archivetransaction ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_archivetransaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_attachment; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_attachment (
    id bigint NOT NULL,
    file_name text NOT NULL,
    path_id text NOT NULL,
    create_time timestamp with time zone NOT NULL,
    owner_id integer NOT NULL,
    is_realm_public boolean,
    realm_id integer NOT NULL,
    size integer NOT NULL,
    is_web_public boolean,
    content_type text
);


ALTER TABLE zulip.zerver_attachment OWNER TO zulip;

--
-- Name: zerver_attachment_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_attachment ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_attachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_attachment_messages; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_attachment_messages (
    id bigint NOT NULL,
    attachment_id bigint NOT NULL,
    message_id integer NOT NULL
);


ALTER TABLE zulip.zerver_attachment_messages OWNER TO zulip;

--
-- Name: zerver_attachment_messages_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_attachment_messages ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_attachment_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_attachment_scheduled_messages; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_attachment_scheduled_messages (
    id bigint NOT NULL,
    attachment_id bigint NOT NULL,
    scheduledmessage_id bigint NOT NULL
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
    id bigint NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    bot_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_botconfigdata OWNER TO zulip;

--
-- Name: zerver_botstoragedata; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_botstoragedata (
    id bigint NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    bot_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_botstoragedata OWNER TO zulip;

--
-- Name: zerver_botuserconfigdata_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_botconfigdata ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_botuserconfigdata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_botuserstatedata_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_botstoragedata ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_botuserstatedata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.zerver_client ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_customprofilefield; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_customprofilefield (
    id bigint NOT NULL,
    name character varying(40) NOT NULL,
    field_type smallint NOT NULL,
    realm_id integer NOT NULL,
    hint character varying(80) NOT NULL,
    field_data text NOT NULL,
    "order" integer NOT NULL,
    display_in_profile_summary boolean NOT NULL,
    required boolean NOT NULL,
    CONSTRAINT zerver_customprofilefield_field_type_check CHECK ((field_type >= 0))
);


ALTER TABLE zulip.zerver_customprofilefield OWNER TO zulip;

--
-- Name: zerver_customprofilefield_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_customprofilefield ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_customprofilefield_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_customprofilefieldvalue; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_customprofilefieldvalue (
    id bigint NOT NULL,
    value text NOT NULL,
    field_id bigint NOT NULL,
    user_profile_id integer NOT NULL,
    rendered_value text
);


ALTER TABLE zulip.zerver_customprofilefieldvalue OWNER TO zulip;

--
-- Name: zerver_customprofilefieldvalue_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_customprofilefieldvalue ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_customprofilefieldvalue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_defaultstream; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_defaultstream (
    id bigint NOT NULL,
    realm_id integer NOT NULL,
    stream_id bigint NOT NULL
);


ALTER TABLE zulip.zerver_defaultstream OWNER TO zulip;

--
-- Name: zerver_defaultstream_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_defaultstream ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_defaultstream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_defaultstreamgroup; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_defaultstreamgroup (
    id bigint NOT NULL,
    name character varying(60) NOT NULL,
    realm_id integer NOT NULL,
    description character varying(1024) NOT NULL
);


ALTER TABLE zulip.zerver_defaultstreamgroup OWNER TO zulip;

--
-- Name: zerver_defaultstreamgroup_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_defaultstreamgroup ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_defaultstreamgroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_defaultstreamgroup_streams; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_defaultstreamgroup_streams (
    id bigint NOT NULL,
    defaultstreamgroup_id bigint NOT NULL,
    stream_id bigint NOT NULL
);


ALTER TABLE zulip.zerver_defaultstreamgroup_streams OWNER TO zulip;

--
-- Name: zerver_defaultstreamgroup_streams_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_defaultstreamgroup_streams ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_defaultstreamgroup_streams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_draft; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_draft (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_draft ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_draft_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_emailchangestatus; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_emailchangestatus (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_emailchangestatus ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_emailchangestatus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_groupgroupmembership; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_groupgroupmembership (
    id bigint NOT NULL,
    subgroup_id bigint NOT NULL,
    supergroup_id bigint NOT NULL
);


ALTER TABLE zulip.zerver_groupgroupmembership OWNER TO zulip;

--
-- Name: zerver_groupgroupmembership_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_groupgroupmembership ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_groupgroupmembership_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_huddle; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_huddle (
    id bigint NOT NULL,
    huddle_hash character varying(40) NOT NULL,
    recipient_id integer
);


ALTER TABLE zulip.zerver_huddle OWNER TO zulip;

--
-- Name: zerver_huddle_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_huddle ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_huddle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_imageattachment; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_imageattachment (
    id bigint NOT NULL,
    path_id text NOT NULL,
    original_width_px integer NOT NULL,
    original_height_px integer NOT NULL,
    frames integer NOT NULL,
    thumbnail_metadata jsonb NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_imageattachment OWNER TO zulip;

--
-- Name: zerver_imageattachment_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_imageattachment ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_imageattachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    realm_id integer NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    CONSTRAINT zerver_message_type_check CHECK ((type >= 0))
);
ALTER TABLE ONLY zulip.zerver_message ALTER COLUMN search_tsvector SET STATISTICS 10000;


ALTER TABLE zulip.zerver_message OWNER TO zulip;

--
-- Name: zerver_message_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_message ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_missedmessageemailaddress; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_missedmessageemailaddress (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_missedmessageemailaddress ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_missedmessageemailaddress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_multiuseinvite; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_multiuseinvite (
    id bigint NOT NULL,
    realm_id integer NOT NULL,
    referred_by_id integer NOT NULL,
    invited_as smallint NOT NULL,
    status integer NOT NULL,
    include_realm_default_subscriptions boolean NOT NULL,
    CONSTRAINT zerver_multiuseinvite_invited_as_check CHECK ((invited_as >= 0))
);


ALTER TABLE zulip.zerver_multiuseinvite OWNER TO zulip;

--
-- Name: zerver_multiuseinvite_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_multiuseinvite ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_multiuseinvite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_multiuseinvite_streams; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_multiuseinvite_streams (
    id bigint NOT NULL,
    multiuseinvite_id bigint NOT NULL,
    stream_id bigint NOT NULL
);


ALTER TABLE zulip.zerver_multiuseinvite_streams OWNER TO zulip;

--
-- Name: zerver_multiuseinvite_streams_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_multiuseinvite_streams ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_multiuseinvite_streams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_usertopic; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usertopic (
    id bigint NOT NULL,
    topic_name character varying(60) NOT NULL,
    recipient_id integer NOT NULL,
    stream_id bigint NOT NULL,
    user_profile_id integer NOT NULL,
    last_updated timestamp with time zone NOT NULL,
    visibility_policy smallint NOT NULL
);


ALTER TABLE zulip.zerver_usertopic OWNER TO zulip;

--
-- Name: zerver_mutedtopic_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_usertopic ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_mutedtopic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_muteduser; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_muteduser (
    id bigint NOT NULL,
    date_muted timestamp with time zone NOT NULL,
    muted_user_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_muteduser OWNER TO zulip;

--
-- Name: zerver_muteduser_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_muteduser ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_muteduser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_namedusergroup; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_namedusergroup (
    usergroup_ptr_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    is_system_group boolean NOT NULL,
    can_mention_group_id bigint NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_namedusergroup OWNER TO zulip;

--
-- Name: zerver_onboardingstep; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_onboardingstep (
    id bigint NOT NULL,
    onboarding_step character varying(40) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE zulip.zerver_onboardingstep OWNER TO zulip;

--
-- Name: zerver_onboardingstep_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_onboardingstep ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_onboardingstep_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_onboardingusermessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_onboardingusermessage (
    id bigint NOT NULL,
    flags bigint NOT NULL,
    message_id integer NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_onboardingusermessage OWNER TO zulip;

--
-- Name: zerver_onboardingusermessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_onboardingusermessage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_onboardingusermessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_preregistrationrealm; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_preregistrationrealm (
    id bigint NOT NULL,
    name character varying(40) NOT NULL,
    org_type smallint NOT NULL,
    string_id character varying(40) NOT NULL,
    email character varying(254) NOT NULL,
    status integer NOT NULL,
    created_realm_id integer,
    created_user_id integer,
    default_language character varying(50) NOT NULL,
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
    id bigint NOT NULL,
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
    multiuse_invite_id bigint,
    include_realm_default_subscriptions boolean NOT NULL,
    notify_referrer_on_join boolean NOT NULL,
    CONSTRAINT zerver_preregistrationuser_invited_as_check CHECK ((invited_as >= 0))
);


ALTER TABLE zulip.zerver_preregistrationuser OWNER TO zulip;

--
-- Name: zerver_preregistrationuser_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_preregistrationuser ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_preregistrationuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_preregistrationuser_streams; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_preregistrationuser_streams (
    id bigint NOT NULL,
    preregistrationuser_id bigint NOT NULL,
    stream_id bigint NOT NULL
);


ALTER TABLE zulip.zerver_preregistrationuser_streams OWNER TO zulip;

--
-- Name: zerver_preregistrationuser_streams_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_preregistrationuser_streams ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_preregistrationuser_streams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_presencesequence; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_presencesequence (
    id bigint NOT NULL,
    last_update_id bigint NOT NULL,
    realm_id integer NOT NULL,
    CONSTRAINT zerver_presencesequence_last_update_id_check CHECK ((last_update_id >= 0))
);


ALTER TABLE zulip.zerver_presencesequence OWNER TO zulip;

--
-- Name: zerver_presencesequence_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_presencesequence ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_presencesequence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_pushdevicetoken; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_pushdevicetoken (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_pushdevicetoken ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_pushdevicetoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_reaction; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_reaction (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_reaction ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_reaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    new_stream_announcements_stream_id bigint,
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
    signup_announcements_stream_id bigint,
    max_invites integer,
    message_visibility_limit integer,
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
    default_code_block_language text NOT NULL,
    wildcard_mention_policy smallint NOT NULL,
    deactivated_redirect character varying(128),
    invite_to_realm_policy smallint NOT NULL,
    giphy_rating smallint NOT NULL,
    move_messages_between_streams_policy smallint NOT NULL,
    edit_topic_policy smallint NOT NULL,
    add_custom_emoji_policy smallint NOT NULL,
    demo_organization_scheduled_deletion_date timestamp with time zone,
    delete_own_message_policy smallint NOT NULL,
    create_web_public_stream_policy smallint NOT NULL,
    enable_spectator_access boolean NOT NULL,
    want_advertise_in_communities_directory boolean NOT NULL,
    enable_read_receipts boolean NOT NULL,
    move_messages_within_stream_limit_seconds integer,
    move_messages_between_streams_limit_seconds integer,
    create_multiuse_invite_group_id bigint NOT NULL,
    jitsi_server_url character varying(200),
    enable_guest_user_indicator boolean NOT NULL,
    uuid uuid NOT NULL,
    uuid_owner_secret text NOT NULL,
    can_access_all_users_group_id bigint NOT NULL,
    push_notifications_enabled boolean NOT NULL,
    push_notifications_enabled_end_timestamp timestamp with time zone,
    zulip_update_announcements_stream_id bigint,
    zulip_update_announcements_level integer,
    require_unique_names boolean NOT NULL,
    custom_upload_quota_gb integer,
    can_create_public_channel_group_id bigint NOT NULL,
    can_create_private_channel_group_id bigint NOT NULL,
    direct_message_initiator_group_id bigint NOT NULL,
    direct_message_permission_group_id bigint NOT NULL,
    CONSTRAINT zerver_realm_add_custom_emoji_policy_check CHECK ((add_custom_emoji_policy >= 0)),
    CONSTRAINT zerver_realm_bot_creation_policy_check CHECK ((bot_creation_policy >= 0)),
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
    CONSTRAINT zerver_realm_user_group_edit_policy_check CHECK ((user_group_edit_policy >= 0)),
    CONSTRAINT zerver_realm_video_chat_provider_check CHECK ((video_chat_provider >= 0)),
    CONSTRAINT zerver_realm_waiting_period_threshold_check CHECK ((waiting_period_threshold >= 0)),
    CONSTRAINT zerver_realm_wildcard_mention_policy_check CHECK ((wildcard_mention_policy >= 0)),
    CONSTRAINT zerver_realm_zulip_update_announcements_level_check CHECK ((zulip_update_announcements_level >= 0))
);


ALTER TABLE zulip.zerver_realm OWNER TO zulip;

--
-- Name: zerver_realm_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realm ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_realmdomain; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmdomain (
    id bigint NOT NULL,
    domain character varying(80) NOT NULL,
    realm_id integer NOT NULL,
    allow_subdomains boolean NOT NULL
);


ALTER TABLE zulip.zerver_realmdomain OWNER TO zulip;

--
-- Name: zerver_realmalias_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmdomain ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmalias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_realmauditlog; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmauditlog (
    id bigint NOT NULL,
    backfilled boolean NOT NULL,
    event_time timestamp with time zone NOT NULL,
    acting_user_id integer,
    modified_stream_id bigint,
    modified_user_id integer,
    realm_id integer NOT NULL,
    event_last_message_id integer,
    event_type smallint NOT NULL,
    extra_data jsonb NOT NULL,
    modified_user_group_id bigint,
    CONSTRAINT zerver_realmauditlog_event_type_int_check CHECK ((event_type >= 0))
);


ALTER TABLE zulip.zerver_realmauditlog OWNER TO zulip;

--
-- Name: zerver_realmauditlog_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmauditlog ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmauditlog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_realmauthenticationmethod; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmauthenticationmethod (
    id bigint NOT NULL,
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
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_realmemoji ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmemoji_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_realmfilter; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmfilter (
    id bigint NOT NULL,
    pattern text NOT NULL,
    realm_id integer NOT NULL,
    url_template text NOT NULL,
    "order" integer NOT NULL
);


ALTER TABLE zulip.zerver_realmfilter OWNER TO zulip;

--
-- Name: zerver_realmfilter_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmfilter ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmfilter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_realmplayground; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmplayground (
    id bigint NOT NULL,
    name text NOT NULL,
    pygments_language character varying(40) NOT NULL,
    realm_id integer NOT NULL,
    url_template text NOT NULL
);


ALTER TABLE zulip.zerver_realmplayground OWNER TO zulip;

--
-- Name: zerver_realmplayground_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmplayground ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmplayground_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_realmreactivationstatus; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmreactivationstatus (
    id bigint NOT NULL,
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
    id bigint NOT NULL,
    enter_sends boolean NOT NULL,
    left_side_userlist boolean NOT NULL,
    default_language character varying(50) NOT NULL,
    web_home_view text NOT NULL,
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
    web_escape_navigates_to_home_view boolean NOT NULL,
    display_emoji_reaction_users boolean NOT NULL,
    user_list_style smallint NOT NULL,
    email_address_visibility smallint NOT NULL,
    realm_name_in_email_notifications_policy smallint NOT NULL,
    web_mark_read_on_scroll_policy smallint NOT NULL,
    enable_followed_topic_audible_notifications boolean NOT NULL,
    enable_followed_topic_desktop_notifications boolean NOT NULL,
    enable_followed_topic_email_notifications boolean NOT NULL,
    enable_followed_topic_push_notifications boolean NOT NULL,
    enable_followed_topic_wildcard_mentions_notify boolean NOT NULL,
    web_stream_unreads_count_display_policy smallint NOT NULL,
    automatically_follow_topics_policy smallint NOT NULL,
    automatically_unmute_topics_in_muted_streams_policy smallint NOT NULL,
    automatically_follow_topics_where_mentioned boolean NOT NULL,
    web_font_size_px smallint NOT NULL,
    web_line_height_percent smallint NOT NULL,
    receives_typing_notifications boolean NOT NULL,
    web_navigate_to_sent_message boolean NOT NULL,
    web_channel_default_view smallint DEFAULT 1 NOT NULL,
    web_animate_image_previews text NOT NULL,
    CONSTRAINT zerver_realmuserdefault_automatically_follow_topics_polic_check CHECK ((automatically_follow_topics_policy >= 0)),
    CONSTRAINT zerver_realmuserdefault_automatically_unmute_topics_in_mu_check CHECK ((automatically_unmute_topics_in_muted_streams_policy >= 0)),
    CONSTRAINT zerver_realmuserdefault_color_scheme_check CHECK ((color_scheme >= 0)),
    CONSTRAINT zerver_realmuserdefault_demote_inactive_streams_check CHECK ((demote_inactive_streams >= 0)),
    CONSTRAINT zerver_realmuserdefault_desktop_icon_count_display_check CHECK ((desktop_icon_count_display >= 0)),
    CONSTRAINT zerver_realmuserdefault_email_address_visibility_check CHECK ((email_address_visibility >= 0)),
    CONSTRAINT zerver_realmuserdefault_realm_name_in_email_notifications_check CHECK ((realm_name_in_email_notifications_policy >= 0)),
    CONSTRAINT zerver_realmuserdefault_user_list_style_check CHECK ((user_list_style >= 0)),
    CONSTRAINT zerver_realmuserdefault_web_font_size_px_check CHECK ((web_font_size_px >= 0)),
    CONSTRAINT zerver_realmuserdefault_web_line_height_percent_check CHECK ((web_line_height_percent >= 0)),
    CONSTRAINT zerver_realmuserdefault_web_stream_unreads_count_display__check CHECK ((web_stream_unreads_count_display_policy >= 0))
);


ALTER TABLE zulip.zerver_realmuserdefault OWNER TO zulip;

--
-- Name: zerver_realmuserdefault_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmuserdefault ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmuserdefault_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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

ALTER TABLE zulip.zerver_recipient ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_recipient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_scheduledemail; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_scheduledemail (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_scheduledemail ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_scheduledemail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_scheduledemail_users; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_scheduledemail_users (
    id bigint NOT NULL,
    scheduledemail_id bigint NOT NULL,
    userprofile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_scheduledemail_users OWNER TO zulip;

--
-- Name: zerver_scheduledemail_users_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_scheduledemail_users ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_scheduledemail_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_scheduledmessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_scheduledmessage (
    id bigint NOT NULL,
    subject character varying(60) NOT NULL,
    content text NOT NULL,
    scheduled_timestamp timestamp with time zone NOT NULL,
    delivered boolean NOT NULL,
    realm_id integer NOT NULL,
    recipient_id integer NOT NULL,
    sender_id integer NOT NULL,
    sending_client_id integer NOT NULL,
    stream_id bigint,
    delivery_type smallint NOT NULL,
    rendered_content text NOT NULL,
    has_attachment boolean NOT NULL,
    failed boolean NOT NULL,
    failure_message text,
    delivered_message_id integer,
    read_by_sender boolean NOT NULL,
    CONSTRAINT zerver_scheduledmessage_delivery_type_check CHECK ((delivery_type >= 0))
);


ALTER TABLE zulip.zerver_scheduledmessage OWNER TO zulip;

--
-- Name: zerver_scheduledmessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_scheduledmessage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_scheduledmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_scheduledmessagenotificationemail; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_scheduledmessagenotificationemail (
    id bigint NOT NULL,
    trigger text NOT NULL,
    scheduled_timestamp timestamp with time zone NOT NULL,
    mentioned_user_group_id bigint,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_scheduledmessagenotificationemail OWNER TO zulip;

--
-- Name: zerver_scheduledmessagenotificationemail_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_scheduledmessagenotificationemail ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_scheduledmessagenotificationemail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_service; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_service (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_service ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_stream; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_stream (
    id bigint NOT NULL,
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
    can_remove_subscribers_group_id bigint NOT NULL,
    creator_id integer,
    CONSTRAINT zerver_stream_stream_post_policy_check CHECK ((stream_post_policy >= 0))
);


ALTER TABLE zulip.zerver_stream OWNER TO zulip;

--
-- Name: zerver_stream_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_stream ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_submessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_submessage (
    id bigint NOT NULL,
    msg_type text NOT NULL,
    content text NOT NULL,
    message_id integer NOT NULL,
    sender_id integer NOT NULL
);


ALTER TABLE zulip.zerver_submessage OWNER TO zulip;

--
-- Name: zerver_submessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_submessage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_submessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_subscription; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_subscription (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_subscription ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_useractivity; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_useractivity (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_useractivity ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_useractivity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_useractivityinterval; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_useractivityinterval (
    id bigint NOT NULL,
    start timestamp with time zone NOT NULL,
    "end" timestamp with time zone NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_useractivityinterval OWNER TO zulip;

--
-- Name: zerver_useractivityinterval_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_useractivityinterval ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_useractivityinterval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_usergroup; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usergroup (
    id bigint NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_usergroup OWNER TO zulip;

--
-- Name: zerver_usergroup_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_usergroup ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_usergroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_usergroupmembership; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usergroupmembership (
    id bigint NOT NULL,
    user_group_id bigint NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_usergroupmembership OWNER TO zulip;

--
-- Name: zerver_usergroupmembership_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_usergroupmembership ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_usergroupmembership_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_usermessage; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usermessage (
    flags bigint NOT NULL,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE zulip.zerver_usermessage OWNER TO zulip;

--
-- Name: zerver_usermessage_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_usermessage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_usermessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_userpresence; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userpresence (
    id bigint NOT NULL,
    last_connected_time timestamp with time zone,
    last_active_time timestamp with time zone,
    realm_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    last_update_id bigint NOT NULL,
    CONSTRAINT zerver_userpresence_last_update_id_check CHECK ((last_update_id >= 0))
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
    bot_owner_id integer,
    default_events_register_stream_id bigint,
    default_sending_stream_id bigint,
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
    web_home_view text NOT NULL,
    enable_marketing_emails boolean NOT NULL,
    email_notifications_batching_period_seconds integer NOT NULL,
    enable_drafts_synchronization boolean NOT NULL,
    send_private_typing_notifications boolean NOT NULL,
    send_stream_typing_notifications boolean NOT NULL,
    send_read_receipts boolean NOT NULL,
    web_escape_navigates_to_home_view boolean NOT NULL,
    uuid uuid NOT NULL,
    display_emoji_reaction_users boolean NOT NULL,
    user_list_style smallint NOT NULL,
    email_address_visibility smallint NOT NULL,
    realm_name_in_email_notifications_policy smallint NOT NULL,
    web_mark_read_on_scroll_policy smallint NOT NULL,
    enable_followed_topic_audible_notifications boolean NOT NULL,
    enable_followed_topic_desktop_notifications boolean NOT NULL,
    enable_followed_topic_email_notifications boolean NOT NULL,
    enable_followed_topic_push_notifications boolean NOT NULL,
    enable_followed_topic_wildcard_mentions_notify boolean NOT NULL,
    web_stream_unreads_count_display_policy smallint NOT NULL,
    automatically_follow_topics_policy smallint NOT NULL,
    automatically_unmute_topics_in_muted_streams_policy smallint NOT NULL,
    automatically_follow_topics_where_mentioned boolean NOT NULL,
    web_font_size_px smallint NOT NULL,
    web_line_height_percent smallint NOT NULL,
    receives_typing_notifications boolean NOT NULL,
    web_navigate_to_sent_message boolean NOT NULL,
    web_channel_default_view smallint DEFAULT 1 NOT NULL,
    web_animate_image_previews text NOT NULL,
    CONSTRAINT zerver_userprofile_automatically_follow_topics_policy_check CHECK ((automatically_follow_topics_policy >= 0)),
    CONSTRAINT zerver_userprofile_automatically_unmute_topics_in_muted_s_check CHECK ((automatically_unmute_topics_in_muted_streams_policy >= 0)),
    CONSTRAINT zerver_userprofile_avatar_version_check CHECK ((avatar_version >= 0)),
    CONSTRAINT zerver_userprofile_bot_type_check CHECK ((bot_type >= 0)),
    CONSTRAINT zerver_userprofile_color_scheme_check CHECK ((color_scheme >= 0)),
    CONSTRAINT zerver_userprofile_demote_inactive_streams_check CHECK ((demote_inactive_streams >= 0)),
    CONSTRAINT zerver_userprofile_desktop_icon_count_display_check CHECK ((desktop_icon_count_display >= 0)),
    CONSTRAINT zerver_userprofile_email_address_visibility_check CHECK ((email_address_visibility >= 0)),
    CONSTRAINT zerver_userprofile_realm_name_in_email_notifications_poli_check CHECK ((realm_name_in_email_notifications_policy >= 0)),
    CONSTRAINT zerver_userprofile_role_check CHECK ((role >= 0)),
    CONSTRAINT zerver_userprofile_user_list_style_check CHECK ((user_list_style >= 0)),
    CONSTRAINT zerver_userprofile_web_font_size_px_check CHECK ((web_font_size_px >= 0)),
    CONSTRAINT zerver_userprofile_web_line_height_percent_check CHECK ((web_line_height_percent >= 0)),
    CONSTRAINT zerver_userprofile_web_stream_unreads_count_display_polic_check CHECK ((web_stream_unreads_count_display_policy >= 0))
);


ALTER TABLE zulip.zerver_userprofile OWNER TO zulip;

--
-- Name: zerver_userprofile_groups; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userprofile_groups (
    id bigint NOT NULL,
    userprofile_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE zulip.zerver_userprofile_groups OWNER TO zulip;

--
-- Name: zerver_userprofile_groups_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_userprofile_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_userprofile_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_userprofile_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_userprofile ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_userprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_userprofile_user_permissions; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userprofile_user_permissions (
    id bigint NOT NULL,
    userprofile_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE zulip.zerver_userprofile_user_permissions OWNER TO zulip;

--
-- Name: zerver_userprofile_user_permissions_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_userprofile_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_userprofile_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_userstatus; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_userstatus (
    id bigint NOT NULL,
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

ALTER TABLE zulip.zerver_userstatus ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_userstatus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: fts_update_log id; Type: DEFAULT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.fts_update_log ALTER COLUMN id SET DEFAULT nextval('zulip.fts_update_log_id_seq'::regclass);


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
1	2	8	messages_read::hour	2024-08-02 10:00:00+00	1	\N
2	2	8	messages_read_interactions::hour	2024-08-02 10:00:00+00	1	\N
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
37	Can add message	10	add_message
38	Can change message	10	change_message
39	Can delete message	10	delete_message
40	Can view message	10	view_message
41	Can add preregistration user	11	add_preregistrationuser
42	Can change preregistration user	11	change_preregistrationuser
43	Can delete preregistration user	11	delete_preregistrationuser
44	Can view preregistration user	11	view_preregistrationuser
45	Can add push device token	12	add_pushdevicetoken
46	Can change push device token	12	change_pushdevicetoken
47	Can delete push device token	12	delete_pushdevicetoken
48	Can view push device token	12	view_pushdevicetoken
49	Can add realm	13	add_realm
50	Can change realm	13	change_realm
51	Can delete realm	13	delete_realm
52	Can view realm	13	view_realm
53	Can add realm emoji	14	add_realmemoji
54	Can change realm emoji	14	change_realmemoji
55	Can delete realm emoji	14	delete_realmemoji
56	Can view realm emoji	14	view_realmemoji
57	Can add realm filter	15	add_realmfilter
58	Can change realm filter	15	change_realmfilter
59	Can delete realm filter	15	delete_realmfilter
60	Can view realm filter	15	view_realmfilter
61	Can add recipient	16	add_recipient
62	Can change recipient	16	change_recipient
63	Can delete recipient	16	delete_recipient
64	Can view recipient	16	view_recipient
65	Can add stream	17	add_stream
66	Can change stream	17	change_stream
67	Can delete stream	17	delete_stream
68	Can view stream	17	view_stream
69	Can add subscription	18	add_subscription
70	Can change subscription	18	change_subscription
71	Can delete subscription	18	delete_subscription
72	Can view subscription	18	view_subscription
73	Can add user activity	19	add_useractivity
74	Can change user activity	19	change_useractivity
75	Can delete user activity	19	delete_useractivity
76	Can view user activity	19	view_useractivity
77	Can add user activity interval	20	add_useractivityinterval
78	Can change user activity interval	20	change_useractivityinterval
79	Can delete user activity interval	20	delete_useractivityinterval
80	Can view user activity interval	20	view_useractivityinterval
81	Can add user message	21	add_usermessage
82	Can change user message	21	change_usermessage
83	Can delete user message	21	delete_usermessage
84	Can view user message	21	view_usermessage
85	Can add attachment	22	add_attachment
86	Can change attachment	22	change_attachment
87	Can delete attachment	22	delete_attachment
88	Can view attachment	22	view_attachment
89	Can add reaction	23	add_reaction
90	Can change reaction	23	change_reaction
91	Can delete reaction	23	delete_reaction
92	Can view reaction	23	view_reaction
93	Can add email change status	24	add_emailchangestatus
94	Can change email change status	24	change_emailchangestatus
95	Can delete email change status	24	delete_emailchangestatus
96	Can view email change status	24	view_emailchangestatus
97	Can add realm audit log	25	add_realmauditlog
98	Can change realm audit log	25	change_realmauditlog
189	Can add draft	48	add_draft
99	Can delete realm audit log	25	delete_realmauditlog
100	Can view realm audit log	25	view_realmauditlog
101	Can add archived attachment	26	add_archivedattachment
102	Can change archived attachment	26	change_archivedattachment
103	Can delete archived attachment	26	delete_archivedattachment
104	Can view archived attachment	26	view_archivedattachment
105	Can add archived message	27	add_archivedmessage
106	Can change archived message	27	change_archivedmessage
107	Can delete archived message	27	delete_archivedmessage
108	Can view archived message	27	view_archivedmessage
109	Can add archived user message	28	add_archivedusermessage
110	Can change archived user message	28	change_archivedusermessage
111	Can delete archived user message	28	delete_archivedusermessage
112	Can view archived user message	28	view_archivedusermessage
113	Can add realm domain	29	add_realmdomain
114	Can change realm domain	29	change_realmdomain
115	Can delete realm domain	29	delete_realmdomain
116	Can view realm domain	29	view_realmdomain
117	Can add custom profile field	30	add_customprofilefield
118	Can change custom profile field	30	change_customprofilefield
119	Can delete custom profile field	30	delete_customprofilefield
120	Can view custom profile field	30	view_customprofilefield
121	Can add custom profile field value	31	add_customprofilefieldvalue
122	Can change custom profile field value	31	change_customprofilefieldvalue
123	Can delete custom profile field value	31	delete_customprofilefieldvalue
124	Can view custom profile field value	31	view_customprofilefieldvalue
125	Can add service	32	add_service
126	Can change service	32	change_service
127	Can delete service	32	delete_service
128	Can view service	32	view_service
129	Can add scheduled email	33	add_scheduledemail
130	Can change scheduled email	33	change_scheduledemail
131	Can delete scheduled email	33	delete_scheduledemail
132	Can view scheduled email	33	view_scheduledemail
133	Can add multiuse invite	34	add_multiuseinvite
134	Can change multiuse invite	34	change_multiuseinvite
135	Can delete multiuse invite	34	delete_multiuseinvite
136	Can view multiuse invite	34	view_multiuseinvite
137	Can add default stream group	35	add_defaultstreamgroup
138	Can change default stream group	35	change_defaultstreamgroup
139	Can delete default stream group	35	delete_defaultstreamgroup
140	Can view default stream group	35	view_defaultstreamgroup
141	Can add user group	36	add_usergroup
142	Can change user group	36	change_usergroup
143	Can delete user group	36	delete_usergroup
144	Can view user group	36	view_usergroup
145	Can add user group membership	37	add_usergroupmembership
146	Can change user group membership	37	change_usergroupmembership
147	Can delete user group membership	37	delete_usergroupmembership
148	Can view user group membership	37	view_usergroupmembership
149	Can add bot storage data	38	add_botstoragedata
150	Can change bot storage data	38	change_botstoragedata
151	Can delete bot storage data	38	delete_botstoragedata
152	Can view bot storage data	38	view_botstoragedata
153	Can add bot config data	39	add_botconfigdata
154	Can change bot config data	39	change_botconfigdata
155	Can delete bot config data	39	delete_botconfigdata
156	Can view bot config data	39	view_botconfigdata
157	Can add scheduled message	40	add_scheduledmessage
158	Can change scheduled message	40	change_scheduledmessage
159	Can delete scheduled message	40	delete_scheduledmessage
160	Can view scheduled message	40	view_scheduledmessage
161	Can add sub message	41	add_submessage
162	Can change sub message	41	change_submessage
163	Can delete sub message	41	delete_submessage
164	Can view sub message	41	view_submessage
165	Can add user status	42	add_userstatus
166	Can change user status	42	change_userstatus
167	Can delete user status	42	delete_userstatus
168	Can view user status	42	view_userstatus
169	Can add archived reaction	43	add_archivedreaction
170	Can change archived reaction	43	change_archivedreaction
171	Can delete archived reaction	43	delete_archivedreaction
172	Can view archived reaction	43	view_archivedreaction
173	Can add archived sub message	44	add_archivedsubmessage
174	Can change archived sub message	44	change_archivedsubmessage
175	Can delete archived sub message	44	delete_archivedsubmessage
176	Can view archived sub message	44	view_archivedsubmessage
177	Can add archive transaction	45	add_archivetransaction
178	Can change archive transaction	45	change_archivetransaction
179	Can delete archive transaction	45	delete_archivetransaction
180	Can view archive transaction	45	view_archivetransaction
181	Can add missed message email address	46	add_missedmessageemailaddress
182	Can change missed message email address	46	change_missedmessageemailaddress
183	Can delete missed message email address	46	delete_missedmessageemailaddress
184	Can view missed message email address	46	view_missedmessageemailaddress
185	Can add alert word	47	add_alertword
186	Can change alert word	47	change_alertword
187	Can delete alert word	47	delete_alertword
188	Can view alert word	47	view_alertword
190	Can change draft	48	change_draft
191	Can delete draft	48	delete_draft
192	Can view draft	48	view_draft
193	Can add muted user	49	add_muteduser
194	Can change muted user	49	change_muteduser
195	Can delete muted user	49	delete_muteduser
196	Can view muted user	49	view_muteduser
197	Can add realm playground	50	add_realmplayground
198	Can change realm playground	50	change_realmplayground
199	Can delete realm playground	50	delete_realmplayground
200	Can view realm playground	50	view_realmplayground
201	Can add scheduled message notification email	51	add_scheduledmessagenotificationemail
202	Can change scheduled message notification email	51	change_scheduledmessagenotificationemail
203	Can delete scheduled message notification email	51	delete_scheduledmessagenotificationemail
204	Can view scheduled message notification email	51	view_scheduledmessagenotificationemail
205	Can add realm user default	52	add_realmuserdefault
206	Can change realm user default	52	change_realmuserdefault
207	Can delete realm user default	52	delete_realmuserdefault
208	Can view realm user default	52	view_realmuserdefault
209	Can add user topic	53	add_usertopic
210	Can change user topic	53	change_usertopic
211	Can delete user topic	53	delete_usertopic
212	Can view user topic	53	view_usertopic
213	Can add group group membership	54	add_groupgroupmembership
214	Can change group group membership	54	change_groupgroupmembership
215	Can delete group group membership	54	delete_groupgroupmembership
216	Can view group group membership	54	view_groupgroupmembership
217	Can add realm reactivation status	55	add_realmreactivationstatus
218	Can change realm reactivation status	55	change_realmreactivationstatus
219	Can delete realm reactivation status	55	delete_realmreactivationstatus
220	Can view realm reactivation status	55	view_realmreactivationstatus
221	Can add preregistration realm	56	add_preregistrationrealm
222	Can change preregistration realm	56	change_preregistrationrealm
223	Can delete preregistration realm	56	delete_preregistrationrealm
224	Can view preregistration realm	56	view_preregistrationrealm
225	Can add realm authentication method	57	add_realmauthenticationmethod
226	Can change realm authentication method	57	change_realmauthenticationmethod
227	Can delete realm authentication method	57	delete_realmauthenticationmethod
228	Can view realm authentication method	57	view_realmauthenticationmethod
229	Can add user presence	58	add_userpresence
230	Can change user presence	58	change_userpresence
231	Can delete user presence	58	delete_userpresence
232	Can view user presence	58	view_userpresence
233	Can add onboarding step	59	add_onboardingstep
234	Can change onboarding step	59	change_onboardingstep
235	Can delete onboarding step	59	delete_onboardingstep
236	Can view onboarding step	59	view_onboardingstep
237	Can add named user group	60	add_namedusergroup
238	Can change named user group	60	change_namedusergroup
239	Can delete named user group	60	delete_namedusergroup
240	Can view named user group	60	view_namedusergroup
241	Can add presence sequence	61	add_presencesequence
242	Can change presence sequence	61	change_presencesequence
243	Can delete presence sequence	61	delete_presencesequence
244	Can view presence sequence	61	view_presencesequence
245	Can add onboarding user message	62	add_onboardingusermessage
246	Can change onboarding user message	62	change_onboardingusermessage
247	Can delete onboarding user message	62	delete_onboardingusermessage
248	Can view onboarding user message	62	view_onboardingusermessage
249	Can add direct message group	63	add_directmessagegroup
250	Can change direct message group	63	change_directmessagegroup
251	Can delete direct message group	63	delete_directmessagegroup
252	Can view direct message group	63	view_directmessagegroup
253	Can add image attachment	64	add_imageattachment
254	Can change image attachment	64	change_imageattachment
255	Can delete image attachment	64	delete_imageattachment
256	Can view image attachment	64	view_imageattachment
257	Can add association	65	add_association
258	Can change association	65	change_association
259	Can delete association	65	delete_association
260	Can view association	65	view_association
261	Can add code	66	add_code
262	Can change code	66	change_code
263	Can delete code	66	delete_code
264	Can view code	66	view_code
265	Can add nonce	67	add_nonce
266	Can change nonce	67	change_nonce
267	Can delete nonce	67	delete_nonce
268	Can view nonce	67	view_nonce
269	Can add user social auth	68	add_usersocialauth
270	Can change user social auth	68	change_usersocialauth
271	Can delete user social auth	68	delete_usersocialauth
272	Can view user social auth	68	view_usersocialauth
273	Can add partial	69	add_partial
274	Can change partial	69	change_partial
275	Can delete partial	69	delete_partial
276	Can view partial	69	view_partial
277	Can add static device	70	add_staticdevice
278	Can change static device	70	change_staticdevice
279	Can delete static device	70	delete_staticdevice
280	Can view static device	70	view_staticdevice
281	Can add static token	71	add_statictoken
282	Can change static token	71	change_statictoken
283	Can delete static token	71	delete_statictoken
284	Can view static token	71	view_statictoken
285	Can add TOTP device	72	add_totpdevice
286	Can change TOTP device	72	change_totpdevice
287	Can delete TOTP device	72	delete_totpdevice
288	Can view TOTP device	72	view_totpdevice
289	Can add phone device	73	add_phonedevice
290	Can change phone device	73	change_phonedevice
291	Can delete phone device	73	delete_phonedevice
292	Can view phone device	73	view_phonedevice
293	Can add installation count	74	add_installationcount
294	Can change installation count	74	change_installationcount
295	Can delete installation count	74	delete_installationcount
296	Can view installation count	74	view_installationcount
297	Can add realm count	75	add_realmcount
298	Can change realm count	75	change_realmcount
299	Can delete realm count	75	delete_realmcount
300	Can view realm count	75	view_realmcount
301	Can add stream count	76	add_streamcount
302	Can change stream count	76	change_streamcount
303	Can delete stream count	76	delete_streamcount
304	Can view stream count	76	view_streamcount
305	Can add user count	77	add_usercount
306	Can change user count	77	change_usercount
307	Can delete user count	77	delete_usercount
308	Can view user count	77	view_usercount
309	Can add fill state	78	add_fillstate
310	Can change fill state	78	change_fillstate
311	Can delete fill state	78	delete_fillstate
312	Can view fill state	78	view_fillstate
\.


--
-- Data for Name: confirmation_confirmation; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.confirmation_confirmation (id, object_id, date_sent, confirmation_key, content_type_id, type, realm_id, expiry_date) FROM stdin;
1	1	2024-08-02 09:00:06.032514+00	lzjvjbw63765pkgmorqh4bbl	56	7	\N	2024-08-03 09:00:06.032514+00
2	8	2024-08-02 09:00:27.062221+00	aasgnk3uxlzdurlf4mbgdc22	7	4	2	4762-06-30 09:00:27.062221+00
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
10	zerver	message
11	zerver	preregistrationuser
12	zerver	pushdevicetoken
13	zerver	realm
14	zerver	realmemoji
15	zerver	realmfilter
16	zerver	recipient
17	zerver	stream
18	zerver	subscription
19	zerver	useractivity
20	zerver	useractivityinterval
21	zerver	usermessage
22	zerver	attachment
23	zerver	reaction
24	zerver	emailchangestatus
25	zerver	realmauditlog
26	zerver	archivedattachment
27	zerver	archivedmessage
28	zerver	archivedusermessage
29	zerver	realmdomain
30	zerver	customprofilefield
31	zerver	customprofilefieldvalue
32	zerver	service
33	zerver	scheduledemail
34	zerver	multiuseinvite
35	zerver	defaultstreamgroup
36	zerver	usergroup
37	zerver	usergroupmembership
38	zerver	botstoragedata
39	zerver	botconfigdata
40	zerver	scheduledmessage
41	zerver	submessage
42	zerver	userstatus
43	zerver	archivedreaction
44	zerver	archivedsubmessage
45	zerver	archivetransaction
46	zerver	missedmessageemailaddress
47	zerver	alertword
48	zerver	draft
49	zerver	muteduser
50	zerver	realmplayground
51	zerver	scheduledmessagenotificationemail
52	zerver	realmuserdefault
53	zerver	usertopic
54	zerver	groupgroupmembership
55	zerver	realmreactivationstatus
56	zerver	preregistrationrealm
57	zerver	realmauthenticationmethod
58	zerver	userpresence
59	zerver	onboardingstep
60	zerver	namedusergroup
61	zerver	presencesequence
62	zerver	onboardingusermessage
63	zerver	directmessagegroup
64	zerver	imageattachment
65	social_django	association
66	social_django	code
67	social_django	nonce
68	social_django	usersocialauth
69	social_django	partial
70	otp_static	staticdevice
71	otp_static	statictoken
72	otp_totp	totpdevice
73	phonenumber	phonedevice
74	analytics	installationcount
75	analytics	realmcount
76	analytics	streamcount
77	analytics	usercount
78	analytics	fillstate
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2024-08-02 08:55:33.87185+00
2	auth	0001_initial	2024-08-02 08:55:33.885552+00
3	zerver	0001_initial	2024-08-02 08:55:34.465024+00
4	zerver	0029_realm_subdomain	2024-08-02 08:55:34.485235+00
5	zerver	0030_realm_org_type	2024-08-02 08:55:34.492885+00
6	zerver	0031_remove_system_avatar_source	2024-08-02 08:55:34.502989+00
7	zerver	0032_verify_all_medium_avatar_images	2024-08-02 08:55:34.516295+00
8	zerver	0033_migrate_domain_to_realmalias	2024-08-02 08:55:34.527452+00
9	zerver	0034_userprofile_enable_online_push_notifications	2024-08-02 08:55:34.538273+00
10	zerver	0035_realm_message_retention_period_days	2024-08-02 08:55:34.544384+00
11	zerver	0036_rename_subdomain_to_string_id	2024-08-02 08:55:34.550765+00
12	zerver	0037_disallow_null_string_id	2024-08-02 08:55:34.567971+00
13	zerver	0038_realm_change_to_community_defaults	2024-08-02 08:55:34.585453+00
14	zerver	0039_realmalias_drop_uniqueness	2024-08-02 08:55:34.595968+00
15	zerver	0040_realm_authentication_methods	2024-08-02 08:55:34.602607+00
16	zerver	0041_create_attachments_for_old_messages	2024-08-02 08:55:34.676781+00
17	zerver	0042_attachment_file_name_length	2024-08-02 08:55:34.68666+00
18	zerver	0043_realm_filter_validators	2024-08-02 08:55:34.687239+00
19	zerver	0044_reaction	2024-08-02 08:55:34.710967+00
20	zerver	0045_realm_waiting_period_threshold	2024-08-02 08:55:34.71794+00
21	zerver	0046_realmemoji_author	2024-08-02 08:55:34.729468+00
22	zerver	0047_realm_add_emoji_by_admins_only	2024-08-02 08:55:34.7361+00
23	zerver	0048_enter_sends_default_to_false	2024-08-02 08:55:34.746931+00
24	zerver	0049_userprofile_pm_content_in_desktop_notifications	2024-08-02 08:55:34.757074+00
25	zerver	0050_userprofile_avatar_version	2024-08-02 08:55:34.767909+00
26	analytics	0001_initial	2024-08-02 08:55:34.886536+00
27	analytics	0002_remove_huddlecount	2024-08-02 08:55:34.94074+00
28	analytics	0003_fillstate	2024-08-02 08:55:34.944223+00
29	analytics	0004_add_subgroup	2024-08-02 08:55:35.020727+00
30	analytics	0005_alter_field_size	2024-08-02 08:55:35.095769+00
31	analytics	0006_add_subgroup_to_unique_constraints	2024-08-02 08:55:35.13317+00
32	analytics	0007_remove_interval	2024-08-02 08:55:35.197284+00
33	analytics	0008_add_count_indexes	2024-08-02 08:55:35.225076+00
34	analytics	0009_remove_messages_to_stream_stat	2024-08-02 08:55:35.240495+00
35	analytics	0010_clear_messages_sent_values	2024-08-02 08:55:35.254733+00
36	analytics	0011_clear_analytics_tables	2024-08-02 08:55:35.269009+00
37	analytics	0012_add_on_delete	2024-08-02 08:55:35.316163+00
38	analytics	0013_remove_anomaly	2024-08-02 08:55:35.418478+00
39	analytics	0014_remove_fillstate_last_modified	2024-08-02 08:55:35.420363+00
40	analytics	0015_clear_duplicate_counts	2024-08-02 08:55:35.436635+00
41	analytics	0016_unique_constraint_when_subgroup_null	2024-08-02 08:55:35.521885+00
42	analytics	0017_regenerate_partial_indexes	2024-08-02 08:55:35.629234+00
43	analytics	0018_remove_usercount_active_users_audit	2024-08-02 08:55:35.630432+00
44	analytics	0019_remove_unused_counts	2024-08-02 08:55:35.631708+00
45	analytics	0020_alter_installationcount_id_alter_realmcount_id_and_more	2024-08-02 08:55:35.671667+00
46	analytics	0021_alter_fillstate_id	2024-08-02 08:55:35.675235+00
47	contenttypes	0002_remove_content_type_name	2024-08-02 08:55:35.691231+00
48	auth	0002_alter_permission_name_max_length	2024-08-02 08:55:35.702962+00
49	auth	0003_alter_user_email_max_length	2024-08-02 08:55:35.707242+00
50	auth	0004_alter_user_username_opts	2024-08-02 08:55:35.711961+00
51	auth	0005_alter_user_last_login_null	2024-08-02 08:55:35.716292+00
52	auth	0006_require_contenttypes_0002	2024-08-02 08:55:35.716811+00
53	auth	0007_alter_validators_add_error_messages	2024-08-02 08:55:35.721055+00
54	auth	0008_alter_user_username_max_length	2024-08-02 08:55:35.725183+00
55	auth	0009_alter_user_last_name_max_length	2024-08-02 08:55:35.729476+00
56	auth	0010_alter_group_name_max_length	2024-08-02 08:55:35.742572+00
57	auth	0011_update_proxy_permissions	2024-08-02 08:55:35.754766+00
58	auth	0012_alter_user_first_name_max_length	2024-08-02 08:55:35.759474+00
59	zerver	0051_realmalias_add_allow_subdomains	2024-08-02 08:55:35.823661+00
60	zerver	0052_auto_fix_realmalias_realm_nullable	2024-08-02 08:55:35.838735+00
61	zerver	0053_emailchangestatus	2024-08-02 08:55:35.855191+00
62	zerver	0054_realm_icon	2024-08-02 08:55:35.872566+00
63	zerver	0055_attachment_size	2024-08-02 08:55:35.885135+00
64	zerver	0056_userprofile_emoji_alt_code	2024-08-02 08:55:35.897099+00
65	zerver	0057_realmauditlog	2024-08-02 08:55:35.929284+00
66	zerver	0058_realm_email_changes_disabled	2024-08-02 08:55:35.938324+00
67	zerver	0059_userprofile_quota	2024-08-02 08:55:35.950754+00
68	zerver	0060_move_avatars_to_be_uid_based	2024-08-02 08:55:35.951242+00
69	zerver	0061_userprofile_timezone	2024-08-02 08:55:35.964368+00
70	zerver	0062_default_timezone	2024-08-02 08:55:35.976446+00
71	zerver	0063_realm_description	2024-08-02 08:55:35.985713+00
72	zerver	0064_sync_uploads_filesize_with_db	2024-08-02 08:55:35.986196+00
73	zerver	0065_realm_inline_image_preview	2024-08-02 08:55:35.994911+00
74	zerver	0066_realm_inline_url_embed_preview	2024-08-02 08:55:36.003508+00
75	zerver	0067_archived_models	2024-08-02 08:55:36.104502+00
76	zerver	0068_remove_realm_domain	2024-08-02 08:55:36.114206+00
77	zerver	0069_realmauditlog_extra_data	2024-08-02 08:55:36.128633+00
78	zerver	0070_userhotspot	2024-08-02 08:55:36.206936+00
79	zerver	0071_rename_realmalias_to_realmdomain	2024-08-02 08:55:36.2319+00
80	zerver	0072_realmauditlog_add_index_event_time	2024-08-02 08:55:36.245993+00
81	zerver	0073_custom_profile_fields	2024-08-02 08:55:36.30277+00
82	zerver	0074_fix_duplicate_attachments	2024-08-02 08:55:36.319555+00
83	zerver	0075_attachment_path_id_unique	2024-08-02 08:55:36.353558+00
84	zerver	0076_userprofile_emojiset	2024-08-02 08:55:36.369199+00
85	zerver	0077_add_file_name_field_to_realm_emoji	2024-08-02 08:55:36.398643+00
86	zerver	0078_service	2024-08-02 08:55:36.41672+00
87	zerver	0079_remove_old_scheduled_jobs	2024-08-02 08:55:36.432904+00
88	zerver	0080_realm_description_length	2024-08-02 08:55:36.44307+00
89	zerver	0081_make_emoji_lowercase	2024-08-02 08:55:36.473717+00
90	zerver	0082_index_starred_user_messages	2024-08-02 08:55:36.538461+00
91	zerver	0083_index_mentioned_user_messages	2024-08-02 08:55:36.552984+00
92	zerver	0084_realmemoji_deactivated	2024-08-02 08:55:36.568434+00
93	zerver	0085_fix_bots_with_none_bot_type	2024-08-02 08:55:36.58575+00
94	zerver	0086_realm_alter_default_org_type	2024-08-02 08:55:36.595173+00
95	zerver	0087_remove_old_scheduled_jobs	2024-08-02 08:55:36.61166+00
96	zerver	0088_remove_referral_and_invites	2024-08-02 08:55:36.658194+00
97	zerver	0089_auto_20170710_1353	2024-08-02 08:55:36.689117+00
98	zerver	0090_userprofile_high_contrast_mode	2024-08-02 08:55:36.704007+00
99	zerver	0091_realm_allow_edit_history	2024-08-02 08:55:36.714189+00
100	zerver	0092_create_scheduledemail	2024-08-02 08:55:36.734601+00
101	zerver	0093_subscription_event_log_backfill	2024-08-02 08:55:36.769506+00
102	zerver	0094_realm_filter_url_validator	2024-08-02 08:55:36.770042+00
103	zerver	0095_index_unread_user_messages	2024-08-02 08:55:36.784479+00
104	zerver	0096_add_password_required	2024-08-02 08:55:36.799775+00
105	zerver	0097_reactions_emoji_code	2024-08-02 08:55:36.895568+00
106	zerver	0098_index_has_alert_word_user_messages	2024-08-02 08:55:36.910386+00
107	zerver	0099_index_wildcard_mentioned_user_messages	2024-08-02 08:55:36.9247+00
108	zerver	0100_usermessage_remove_is_me_message	2024-08-02 08:55:36.951748+00
109	zerver	0101_muted_topic	2024-08-02 08:55:36.985872+00
110	zerver	0102_convert_muted_topic	2024-08-02 08:55:37.00348+00
111	zerver	0103_remove_userprofile_muted_topics	2024-08-02 08:55:37.019168+00
112	zerver	0104_fix_unreads	2024-08-02 08:55:37.036049+00
113	zerver	0105_userprofile_enable_stream_push_notifications	2024-08-02 08:55:37.052571+00
114	zerver	0106_subscription_push_notifications	2024-08-02 08:55:37.067152+00
115	zerver	0107_multiuseinvite	2024-08-02 08:55:37.091459+00
116	zerver	0108_fix_default_string_id	2024-08-02 08:55:37.108872+00
117	zerver	0109_mark_tutorial_status_finished	2024-08-02 08:55:37.126561+00
118	zerver	0110_stream_is_in_zephyr_realm	2024-08-02 08:55:37.154565+00
119	zerver	0111_botuserstatedata	2024-08-02 08:55:37.23988+00
120	zerver	0112_index_muted_topics	2024-08-02 08:55:37.256367+00
121	zerver	0113_default_stream_group	2024-08-02 08:55:37.291281+00
122	zerver	0114_preregistrationuser_invited_as_admin	2024-08-02 08:55:37.308811+00
123	zerver	0115_user_groups	2024-08-02 08:55:37.399667+00
124	zerver	0116_realm_allow_message_deleting	2024-08-02 08:55:37.411053+00
125	zerver	0117_add_desc_to_user_group	2024-08-02 08:55:37.429573+00
126	zerver	0118_defaultstreamgroup_description	2024-08-02 08:55:37.44201+00
127	zerver	0119_userprofile_night_mode	2024-08-02 08:55:37.460294+00
128	zerver	0120_botuserconfigdata	2024-08-02 08:55:37.497586+00
129	zerver	0121_realm_signup_notifications_stream	2024-08-02 08:55:37.588044+00
130	zerver	0122_rename_botuserstatedata_botstoragedata	2024-08-02 08:55:37.623433+00
131	zerver	0123_userprofile_make_realm_email_pair_unique	2024-08-02 08:55:37.662173+00
132	zerver	0124_stream_enable_notifications	2024-08-02 08:55:37.696343+00
133	confirmation	0001_initial	2024-08-02 08:55:37.717259+00
134	confirmation	0002_realmcreationkey	2024-08-02 08:55:37.719197+00
135	confirmation	0003_emailchangeconfirmation	2024-08-02 08:55:37.720222+00
136	confirmation	0004_remove_confirmationmanager	2024-08-02 08:55:37.727605+00
137	confirmation	0005_confirmation_realm	2024-08-02 08:55:37.747897+00
138	confirmation	0006_realmcreationkey_presume_email_valid	2024-08-02 08:55:37.749709+00
139	confirmation	0007_add_indexes	2024-08-02 08:55:37.800004+00
140	confirmation	0008_confirmation_expiry_date	2024-08-02 08:55:37.813509+00
141	confirmation	0009_confirmation_expiry_date_backfill	2024-08-02 08:55:37.884707+00
142	confirmation	0010_alter_confirmation_expiry_date	2024-08-02 08:55:37.897043+00
143	confirmation	0011_alter_confirmation_expiry_date	2024-08-02 08:55:37.910087+00
144	confirmation	0012_alter_confirmation_id	2024-08-02 08:55:37.926546+00
145	confirmation	0013_alter_realmcreationkey_id	2024-08-02 08:55:37.930957+00
146	otp_static	0001_initial	2024-08-02 08:55:37.9743+00
147	otp_static	0002_throttling	2024-08-02 08:55:38.006338+00
148	otp_static	0003_add_timestamps	2024-08-02 08:55:38.037887+00
149	otp_totp	0001_initial	2024-08-02 08:55:38.060239+00
150	otp_totp	0002_auto_20190420_0723	2024-08-02 08:55:38.093206+00
151	otp_totp	0003_add_timestamps	2024-08-02 08:55:38.125058+00
152	phonenumber	0001_initial	2024-08-02 08:55:38.169937+00
153	two_factor	0001_initial	2024-08-02 08:55:38.170308+00
154	two_factor	0002_auto_20150110_0810	2024-08-02 08:55:38.170601+00
155	two_factor	0003_auto_20150817_1733	2024-08-02 08:55:38.170946+00
156	two_factor	0004_auto_20160205_1827	2024-08-02 08:55:38.171234+00
157	two_factor	0005_auto_20160224_0450	2024-08-02 08:55:38.171533+00
158	two_factor	0006_phonedevice_key_default	2024-08-02 08:55:38.171795+00
159	two_factor	0007_auto_20201201_1019	2024-08-02 08:55:38.172041+00
160	two_factor	0008_delete_phonedevice	2024-08-02 08:55:38.1723+00
161	two_factor	0001_squashed_0008_delete_phonedevice	2024-08-02 08:55:38.172582+00
162	sessions	0001_initial	2024-08-02 08:55:38.17603+00
163	default	0001_initial	2024-08-02 08:55:38.278735+00
164	social_auth	0001_initial	2024-08-02 08:55:38.279149+00
165	default	0002_add_related_name	2024-08-02 08:55:38.300557+00
166	social_auth	0002_add_related_name	2024-08-02 08:55:38.300975+00
167	default	0003_alter_email_max_length	2024-08-02 08:55:38.303352+00
168	social_auth	0003_alter_email_max_length	2024-08-02 08:55:38.303588+00
169	default	0004_auto_20160423_0400	2024-08-02 08:55:38.320785+00
170	social_auth	0004_auto_20160423_0400	2024-08-02 08:55:38.321128+00
171	social_auth	0005_auto_20160727_2333	2024-08-02 08:55:38.323549+00
172	social_django	0006_partial	2024-08-02 08:55:38.327297+00
173	social_django	0007_code_timestamp	2024-08-02 08:55:38.329752+00
174	social_django	0008_partial_timestamp	2024-08-02 08:55:38.332379+00
175	social_django	0009_auto_20191118_0520	2024-08-02 08:55:38.366925+00
176	social_django	0010_uid_db_index	2024-08-02 08:55:38.384933+00
177	social_django	0011_alter_id_fields	2024-08-02 08:55:38.422339+00
178	social_django	0012_usersocialauth_extra_data_new	2024-08-02 08:55:38.44253+00
179	social_django	0013_migrate_extra_data	2024-08-02 08:55:38.466047+00
180	social_django	0014_remove_usersocialauth_extra_data	2024-08-02 08:55:38.484974+00
181	social_django	0015_rename_extra_data_new_usersocialauth_extra_data	2024-08-02 08:55:38.503697+00
182	zerver	0125_realm_max_invites	2024-08-02 08:55:38.516248+00
183	zerver	0126_prereg_remove_users_without_realm	2024-08-02 08:55:38.587674+00
184	zerver	0127_disallow_chars_in_stream_and_user_name	2024-08-02 08:55:38.588412+00
185	zerver	0128_scheduledemail_realm	2024-08-02 08:55:38.65847+00
186	zerver	0129_remove_userprofile_autoscroll_forever	2024-08-02 08:55:38.679913+00
187	zerver	0130_text_choice_in_emojiset	2024-08-02 08:55:38.746031+00
188	zerver	0131_realm_create_generic_bot_by_admins_only	2024-08-02 08:55:38.758761+00
189	zerver	0132_realm_message_visibility_limit	2024-08-02 08:55:38.771785+00
190	zerver	0133_rename_botuserconfigdata_botconfigdata	2024-08-02 08:55:38.812434+00
191	zerver	0134_scheduledmessage	2024-08-02 08:55:38.841502+00
192	zerver	0135_scheduledmessage_delivery_type	2024-08-02 08:55:38.863018+00
193	zerver	0136_remove_userprofile_quota	2024-08-02 08:55:38.937442+00
194	zerver	0137_realm_upload_quota_gb	2024-08-02 08:55:38.951132+00
195	zerver	0138_userprofile_realm_name_in_notifications	2024-08-02 08:55:38.973556+00
196	zerver	0139_fill_last_message_id_in_subscription_logs	2024-08-02 08:55:38.99778+00
197	zerver	0140_realm_send_welcome_emails	2024-08-02 08:55:39.011414+00
198	zerver	0141_change_usergroup_description_to_textfield	2024-08-02 08:55:39.032183+00
199	zerver	0142_userprofile_translate_emoticons	2024-08-02 08:55:39.053392+00
200	zerver	0143_realm_bot_creation_policy	2024-08-02 08:55:39.089939+00
201	zerver	0144_remove_realm_create_generic_bot_by_admins_only	2024-08-02 08:55:39.102872+00
202	zerver	0145_reactions_realm_emoji_name_to_id	2024-08-02 08:55:39.126417+00
203	zerver	0146_userprofile_message_content_in_email_notifications	2024-08-02 08:55:39.147866+00
204	zerver	0147_realm_disallow_disposable_email_addresses	2024-08-02 08:55:39.161458+00
205	zerver	0148_max_invites_forget_default	2024-08-02 08:55:39.187091+00
206	zerver	0149_realm_emoji_drop_unique_constraint	2024-08-02 08:55:39.304832+00
207	zerver	0150_realm_allow_community_topic_editing	2024-08-02 08:55:39.319254+00
208	zerver	0151_last_reminder_default_none	2024-08-02 08:55:39.342244+00
209	zerver	0152_realm_default_twenty_four_hour_time	2024-08-02 08:55:39.355692+00
210	zerver	0153_remove_int_float_custom_fields	2024-08-02 08:55:39.369239+00
211	zerver	0154_fix_invalid_bot_owner	2024-08-02 08:55:39.393021+00
212	zerver	0155_change_default_realm_description	2024-08-02 08:55:39.407389+00
213	zerver	0156_add_hint_to_profile_field	2024-08-02 08:55:39.421469+00
214	zerver	0157_userprofile_is_guest	2024-08-02 08:55:39.444638+00
215	zerver	0158_realm_video_chat_provider	2024-08-02 08:55:39.458953+00
216	zerver	0159_realm_google_hangouts_domain	2024-08-02 08:55:39.47309+00
217	zerver	0160_add_choice_field	2024-08-02 08:55:39.500287+00
218	zerver	0161_realm_message_content_delete_limit_seconds	2024-08-02 08:55:39.513931+00
219	zerver	0162_change_default_community_topic_editing	2024-08-02 08:55:39.527679+00
220	zerver	0163_remove_userprofile_default_desktop_notifications	2024-08-02 08:55:39.60444+00
221	zerver	0164_stream_history_public_to_subscribers	2024-08-02 08:55:39.643079+00
222	zerver	0165_add_date_to_profile_field	2024-08-02 08:55:39.656635+00
223	zerver	0166_add_url_to_profile_field	2024-08-02 08:55:39.670844+00
224	zerver	0167_custom_profile_fields_sort_order	2024-08-02 08:55:39.707554+00
225	zerver	0168_stream_is_web_public	2024-08-02 08:55:39.720872+00
226	zerver	0169_stream_is_announcement_only	2024-08-02 08:55:39.734876+00
227	zerver	0170_submessage	2024-08-02 08:55:39.760951+00
228	zerver	0171_userprofile_dense_mode	2024-08-02 08:55:39.782898+00
229	zerver	0172_add_user_type_of_custom_profile_field	2024-08-02 08:55:39.79629+00
230	zerver	0173_support_seat_based_plans	2024-08-02 08:55:39.830879+00
231	zerver	0174_userprofile_delivery_email	2024-08-02 08:55:39.878084+00
232	zerver	0175_change_realm_audit_log_event_type_tense	2024-08-02 08:55:39.962845+00
233	zerver	0176_remove_subscription_notifications	2024-08-02 08:55:39.982188+00
234	zerver	0177_user_message_add_and_index_is_private_flag	2024-08-02 08:55:40.065476+00
235	zerver	0178_rename_to_emails_restricted_to_domains	2024-08-02 08:55:40.079454+00
236	zerver	0179_rename_to_digest_emails_enabled	2024-08-02 08:55:40.092858+00
237	zerver	0180_usermessage_add_active_mobile_push_notification	2024-08-02 08:55:40.148162+00
238	zerver	0181_userprofile_change_emojiset	2024-08-02 08:55:40.194018+00
239	zerver	0182_set_initial_value_is_private_flag	2024-08-02 08:55:40.270239+00
240	zerver	0183_change_custom_field_name_max_length	2024-08-02 08:55:40.287125+00
241	zerver	0184_rename_custom_field_types	2024-08-02 08:55:40.300167+00
242	zerver	0185_realm_plan_type	2024-08-02 08:55:40.314711+00
243	zerver	0186_userprofile_starred_message_counts	2024-08-02 08:55:40.336842+00
244	zerver	0187_userprofile_is_billing_admin	2024-08-02 08:55:40.359965+00
245	zerver	0188_userprofile_enable_login_emails	2024-08-02 08:55:40.381775+00
246	zerver	0189_userprofile_add_some_emojisets	2024-08-02 08:55:40.4283+00
247	zerver	0190_cleanup_pushdevicetoken	2024-08-02 08:55:40.469024+00
248	zerver	0191_realm_seat_limit	2024-08-02 08:55:40.482974+00
249	zerver	0192_customprofilefieldvalue_rendered_value	2024-08-02 08:55:40.502036+00
250	zerver	0193_realm_email_address_visibility	2024-08-02 08:55:40.515873+00
251	zerver	0194_userprofile_notification_sound	2024-08-02 08:55:40.588874+00
252	zerver	0195_realm_first_visible_message_id	2024-08-02 08:55:40.603904+00
253	zerver	0196_add_realm_logo_fields	2024-08-02 08:55:40.632013+00
254	zerver	0197_azure_active_directory_auth	2024-08-02 08:55:40.646505+00
255	zerver	0198_preregistrationuser_invited_as	2024-08-02 08:55:40.692015+00
256	zerver	0199_userstatus	2024-08-02 08:55:40.718285+00
257	zerver	0200_remove_preregistrationuser_invited_as_admin	2024-08-02 08:55:40.740441+00
258	zerver	0201_zoom_video_chat	2024-08-02 08:55:40.784862+00
259	zerver	0202_add_user_status_info	2024-08-02 08:55:40.825552+00
260	zerver	0203_realm_message_content_allowed_in_email_notifications	2024-08-02 08:55:40.839855+00
261	zerver	0204_remove_realm_billing_fields	2024-08-02 08:55:40.86677+00
262	zerver	0205_remove_realmauditlog_requires_billing_update	2024-08-02 08:55:40.947808+00
263	zerver	0206_stream_rendered_description	2024-08-02 08:55:40.986468+00
264	zerver	0207_multiuseinvite_invited_as	2024-08-02 08:55:41.009201+00
265	zerver	0208_add_realm_night_logo_fields	2024-08-02 08:55:41.036927+00
266	zerver	0209_stream_first_message_id	2024-08-02 08:55:41.052243+00
267	zerver	0210_stream_first_message_id	2024-08-02 08:55:41.076747+00
268	zerver	0211_add_users_field_to_scheduled_email	2024-08-02 08:55:41.152583+00
269	zerver	0212_make_stream_email_token_unique	2024-08-02 08:55:41.177067+00
270	zerver	0213_realm_digest_weekday	2024-08-02 08:55:41.191312+00
271	zerver	0214_realm_invite_to_stream_policy	2024-08-02 08:55:41.286358+00
272	zerver	0215_realm_avatar_changes_disabled	2024-08-02 08:55:41.302197+00
273	zerver	0216_add_create_stream_policy	2024-08-02 08:55:41.317224+00
274	zerver	0217_migrate_create_stream_policy	2024-08-02 08:55:41.3428+00
275	zerver	0218_remove_create_stream_by_admins_only	2024-08-02 08:55:41.356596+00
276	zerver	0219_toggle_realm_digest_emails_enabled_default	2024-08-02 08:55:41.394947+00
277	zerver	0220_subscription_notification_settings	2024-08-02 08:55:41.47168+00
278	zerver	0221_subscription_notifications_data_migration	2024-08-02 08:55:41.505122+00
279	zerver	0222_userprofile_fluid_layout_width	2024-08-02 08:55:41.528893+00
280	zerver	0223_rename_to_is_muted	2024-08-02 08:55:41.647017+00
281	zerver	0224_alter_field_realm_video_chat_provider	2024-08-02 08:55:41.716519+00
282	zerver	0225_archived_reaction_model	2024-08-02 08:55:41.767297+00
283	zerver	0226_archived_submessage_model	2024-08-02 08:55:41.795725+00
284	zerver	0227_inline_url_embed_preview_default_off	2024-08-02 08:55:41.836281+00
285	zerver	0228_userprofile_demote_inactive_streams	2024-08-02 08:55:41.86062+00
286	zerver	0229_stream_message_retention_days	2024-08-02 08:55:41.875374+00
287	zerver	0230_rename_to_enable_stream_audible_notifications	2024-08-02 08:55:41.957202+00
288	zerver	0231_add_archive_transaction_model	2024-08-02 08:55:42.116931+00
289	zerver	0232_make_archive_transaction_field_not_nullable	2024-08-02 08:55:42.146041+00
290	zerver	0233_userprofile_avatar_hash	2024-08-02 08:55:42.169671+00
291	zerver	0234_add_external_account_custom_profile_field	2024-08-02 08:55:42.183514+00
292	zerver	0235_userprofile_desktop_icon_count_display	2024-08-02 08:55:42.207523+00
293	zerver	0236_remove_illegal_characters_email_full	2024-08-02 08:55:42.290042+00
294	zerver	0237_rename_zulip_realm_to_zulipinternal	2024-08-02 08:55:42.317532+00
295	zerver	0238_usermessage_bigint_id	2024-08-02 08:55:42.35974+00
296	zerver	0239_usermessage_copy_id_to_bigint_id	2024-08-02 08:55:42.388148+00
297	zerver	0240_usermessage_migrate_bigint_id_into_id	2024-08-02 08:55:42.429104+00
298	zerver	0241_usermessage_bigint_id_migration_finalize	2024-08-02 08:55:42.474511+00
299	zerver	0242_fix_bot_email_property	2024-08-02 08:55:42.500873+00
300	zerver	0243_message_add_date_sent_column	2024-08-02 08:55:42.541468+00
301	zerver	0244_message_copy_pub_date_to_date_sent	2024-08-02 08:55:42.666816+00
302	zerver	0245_message_date_sent_finalize_part1	2024-08-02 08:55:42.716713+00
303	zerver	0246_message_date_sent_finalize_part2	2024-08-02 08:55:42.807257+00
304	zerver	0247_realmauditlog_event_type_to_int	2024-08-02 08:55:43.004428+00
305	zerver	0248_userprofile_role_start	2024-08-02 08:55:43.055246+00
306	zerver	0249_userprofile_role_finish	2024-08-02 08:55:43.128709+00
307	zerver	0250_saml_auth	2024-08-02 08:55:43.14366+00
308	zerver	0251_prereg_user_add_full_name	2024-08-02 08:55:43.189913+00
309	zerver	0252_realm_user_group_edit_policy	2024-08-02 08:55:43.20509+00
310	zerver	0253_userprofile_wildcard_mentions_notify	2024-08-02 08:55:43.302663+00
311	zerver	0209_user_profile_no_empty_password	2024-08-02 08:55:43.330158+00
312	zerver	0254_merge_0209_0253	2024-08-02 08:55:43.330764+00
313	zerver	0255_userprofile_stream_add_recipient_column	2024-08-02 08:55:43.382592+00
314	zerver	0256_userprofile_stream_set_recipient_column_values	2024-08-02 08:55:43.384448+00
315	zerver	0257_fix_has_link_attribute	2024-08-02 08:55:43.410533+00
316	zerver	0258_enable_online_push_notifications_default	2024-08-02 08:55:43.435751+00
317	zerver	0259_missedmessageemailaddress	2024-08-02 08:55:43.466275+00
318	zerver	0260_missed_message_addresses_from_redis_to_db	2024-08-02 08:55:43.493714+00
319	zerver	0261_realm_private_message_policy	2024-08-02 08:55:43.50916+00
320	zerver	0262_mutedtopic_date_muted	2024-08-02 08:55:43.531892+00
321	zerver	0263_stream_stream_post_policy	2024-08-02 08:55:43.549086+00
322	zerver	0264_migrate_is_announcement_only	2024-08-02 08:55:43.631071+00
323	zerver	0265_remove_stream_is_announcement_only	2024-08-02 08:55:43.648643+00
324	zerver	0266_userpresence_realm	2024-08-02 08:55:43.676344+00
325	zerver	0267_backfill_userpresence_realm_id	2024-08-02 08:55:43.677738+00
326	zerver	0268_add_userpresence_realm_timestamp_index	2024-08-02 08:55:43.72906+00
327	zerver	0269_gitlab_auth	2024-08-02 08:55:43.744533+00
328	zerver	0270_huddle_recipient	2024-08-02 08:55:43.770947+00
329	zerver	0271_huddle_set_recipient_column_values	2024-08-02 08:55:43.772161+00
330	zerver	0272_realm_default_code_block_language	2024-08-02 08:55:43.787983+00
331	zerver	0273_migrate_old_bot_messages	2024-08-02 08:55:43.815305+00
332	zerver	0274_nullbooleanfield_to_booleanfield	2024-08-02 08:55:44.050179+00
333	zerver	0275_remove_userprofile_last_pointer_updater	2024-08-02 08:55:44.076107+00
334	zerver	0276_alertword	2024-08-02 08:55:44.106966+00
335	zerver	0277_migrate_alert_word	2024-08-02 08:55:44.13432+00
336	zerver	0278_remove_userprofile_alert_words	2024-08-02 08:55:44.159185+00
337	zerver	0279_message_recipient_subject_indexes	2024-08-02 08:55:44.204802+00
338	zerver	0280_userprofile_presence_enabled	2024-08-02 08:55:44.281413+00
339	zerver	0281_zoom_oauth	2024-08-02 08:55:44.30768+00
340	zerver	0282_remove_zoom_video_chat	2024-08-02 08:55:44.353117+00
341	zerver	0283_apple_auth	2024-08-02 08:55:44.368818+00
342	zerver	0284_convert_realm_admins_to_realm_owners	2024-08-02 08:55:44.396468+00
343	zerver	0285_remove_realm_google_hangouts_domain	2024-08-02 08:55:44.437884+00
344	zerver	0261_pregistrationuser_clear_invited_as_admin	2024-08-02 08:55:44.464327+00
345	zerver	0286_merge_0260_0285	2024-08-02 08:55:44.464865+00
346	zerver	0287_clear_duplicate_reactions	2024-08-02 08:55:44.492268+00
347	zerver	0288_reaction_unique_on_emoji_code	2024-08-02 08:55:44.535972+00
348	zerver	0289_tighten_attachment_size	2024-08-02 08:55:44.640413+00
349	zerver	0290_remove_night_mode_add_color_scheme	2024-08-02 08:55:44.718998+00
350	zerver	0291_realm_retention_days_not_null	2024-08-02 08:55:44.73554+00
351	zerver	0292_update_default_value_of_invited_as	2024-08-02 08:55:44.785128+00
352	zerver	0293_update_invite_as_dict_values	2024-08-02 08:55:44.813682+00
353	zerver	0294_remove_userprofile_pointer	2024-08-02 08:55:44.838696+00
354	zerver	0295_case_insensitive_email_indexes	2024-08-02 08:55:44.867423+00
355	zerver	0296_remove_userprofile_short_name	2024-08-02 08:55:44.893024+00
356	zerver	0297_draft	2024-08-02 08:55:44.984458+00
357	zerver	0298_fix_realmauditlog_format	2024-08-02 08:55:45.012372+00
358	zerver	0299_subscription_role	2024-08-02 08:55:45.035895+00
359	zerver	0300_add_attachment_is_web_public	2024-08-02 08:55:45.085767+00
360	zerver	0301_fix_unread_messages_in_deactivated_streams	2024-08-02 08:55:45.087435+00
361	zerver	0302_case_insensitive_stream_name_index	2024-08-02 08:55:45.107467+00
362	zerver	0303_realm_wildcard_mention_policy	2024-08-02 08:55:45.124527+00
363	zerver	0304_remove_default_status_of_default_private_streams	2024-08-02 08:55:45.152699+00
364	zerver	0305_realm_deactivated_redirect	2024-08-02 08:55:45.168615+00
365	zerver	0306_custom_profile_field_date_format	2024-08-02 08:55:45.170141+00
366	zerver	0307_rename_api_super_user_to_can_forge_sender	2024-08-02 08:55:45.197532+00
367	zerver	0308_remove_reduntant_realm_meta_permissions	2024-08-02 08:55:45.213021+00
368	zerver	0309_userprofile_can_create_users	2024-08-02 08:55:45.23981+00
369	zerver	0310_jsonfield	2024-08-02 08:55:45.240249+00
370	zerver	0311_userprofile_default_view	2024-08-02 08:55:45.266319+00
371	zerver	0312_subscription_is_user_active	2024-08-02 08:55:45.288679+00
372	zerver	0313_finish_is_user_active_migration	2024-08-02 08:55:45.430227+00
373	zerver	0314_muted_user	2024-08-02 08:55:45.460872+00
374	zerver	0315_realmplayground	2024-08-02 08:55:45.492642+00
375	zerver	0316_realm_invite_to_realm_policy	2024-08-02 08:55:45.509646+00
376	zerver	0317_migrate_to_invite_to_realm_policy	2024-08-02 08:55:45.537667+00
377	zerver	0318_remove_realm_invite_by_admins_only	2024-08-02 08:55:45.553575+00
378	zerver	0319_realm_giphy_rating	2024-08-02 08:55:45.570295+00
379	zerver	0320_realm_move_messages_between_streams_policy	2024-08-02 08:55:45.586963+00
380	zerver	0321_userprofile_enable_marketing_emails	2024-08-02 08:55:45.613224+00
381	zerver	0322_realm_create_audit_log_backfill	2024-08-02 08:55:45.641103+00
382	zerver	0323_show_starred_message_counts	2024-08-02 08:55:45.75274+00
383	zerver	0324_fix_deletion_cascade_behavior	2024-08-02 08:55:45.864208+00
384	zerver	0325_alter_realmplayground_unique_together	2024-08-02 08:55:45.882397+00
385	zerver	0359_re2_linkifiers	2024-08-02 08:55:45.912076+00
386	zerver	0326_alter_realm_authentication_methods	2024-08-02 08:55:45.92863+00
387	zerver	0327_realm_edit_topic_policy	2024-08-02 08:55:45.945113+00
388	zerver	0328_migrate_to_edit_topic_policy	2024-08-02 08:55:45.97364+00
389	zerver	0329_remove_realm_allow_community_topic_editing	2024-08-02 08:55:45.989614+00
390	zerver	0330_linkifier_pattern_validator	2024-08-02 08:55:46.061831+00
391	zerver	0331_scheduledmessagenotificationemail	2024-08-02 08:55:46.098818+00
392	zerver	0332_realmuserdefault	2024-08-02 08:55:46.130291+00
393	zerver	0333_alter_realm_org_type	2024-08-02 08:55:46.174686+00
394	zerver	0334_email_notifications_batching_period	2024-08-02 08:55:46.218066+00
395	zerver	0335_add_draft_sync_field	2024-08-02 08:55:46.261408+00
396	zerver	0336_userstatus_status_emoji	2024-08-02 08:55:46.385899+00
397	zerver	0337_realm_add_custom_emoji_policy	2024-08-02 08:55:46.404761+00
398	zerver	0338_migrate_to_add_custom_emoji_policy	2024-08-02 08:55:46.435271+00
399	zerver	0339_remove_realm_add_emoji_by_admins_only	2024-08-02 08:55:46.453061+00
400	zerver	0340_rename_mutedtopic_to_usertopic	2024-08-02 08:55:46.530041+00
401	zerver	0341_usergroup_is_system_group	2024-08-02 08:55:46.557303+00
402	zerver	0342_realm_demo_organization_scheduled_deletion_date	2024-08-02 08:55:46.573822+00
403	zerver	0343_alter_useractivityinterval_index_together	2024-08-02 08:55:46.597337+00
404	zerver	0344_alter_emojiset_default_value	2024-08-02 08:55:46.641783+00
405	zerver	0345_alter_realm_name	2024-08-02 08:55:46.746758+00
406	zerver	0346_create_realm_user_default_table	2024-08-02 08:55:46.776912+00
407	zerver	0347_realm_emoji_animated	2024-08-02 08:55:46.804314+00
408	zerver	0348_rename_date_muted_usertopic_last_updated	2024-08-02 08:55:46.829558+00
409	zerver	0349_alter_usertopic_table	2024-08-02 08:55:46.853814+00
410	zerver	0350_usertopic_visibility_policy	2024-08-02 08:55:46.87826+00
411	zerver	0351_user_topic_visibility_indexes	2024-08-02 08:55:46.926788+00
412	zerver	0352_migrate_twenty_four_hour_time_to_realmuserdefault	2024-08-02 08:55:46.956829+00
413	zerver	0353_remove_realm_default_twenty_four_hour_time	2024-08-02 08:55:46.973278+00
414	zerver	0354_alter_realm_message_content_delete_limit_seconds	2024-08-02 08:55:47.090417+00
415	zerver	0355_realm_delete_own_message_policy	2024-08-02 08:55:47.108635+00
416	zerver	0356_migrate_to_delete_own_message_policy	2024-08-02 08:55:47.142067+00
417	zerver	0357_remove_realm_allow_message_deleting	2024-08-02 08:55:47.160804+00
418	zerver	0358_split_create_stream_policy	2024-08-02 08:55:47.243984+00
419	zerver	0360_merge_0358_0359	2024-08-02 08:55:47.244496+00
420	zerver	0361_realm_create_web_public_stream_policy	2024-08-02 08:55:47.26214+00
421	zerver	0362_send_typing_notifications_user_setting	2024-08-02 08:55:47.408559+00
422	zerver	0363_send_read_receipts_user_setting	2024-08-02 08:55:47.453151+00
423	zerver	0364_rename_members_usergroup_direct_members	2024-08-02 08:55:47.480244+00
424	zerver	0365_alter_user_group_related_fields	2024-08-02 08:55:47.5633+00
425	zerver	0366_group_group_membership	2024-08-02 08:55:47.629545+00
426	zerver	0367_scimclient	2024-08-02 08:55:47.661218+00
427	zerver	0368_alter_realmfilter_url_format_string	2024-08-02 08:55:47.661744+00
428	zerver	0369_add_escnav_default_display_user_setting	2024-08-02 08:55:47.768212+00
429	zerver	0370_realm_enable_spectator_access	2024-08-02 08:55:47.785693+00
430	zerver	0371_invalid_characters_in_topics	2024-08-02 08:55:47.815993+00
431	zerver	0372_realmemoji_unique_realm_emoji_when_false_deactivated	2024-08-02 08:55:47.843916+00
432	zerver	0373_fix_deleteduser_dummies	2024-08-02 08:55:47.876275+00
433	zerver	0374_backfill_user_delete_realmauditlog	2024-08-02 08:55:47.906531+00
434	zerver	0375_invalid_characters_in_stream_names	2024-08-02 08:55:47.936201+00
435	zerver	0376_set_realmemoji_author_and_reupload_realmemoji	2024-08-02 08:55:47.966892+00
436	zerver	0377_message_edit_history_format	2024-08-02 08:55:48.046039+00
437	zerver	0378_alter_realmuserdefault_realm	2024-08-02 08:55:48.081322+00
438	zerver	0379_userprofile_uuid	2024-08-02 08:55:48.110729+00
439	zerver	0380_userprofile_uuid_backfill	2024-08-02 08:55:48.141691+00
440	zerver	0381_alter_userprofile_uuid	2024-08-02 08:55:48.173137+00
441	zerver	0382_create_role_based_system_groups	2024-08-02 08:55:48.203456+00
442	zerver	0383_revoke_invitations_from_deactivated_users	2024-08-02 08:55:48.233329+00
443	zerver	0384_alter_realm_not_null	2024-08-02 08:55:48.295488+00
444	zerver	0385_attachment_flags_cache	2024-08-02 08:55:48.465033+00
445	zerver	0386_fix_attachment_caches	2024-08-02 08:55:48.524748+00
446	zerver	0387_reupload_realmemoji_again	2024-08-02 08:55:48.555364+00
447	zerver	0388_preregistrationuser_created_user	2024-08-02 08:55:48.586435+00
448	zerver	0389_userprofile_display_emoji_reaction_users	2024-08-02 08:55:48.630702+00
449	zerver	0390_fix_stream_history_public_to_subscribers	2024-08-02 08:55:48.711934+00
450	zerver	0391_alter_stream_history_public_to_subscribers	2024-08-02 08:55:48.74161+00
451	zerver	0392_non_nullable_fields	2024-08-02 08:55:48.874941+00
452	zerver	0393_realm_want_advertise_in_communities_directory	2024-08-02 08:55:48.892859+00
453	zerver	0394_alter_realm_want_advertise_in_communities_directory	2024-08-02 08:55:48.911394+00
454	zerver	0395_alter_realm_wildcard_mention_policy	2024-08-02 08:55:49.011609+00
455	zerver	0396_remove_subscription_role	2024-08-02 08:55:49.036108+00
456	zerver	0397_remove_custom_field_values_for_deleted_options	2024-08-02 08:55:49.067038+00
457	zerver	0398_tsvector_statistics	2024-08-02 08:55:49.069316+00
458	zerver	0399_preregistrationuser_multiuse_invite	2024-08-02 08:55:49.100369+00
459	zerver	0400_realmreactivationstatus	2024-08-02 08:55:49.132089+00
460	zerver	0401_migrate_old_realm_reactivation_links	2024-08-02 08:55:49.162872+00
461	zerver	0402_alter_usertopic_visibility_policy	2024-08-02 08:55:49.187483+00
462	zerver	0403_create_role_based_groups_for_internal_realms	2024-08-02 08:55:49.218531+00
463	zerver	0404_realm_enable_read_receipts	2024-08-02 08:55:49.236631+00
464	zerver	0405_set_default_for_enable_read_receipts	2024-08-02 08:55:49.319992+00
465	zerver	0406_alter_realm_message_content_edit_limit_seconds	2024-08-02 08:55:49.388237+00
466	zerver	0407_userprofile_user_list_style	2024-08-02 08:55:49.434917+00
467	zerver	0408_stream_can_remove_subscribers_group	2024-08-02 08:55:49.466226+00
468	zerver	0409_set_default_for_can_remove_subscribers_group	2024-08-02 08:55:49.49725+00
469	zerver	0410_alter_stream_can_remove_subscribers_group	2024-08-02 08:55:49.529622+00
470	zerver	0411_alter_muteduser_muted_user_and_more	2024-08-02 08:55:49.587681+00
471	zerver	0412_customprofilefield_display_in_profile_summary	2024-08-02 08:55:49.660959+00
472	zerver	0413_set_presence_enabled_false_for_user_status_away	2024-08-02 08:55:49.693411+00
473	zerver	0414_remove_userstatus_status	2024-08-02 08:55:49.717037+00
474	zerver	0415_delete_scimclient	2024-08-02 08:55:49.71924+00
475	zerver	0416_set_default_emoji_style	2024-08-02 08:55:49.750732+00
476	zerver	0417_alter_customprofilefield_field_type	2024-08-02 08:55:49.768135+00
477	zerver	0418_archivedmessage_realm_message_realm	2024-08-02 08:55:49.830564+00
478	zerver	0419_backfill_message_realm	2024-08-02 08:55:49.86502+00
479	zerver	0420_alter_archivedmessage_realm_alter_message_realm	2024-08-02 08:55:49.981675+00
480	zerver	0421_migrate_pronouns_custom_profile_fields	2024-08-02 08:55:50.013334+00
481	zerver	0422_multiuseinvite_status	2024-08-02 08:55:50.042178+00
482	zerver	0423_fix_email_gateway_attachment_owner	2024-08-02 08:55:50.072988+00
483	zerver	0424_realm_move_messages_within_stream_limit_seconds	2024-08-02 08:55:50.092877+00
484	zerver	0425_realm_move_messages_between_streams_limit_seconds	2024-08-02 08:55:50.112534+00
485	zerver	0426_add_email_address_visibility_setting	2024-08-02 08:55:50.159361+00
486	zerver	0427_migrate_to_user_level_email_address_visibility_setting	2024-08-02 08:55:50.190788+00
487	zerver	0428_remove_realm_email_address_visibility	2024-08-02 08:55:50.210343+00
488	zerver	0429_user_topic_case_insensitive_unique_toghether	2024-08-02 08:55:50.315954+00
489	zerver	0430_fix_audit_log_objects_for_group_based_stream_settings	2024-08-02 08:55:50.347392+00
490	zerver	0431_alter_archivedreaction_unique_together_and_more	2024-08-02 08:55:50.396841+00
491	zerver	0432_alter_and_migrate_realm_name_in_notifications	2024-08-02 08:55:50.548119+00
492	zerver	0433_preregistrationrealm	2024-08-02 08:55:50.643519+00
493	zerver	0434_create_nobody_system_group	2024-08-02 08:55:50.675124+00
494	zerver	0435_scheduledmessage_rendered_content	2024-08-02 08:55:50.704619+00
495	zerver	0436_realmauthenticationmethods	2024-08-02 08:55:50.770681+00
496	zerver	0437_remove_realm_authentication_methods	2024-08-02 08:55:50.790958+00
497	zerver	0438_add_web_mark_read_on_scroll_policy_setting	2024-08-02 08:55:50.839328+00
498	zerver	0439_fix_deleteduser_email	2024-08-02 08:55:50.871192+00
499	zerver	0440_realmfilter_url_template	2024-08-02 08:55:50.909308+00
500	zerver	0441_backfill_realmfilter_url_template	2024-08-02 08:55:50.94068+00
501	zerver	0442_remove_realmfilter_url_format_string	2024-08-02 08:55:51.05037+00
502	zerver	0443_userpresence_new_table_schema	2024-08-02 08:55:51.233398+00
503	zerver	0444_userpresence_fill_data	2024-08-02 08:55:51.265359+00
504	zerver	0445_drop_userpresenceold	2024-08-02 08:55:51.268225+00
505	zerver	0446_realmauditlog_zerver_realmauditlog_user_subscriptions_idx	2024-08-02 08:55:51.297874+00
506	zerver	0447_attachment_scheduled_messages_and_more	2024-08-02 08:55:51.423533+00
507	zerver	0448_scheduledmessage_new_fields	2024-08-02 08:55:51.513647+00
508	zerver	0449_scheduledmessage_zerver_unsent_scheduled_messages_indexes	2024-08-02 08:55:51.572194+00
509	zerver	0450_backfill_subscription_auditlogs	2024-08-02 08:55:51.604083+00
510	zerver	0451_add_userprofile_api_key_index	2024-08-02 08:55:51.637702+00
511	zerver	0452_realmauditlog_extra_data_json	2024-08-02 08:55:51.724949+00
512	zerver	0453_followed_topic_notifications	2024-08-02 08:55:51.968438+00
513	zerver	0454_usergroup_can_mention_group	2024-08-02 08:55:52.054113+00
514	zerver	0455_set_default_for_can_mention_group	2024-08-02 08:55:52.087151+00
515	zerver	0456_alter_usergroup_can_mention_group	2024-08-02 08:55:52.121203+00
516	zerver	0457_backfill_scheduledmessagenotificationemail_trigger	2024-08-02 08:55:52.123135+00
517	zerver	0458_realmauditlog_modified_user_group	2024-08-02 08:55:52.156084+00
518	zerver	0459_remove_invalid_characters_from_user_group_name	2024-08-02 08:55:52.189962+00
519	zerver	0460_backfill_realmauditlog_extradata_to_json_field	2024-08-02 08:55:52.222589+00
520	zerver	0461_alter_realm_default_code_block_language	2024-08-02 08:55:52.296605+00
521	zerver	0462_realmplayground_url_template	2024-08-02 08:55:52.375416+00
522	zerver	0463_backfill_realmplayground_url_template	2024-08-02 08:55:52.408662+00
523	zerver	0464_remove_realmplayground_url_prefix	2024-08-02 08:55:52.449963+00
524	zerver	0465_backfill_scheduledmessagenotificationemail_trigger	2024-08-02 08:55:52.451251+00
525	zerver	0466_realmfilter_order	2024-08-02 08:55:52.502609+00
526	zerver	0467_rename_extradata_realmauditlog_extra_data_json	2024-08-02 08:55:52.561743+00
527	zerver	0468_rename_followup_day_email_templates	2024-08-02 08:55:52.596309+00
528	zerver	0469_realm_create_multiuse_invite_group	2024-08-02 08:55:52.629896+00
529	zerver	0470_set_default_value_for_create_multiuse_invite_group	2024-08-02 08:55:52.716906+00
530	zerver	0471_alter_realm_create_multiuse_invite_group	2024-08-02 08:55:52.751842+00
531	zerver	0472_add_message_realm_id_indexes	2024-08-02 08:55:53.088097+00
532	zerver	0473_remove_message_non_realm_id_indexes	2024-08-02 08:55:53.208923+00
533	zerver	0474_realmuserdefault_web_stream_unreads_count_display_policy_and_more	2024-08-02 08:55:53.259632+00
534	zerver	0475_realm_jitsi_server_url	2024-08-02 08:55:53.335217+00
535	zerver	0476_realmuserdefault_automatically_follow_topics_policy_and_more	2024-08-02 08:55:53.436828+00
536	zerver	0477_alter_realmuserdefault_automatically_follow_topics_policy_and_more	2024-08-02 08:55:53.437508+00
537	zerver	0478_realm_enable_guest_user_indicator	2024-08-02 08:55:53.461106+00
538	zerver	0479_realm_uuid_realm_uuid_owner_secret	2024-08-02 08:55:53.506706+00
539	zerver	0480_realm_backfill_uuid_and_secret	2024-08-02 08:55:53.53947+00
540	zerver	0481_alter_realm_uuid_alter_realm_uuid_owner_secret	2024-08-02 08:55:53.585631+00
541	zerver	0482_automatically_follow_unmute_topics_policy_defaults	2024-08-02 08:55:53.790616+00
542	zerver	0483_rename_escape_navigates_to_default_view_realmuserdefault_web_escape_navigates_to_home_view_and_more	2024-08-02 08:55:53.89792+00
543	zerver	0484_preregistrationrealm_default_language	2024-08-02 08:55:53.928438+00
544	zerver	0485_alter_usermessage_flags_and_add_index	2024-08-02 08:55:54.074197+00
545	zerver	0486_clear_old_data_for_unused_usermessage_flags	2024-08-02 08:55:54.163007+00
546	zerver	0487_realm_can_access_all_users_group	2024-08-02 08:55:54.198715+00
547	zerver	0488_set_default_value_for_can_access_all_users_group	2024-08-02 08:55:54.233595+00
548	zerver	0489_alter_realm_can_access_all_users_group	2024-08-02 08:55:54.270358+00
549	zerver	0490_renumber_options_desktop_icon_count_display	2024-08-02 08:55:54.305191+00
550	zerver	0491_alter_realmuserdefault_web_home_view_and_more	2024-08-02 08:55:54.418904+00
551	zerver	0492_realm_push_notifications_enabled_and_more	2024-08-02 08:55:54.465037+00
552	zerver	0493_rename_userhotspot_to_onboardingstep	2024-08-02 08:55:54.571677+00
553	zerver	0494_realmuserdefault_automatically_follow_topics_where_mentioned_and_more	2024-08-02 08:55:54.62286+00
554	zerver	0495_scheduledmessage_read_by_sender	2024-08-02 08:55:54.654+00
555	zerver	0496_alter_scheduledmessage_read_by_sender	2024-08-02 08:55:54.775122+00
556	zerver	0501_delete_dangling_usermessages	2024-08-02 08:55:54.813426+00
557	zerver	0517_resort_edit_history	2024-08-02 08:55:54.813947+00
558	zerver	0497_resort_edit_history	2024-08-02 08:55:54.815513+00
559	zerver	0498_rename_notifications_stream_realm_new_stream_announcements_stream	2024-08-02 08:55:54.843298+00
560	zerver	0499_rename_signup_notifications_stream_realm_signup_announcements_stream	2024-08-02 08:55:54.869479+00
561	zerver	0500_realm_zulip_update_announcements_stream	2024-08-02 08:55:54.937192+00
562	zerver	0501_mark_introduce_zulip_view_modals_as_read	2024-08-02 08:55:54.970623+00
563	zerver	0502_merge_20240319_2236	2024-08-02 08:55:54.971234+00
564	zerver	0503_realm_zulip_update_announcements_level	2024-08-02 08:55:54.994303+00
565	zerver	0504_customprofilefield_required	2024-08-02 08:55:55.015447+00
566	zerver	0505_realmuserdefault_web_font_size_px_and_more	2024-08-02 08:55:55.186943+00
567	zerver	0506_realm_require_unique_names	2024-08-02 08:55:55.210167+00
568	zerver	0507_rework_realm_upload_quota_gb	2024-08-02 08:55:55.254198+00
569	zerver	0508_realmuserdefault_receives_typing_notifications_and_more	2024-08-02 08:55:55.305303+00
570	zerver	0509_fix_emoji_metadata	2024-08-02 08:55:55.337952+00
571	zerver	0510_add_realmauditlog_realm_event_type_index	2024-08-02 08:55:55.36921+00
572	zerver	0511_stream_creator	2024-08-02 08:55:55.49356+00
573	zerver	0512_namedusergroup	2024-08-02 08:55:55.531509+00
574	zerver	0513_copy_groups_data_to_named_user_group	2024-08-02 08:55:55.564435+00
575	zerver	0514_update_usergroup_foreign_keys_to_namedusergroup	2024-08-02 08:55:55.700788+00
576	zerver	0515_rename_named_group_can_mention_group_namedusergroup_can_mention_group_and_more	2024-08-02 08:55:56.08089+00
577	zerver	0516_fix_confirmation_preregistrationusers	2024-08-02 08:55:56.086037+00
578	zerver	0518_merge	2024-08-02 08:55:56.086546+00
579	zerver	0519_archivetransaction_restored_timestamp	2024-08-02 08:55:56.109143+00
580	zerver	0520_attachment_zerver_attachment_realm_create_time	2024-08-02 08:55:56.193754+00
581	zerver	0521_multiuseinvite_include_realm_default_subscriptions_and_more	2024-08-02 08:55:56.254188+00
582	zerver	0522_set_include_realm_default_subscriptions_for_existing_objects	2024-08-02 08:55:56.320507+00
583	zerver	0523_alter_multiuseinvite_subscribe_to_default_streams_and_more	2024-08-02 08:55:56.381934+00
584	zerver	0524_remove_userprofile_onboarding_steps	2024-08-02 08:55:56.413382+00
585	zerver	0525_userpresence_last_update_id	2024-08-02 08:55:56.530203+00
586	zerver	0526_user_presence_backfill_last_update_id_to_0	2024-08-02 08:55:56.626357+00
587	zerver	0527_presencesequence	2024-08-02 08:55:56.694444+00
588	zerver	0528_realmauditlog_zerver_realmauditlog_user_activations_idx	2024-08-02 08:55:56.726861+00
589	zerver	0529_fts_bigint_id	2024-08-02 08:55:56.729666+00
590	zerver	0530_alter_useractivity_id_alter_useractivityinterval_id	2024-08-02 08:55:56.850594+00
591	zerver	0531_convert_most_ids_to_bigints	2024-08-02 08:55:58.713078+00
592	zerver	0532_realm_can_create_public_channel_group	2024-08-02 08:55:58.74731+00
593	zerver	0533_set_can_create_public_channel_group	2024-08-02 08:55:58.783543+00
594	zerver	0534_alter_realm_can_create_public_channel_group	2024-08-02 08:55:58.820371+00
595	zerver	0535_remove_realm_create_public_stream_policy	2024-08-02 08:55:58.843444+00
596	zerver	0536_add_message_type	2024-08-02 08:55:58.962765+00
597	zerver	0537_realm_can_create_private_channel_group	2024-08-02 08:55:58.998461+00
598	zerver	0538_set_can_create_private_channel_group	2024-08-02 08:55:59.036248+00
599	zerver	0539_alter_realm_can_create_private_channel_group	2024-08-02 08:55:59.072836+00
600	zerver	0540_remove_realm_create_private_stream_policy	2024-08-02 08:55:59.095947+00
601	zerver	0541_alter_realmauditlog_options	2024-08-02 08:55:59.127801+00
602	zerver	0542_onboardingusermessage	2024-08-02 08:55:59.165882+00
603	zerver	0543_preregistrationuser_notify_referrer_on_join	2024-08-02 08:55:59.197443+00
604	zerver	0544_copy_avatar_images	2024-08-02 08:55:59.289611+00
605	zerver	0545_attachment_content_type	2024-08-02 08:55:59.355599+00
606	zerver	0546_rename_huddle_directmessagegroup_and_more	2024-08-02 08:55:59.373718+00
607	zerver	0547_realmuserdefault_web_navigate_to_sent_message_and_more	2024-08-02 08:55:59.428328+00
608	zerver	0548_realmuserdefault_web_channel_default_view_and_more	2024-08-02 08:55:59.48203+00
609	zerver	0549_realm_direct_message_initiator_group_and_more	2024-08-02 08:55:59.55037+00
610	zerver	0550_set_default_value_for_realm_direct_message_initiator_group_and_more	2024-08-02 08:55:59.643591+00
611	zerver	0551_alter_realm_direct_message_initiator_group_and_more	2024-08-02 08:55:59.719042+00
612	zerver	0552_remove_realm_private_message_policy	2024-08-02 08:55:59.743275+00
613	zerver	0553_copy_emoji_images	2024-08-02 08:55:59.781472+00
614	zerver	0554_imageattachment	2024-08-02 08:55:59.81793+00
615	zerver	0555_alter_onboardingstep_onboarding_step	2024-08-02 08:55:59.844729+00
616	zerver	0556_alter_realmuserdefault_dense_mode_and_more	2024-08-02 08:56:00.066777+00
617	zerver	0557_change_information_density_defaults	2024-08-02 08:56:00.102429+00
618	zerver	0558_realmuserdefault_web_animate_image_previews_and_more	2024-08-02 08:56:00.156834+00
619	social_django	0002_add_related_name	2024-08-02 08:56:00.160331+00
620	social_django	0001_initial	2024-08-02 08:56:00.160677+00
621	social_django	0004_auto_20160423_0400	2024-08-02 08:56:00.161005+00
622	social_django	0005_auto_20160727_2333	2024-08-02 08:56:00.161355+00
623	social_django	0003_alter_email_max_length	2024-08-02 08:56:00.161653+00
624	phonenumber	0001_squashed_0001_initial	2024-08-02 08:56:00.161968+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_session (session_key, session_data, expire_date) FROM stdin;
is9enavulv22icsccfjejx4rqytiizrx	.eJxVi0sOwiAQQO_C2jRQpjC4NJ7CDeEzhKq1TSkLbXp3NelCt--zMuvqkm0tNNs-siNDdvhl3oUbPb7iNc3jlcLS7Kg0l3rvp3Mdhudpr_7W7Er-fNGT5AITSlASRWxNEgG8lgY4GO50UtQhJxGS71qldXCea6EQAMhQYtsbh101hg:1sZo9D:r067zPnC7_pHfby1kZXvmJDt8Al1F0uzye5n5U2kWGw	2024-08-16 09:00:27.916837+00
\.


--
-- Data for Name: fts_update_log; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.fts_update_log (id, message_id) FROM stdin;
\.


--
-- Data for Name: otp_static_staticdevice; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.otp_static_staticdevice (id, name, confirmed, user_id, throttling_failure_count, throttling_failure_timestamp, created_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: otp_static_statictoken; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.otp_static_statictoken (id, token, device_id) FROM stdin;
\.


--
-- Data for Name: otp_totp_totpdevice; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.otp_totp_totpdevice (id, name, confirmed, key, step, t0, digits, tolerance, drift, last_t, user_id, throttling_failure_count, throttling_failure_timestamp, created_at, last_used_at) FROM stdin;
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

COPY zulip.social_auth_partial (id, token, next_step, backend, "timestamp", data) FROM stdin;
\.


--
-- Data for Name: social_auth_usersocialauth; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.social_auth_usersocialauth (id, provider, uid, user_id, created, modified, extra_data) FROM stdin;
\.


--
-- Data for Name: third_party_api_results; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.third_party_api_results (cache_key, value, expires) FROM stdin;
\.


--
-- Data for Name: two_factor_phonedevice; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.two_factor_phonedevice (id, name, confirmed, throttling_failure_timestamp, throttling_failure_count, number, key, method, user_id) FROM stdin;
\.


--
-- Data for Name: zerver_alertword; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_alertword (id, word, realm_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedattachment; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedattachment (id, file_name, path_id, is_realm_public, create_time, size, owner_id, realm_id, is_web_public, content_type) FROM stdin;
\.


--
-- Data for Name: zerver_archivedattachment_messages; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedattachment_messages (id, archivedattachment_id, archivedmessage_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedmessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedmessage (id, subject, content, rendered_content, rendered_content_version, date_sent, last_edit_time, edit_history, has_attachment, has_image, has_link, recipient_id, sender_id, sending_client_id, archive_transaction_id, realm_id, type) FROM stdin;
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

COPY zulip.zerver_archivetransaction (id, "timestamp", restored, type, realm_id, restored_timestamp) FROM stdin;
\.


--
-- Data for Name: zerver_attachment; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_attachment (id, file_name, path_id, create_time, owner_id, is_realm_public, realm_id, size, is_web_public, content_type) FROM stdin;
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
1	Internal
2	website
3	ZulipMobile
4	ZulipElectron
5	internal
\.


--
-- Data for Name: zerver_customprofilefield; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_customprofilefield (id, name, field_type, realm_id, hint, field_data, "order", display_in_profile_summary, required) FROM stdin;
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
2	2	2
3	2	3
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
1	2	3
2	3	4
3	4	5
4	5	6
5	6	7
6	7	8
7	10	11
8	11	12
9	12	13
10	13	14
11	14	15
12	15	16
\.


--
-- Data for Name: zerver_huddle; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_huddle (id, huddle_hash, recipient_id) FROM stdin;
\.


--
-- Data for Name: zerver_imageattachment; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_imageattachment (id, path_id, original_width_px, original_height_px, frames, thumbnail_metadata, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_message; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_message (id, subject, content, rendered_content, rendered_content_version, last_edit_time, edit_history, has_attachment, has_image, has_link, recipient_id, sender_id, sending_client_id, search_tsvector, date_sent, realm_id, type) FROM stdin;
1	moving messages	If anything is out of place, it’s easy to [move messages](/help/move-content-to-another-topic), [rename](/help/rename-a-topic) and [split](/help/move-content-to-another-topic) topics, or even move a topic [to a different channel](/help/move-content-to-another-channel).	<p>If anything is out of place, it’s easy to <a href="/help/move-content-to-another-topic">move messages</a>, <a href="/help/rename-a-topic">rename</a> and <a href="/help/move-content-to-another-topic">split</a> topics, or even move a topic <a href="/help/move-content-to-another-channel">to a different channel</a>.</p>	1	\N	\N	f	f	t	8	7	1	'anything':4 'channel':27 'different':26 'easy':11 'even':20 'message':2,14 'move':1,13,21 'moving':1 'name':15 'place':8 'split':17 'topic':18,23	2024-08-02 09:00:26.875464+00	2	1
2	moving messages	:point_right: Try moving this message to another topic and back.	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span> Try moving this message to another topic and back.</p>	1	\N	\N	f	f	f	8	7	1	'another':10 'back':13 'message':2,8 'move':1,6 'moving':1,6 'point':3 'right':4 'topic':11 'try':5	2024-08-02 09:00:26.885994+00	2	1
9	greetings	:point_right: Click on this message to start a new message in the same conversation.	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span> Click on this message to start a new message in the same conversation.</p>	1	\N	\N	f	f	f	10	7	1	'click':4 'conversation':16 'greet':1 'message':7,12 'new':11 'point':2 'right':3 'start':9	2024-08-02 09:00:26.973805+00	2	1
10	welcome to Zulip!	Zulip is organised to help you communicate more efficiently. Conversations are labeled with topics, which summarise what the conversation is about.\n\nFor example, this message is in the “welcome to Zulip!” topic in the #**Zulip** channel, as you can see in the left sidebar and above.	<p>Zulip is organised to help you communicate more efficiently. Conversations are labeled with topics, which summarise what the conversation is about.</p>\n<p>For example, this message is in the “welcome to Zulip!” topic in the <a class="stream" data-stream-id="1" href="/#narrow/stream/1-Zulip">#Zulip</a> channel, as you can see in the left sidebar and above.</p>	1	\N	\N	f	f	t	8	7	1	'channel':39 'communicate':10 'conversation':13,22 'efficient':12 'example':26 'help':8 'label':15 'labeled':15 'left':46 'message':28 'organis':6 'see':43 'sidebar':47 'summaris':19 'topic':17,35 'welcome':1,32 'zulip':3,4,34,38	2024-08-02 09:00:26.979949+00	2	1
11	welcome to Zulip!	You can read Zulip one conversation at a time, seeing each message in context, no matter how many other conversations are going on.	<p>You can read Zulip one conversation at a time, seeing each message in context, no matter how many other conversations are going on.</p>	1	\N	\N	f	f	f	8	7	1	'conversation':9,23 'go':25 'going':25 'many':21 'matte':19 'matter':19 'message':15 'one':8 'read':6 'seeing':13 'text':17 'time':12 'welcome':1 'zulip':3,7	2024-08-02 09:00:26.986469+00	2	1
12	welcome to Zulip!	:point_right: When you're ready, check out your [Inbox](/#inbox) for other conversations with unread messages.	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span> When you're ready, check out your <a href="/#inbox">Inbox</a> for other conversations with unread messages.</p>	1	\N	\N	f	f	t	8	7	1	'check':10 'conversation':16 'inbox':13 'message':19 'point':4 're':8 'ready':9 'right':5 'unread':18 'welcome':1 'zulip':3	2024-08-02 09:00:26.992107+00	2	1
13		Hello, and welcome to Zulip!👋  I've kicked off some conversations to help you get started. You can find them in your [Inbox](/#inbox).\n\n\n\nTo learn more, check out our [Getting started guide](/help/getting-started-with-zulip)!   We also have a guide for [Setting up your organization](/help/getting-your-organization-started-with-zulip).	<p>Hello, and welcome to Zulip!<span aria-label="wave" class="emoji emoji-1f44b" role="img" title="wave">:wave:</span>  I've kicked off some conversations to help you get started. You can find them in your <a href="/#inbox">Inbox</a>.</p>\n<p>To learn more, check out our <a href="/help/getting-started-with-zulip">Getting started guide</a>!   We also have a guide for <a href="/help/getting-your-organization-started-with-zulip">Setting up your organization</a>.</p>	1	\N	\N	f	f	t	11	7	1	'also':35 'check':28 'conversation':12 'find':20 'get':16 'getting':31 'guide':33,38 'hello':1 'help':14 'inbox':24 'kick':9 'learn':26 'organization':43 'sett':40 'setting':40 'start':17,32 've':8 'wave':6 'welcome':3 'zulip':5	2024-08-02 09:00:27.069925+00	2	1
3	experiments	:point_right:  Use this topic to try out [Zulip's messaging features](/help/format-your-message-using-markdown).	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span>  Use this topic to try out <a href="/help/format-your-message-using-markdown">Zulip's messaging features</a>.</p>	1	\N	\N	f	f	t	9	7	1	'experiment':1 'feature':13 'message':12 'point':2 'right':3 'topic':6 'try':8 'use':4 'zulip':10	2024-08-02 09:00:26.892065+00	2	1
4	experiments	```spoiler Want to see some examples?\n\n````python\n\nprint("code blocks")\n\n````\n\n- bulleted\n- lists\n\nLink to a conversation: #**Zulip>welcome to Zulip!**\n\n```	<div class="spoiler-block"><div class="spoiler-header">\n<p>Want to see some examples?</p>\n</div><div class="spoiler-content" aria-hidden="true">\n<div class="codehilite" data-code-language="Python"><pre><span></span><code><span class="nb">print</span><span class="p">(</span><span class="s2">"code blocks"</span><span class="p">)</span>\n</code></pre></div>\n<ul>\n<li>bulleted</li>\n<li>lists</li>\n</ul>\n<p>Link to a conversation: <a class="stream-topic" data-stream-id="1" href="/#narrow/stream/1-Zulip/topic/welcome.20to.20Zulip.21">#Zulip &gt; welcome to Zulip!</a></p>\n</div></div>	1	\N	\N	f	f	t	9	7	1	'block':9 'bullet':10 'code':8 'conversation':15 'example':6 'experiment':1 'link':12 'list':11 'print':7 'see':4 'want':2 'welcome':17 'zulip':16,19	2024-08-02 09:00:26.897933+00	2	1
5	start a conversation	To kick off a new conversation, click **Start new conversation** below. The new conversation thread will be labeled with its own topic.	<p>To kick off a new conversation, click <strong>Start new conversation</strong> below. The new conversation thread will be labeled with its own topic.</p>	1	\N	\N	f	f	f	9	7	1	'click':10 'conversation':3,9,13,17 'kick':5 'label':21 'labeled':21 'new':8,12,16 'start':1,11 'thread':18 'topic':25	2024-08-02 09:00:26.949992+00	2	1
6	start a conversation	For a good topic name, think about finishing the sentence: “Hey, can we chat about…?”	<p>For a good topic name, think about finishing the sentence: “Hey, can we chat about…?”</p>	1	\N	\N	f	f	f	9	7	1	'chat':17 'conversation':3 'finish':11 'good':6 'hey':14 'name':8 'sentence':13 'start':1 'think':9 'topic':7	2024-08-02 09:00:26.956408+00	2	1
7	start a conversation	:point_right: Try starting a new conversation in this channel.	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span> Try starting a new conversation in this channel.</p>	1	\N	\N	f	f	f	9	7	1	'channel':13 'conversation':3,10 'new':9 'point':4 'right':5 'start':1,7 'try':6	2024-08-02 09:00:26.962116+00	2	1
8	greetings	This **greetings** topic is a great place to say “hi” :wave: to your teammates.	<p>This <strong>greetings</strong> topic is a great place to say “hi” <span aria-label="wave" class="emoji emoji-1f44b" role="img" title="wave">:wave:</span> to your teammates.</p>	1	\N	\N	f	f	f	10	7	1	'great':7 'greet':1,3 'hi':11 'place':8 'say':10 'teammate':15 'topic':4 'wave':12	2024-08-02 09:00:26.967873+00	2	1
\.


--
-- Data for Name: zerver_missedmessageemailaddress; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_missedmessageemailaddress (id, email_token, "timestamp", times_used, message_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_multiuseinvite; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_multiuseinvite (id, realm_id, referred_by_id, invited_as, status, include_realm_default_subscriptions) FROM stdin;
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
-- Data for Name: zerver_namedusergroup; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_namedusergroup (usergroup_ptr_id, name, description, is_system_group, can_mention_group_id, realm_id) FROM stdin;
1	role:nobody	Nobody	t	1	1
2	role:owners	Owners of this organization	t	1	1
3	role:administrators	Administrators of this organization, including owners	t	1	1
4	role:moderators	Moderators of this organization, including administrators	t	1	1
5	role:fullmembers	Members of this organization, not including new accounts and guests	t	1	1
6	role:members	Members of this organization, not including guests	t	1	1
7	role:everyone	Everyone in this organization, including guests	t	1	1
8	role:internet	Everyone on the Internet	t	1	1
9	role:nobody	Nobody	t	9	2
10	role:owners	Owners of this organization	t	9	2
11	role:administrators	Administrators of this organization, including owners	t	9	2
12	role:moderators	Moderators of this organization, including administrators	t	9	2
13	role:fullmembers	Members of this organization, not including new accounts and guests	t	9	2
14	role:members	Members of this organization, not including guests	t	9	2
15	role:everyone	Everyone in this organization, including guests	t	9	2
16	role:internet	Everyone on the Internet	t	9	2
\.


--
-- Data for Name: zerver_onboardingstep; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_onboardingstep (id, onboarding_step, "timestamp", user_id) FROM stdin;
1	visibility_policy_banner	2024-08-02 09:00:27.079678+00	8
\.


--
-- Data for Name: zerver_onboardingusermessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_onboardingusermessage (id, flags, message_id, realm_id) FROM stdin;
1	6	1	2
2	2	2	2
3	6	3	2
4	2	4	2
5	6	5	2
6	2	6	2
7	2	7	2
8	6	8	2
9	2	9	2
10	6	10	2
11	2	11	2
12	2	12	2
\.


--
-- Data for Name: zerver_preregistrationrealm; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationrealm (id, name, org_type, string_id, email, status, created_realm_id, created_user_id, default_language) FROM stdin;
1	testing	10		test@test.com	1	2	8	en-gb
\.


--
-- Data for Name: zerver_preregistrationuser; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationuser (id, email, invited_at, status, realm_id, referred_by_id, realm_creation, password_required, invited_as, full_name, full_name_validated, created_user_id, multiuse_invite_id, include_realm_default_subscriptions, notify_referrer_on_join) FROM stdin;
\.


--
-- Data for Name: zerver_preregistrationuser_streams; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationuser_streams (id, preregistrationuser_id, stream_id) FROM stdin;
\.


--
-- Data for Name: zerver_presencesequence; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_presencesequence (id, last_update_id, realm_id) FROM stdin;
1	0	1
2	3	2
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
1	7	8	wave	1f44b	unicode_emoji
\.


--
-- Data for Name: zerver_realm; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realm (id, name, emails_restricted_to_domains, invite_required, mandatory_topics, digest_emails_enabled, name_changes_disabled, date_created, deactivated, new_stream_announcements_stream_id, allow_message_editing, message_content_edit_limit_seconds, default_language, string_id, org_type, message_retention_days, waiting_period_threshold, icon_source, icon_version, email_changes_disabled, description, inline_image_preview, inline_url_embed_preview, allow_edit_history, signup_announcements_stream_id, max_invites, message_visibility_limit, send_welcome_emails, bot_creation_policy, disallow_disposable_email_addresses, message_content_delete_limit_seconds, plan_type, first_visible_message_id, logo_source, logo_version, message_content_allowed_in_email_notifications, night_logo_source, night_logo_version, digest_weekday, invite_to_stream_policy, avatar_changes_disabled, video_chat_provider, user_group_edit_policy, default_code_block_language, wildcard_mention_policy, deactivated_redirect, invite_to_realm_policy, giphy_rating, move_messages_between_streams_policy, edit_topic_policy, add_custom_emoji_policy, demo_organization_scheduled_deletion_date, delete_own_message_policy, create_web_public_stream_policy, enable_spectator_access, want_advertise_in_communities_directory, enable_read_receipts, move_messages_within_stream_limit_seconds, move_messages_between_streams_limit_seconds, create_multiuse_invite_group_id, jitsi_server_url, enable_guest_user_indicator, uuid, uuid_owner_secret, can_access_all_users_group_id, push_notifications_enabled, push_notifications_enabled_end_timestamp, zulip_update_announcements_stream_id, zulip_update_announcements_level, require_unique_names, custom_upload_quota_gb, can_create_public_channel_group_id, can_create_private_channel_group_id, direct_message_initiator_group_id, direct_message_permission_group_id) FROM stdin;
1	System bot realm	f	t	f	f	f	2024-08-02 09:00:26.607909+00	f	\N	t	600	en	zulipinternal	0	-1	0	G	1	f		t	f	t	\N	\N	\N	t	1	t	600	1	0	D	1	t	D	1	1	1	f	1	1		5	\N	1	2	1	5	1	\N	5	7	f	f	f	604800	604800	3	\N	t	d8fd5bda-7125-499b-bfa3-230089eefe75	zuliprealm_JBRC2TDwdsQV07haPatn3o4apY6jxABz	7	f	\N	\N	\N	f	\N	6	6	7	7
2	testing	f	t	f	f	f	2024-08-02 09:00:26.698642+00	f	3	t	600	en-gb		10	-1	0	G	1	f		t	f	t	\N	\N	\N	t	1	t	600	1	0	D	1	t	D	1	1	1	f	1	1		5	\N	1	2	1	5	1	\N	5	7	f	f	t	604800	604800	11	\N	t	f2c61d8f-c5ab-4149-a334-42fc5ddd633c	zuliprealm_AFFRvSPWum18wttzDo3Keg41uj1BPDUV	15	f	\N	3	8	f	\N	14	14	15	15
\.


--
-- Data for Name: zerver_realmauditlog; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmauditlog (id, backfilled, event_time, acting_user_id, modified_stream_id, modified_user_id, realm_id, event_last_message_id, event_type, extra_data, modified_user_group_id) FROM stdin;
1	f	2024-08-02 09:00:26.607909+00	\N	\N	\N	1	\N	215	{}	\N
2	f	2024-08-02 09:00:26.627518+00	\N	\N	\N	1	\N	701	{}	1
3	f	2024-08-02 09:00:26.627518+00	\N	\N	\N	1	\N	701	{}	2
4	f	2024-08-02 09:00:26.627518+00	\N	\N	\N	1	\N	701	{}	3
5	f	2024-08-02 09:00:26.627518+00	\N	\N	\N	1	\N	701	{}	4
6	f	2024-08-02 09:00:26.627518+00	\N	\N	\N	1	\N	701	{}	5
7	f	2024-08-02 09:00:26.627518+00	\N	\N	\N	1	\N	701	{}	6
8	f	2024-08-02 09:00:26.627518+00	\N	\N	\N	1	\N	701	{}	7
9	f	2024-08-02 09:00:26.627518+00	\N	\N	\N	1	\N	701	{}	8
10	f	2024-08-02 09:00:26.630242+00	\N	\N	\N	1	\N	705	{"subgroup_ids": [2]}	3
11	f	2024-08-02 09:00:26.630242+00	\N	\N	\N	1	\N	707	{"supergroup_ids": [3]}	2
12	f	2024-08-02 09:00:26.630324+00	\N	\N	\N	1	\N	705	{"subgroup_ids": [3]}	4
13	f	2024-08-02 09:00:26.630324+00	\N	\N	\N	1	\N	707	{"supergroup_ids": [4]}	3
14	f	2024-08-02 09:00:26.630404+00	\N	\N	\N	1	\N	705	{"subgroup_ids": [4]}	5
15	f	2024-08-02 09:00:26.630404+00	\N	\N	\N	1	\N	707	{"supergroup_ids": [5]}	4
16	f	2024-08-02 09:00:26.630466+00	\N	\N	\N	1	\N	705	{"subgroup_ids": [5]}	6
17	f	2024-08-02 09:00:26.630466+00	\N	\N	\N	1	\N	707	{"supergroup_ids": [6]}	5
18	f	2024-08-02 09:00:26.630528+00	\N	\N	\N	1	\N	705	{"subgroup_ids": [6]}	7
19	f	2024-08-02 09:00:26.630528+00	\N	\N	\N	1	\N	707	{"supergroup_ids": [7]}	6
20	f	2024-08-02 09:00:26.6306+00	\N	\N	\N	1	\N	705	{"subgroup_ids": [7]}	8
21	f	2024-08-02 09:00:26.6306+00	\N	\N	\N	1	\N	707	{"supergroup_ids": [8]}	7
22	f	2024-08-02 09:00:26.651917+00	\N	\N	1	1	\N	101	{}	\N
23	f	2024-08-02 09:00:26.652263+00	\N	\N	2	1	\N	101	{}	\N
24	f	2024-08-02 09:00:26.652425+00	\N	\N	3	1	\N	101	{}	\N
25	f	2024-08-02 09:00:26.65259+00	\N	\N	4	1	\N	101	{}	\N
26	f	2024-08-02 09:00:26.652751+00	\N	\N	5	1	\N	101	{}	\N
27	f	2024-08-02 09:00:26.652896+00	\N	\N	6	1	\N	101	{}	\N
28	f	2024-08-02 09:00:26.653052+00	\N	\N	7	1	\N	101	{}	\N
29	f	2024-08-02 09:00:26.668949+00	\N	\N	1	1	\N	703	{}	6
30	f	2024-08-02 09:00:26.668949+00	\N	\N	1	1	\N	703	{}	5
31	f	2024-08-02 09:00:26.668949+00	\N	\N	2	1	\N	703	{}	6
32	f	2024-08-02 09:00:26.668949+00	\N	\N	2	1	\N	703	{}	5
33	f	2024-08-02 09:00:26.668949+00	\N	\N	3	1	\N	703	{}	6
34	f	2024-08-02 09:00:26.668949+00	\N	\N	3	1	\N	703	{}	5
35	f	2024-08-02 09:00:26.668949+00	\N	\N	4	1	\N	703	{}	6
36	f	2024-08-02 09:00:26.668949+00	\N	\N	4	1	\N	703	{}	5
37	f	2024-08-02 09:00:26.668949+00	\N	\N	5	1	\N	703	{}	6
38	f	2024-08-02 09:00:26.668949+00	\N	\N	5	1	\N	703	{}	5
39	f	2024-08-02 09:00:26.668949+00	\N	\N	6	1	\N	703	{}	6
40	f	2024-08-02 09:00:26.668949+00	\N	\N	6	1	\N	703	{}	5
41	f	2024-08-02 09:00:26.668949+00	\N	\N	7	1	\N	703	{}	6
42	f	2024-08-02 09:00:26.668949+00	\N	\N	7	1	\N	703	{}	5
44	f	2024-08-02 09:00:26.70361+00	\N	\N	\N	2	\N	701	{}	9
45	f	2024-08-02 09:00:26.70361+00	\N	\N	\N	2	\N	701	{}	10
46	f	2024-08-02 09:00:26.70361+00	\N	\N	\N	2	\N	701	{}	11
47	f	2024-08-02 09:00:26.70361+00	\N	\N	\N	2	\N	701	{}	12
48	f	2024-08-02 09:00:26.70361+00	\N	\N	\N	2	\N	701	{}	13
49	f	2024-08-02 09:00:26.70361+00	\N	\N	\N	2	\N	701	{}	14
50	f	2024-08-02 09:00:26.70361+00	\N	\N	\N	2	\N	701	{}	15
51	f	2024-08-02 09:00:26.70361+00	\N	\N	\N	2	\N	701	{}	16
52	f	2024-08-02 09:00:26.705239+00	\N	\N	\N	2	\N	705	{"subgroup_ids": [10]}	11
53	f	2024-08-02 09:00:26.705239+00	\N	\N	\N	2	\N	707	{"supergroup_ids": [11]}	10
54	f	2024-08-02 09:00:26.70529+00	\N	\N	\N	2	\N	705	{"subgroup_ids": [11]}	12
55	f	2024-08-02 09:00:26.70529+00	\N	\N	\N	2	\N	707	{"supergroup_ids": [12]}	11
56	f	2024-08-02 09:00:26.705331+00	\N	\N	\N	2	\N	705	{"subgroup_ids": [12]}	13
57	f	2024-08-02 09:00:26.705331+00	\N	\N	\N	2	\N	707	{"supergroup_ids": [13]}	12
58	f	2024-08-02 09:00:26.705372+00	\N	\N	\N	2	\N	705	{"subgroup_ids": [13]}	14
59	f	2024-08-02 09:00:26.705372+00	\N	\N	\N	2	\N	707	{"supergroup_ids": [14]}	13
60	f	2024-08-02 09:00:26.705411+00	\N	\N	\N	2	\N	705	{"subgroup_ids": [14]}	15
61	f	2024-08-02 09:00:26.705411+00	\N	\N	\N	2	\N	707	{"supergroup_ids": [15]}	14
62	f	2024-08-02 09:00:26.705451+00	\N	\N	\N	2	\N	705	{"subgroup_ids": [15]}	16
63	f	2024-08-02 09:00:26.705451+00	\N	\N	\N	2	\N	707	{"supergroup_ids": [16]}	15
64	f	2024-08-02 09:00:26.741474+00	\N	1	\N	2	\N	601	{}	\N
65	f	2024-08-02 09:00:26.755626+00	\N	2	\N	2	\N	601	{}	\N
66	f	2024-08-02 09:00:26.760282+00	\N	3	\N	2	\N	601	{}	\N
67	f	2024-08-02 09:00:26.769576+00	8	\N	8	2	\N	101	{"10": {"11": {"100": 1, "200": 0, "300": 0, "400": 0, "600": 0}, "12": 0}}	\N
43	f	2024-08-02 09:00:26.698642+00	8	\N	\N	2	\N	215	{"how_realm_creator_found_zulip": "Search engine", "how_realm_creator_found_zulip_extra_context": ""}	\N
68	f	2024-08-02 09:00:26.769576+00	8	\N	8	2	\N	703	{}	10
69	f	2024-08-02 09:00:27.050611+00	\N	1	8	2	12	301	{}	\N
70	f	2024-08-02 09:00:27.050611+00	\N	2	8	2	12	301	{}	\N
71	f	2024-08-02 09:00:27.050611+00	\N	3	8	2	12	301	{}	\N
\.


--
-- Data for Name: zerver_realmauthenticationmethod; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmauthenticationmethod (id, name, realm_id) FROM stdin;
1	Dev	1
2	Email	1
3	LDAP	1
4	RemoteUser	1
5	GitHub	1
6	AzureAD	1
7	GitLab	1
8	Google	1
9	Apple	1
10	SAML	1
11	OpenID Connect	1
12	Dev	2
13	Email	2
14	LDAP	2
15	RemoteUser	2
16	GitHub	2
17	AzureAD	2
18	GitLab	2
19	Google	2
20	Apple	2
21	SAML	2
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

COPY zulip.zerver_realmfilter (id, pattern, realm_id, url_template, "order") FROM stdin;
\.


--
-- Data for Name: zerver_realmplayground; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmplayground (id, name, pygments_language, realm_id, url_template) FROM stdin;
\.


--
-- Data for Name: zerver_realmreactivationstatus; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmreactivationstatus (id, status, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmuserdefault; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmuserdefault (id, enter_sends, left_side_userlist, default_language, web_home_view, dense_mode, fluid_layout_width, high_contrast_mode, translate_emoticons, twenty_four_hour_time, starred_message_counts, color_scheme, demote_inactive_streams, emojiset, enable_stream_desktop_notifications, enable_stream_email_notifications, enable_stream_push_notifications, enable_stream_audible_notifications, notification_sound, wildcard_mentions_notify, enable_desktop_notifications, pm_content_in_desktop_notifications, enable_sounds, enable_offline_email_notifications, message_content_in_email_notifications, enable_offline_push_notifications, enable_online_push_notifications, desktop_icon_count_display, enable_digest_emails, enable_login_emails, enable_marketing_emails, presence_enabled, realm_id, email_notifications_batching_period_seconds, enable_drafts_synchronization, send_private_typing_notifications, send_stream_typing_notifications, send_read_receipts, web_escape_navigates_to_home_view, display_emoji_reaction_users, user_list_style, email_address_visibility, realm_name_in_email_notifications_policy, web_mark_read_on_scroll_policy, enable_followed_topic_audible_notifications, enable_followed_topic_desktop_notifications, enable_followed_topic_email_notifications, enable_followed_topic_push_notifications, enable_followed_topic_wildcard_mentions_notify, web_stream_unreads_count_display_policy, automatically_follow_topics_policy, automatically_unmute_topics_in_muted_streams_policy, automatically_follow_topics_where_mentioned, web_font_size_px, web_line_height_percent, receives_typing_notifications, web_navigate_to_sent_message, web_channel_default_view, web_animate_image_previews) FROM stdin;
1	f	f	en	inbox	f	f	f	f	f	t	1	1	google	f	f	f	f	zulip	t	t	t	t	t	t	t	t	1	t	t	t	t	1	120	t	t	t	t	t	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
2	f	f	en	inbox	f	f	f	f	f	t	1	1	google	f	f	f	f	zulip	t	t	t	t	t	t	t	t	1	t	t	t	t	2	120	t	t	t	t	t	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
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
10	3	2
11	8	1
\.


--
-- Data for Name: zerver_scheduledemail; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledemail (id, scheduled_timestamp, data, address, type, realm_id) FROM stdin;
1	2024-08-06 08:00:27.063781+00	{"template_prefix":"zerver/emails/onboarding_zulip_topics","from_name":null,"from_address":"SUPPORT","language":null,"context":{"realm_url":"https://localhost","realm_name":"testing","root_domain_url":"https://localhost","external_url_scheme":"https://","external_host":"localhost","user_name":"tester","corporate_enabled":false,"unsubscribe_link":"https://localhost/accounts/unsubscribe/welcome/aasgnk3uxlzdurlf4mbgdc22","move_messages_link":"https://localhost/help/move-content-to-another-topic","rename_topics_link":"https://localhost/help/rename-a-topic","move_channels_link":"https://localhost/help/move-content-to-another-channel"}}	\N	1	2
2	2024-08-08 08:00:27.065293+00	{"template_prefix":"zerver/emails/onboarding_zulip_guide","from_name":null,"from_address":"SUPPORT","language":null,"context":{"realm_url":"https://localhost","realm_name":"testing","root_domain_url":"https://localhost","external_url_scheme":"https://","external_host":"localhost","user_name":"tester","corporate_enabled":false,"unsubscribe_link":"https://localhost/accounts/unsubscribe/welcome/aasgnk3uxlzdurlf4mbgdc22","organization_type":"business","zulip_guide_link":"https://zulip.com/for/business/"}}	\N	1	2
3	2024-08-12 08:00:27.066258+00	{"template_prefix":"zerver/emails/onboarding_team_to_zulip","from_name":null,"from_address":"SUPPORT","language":null,"context":{"realm_url":"https://localhost","realm_name":"testing","root_domain_url":"https://localhost","external_url_scheme":"https://","external_host":"localhost","user_name":"tester","corporate_enabled":false,"unsubscribe_link":"https://localhost/accounts/unsubscribe/welcome/aasgnk3uxlzdurlf4mbgdc22","get_organization_started":"https://localhost/help/getting-your-organization-started-with-zulip","invite_users":"https://localhost/help/invite-users-to-join","trying_out_zulip":"https://localhost/help/trying-out-zulip","why_zulip":"https://zulip.com/why-zulip/"}}	\N	1	2
\.


--
-- Data for Name: zerver_scheduledemail_users; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledemail_users (id, scheduledemail_id, userprofile_id) FROM stdin;
1	1	8
2	2	8
3	3	8
\.


--
-- Data for Name: zerver_scheduledmessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledmessage (id, subject, content, scheduled_timestamp, delivered, realm_id, recipient_id, sender_id, sending_client_id, stream_id, delivery_type, rendered_content, has_attachment, failed, failure_message, delivered_message_id, read_by_sender) FROM stdin;
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

COPY zulip.zerver_stream (id, name, invite_only, email_token, description, date_created, deactivated, realm_id, is_in_zephyr_realm, history_public_to_subscribers, is_web_public, rendered_description, first_message_id, message_retention_days, recipient_id, stream_post_policy, can_remove_subscribers_group_id, creator_id) FROM stdin;
2	sandbox	f	c65710313dcb1e8570f8bd2c6beeb0b4	Experiment with Zulip here. :test_tube:	2024-08-02 09:00:26.751749+00	f	2	f	t	f	<p>Experiment with Zulip here. <span aria-label="test tube" class="emoji emoji-1f9ea" role="img" title="test tube">:test_tube:</span></p>	7	\N	9	1	11	\N
3	general	f	7c7126bc836d5bcf7d19305ec5ebc3a5	For team-wide conversations	2024-08-02 09:00:26.758357+00	f	2	f	t	f	<p>For team-wide conversations</p>	9	\N	10	1	11	\N
1	Zulip	f	49581c9bc9d5ea384e0bf3feab9a00ad	Questions and discussion about using Zulip.	2024-08-02 09:00:26.714957+00	f	2	f	t	f	<p>Questions and discussion about using Zulip.</p>	12	\N	8	1	11	\N
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
8	t	#c2c2c2	\N	\N	11	8	f	\N	\N	f	\N	t
9	t	#76ce90	\N	\N	8	8	f	\N	\N	f	\N	t
10	t	#fae589	\N	\N	9	8	f	\N	\N	f	\N	t
11	t	#a6c7e5	\N	\N	10	8	f	\N	\N	f	\N	t
\.


--
-- Data for Name: zerver_useractivity; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_useractivity (id, query, count, last_visit, client_id, user_profile_id) FROM stdin;
1	log_into_subdomain	1	2024-08-02 09:00:27+00	2	8
2	home_real	1	2024-08-02 09:00:27+00	2	8
3	/api/v1/events/internal	2	2024-08-02 09:00:27+00	5	8
5	get_messages_backend	3	2024-08-02 09:00:28+00	2	8
7	set_tutorial_status	1	2024-08-02 09:00:28+00	2	8
8	update_message_flags	1	2024-08-02 09:00:28+00	2	8
9	get_user_invites	1	2024-08-02 09:00:48+00	2	8
12	json_fetch_api_key	2	2024-08-02 09:02:42+00	2	8
6	get_events	6	2024-08-02 09:03:14+00	2	8
\.


--
-- Data for Name: zerver_useractivityinterval; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_useractivityinterval (id, start, "end", user_profile_id) FROM stdin;
1	2024-08-02 09:00:28+00	2024-08-02 09:17:28+00	8
\.


--
-- Data for Name: zerver_usergroup; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usergroup (id, realm_id) FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	2
10	2
11	2
12	2
13	2
14	2
15	2
16	2
\.


--
-- Data for Name: zerver_usergroupmembership; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usergroupmembership (id, user_group_id, user_profile_id) FROM stdin;
1	6	1
2	5	1
3	6	2
4	5	2
5	6	3
6	5	3
7	6	4
8	5	4
9	6	5
10	5	5
11	6	6
12	5	6
13	6	7
14	5	7
15	10	8
\.


--
-- Data for Name: zerver_usermessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usermessage (flags, message_id, user_profile_id, id) FROM stdin;
2	1	8	1
0	2	8	2
2	3	8	3
0	4	8	4
2	5	8	5
0	6	8	6
0	7	8	7
2	8	8	8
0	9	8	9
2	10	8	10
0	11	8	11
0	12	8	12
2048	13	7	14
2051	13	8	13
\.


--
-- Data for Name: zerver_userpresence; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userpresence (id, last_connected_time, last_active_time, realm_id, user_profile_id, last_update_id) FROM stdin;
1	2024-08-02 09:02:28+00	2024-08-02 09:02:28+00	2	8	3
\.


--
-- Data for Name: zerver_userprofile; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userprofile (id, password, last_login, is_superuser, email, is_staff, is_active, is_bot, date_joined, is_mirror_dummy, full_name, api_key, enable_stream_desktop_notifications, enable_stream_audible_notifications, enable_desktop_notifications, enable_sounds, enable_offline_email_notifications, enable_offline_push_notifications, enable_digest_emails, last_reminder, rate_limits, default_all_public_streams, enter_sends, twenty_four_hour_time, avatar_source, tutorial_status, bot_owner_id, default_events_register_stream_id, default_sending_stream_id, realm_id, left_side_userlist, can_forge_sender, bot_type, default_language, tos_version, enable_online_push_notifications, pm_content_in_desktop_notifications, avatar_version, timezone, emojiset, last_active_message_id, long_term_idle, high_contrast_mode, enable_stream_push_notifications, enable_stream_email_notifications, translate_emoticons, message_content_in_email_notifications, dense_mode, delivery_email, starred_message_counts, is_billing_admin, enable_login_emails, notification_sound, fluid_layout_width, demote_inactive_streams, avatar_hash, desktop_icon_count_display, role, wildcard_mentions_notify, recipient_id, presence_enabled, zoom_token, color_scheme, can_create_users, web_home_view, enable_marketing_emails, email_notifications_batching_period_seconds, enable_drafts_synchronization, send_private_typing_notifications, send_stream_typing_notifications, send_read_receipts, web_escape_navigates_to_home_view, uuid, display_emoji_reaction_users, user_list_style, email_address_visibility, realm_name_in_email_notifications_policy, web_mark_read_on_scroll_policy, enable_followed_topic_audible_notifications, enable_followed_topic_desktop_notifications, enable_followed_topic_email_notifications, enable_followed_topic_push_notifications, enable_followed_topic_wildcard_mentions_notify, web_stream_unreads_count_display_policy, automatically_follow_topics_policy, automatically_unmute_topics_in_muted_streams_policy, automatically_follow_topics_where_mentioned, web_font_size_px, web_line_height_percent, receives_typing_notifications, web_navigate_to_sent_message, web_channel_default_view, web_animate_image_previews) FROM stdin;
2	!W90lSYcJcynQbTMfSfggruHZQ04mo3dsRiNbcnE0	2024-08-02 09:00:26.652263+00	f	nagios-receive-bot@zulip.com	f	t	t	2024-08-02 09:00:26.652263+00	f	Nagios Receive Bot	2g2pV6R1aIlbGsqPJoxpUc2Uh5h4EcDv	f	f	t	t	t	t	t	\N		f	f	f	G	F	2	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	f	nagios-receive-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	2	t	\N	1	f	inbox	t	120	t	t	t	t	t	065b4ebb-62d7-4e4a-b294-c53f45f01074	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
3	!B4NpGKWd0MoWqysrI5WmtzCcZEEkSclJpDstGtQY	2024-08-02 09:00:26.652425+00	f	nagios-send-bot@zulip.com	f	t	t	2024-08-02 09:00:26.652425+00	f	Nagios Send Bot	i2P0bt503MxGT2ob8YMZjqKq28Q81URJ	f	f	t	t	t	t	t	\N		f	f	f	G	F	3	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	f	nagios-send-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	3	t	\N	1	f	inbox	t	120	t	t	t	t	t	c2905c5b-a64d-4e49-93a1-77879a2884c3	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
4	!jjf5ZeFIynHoTNkE13mvgPk2tEPgAaSFtXUz8LlX	2024-08-02 09:00:26.65259+00	f	nagios-staging-receive-bot@zulip.com	f	t	t	2024-08-02 09:00:26.65259+00	f	Nagios Staging Receive Bot	2TPYm90iUvc7PAuQVZDRkPTpxnR0iSEH	f	f	t	t	t	t	t	\N		f	f	f	G	F	4	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	f	nagios-staging-receive-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	4	t	\N	1	f	inbox	t	120	t	t	t	t	t	cc1c2bf3-0453-4675-b2e8-fd6c38a589c8	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
5	!9L156I8NyhmLinuSeiEORJUc5GM7xxYn0wTEbRmc	2024-08-02 09:00:26.652751+00	f	nagios-staging-send-bot@zulip.com	f	t	t	2024-08-02 09:00:26.652751+00	f	Nagios Staging Send Bot	CJLwUAGfYubvlwlhZpFQVcR4jzS6UbKP	f	f	t	t	t	t	t	\N		f	f	f	G	F	5	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	f	nagios-staging-send-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	5	t	\N	1	f	inbox	t	120	t	t	t	t	t	a659cc77-69d7-4d1b-ba5c-31a12e11714b	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
6	!y6ZCsINgLj7e22g8wdR2w17MLaPlbjKJ6h4f1pcR	2024-08-02 09:00:26.652896+00	f	notification-bot@zulip.com	f	t	t	2024-08-02 09:00:26.652896+00	f	Notification Bot	G2QTeUSDDJqAPnS6lbyiy1ZDPdFcYQZi	f	f	t	t	t	t	t	\N		f	f	f	G	F	6	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	f	notification-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	6	t	\N	1	f	inbox	t	120	t	t	t	t	t	723c8c74-1f40-476b-a87c-e4527b0afe5e	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
7	!fbANbcjs1JvJkMjy2B4R2kAMF3YzWlQkUZDu3i04	2024-08-02 09:00:26.653052+00	f	welcome-bot@zulip.com	f	t	t	2024-08-02 09:00:26.653052+00	f	Welcome Bot	O7hIFsam401BehTGoXjHF7NFNnj3KDSI	f	f	t	t	t	t	t	\N		f	f	f	G	F	7	\N	\N	1	f	f	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	f	welcome-bot@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	7	t	\N	1	f	inbox	t	120	t	t	t	t	t	1fa93e5c-a4c5-4210-bdd6-cac644c4e4a6	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
1	!7USL7q9vJl2YVFryK6nm7D5arK3uyNxNG2i2Vtrt	2024-08-02 09:00:26.651917+00	f	emailgateway@zulip.com	f	t	t	2024-08-02 09:00:26.651917+00	f	Email Gateway	V1rRs9IizR1o7JotRRGfhPzg17DgcZUX	f	f	t	t	t	t	t	\N		f	f	f	G	F	1	\N	\N	1	f	t	1	en	\N	t	t	1		google	\N	f	f	f	f	f	t	f	emailgateway@zulip.com	t	f	t	zulip	f	1	\N	1	400	t	1	t	\N	1	f	inbox	t	120	t	t	t	t	t	16cab76d-a60c-4186-81bd-371bd581c0f9	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
8	argon2$argon2id$v=19$m=102400,t=2,p=8$ZnJTd0lkc1J4RDU4OVhwcnZUZER3Nw$z7CTdwm0tEjfzWAPPKaPNC6R1DFxFd5N4xNI4+8CK+Q	2024-08-02 09:00:27.11103+00	t	test@test.com	f	t	f	2024-08-02 09:00:26.769576+00	f	tester	4BC7m7srjklLX6yBRy66IvZcJ32jW28z	f	f	t	t	t	t	t	\N		f	f	f	G	S	\N	\N	\N	2	f	f	\N	en-gb	\N	t	t	1	Europe/London	google	\N	f	f	f	f	f	t	f	test@test.com	t	f	t	zulip	f	1	\N	1	100	t	11	t	\N	1	t	inbox	f	120	t	t	t	t	t	4f2c8447-4c17-4411-8e87-8f82e20a9857	t	2	1	1	1	t	t	t	t	t	2	3	2	t	16	140	t	t	1	on_hover
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

SELECT pg_catalog.setval('zulip.analytics_realmcount_id_seq', 1, false);


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

SELECT pg_catalog.setval('zulip.auth_permission_id_seq', 312, true);


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

SELECT pg_catalog.setval('zulip.django_content_type_id_seq', 78, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.django_migrations_id_seq', 624, true);


--
-- Name: fts_update_log_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.fts_update_log_id_seq', 13, true);


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

SELECT pg_catalog.setval('zulip.zerver_defaultstream_id_seq', 3, true);


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
-- Name: zerver_imageattachment_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_imageattachment_id_seq', 1, false);


--
-- Name: zerver_message_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_message_id_seq', 13, true);


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
-- Name: zerver_onboardingstep_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_onboardingstep_id_seq', 1, true);


--
-- Name: zerver_onboardingusermessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_onboardingusermessage_id_seq', 12, true);


--
-- Name: zerver_preregistrationrealm_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_preregistrationrealm_id_seq', 1, true);


--
-- Name: zerver_preregistrationuser_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_preregistrationuser_id_seq', 1, false);


--
-- Name: zerver_preregistrationuser_streams_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_preregistrationuser_streams_id_seq', 1, false);


--
-- Name: zerver_presencesequence_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_presencesequence_id_seq', 2, true);


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

SELECT pg_catalog.setval('zulip.zerver_realmauditlog_id_seq', 71, true);


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

SELECT pg_catalog.setval('zulip.zerver_recipient_id_seq', 11, true);


--
-- Name: zerver_scheduledemail_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledemail_id_seq', 4, true);


--
-- Name: zerver_scheduledemail_users_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledemail_users_id_seq', 4, true);


--
-- Name: zerver_scheduledmessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledmessage_id_seq', 1, false);


--
-- Name: zerver_scheduledmessagenotificationemail_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledmessagenotificationemail_id_seq', 1, false);


--
-- Name: zerver_service_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_service_id_seq', 1, false);


--
-- Name: zerver_stream_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_stream_id_seq', 3, true);


--
-- Name: zerver_submessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_submessage_id_seq', 1, false);


--
-- Name: zerver_subscription_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_subscription_id_seq', 11, true);


--
-- Name: zerver_useractivity_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_useractivity_id_seq', 14, true);


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
-- Name: zerver_usermessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_usermessage_id_seq', 14, true);


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
-- Name: zerver_imageattachment zerver_imageattachment_path_id_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_imageattachment
    ADD CONSTRAINT zerver_imageattachment_path_id_key UNIQUE (path_id);


--
-- Name: zerver_imageattachment zerver_imageattachment_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_imageattachment
    ADD CONSTRAINT zerver_imageattachment_pkey PRIMARY KEY (id);


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
-- Name: zerver_namedusergroup zerver_namedusergroup_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergroup_pkey PRIMARY KEY (usergroup_ptr_id);


--
-- Name: zerver_namedusergroup zerver_namedusergroup_realm_id_name_419247c4_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergroup_realm_id_name_419247c4_uniq UNIQUE (realm_id, name);


--
-- Name: zerver_onboardingstep zerver_onboardingstep_id_45d37e68_pk; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_onboardingstep
    ADD CONSTRAINT zerver_onboardingstep_id_45d37e68_pk PRIMARY KEY (id);


--
-- Name: zerver_onboardingstep zerver_onboardingstep_user_id_onboarding_step_82524e0a_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_onboardingstep
    ADD CONSTRAINT zerver_onboardingstep_user_id_onboarding_step_82524e0a_uniq UNIQUE (user_id, onboarding_step);


--
-- Name: zerver_onboardingusermessage zerver_onboardingusermessage_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_onboardingusermessage
    ADD CONSTRAINT zerver_onboardingusermessage_pkey PRIMARY KEY (id);


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
-- Name: zerver_presencesequence zerver_presencesequence_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_presencesequence
    ADD CONSTRAINT zerver_presencesequence_pkey PRIMARY KEY (id);


--
-- Name: zerver_presencesequence zerver_presencesequence_realm_id_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_presencesequence
    ADD CONSTRAINT zerver_presencesequence_realm_id_key UNIQUE (realm_id);


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
-- Name: zerver_realm zerver_realm_uuid_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_uuid_key UNIQUE (uuid);


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
-- Name: zerver_archivetransaction_restored_timestamp_7bf02066; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivetransaction_restored_timestamp_7bf02066 ON zulip.zerver_archivetransaction USING btree (restored_timestamp);


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
-- Name: zerver_attachment_realm_create_time; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_realm_create_time ON zulip.zerver_attachment USING btree (realm_id, create_time);


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
-- Name: zerver_imageattachment_path_id_0fbe468e_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_imageattachment_path_id_0fbe468e_like ON zulip.zerver_imageattachment USING btree (path_id text_pattern_ops);


--
-- Name: zerver_imageattachment_realm_id_297cef1f; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_imageattachment_realm_id_297cef1f ON zulip.zerver_imageattachment USING btree (realm_id);


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
-- Name: zerver_message_realm_date_sent; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_date_sent ON zulip.zerver_message USING btree (realm_id, date_sent);


--
-- Name: zerver_message_realm_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_id ON zulip.zerver_message USING btree (realm_id, id DESC NULLS LAST);


--
-- Name: zerver_message_realm_id_849a39c8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_id_849a39c8 ON zulip.zerver_message USING btree (realm_id);


--
-- Name: zerver_message_realm_recipient_date_sent; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_recipient_date_sent ON zulip.zerver_message USING btree (realm_id, recipient_id, date_sent);


--
-- Name: zerver_message_realm_recipient_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_recipient_id ON zulip.zerver_message USING btree (realm_id, recipient_id, id);


--
-- Name: zerver_message_realm_recipient_subject; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_recipient_subject ON zulip.zerver_message USING btree (realm_id, recipient_id, subject, id DESC NULLS LAST);


--
-- Name: zerver_message_realm_recipient_upper_subject; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_recipient_upper_subject ON zulip.zerver_message USING btree (realm_id, recipient_id, upper((subject)::text), id DESC NULLS LAST);


--
-- Name: zerver_message_realm_sender_recipient; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_sender_recipient ON zulip.zerver_message USING btree (realm_id, sender_id, recipient_id);


--
-- Name: zerver_message_realm_upper_subject; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_upper_subject ON zulip.zerver_message USING btree (realm_id, upper((subject)::text), id DESC NULLS LAST);


--
-- Name: zerver_message_recipient_id_5a7b6f03; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_recipient_id_5a7b6f03 ON zulip.zerver_message USING btree (recipient_id);


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
-- Name: zerver_namedusergroup_can_mention_group_id_39bf278e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_can_mention_group_id_39bf278e ON zulip.zerver_namedusergroup USING btree (can_mention_group_id);


--
-- Name: zerver_namedusergroup_realm_id_f1b966ff; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_realm_id_f1b966ff ON zulip.zerver_namedusergroup USING btree (realm_id);


--
-- Name: zerver_onboardingstep_user_id_3ced3a3a; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_onboardingstep_user_id_3ced3a3a ON zulip.zerver_onboardingstep USING btree (user_id);


--
-- Name: zerver_onboardingusermessage_message_id_ec6c709e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_onboardingusermessage_message_id_ec6c709e ON zulip.zerver_onboardingusermessage USING btree (message_id);


--
-- Name: zerver_onboardingusermessage_realm_id_ef89682e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_onboardingusermessage_realm_id_ef89682e ON zulip.zerver_onboardingusermessage USING btree (realm_id);


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
-- Name: zerver_realm_can_access_all_users_group_id_692c7cc6; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_access_all_users_group_id_692c7cc6 ON zulip.zerver_realm USING btree (can_access_all_users_group_id);


--
-- Name: zerver_realm_can_create_private_channel_group_id_ba294d86; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_create_private_channel_group_id_ba294d86 ON zulip.zerver_realm USING btree (can_create_private_channel_group_id);


--
-- Name: zerver_realm_can_create_public_channel_group_id_6eb35b68; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_create_public_channel_group_id_6eb35b68 ON zulip.zerver_realm USING btree (can_create_public_channel_group_id);


--
-- Name: zerver_realm_create_multiuse_invite_group_id_28a8b9cb; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_create_multiuse_invite_group_id_28a8b9cb ON zulip.zerver_realm USING btree (create_multiuse_invite_group_id);


--
-- Name: zerver_realm_direct_message_initiator_group_id_e7f0ea74; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_direct_message_initiator_group_id_e7f0ea74 ON zulip.zerver_realm USING btree (direct_message_initiator_group_id);


--
-- Name: zerver_realm_direct_message_permission_group_id_df6cc218; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_direct_message_permission_group_id_df6cc218 ON zulip.zerver_realm USING btree (direct_message_permission_group_id);


--
-- Name: zerver_realm_notifications_stream_id_f07609e9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_notifications_stream_id_f07609e9 ON zulip.zerver_realm USING btree (new_stream_announcements_stream_id);


--
-- Name: zerver_realm_push_notifications_enabled_f806b849; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_push_notifications_enabled_f806b849 ON zulip.zerver_realm USING btree (push_notifications_enabled);


--
-- Name: zerver_realm_signup_notifications_stream_id_1e735af4; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_signup_notifications_stream_id_1e735af4 ON zulip.zerver_realm USING btree (signup_announcements_stream_id);


--
-- Name: zerver_realm_subdomain_375be8b1_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_subdomain_375be8b1_like ON zulip.zerver_realm USING btree (string_id varchar_pattern_ops);


--
-- Name: zerver_realm_unsent_scheduled_messages_by_user; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_unsent_scheduled_messages_by_user ON zulip.zerver_scheduledmessage USING btree (realm_id, sender_id, delivery_type, scheduled_timestamp) WHERE (NOT delivered);


--
-- Name: zerver_realm_want_advertise_in_communities_directory_0776d2a9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_want_advertise_in_communities_directory_0776d2a9 ON zulip.zerver_realm USING btree (want_advertise_in_communities_directory);


--
-- Name: zerver_realm_zulip_update_announcements_stream_id_b7809c68; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_zulip_update_announcements_stream_id_b7809c68 ON zulip.zerver_realm USING btree (zulip_update_announcements_stream_id);


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
-- Name: zerver_realmauditlog_modified_user_group_id_56329312; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_modified_user_group_id_56329312 ON zulip.zerver_realmauditlog USING btree (modified_user_group_id);


--
-- Name: zerver_realmauditlog_modified_user_id_fa063d3c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_modified_user_id_fa063d3c ON zulip.zerver_realmauditlog USING btree (modified_user_id);


--
-- Name: zerver_realmauditlog_realm__event_type__event_time; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_realm__event_type__event_time ON zulip.zerver_realmauditlog USING btree (realm_id, event_type, event_time);


--
-- Name: zerver_realmauditlog_realm_id_7d25fe8b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_realm_id_7d25fe8b ON zulip.zerver_realmauditlog USING btree (realm_id);


--
-- Name: zerver_realmauditlog_user_activations_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmauditlog_user_activations_idx ON zulip.zerver_realmauditlog USING btree (modified_user_id, event_time) WHERE (event_type = ANY (ARRAY[101, 102, 103, 104]));


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
-- Name: zerver_stream_creator_id_65aeba7e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_creator_id_65aeba7e ON zulip.zerver_stream USING btree (creator_id);


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
-- Name: zerver_usermessage_active_mobile_push_notification_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_active_mobile_push_notification_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE ((flags & (4096)::bigint) <> 0);


--
-- Name: zerver_usermessage_any_mentioned_message_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usermessage_any_mentioned_message_id ON zulip.zerver_usermessage USING btree (user_profile_id, message_id) WHERE ((flags & (120)::bigint) <> 0);


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
-- Name: zerver_userpresence_last_update_id_63c97509; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_last_update_id_63c97509 ON zulip.zerver_userpresence USING btree (last_update_id);


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
-- Name: zerver_userpresence_realm_last_update_id_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userpresence_realm_last_update_id_idx ON zulip.zerver_userpresence USING btree (realm_id, last_update_id);


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
-- Name: zerver_message_realm_recipient; Type: STATISTICS; Schema: zulip; Owner: zulip
--

CREATE STATISTICS zulip.zerver_message_realm_recipient ON recipient_id, realm_id FROM zulip.zerver_message;


ALTER STATISTICS zulip.zerver_message_realm_recipient OWNER TO zulip;

--
-- Name: zerver_message_realm_sender; Type: STATISTICS; Schema: zulip; Owner: zulip
--

CREATE STATISTICS zulip.zerver_message_realm_sender ON sender_id, realm_id FROM zulip.zerver_message;


ALTER STATISTICS zulip.zerver_message_realm_sender OWNER TO zulip;

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
-- Name: analytics_streamcount analytics_streamcount_stream_id_e1168935_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.analytics_streamcount
    ADD CONSTRAINT analytics_streamcount_stream_id_e1168935_fk FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_archivedattachment_messages zerver_archivedattachment_archivedattachment_id_1b7d6694_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment_messages
    ADD CONSTRAINT zerver_archivedattachment_archivedattachment_id_1b7d6694_fk FOREIGN KEY (archivedattachment_id) REFERENCES zulip.zerver_archivedattachment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_archivedattachment zerver_archivedattachment_realm_id_95fb78cc_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment
    ADD CONSTRAINT zerver_archivedattachment_realm_id_95fb78cc_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_archivedmessage zerver_archivedmessage_archive_transaction_id_3f0a7f7b_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedmessage
    ADD CONSTRAINT zerver_archivedmessage_archive_transaction_id_3f0a7f7b_fk FOREIGN KEY (archive_transaction_id) REFERENCES zulip.zerver_archivetransaction(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_attachment_messages zerver_attachment_me_message_id_c5e566fb_fk_zerver_me; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_messages
    ADD CONSTRAINT zerver_attachment_me_message_id_c5e566fb_fk_zerver_me FOREIGN KEY (message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_attachment_messages zerver_attachment_messages_attachment_id_eb4e59c0_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_messages
    ADD CONSTRAINT zerver_attachment_messages_attachment_id_eb4e59c0_fk FOREIGN KEY (attachment_id) REFERENCES zulip.zerver_attachment(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_attachment_scheduled_messages zerver_attachment_schedul_scheduledmessage_id_27c3f026_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_scheduled_messages
    ADD CONSTRAINT zerver_attachment_schedul_scheduledmessage_id_27c3f026_fk FOREIGN KEY (scheduledmessage_id) REFERENCES zulip.zerver_scheduledmessage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_attachment_scheduled_messages zerver_attachment_scheduled_messages_attachment_id_03da128c_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment_scheduled_messages
    ADD CONSTRAINT zerver_attachment_scheduled_messages_attachment_id_03da128c_fk FOREIGN KEY (attachment_id) REFERENCES zulip.zerver_attachment(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_customprofilefieldvalue zerver_customprofilefieldvalue_field_id_00409129_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_customprofilefieldvalue
    ADD CONSTRAINT zerver_customprofilefieldvalue_field_id_00409129_fk FOREIGN KEY (field_id) REFERENCES zulip.zerver_customprofilefield(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstream zerver_defaultstream_realm_id_b5f0faf3_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstream
    ADD CONSTRAINT zerver_defaultstream_realm_id_b5f0faf3_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstream zerver_defaultstream_stream_id_9a8e0616_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstream
    ADD CONSTRAINT zerver_defaultstream_stream_id_9a8e0616_fk FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstreamgroup_streams zerver_defaultstreamgroup_defaultstreamgroup_id_bd9739b9_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup_streams
    ADD CONSTRAINT zerver_defaultstreamgroup_defaultstreamgroup_id_bd9739b9_fk FOREIGN KEY (defaultstreamgroup_id) REFERENCES zulip.zerver_defaultstreamgroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstreamgroup zerver_defaultstreamgroup_realm_id_b15f3495_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup
    ADD CONSTRAINT zerver_defaultstreamgroup_realm_id_b15f3495_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_defaultstreamgroup_streams zerver_defaultstreamgroup_streams_stream_id_9844331d_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_defaultstreamgroup_streams
    ADD CONSTRAINT zerver_defaultstreamgroup_streams_stream_id_9844331d_fk FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_groupgroupmembership zerver_groupgroupmembership_subgroup_id_3ec521bb_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_groupgroupmembership
    ADD CONSTRAINT zerver_groupgroupmembership_subgroup_id_3ec521bb_fk FOREIGN KEY (subgroup_id) REFERENCES zulip.zerver_namedusergroup(usergroup_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_groupgroupmembership zerver_groupgroupmembership_supergroup_id_3874b6ef_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_groupgroupmembership
    ADD CONSTRAINT zerver_groupgroupmembership_supergroup_id_3874b6ef_fk FOREIGN KEY (supergroup_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_huddle zerver_huddle_recipient_id_e3e1fadc_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_huddle
    ADD CONSTRAINT zerver_huddle_recipient_id_e3e1fadc_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_imageattachment zerver_imageattachment_realm_id_297cef1f_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_imageattachment
    ADD CONSTRAINT zerver_imageattachment_realm_id_297cef1f_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_multiuseinvite zerver_multiuseinvit_referred_by_id_8970bd5c_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite
    ADD CONSTRAINT zerver_multiuseinvit_referred_by_id_8970bd5c_fk_zerver_us FOREIGN KEY (referred_by_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite zerver_multiuseinvite_realm_id_8eb19d52_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite
    ADD CONSTRAINT zerver_multiuseinvite_realm_id_8eb19d52_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite_streams zerver_multiuseinvite_streams_multiuseinvite_id_be033d7f_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_streams
    ADD CONSTRAINT zerver_multiuseinvite_streams_multiuseinvite_id_be033d7f_fk FOREIGN KEY (multiuseinvite_id) REFERENCES zulip.zerver_multiuseinvite(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite_streams zerver_multiuseinvite_streams_stream_id_2cb97168_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_streams
    ADD CONSTRAINT zerver_multiuseinvite_streams_stream_id_2cb97168_fk FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usertopic zerver_mutedtopic_recipient_id_e1901302_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_mutedtopic_recipient_id_e1901302_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_namedusergroup zerver_namedusergroup_can_mention_group_id_39bf278e_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergroup_can_mention_group_id_39bf278e_fk FOREIGN KEY (can_mention_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergroup_realm_id_f1b966ff_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergroup_realm_id_f1b966ff_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergroup_usergroup_ptr_id_684bf3ca_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergroup_usergroup_ptr_id_684bf3ca_fk FOREIGN KEY (usergroup_ptr_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_onboardingstep zerver_onboardingstep_user_id_3ced3a3a_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_onboardingstep
    ADD CONSTRAINT zerver_onboardingstep_user_id_3ced3a3a_fk_zerver_userprofile_id FOREIGN KEY (user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_onboardingusermessage zerver_onboardinguse_message_id_ec6c709e_fk_zerver_me; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_onboardingusermessage
    ADD CONSTRAINT zerver_onboardinguse_message_id_ec6c709e_fk_zerver_me FOREIGN KEY (message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_onboardingusermessage zerver_onboardinguse_realm_id_ef89682e_fk_zerver_re; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_onboardingusermessage
    ADD CONSTRAINT zerver_onboardinguse_realm_id_ef89682e_fk_zerver_re FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_preregistrationuser zerver_preregistrati_referred_by_id_51f0a793_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrati_referred_by_id_51f0a793_fk_zerver_us FOREIGN KEY (referred_by_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser_streams zerver_preregistrationuse_preregistrationuser_id_332ca855_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams
    ADD CONSTRAINT zerver_preregistrationuse_preregistrationuser_id_332ca855_fk FOREIGN KEY (preregistrationuser_id) REFERENCES zulip.zerver_preregistrationuser(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser zerver_preregistrationuser_multiuse_invite_id_7747603e_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrationuser_multiuse_invite_id_7747603e_fk FOREIGN KEY (multiuse_invite_id) REFERENCES zulip.zerver_multiuseinvite(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser zerver_preregistrationuser_realm_id_fd5aff83_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrationuser_realm_id_fd5aff83_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser_streams zerver_preregistrationuser_streams_stream_id_29da6767_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams
    ADD CONSTRAINT zerver_preregistrationuser_streams_stream_id_29da6767_fk FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_presencesequence zerver_presencesequence_realm_id_63433ff2_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_presencesequence
    ADD CONSTRAINT zerver_presencesequence_realm_id_63433ff2_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_realm zerver_realm_can_access_all_users_group_id_692c7cc6_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_access_all_users_group_id_692c7cc6_fk FOREIGN KEY (can_access_all_users_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_create_private_c_ba294d86_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_create_private_c_ba294d86_fk_zerver_us FOREIGN KEY (can_create_private_channel_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_create_public_ch_6eb35b68_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_create_public_ch_6eb35b68_fk_zerver_us FOREIGN KEY (can_create_public_channel_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_create_multiuse_invite_group_id_28a8b9cb_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_create_multiuse_invite_group_id_28a8b9cb_fk FOREIGN KEY (create_multiuse_invite_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_direct_message_initi_e7f0ea74_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_direct_message_initi_e7f0ea74_fk_zerver_us FOREIGN KEY (direct_message_initiator_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_direct_message_permi_df6cc218_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_direct_message_permi_df6cc218_fk_zerver_us FOREIGN KEY (direct_message_permission_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_new_stream_announcements_stream_id_dc0a0303_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_new_stream_announcements_stream_id_dc0a0303_fk FOREIGN KEY (new_stream_announcements_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_signup_announcements_stream_id_9bdc4b8b_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_signup_announcements_stream_id_9bdc4b8b_fk FOREIGN KEY (signup_announcements_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_zulip_update_announcements_stream_id_b7809c68_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_zulip_update_announcements_stream_id_b7809c68_fk FOREIGN KEY (zulip_update_announcements_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_realmauditlog zerver_realmauditlog_modified_stream_id_4de0252c_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog
    ADD CONSTRAINT zerver_realmauditlog_modified_stream_id_4de0252c_fk FOREIGN KEY (modified_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmauditlog zerver_realmauditlog_modified_user_group_id_56329312_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog
    ADD CONSTRAINT zerver_realmauditlog_modified_user_group_id_56329312_fk FOREIGN KEY (modified_user_group_id) REFERENCES zulip.zerver_namedusergroup(usergroup_ptr_id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_scheduledemail_users zerver_scheduledemail_users_scheduledemail_id_792d525e_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledemail_users
    ADD CONSTRAINT zerver_scheduledemail_users_scheduledemail_id_792d525e_fk FOREIGN KEY (scheduledemail_id) REFERENCES zulip.zerver_scheduledemail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessage zerver_scheduledmess_delivered_message_id_e971c426_fk_zerver_me; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmess_delivered_message_id_e971c426_fk_zerver_me FOREIGN KEY (delivered_message_id) REFERENCES zulip.zerver_message(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_scheduledmessage zerver_scheduledmessage_stream_id_45dc289f_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessage
    ADD CONSTRAINT zerver_scheduledmessage_stream_id_45dc289f_fk FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_scheduledmessagenotificationemail zerver_scheduledmessageno_mentioned_user_group_id_6c2b438d_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessagenotificationemail
    ADD CONSTRAINT zerver_scheduledmessageno_mentioned_user_group_id_6c2b438d_fk FOREIGN KEY (mentioned_user_group_id) REFERENCES zulip.zerver_namedusergroup(usergroup_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_service zerver_service_user_profile_id_111b0c49_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_service
    ADD CONSTRAINT zerver_service_user_profile_id_111b0c49_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_can_remove_subscribers_group_id_ce4fe4b7_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_can_remove_subscribers_group_id_ce4fe4b7_fk FOREIGN KEY (can_remove_subscribers_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_creator_id_65aeba7e_fk_zerver_userprofile_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_creator_id_65aeba7e_fk_zerver_userprofile_id FOREIGN KEY (creator_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_usergroupmembership zerver_usergroupmemb_user_profile_id_6aa688e2_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroupmembership
    ADD CONSTRAINT zerver_usergroupmemb_user_profile_id_6aa688e2_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usergroupmembership zerver_usergroupmembership_user_group_id_7722d5a1_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usergroupmembership
    ADD CONSTRAINT zerver_usergroupmembership_user_group_id_7722d5a1_fk FOREIGN KEY (user_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_userprofile zerver_userprofile_default_events_register_s_40e28493_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_default_events_register_s_40e28493_fk FOREIGN KEY (default_events_register_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_userprofile zerver_userprofile_default_sending_stream_id_3ba7368b_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_default_sending_stream_id_3ba7368b_fk FOREIGN KEY (default_sending_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_usertopic zerver_usertopic_stream_id_0ce5ea26_fk; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_usertopic_stream_id_0ce5ea26_fk FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

