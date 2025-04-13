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
    object_id bigint NOT NULL,
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
    user_profile_id integer NOT NULL,
    realm_id integer NOT NULL
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
    create_time timestamp with time zone NOT NULL,
    size integer NOT NULL,
    content_type text,
    is_realm_public boolean,
    is_web_public boolean,
    owner_id integer NOT NULL,
    realm_id integer NOT NULL
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
    type smallint DEFAULT 1 NOT NULL,
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
    sender_id integer NOT NULL,
    archive_transaction_id bigint NOT NULL,
    sending_client_id integer NOT NULL,
    realm_id integer NOT NULL,
    recipient_id integer NOT NULL,
    is_channel_message boolean NOT NULL,
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
    restored_timestamp timestamp with time zone,
    type smallint NOT NULL,
    realm_id integer,
    protect_from_deletion boolean NOT NULL,
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
    size integer NOT NULL,
    content_type text,
    is_realm_public boolean,
    is_web_public boolean,
    owner_id integer NOT NULL,
    realm_id integer NOT NULL
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
-- Name: zerver_botconfigdata_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_botconfigdata ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_botconfigdata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
-- Name: zerver_botstoragedata_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_botstoragedata ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_botstoragedata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: zerver_channelemailaddress; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_channelemailaddress (
    id bigint NOT NULL,
    email_token character varying(32) NOT NULL,
    date_created timestamp with time zone NOT NULL,
    deactivated boolean NOT NULL,
    channel_id bigint NOT NULL,
    creator_id integer,
    realm_id integer NOT NULL,
    sender_id integer NOT NULL
);


ALTER TABLE zulip.zerver_channelemailaddress OWNER TO zulip;

--
-- Name: zerver_channelemailaddress_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_channelemailaddress ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_channelemailaddress_id_seq
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
    hint character varying(80) NOT NULL,
    "order" integer NOT NULL,
    display_in_profile_summary boolean NOT NULL,
    required boolean NOT NULL,
    field_type smallint NOT NULL,
    field_data text NOT NULL,
    realm_id integer NOT NULL,
    editable_by_user boolean DEFAULT true NOT NULL,
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
    rendered_value text,
    field_id bigint NOT NULL,
    user_profile_id integer NOT NULL
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
    description character varying(1024) NOT NULL,
    realm_id integer NOT NULL
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
    user_profile_id integer NOT NULL,
    recipient_id integer
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
    user_profile_id integer NOT NULL,
    realm_id integer NOT NULL
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
    supergroup_id bigint NOT NULL,
    subgroup_id bigint NOT NULL
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
    recipient_id integer,
    group_size integer NOT NULL
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
    realm_id integer NOT NULL,
    content_type text
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
    type smallint DEFAULT 1 NOT NULL,
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
    search_tsvector tsvector,
    sender_id integer NOT NULL,
    sending_client_id integer NOT NULL,
    realm_id integer NOT NULL,
    recipient_id integer NOT NULL,
    is_channel_message boolean NOT NULL,
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
    invited_as smallint NOT NULL,
    include_realm_default_subscriptions boolean NOT NULL,
    status integer NOT NULL,
    referred_by_id integer NOT NULL,
    realm_id integer NOT NULL,
    CONSTRAINT zerver_multiuseinvite_invited_as_check CHECK ((invited_as >= 0))
);


ALTER TABLE zulip.zerver_multiuseinvite OWNER TO zulip;

--
-- Name: zerver_multiuseinvite_groups; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_multiuseinvite_groups (
    id bigint NOT NULL,
    multiuseinvite_id bigint NOT NULL,
    namedusergroup_id bigint NOT NULL
);


ALTER TABLE zulip.zerver_multiuseinvite_groups OWNER TO zulip;

--
-- Name: zerver_multiuseinvite_groups_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_multiuseinvite_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_multiuseinvite_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    realm_id integer NOT NULL,
    can_manage_group_id bigint NOT NULL,
    deactivated boolean DEFAULT false NOT NULL,
    creator_id integer,
    date_created timestamp with time zone,
    can_join_group_id bigint NOT NULL,
    can_add_members_group_id bigint NOT NULL,
    can_leave_group_id bigint NOT NULL,
    can_remove_members_group_id bigint NOT NULL
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
    default_language character varying(50) NOT NULL,
    string_id character varying(40) NOT NULL,
    email character varying(254) NOT NULL,
    status integer NOT NULL,
    created_user_id integer,
    created_realm_id integer,
    data_import_metadata jsonb NOT NULL,
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
    full_name character varying(100),
    full_name_validated boolean NOT NULL,
    notify_referrer_on_join boolean NOT NULL,
    invited_at timestamp with time zone NOT NULL,
    realm_creation boolean NOT NULL,
    password_required boolean NOT NULL,
    status integer NOT NULL,
    invited_as smallint NOT NULL,
    include_realm_default_subscriptions boolean NOT NULL,
    created_user_id integer,
    multiuse_invite_id bigint,
    referred_by_id integer,
    realm_id integer,
    CONSTRAINT zerver_preregistrationuser_invited_as_check CHECK ((invited_as >= 0))
);


ALTER TABLE zulip.zerver_preregistrationuser OWNER TO zulip;

--
-- Name: zerver_preregistrationuser_groups; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_preregistrationuser_groups (
    id bigint NOT NULL,
    preregistrationuser_id bigint NOT NULL,
    namedusergroup_id bigint NOT NULL
);


ALTER TABLE zulip.zerver_preregistrationuser_groups OWNER TO zulip;

--
-- Name: zerver_preregistrationuser_groups_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_preregistrationuser_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_preregistrationuser_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


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
    emoji_name text NOT NULL,
    reaction_type character varying(30) NOT NULL,
    emoji_code text NOT NULL,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL
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
    description text NOT NULL,
    string_id character varying(40) NOT NULL,
    uuid uuid NOT NULL,
    uuid_owner_secret text NOT NULL,
    push_notifications_enabled boolean NOT NULL,
    push_notifications_enabled_end_timestamp timestamp with time zone,
    date_created timestamp with time zone NOT NULL,
    demo_organization_scheduled_deletion_date timestamp with time zone,
    deactivated boolean NOT NULL,
    deactivated_redirect character varying(128),
    emails_restricted_to_domains boolean NOT NULL,
    invite_required boolean NOT NULL,
    max_invites integer,
    disallow_disposable_email_addresses boolean NOT NULL,
    enable_spectator_access boolean NOT NULL,
    want_advertise_in_communities_directory boolean NOT NULL,
    inline_image_preview boolean NOT NULL,
    inline_url_embed_preview boolean NOT NULL,
    digest_emails_enabled boolean NOT NULL,
    digest_weekday smallint NOT NULL,
    send_welcome_emails boolean NOT NULL,
    message_content_allowed_in_email_notifications boolean NOT NULL,
    mandatory_topics boolean NOT NULL,
    require_unique_names boolean NOT NULL,
    name_changes_disabled boolean NOT NULL,
    email_changes_disabled boolean NOT NULL,
    avatar_changes_disabled boolean NOT NULL,
    move_messages_within_stream_limit_seconds integer,
    move_messages_between_streams_limit_seconds integer,
    waiting_period_threshold integer NOT NULL,
    message_content_delete_limit_seconds integer,
    allow_message_editing boolean NOT NULL,
    message_content_edit_limit_seconds integer,
    default_language character varying(50) NOT NULL,
    zulip_update_announcements_level integer,
    message_retention_days integer NOT NULL,
    message_visibility_limit integer,
    first_visible_message_id integer NOT NULL,
    org_type smallint NOT NULL,
    plan_type smallint NOT NULL,
    custom_upload_quota_gb integer,
    video_chat_provider smallint NOT NULL,
    jitsi_server_url character varying(200),
    giphy_rating smallint NOT NULL,
    default_code_block_language text NOT NULL,
    enable_read_receipts boolean NOT NULL,
    enable_guest_user_indicator boolean NOT NULL,
    icon_source character varying(1) NOT NULL,
    icon_version smallint NOT NULL,
    logo_source character varying(1) NOT NULL,
    logo_version smallint NOT NULL,
    night_logo_source character varying(1) NOT NULL,
    night_logo_version smallint NOT NULL,
    can_access_all_users_group_id bigint NOT NULL,
    can_create_private_channel_group_id bigint NOT NULL,
    can_create_public_channel_group_id bigint NOT NULL,
    can_create_web_public_channel_group_id bigint NOT NULL,
    can_delete_any_message_group_id bigint NOT NULL,
    create_multiuse_invite_group_id bigint NOT NULL,
    direct_message_initiator_group_id bigint NOT NULL,
    direct_message_permission_group_id bigint NOT NULL,
    new_stream_announcements_stream_id bigint,
    signup_announcements_stream_id bigint,
    zulip_update_announcements_stream_id bigint,
    can_delete_own_message_group_id bigint NOT NULL,
    can_create_groups_id bigint NOT NULL,
    can_manage_all_groups_id bigint NOT NULL,
    can_add_custom_emoji_group_id bigint NOT NULL,
    can_move_messages_between_channels_group_id bigint NOT NULL,
    can_move_messages_between_topics_group_id bigint NOT NULL,
    can_invite_users_group_id bigint NOT NULL,
    moderation_request_channel_id bigint,
    scheduled_deletion_date timestamp with time zone,
    can_add_subscribers_group_id bigint NOT NULL,
    can_create_bots_group_id bigint NOT NULL,
    can_create_write_only_bots_group_id bigint NOT NULL,
    enable_guest_user_dm_warning boolean NOT NULL,
    can_summarize_topics_group_id bigint NOT NULL,
    can_mention_many_users_group_id bigint NOT NULL,
    message_edit_history_visibility_policy smallint NOT NULL,
    can_manage_billing_group_id bigint NOT NULL,
    can_resolve_topics_group_id bigint NOT NULL,
    CONSTRAINT zerver_realm_giphy_rating_check CHECK ((giphy_rating >= 0)),
    CONSTRAINT zerver_realm_icon_version_check CHECK ((icon_version >= 0)),
    CONSTRAINT zerver_realm_logo_version_check CHECK ((logo_version >= 0)),
    CONSTRAINT zerver_realm_message_content_delete_limit_seconds_check CHECK ((message_content_delete_limit_seconds >= 0)),
    CONSTRAINT zerver_realm_message_content_edit_limit_seconds_check CHECK ((message_content_edit_limit_seconds >= 0)),
    CONSTRAINT zerver_realm_message_edit_history_visibility_policy_check CHECK ((message_edit_history_visibility_policy >= 0)),
    CONSTRAINT zerver_realm_move_messages_between_streams_limit_seconds_check CHECK ((move_messages_between_streams_limit_seconds >= 0)),
    CONSTRAINT zerver_realm_move_messages_within_stream_limit_seconds_check CHECK ((move_messages_within_stream_limit_seconds >= 0)),
    CONSTRAINT zerver_realm_night_logo_version_check CHECK ((night_logo_version >= 0)),
    CONSTRAINT zerver_realm_org_type_check CHECK ((org_type >= 0)),
    CONSTRAINT zerver_realm_plan_type_check CHECK ((plan_type >= 0)),
    CONSTRAINT zerver_realm_video_chat_provider_check CHECK ((video_chat_provider >= 0)),
    CONSTRAINT zerver_realm_waiting_period_threshold_check CHECK ((waiting_period_threshold >= 0)),
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
-- Name: zerver_realmauditlog; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmauditlog (
    id bigint NOT NULL,
    event_time timestamp with time zone NOT NULL,
    backfilled boolean NOT NULL,
    extra_data jsonb NOT NULL,
    event_type smallint NOT NULL,
    event_last_message_id integer,
    acting_user_id integer,
    modified_user_id integer,
    realm_id integer NOT NULL,
    modified_stream_id bigint,
    modified_user_group_id bigint,
    CONSTRAINT zerver_realmauditlog_event_type_check CHECK ((event_type >= 0))
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
-- Name: zerver_realmdomain; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmdomain (
    id bigint NOT NULL,
    domain character varying(80) NOT NULL,
    allow_subdomains boolean NOT NULL,
    realm_id integer NOT NULL
);


ALTER TABLE zulip.zerver_realmdomain OWNER TO zulip;

--
-- Name: zerver_realmdomain_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmdomain ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmdomain_id_seq
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
    file_name text,
    is_animated boolean NOT NULL,
    deactivated boolean NOT NULL,
    author_id integer,
    realm_id integer NOT NULL
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
-- Name: zerver_realmexport; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_realmexport (
    id bigint NOT NULL,
    type smallint NOT NULL,
    status smallint NOT NULL,
    date_requested timestamp with time zone NOT NULL,
    date_started timestamp with time zone,
    date_succeeded timestamp with time zone,
    date_failed timestamp with time zone,
    date_deleted timestamp with time zone,
    export_path text,
    sha256sum_hex character varying(64),
    tarball_size_bytes bigint,
    stats jsonb,
    acting_user_id integer,
    realm_id integer NOT NULL,
    CONSTRAINT zerver_realmexport_status_check CHECK ((status >= 0)),
    CONSTRAINT zerver_realmexport_tarball_size_bytes_check CHECK ((tarball_size_bytes >= 0)),
    CONSTRAINT zerver_realmexport_type_check CHECK ((type >= 0))
);


ALTER TABLE zulip.zerver_realmexport OWNER TO zulip;

--
-- Name: zerver_realmexport_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_realmexport ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_realmexport_id_seq
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
    url_template text NOT NULL,
    "order" integer NOT NULL,
    realm_id integer NOT NULL
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
    url_template text NOT NULL,
    name text NOT NULL,
    pygments_language character varying(40) NOT NULL,
    realm_id integer NOT NULL
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
    web_escape_navigates_to_home_view boolean NOT NULL,
    fluid_layout_width boolean NOT NULL,
    high_contrast_mode boolean NOT NULL,
    translate_emoticons boolean NOT NULL,
    display_emoji_reaction_users boolean NOT NULL,
    twenty_four_hour_time boolean NOT NULL,
    starred_message_counts boolean NOT NULL,
    color_scheme smallint NOT NULL,
    web_font_size_px smallint NOT NULL,
    web_line_height_percent smallint NOT NULL,
    web_animate_image_previews text NOT NULL,
    demote_inactive_streams smallint NOT NULL,
    web_mark_read_on_scroll_policy smallint NOT NULL,
    web_channel_default_view smallint DEFAULT 1 NOT NULL,
    emojiset character varying(20) NOT NULL,
    user_list_style smallint NOT NULL,
    web_stream_unreads_count_display_policy smallint NOT NULL,
    web_navigate_to_sent_message boolean NOT NULL,
    email_notifications_batching_period_seconds integer NOT NULL,
    enable_stream_desktop_notifications boolean NOT NULL,
    enable_stream_email_notifications boolean NOT NULL,
    enable_stream_push_notifications boolean NOT NULL,
    enable_stream_audible_notifications boolean NOT NULL,
    notification_sound character varying(20) NOT NULL,
    wildcard_mentions_notify boolean NOT NULL,
    enable_followed_topic_desktop_notifications boolean NOT NULL,
    enable_followed_topic_email_notifications boolean NOT NULL,
    enable_followed_topic_push_notifications boolean NOT NULL,
    enable_followed_topic_audible_notifications boolean NOT NULL,
    enable_followed_topic_wildcard_mentions_notify boolean NOT NULL,
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
    realm_name_in_email_notifications_policy smallint NOT NULL,
    automatically_follow_topics_policy smallint NOT NULL,
    automatically_unmute_topics_in_muted_streams_policy smallint NOT NULL,
    automatically_follow_topics_where_mentioned boolean NOT NULL,
    enable_drafts_synchronization boolean NOT NULL,
    send_stream_typing_notifications boolean NOT NULL,
    send_private_typing_notifications boolean NOT NULL,
    send_read_receipts boolean NOT NULL,
    receives_typing_notifications boolean NOT NULL,
    email_address_visibility smallint NOT NULL,
    realm_id integer NOT NULL,
    allow_private_data_export boolean NOT NULL,
    web_suggest_update_timezone boolean NOT NULL,
    hide_ai_features boolean NOT NULL,
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
-- Name: zerver_savedsnippet; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_savedsnippet (
    id bigint NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    date_created timestamp with time zone NOT NULL,
    realm_id integer NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_savedsnippet OWNER TO zulip;

--
-- Name: zerver_savedsnippet_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_savedsnippet ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_savedsnippet_id_seq
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
    rendered_content text NOT NULL,
    scheduled_timestamp timestamp with time zone NOT NULL,
    read_by_sender boolean NOT NULL,
    delivered boolean NOT NULL,
    has_attachment boolean NOT NULL,
    failed boolean NOT NULL,
    failure_message text,
    delivery_type smallint NOT NULL,
    delivered_message_id integer,
    realm_id integer NOT NULL,
    recipient_id integer NOT NULL,
    sender_id integer NOT NULL,
    sending_client_id integer NOT NULL,
    stream_id bigint,
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
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL,
    mentioned_user_group_id bigint
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
    date_created timestamp with time zone NOT NULL,
    deactivated boolean NOT NULL,
    description character varying(1024) NOT NULL,
    rendered_description text NOT NULL,
    invite_only boolean NOT NULL,
    history_public_to_subscribers boolean NOT NULL,
    is_web_public boolean NOT NULL,
    is_in_zephyr_realm boolean NOT NULL,
    message_retention_days integer,
    first_message_id integer,
    can_remove_subscribers_group_id bigint NOT NULL,
    creator_id integer,
    realm_id integer NOT NULL,
    recipient_id integer,
    is_recently_active boolean DEFAULT true NOT NULL,
    can_administer_channel_group_id bigint NOT NULL,
    can_send_message_group_id bigint NOT NULL,
    can_add_subscribers_group_id bigint NOT NULL,
    can_subscribe_group_id bigint NOT NULL
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
    is_user_active boolean NOT NULL,
    is_muted boolean NOT NULL,
    color character varying(10) NOT NULL,
    pin_to_top boolean NOT NULL,
    desktop_notifications boolean,
    audible_notifications boolean,
    push_notifications boolean,
    email_notifications boolean,
    wildcard_mentions_notify boolean,
    recipient_id integer NOT NULL,
    user_profile_id integer NOT NULL
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
    id bigint NOT NULL,
    flags bigint NOT NULL,
    message_id integer NOT NULL,
    user_profile_id integer NOT NULL
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
    last_update_id bigint NOT NULL,
    last_connected_time timestamp with time zone,
    last_active_time timestamp with time zone,
    realm_id integer NOT NULL,
    user_profile_id integer NOT NULL,
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
    enter_sends boolean NOT NULL,
    left_side_userlist boolean NOT NULL,
    default_language character varying(50) NOT NULL,
    web_home_view text NOT NULL,
    web_escape_navigates_to_home_view boolean NOT NULL,
    fluid_layout_width boolean NOT NULL,
    high_contrast_mode boolean NOT NULL,
    translate_emoticons boolean NOT NULL,
    display_emoji_reaction_users boolean NOT NULL,
    twenty_four_hour_time boolean NOT NULL,
    starred_message_counts boolean NOT NULL,
    color_scheme smallint NOT NULL,
    web_font_size_px smallint NOT NULL,
    web_line_height_percent smallint NOT NULL,
    web_animate_image_previews text NOT NULL,
    demote_inactive_streams smallint NOT NULL,
    web_mark_read_on_scroll_policy smallint NOT NULL,
    web_channel_default_view smallint DEFAULT 1 NOT NULL,
    emojiset character varying(20) NOT NULL,
    user_list_style smallint NOT NULL,
    web_stream_unreads_count_display_policy smallint NOT NULL,
    web_navigate_to_sent_message boolean NOT NULL,
    email_notifications_batching_period_seconds integer NOT NULL,
    enable_stream_desktop_notifications boolean NOT NULL,
    enable_stream_email_notifications boolean NOT NULL,
    enable_stream_push_notifications boolean NOT NULL,
    enable_stream_audible_notifications boolean NOT NULL,
    notification_sound character varying(20) NOT NULL,
    wildcard_mentions_notify boolean NOT NULL,
    enable_followed_topic_desktop_notifications boolean NOT NULL,
    enable_followed_topic_email_notifications boolean NOT NULL,
    enable_followed_topic_push_notifications boolean NOT NULL,
    enable_followed_topic_audible_notifications boolean NOT NULL,
    enable_followed_topic_wildcard_mentions_notify boolean NOT NULL,
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
    realm_name_in_email_notifications_policy smallint NOT NULL,
    automatically_follow_topics_policy smallint NOT NULL,
    automatically_unmute_topics_in_muted_streams_policy smallint NOT NULL,
    automatically_follow_topics_where_mentioned boolean NOT NULL,
    enable_drafts_synchronization boolean NOT NULL,
    send_stream_typing_notifications boolean NOT NULL,
    send_private_typing_notifications boolean NOT NULL,
    send_read_receipts boolean NOT NULL,
    receives_typing_notifications boolean NOT NULL,
    email_address_visibility smallint NOT NULL,
    delivery_email character varying(254) NOT NULL,
    email character varying(254) NOT NULL,
    full_name character varying(100) NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    tos_version character varying(10),
    api_key character varying(32) NOT NULL,
    uuid uuid NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    is_bot boolean NOT NULL,
    bot_type smallint,
    role smallint NOT NULL,
    long_term_idle boolean NOT NULL,
    last_active_message_id integer,
    is_mirror_dummy boolean NOT NULL,
    can_forge_sender boolean NOT NULL,
    can_create_users boolean NOT NULL,
    last_reminder timestamp with time zone,
    rate_limits character varying(100) NOT NULL,
    default_all_public_streams boolean NOT NULL,
    timezone character varying(40) NOT NULL,
    avatar_source character varying(1) NOT NULL,
    avatar_version smallint NOT NULL,
    avatar_hash character varying(64),
    zoom_token jsonb,
    bot_owner_id integer,
    realm_id integer NOT NULL,
    recipient_id integer,
    default_events_register_stream_id bigint,
    default_sending_stream_id bigint,
    allow_private_data_export boolean NOT NULL,
    can_change_user_emails boolean NOT NULL,
    web_suggest_update_timezone boolean NOT NULL,
    hide_ai_features boolean NOT NULL,
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
    reaction_type character varying(30) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    emoji_name text NOT NULL,
    emoji_code text NOT NULL,
    status_text character varying(255) NOT NULL,
    client_id integer NOT NULL,
    user_profile_id integer NOT NULL
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
-- Name: zerver_usertopic; Type: TABLE; Schema: zulip; Owner: zulip
--

CREATE TABLE zulip.zerver_usertopic (
    id bigint NOT NULL,
    topic_name character varying(60) NOT NULL,
    last_updated timestamp with time zone NOT NULL,
    visibility_policy smallint NOT NULL,
    recipient_id integer NOT NULL,
    stream_id bigint NOT NULL,
    user_profile_id integer NOT NULL
);


ALTER TABLE zulip.zerver_usertopic OWNER TO zulip;

--
-- Name: zerver_usertopic_id_seq; Type: SEQUENCE; Schema: zulip; Owner: zulip
--

ALTER TABLE zulip.zerver_usertopic ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME zulip.zerver_usertopic_id_seq
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
1	2	8	messages_read::hour	2025-03-28 16:00:00+00	1	\N
2	2	8	messages_read_interactions::hour	2025-03-28 16:00:00+00	1	\N
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
17	Can add realm creation key	5	add_realmcreationkey
18	Can change realm creation key	5	change_realmcreationkey
19	Can delete realm creation key	5	delete_realmcreationkey
20	Can view realm creation key	5	view_realmcreationkey
21	Can add confirmation	6	add_confirmation
22	Can change confirmation	6	change_confirmation
23	Can delete confirmation	6	delete_confirmation
24	Can view confirmation	6	view_confirmation
25	Can add archive transaction	7	add_archivetransaction
26	Can change archive transaction	7	change_archivetransaction
27	Can delete archive transaction	7	delete_archivetransaction
28	Can view archive transaction	7	view_archivetransaction
29	Can add client	8	add_client
30	Can change client	8	change_client
31	Can delete client	8	delete_client
32	Can view client	8	view_client
33	Can add user group	9	add_usergroup
34	Can change user group	9	change_usergroup
35	Can delete user group	9	delete_usergroup
36	Can view user group	9	view_usergroup
37	Can add realm	10	add_realm
38	Can change realm	10	change_realm
39	Can delete realm	10	delete_realm
40	Can view realm	10	view_realm
41	Can add user profile	11	add_userprofile
42	Can change user profile	11	change_userprofile
43	Can delete user profile	11	delete_userprofile
44	Can view user profile	11	view_userprofile
45	Can add archived message	12	add_archivedmessage
46	Can change archived message	12	change_archivedmessage
47	Can delete archived message	12	delete_archivedmessage
48	Can view archived message	12	view_archivedmessage
49	Can add archived sub message	13	add_archivedsubmessage
50	Can change archived sub message	13	change_archivedsubmessage
51	Can delete archived sub message	13	delete_archivedsubmessage
52	Can view archived sub message	13	view_archivedsubmessage
53	Can add message	14	add_message
54	Can change message	14	change_message
55	Can delete message	14	delete_message
56	Can view message	14	view_message
57	Can add missed message email address	15	add_missedmessageemailaddress
58	Can change missed message email address	15	change_missedmessageemailaddress
59	Can delete missed message email address	15	delete_missedmessageemailaddress
60	Can view missed message email address	15	view_missedmessageemailaddress
61	Can add named user group	16	add_namedusergroup
62	Can change named user group	16	change_namedusergroup
63	Can delete named user group	16	delete_namedusergroup
64	Can view named user group	16	view_namedusergroup
65	Can add group group membership	17	add_groupgroupmembership
66	Can change group group membership	17	change_groupgroupmembership
67	Can delete group group membership	17	delete_groupgroupmembership
68	Can view group group membership	17	view_groupgroupmembership
69	Can add presence sequence	18	add_presencesequence
70	Can change presence sequence	18	change_presencesequence
71	Can delete presence sequence	18	delete_presencesequence
72	Can view presence sequence	18	view_presencesequence
73	Can add preregistration realm	19	add_preregistrationrealm
74	Can change preregistration realm	19	change_preregistrationrealm
75	Can delete preregistration realm	19	delete_preregistrationrealm
76	Can view preregistration realm	19	view_preregistrationrealm
77	Can add onboarding user message	20	add_onboardingusermessage
78	Can change onboarding user message	20	change_onboardingusermessage
79	Can delete onboarding user message	20	delete_onboardingusermessage
80	Can view onboarding user message	20	view_onboardingusermessage
81	Can add multiuse invite	21	add_multiuseinvite
82	Can change multiuse invite	21	change_multiuseinvite
83	Can delete multiuse invite	21	delete_multiuseinvite
84	Can view multiuse invite	21	view_multiuseinvite
85	Can add image attachment	22	add_imageattachment
86	Can change image attachment	22	change_imageattachment
87	Can delete image attachment	22	delete_imageattachment
88	Can view image attachment	22	view_imageattachment
89	Can add email change status	23	add_emailchangestatus
90	Can change email change status	23	change_emailchangestatus
91	Can delete email change status	23	delete_emailchangestatus
92	Can view email change status	23	view_emailchangestatus
93	Can add custom profile field	24	add_customprofilefield
94	Can change custom profile field	24	change_customprofilefield
95	Can delete custom profile field	24	delete_customprofilefield
96	Can view custom profile field	24	view_customprofilefield
97	Can add archived attachment	25	add_archivedattachment
98	Can change archived attachment	25	change_archivedattachment
99	Can delete archived attachment	25	delete_archivedattachment
100	Can view archived attachment	25	view_archivedattachment
101	Can add realm reactivation status	26	add_realmreactivationstatus
102	Can change realm reactivation status	26	change_realmreactivationstatus
103	Can delete realm reactivation status	26	delete_realmreactivationstatus
104	Can view realm reactivation status	26	view_realmreactivationstatus
105	Can add realm user default	27	add_realmuserdefault
106	Can change realm user default	27	change_realmuserdefault
107	Can delete realm user default	27	delete_realmuserdefault
108	Can view realm user default	27	view_realmuserdefault
109	Can add recipient	28	add_recipient
110	Can change recipient	28	change_recipient
111	Can delete recipient	28	delete_recipient
112	Can view recipient	28	view_recipient
113	Can add draft	29	add_draft
114	Can change draft	29	change_draft
115	Can delete draft	29	delete_draft
116	Can view draft	29	view_draft
117	Can add direct message group	30	add_directmessagegroup
118	Can change direct message group	30	change_directmessagegroup
119	Can delete direct message group	30	delete_directmessagegroup
120	Can view direct message group	30	view_directmessagegroup
121	Can add scheduled email	31	add_scheduledemail
122	Can change scheduled email	31	change_scheduledemail
123	Can delete scheduled email	31	delete_scheduledemail
124	Can view scheduled email	31	view_scheduledemail
125	Can add scheduled message	32	add_scheduledmessage
126	Can change scheduled message	32	change_scheduledmessage
127	Can delete scheduled message	32	delete_scheduledmessage
128	Can view scheduled message	32	view_scheduledmessage
129	Can add attachment	33	add_attachment
130	Can change attachment	33	change_attachment
131	Can delete attachment	33	delete_attachment
132	Can view attachment	33	view_attachment
133	Can add service	34	add_service
134	Can change service	34	change_service
135	Can delete service	34	delete_service
136	Can view service	34	view_service
137	Can add stream	35	add_stream
138	Can change stream	35	change_stream
139	Can delete stream	35	delete_stream
140	Can view stream	35	view_stream
141	Can add preregistration user	36	add_preregistrationuser
142	Can change preregistration user	36	change_preregistrationuser
143	Can delete preregistration user	36	delete_preregistrationuser
144	Can view preregistration user	36	view_preregistrationuser
145	Can add default stream group	37	add_defaultstreamgroup
146	Can change default stream group	37	change_defaultstreamgroup
147	Can delete default stream group	37	delete_defaultstreamgroup
148	Can view default stream group	37	view_defaultstreamgroup
149	Can add default stream	38	add_defaultstream
150	Can change default stream	38	change_defaultstream
151	Can delete default stream	38	delete_defaultstream
152	Can view default stream	38	view_defaultstream
153	Can add sub message	39	add_submessage
154	Can change sub message	39	change_submessage
155	Can delete sub message	39	delete_submessage
156	Can view sub message	39	view_submessage
157	Can add subscription	40	add_subscription
158	Can change subscription	40	change_subscription
159	Can delete subscription	40	delete_subscription
160	Can view subscription	40	view_subscription
161	Can add user activity	41	add_useractivity
162	Can change user activity	41	change_useractivity
163	Can delete user activity	41	delete_useractivity
164	Can view user activity	41	view_useractivity
165	Can add user activity interval	42	add_useractivityinterval
166	Can change user activity interval	42	change_useractivityinterval
167	Can delete user activity interval	42	delete_useractivityinterval
168	Can view user activity interval	42	view_useractivityinterval
169	Can add user group membership	43	add_usergroupmembership
170	Can change user group membership	43	change_usergroupmembership
171	Can delete user group membership	43	delete_usergroupmembership
172	Can view user group membership	43	view_usergroupmembership
173	Can add user message	44	add_usermessage
174	Can change user message	44	change_usermessage
175	Can delete user message	44	delete_usermessage
176	Can view user message	44	view_usermessage
177	Can add user presence	45	add_userpresence
178	Can change user presence	45	change_userpresence
179	Can delete user presence	45	delete_userpresence
180	Can view user presence	45	view_userpresence
181	Can add user status	46	add_userstatus
182	Can change user status	46	change_userstatus
183	Can delete user status	46	delete_userstatus
184	Can view user status	46	view_userstatus
185	Can add user topic	47	add_usertopic
186	Can change user topic	47	change_usertopic
187	Can delete user topic	47	delete_usertopic
188	Can view user topic	47	view_usertopic
189	Can add archived reaction	48	add_archivedreaction
190	Can change archived reaction	48	change_archivedreaction
191	Can delete archived reaction	48	delete_archivedreaction
192	Can view archived reaction	48	view_archivedreaction
193	Can add archived user message	49	add_archivedusermessage
194	Can change archived user message	49	change_archivedusermessage
195	Can delete archived user message	49	delete_archivedusermessage
196	Can view archived user message	49	view_archivedusermessage
197	Can add bot config data	50	add_botconfigdata
198	Can change bot config data	50	change_botconfigdata
199	Can delete bot config data	50	delete_botconfigdata
200	Can view bot config data	50	view_botconfigdata
201	Can add bot storage data	51	add_botstoragedata
202	Can change bot storage data	51	change_botstoragedata
203	Can delete bot storage data	51	delete_botstoragedata
204	Can view bot storage data	51	view_botstoragedata
205	Can add custom profile field value	52	add_customprofilefieldvalue
206	Can change custom profile field value	52	change_customprofilefieldvalue
207	Can delete custom profile field value	52	delete_customprofilefieldvalue
208	Can view custom profile field value	52	view_customprofilefieldvalue
209	Can add muted user	53	add_muteduser
210	Can change muted user	53	change_muteduser
211	Can delete muted user	53	delete_muteduser
212	Can view muted user	53	view_muteduser
213	Can add scheduled message notification email	54	add_scheduledmessagenotificationemail
214	Can change scheduled message notification email	54	change_scheduledmessagenotificationemail
215	Can delete scheduled message notification email	54	delete_scheduledmessagenotificationemail
216	Can view scheduled message notification email	54	view_scheduledmessagenotificationemail
217	Can add realm audit log	55	add_realmauditlog
218	Can change realm audit log	55	change_realmauditlog
219	Can delete realm audit log	55	delete_realmauditlog
220	Can view realm audit log	55	view_realmauditlog
221	Can add onboarding step	56	add_onboardingstep
222	Can change onboarding step	56	change_onboardingstep
223	Can delete onboarding step	56	delete_onboardingstep
224	Can view onboarding step	56	view_onboardingstep
225	Can add push device token	57	add_pushdevicetoken
226	Can change push device token	57	change_pushdevicetoken
227	Can delete push device token	57	delete_pushdevicetoken
228	Can view push device token	57	view_pushdevicetoken
229	Can add reaction	58	add_reaction
230	Can change reaction	58	change_reaction
231	Can delete reaction	58	delete_reaction
232	Can view reaction	58	view_reaction
233	Can add alert word	59	add_alertword
234	Can change alert word	59	change_alertword
235	Can delete alert word	59	delete_alertword
236	Can view alert word	59	view_alertword
237	Can add realm authentication method	60	add_realmauthenticationmethod
238	Can change realm authentication method	60	change_realmauthenticationmethod
239	Can delete realm authentication method	60	delete_realmauthenticationmethod
240	Can view realm authentication method	60	view_realmauthenticationmethod
241	Can add realm domain	61	add_realmdomain
242	Can change realm domain	61	change_realmdomain
243	Can delete realm domain	61	delete_realmdomain
244	Can view realm domain	61	view_realmdomain
245	Can add realm emoji	62	add_realmemoji
246	Can change realm emoji	62	change_realmemoji
247	Can delete realm emoji	62	delete_realmemoji
248	Can view realm emoji	62	view_realmemoji
249	Can add realm filter	63	add_realmfilter
250	Can change realm filter	63	change_realmfilter
251	Can delete realm filter	63	delete_realmfilter
252	Can view realm filter	63	view_realmfilter
253	Can add realm playground	64	add_realmplayground
254	Can change realm playground	64	change_realmplayground
255	Can delete realm playground	64	delete_realmplayground
256	Can view realm playground	64	view_realmplayground
257	Can add saved snippet	65	add_savedsnippet
258	Can change saved snippet	65	change_savedsnippet
259	Can delete saved snippet	65	delete_savedsnippet
260	Can view saved snippet	65	view_savedsnippet
261	Can add realm export	66	add_realmexport
262	Can change realm export	66	change_realmexport
263	Can delete realm export	66	delete_realmexport
264	Can view realm export	66	view_realmexport
265	Can add channel email address	67	add_channelemailaddress
266	Can change channel email address	67	change_channelemailaddress
267	Can delete channel email address	67	delete_channelemailaddress
268	Can view channel email address	67	view_channelemailaddress
269	Can add association	68	add_association
270	Can change association	68	change_association
271	Can delete association	68	delete_association
272	Can view association	68	view_association
273	Can add code	69	add_code
274	Can change code	69	change_code
275	Can delete code	69	delete_code
276	Can view code	69	view_code
277	Can add nonce	70	add_nonce
278	Can change nonce	70	change_nonce
279	Can delete nonce	70	delete_nonce
280	Can view nonce	70	view_nonce
281	Can add user social auth	71	add_usersocialauth
282	Can change user social auth	71	change_usersocialauth
283	Can delete user social auth	71	delete_usersocialauth
284	Can view user social auth	71	view_usersocialauth
285	Can add partial	72	add_partial
286	Can change partial	72	change_partial
287	Can delete partial	72	delete_partial
288	Can view partial	72	view_partial
289	Can add static device	73	add_staticdevice
290	Can change static device	73	change_staticdevice
291	Can delete static device	73	delete_staticdevice
292	Can view static device	73	view_staticdevice
293	Can add static token	74	add_statictoken
294	Can change static token	74	change_statictoken
295	Can delete static token	74	delete_statictoken
296	Can view static token	74	view_statictoken
297	Can add TOTP device	75	add_totpdevice
298	Can change TOTP device	75	change_totpdevice
299	Can delete TOTP device	75	delete_totpdevice
300	Can view TOTP device	75	view_totpdevice
301	Can add phone device	76	add_phonedevice
302	Can change phone device	76	change_phonedevice
303	Can delete phone device	76	delete_phonedevice
304	Can view phone device	76	view_phonedevice
305	Can add installation count	77	add_installationcount
306	Can change installation count	77	change_installationcount
307	Can delete installation count	77	delete_installationcount
308	Can view installation count	77	view_installationcount
309	Can add realm count	78	add_realmcount
310	Can change realm count	78	change_realmcount
311	Can delete realm count	78	delete_realmcount
312	Can view realm count	78	view_realmcount
313	Can add stream count	79	add_streamcount
314	Can change stream count	79	change_streamcount
315	Can delete stream count	79	delete_streamcount
316	Can view stream count	79	view_streamcount
317	Can add user count	80	add_usercount
318	Can change user count	80	change_usercount
319	Can delete user count	80	delete_usercount
320	Can view user count	80	view_usercount
321	Can add fill state	81	add_fillstate
322	Can change fill state	81	change_fillstate
323	Can delete fill state	81	delete_fillstate
324	Can view fill state	81	view_fillstate
\.


--
-- Data for Name: confirmation_confirmation; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.confirmation_confirmation (id, object_id, date_sent, confirmation_key, content_type_id, type, realm_id, expiry_date) FROM stdin;
1	1	2025-03-28 15:35:15.167674+00	cczamwol2bcyjk2pycvvnv2g	19	7	\N	2025-03-29 15:35:15.167674+00
2	8	2025-03-28 15:35:56.379179+00	hb7o664zca5citjna6jk7ea7	11	4	2	4763-02-23 15:35:56.379179+00
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
5	confirmation	realmcreationkey
6	confirmation	confirmation
7	zerver	archivetransaction
8	zerver	client
9	zerver	usergroup
10	zerver	realm
11	zerver	userprofile
12	zerver	archivedmessage
13	zerver	archivedsubmessage
14	zerver	message
15	zerver	missedmessageemailaddress
16	zerver	namedusergroup
17	zerver	groupgroupmembership
18	zerver	presencesequence
19	zerver	preregistrationrealm
20	zerver	onboardingusermessage
21	zerver	multiuseinvite
22	zerver	imageattachment
23	zerver	emailchangestatus
24	zerver	customprofilefield
25	zerver	archivedattachment
26	zerver	realmreactivationstatus
27	zerver	realmuserdefault
28	zerver	recipient
29	zerver	draft
30	zerver	directmessagegroup
31	zerver	scheduledemail
32	zerver	scheduledmessage
33	zerver	attachment
34	zerver	service
35	zerver	stream
36	zerver	preregistrationuser
37	zerver	defaultstreamgroup
38	zerver	defaultstream
39	zerver	submessage
40	zerver	subscription
41	zerver	useractivity
42	zerver	useractivityinterval
43	zerver	usergroupmembership
44	zerver	usermessage
45	zerver	userpresence
46	zerver	userstatus
47	zerver	usertopic
48	zerver	archivedreaction
49	zerver	archivedusermessage
50	zerver	botconfigdata
51	zerver	botstoragedata
52	zerver	customprofilefieldvalue
53	zerver	muteduser
54	zerver	scheduledmessagenotificationemail
55	zerver	realmauditlog
56	zerver	onboardingstep
57	zerver	pushdevicetoken
58	zerver	reaction
59	zerver	alertword
60	zerver	realmauthenticationmethod
61	zerver	realmdomain
62	zerver	realmemoji
63	zerver	realmfilter
64	zerver	realmplayground
65	zerver	savedsnippet
66	zerver	realmexport
67	zerver	channelemailaddress
68	social_django	association
69	social_django	code
70	social_django	nonce
71	social_django	usersocialauth
72	social_django	partial
73	otp_static	staticdevice
74	otp_static	statictoken
75	otp_totp	totpdevice
76	phonenumber	phonedevice
77	analytics	installationcount
78	analytics	realmcount
79	analytics	streamcount
80	analytics	usercount
81	analytics	fillstate
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2025-03-28 15:34:32.597106+00
2	auth	0001_initial	2025-03-28 15:34:32.611749+00
3	zerver	0001_initial	2025-03-28 15:34:35.568107+00
4	zerver	0029_realm_subdomain	2025-03-28 15:34:35.569439+00
5	zerver	0030_realm_org_type	2025-03-28 15:34:35.569759+00
6	zerver	0031_remove_system_avatar_source	2025-03-28 15:34:35.570012+00
7	zerver	0032_verify_all_medium_avatar_images	2025-03-28 15:34:35.570246+00
8	zerver	0033_migrate_domain_to_realmalias	2025-03-28 15:34:35.570493+00
9	zerver	0034_userprofile_enable_online_push_notifications	2025-03-28 15:34:35.57074+00
10	zerver	0035_realm_message_retention_period_days	2025-03-28 15:34:35.570957+00
11	zerver	0036_rename_subdomain_to_string_id	2025-03-28 15:34:35.571191+00
12	zerver	0037_disallow_null_string_id	2025-03-28 15:34:35.571405+00
13	zerver	0038_realm_change_to_community_defaults	2025-03-28 15:34:35.571647+00
14	zerver	0039_realmalias_drop_uniqueness	2025-03-28 15:34:35.571885+00
15	zerver	0040_realm_authentication_methods	2025-03-28 15:34:35.572184+00
16	zerver	0041_create_attachments_for_old_messages	2025-03-28 15:34:35.572405+00
17	zerver	0042_attachment_file_name_length	2025-03-28 15:34:35.572629+00
18	zerver	0043_realm_filter_validators	2025-03-28 15:34:35.572843+00
19	zerver	0044_reaction	2025-03-28 15:34:35.573117+00
20	zerver	0045_realm_waiting_period_threshold	2025-03-28 15:34:35.57347+00
21	zerver	0046_realmemoji_author	2025-03-28 15:34:35.573753+00
22	zerver	0047_realm_add_emoji_by_admins_only	2025-03-28 15:34:35.574012+00
23	zerver	0048_enter_sends_default_to_false	2025-03-28 15:34:35.574244+00
24	zerver	0049_userprofile_pm_content_in_desktop_notifications	2025-03-28 15:34:35.574479+00
25	zerver	0050_userprofile_avatar_version	2025-03-28 15:34:35.574714+00
26	zerver	0051_realmalias_add_allow_subdomains	2025-03-28 15:34:35.574936+00
27	zerver	0052_auto_fix_realmalias_realm_nullable	2025-03-28 15:34:35.575159+00
28	zerver	0053_emailchangestatus	2025-03-28 15:34:35.575376+00
29	zerver	0054_realm_icon	2025-03-28 15:34:35.57564+00
30	zerver	0055_attachment_size	2025-03-28 15:34:35.57591+00
31	zerver	0056_userprofile_emoji_alt_code	2025-03-28 15:34:35.576196+00
32	zerver	0057_realmauditlog	2025-03-28 15:34:35.576408+00
33	zerver	0058_realm_email_changes_disabled	2025-03-28 15:34:35.576644+00
34	zerver	0059_userprofile_quota	2025-03-28 15:34:35.576876+00
35	zerver	0060_move_avatars_to_be_uid_based	2025-03-28 15:34:35.577121+00
36	zerver	0061_userprofile_timezone	2025-03-28 15:34:35.577332+00
37	zerver	0062_default_timezone	2025-03-28 15:34:35.577538+00
38	zerver	0063_realm_description	2025-03-28 15:34:35.577738+00
39	zerver	0064_sync_uploads_filesize_with_db	2025-03-28 15:34:35.57793+00
40	zerver	0065_realm_inline_image_preview	2025-03-28 15:34:35.578131+00
41	zerver	0066_realm_inline_url_embed_preview	2025-03-28 15:34:35.578318+00
42	zerver	0067_archived_models	2025-03-28 15:34:35.578504+00
43	zerver	0068_remove_realm_domain	2025-03-28 15:34:35.578691+00
44	zerver	0069_realmauditlog_extra_data	2025-03-28 15:34:35.578907+00
45	zerver	0070_userhotspot	2025-03-28 15:34:35.579163+00
46	zerver	0071_rename_realmalias_to_realmdomain	2025-03-28 15:34:35.579369+00
47	zerver	0072_realmauditlog_add_index_event_time	2025-03-28 15:34:35.579594+00
48	zerver	0073_custom_profile_fields	2025-03-28 15:34:35.579814+00
49	zerver	0074_fix_duplicate_attachments	2025-03-28 15:34:35.580027+00
50	zerver	0075_attachment_path_id_unique	2025-03-28 15:34:35.580262+00
51	zerver	0076_userprofile_emojiset	2025-03-28 15:34:35.580493+00
52	zerver	0077_add_file_name_field_to_realm_emoji	2025-03-28 15:34:35.580698+00
53	zerver	0078_service	2025-03-28 15:34:35.580907+00
54	zerver	0079_remove_old_scheduled_jobs	2025-03-28 15:34:35.581153+00
55	zerver	0080_realm_description_length	2025-03-28 15:34:35.581367+00
56	zerver	0081_make_emoji_lowercase	2025-03-28 15:34:35.581606+00
57	zerver	0082_index_starred_user_messages	2025-03-28 15:34:35.581826+00
58	zerver	0083_index_mentioned_user_messages	2025-03-28 15:34:35.582031+00
59	zerver	0084_realmemoji_deactivated	2025-03-28 15:34:35.582235+00
60	zerver	0085_fix_bots_with_none_bot_type	2025-03-28 15:34:35.582426+00
61	zerver	0086_realm_alter_default_org_type	2025-03-28 15:34:35.582614+00
62	zerver	0087_remove_old_scheduled_jobs	2025-03-28 15:34:35.582802+00
63	zerver	0088_remove_referral_and_invites	2025-03-28 15:34:35.582996+00
64	zerver	0089_auto_20170710_1353	2025-03-28 15:34:35.583216+00
65	zerver	0090_userprofile_high_contrast_mode	2025-03-28 15:34:35.583468+00
66	zerver	0091_realm_allow_edit_history	2025-03-28 15:34:35.583736+00
67	zerver	0092_create_scheduledemail	2025-03-28 15:34:35.584005+00
68	zerver	0093_subscription_event_log_backfill	2025-03-28 15:34:35.584245+00
69	zerver	0094_realm_filter_url_validator	2025-03-28 15:34:35.584455+00
70	zerver	0095_index_unread_user_messages	2025-03-28 15:34:35.584657+00
71	zerver	0096_add_password_required	2025-03-28 15:34:35.584872+00
72	zerver	0097_reactions_emoji_code	2025-03-28 15:34:35.585093+00
73	zerver	0098_index_has_alert_word_user_messages	2025-03-28 15:34:35.585325+00
74	zerver	0099_index_wildcard_mentioned_user_messages	2025-03-28 15:34:35.585538+00
75	zerver	0100_usermessage_remove_is_me_message	2025-03-28 15:34:35.585759+00
76	zerver	0101_muted_topic	2025-03-28 15:34:35.585988+00
77	zerver	0102_convert_muted_topic	2025-03-28 15:34:35.586224+00
78	zerver	0103_remove_userprofile_muted_topics	2025-03-28 15:34:35.586461+00
79	zerver	0104_fix_unreads	2025-03-28 15:34:35.586697+00
80	zerver	0105_userprofile_enable_stream_push_notifications	2025-03-28 15:34:35.586933+00
81	zerver	0106_subscription_push_notifications	2025-03-28 15:34:35.587187+00
82	zerver	0107_multiuseinvite	2025-03-28 15:34:35.58742+00
83	zerver	0108_fix_default_string_id	2025-03-28 15:34:35.587626+00
84	zerver	0109_mark_tutorial_status_finished	2025-03-28 15:34:35.587843+00
85	zerver	0110_stream_is_in_zephyr_realm	2025-03-28 15:34:35.588091+00
86	zerver	0111_botuserstatedata	2025-03-28 15:34:35.588312+00
87	zerver	0112_index_muted_topics	2025-03-28 15:34:35.58852+00
88	zerver	0113_default_stream_group	2025-03-28 15:34:35.588713+00
89	zerver	0114_preregistrationuser_invited_as_admin	2025-03-28 15:34:35.588901+00
90	zerver	0115_user_groups	2025-03-28 15:34:35.589247+00
91	zerver	0116_realm_allow_message_deleting	2025-03-28 15:34:35.589474+00
92	zerver	0117_add_desc_to_user_group	2025-03-28 15:34:35.589675+00
93	zerver	0118_defaultstreamgroup_description	2025-03-28 15:34:35.58988+00
94	zerver	0119_userprofile_night_mode	2025-03-28 15:34:35.590103+00
95	zerver	0120_botuserconfigdata	2025-03-28 15:34:35.590306+00
96	zerver	0121_realm_signup_notifications_stream	2025-03-28 15:34:35.590528+00
97	zerver	0122_rename_botuserstatedata_botstoragedata	2025-03-28 15:34:35.590848+00
98	zerver	0123_userprofile_make_realm_email_pair_unique	2025-03-28 15:34:35.591186+00
99	zerver	0124_stream_enable_notifications	2025-03-28 15:34:35.59144+00
100	zerver	0125_realm_max_invites	2025-03-28 15:34:35.591656+00
101	zerver	0126_prereg_remove_users_without_realm	2025-03-28 15:34:35.591895+00
102	zerver	0127_disallow_chars_in_stream_and_user_name	2025-03-28 15:34:35.592115+00
103	zerver	0128_scheduledemail_realm	2025-03-28 15:34:35.592321+00
104	zerver	0129_remove_userprofile_autoscroll_forever	2025-03-28 15:34:35.592527+00
105	zerver	0130_text_choice_in_emojiset	2025-03-28 15:34:35.592717+00
106	zerver	0131_realm_create_generic_bot_by_admins_only	2025-03-28 15:34:35.592906+00
107	zerver	0132_realm_message_visibility_limit	2025-03-28 15:34:35.593106+00
108	zerver	0133_rename_botuserconfigdata_botconfigdata	2025-03-28 15:34:35.593298+00
109	zerver	0134_scheduledmessage	2025-03-28 15:34:35.593488+00
110	zerver	0135_scheduledmessage_delivery_type	2025-03-28 15:34:35.593675+00
111	zerver	0136_remove_userprofile_quota	2025-03-28 15:34:35.594138+00
112	zerver	0137_realm_upload_quota_gb	2025-03-28 15:34:35.594417+00
113	zerver	0138_userprofile_realm_name_in_notifications	2025-03-28 15:34:35.594649+00
114	zerver	0139_fill_last_message_id_in_subscription_logs	2025-03-28 15:34:35.594882+00
115	zerver	0140_realm_send_welcome_emails	2025-03-28 15:34:35.595179+00
116	zerver	0141_change_usergroup_description_to_textfield	2025-03-28 15:34:35.595459+00
117	zerver	0142_userprofile_translate_emoticons	2025-03-28 15:34:35.595718+00
118	zerver	0143_realm_bot_creation_policy	2025-03-28 15:34:35.596022+00
119	zerver	0144_remove_realm_create_generic_bot_by_admins_only	2025-03-28 15:34:35.596374+00
120	zerver	0145_reactions_realm_emoji_name_to_id	2025-03-28 15:34:35.59662+00
121	zerver	0146_userprofile_message_content_in_email_notifications	2025-03-28 15:34:35.596842+00
122	zerver	0147_realm_disallow_disposable_email_addresses	2025-03-28 15:34:35.597066+00
123	zerver	0148_max_invites_forget_default	2025-03-28 15:34:35.597313+00
124	zerver	0149_realm_emoji_drop_unique_constraint	2025-03-28 15:34:35.597543+00
125	zerver	0150_realm_allow_community_topic_editing	2025-03-28 15:34:35.597742+00
126	zerver	0151_last_reminder_default_none	2025-03-28 15:34:35.597937+00
127	zerver	0152_realm_default_twenty_four_hour_time	2025-03-28 15:34:35.598221+00
128	zerver	0153_remove_int_float_custom_fields	2025-03-28 15:34:35.598437+00
129	zerver	0154_fix_invalid_bot_owner	2025-03-28 15:34:35.598685+00
130	zerver	0155_change_default_realm_description	2025-03-28 15:34:35.598949+00
131	zerver	0156_add_hint_to_profile_field	2025-03-28 15:34:35.5992+00
132	zerver	0157_userprofile_is_guest	2025-03-28 15:34:35.599441+00
133	zerver	0158_realm_video_chat_provider	2025-03-28 15:34:35.599704+00
134	zerver	0159_realm_google_hangouts_domain	2025-03-28 15:34:35.599934+00
135	zerver	0160_add_choice_field	2025-03-28 15:34:35.600174+00
136	zerver	0161_realm_message_content_delete_limit_seconds	2025-03-28 15:34:35.600411+00
137	zerver	0162_change_default_community_topic_editing	2025-03-28 15:34:35.600638+00
138	zerver	0163_remove_userprofile_default_desktop_notifications	2025-03-28 15:34:35.600866+00
139	zerver	0164_stream_history_public_to_subscribers	2025-03-28 15:34:35.601115+00
140	zerver	0165_add_date_to_profile_field	2025-03-28 15:34:35.601366+00
141	zerver	0166_add_url_to_profile_field	2025-03-28 15:34:35.6016+00
142	zerver	0167_custom_profile_fields_sort_order	2025-03-28 15:34:35.601842+00
143	zerver	0168_stream_is_web_public	2025-03-28 15:34:35.602094+00
144	zerver	0169_stream_is_announcement_only	2025-03-28 15:34:35.602328+00
145	zerver	0170_submessage	2025-03-28 15:34:35.602586+00
146	zerver	0171_userprofile_dense_mode	2025-03-28 15:34:35.602953+00
147	zerver	0172_add_user_type_of_custom_profile_field	2025-03-28 15:34:35.603232+00
148	zerver	0173_support_seat_based_plans	2025-03-28 15:34:35.603443+00
149	zerver	0174_userprofile_delivery_email	2025-03-28 15:34:35.603789+00
150	zerver	0175_change_realm_audit_log_event_type_tense	2025-03-28 15:34:35.604126+00
151	zerver	0176_remove_subscription_notifications	2025-03-28 15:34:35.604369+00
152	zerver	0177_user_message_add_and_index_is_private_flag	2025-03-28 15:34:35.604593+00
153	zerver	0178_rename_to_emails_restricted_to_domains	2025-03-28 15:34:35.604819+00
154	zerver	0179_rename_to_digest_emails_enabled	2025-03-28 15:34:35.605063+00
155	zerver	0180_usermessage_add_active_mobile_push_notification	2025-03-28 15:34:35.605316+00
156	zerver	0181_userprofile_change_emojiset	2025-03-28 15:34:35.605778+00
157	zerver	0182_set_initial_value_is_private_flag	2025-03-28 15:34:35.606133+00
158	zerver	0183_change_custom_field_name_max_length	2025-03-28 15:34:35.60637+00
159	zerver	0184_rename_custom_field_types	2025-03-28 15:34:35.606598+00
160	zerver	0185_realm_plan_type	2025-03-28 15:34:35.60681+00
161	zerver	0186_userprofile_starred_message_counts	2025-03-28 15:34:35.607047+00
162	zerver	0187_userprofile_is_billing_admin	2025-03-28 15:34:35.60729+00
163	zerver	0188_userprofile_enable_login_emails	2025-03-28 15:34:35.607507+00
164	zerver	0189_userprofile_add_some_emojisets	2025-03-28 15:34:35.607725+00
165	zerver	0190_cleanup_pushdevicetoken	2025-03-28 15:34:35.607936+00
166	zerver	0191_realm_seat_limit	2025-03-28 15:34:35.608168+00
167	zerver	0192_customprofilefieldvalue_rendered_value	2025-03-28 15:34:35.608389+00
168	zerver	0193_realm_email_address_visibility	2025-03-28 15:34:35.608751+00
169	zerver	0194_userprofile_notification_sound	2025-03-28 15:34:35.609064+00
170	zerver	0195_realm_first_visible_message_id	2025-03-28 15:34:35.609345+00
171	zerver	0196_add_realm_logo_fields	2025-03-28 15:34:35.609574+00
172	zerver	0197_azure_active_directory_auth	2025-03-28 15:34:35.609833+00
173	zerver	0198_preregistrationuser_invited_as	2025-03-28 15:34:35.610122+00
174	zerver	0199_userstatus	2025-03-28 15:34:35.610364+00
175	zerver	0200_remove_preregistrationuser_invited_as_admin	2025-03-28 15:34:35.610576+00
176	zerver	0201_zoom_video_chat	2025-03-28 15:34:35.610783+00
177	zerver	0202_add_user_status_info	2025-03-28 15:34:35.611003+00
178	zerver	0203_realm_message_content_allowed_in_email_notifications	2025-03-28 15:34:35.611209+00
179	zerver	0204_remove_realm_billing_fields	2025-03-28 15:34:35.611413+00
180	zerver	0205_remove_realmauditlog_requires_billing_update	2025-03-28 15:34:35.61161+00
181	zerver	0206_stream_rendered_description	2025-03-28 15:34:35.611806+00
182	zerver	0207_multiuseinvite_invited_as	2025-03-28 15:34:35.612016+00
183	zerver	0208_add_realm_night_logo_fields	2025-03-28 15:34:35.612226+00
184	zerver	0209_stream_first_message_id	2025-03-28 15:34:35.612426+00
185	zerver	0210_stream_first_message_id	2025-03-28 15:34:35.612625+00
186	zerver	0211_add_users_field_to_scheduled_email	2025-03-28 15:34:35.612831+00
187	zerver	0212_make_stream_email_token_unique	2025-03-28 15:34:35.613072+00
188	zerver	0213_realm_digest_weekday	2025-03-28 15:34:35.613328+00
189	zerver	0214_realm_invite_to_stream_policy	2025-03-28 15:34:35.613551+00
190	zerver	0215_realm_avatar_changes_disabled	2025-03-28 15:34:35.613772+00
191	zerver	0216_add_create_stream_policy	2025-03-28 15:34:35.613996+00
192	zerver	0217_migrate_create_stream_policy	2025-03-28 15:34:35.61426+00
193	zerver	0218_remove_create_stream_by_admins_only	2025-03-28 15:34:35.61453+00
194	zerver	0219_toggle_realm_digest_emails_enabled_default	2025-03-28 15:34:35.614757+00
195	zerver	0220_subscription_notification_settings	2025-03-28 15:34:35.614977+00
196	zerver	0221_subscription_notifications_data_migration	2025-03-28 15:34:35.61519+00
197	zerver	0222_userprofile_fluid_layout_width	2025-03-28 15:34:35.615394+00
198	zerver	0223_rename_to_is_muted	2025-03-28 15:34:35.615595+00
199	zerver	0224_alter_field_realm_video_chat_provider	2025-03-28 15:34:35.615798+00
200	zerver	0225_archived_reaction_model	2025-03-28 15:34:35.616+00
201	zerver	0226_archived_submessage_model	2025-03-28 15:34:35.616203+00
202	zerver	0227_inline_url_embed_preview_default_off	2025-03-28 15:34:35.61648+00
203	zerver	0228_userprofile_demote_inactive_streams	2025-03-28 15:34:35.616863+00
204	zerver	0229_stream_message_retention_days	2025-03-28 15:34:35.617177+00
205	zerver	0230_rename_to_enable_stream_audible_notifications	2025-03-28 15:34:35.617435+00
206	zerver	0231_add_archive_transaction_model	2025-03-28 15:34:35.61782+00
207	zerver	0232_make_archive_transaction_field_not_nullable	2025-03-28 15:34:35.618144+00
208	zerver	0233_userprofile_avatar_hash	2025-03-28 15:34:35.618382+00
209	zerver	0234_add_external_account_custom_profile_field	2025-03-28 15:34:35.6186+00
210	zerver	0235_userprofile_desktop_icon_count_display	2025-03-28 15:34:35.61884+00
211	zerver	0236_remove_illegal_characters_email_full	2025-03-28 15:34:35.619224+00
212	zerver	0237_rename_zulip_realm_to_zulipinternal	2025-03-28 15:34:35.61964+00
213	zerver	0238_usermessage_bigint_id	2025-03-28 15:34:35.620029+00
214	zerver	0239_usermessage_copy_id_to_bigint_id	2025-03-28 15:34:35.620317+00
215	zerver	0240_usermessage_migrate_bigint_id_into_id	2025-03-28 15:34:35.620559+00
216	zerver	0241_usermessage_bigint_id_migration_finalize	2025-03-28 15:34:35.62078+00
217	zerver	0242_fix_bot_email_property	2025-03-28 15:34:35.621066+00
218	zerver	0243_message_add_date_sent_column	2025-03-28 15:34:35.62132+00
219	zerver	0244_message_copy_pub_date_to_date_sent	2025-03-28 15:34:35.621522+00
220	zerver	0245_message_date_sent_finalize_part1	2025-03-28 15:34:35.621712+00
221	zerver	0246_message_date_sent_finalize_part2	2025-03-28 15:34:35.621908+00
222	zerver	0247_realmauditlog_event_type_to_int	2025-03-28 15:34:35.622126+00
223	zerver	0248_userprofile_role_start	2025-03-28 15:34:35.622334+00
224	zerver	0249_userprofile_role_finish	2025-03-28 15:34:35.622528+00
225	zerver	0250_saml_auth	2025-03-28 15:34:35.622736+00
226	zerver	0251_prereg_user_add_full_name	2025-03-28 15:34:35.622941+00
227	zerver	0252_realm_user_group_edit_policy	2025-03-28 15:34:35.623166+00
228	zerver	0253_userprofile_wildcard_mentions_notify	2025-03-28 15:34:35.623376+00
229	zerver	0209_user_profile_no_empty_password	2025-03-28 15:34:35.623565+00
230	zerver	0254_merge_0209_0253	2025-03-28 15:34:35.623749+00
231	zerver	0255_userprofile_stream_add_recipient_column	2025-03-28 15:34:35.623941+00
232	zerver	0256_userprofile_stream_set_recipient_column_values	2025-03-28 15:34:35.624167+00
233	zerver	0257_fix_has_link_attribute	2025-03-28 15:34:35.624396+00
234	zerver	0258_enable_online_push_notifications_default	2025-03-28 15:34:35.62459+00
235	zerver	0259_missedmessageemailaddress	2025-03-28 15:34:35.624792+00
236	zerver	0260_missed_message_addresses_from_redis_to_db	2025-03-28 15:34:35.625035+00
237	zerver	0261_realm_private_message_policy	2025-03-28 15:34:35.62527+00
238	zerver	0262_mutedtopic_date_muted	2025-03-28 15:34:35.625472+00
239	zerver	0263_stream_stream_post_policy	2025-03-28 15:34:35.62568+00
240	zerver	0264_migrate_is_announcement_only	2025-03-28 15:34:35.625877+00
241	zerver	0265_remove_stream_is_announcement_only	2025-03-28 15:34:35.626143+00
242	zerver	0266_userpresence_realm	2025-03-28 15:34:35.626416+00
243	zerver	0267_backfill_userpresence_realm_id	2025-03-28 15:34:35.626631+00
244	zerver	0268_add_userpresence_realm_timestamp_index	2025-03-28 15:34:35.626839+00
245	zerver	0269_gitlab_auth	2025-03-28 15:34:35.627059+00
246	zerver	0270_huddle_recipient	2025-03-28 15:34:35.627389+00
247	zerver	0271_huddle_set_recipient_column_values	2025-03-28 15:34:35.627681+00
248	zerver	0272_realm_default_code_block_language	2025-03-28 15:34:35.627905+00
249	zerver	0273_migrate_old_bot_messages	2025-03-28 15:34:35.62814+00
250	zerver	0274_nullbooleanfield_to_booleanfield	2025-03-28 15:34:35.628463+00
251	zerver	0275_remove_userprofile_last_pointer_updater	2025-03-28 15:34:35.628754+00
252	zerver	0276_alertword	2025-03-28 15:34:35.629001+00
253	zerver	0277_migrate_alert_word	2025-03-28 15:34:35.629211+00
254	zerver	0278_remove_userprofile_alert_words	2025-03-28 15:34:35.629409+00
255	zerver	0279_message_recipient_subject_indexes	2025-03-28 15:34:35.629603+00
256	zerver	0280_userprofile_presence_enabled	2025-03-28 15:34:35.630005+00
257	zerver	0281_zoom_oauth	2025-03-28 15:34:35.630439+00
258	zerver	0282_remove_zoom_video_chat	2025-03-28 15:34:35.630803+00
259	zerver	0283_apple_auth	2025-03-28 15:34:35.631077+00
260	zerver	0284_convert_realm_admins_to_realm_owners	2025-03-28 15:34:35.63132+00
261	zerver	0285_remove_realm_google_hangouts_domain	2025-03-28 15:34:35.631536+00
262	zerver	0261_pregistrationuser_clear_invited_as_admin	2025-03-28 15:34:35.631886+00
263	zerver	0286_merge_0260_0285	2025-03-28 15:34:35.63225+00
264	zerver	0287_clear_duplicate_reactions	2025-03-28 15:34:35.632591+00
265	zerver	0288_reaction_unique_on_emoji_code	2025-03-28 15:34:35.632833+00
266	zerver	0289_tighten_attachment_size	2025-03-28 15:34:35.633082+00
267	zerver	0290_remove_night_mode_add_color_scheme	2025-03-28 15:34:35.633341+00
268	zerver	0291_realm_retention_days_not_null	2025-03-28 15:34:35.633591+00
269	zerver	0292_update_default_value_of_invited_as	2025-03-28 15:34:35.633835+00
270	zerver	0293_update_invite_as_dict_values	2025-03-28 15:34:35.63408+00
271	zerver	0294_remove_userprofile_pointer	2025-03-28 15:34:35.634324+00
272	zerver	0295_case_insensitive_email_indexes	2025-03-28 15:34:35.634537+00
273	zerver	0296_remove_userprofile_short_name	2025-03-28 15:34:35.634754+00
274	zerver	0297_draft	2025-03-28 15:34:35.634946+00
275	zerver	0298_fix_realmauditlog_format	2025-03-28 15:34:35.63515+00
276	zerver	0299_subscription_role	2025-03-28 15:34:35.635338+00
277	zerver	0300_add_attachment_is_web_public	2025-03-28 15:34:35.635539+00
278	zerver	0301_fix_unread_messages_in_deactivated_streams	2025-03-28 15:34:35.635756+00
279	zerver	0302_case_insensitive_stream_name_index	2025-03-28 15:34:35.636041+00
280	zerver	0303_realm_wildcard_mention_policy	2025-03-28 15:34:35.636285+00
281	zerver	0304_remove_default_status_of_default_private_streams	2025-03-28 15:34:35.63649+00
282	zerver	0305_realm_deactivated_redirect	2025-03-28 15:34:35.636724+00
283	zerver	0306_custom_profile_field_date_format	2025-03-28 15:34:35.636932+00
284	zerver	0307_rename_api_super_user_to_can_forge_sender	2025-03-28 15:34:35.637157+00
285	zerver	0308_remove_reduntant_realm_meta_permissions	2025-03-28 15:34:35.637372+00
286	zerver	0309_userprofile_can_create_users	2025-03-28 15:34:35.63763+00
287	zerver	0310_jsonfield	2025-03-28 15:34:35.637844+00
288	zerver	0311_userprofile_default_view	2025-03-28 15:34:35.638057+00
289	zerver	0312_subscription_is_user_active	2025-03-28 15:34:35.638271+00
290	zerver	0313_finish_is_user_active_migration	2025-03-28 15:34:35.63849+00
291	zerver	0314_muted_user	2025-03-28 15:34:35.638703+00
292	zerver	0315_realmplayground	2025-03-28 15:34:35.63891+00
293	zerver	0316_realm_invite_to_realm_policy	2025-03-28 15:34:35.639116+00
294	zerver	0317_migrate_to_invite_to_realm_policy	2025-03-28 15:34:35.639319+00
295	zerver	0318_remove_realm_invite_by_admins_only	2025-03-28 15:34:35.63952+00
296	zerver	0319_realm_giphy_rating	2025-03-28 15:34:35.639728+00
297	zerver	0320_realm_move_messages_between_streams_policy	2025-03-28 15:34:35.639932+00
298	zerver	0321_userprofile_enable_marketing_emails	2025-03-28 15:34:35.640219+00
299	zerver	0322_realm_create_audit_log_backfill	2025-03-28 15:34:35.640481+00
300	zerver	0323_show_starred_message_counts	2025-03-28 15:34:35.640713+00
301	zerver	0324_fix_deletion_cascade_behavior	2025-03-28 15:34:35.640929+00
302	zerver	0325_alter_realmplayground_unique_together	2025-03-28 15:34:35.641208+00
303	zerver	0359_re2_linkifiers	2025-03-28 15:34:35.641476+00
304	zerver	0326_alter_realm_authentication_methods	2025-03-28 15:34:35.641697+00
305	zerver	0327_realm_edit_topic_policy	2025-03-28 15:34:35.641901+00
306	zerver	0328_migrate_to_edit_topic_policy	2025-03-28 15:34:35.64216+00
307	zerver	0329_remove_realm_allow_community_topic_editing	2025-03-28 15:34:35.642366+00
308	zerver	0330_linkifier_pattern_validator	2025-03-28 15:34:35.642564+00
309	zerver	0331_scheduledmessagenotificationemail	2025-03-28 15:34:35.642753+00
310	zerver	0332_realmuserdefault	2025-03-28 15:34:35.642951+00
311	zerver	0333_alter_realm_org_type	2025-03-28 15:34:35.643156+00
312	zerver	0334_email_notifications_batching_period	2025-03-28 15:34:35.643344+00
313	zerver	0335_add_draft_sync_field	2025-03-28 15:34:35.643536+00
314	zerver	0336_userstatus_status_emoji	2025-03-28 15:34:35.643727+00
315	zerver	0337_realm_add_custom_emoji_policy	2025-03-28 15:34:35.643919+00
316	zerver	0338_migrate_to_add_custom_emoji_policy	2025-03-28 15:34:35.644166+00
317	zerver	0339_remove_realm_add_emoji_by_admins_only	2025-03-28 15:34:35.644374+00
318	zerver	0340_rename_mutedtopic_to_usertopic	2025-03-28 15:34:35.644579+00
319	zerver	0341_usergroup_is_system_group	2025-03-28 15:34:35.644837+00
320	zerver	0342_realm_demo_organization_scheduled_deletion_date	2025-03-28 15:34:35.645053+00
321	zerver	0343_alter_useractivityinterval_index_together	2025-03-28 15:34:35.645274+00
322	zerver	0344_alter_emojiset_default_value	2025-03-28 15:34:35.645489+00
323	zerver	0345_alter_realm_name	2025-03-28 15:34:35.645697+00
324	zerver	0346_create_realm_user_default_table	2025-03-28 15:34:35.645902+00
325	zerver	0347_realm_emoji_animated	2025-03-28 15:34:35.64611+00
326	zerver	0348_rename_date_muted_usertopic_last_updated	2025-03-28 15:34:35.646313+00
327	zerver	0349_alter_usertopic_table	2025-03-28 15:34:35.646511+00
328	zerver	0350_usertopic_visibility_policy	2025-03-28 15:34:35.646706+00
329	zerver	0351_user_topic_visibility_indexes	2025-03-28 15:34:35.646905+00
330	zerver	0352_migrate_twenty_four_hour_time_to_realmuserdefault	2025-03-28 15:34:35.647122+00
331	zerver	0353_remove_realm_default_twenty_four_hour_time	2025-03-28 15:34:35.647327+00
332	zerver	0354_alter_realm_message_content_delete_limit_seconds	2025-03-28 15:34:35.647556+00
333	zerver	0355_realm_delete_own_message_policy	2025-03-28 15:34:35.647846+00
334	zerver	0356_migrate_to_delete_own_message_policy	2025-03-28 15:34:35.648182+00
335	zerver	0357_remove_realm_allow_message_deleting	2025-03-28 15:34:35.648409+00
336	zerver	0358_split_create_stream_policy	2025-03-28 15:34:35.648619+00
337	zerver	0360_merge_0358_0359	2025-03-28 15:34:35.648825+00
338	zerver	0361_realm_create_web_public_stream_policy	2025-03-28 15:34:35.64903+00
339	zerver	0362_send_typing_notifications_user_setting	2025-03-28 15:34:35.649235+00
340	zerver	0363_send_read_receipts_user_setting	2025-03-28 15:34:35.649434+00
341	zerver	0364_rename_members_usergroup_direct_members	2025-03-28 15:34:35.649634+00
342	zerver	0365_alter_user_group_related_fields	2025-03-28 15:34:35.649837+00
343	zerver	0366_group_group_membership	2025-03-28 15:34:35.650028+00
344	zerver	0367_scimclient	2025-03-28 15:34:35.650226+00
345	zerver	0368_alter_realmfilter_url_format_string	2025-03-28 15:34:35.650426+00
346	zerver	0369_add_escnav_default_display_user_setting	2025-03-28 15:34:35.650636+00
347	zerver	0370_realm_enable_spectator_access	2025-03-28 15:34:35.65083+00
348	zerver	0371_invalid_characters_in_topics	2025-03-28 15:34:35.651036+00
349	zerver	0372_realmemoji_unique_realm_emoji_when_false_deactivated	2025-03-28 15:34:35.651248+00
350	zerver	0373_fix_deleteduser_dummies	2025-03-28 15:34:35.651446+00
351	zerver	0374_backfill_user_delete_realmauditlog	2025-03-28 15:34:35.651643+00
352	zerver	0375_invalid_characters_in_stream_names	2025-03-28 15:34:35.651835+00
353	zerver	0376_set_realmemoji_author_and_reupload_realmemoji	2025-03-28 15:34:35.652035+00
354	zerver	0377_message_edit_history_format	2025-03-28 15:34:35.65223+00
355	zerver	0378_alter_realmuserdefault_realm	2025-03-28 15:34:35.652427+00
356	zerver	0379_userprofile_uuid	2025-03-28 15:34:35.652615+00
357	zerver	0380_userprofile_uuid_backfill	2025-03-28 15:34:35.652806+00
358	zerver	0381_alter_userprofile_uuid	2025-03-28 15:34:35.653009+00
359	zerver	0382_create_role_based_system_groups	2025-03-28 15:34:35.653208+00
360	zerver	0383_revoke_invitations_from_deactivated_users	2025-03-28 15:34:35.653413+00
361	zerver	0384_alter_realm_not_null	2025-03-28 15:34:35.653611+00
362	zerver	0385_attachment_flags_cache	2025-03-28 15:34:35.653797+00
363	zerver	0386_fix_attachment_caches	2025-03-28 15:34:35.654038+00
364	zerver	0387_reupload_realmemoji_again	2025-03-28 15:34:35.654259+00
365	zerver	0388_preregistrationuser_created_user	2025-03-28 15:34:35.654494+00
366	zerver	0389_userprofile_display_emoji_reaction_users	2025-03-28 15:34:35.654726+00
367	zerver	0390_fix_stream_history_public_to_subscribers	2025-03-28 15:34:35.654983+00
368	zerver	0391_alter_stream_history_public_to_subscribers	2025-03-28 15:34:35.655265+00
369	zerver	0392_non_nullable_fields	2025-03-28 15:34:35.655508+00
370	zerver	0393_realm_want_advertise_in_communities_directory	2025-03-28 15:34:35.655796+00
371	zerver	0394_alter_realm_want_advertise_in_communities_directory	2025-03-28 15:34:35.656109+00
372	zerver	0395_alter_realm_wildcard_mention_policy	2025-03-28 15:34:35.656381+00
373	zerver	0396_remove_subscription_role	2025-03-28 15:34:35.656724+00
374	zerver	0397_remove_custom_field_values_for_deleted_options	2025-03-28 15:34:35.657103+00
375	zerver	0398_tsvector_statistics	2025-03-28 15:34:35.657536+00
376	zerver	0399_preregistrationuser_multiuse_invite	2025-03-28 15:34:35.657976+00
377	zerver	0400_realmreactivationstatus	2025-03-28 15:34:35.658267+00
378	zerver	0401_migrate_old_realm_reactivation_links	2025-03-28 15:34:35.658551+00
379	zerver	0402_alter_usertopic_visibility_policy	2025-03-28 15:34:35.658886+00
380	zerver	0403_create_role_based_groups_for_internal_realms	2025-03-28 15:34:35.659204+00
381	zerver	0404_realm_enable_read_receipts	2025-03-28 15:34:35.659464+00
382	zerver	0405_set_default_for_enable_read_receipts	2025-03-28 15:34:35.659739+00
383	zerver	0406_alter_realm_message_content_edit_limit_seconds	2025-03-28 15:34:35.660068+00
384	zerver	0407_userprofile_user_list_style	2025-03-28 15:34:35.660376+00
385	zerver	0408_stream_can_remove_subscribers_group	2025-03-28 15:34:35.660696+00
386	zerver	0409_set_default_for_can_remove_subscribers_group	2025-03-28 15:34:35.660977+00
387	zerver	0410_alter_stream_can_remove_subscribers_group	2025-03-28 15:34:35.661393+00
388	zerver	0411_alter_muteduser_muted_user_and_more	2025-03-28 15:34:35.661846+00
389	zerver	0412_customprofilefield_display_in_profile_summary	2025-03-28 15:34:35.662378+00
390	zerver	0413_set_presence_enabled_false_for_user_status_away	2025-03-28 15:34:35.662707+00
391	zerver	0414_remove_userstatus_status	2025-03-28 15:34:35.663007+00
392	zerver	0415_delete_scimclient	2025-03-28 15:34:35.663359+00
393	zerver	0416_set_default_emoji_style	2025-03-28 15:34:35.663673+00
394	zerver	0417_alter_customprofilefield_field_type	2025-03-28 15:34:35.663932+00
395	zerver	0418_archivedmessage_realm_message_realm	2025-03-28 15:34:35.66417+00
396	zerver	0419_backfill_message_realm	2025-03-28 15:34:35.664493+00
397	zerver	0420_alter_archivedmessage_realm_alter_message_realm	2025-03-28 15:34:35.664921+00
398	zerver	0421_migrate_pronouns_custom_profile_fields	2025-03-28 15:34:35.665339+00
399	zerver	0422_multiuseinvite_status	2025-03-28 15:34:35.665661+00
400	zerver	0423_fix_email_gateway_attachment_owner	2025-03-28 15:34:35.666146+00
401	zerver	0424_realm_move_messages_within_stream_limit_seconds	2025-03-28 15:34:35.666471+00
402	zerver	0425_realm_move_messages_between_streams_limit_seconds	2025-03-28 15:34:35.666754+00
403	zerver	0426_add_email_address_visibility_setting	2025-03-28 15:34:35.667022+00
404	zerver	0427_migrate_to_user_level_email_address_visibility_setting	2025-03-28 15:34:35.667321+00
405	zerver	0428_remove_realm_email_address_visibility	2025-03-28 15:34:35.667599+00
406	zerver	0429_user_topic_case_insensitive_unique_toghether	2025-03-28 15:34:35.668115+00
407	zerver	0430_fix_audit_log_objects_for_group_based_stream_settings	2025-03-28 15:34:35.668602+00
408	zerver	0431_alter_archivedreaction_unique_together_and_more	2025-03-28 15:34:35.669+00
409	zerver	0432_alter_and_migrate_realm_name_in_notifications	2025-03-28 15:34:35.669427+00
410	zerver	0433_preregistrationrealm	2025-03-28 15:34:35.669728+00
411	zerver	0434_create_nobody_system_group	2025-03-28 15:34:35.669988+00
412	zerver	0435_scheduledmessage_rendered_content	2025-03-28 15:34:35.670257+00
413	zerver	0436_realmauthenticationmethods	2025-03-28 15:34:35.670543+00
414	zerver	0437_remove_realm_authentication_methods	2025-03-28 15:34:35.670784+00
415	zerver	0438_add_web_mark_read_on_scroll_policy_setting	2025-03-28 15:34:35.671074+00
416	zerver	0439_fix_deleteduser_email	2025-03-28 15:34:35.671341+00
417	zerver	0440_realmfilter_url_template	2025-03-28 15:34:35.671609+00
418	zerver	0441_backfill_realmfilter_url_template	2025-03-28 15:34:35.671882+00
419	zerver	0442_remove_realmfilter_url_format_string	2025-03-28 15:34:35.672159+00
420	zerver	0443_userpresence_new_table_schema	2025-03-28 15:34:35.672403+00
421	zerver	0444_userpresence_fill_data	2025-03-28 15:34:35.672644+00
422	zerver	0445_drop_userpresenceold	2025-03-28 15:34:35.672919+00
423	zerver	0446_realmauditlog_zerver_realmauditlog_user_subscriptions_idx	2025-03-28 15:34:35.673183+00
424	zerver	0447_attachment_scheduled_messages_and_more	2025-03-28 15:34:35.673407+00
425	zerver	0448_scheduledmessage_new_fields	2025-03-28 15:34:35.673661+00
426	zerver	0449_scheduledmessage_zerver_unsent_scheduled_messages_indexes	2025-03-28 15:34:35.673956+00
427	zerver	0450_backfill_subscription_auditlogs	2025-03-28 15:34:35.674214+00
428	zerver	0451_add_userprofile_api_key_index	2025-03-28 15:34:35.674426+00
429	zerver	0452_realmauditlog_extra_data_json	2025-03-28 15:34:35.674672+00
430	zerver	0453_followed_topic_notifications	2025-03-28 15:34:35.67496+00
431	zerver	0454_usergroup_can_mention_group	2025-03-28 15:34:35.67524+00
432	zerver	0455_set_default_for_can_mention_group	2025-03-28 15:34:35.675497+00
433	zerver	0456_alter_usergroup_can_mention_group	2025-03-28 15:34:35.675774+00
434	zerver	0457_backfill_scheduledmessagenotificationemail_trigger	2025-03-28 15:34:35.676048+00
435	zerver	0458_realmauditlog_modified_user_group	2025-03-28 15:34:35.676291+00
436	zerver	0459_remove_invalid_characters_from_user_group_name	2025-03-28 15:34:35.676515+00
437	zerver	0460_backfill_realmauditlog_extradata_to_json_field	2025-03-28 15:34:35.676734+00
438	zerver	0461_alter_realm_default_code_block_language	2025-03-28 15:34:35.676948+00
439	zerver	0462_realmplayground_url_template	2025-03-28 15:34:35.677181+00
440	zerver	0463_backfill_realmplayground_url_template	2025-03-28 15:34:35.677448+00
441	zerver	0464_remove_realmplayground_url_prefix	2025-03-28 15:34:35.677784+00
442	zerver	0465_backfill_scheduledmessagenotificationemail_trigger	2025-03-28 15:34:35.678065+00
443	zerver	0466_realmfilter_order	2025-03-28 15:34:35.678308+00
444	zerver	0467_rename_extradata_realmauditlog_extra_data_json	2025-03-28 15:34:35.678523+00
445	zerver	0468_rename_followup_day_email_templates	2025-03-28 15:34:35.678744+00
446	zerver	0469_realm_create_multiuse_invite_group	2025-03-28 15:34:35.679121+00
447	zerver	0470_set_default_value_for_create_multiuse_invite_group	2025-03-28 15:34:35.679404+00
448	zerver	0471_alter_realm_create_multiuse_invite_group	2025-03-28 15:34:35.679671+00
449	zerver	0472_add_message_realm_id_indexes	2025-03-28 15:34:35.67991+00
450	zerver	0473_remove_message_non_realm_id_indexes	2025-03-28 15:34:35.680159+00
451	zerver	0474_realmuserdefault_web_stream_unreads_count_display_policy_and_more	2025-03-28 15:34:35.680366+00
452	zerver	0475_realm_jitsi_server_url	2025-03-28 15:34:35.680582+00
453	zerver	0476_realmuserdefault_automatically_follow_topics_policy_and_more	2025-03-28 15:34:35.680984+00
454	zerver	0477_alter_realmuserdefault_automatically_follow_topics_policy_and_more	2025-03-28 15:34:35.681284+00
455	zerver	0478_realm_enable_guest_user_indicator	2025-03-28 15:34:35.68152+00
456	zerver	0479_realm_uuid_realm_uuid_owner_secret	2025-03-28 15:34:35.681732+00
457	zerver	0480_realm_backfill_uuid_and_secret	2025-03-28 15:34:35.681999+00
458	zerver	0481_alter_realm_uuid_alter_realm_uuid_owner_secret	2025-03-28 15:34:35.682278+00
459	zerver	0482_automatically_follow_unmute_topics_policy_defaults	2025-03-28 15:34:35.682536+00
460	zerver	0483_rename_escape_navigates_to_default_view_realmuserdefault_web_escape_navigates_to_home_view_and_more	2025-03-28 15:34:35.682781+00
461	zerver	0484_preregistrationrealm_default_language	2025-03-28 15:34:35.683039+00
462	zerver	0485_alter_usermessage_flags_and_add_index	2025-03-28 15:34:35.683268+00
463	zerver	0486_clear_old_data_for_unused_usermessage_flags	2025-03-28 15:34:35.683497+00
464	zerver	0487_realm_can_access_all_users_group	2025-03-28 15:34:35.683734+00
465	zerver	0488_set_default_value_for_can_access_all_users_group	2025-03-28 15:34:35.68398+00
466	zerver	0489_alter_realm_can_access_all_users_group	2025-03-28 15:34:35.684213+00
467	zerver	0490_renumber_options_desktop_icon_count_display	2025-03-28 15:34:35.684437+00
468	zerver	0491_alter_realmuserdefault_web_home_view_and_more	2025-03-28 15:34:35.684667+00
469	zerver	0492_realm_push_notifications_enabled_and_more	2025-03-28 15:34:35.684889+00
470	zerver	0493_rename_userhotspot_to_onboardingstep	2025-03-28 15:34:35.685129+00
471	zerver	0494_realmuserdefault_automatically_follow_topics_where_mentioned_and_more	2025-03-28 15:34:35.685361+00
472	zerver	0495_scheduledmessage_read_by_sender	2025-03-28 15:34:35.685588+00
473	zerver	0496_alter_scheduledmessage_read_by_sender	2025-03-28 15:34:35.68582+00
474	zerver	0501_delete_dangling_usermessages	2025-03-28 15:34:35.68605+00
475	zerver	0517_resort_edit_history	2025-03-28 15:34:35.686285+00
476	zerver	0497_resort_edit_history	2025-03-28 15:34:35.686526+00
477	zerver	0498_rename_notifications_stream_realm_new_stream_announcements_stream	2025-03-28 15:34:35.686757+00
478	zerver	0499_rename_signup_notifications_stream_realm_signup_announcements_stream	2025-03-28 15:34:35.687078+00
479	zerver	0500_realm_zulip_update_announcements_stream	2025-03-28 15:34:35.687358+00
480	zerver	0501_mark_introduce_zulip_view_modals_as_read	2025-03-28 15:34:35.687594+00
481	zerver	0502_merge_20240319_2236	2025-03-28 15:34:35.687813+00
482	zerver	0503_realm_zulip_update_announcements_level	2025-03-28 15:34:35.688029+00
483	zerver	0504_customprofilefield_required	2025-03-28 15:34:35.688274+00
484	zerver	0505_realmuserdefault_web_font_size_px_and_more	2025-03-28 15:34:35.688529+00
485	zerver	0506_realm_require_unique_names	2025-03-28 15:34:35.688777+00
486	zerver	0507_rework_realm_upload_quota_gb	2025-03-28 15:34:35.689058+00
487	zerver	0508_realmuserdefault_receives_typing_notifications_and_more	2025-03-28 15:34:35.689385+00
488	zerver	0509_fix_emoji_metadata	2025-03-28 15:34:35.689665+00
489	zerver	0510_add_realmauditlog_realm_event_type_index	2025-03-28 15:34:35.689889+00
490	zerver	0511_stream_creator	2025-03-28 15:34:35.69013+00
491	zerver	0512_namedusergroup	2025-03-28 15:34:35.690501+00
492	zerver	0513_copy_groups_data_to_named_user_group	2025-03-28 15:34:35.690803+00
493	zerver	0514_update_usergroup_foreign_keys_to_namedusergroup	2025-03-28 15:34:35.691115+00
494	zerver	0515_rename_named_group_can_mention_group_namedusergroup_can_mention_group_and_more	2025-03-28 15:34:35.69138+00
495	zerver	0516_fix_confirmation_preregistrationusers	2025-03-28 15:34:35.691618+00
496	zerver	0518_merge	2025-03-28 15:34:35.691857+00
497	zerver	0519_archivetransaction_restored_timestamp	2025-03-28 15:34:35.692323+00
498	zerver	0520_attachment_zerver_attachment_realm_create_time	2025-03-28 15:34:35.692682+00
499	zerver	0521_multiuseinvite_include_realm_default_subscriptions_and_more	2025-03-28 15:34:35.692921+00
500	zerver	0522_set_include_realm_default_subscriptions_for_existing_objects	2025-03-28 15:34:35.693159+00
501	zerver	0523_alter_multiuseinvite_subscribe_to_default_streams_and_more	2025-03-28 15:34:35.693401+00
502	zerver	0524_remove_userprofile_onboarding_steps	2025-03-28 15:34:35.693629+00
503	zerver	0525_userpresence_last_update_id	2025-03-28 15:34:35.693854+00
504	zerver	0526_user_presence_backfill_last_update_id_to_0	2025-03-28 15:34:35.69408+00
505	zerver	0527_presencesequence	2025-03-28 15:34:35.694311+00
506	zerver	0528_realmauditlog_zerver_realmauditlog_user_activations_idx	2025-03-28 15:34:35.694539+00
507	zerver	0529_fts_bigint_id	2025-03-28 15:34:35.694806+00
508	zerver	0530_alter_useractivity_id_alter_useractivityinterval_id	2025-03-28 15:34:35.695098+00
509	zerver	0531_convert_most_ids_to_bigints	2025-03-28 15:34:35.695377+00
510	zerver	0532_realm_can_create_public_channel_group	2025-03-28 15:34:35.695611+00
511	zerver	0533_set_can_create_public_channel_group	2025-03-28 15:34:35.695836+00
512	zerver	0534_alter_realm_can_create_public_channel_group	2025-03-28 15:34:35.696049+00
513	zerver	0535_remove_realm_create_public_stream_policy	2025-03-28 15:34:35.696257+00
514	zerver	0536_add_message_type	2025-03-28 15:34:35.696466+00
515	zerver	0537_realm_can_create_private_channel_group	2025-03-28 15:34:35.696665+00
516	zerver	0538_set_can_create_private_channel_group	2025-03-28 15:34:35.696878+00
517	zerver	0539_alter_realm_can_create_private_channel_group	2025-03-28 15:34:35.697194+00
518	zerver	0540_remove_realm_create_private_stream_policy	2025-03-28 15:34:35.697513+00
519	zerver	0541_alter_realmauditlog_options	2025-03-28 15:34:35.697781+00
520	zerver	0542_onboardingusermessage	2025-03-28 15:34:35.698043+00
521	zerver	0543_preregistrationuser_notify_referrer_on_join	2025-03-28 15:34:35.69826+00
522	zerver	0544_copy_avatar_images	2025-03-28 15:34:35.698475+00
523	zerver	0545_attachment_content_type	2025-03-28 15:34:35.698687+00
524	zerver	0546_rename_huddle_directmessagegroup_and_more	2025-03-28 15:34:35.698923+00
525	zerver	0547_realmuserdefault_web_navigate_to_sent_message_and_more	2025-03-28 15:34:35.699149+00
526	zerver	0548_realmuserdefault_web_channel_default_view_and_more	2025-03-28 15:34:35.699357+00
527	zerver	0549_realm_direct_message_initiator_group_and_more	2025-03-28 15:34:35.699577+00
528	zerver	0550_set_default_value_for_realm_direct_message_initiator_group_and_more	2025-03-28 15:34:35.699796+00
529	zerver	0551_alter_realm_direct_message_initiator_group_and_more	2025-03-28 15:34:35.700002+00
530	zerver	0552_remove_realm_private_message_policy	2025-03-28 15:34:35.700217+00
531	zerver	0553_copy_emoji_images	2025-03-28 15:34:35.700432+00
532	zerver	0554_imageattachment	2025-03-28 15:34:35.700647+00
533	zerver	0555_alter_onboardingstep_onboarding_step	2025-03-28 15:34:35.700847+00
534	zerver	0556_alter_realmuserdefault_dense_mode_and_more	2025-03-28 15:34:35.701055+00
535	zerver	0557_change_information_density_defaults	2025-03-28 15:34:35.701265+00
536	zerver	0558_realmuserdefault_web_animate_image_previews_and_more	2025-03-28 15:34:35.701491+00
537	zerver	0559_realm_can_create_web_public_channel_group	2025-03-28 15:34:35.701693+00
538	zerver	0560_set_can_create_web_public_channel_group	2025-03-28 15:34:35.701895+00
539	zerver	0561_alter_realm_can_create_web_public_channel_group	2025-03-28 15:34:35.702119+00
540	zerver	0562_remove_realm_create_web_public_stream_policy	2025-03-28 15:34:35.702317+00
541	zerver	0563_zulipinternal_can_delete	2025-03-28 15:34:35.702527+00
542	zerver	0564_purge_nagios_messages	2025-03-28 15:34:35.702729+00
543	zerver	0565_realm_can_delete_any_message_group	2025-03-28 15:34:35.702953+00
544	zerver	0566_set_default_for_can_delete_any_message_group	2025-03-28 15:34:35.703173+00
545	zerver	0567_alter_realm_can_delete_any_message_group	2025-03-28 15:34:35.703377+00
546	zerver	0568_mark_narrow_to_dm_with_welcome_bot_new_user_as_read	2025-03-28 15:34:35.703591+00
547	zerver	0569_remove_userprofile_tutorial_status	2025-03-28 15:34:35.703794+00
548	analytics	0001_initial	2025-03-28 15:34:35.888482+00
549	analytics	0002_remove_huddlecount	2025-03-28 15:34:35.888914+00
550	analytics	0003_fillstate	2025-03-28 15:34:35.889225+00
551	analytics	0004_add_subgroup	2025-03-28 15:34:35.889491+00
552	analytics	0005_alter_field_size	2025-03-28 15:34:35.889771+00
553	analytics	0006_add_subgroup_to_unique_constraints	2025-03-28 15:34:35.890005+00
554	analytics	0007_remove_interval	2025-03-28 15:34:35.890223+00
555	analytics	0008_add_count_indexes	2025-03-28 15:34:35.890437+00
556	analytics	0009_remove_messages_to_stream_stat	2025-03-28 15:34:35.890679+00
557	analytics	0010_clear_messages_sent_values	2025-03-28 15:34:35.890913+00
558	analytics	0011_clear_analytics_tables	2025-03-28 15:34:35.891174+00
559	analytics	0012_add_on_delete	2025-03-28 15:34:35.891406+00
560	analytics	0013_remove_anomaly	2025-03-28 15:34:35.891616+00
561	analytics	0014_remove_fillstate_last_modified	2025-03-28 15:34:35.891823+00
562	analytics	0015_clear_duplicate_counts	2025-03-28 15:34:35.892027+00
563	analytics	0016_unique_constraint_when_subgroup_null	2025-03-28 15:34:35.892231+00
564	analytics	0017_regenerate_partial_indexes	2025-03-28 15:34:35.892433+00
565	analytics	0018_remove_usercount_active_users_audit	2025-03-28 15:34:35.892638+00
566	analytics	0019_remove_unused_counts	2025-03-28 15:34:35.89287+00
567	analytics	0020_alter_installationcount_id_alter_realmcount_id_and_more	2025-03-28 15:34:35.893124+00
568	analytics	0021_alter_fillstate_id	2025-03-28 15:34:35.893352+00
569	contenttypes	0002_remove_content_type_name	2025-03-28 15:34:35.925654+00
570	auth	0002_alter_permission_name_max_length	2025-03-28 15:34:35.953828+00
571	auth	0003_alter_user_email_max_length	2025-03-28 15:34:35.959737+00
572	auth	0004_alter_user_username_opts	2025-03-28 15:34:35.964781+00
573	auth	0005_alter_user_last_login_null	2025-03-28 15:34:35.969763+00
574	auth	0006_require_contenttypes_0002	2025-03-28 15:34:35.970191+00
575	auth	0007_alter_validators_add_error_messages	2025-03-28 15:34:35.975411+00
576	auth	0008_alter_user_username_max_length	2025-03-28 15:34:35.980392+00
577	auth	0009_alter_user_last_name_max_length	2025-03-28 15:34:35.986528+00
578	auth	0010_alter_group_name_max_length	2025-03-28 15:34:36.016185+00
579	auth	0011_update_proxy_permissions	2025-03-28 15:34:36.04391+00
580	auth	0012_alter_user_first_name_max_length	2025-03-28 15:34:36.049254+00
581	confirmation	0001_initial	2025-03-28 15:34:36.088873+00
582	confirmation	0002_realmcreationkey	2025-03-28 15:34:36.089246+00
583	confirmation	0003_emailchangeconfirmation	2025-03-28 15:34:36.089487+00
584	confirmation	0004_remove_confirmationmanager	2025-03-28 15:34:36.08973+00
585	confirmation	0005_confirmation_realm	2025-03-28 15:34:36.090034+00
586	confirmation	0006_realmcreationkey_presume_email_valid	2025-03-28 15:34:36.090322+00
587	confirmation	0007_add_indexes	2025-03-28 15:34:36.090558+00
588	confirmation	0008_confirmation_expiry_date	2025-03-28 15:34:36.090809+00
589	confirmation	0009_confirmation_expiry_date_backfill	2025-03-28 15:34:36.091046+00
590	confirmation	0010_alter_confirmation_expiry_date	2025-03-28 15:34:36.091308+00
591	confirmation	0011_alter_confirmation_expiry_date	2025-03-28 15:34:36.091549+00
592	confirmation	0012_alter_confirmation_id	2025-03-28 15:34:36.091775+00
593	confirmation	0013_alter_realmcreationkey_id	2025-03-28 15:34:36.09201+00
594	confirmation	0014_confirmation_confirmatio_content_80155a_idx	2025-03-28 15:34:36.09223+00
595	confirmation	0015_alter_confirmation_object_id	2025-03-28 15:34:36.119363+00
596	otp_static	0001_initial	2025-03-28 15:34:36.182673+00
597	otp_static	0002_throttling	2025-03-28 15:34:36.316757+00
598	otp_static	0003_add_timestamps	2025-03-28 15:34:36.361581+00
599	otp_totp	0001_initial	2025-03-28 15:34:36.393811+00
600	otp_totp	0002_auto_20190420_0723	2025-03-28 15:34:36.438338+00
601	otp_totp	0003_add_timestamps	2025-03-28 15:34:36.483027+00
602	phonenumber	0001_initial	2025-03-28 15:34:36.548424+00
603	two_factor	0001_initial	2025-03-28 15:34:36.548896+00
604	two_factor	0002_auto_20150110_0810	2025-03-28 15:34:36.549301+00
605	two_factor	0003_auto_20150817_1733	2025-03-28 15:34:36.549605+00
606	two_factor	0004_auto_20160205_1827	2025-03-28 15:34:36.549864+00
607	two_factor	0005_auto_20160224_0450	2025-03-28 15:34:36.550115+00
608	two_factor	0006_phonedevice_key_default	2025-03-28 15:34:36.550334+00
609	two_factor	0007_auto_20201201_1019	2025-03-28 15:34:36.550547+00
610	two_factor	0008_delete_phonedevice	2025-03-28 15:34:36.550764+00
611	two_factor	0001_squashed_0008_delete_phonedevice	2025-03-28 15:34:36.551014+00
612	sessions	0001_initial	2025-03-28 15:34:36.554797+00
613	default	0001_initial	2025-03-28 15:34:36.683654+00
614	social_auth	0001_initial	2025-03-28 15:34:36.684033+00
615	default	0002_add_related_name	2025-03-28 15:34:36.713977+00
616	social_auth	0002_add_related_name	2025-03-28 15:34:36.714346+00
617	default	0003_alter_email_max_length	2025-03-28 15:34:36.717084+00
618	social_auth	0003_alter_email_max_length	2025-03-28 15:34:36.717282+00
619	default	0004_auto_20160423_0400	2025-03-28 15:34:36.740212+00
620	social_auth	0004_auto_20160423_0400	2025-03-28 15:34:36.740564+00
621	social_auth	0005_auto_20160727_2333	2025-03-28 15:34:36.743038+00
622	social_django	0006_partial	2025-03-28 15:34:36.747199+00
623	social_django	0007_code_timestamp	2025-03-28 15:34:36.749923+00
624	social_django	0008_partial_timestamp	2025-03-28 15:34:36.752596+00
625	social_django	0009_auto_20191118_0520	2025-03-28 15:34:36.799347+00
626	social_django	0010_uid_db_index	2025-03-28 15:34:36.824128+00
627	social_django	0011_alter_id_fields	2025-03-28 15:34:36.871171+00
628	social_django	0012_usersocialauth_extra_data_new	2025-03-28 15:34:36.898039+00
629	social_django	0013_migrate_extra_data	2025-03-28 15:34:36.93085+00
630	social_django	0014_remove_usersocialauth_extra_data	2025-03-28 15:34:36.955691+00
631	social_django	0015_rename_extra_data_new_usersocialauth_extra_data	2025-03-28 15:34:37.046486+00
632	social_django	0016_alter_usersocialauth_extra_data	2025-03-28 15:34:37.070962+00
633	zerver	0576_backfill_imageattachment	2025-03-28 15:34:37.105277+00
634	zerver	0622_backfill_imageattachment_again	2025-03-28 15:34:37.138494+00
635	zerver	0639_zh_hant_tw_rename	2025-03-28 15:34:37.17049+00
636	zerver	0570_namedusergroup_can_manage_group	2025-03-28 15:34:37.204559+00
637	zerver	0571_set_default_for_can_manage_group	2025-03-28 15:34:37.235945+00
638	zerver	0572_alter_usergroup_can_manage_group	2025-03-28 15:34:37.271389+00
639	zerver	0573_directmessagegroup_group_size	2025-03-28 15:34:37.280468+00
640	zerver	0574_backfill_directmessagegroup_group_size	2025-03-28 15:34:37.311578+00
641	zerver	0575_alter_directmessagegroup_group_size	2025-03-28 15:34:37.320541+00
642	zerver	0577_merge_20240829_0153	2025-03-28 15:34:37.320947+00
643	zerver	0578_namedusergroup_deactivated	2025-03-28 15:34:37.343073+00
644	zerver	0579_realm_can_delete_own_message_group	2025-03-28 15:34:37.453879+00
645	zerver	0580_set_default_value_for_can_delete_own_message_group	2025-03-28 15:34:37.493093+00
646	zerver	0581_alter_realm_can_delete_own_message_group	2025-03-28 15:34:37.537379+00
647	zerver	0582_remove_realm_delete_own_message_policy	2025-03-28 15:34:37.559689+00
648	zerver	0583_namedusergroup_creator_namedusergroup_date_created	2025-03-28 15:34:37.623031+00
649	zerver	0584_namedusergroup_creator_date_created_backfill	2025-03-28 15:34:37.65742+00
650	zerver	0585_userprofile_allow_private_data_export_and_more	2025-03-28 15:34:37.707821+00
651	zerver	0586_customprofilefield_editable_by_user	2025-03-28 15:34:37.729936+00
652	zerver	0587_savedsnippet	2025-03-28 15:34:37.833118+00
653	zerver	0588_realm_add_can_create_groups	2025-03-28 15:34:37.865508+00
654	zerver	0589_set_can_create_groups	2025-03-28 15:34:37.899983+00
655	zerver	0590_alter_realm_can_create_groups	2025-03-28 15:34:37.934887+00
656	zerver	0591_realm_add_can_manage_all_groups	2025-03-28 15:34:37.96827+00
657	zerver	0592_set_can_manage_all_groups	2025-03-28 15:34:38.002611+00
658	zerver	0593_alter_realm_manage_all_groups	2025-03-28 15:34:38.037492+00
659	zerver	0594_remove_realm_user_group_edit_policy	2025-03-28 15:34:38.059709+00
660	zerver	0595_add_realmexport_table_and_backfill	2025-03-28 15:34:38.127439+00
661	zerver	0596_namedusergroup_can_join_group	2025-03-28 15:34:38.234643+00
662	zerver	0597_set_default_value_for_can_join_group	2025-03-28 15:34:38.267515+00
663	zerver	0598_alter_namedusergroup_can_join_group	2025-03-28 15:34:38.303855+00
664	zerver	0599_namedusergroup_add_can_add_members_group	2025-03-28 15:34:38.338444+00
665	zerver	0600_set_default_for_can_add_members_group	2025-03-28 15:34:38.370919+00
666	zerver	0601_alter_namedusergroup_can_add_members_group	2025-03-28 15:34:38.405055+00
667	zerver	0602_remap_can_manage_all_groups	2025-03-28 15:34:38.437938+00
668	zerver	0603_realm_can_add_custom_emoji_group	2025-03-28 15:34:38.471199+00
669	zerver	0604_set_default_value_for_can_add_custom_emoji_group	2025-03-28 15:34:38.567081+00
670	zerver	0605_alter_realm_can_add_custom_emoji_group	2025-03-28 15:34:38.602768+00
671	zerver	0606_remove_realm_add_custom_emoji_policy	2025-03-28 15:34:38.625512+00
672	zerver	0607_namedusergroup_add_can_leave_group	2025-03-28 15:34:38.658771+00
673	zerver	0608_set_default_for_can_leave_group	2025-03-28 15:34:38.690893+00
674	zerver	0609_alter_namedusergroup_can_leave_group	2025-03-28 15:34:38.725853+00
675	zerver	0610_mark_introduce_resolve_topic_modal_as_read	2025-03-28 15:34:38.758584+00
676	zerver	0611_realm_can_move_messages_between_channels_group	2025-03-28 15:34:38.792843+00
677	zerver	0612_set_default_value_for_can_move_messages_between_channels_group	2025-03-28 15:34:38.828607+00
678	zerver	0613_alter_realm_can_move_messages_between_channels_group	2025-03-28 15:34:38.93034+00
679	zerver	0614_remove_realm_move_messages_between_streams_policy	2025-03-28 15:34:38.954237+00
680	zerver	0615_system_bot_avatars	2025-03-28 15:34:38.986554+00
681	zerver	0616_userprofile_can_change_user_emails	2025-03-28 15:34:39.018924+00
682	zerver	0617_remove_prefix_from_archived_streams	2025-03-28 15:34:39.051216+00
683	zerver	0618_realm_can_move_messages_between_topics_group	2025-03-28 15:34:39.085418+00
684	zerver	0619_set_default_value_for_can_move_messages_between_topics_group	2025-03-28 15:34:39.121111+00
685	zerver	0620_alter_realm_can_move_messages_between_topics_group	2025-03-28 15:34:39.157175+00
686	zerver	0621_remove_realm_edit_topic_policy	2025-03-28 15:34:39.180912+00
687	zerver	0623_merge_20241030_1835	2025-03-28 15:34:39.181639+00
688	zerver	0624_alter_realmexport_tarball_size_bytes	2025-03-28 15:34:39.216584+00
689	zerver	0625_realm_can_invite_users_group	2025-03-28 15:34:39.31778+00
690	zerver	0626_set_default_value_for_can_invite_users_group	2025-03-28 15:34:39.354531+00
691	zerver	0627_alter_realm_can_invite_users_group	2025-03-28 15:34:39.390594+00
692	zerver	0628_remove_realm_invite_to_realm_policy	2025-03-28 15:34:39.414002+00
693	zerver	0629_remove_stream_email_token_backfill_channelemailaddress	2025-03-28 15:34:39.519119+00
694	zerver	0630_multiuseinvite_groups_preregistrationuser_groups	2025-03-28 15:34:39.593093+00
695	zerver	0631_stream_is_recently_active	2025-03-28 15:34:39.692363+00
696	zerver	0632_preregistrationrealm_data_import_metadata	2025-03-28 15:34:39.72532+00
697	zerver	0633_namedusergroup_can_remove_members_group	2025-03-28 15:34:39.760564+00
698	zerver	0634_set_default_for_can_remove_members_group	2025-03-28 15:34:39.793593+00
699	zerver	0635_alter_namedusergroup_can_remove_members_group	2025-03-28 15:34:39.830214+00
700	zerver	0636_streams_add_can_administer_channel_group	2025-03-28 15:34:39.865237+00
701	zerver	0637_set_default_for_can_administer_channel_group	2025-03-28 15:34:39.8992+00
702	zerver	0638_alter_stream_can_administer_channel_group	2025-03-28 15:34:39.935954+00
703	zerver	0640_merge_20241211_1953	2025-03-28 15:34:39.936555+00
704	zerver	0641_web_suggest_update_time_zone	2025-03-28 15:34:40.073924+00
705	zerver	0642_realm_moderation_request_channel	2025-03-28 15:34:40.114701+00
706	zerver	0643_realm_scheduled_deletion_date	2025-03-28 15:34:40.139983+00
707	zerver	0644_check_update_all_channels_active_status	2025-03-28 15:34:40.174431+00
708	zerver	0645_stream_can_send_message_group	2025-03-28 15:34:40.210475+00
709	zerver	0646_set_default_for_can_send_message_group	2025-03-28 15:34:40.244289+00
710	zerver	0647_alter_stream_can_send_message_group	2025-03-28 15:34:40.281332+00
711	zerver	0648_remove_stream_stream_post_policy	2025-03-28 15:34:40.313742+00
712	zerver	0649_realm_can_add_subscribers_group	2025-03-28 15:34:40.348495+00
713	zerver	0650_set_default_for_realm_can_add_subscribers_group	2025-03-28 15:34:40.455205+00
714	zerver	0651_alter_realm_can_add_subscribers_group	2025-03-28 15:34:40.492448+00
715	zerver	0652_remove_realm_invite_to_stream_policy	2025-03-28 15:34:40.517866+00
716	zerver	0653_stream_can_add_subscribers_group	2025-03-28 15:34:40.553864+00
717	zerver	0654_set_default_for_stream_can_add_subscribers_group	2025-03-28 15:34:40.587356+00
718	zerver	0655_alter_stream_can_add_subscribers_group	2025-03-28 15:34:40.623996+00
719	zerver	0656_realm_can_create_bots_group_and_more	2025-03-28 15:34:40.693384+00
720	zerver	0657_set_default_value_for_can_create_bots_group_and_more	2025-03-28 15:34:40.847671+00
721	zerver	0658_alter_realm_can_create_bots_group_and_more	2025-03-28 15:34:40.921402+00
722	zerver	0659_remove_realm_bot_creation_policy	2025-03-28 15:34:40.946853+00
723	zerver	0660_add_imageattachment_content_type	2025-03-28 15:34:41.003474+00
724	zerver	0661_archivetransaction_protect_from_deletion	2025-03-28 15:34:41.029352+00
725	zerver	0662_clear_realm_channel_fields_if_configured_channel_deactivated	2025-03-28 15:34:41.067012+00
726	zerver	0663_realm_enable_guest_user_dm_warning	2025-03-28 15:34:41.091855+00
727	zerver	0664_realm_can_summarize_topics_group	2025-03-28 15:34:41.192402+00
728	zerver	0665_set_default_for_can_summarize_topics_group	2025-03-28 15:34:41.226565+00
729	zerver	0666_alter_realm_can_summarize_topics_group	2025-03-28 15:34:41.263678+00
730	zerver	0667_realmuserdefault_hide_ai_features_and_more	2025-03-28 15:34:41.318231+00
731	zerver	0668_realm_can_mention_many_users_group	2025-03-28 15:34:41.35455+00
732	zerver	0669_set_default_value_for_can_mention_many_users_group	2025-03-28 15:34:41.393308+00
733	zerver	0670_alter_realm_can_mention_many_users_group	2025-03-28 15:34:41.431299+00
734	zerver	0671_remove_realm_wildcard_mention_policy	2025-03-28 15:34:41.456087+00
735	zerver	0672_fix_attachment_realm	2025-03-28 15:34:41.56006+00
736	zerver	0673_stream_can_subscribe_group	2025-03-28 15:34:41.596447+00
737	zerver	0674_set_default_for_stream_can_subscribe_group	2025-03-28 15:34:41.630736+00
738	zerver	0675_alter_stream_can_subscribe_group	2025-03-28 15:34:41.667792+00
739	zerver	0676_realm_message_edit_history_visibility_policy	2025-03-28 15:34:41.692588+00
740	zerver	0677_set_default_message_edit_history_visibility_policy	2025-03-28 15:34:41.726558+00
741	zerver	0678_remove_realm_allow_edit_history	2025-03-28 15:34:41.750808+00
742	zerver	0679_zerver_message_edit_history_id	2025-03-28 15:34:41.784459+00
743	zerver	0680_rename_general_chat_to_empty_string_topic	2025-03-28 15:34:41.81892+00
744	zerver	0681_realm_can_manage_billing_group	2025-03-28 15:34:41.920142+00
745	zerver	0682_set_default_value_for_can_manage_billing_group	2025-03-28 15:34:41.95485+00
746	zerver	0683_alter_realm_can_manage_billing_group	2025-03-28 15:34:41.992094+00
747	zerver	0684_remove_userprofile_is_billing_admin	2025-03-28 15:34:42.025017+00
748	zerver	0685_remove_realmuserdefault_dense_mode_and_more	2025-03-28 15:34:42.079803+00
749	zerver	0686_realm_can_resolve_topics_group	2025-03-28 15:34:42.114927+00
750	zerver	0687_set_default_value_for_can_resolve_topics_group	2025-03-28 15:34:42.152128+00
751	zerver	0688_alter_realm_can_resolve_topics_group	2025-03-28 15:34:42.189179+00
752	zerver	0689_mark_navigation_tour_video_as_read	2025-03-28 15:34:42.292821+00
753	zerver	0690_message_is_channel_message	2025-03-28 15:34:42.359316+00
754	zerver	0691_backfill_message_is_channel_message	2025-03-28 15:34:42.395038+00
755	zerver	0692_alter_message_is_channel_message	2025-03-28 15:34:42.462918+00
756	zerver	0693_add_conditional_indexes_for_topic	2025-03-28 15:34:42.719815+00
757	zerver	0694_remove_message_unconditional_topic_indexes	2025-03-28 15:34:42.815587+00
758	zerver	0695_is_channel_message_stats	2025-03-28 15:34:42.818287+00
759	zerver	0696_rename_no_topic_to_empty_string_topic	2025-03-28 15:34:42.852201+00
760	confirmation	0001_squashed_0014_confirmation_confirmatio_content_80155a_idx	2025-03-28 15:34:42.85582+00
761	zerver	0001_squashed_0569	2025-03-28 15:34:42.856331+00
762	social_django	0004_auto_20160423_0400	2025-03-28 15:34:42.856583+00
763	social_django	0005_auto_20160727_2333	2025-03-28 15:34:42.856811+00
764	social_django	0003_alter_email_max_length	2025-03-28 15:34:42.857033+00
765	social_django	0002_add_related_name	2025-03-28 15:34:42.857248+00
766	social_django	0001_initial	2025-03-28 15:34:42.857456+00
767	phonenumber	0001_squashed_0001_initial	2025-03-28 15:34:42.857667+00
768	analytics	0001_squashed_0021_alter_fillstate_id	2025-03-28 15:34:42.857876+00
769	zerver	0697_empty_topic_name_for_dms_from_third_party_imports	2025-03-31 14:28:04.180337+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.django_session (session_key, session_data, expire_date) FROM stdin;
pkpn6j06zgvqgobfutmj9xjj63o3tvu4	.eJxVizsOwjAMQO-SGVVJnV8ZEadgqWzHKAUKVdMMgLg7IHWA9X2eqse65L4Wmfshqa2KavPLCPks1694TPPtJLw0KyrNoV6GaV_H8b5bq781Y8mfzx85aMvgIHoBEWfIE4N1FltwqWXLwQdjUmfJxGQikJCTgDpq7BjV6w2TjjX7:1tyBkT:XZOXl3gRlY13jf8_5VL6ezKf7FKFWLiokEtfdjdt3SI	2025-04-11 15:35:57.281893+00
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

COPY zulip.zerver_alertword (id, word, user_profile_id, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedattachment; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedattachment (id, file_name, path_id, create_time, size, content_type, is_realm_public, is_web_public, owner_id, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedattachment_messages; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedattachment_messages (id, archivedattachment_id, archivedmessage_id) FROM stdin;
\.


--
-- Data for Name: zerver_archivedmessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_archivedmessage (id, type, subject, content, rendered_content, rendered_content_version, date_sent, last_edit_time, edit_history, has_attachment, has_image, has_link, sender_id, archive_transaction_id, sending_client_id, realm_id, recipient_id, is_channel_message) FROM stdin;
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

COPY zulip.zerver_archivetransaction (id, "timestamp", restored, restored_timestamp, type, realm_id, protect_from_deletion) FROM stdin;
\.


--
-- Data for Name: zerver_attachment; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_attachment (id, file_name, path_id, create_time, size, content_type, is_realm_public, is_web_public, owner_id, realm_id) FROM stdin;
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
-- Data for Name: zerver_channelemailaddress; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_channelemailaddress (id, email_token, date_created, deactivated, channel_id, creator_id, realm_id, sender_id) FROM stdin;
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

COPY zulip.zerver_customprofilefield (id, name, hint, "order", display_in_profile_summary, required, field_type, field_data, realm_id, editable_by_user) FROM stdin;
\.


--
-- Data for Name: zerver_customprofilefieldvalue; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_customprofilefieldvalue (id, value, rendered_value, field_id, user_profile_id) FROM stdin;
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

COPY zulip.zerver_defaultstreamgroup (id, name, description, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_defaultstreamgroup_streams; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_defaultstreamgroup_streams (id, defaultstreamgroup_id, stream_id) FROM stdin;
\.


--
-- Data for Name: zerver_draft; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_draft (id, topic, content, last_edit_time, user_profile_id, recipient_id) FROM stdin;
\.


--
-- Data for Name: zerver_emailchangestatus; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_emailchangestatus (id, new_email, old_email, updated_at, status, user_profile_id, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_groupgroupmembership; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_groupgroupmembership (id, supergroup_id, subgroup_id) FROM stdin;
1	3	2
2	4	3
3	5	4
4	6	5
5	7	6
6	8	7
7	11	10
8	12	11
9	13	12
10	14	13
11	15	14
12	16	15
\.


--
-- Data for Name: zerver_huddle; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_huddle (id, huddle_hash, recipient_id, group_size) FROM stdin;
\.


--
-- Data for Name: zerver_imageattachment; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_imageattachment (id, path_id, original_width_px, original_height_px, frames, thumbnail_metadata, realm_id, content_type) FROM stdin;
\.


--
-- Data for Name: zerver_message; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_message (id, type, subject, content, rendered_content, rendered_content_version, date_sent, last_edit_time, edit_history, has_attachment, has_image, has_link, search_tsvector, sender_id, sending_client_id, realm_id, recipient_id, is_channel_message) FROM stdin;
1	1	moving messages	If anything is out of place, it’s easy to [move messages](/help/move-content-to-another-topic), [rename](/help/rename-a-topic) and [split](/help/move-content-to-another-topic) topics, or even move a topic [to a different channel](/help/move-content-to-another-channel).	<p>If anything is out of place, it’s easy to <a href="/help/move-content-to-another-topic">move messages</a>, <a href="/help/rename-a-topic">rename</a> and <a href="/help/move-content-to-another-topic">split</a> topics, or even move a topic <a href="/help/move-content-to-another-channel">to a different channel</a>.</p>	1	2025-03-28 15:35:56.17781+00	\N	\N	f	f	t	'anything':4 'channel':27 'different':26 'easy':11 'even':20 'message':2,14 'move':1,13,21 'moving':1 'name':15 'place':8 'split':17 'topic':18,23	7	1	2	8	t
2	1	moving messages	:point_right: Try moving this message to another topic and back.	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span> Try moving this message to another topic and back.</p>	1	2025-03-28 15:35:56.187487+00	\N	\N	f	f	f	'another':10 'back':13 'message':2,8 'move':1,6 'moving':1,6 'point':3 'right':4 'topic':11 'try':5	7	1	2	8	t
3	1	experiments	:point_right:  Use this topic to try out [Zulip's messaging features](/help/format-your-message-using-markdown).	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span>  Use this topic to try out <a href="/help/format-your-message-using-markdown">Zulip's messaging features</a>.</p>	1	2025-03-28 15:35:56.194406+00	\N	\N	f	f	t	'experiment':1 'feature':13 'message':12 'point':2 'right':3 'topic':6 'try':8 'use':4 'zulip':10	7	1	2	9	t
5	1	start a conversation	To kick off a new conversation, pick a channel in the left sidebar, and click the `+` button next to its name.	<p>To kick off a new conversation, pick a channel in the left sidebar, and click the <code>+</code> button next to its name.</p>	1	2025-03-28 15:35:56.278015+00	\N	\N	f	f	f	'button':20 'channel':12 'click':18 'conversation':3,9 'kick':5 'left':15 'name':24 'new':8 'next':21 'pick':10 'sidebar':16 'start':1	7	1	2	9	t
6	1	start a conversation	Label your conversation with a topic. Think about finishing the sentence: “Hey, can we chat about…?”	<p>Label your conversation with a topic. Think about finishing the sentence: “Hey, can we chat about…?”</p>	1	2025-03-28 15:35:56.284448+00	\N	\N	f	f	f	'chat':18 'conversation':3,6 'finish':12 'hey':15 'label':4 'sentence':14 'start':1 'think':10 'topic':9	7	1	2	9	t
7	1	start a conversation	:point_right: Try starting a new conversation in this channel.	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span> Try starting a new conversation in this channel.</p>	1	2025-03-28 15:35:56.290697+00	\N	\N	f	f	f	'channel':13 'conversation':3,10 'new':9 'point':4 'right':5 'start':1,7 'try':6	7	1	2	9	t
8	1	greetings	This **greetings** topic is a great place to say “hi” :wave: to your teammates.	<p>This <strong>greetings</strong> topic is a great place to say “hi” <span aria-label="wave" class="emoji emoji-1f44b" role="img" title="wave">:wave:</span> to your teammates.</p>	1	2025-03-28 15:35:56.297331+00	\N	\N	f	f	f	'great':7 'greet':1,3 'hi':11 'place':8 'say':10 'teammate':15 'topic':4 'wave':12	7	1	2	10	t
9	1	greetings	:point_right: Click on this message to start a new message in the same conversation.	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span> Click on this message to start a new message in the same conversation.</p>	1	2025-03-28 15:35:56.303628+00	\N	\N	f	f	f	'click':4 'conversation':16 'greet':1 'message':7,12 'new':11 'point':2 'right':3 'start':9	7	1	2	10	t
11	1	welcome to Zulip!	You can read Zulip one conversation at a time, seeing each message in context, no matter how many other conversations are going on.	<p>You can read Zulip one conversation at a time, seeing each message in context, no matter how many other conversations are going on.</p>	1	2025-03-28 15:35:56.317295+00	\N	\N	f	f	f	'conversation':9,23 'go':25 'going':25 'many':21 'matte':19 'matter':19 'message':15 'one':8 'read':6 'seeing':13 'text':17 'time':12 'welcome':1 'zulip':3,7	7	1	2	8	t
12	1	welcome to Zulip!	:point_right: When you're ready, check out your [Inbox](/#inbox) for other conversations with unread messages.	<p><span aria-label="point right" class="emoji emoji-1f449" role="img" title="point right">:point_right:</span> When you're ready, check out your <a href="/#inbox">Inbox</a> for other conversations with unread messages.</p>	1	2025-03-28 15:35:56.323649+00	\N	\N	f	f	t	'check':10 'conversation':16 'inbox':13 'message':19 'point':4 're':8 'ready':9 'right':5 'unread':18 'welcome':1 'zulip':3	7	1	2	8	t
4	1	experiments	```spoiler Want to see some examples?\n\n````python\n\nprint("code blocks")\n\n````\n\n- bulleted\n- lists\n\nLink to a conversation: #**Zulip>welcome to Zulip!**\n\n```	<div class="spoiler-block"><div class="spoiler-header">\n<p>Want to see some examples?</p>\n</div><div class="spoiler-content" aria-hidden="true">\n<div class="codehilite" data-code-language="Python"><pre><span></span><code><span class="nb">print</span><span class="p">(</span><span class="s2">"code blocks"</span><span class="p">)</span>\n</code></pre></div>\n<ul>\n<li>bulleted</li>\n<li>lists</li>\n</ul>\n<p>Link to a conversation: <a class="stream-topic" data-stream-id="1" href="/#narrow/channel/1-Zulip/topic/welcome.20to.20Zulip.21">#Zulip &gt; welcome to Zulip!</a></p>\n</div></div>	1	2025-03-28 15:35:56.20075+00	\N	\N	f	f	t	'block':9 'bullet':10 'code':8 'conversation':15 'example':6 'experiment':1 'link':12 'list':11 'print':7 'see':4 'want':2 'welcome':17 'zulip':16,19	7	1	2	9	t
10	1	welcome to Zulip!	Zulip is organised to help you communicate more efficiently. Conversations are labeled with topics, which summarise what the conversation is about.\n\nFor example, this message is in the “welcome to Zulip!” topic in the #**Zulip** channel, as you can see in the left sidebar and above.	<p>Zulip is organised to help you communicate more efficiently. Conversations are labeled with topics, which summarise what the conversation is about.</p>\n<p>For example, this message is in the “welcome to Zulip!” topic in the <a class="stream" data-stream-id="1" href="/#narrow/channel/1-Zulip">#Zulip</a> channel, as you can see in the left sidebar and above.</p>	1	2025-03-28 15:35:56.309553+00	\N	\N	f	f	t	'channel':39 'communicate':10 'conversation':13,22 'efficient':12 'example':26 'help':8 'label':15 'labeled':15 'left':46 'message':28 'organis':6 'see':43 'sidebar':47 'summaris':19 'topic':17,35 'welcome':1,32 'zulip':3,4,34,38	7	1	2	8	t
13	1		Hello, and welcome to Zulip!👋  I've kicked off some conversations to help you get started. You can find them in your [Inbox](/#inbox).\n\n\n\nTo learn more, check out our [getting started guide](/help/getting-started-with-zulip)!   We also have a guide for [moving your organisation to Zulip](/help/moving-to-zulip).\n\n\n\nYou can always come back to the [Welcome to Zulip video](https://static.zulipchat.com/static/navigation-tour-video/zulip-10.mp4) for a quick app overview.	<p>Hello, and welcome to Zulip!<span aria-label="wave" class="emoji emoji-1f44b" role="img" title="wave">:wave:</span>  I've kicked off some conversations to help you get started. You can find them in your <a href="/#inbox">Inbox</a>.</p>\n<p>To learn more, check out our <a href="/help/getting-started-with-zulip">getting started guide</a>!   We also have a guide for <a href="/help/moving-to-zulip">moving your organisation to Zulip</a>.</p>\n<p>You can always come back to the <a href="https://static.zulipchat.com/static/navigation-tour-video/zulip-10.mp4">Welcome to Zulip video</a> for a quick app overview.</p>\n<div class="message_inline_image message_inline_video"><a href="https://static.zulipchat.com/static/navigation-tour-video/zulip-10.mp4" title="Welcome to Zulip video"><video preload="metadata" src="/external_content/413693f8c20f7d5e16c6ee882eb0a87ffd6c8311/68747470733a2f2f7374617469632e7a756c6970636861742e636f6d2f7374617469632f6e617669676174696f6e2d746f75722d766964656f2f7a756c69702d31302e6d7034"></video></a></div>	1	2025-03-28 15:35:56.384587+00	\N	\N	f	f	t	'also':35 'always':47 'app':59 'back':49 'check':28 'come':48 'conversation':12 'find':20 'get':16 'getting':31 'guide':33,38 'hello':1 'help':14 'inbox':24 'kick':9 'learn':26 'move':40 'moving':40 'organis':42 'overview':60 'quick':58 'start':17,32 've':8 'video':55 'wave':6 'welcome':3,52 'zulip':5,44,54	7	1	2	11	f
\.


--
-- Data for Name: zerver_missedmessageemailaddress; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_missedmessageemailaddress (id, email_token, "timestamp", times_used, message_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_multiuseinvite; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_multiuseinvite (id, invited_as, include_realm_default_subscriptions, status, referred_by_id, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_multiuseinvite_groups; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_multiuseinvite_groups (id, multiuseinvite_id, namedusergroup_id) FROM stdin;
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

COPY zulip.zerver_namedusergroup (usergroup_ptr_id, name, description, is_system_group, can_mention_group_id, realm_id, can_manage_group_id, deactivated, creator_id, date_created, can_join_group_id, can_add_members_group_id, can_leave_group_id, can_remove_members_group_id) FROM stdin;
1	role:nobody	Nobody	t	1	1	1	f	\N	\N	1	1	1	1
2	role:owners	Owners of this organization	t	1	1	1	f	\N	\N	1	1	1	1
3	role:administrators	Administrators of this organization, including owners	t	1	1	1	f	\N	\N	1	1	1	1
4	role:moderators	Moderators of this organization, including administrators	t	1	1	1	f	\N	\N	1	1	1	1
5	role:fullmembers	Members of this organization, not including new accounts and guests	t	1	1	1	f	\N	\N	1	1	1	1
6	role:members	Members of this organization, not including guests	t	1	1	1	f	\N	\N	1	1	1	1
7	role:everyone	Everyone in this organization, including guests	t	1	1	1	f	\N	\N	1	1	1	1
8	role:internet	Everyone on the Internet	t	1	1	1	f	\N	\N	1	1	1	1
9	role:nobody	Nobody	t	9	2	9	f	\N	\N	9	9	9	9
10	role:owners	Owners of this organization	t	9	2	9	f	\N	\N	9	9	9	9
11	role:administrators	Administrators of this organization, including owners	t	9	2	9	f	\N	\N	9	9	9	9
12	role:moderators	Moderators of this organization, including administrators	t	9	2	9	f	\N	\N	9	9	9	9
13	role:fullmembers	Members of this organization, not including new accounts and guests	t	9	2	9	f	\N	\N	9	9	9	9
14	role:members	Members of this organization, not including guests	t	9	2	9	f	\N	\N	9	9	9	9
15	role:everyone	Everyone in this organization, including guests	t	9	2	9	f	\N	\N	9	9	9	9
16	role:internet	Everyone on the Internet	t	9	2	9	f	\N	\N	9	9	9	9
\.


--
-- Data for Name: zerver_onboardingstep; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_onboardingstep (id, onboarding_step, "timestamp", user_id) FROM stdin;
1	visibility_policy_banner	2025-03-28 15:35:56.391805+00	8
2	narrow_to_dm_with_welcome_bot_new_user	2025-03-28 15:35:57.511171+00	8
3	navigation_tour_video	2025-03-28 15:36:01.980843+00	8
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

COPY zulip.zerver_preregistrationrealm (id, name, org_type, default_language, string_id, email, status, created_user_id, created_realm_id, data_import_metadata) FROM stdin;
1	testing	20	en-gb		test@test.com	1	8	2	{}
\.


--
-- Data for Name: zerver_preregistrationuser; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationuser (id, email, full_name, full_name_validated, notify_referrer_on_join, invited_at, realm_creation, password_required, status, invited_as, include_realm_default_subscriptions, created_user_id, multiuse_invite_id, referred_by_id, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_preregistrationuser_groups; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_preregistrationuser_groups (id, preregistrationuser_id, namedusergroup_id) FROM stdin;
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
2	4	2
\.


--
-- Data for Name: zerver_pushdevicetoken; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_pushdevicetoken (id, kind, token, last_updated, ios_app_id, user_id) FROM stdin;
\.


--
-- Data for Name: zerver_reaction; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_reaction (id, emoji_name, reaction_type, emoji_code, message_id, user_profile_id) FROM stdin;
1	wave	unicode_emoji	1f44b	8	7
\.


--
-- Data for Name: zerver_realm; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realm (id, name, description, string_id, uuid, uuid_owner_secret, push_notifications_enabled, push_notifications_enabled_end_timestamp, date_created, demo_organization_scheduled_deletion_date, deactivated, deactivated_redirect, emails_restricted_to_domains, invite_required, max_invites, disallow_disposable_email_addresses, enable_spectator_access, want_advertise_in_communities_directory, inline_image_preview, inline_url_embed_preview, digest_emails_enabled, digest_weekday, send_welcome_emails, message_content_allowed_in_email_notifications, mandatory_topics, require_unique_names, name_changes_disabled, email_changes_disabled, avatar_changes_disabled, move_messages_within_stream_limit_seconds, move_messages_between_streams_limit_seconds, waiting_period_threshold, message_content_delete_limit_seconds, allow_message_editing, message_content_edit_limit_seconds, default_language, zulip_update_announcements_level, message_retention_days, message_visibility_limit, first_visible_message_id, org_type, plan_type, custom_upload_quota_gb, video_chat_provider, jitsi_server_url, giphy_rating, default_code_block_language, enable_read_receipts, enable_guest_user_indicator, icon_source, icon_version, logo_source, logo_version, night_logo_source, night_logo_version, can_access_all_users_group_id, can_create_private_channel_group_id, can_create_public_channel_group_id, can_create_web_public_channel_group_id, can_delete_any_message_group_id, create_multiuse_invite_group_id, direct_message_initiator_group_id, direct_message_permission_group_id, new_stream_announcements_stream_id, signup_announcements_stream_id, zulip_update_announcements_stream_id, can_delete_own_message_group_id, can_create_groups_id, can_manage_all_groups_id, can_add_custom_emoji_group_id, can_move_messages_between_channels_group_id, can_move_messages_between_topics_group_id, can_invite_users_group_id, moderation_request_channel_id, scheduled_deletion_date, can_add_subscribers_group_id, can_create_bots_group_id, can_create_write_only_bots_group_id, enable_guest_user_dm_warning, can_summarize_topics_group_id, can_mention_many_users_group_id, message_edit_history_visibility_policy, can_manage_billing_group_id, can_resolve_topics_group_id) FROM stdin;
1	System bot realm		zulipinternal	d2b32b2a-feb7-495a-b525-d97e6981ad09	zuliprealm_A3eF3t8LxmuVfnorEpYK9cr7DRsNXUDK	f	\N	2025-03-28 15:35:55.932806+00	\N	f	\N	f	t	\N	t	f	f	t	f	f	1	t	t	f	f	f	f	f	604800	604800	0	600	t	600	en	\N	-1	\N	0	0	1	\N	1	\N	2		f	t	G	1	D	1	D	1	7	6	6	2	3	3	7	7	\N	\N	\N	7	6	2	6	6	7	6	\N	\N	6	6	6	t	7	3	1	3	7
2	testing			43ba2f40-b72f-42e8-b5bd-6444040ab15c	zuliprealm_9wRdNUErUDXr2jfrrCMXTxshwDrqbKwc	f	\N	2025-03-28 15:35:56.02457+00	\N	f	\N	f	t	\N	t	f	f	t	f	f	1	t	t	f	f	f	f	f	604800	604800	0	600	t	600	en-gb	15	-1	\N	0	20	1	\N	1	\N	2		t	t	G	1	D	1	D	1	15	14	14	10	11	11	15	15	3	\N	3	15	14	10	14	14	15	14	\N	\N	14	14	14	t	15	11	1	11	15
\.


--
-- Data for Name: zerver_realmauditlog; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmauditlog (id, event_time, backfilled, extra_data, event_type, event_last_message_id, acting_user_id, modified_user_id, realm_id, modified_stream_id, modified_user_group_id) FROM stdin;
1	2025-03-28 15:35:55.932806+00	f	{}	215	\N	\N	\N	1	\N	\N
2	2025-03-28 15:35:55.947041+00	f	{}	701	\N	\N	\N	1	\N	1
3	2025-03-28 15:35:55.947041+00	f	{}	701	\N	\N	\N	1	\N	2
4	2025-03-28 15:35:55.947041+00	f	{}	701	\N	\N	\N	1	\N	3
5	2025-03-28 15:35:55.947041+00	f	{}	701	\N	\N	\N	1	\N	4
6	2025-03-28 15:35:55.947041+00	f	{}	701	\N	\N	\N	1	\N	5
7	2025-03-28 15:35:55.947041+00	f	{}	701	\N	\N	\N	1	\N	6
8	2025-03-28 15:35:55.947041+00	f	{}	701	\N	\N	\N	1	\N	7
9	2025-03-28 15:35:55.947041+00	f	{}	701	\N	\N	\N	1	\N	8
10	2025-03-28 15:35:55.954699+00	f	{"subgroup_ids": [2]}	705	\N	\N	\N	1	\N	3
11	2025-03-28 15:35:55.954699+00	f	{"supergroup_ids": [3]}	707	\N	\N	\N	1	\N	2
12	2025-03-28 15:35:55.95477+00	f	{"subgroup_ids": [3]}	705	\N	\N	\N	1	\N	4
13	2025-03-28 15:35:55.95477+00	f	{"supergroup_ids": [4]}	707	\N	\N	\N	1	\N	3
14	2025-03-28 15:35:55.954818+00	f	{"subgroup_ids": [4]}	705	\N	\N	\N	1	\N	5
15	2025-03-28 15:35:55.954818+00	f	{"supergroup_ids": [5]}	707	\N	\N	\N	1	\N	4
16	2025-03-28 15:35:55.954864+00	f	{"subgroup_ids": [5]}	705	\N	\N	\N	1	\N	6
17	2025-03-28 15:35:55.954864+00	f	{"supergroup_ids": [6]}	707	\N	\N	\N	1	\N	5
18	2025-03-28 15:35:55.95491+00	f	{"subgroup_ids": [6]}	705	\N	\N	\N	1	\N	7
19	2025-03-28 15:35:55.95491+00	f	{"supergroup_ids": [7]}	707	\N	\N	\N	1	\N	6
20	2025-03-28 15:35:55.954984+00	f	{"subgroup_ids": [7]}	705	\N	\N	\N	1	\N	8
21	2025-03-28 15:35:55.954984+00	f	{"supergroup_ids": [8]}	707	\N	\N	\N	1	\N	7
22	2025-03-28 15:35:55.97361+00	f	{}	101	\N	\N	1	1	\N	\N
23	2025-03-28 15:35:55.973913+00	f	{}	101	\N	\N	2	1	\N	\N
24	2025-03-28 15:35:55.974085+00	f	{}	101	\N	\N	3	1	\N	\N
25	2025-03-28 15:35:55.974222+00	f	{}	101	\N	\N	4	1	\N	\N
26	2025-03-28 15:35:55.974351+00	f	{}	101	\N	\N	5	1	\N	\N
27	2025-03-28 15:35:55.974474+00	f	{}	101	\N	\N	6	1	\N	\N
28	2025-03-28 15:35:55.974597+00	f	{}	101	\N	\N	7	1	\N	\N
29	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	1	1	\N	6
30	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	1	1	\N	5
31	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	2	1	\N	6
32	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	2	1	\N	5
33	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	3	1	\N	6
34	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	3	1	\N	5
35	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	4	1	\N	6
36	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	4	1	\N	5
37	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	5	1	\N	6
38	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	5	1	\N	5
39	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	6	1	\N	6
40	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	6	1	\N	5
41	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	7	1	\N	6
42	2025-03-28 15:35:55.985383+00	f	{}	703	\N	\N	7	1	\N	5
43	2025-03-28 15:35:56.013251+00	f	{"1": false, "2": true, "property": "can_forge_sender"}	108	\N	\N	1	1	\N	\N
45	2025-03-28 15:35:56.029434+00	f	{}	701	\N	\N	\N	2	\N	9
46	2025-03-28 15:35:56.029434+00	f	{}	701	\N	\N	\N	2	\N	10
47	2025-03-28 15:35:56.029434+00	f	{}	701	\N	\N	\N	2	\N	11
48	2025-03-28 15:35:56.029434+00	f	{}	701	\N	\N	\N	2	\N	12
49	2025-03-28 15:35:56.029434+00	f	{}	701	\N	\N	\N	2	\N	13
50	2025-03-28 15:35:56.029434+00	f	{}	701	\N	\N	\N	2	\N	14
51	2025-03-28 15:35:56.029434+00	f	{}	701	\N	\N	\N	2	\N	15
52	2025-03-28 15:35:56.029434+00	f	{}	701	\N	\N	\N	2	\N	16
53	2025-03-28 15:35:56.034775+00	f	{"subgroup_ids": [10]}	705	\N	\N	\N	2	\N	11
54	2025-03-28 15:35:56.034775+00	f	{"supergroup_ids": [11]}	707	\N	\N	\N	2	\N	10
55	2025-03-28 15:35:56.034831+00	f	{"subgroup_ids": [11]}	705	\N	\N	\N	2	\N	12
56	2025-03-28 15:35:56.034831+00	f	{"supergroup_ids": [12]}	707	\N	\N	\N	2	\N	11
57	2025-03-28 15:35:56.034871+00	f	{"subgroup_ids": [12]}	705	\N	\N	\N	2	\N	13
58	2025-03-28 15:35:56.034871+00	f	{"supergroup_ids": [13]}	707	\N	\N	\N	2	\N	12
59	2025-03-28 15:35:56.034909+00	f	{"subgroup_ids": [13]}	705	\N	\N	\N	2	\N	14
60	2025-03-28 15:35:56.034909+00	f	{"supergroup_ids": [14]}	707	\N	\N	\N	2	\N	13
61	2025-03-28 15:35:56.034947+00	f	{"subgroup_ids": [14]}	705	\N	\N	\N	2	\N	15
62	2025-03-28 15:35:56.034947+00	f	{"supergroup_ids": [15]}	707	\N	\N	\N	2	\N	14
63	2025-03-28 15:35:56.035005+00	f	{"subgroup_ids": [15]}	705	\N	\N	\N	2	\N	16
64	2025-03-28 15:35:56.035005+00	f	{"supergroup_ids": [16]}	707	\N	\N	\N	2	\N	15
65	2025-03-28 15:35:56.065308+00	f	{}	601	\N	\N	\N	2	1	\N
66	2025-03-28 15:35:56.074534+00	f	{}	601	\N	\N	\N	2	2	\N
67	2025-03-28 15:35:56.079269+00	f	{}	601	\N	\N	\N	2	3	\N
68	2025-03-28 15:35:56.088784+00	f	{"10": {"11": {"100": 1, "200": 0, "300": 0, "400": 0, "600": 0}, "12": 0}}	101	\N	8	8	2	\N	\N
44	2025-03-28 15:35:56.02457+00	f	{"how_realm_creator_found_zulip": "Prefer not to say", "how_realm_creator_found_zulip_extra_context": ""}	215	\N	8	\N	2	\N	\N
69	2025-03-28 15:35:56.088784+00	f	{}	703	\N	8	8	2	\N	10
70	2025-03-28 15:35:56.370403+00	f	{}	301	12	\N	8	2	1	\N
71	2025-03-28 15:35:56.370403+00	f	{}	301	12	\N	8	2	2	\N
72	2025-03-28 15:35:56.370403+00	f	{}	301	12	\N	8	2	3	\N
73	2025-03-28 15:39:24.61228+00	f	{"1": false, "2": true, "property": "can_create_users"}	108	\N	\N	8	2	\N	\N
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

COPY zulip.zerver_realmdomain (id, domain, allow_subdomains, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmemoji; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmemoji (id, name, file_name, is_animated, deactivated, author_id, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmexport; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmexport (id, type, status, date_requested, date_started, date_succeeded, date_failed, date_deleted, export_path, sha256sum_hex, tarball_size_bytes, stats, acting_user_id, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmfilter; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmfilter (id, pattern, url_template, "order", realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmplayground; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmplayground (id, url_template, name, pygments_language, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmreactivationstatus; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmreactivationstatus (id, status, realm_id) FROM stdin;
\.


--
-- Data for Name: zerver_realmuserdefault; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_realmuserdefault (id, enter_sends, left_side_userlist, default_language, web_home_view, web_escape_navigates_to_home_view, fluid_layout_width, high_contrast_mode, translate_emoticons, display_emoji_reaction_users, twenty_four_hour_time, starred_message_counts, color_scheme, web_font_size_px, web_line_height_percent, web_animate_image_previews, demote_inactive_streams, web_mark_read_on_scroll_policy, web_channel_default_view, emojiset, user_list_style, web_stream_unreads_count_display_policy, web_navigate_to_sent_message, email_notifications_batching_period_seconds, enable_stream_desktop_notifications, enable_stream_email_notifications, enable_stream_push_notifications, enable_stream_audible_notifications, notification_sound, wildcard_mentions_notify, enable_followed_topic_desktop_notifications, enable_followed_topic_email_notifications, enable_followed_topic_push_notifications, enable_followed_topic_audible_notifications, enable_followed_topic_wildcard_mentions_notify, enable_desktop_notifications, pm_content_in_desktop_notifications, enable_sounds, enable_offline_email_notifications, message_content_in_email_notifications, enable_offline_push_notifications, enable_online_push_notifications, desktop_icon_count_display, enable_digest_emails, enable_login_emails, enable_marketing_emails, presence_enabled, realm_name_in_email_notifications_policy, automatically_follow_topics_policy, automatically_unmute_topics_in_muted_streams_policy, automatically_follow_topics_where_mentioned, enable_drafts_synchronization, send_stream_typing_notifications, send_private_typing_notifications, send_read_receipts, receives_typing_notifications, email_address_visibility, realm_id, allow_private_data_export, web_suggest_update_timezone, hide_ai_features) FROM stdin;
1	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	1	f	t	f
2	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	2	f	t	f
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
-- Data for Name: zerver_savedsnippet; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_savedsnippet (id, title, content, date_created, realm_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_scheduledemail; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledemail (id, scheduled_timestamp, data, address, type, realm_id) FROM stdin;
1	2025-04-01 14:35:56.380657+00	{"template_prefix":"zerver/emails/onboarding_zulip_topics","from_name":null,"from_address":"SUPPORT","language":null,"context":{"realm_url":"https://localhost","realm_name":"testing","root_domain_url":"https://localhost","external_url_scheme":"https://","external_host":"localhost","user_name":"tester","corporate_enabled":false,"unsubscribe_link":"https://localhost/accounts/unsubscribe/welcome/hb7o664zca5citjna6jk7ea7","move_messages_link":"https://localhost/help/move-content-to-another-topic","rename_topics_link":"https://localhost/help/rename-a-topic","move_channels_link":"https://localhost/help/move-content-to-another-channel"}}	\N	1	2
2	2025-04-03 14:35:56.381684+00	{"template_prefix":"zerver/emails/onboarding_zulip_guide","from_name":null,"from_address":"SUPPORT","language":null,"context":{"realm_url":"https://localhost","realm_name":"testing","root_domain_url":"https://localhost","external_url_scheme":"https://","external_host":"localhost","user_name":"tester","corporate_enabled":false,"unsubscribe_link":"https://localhost/accounts/unsubscribe/welcome/hb7o664zca5citjna6jk7ea7","organization_type":"opensource","zulip_guide_link":"https://zulip.com/for/open-source/"}}	\N	1	2
3	2025-04-07 14:35:56.382222+00	{"template_prefix":"zerver/emails/onboarding_team_to_zulip","from_name":null,"from_address":"SUPPORT","language":null,"context":{"realm_url":"https://localhost","realm_name":"testing","root_domain_url":"https://localhost","external_url_scheme":"https://","external_host":"localhost","user_name":"tester","corporate_enabled":false,"unsubscribe_link":"https://localhost/accounts/unsubscribe/welcome/hb7o664zca5citjna6jk7ea7","get_organization_started":"https://localhost/help/moving-to-zulip","invite_users":"https://localhost/help/invite-users-to-join","trying_out_zulip":"https://localhost/help/trying-out-zulip","why_zulip":"https://zulip.com/why-zulip/"}}	\N	1	2
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

COPY zulip.zerver_scheduledmessage (id, subject, content, rendered_content, scheduled_timestamp, read_by_sender, delivered, has_attachment, failed, failure_message, delivery_type, delivered_message_id, realm_id, recipient_id, sender_id, sending_client_id, stream_id) FROM stdin;
\.


--
-- Data for Name: zerver_scheduledmessagenotificationemail; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_scheduledmessagenotificationemail (id, trigger, scheduled_timestamp, message_id, user_profile_id, mentioned_user_group_id) FROM stdin;
\.


--
-- Data for Name: zerver_service; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_service (id, name, base_url, token, interface, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_stream; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_stream (id, name, date_created, deactivated, description, rendered_description, invite_only, history_public_to_subscribers, is_web_public, is_in_zephyr_realm, message_retention_days, first_message_id, can_remove_subscribers_group_id, creator_id, realm_id, recipient_id, is_recently_active, can_administer_channel_group_id, can_send_message_group_id, can_add_subscribers_group_id, can_subscribe_group_id) FROM stdin;
2	sandbox	2025-03-28 15:35:56.071065+00	f	Experiment with Zulip here. :test_tube:	<p>Experiment with Zulip here. <span aria-label="test tube" class="emoji emoji-1f9ea" role="img" title="test tube">:test_tube:</span></p>	f	t	f	f	\N	7	11	\N	2	9	t	9	15	9	9
3	general	2025-03-28 15:35:56.077802+00	f	For team-wide conversations	<p>For team-wide conversations</p>	f	t	f	f	\N	9	11	\N	2	10	t	9	15	9	9
1	Zulip	2025-03-28 15:35:56.044153+00	f	Questions and discussion about using Zulip.	<p>Questions and discussion about using Zulip.</p>	f	t	f	f	\N	12	11	\N	2	8	t	9	15	9	9
\.


--
-- Data for Name: zerver_submessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_submessage (id, msg_type, content, message_id, sender_id) FROM stdin;
\.


--
-- Data for Name: zerver_subscription; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_subscription (id, active, is_user_active, is_muted, color, pin_to_top, desktop_notifications, audible_notifications, push_notifications, email_notifications, wildcard_mentions_notify, recipient_id, user_profile_id) FROM stdin;
1	t	t	f	#c2c2c2	f	\N	\N	\N	\N	\N	1	1
2	t	t	f	#c2c2c2	f	\N	\N	\N	\N	\N	2	2
3	t	t	f	#c2c2c2	f	\N	\N	\N	\N	\N	3	3
4	t	t	f	#c2c2c2	f	\N	\N	\N	\N	\N	4	4
5	t	t	f	#c2c2c2	f	\N	\N	\N	\N	\N	5	5
6	t	t	f	#c2c2c2	f	\N	\N	\N	\N	\N	6	6
7	t	t	f	#c2c2c2	f	\N	\N	\N	\N	\N	7	7
8	t	t	f	#c2c2c2	f	\N	\N	\N	\N	\N	11	8
9	t	t	f	#76ce90	f	\N	\N	\N	\N	\N	8	8
10	t	t	f	#fae589	f	\N	\N	\N	\N	\N	9	8
11	t	t	f	#a6c7e5	f	\N	\N	\N	\N	\N	10	8
\.


--
-- Data for Name: zerver_useractivity; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_useractivity (id, query, count, last_visit, client_id, user_profile_id) FROM stdin;
1	log_into_subdomain	1	2025-03-28 15:35:56+00	2	8
2	home_real	1	2025-03-28 15:35:56+00	2	8
3	/api/v1/events/internal	2	2025-03-28 15:35:57+00	5	8
5	get_messages_backend	2	2025-03-28 15:35:57+00	2	8
8	update_message_flags	1	2025-03-28 15:35:57+00	2	8
7	mark_onboarding_step_as_read	2	2025-03-28 15:36:01+00	2	8
6	get_events	9	2025-03-28 15:39:23+00	2	8
\.


--
-- Data for Name: zerver_useractivityinterval; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_useractivityinterval (id, start, "end", user_profile_id) FROM stdin;
1	2025-03-28 15:35:57+00	2025-03-28 15:51:57+00	8
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
17	1
18	1
19	1
20	1
21	1
22	1
23	1
24	1
25	1
26	1
27	1
28	1
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
16	17	7
17	18	7
18	19	7
19	20	7
20	21	7
21	22	7
22	23	7
23	24	7
24	25	7
25	26	7
26	27	7
27	28	7
\.


--
-- Data for Name: zerver_usermessage; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usermessage (id, flags, message_id, user_profile_id) FROM stdin;
1	2	1	8
2	0	2	8
3	2	3	8
4	0	4	8
5	2	5	8
6	0	6	8
7	0	7	8
8	2	8	8
9	0	9	8
10	2	10	8
11	0	11	8
12	0	12	8
14	2048	13	7
13	2051	13	8
\.


--
-- Data for Name: zerver_userpresence; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userpresence (id, last_update_id, last_connected_time, last_active_time, realm_id, user_profile_id) FROM stdin;
1	4	2025-03-28 15:38:57.495099+00	2025-03-28 15:38:57.495099+00	2	8
\.


--
-- Data for Name: zerver_userprofile; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_userprofile (id, password, last_login, is_superuser, enter_sends, left_side_userlist, default_language, web_home_view, web_escape_navigates_to_home_view, fluid_layout_width, high_contrast_mode, translate_emoticons, display_emoji_reaction_users, twenty_four_hour_time, starred_message_counts, color_scheme, web_font_size_px, web_line_height_percent, web_animate_image_previews, demote_inactive_streams, web_mark_read_on_scroll_policy, web_channel_default_view, emojiset, user_list_style, web_stream_unreads_count_display_policy, web_navigate_to_sent_message, email_notifications_batching_period_seconds, enable_stream_desktop_notifications, enable_stream_email_notifications, enable_stream_push_notifications, enable_stream_audible_notifications, notification_sound, wildcard_mentions_notify, enable_followed_topic_desktop_notifications, enable_followed_topic_email_notifications, enable_followed_topic_push_notifications, enable_followed_topic_audible_notifications, enable_followed_topic_wildcard_mentions_notify, enable_desktop_notifications, pm_content_in_desktop_notifications, enable_sounds, enable_offline_email_notifications, message_content_in_email_notifications, enable_offline_push_notifications, enable_online_push_notifications, desktop_icon_count_display, enable_digest_emails, enable_login_emails, enable_marketing_emails, presence_enabled, realm_name_in_email_notifications_policy, automatically_follow_topics_policy, automatically_unmute_topics_in_muted_streams_policy, automatically_follow_topics_where_mentioned, enable_drafts_synchronization, send_stream_typing_notifications, send_private_typing_notifications, send_read_receipts, receives_typing_notifications, email_address_visibility, delivery_email, email, full_name, date_joined, tos_version, api_key, uuid, is_staff, is_active, is_bot, bot_type, role, long_term_idle, last_active_message_id, is_mirror_dummy, can_forge_sender, can_create_users, last_reminder, rate_limits, default_all_public_streams, timezone, avatar_source, avatar_version, avatar_hash, zoom_token, bot_owner_id, realm_id, recipient_id, default_events_register_stream_id, default_sending_stream_id, allow_private_data_export, can_change_user_emails, web_suggest_update_timezone, hide_ai_features) FROM stdin;
2	!pVhIYxUVAbdzQ6O0cUthjBQWbpCAn6fa0auHkiJo	2025-03-28 15:35:55.973913+00	f	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	nagios-receive-bot@zulip.com	nagios-receive-bot@zulip.com	Nagios Receive Bot	2025-03-28 15:35:55.973913+00	\N	buSm42KOrPL4P0iX3IzmeSvorYFj2Y2s	e8114c47-ac36-40c9-98cb-da501ef716d1	f	t	t	1	400	f	\N	f	f	f	\N		f		U	1	\N	\N	2	1	2	\N	\N	f	f	t	f
3	!PGzX32H8qMaodONAaeGe2TGCmPkU3GumTywgmEf9	2025-03-28 15:35:55.974085+00	f	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	nagios-send-bot@zulip.com	nagios-send-bot@zulip.com	Nagios Send Bot	2025-03-28 15:35:55.974085+00	\N	o9YyhIn6faKlq9sEWCPO3RuORZ4PDPZ4	edcaa071-25f8-43bb-a05c-205a52870414	f	t	t	1	400	f	\N	f	f	f	\N		f		U	1	\N	\N	3	1	3	\N	\N	f	f	t	f
4	!tKCBBoQx5ElatU4VIzcIHZCGNxX1L10G78Gn6R1a	2025-03-28 15:35:55.974222+00	f	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	nagios-staging-receive-bot@zulip.com	nagios-staging-receive-bot@zulip.com	Nagios Staging Receive Bot	2025-03-28 15:35:55.974222+00	\N	Cw0E3CndD69fDZH7S7FUMp6bIioh14Wf	f4033d0f-d458-41da-a436-f8d597a82ca0	f	t	t	1	400	f	\N	f	f	f	\N		f		U	1	\N	\N	4	1	4	\N	\N	f	f	t	f
5	!92NmcV2QZe8pHNHyvdfeFxd15cPIysAzTxtEVKYA	2025-03-28 15:35:55.974351+00	f	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	nagios-staging-send-bot@zulip.com	nagios-staging-send-bot@zulip.com	Nagios Staging Send Bot	2025-03-28 15:35:55.974351+00	\N	jAj4bvot5DISA5S0IoqDt7klXZ7AhC48	008cba5c-5c8d-4d8e-b3b3-e481c2bd95c9	f	t	t	1	400	f	\N	f	f	f	\N		f		U	1	\N	\N	5	1	5	\N	\N	f	f	t	f
6	!BkaC0bvvdbiBUO9srb4KqxzCviSJy0MM8FishD7R	2025-03-28 15:35:55.974474+00	f	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	notification-bot@zulip.com	notification-bot@zulip.com	Notification Bot	2025-03-28 15:35:55.974474+00	\N	6z0czgaakdvuHp2jKULwoadT9CmtYnep	90222c1e-102f-4262-a733-9c5aed923809	f	t	t	1	400	f	\N	f	f	f	\N		f		U	1	\N	\N	6	1	6	\N	\N	f	f	t	f
7	!6MLyvq2i7OkImIdgzXaeRBf3h7sxE2g4XCzPHWih	2025-03-28 15:35:55.974597+00	f	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	welcome-bot@zulip.com	welcome-bot@zulip.com	Welcome Bot	2025-03-28 15:35:55.974597+00	\N	62o1phDViIOnXK49UMiJnpp0VkfcvVXg	039efcec-ecad-4322-b19f-2992a2d3ffff	f	t	t	1	400	f	\N	f	f	f	\N		f		U	1	\N	\N	7	1	7	\N	\N	f	f	t	f
1	!ecx3QABNWr53H4NAhkBe1KvpxBHqxsHMX427N8Dt	2025-03-28 15:35:55.97361+00	f	f	f	en	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	t	t	1	3	2	t	t	t	t	t	t	1	emailgateway@zulip.com	emailgateway@zulip.com	Email Gateway	2025-03-28 15:35:55.97361+00	\N	E4ogNd9muKYCIW2ErCOg0p0aTlbVoEIw	a0fc5dfe-0b23-47a9-938c-b14530cc3549	f	t	t	1	400	f	\N	f	t	f	\N		f		U	1	\N	\N	1	1	1	\N	\N	f	f	t	f
8	argon2$argon2id$v=19$m=102400,t=2,p=8$Qk5VdFVtQmNFNGpKNFVGdXRQenQ3Qg$VsRbhfKZ61N2lUH6Z0undoqvzHdVssr5UZpWhxZPztw	2025-03-28 15:35:56.418702+00	f	f	f	en-gb	inbox	t	f	f	f	t	f	t	1	16	140	on_hover	1	1	1	google	3	2	t	120	f	f	f	f	zulip	t	t	t	t	t	t	t	t	t	t	t	t	t	1	t	t	f	t	1	3	2	t	t	t	t	t	t	1	test@test.com	test@test.com	tester	2025-03-28 15:35:56.088784+00	\N	OIFI7BOHTk7512CdLi4hyg110RyICBFU	f47bb784-abda-47db-be0e-222457d82235	f	t	f	\N	100	f	\N	f	f	t	\N		f	Europe/London	G	1	\N	\N	\N	2	11	\N	\N	f	f	t	f
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

COPY zulip.zerver_userstatus (id, reaction_type, "timestamp", emoji_name, emoji_code, status_text, client_id, user_profile_id) FROM stdin;
\.


--
-- Data for Name: zerver_usertopic; Type: TABLE DATA; Schema: zulip; Owner: zulip
--

COPY zulip.zerver_usertopic (id, topic_name, last_updated, visibility_policy, recipient_id, stream_id, user_profile_id) FROM stdin;
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

SELECT pg_catalog.setval('zulip.auth_permission_id_seq', 324, true);


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

SELECT pg_catalog.setval('zulip.django_content_type_id_seq', 81, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.django_migrations_id_seq', 769, true);


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
-- Name: zerver_botconfigdata_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_botconfigdata_id_seq', 1, false);


--
-- Name: zerver_botstoragedata_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_botstoragedata_id_seq', 1, false);


--
-- Name: zerver_channelemailaddress_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_channelemailaddress_id_seq', 1, false);


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
-- Name: zerver_multiuseinvite_groups_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_multiuseinvite_groups_id_seq', 1, false);


--
-- Name: zerver_multiuseinvite_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_multiuseinvite_id_seq', 1, false);


--
-- Name: zerver_multiuseinvite_streams_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_multiuseinvite_streams_id_seq', 1, false);


--
-- Name: zerver_muteduser_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_muteduser_id_seq', 1, false);


--
-- Name: zerver_onboardingstep_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_onboardingstep_id_seq', 3, true);


--
-- Name: zerver_onboardingusermessage_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_onboardingusermessage_id_seq', 12, true);


--
-- Name: zerver_preregistrationrealm_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_preregistrationrealm_id_seq', 1, true);


--
-- Name: zerver_preregistrationuser_groups_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_preregistrationuser_groups_id_seq', 1, false);


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
-- Name: zerver_realmauditlog_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmauditlog_id_seq', 73, true);


--
-- Name: zerver_realmauthenticationmethod_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmauthenticationmethod_id_seq', 22, true);


--
-- Name: zerver_realmdomain_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmdomain_id_seq', 1, false);


--
-- Name: zerver_realmemoji_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmemoji_id_seq', 1, false);


--
-- Name: zerver_realmexport_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_realmexport_id_seq', 1, false);


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
-- Name: zerver_savedsnippet_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_savedsnippet_id_seq', 1, false);


--
-- Name: zerver_scheduledemail_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledemail_id_seq', 3, true);


--
-- Name: zerver_scheduledemail_users_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_scheduledemail_users_id_seq', 3, true);


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

SELECT pg_catalog.setval('zulip.zerver_usergroup_id_seq', 28, true);


--
-- Name: zerver_usergroupmembership_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_usergroupmembership_id_seq', 27, true);


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
-- Name: zerver_usertopic_id_seq; Type: SEQUENCE SET; Schema: zulip; Owner: zulip
--

SELECT pg_catalog.setval('zulip.zerver_usertopic_id_seq', 1, false);


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
-- Name: zerver_archivedattachment zerver_archivedattachment_path_id_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_archivedattachment
    ADD CONSTRAINT zerver_archivedattachment_path_id_key UNIQUE (path_id);


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
-- Name: zerver_attachment zerver_attachment_path_id_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_attachment
    ADD CONSTRAINT zerver_attachment_path_id_key UNIQUE (path_id);


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
-- Name: zerver_botconfigdata zerver_botconfigdata_bot_profile_id_key_5bc59cb2_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botconfigdata
    ADD CONSTRAINT zerver_botconfigdata_bot_profile_id_key_5bc59cb2_uniq UNIQUE (bot_profile_id, key);


--
-- Name: zerver_botconfigdata zerver_botconfigdata_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botconfigdata
    ADD CONSTRAINT zerver_botconfigdata_pkey PRIMARY KEY (id);


--
-- Name: zerver_botstoragedata zerver_botstoragedata_bot_profile_id_key_494e4922_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botstoragedata
    ADD CONSTRAINT zerver_botstoragedata_bot_profile_id_key_494e4922_uniq UNIQUE (bot_profile_id, key);


--
-- Name: zerver_botstoragedata zerver_botstoragedata_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botstoragedata
    ADD CONSTRAINT zerver_botstoragedata_pkey PRIMARY KEY (id);


--
-- Name: zerver_channelemailaddress zerver_channelemailaddre_channel_id_creator_id_se_9bca7f8f_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_channelemailaddress
    ADD CONSTRAINT zerver_channelemailaddre_channel_id_creator_id_se_9bca7f8f_uniq UNIQUE (channel_id, creator_id, sender_id);


--
-- Name: zerver_channelemailaddress zerver_channelemailaddress_email_token_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_channelemailaddress
    ADD CONSTRAINT zerver_channelemailaddress_email_token_key UNIQUE (email_token);


--
-- Name: zerver_channelemailaddress zerver_channelemailaddress_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_channelemailaddress
    ADD CONSTRAINT zerver_channelemailaddress_pkey PRIMARY KEY (id);


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
-- Name: zerver_multiuseinvite_groups zerver_multiuseinvite_gr_multiuseinvite_id_namedu_d9ad5782_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_groups
    ADD CONSTRAINT zerver_multiuseinvite_gr_multiuseinvite_id_namedu_d9ad5782_uniq UNIQUE (multiuseinvite_id, namedusergroup_id);


--
-- Name: zerver_multiuseinvite_groups zerver_multiuseinvite_groups_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_groups
    ADD CONSTRAINT zerver_multiuseinvite_groups_pkey PRIMARY KEY (id);


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
-- Name: zerver_onboardingstep zerver_onboardingstep_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_onboardingstep
    ADD CONSTRAINT zerver_onboardingstep_pkey PRIMARY KEY (id);


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
-- Name: zerver_preregistrationuser_groups zerver_preregistrationus_preregistrationuser_id_n_d2ef9516_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_groups
    ADD CONSTRAINT zerver_preregistrationus_preregistrationuser_id_n_d2ef9516_uniq UNIQUE (preregistrationuser_id, namedusergroup_id);


--
-- Name: zerver_preregistrationuser_streams zerver_preregistrationus_preregistrationuser_id_s_d8befabf_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams
    ADD CONSTRAINT zerver_preregistrationus_preregistrationuser_id_s_d8befabf_uniq UNIQUE (preregistrationuser_id, stream_id);


--
-- Name: zerver_preregistrationuser_groups zerver_preregistrationuser_groups_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_groups
    ADD CONSTRAINT zerver_preregistrationuser_groups_pkey PRIMARY KEY (id);


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
-- Name: zerver_realm zerver_realm_string_id_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_string_id_key UNIQUE (string_id);


--
-- Name: zerver_realm zerver_realm_uuid_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_uuid_key UNIQUE (uuid);


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
-- Name: zerver_realmdomain zerver_realmdomain_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmdomain
    ADD CONSTRAINT zerver_realmdomain_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmdomain zerver_realmdomain_realm_id_domain_cb8b8d66_uniq; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmdomain
    ADD CONSTRAINT zerver_realmdomain_realm_id_domain_cb8b8d66_uniq UNIQUE (realm_id, domain);


--
-- Name: zerver_realmemoji zerver_realmemoji_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmemoji
    ADD CONSTRAINT zerver_realmemoji_pkey PRIMARY KEY (id);


--
-- Name: zerver_realmexport zerver_realmexport_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmexport
    ADD CONSTRAINT zerver_realmexport_pkey PRIMARY KEY (id);


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
-- Name: zerver_realmuserdefault zerver_realmuserdefault_realm_id_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmuserdefault
    ADD CONSTRAINT zerver_realmuserdefault_realm_id_key UNIQUE (realm_id);


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
-- Name: zerver_savedsnippet zerver_savedsnippet_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_savedsnippet
    ADD CONSTRAINT zerver_savedsnippet_pkey PRIMARY KEY (id);


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
-- Name: zerver_userprofile zerver_userprofile_api_key_key; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_userprofile
    ADD CONSTRAINT zerver_userprofile_api_key_key UNIQUE (api_key);


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
-- Name: zerver_usertopic zerver_usertopic_pkey; Type: CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_usertopic_pkey PRIMARY KEY (id);


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
-- Name: confirmatio_content_80155a_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX confirmatio_content_80155a_idx ON zulip.confirmation_confirmation USING btree (content_type_id, object_id);


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
-- Name: zerver_archivedmessage_date_sent_cdccea72; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_date_sent_cdccea72 ON zulip.zerver_archivedmessage USING btree (date_sent);


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
-- Name: zerver_archivedmessage_is_channel_message_3eda715b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivedmessage_is_channel_message_3eda715b ON zulip.zerver_archivedmessage USING btree (is_channel_message);


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
-- Name: zerver_archivetransaction_protect_from_deletion_a67491c1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_archivetransaction_protect_from_deletion_a67491c1 ON zulip.zerver_archivetransaction USING btree (protect_from_deletion);


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
-- Name: zerver_attachment_file_name_25dddc06_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_attachment_file_name_25dddc06_like ON zulip.zerver_attachment USING btree (file_name text_pattern_ops);


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
-- Name: zerver_botconfigdata_bot_profile_id_9e645648; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botconfigdata_bot_profile_id_9e645648 ON zulip.zerver_botconfigdata USING btree (bot_profile_id);


--
-- Name: zerver_botconfigdata_key_77c7a44b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botconfigdata_key_77c7a44b ON zulip.zerver_botconfigdata USING btree (key);


--
-- Name: zerver_botconfigdata_key_77c7a44b_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botconfigdata_key_77c7a44b_like ON zulip.zerver_botconfigdata USING btree (key text_pattern_ops);


--
-- Name: zerver_botstoragedata_bot_profile_id_69e55d89; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botstoragedata_bot_profile_id_69e55d89 ON zulip.zerver_botstoragedata USING btree (bot_profile_id);


--
-- Name: zerver_botstoragedata_key_7f566fdd; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botstoragedata_key_7f566fdd ON zulip.zerver_botstoragedata USING btree (key);


--
-- Name: zerver_botstoragedata_key_7f566fdd_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_botstoragedata_key_7f566fdd_like ON zulip.zerver_botstoragedata USING btree (key text_pattern_ops);


--
-- Name: zerver_channelemailaddress_channel_id_1510d1fc; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_channelemailaddress_channel_id_1510d1fc ON zulip.zerver_channelemailaddress USING btree (channel_id);


--
-- Name: zerver_channelemailaddress_creator_id_9ff113fe; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_channelemailaddress_creator_id_9ff113fe ON zulip.zerver_channelemailaddress USING btree (creator_id);


--
-- Name: zerver_channelemailaddress_email_token_fb704ac6_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_channelemailaddress_email_token_fb704ac6_like ON zulip.zerver_channelemailaddress USING btree (email_token varchar_pattern_ops);


--
-- Name: zerver_channelemailaddress_realm_id_5d78bd6b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_channelemailaddress_realm_id_5d78bd6b ON zulip.zerver_channelemailaddress USING btree (realm_id);


--
-- Name: zerver_channelemailaddress_realm_id_channel_id_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_channelemailaddress_realm_id_channel_id_idx ON zulip.zerver_channelemailaddress USING btree (realm_id, channel_id);


--
-- Name: zerver_channelemailaddress_sender_id_05370b5c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_channelemailaddress_sender_id_05370b5c ON zulip.zerver_channelemailaddress USING btree (sender_id);


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
-- Name: zerver_message_edit_history_id; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_edit_history_id ON zulip.zerver_message USING btree (id) WHERE (edit_history IS NOT NULL);


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
-- Name: zerver_message_is_channel_message_ca4058ca; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_is_channel_message_ca4058ca ON zulip.zerver_message USING btree (is_channel_message);


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

CREATE INDEX zerver_message_realm_recipient_subject ON zulip.zerver_message USING btree (realm_id, recipient_id, subject, id DESC NULLS LAST) WHERE is_channel_message;


--
-- Name: zerver_message_realm_recipient_upper_subject; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_recipient_upper_subject ON zulip.zerver_message USING btree (realm_id, recipient_id, upper((subject)::text), id DESC NULLS LAST) WHERE is_channel_message;


--
-- Name: zerver_message_realm_sender_recipient; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_sender_recipient ON zulip.zerver_message USING btree (realm_id, sender_id, recipient_id);


--
-- Name: zerver_message_realm_upper_subject; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_message_realm_upper_subject ON zulip.zerver_message USING btree (realm_id, upper((subject)::text), id DESC NULLS LAST) WHERE is_channel_message;


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
-- Name: zerver_multiuseinvite_groups_multiuseinvite_id_c4ae2eaf; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_multiuseinvite_groups_multiuseinvite_id_c4ae2eaf ON zulip.zerver_multiuseinvite_groups USING btree (multiuseinvite_id);


--
-- Name: zerver_multiuseinvite_groups_namedusergroup_id_db3a6bc2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_multiuseinvite_groups_namedusergroup_id_db3a6bc2 ON zulip.zerver_multiuseinvite_groups USING btree (namedusergroup_id);


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
-- Name: zerver_mutedtopic_stream_topic; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_mutedtopic_stream_topic ON zulip.zerver_usertopic USING btree (stream_id, upper((topic_name)::text));


--
-- Name: zerver_muteduser_muted_user_id_d4b66dff; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_muteduser_muted_user_id_d4b66dff ON zulip.zerver_muteduser USING btree (muted_user_id);


--
-- Name: zerver_muteduser_user_profile_id_aeb57a40; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_muteduser_user_profile_id_aeb57a40 ON zulip.zerver_muteduser USING btree (user_profile_id);


--
-- Name: zerver_namedusergroup_can_add_members_group_id_0767fb27; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_can_add_members_group_id_0767fb27 ON zulip.zerver_namedusergroup USING btree (can_add_members_group_id);


--
-- Name: zerver_namedusergroup_can_join_group_id_bf53b7e9; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_can_join_group_id_bf53b7e9 ON zulip.zerver_namedusergroup USING btree (can_join_group_id);


--
-- Name: zerver_namedusergroup_can_leave_group_id_389c15f4; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_can_leave_group_id_389c15f4 ON zulip.zerver_namedusergroup USING btree (can_leave_group_id);


--
-- Name: zerver_namedusergroup_can_manage_group_id_32c7cdf2; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_can_manage_group_id_32c7cdf2 ON zulip.zerver_namedusergroup USING btree (can_manage_group_id);


--
-- Name: zerver_namedusergroup_can_mention_group_id_39bf278e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_can_mention_group_id_39bf278e ON zulip.zerver_namedusergroup USING btree (can_mention_group_id);


--
-- Name: zerver_namedusergroup_can_remove_members_group_id_28ef9252; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_can_remove_members_group_id_28ef9252 ON zulip.zerver_namedusergroup USING btree (can_remove_members_group_id);


--
-- Name: zerver_namedusergroup_creator_id_c8fde7ca; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_namedusergroup_creator_id_c8fde7ca ON zulip.zerver_namedusergroup USING btree (creator_id);


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
-- Name: zerver_preregistrationuser_groups_namedusergroup_id_6d9d3d4c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_groups_namedusergroup_id_6d9d3d4c ON zulip.zerver_preregistrationuser_groups USING btree (namedusergroup_id);


--
-- Name: zerver_preregistrationuser_multiuse_invite_id_7747603e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_multiuse_invite_id_7747603e ON zulip.zerver_preregistrationuser USING btree (multiuse_invite_id);


--
-- Name: zerver_preregistrationuser_preregistrationuser_id_332ca855; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_preregistrationuser_id_332ca855 ON zulip.zerver_preregistrationuser_streams USING btree (preregistrationuser_id);


--
-- Name: zerver_preregistrationuser_preregistrationuser_id_d806111d; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_preregistrationuser_preregistrationuser_id_d806111d ON zulip.zerver_preregistrationuser_groups USING btree (preregistrationuser_id);


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
-- Name: zerver_realm_can_add_custom_emoji_group_id_b6f75c21; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_add_custom_emoji_group_id_b6f75c21 ON zulip.zerver_realm USING btree (can_add_custom_emoji_group_id);


--
-- Name: zerver_realm_can_add_subscribers_group_id_a48fb661; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_add_subscribers_group_id_a48fb661 ON zulip.zerver_realm USING btree (can_add_subscribers_group_id);


--
-- Name: zerver_realm_can_create_bots_group_id_f031e505; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_create_bots_group_id_f031e505 ON zulip.zerver_realm USING btree (can_create_bots_group_id);


--
-- Name: zerver_realm_can_create_groups_id_03f8febb; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_create_groups_id_03f8febb ON zulip.zerver_realm USING btree (can_create_groups_id);


--
-- Name: zerver_realm_can_create_private_channel_group_id_ba294d86; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_create_private_channel_group_id_ba294d86 ON zulip.zerver_realm USING btree (can_create_private_channel_group_id);


--
-- Name: zerver_realm_can_create_public_channel_group_id_6eb35b68; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_create_public_channel_group_id_6eb35b68 ON zulip.zerver_realm USING btree (can_create_public_channel_group_id);


--
-- Name: zerver_realm_can_create_web_public_channel_group_id_725f9aa6; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_create_web_public_channel_group_id_725f9aa6 ON zulip.zerver_realm USING btree (can_create_web_public_channel_group_id);


--
-- Name: zerver_realm_can_create_write_only_bots_group_id_db352a71; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_create_write_only_bots_group_id_db352a71 ON zulip.zerver_realm USING btree (can_create_write_only_bots_group_id);


--
-- Name: zerver_realm_can_delete_any_message_group_id_3a19fdec; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_delete_any_message_group_id_3a19fdec ON zulip.zerver_realm USING btree (can_delete_any_message_group_id);


--
-- Name: zerver_realm_can_delete_own_message_group_id_f5a22b08; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_delete_own_message_group_id_f5a22b08 ON zulip.zerver_realm USING btree (can_delete_own_message_group_id);


--
-- Name: zerver_realm_can_invite_users_group_id_79a5cd08; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_invite_users_group_id_79a5cd08 ON zulip.zerver_realm USING btree (can_invite_users_group_id);


--
-- Name: zerver_realm_can_manage_all_groups_id_76b03cf7; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_manage_all_groups_id_76b03cf7 ON zulip.zerver_realm USING btree (can_manage_all_groups_id);


--
-- Name: zerver_realm_can_manage_billing_group_id_5d2b10c3; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_manage_billing_group_id_5d2b10c3 ON zulip.zerver_realm USING btree (can_manage_billing_group_id);


--
-- Name: zerver_realm_can_mention_many_users_group_id_f23d5db8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_mention_many_users_group_id_f23d5db8 ON zulip.zerver_realm USING btree (can_mention_many_users_group_id);


--
-- Name: zerver_realm_can_move_messages_between__35537010; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_move_messages_between__35537010 ON zulip.zerver_realm USING btree (can_move_messages_between_channels_group_id);


--
-- Name: zerver_realm_can_move_messages_between_topics_group_id_894ec9a1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_move_messages_between_topics_group_id_894ec9a1 ON zulip.zerver_realm USING btree (can_move_messages_between_topics_group_id);


--
-- Name: zerver_realm_can_resolve_topics_group_id_24551ba1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_resolve_topics_group_id_24551ba1 ON zulip.zerver_realm USING btree (can_resolve_topics_group_id);


--
-- Name: zerver_realm_can_summarize_topics_group_id_0c954718; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_can_summarize_topics_group_id_0c954718 ON zulip.zerver_realm USING btree (can_summarize_topics_group_id);


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
-- Name: zerver_realm_moderation_request_channel_id_1fd26794; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_moderation_request_channel_id_1fd26794 ON zulip.zerver_realm USING btree (moderation_request_channel_id);


--
-- Name: zerver_realm_new_stream_announcements_stream_id_dc0a0303; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_new_stream_announcements_stream_id_dc0a0303 ON zulip.zerver_realm USING btree (new_stream_announcements_stream_id);


--
-- Name: zerver_realm_push_notifications_enabled_f806b849; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_push_notifications_enabled_f806b849 ON zulip.zerver_realm USING btree (push_notifications_enabled);


--
-- Name: zerver_realm_scheduled_deletion_date_5a66dac5; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_scheduled_deletion_date_5a66dac5 ON zulip.zerver_realm USING btree (scheduled_deletion_date);


--
-- Name: zerver_realm_signup_announcements_stream_id_9bdc4b8b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_signup_announcements_stream_id_9bdc4b8b ON zulip.zerver_realm USING btree (signup_announcements_stream_id);


--
-- Name: zerver_realm_string_id_a183c4ff_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realm_string_id_a183c4ff_like ON zulip.zerver_realm USING btree (string_id varchar_pattern_ops);


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
-- Name: zerver_realmdomain_domain_cbae9d44; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmdomain_domain_cbae9d44 ON zulip.zerver_realmdomain USING btree (domain);


--
-- Name: zerver_realmdomain_domain_cbae9d44_like; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmdomain_domain_cbae9d44_like ON zulip.zerver_realmdomain USING btree (domain varchar_pattern_ops);


--
-- Name: zerver_realmdomain_realm_id_06e7fec3; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmdomain_realm_id_06e7fec3 ON zulip.zerver_realmdomain USING btree (realm_id);


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
-- Name: zerver_realmexport_acting_user_id_5d48fd1c; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmexport_acting_user_id_5d48fd1c ON zulip.zerver_realmexport USING btree (acting_user_id);


--
-- Name: zerver_realmexport_realm_id_3f314ca8; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_realmexport_realm_id_3f314ca8 ON zulip.zerver_realmexport USING btree (realm_id);


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
-- Name: zerver_savedsnippet_realm_id_c97e4aee; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_savedsnippet_realm_id_c97e4aee ON zulip.zerver_savedsnippet USING btree (realm_id);


--
-- Name: zerver_savedsnippet_user_profile_id_43f0d808; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_savedsnippet_user_profile_id_43f0d808 ON zulip.zerver_savedsnippet USING btree (user_profile_id);


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
-- Name: zerver_stream_can_add_subscribers_group_id_7b78ce53; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_can_add_subscribers_group_id_7b78ce53 ON zulip.zerver_stream USING btree (can_add_subscribers_group_id);


--
-- Name: zerver_stream_can_administer_channel_group_id_6d9b6d1a; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_can_administer_channel_group_id_6d9b6d1a ON zulip.zerver_stream USING btree (can_administer_channel_group_id);


--
-- Name: zerver_stream_can_remove_subscribers_group_id_ce4fe4b7; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_can_remove_subscribers_group_id_ce4fe4b7 ON zulip.zerver_stream USING btree (can_remove_subscribers_group_id);


--
-- Name: zerver_stream_can_send_message_group_id_52ab4abe; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_can_send_message_group_id_52ab4abe ON zulip.zerver_stream USING btree (can_send_message_group_id);


--
-- Name: zerver_stream_can_subscribe_group_id_6e6a3b7e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_can_subscribe_group_id_6e6a3b7e ON zulip.zerver_stream USING btree (can_subscribe_group_id);


--
-- Name: zerver_stream_creator_id_65aeba7e; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_stream_creator_id_65aeba7e ON zulip.zerver_stream USING btree (creator_id);


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
-- Name: zerver_userprofile_can_change_user_emails_f1463466; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_can_change_user_emails_f1463466 ON zulip.zerver_userprofile USING btree (can_change_user_emails);


--
-- Name: zerver_userprofile_can_create_users_7a0f136d; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_can_create_users_7a0f136d ON zulip.zerver_userprofile USING btree (can_create_users);


--
-- Name: zerver_userprofile_can_forge_sender_7f82274b; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_userprofile_can_forge_sender_7f82274b ON zulip.zerver_userprofile USING btree (can_forge_sender);


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
-- Name: zerver_usertopic_recipient_id_2215b0a7; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usertopic_recipient_id_2215b0a7 ON zulip.zerver_usertopic USING btree (recipient_id);


--
-- Name: zerver_usertopic_stream_id_0ce5ea26; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usertopic_stream_id_0ce5ea26 ON zulip.zerver_usertopic USING btree (stream_id);


--
-- Name: zerver_usertopic_stream_topic_user_visibility_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usertopic_stream_topic_user_visibility_idx ON zulip.zerver_usertopic USING btree (stream_id, topic_name, visibility_policy, user_profile_id);


--
-- Name: zerver_usertopic_user_profile_id_28608df1; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usertopic_user_profile_id_28608df1 ON zulip.zerver_usertopic USING btree (user_profile_id);


--
-- Name: zerver_usertopic_user_visibility_idx; Type: INDEX; Schema: zulip; Owner: zulip
--

CREATE INDEX zerver_usertopic_user_visibility_idx ON zulip.zerver_usertopic USING btree (user_profile_id, visibility_policy, stream_id, topic_name);


--
-- Name: zerver_message_realm_recipient; Type: STATISTICS; Schema: zulip; Owner: zulip
--

CREATE STATISTICS zulip.zerver_message_realm_recipient ON realm_id, recipient_id FROM zulip.zerver_message;


ALTER STATISTICS zulip.zerver_message_realm_recipient OWNER TO zulip;

--
-- Name: zerver_message_realm_sender; Type: STATISTICS; Schema: zulip; Owner: zulip
--

CREATE STATISTICS zulip.zerver_message_realm_sender ON sender_id, realm_id FROM zulip.zerver_message;


ALTER STATISTICS zulip.zerver_message_realm_sender OWNER TO zulip;

--
-- Name: zerver_message_subject_is_channel_message; Type: STATISTICS; Schema: zulip; Owner: zulip
--

CREATE STATISTICS zulip.zerver_message_subject_is_channel_message ON subject, is_channel_message FROM zulip.zerver_message;
ALTER STATISTICS zulip.zerver_message_subject_is_channel_message SET STATISTICS 1500;


ALTER STATISTICS zulip.zerver_message_subject_is_channel_message OWNER TO zulip;

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
-- Name: zerver_botconfigdata zerver_botconfigdata_bot_profile_id_9e645648_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botconfigdata
    ADD CONSTRAINT zerver_botconfigdata_bot_profile_id_9e645648_fk_zerver_us FOREIGN KEY (bot_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_botstoragedata zerver_botstoragedat_bot_profile_id_69e55d89_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_botstoragedata
    ADD CONSTRAINT zerver_botstoragedat_bot_profile_id_69e55d89_fk_zerver_us FOREIGN KEY (bot_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_channelemailaddress zerver_channelemaila_channel_id_1510d1fc_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_channelemailaddress
    ADD CONSTRAINT zerver_channelemaila_channel_id_1510d1fc_fk_zerver_st FOREIGN KEY (channel_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_channelemailaddress zerver_channelemaila_creator_id_9ff113fe_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_channelemailaddress
    ADD CONSTRAINT zerver_channelemaila_creator_id_9ff113fe_fk_zerver_us FOREIGN KEY (creator_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_channelemailaddress zerver_channelemaila_sender_id_05370b5c_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_channelemailaddress
    ADD CONSTRAINT zerver_channelemaila_sender_id_05370b5c_fk_zerver_us FOREIGN KEY (sender_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_channelemailaddress zerver_channelemailaddress_realm_id_5d78bd6b_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_channelemailaddress
    ADD CONSTRAINT zerver_channelemailaddress_realm_id_5d78bd6b_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_groupgroupmembership zerver_groupgroupmem_subgroup_id_3ec521bb_fk_zerver_na; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_groupgroupmembership
    ADD CONSTRAINT zerver_groupgroupmem_subgroup_id_3ec521bb_fk_zerver_na FOREIGN KEY (subgroup_id) REFERENCES zulip.zerver_namedusergroup(usergroup_ptr_id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_multiuseinvite_streams zerver_multiuseinvit_multiuseinvite_id_be033d7f_fk_zerver_mu; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_streams
    ADD CONSTRAINT zerver_multiuseinvit_multiuseinvite_id_be033d7f_fk_zerver_mu FOREIGN KEY (multiuseinvite_id) REFERENCES zulip.zerver_multiuseinvite(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite_groups zerver_multiuseinvit_multiuseinvite_id_c4ae2eaf_fk_zerver_mu; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_groups
    ADD CONSTRAINT zerver_multiuseinvit_multiuseinvite_id_c4ae2eaf_fk_zerver_mu FOREIGN KEY (multiuseinvite_id) REFERENCES zulip.zerver_multiuseinvite(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_multiuseinvite_groups zerver_multiuseinvit_namedusergroup_id_db3a6bc2_fk_zerver_na; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_multiuseinvite_groups
    ADD CONSTRAINT zerver_multiuseinvit_namedusergroup_id_db3a6bc2_fk_zerver_na FOREIGN KEY (namedusergroup_id) REFERENCES zulip.zerver_namedusergroup(usergroup_ptr_id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_namedusergroup zerver_namedusergrou_can_add_members_grou_0767fb27_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergrou_can_add_members_grou_0767fb27_fk_zerver_us FOREIGN KEY (can_add_members_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergrou_can_join_group_id_bf53b7e9_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergrou_can_join_group_id_bf53b7e9_fk_zerver_us FOREIGN KEY (can_join_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergrou_can_leave_group_id_389c15f4_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergrou_can_leave_group_id_389c15f4_fk_zerver_us FOREIGN KEY (can_leave_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergrou_can_manage_group_id_32c7cdf2_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergrou_can_manage_group_id_32c7cdf2_fk_zerver_us FOREIGN KEY (can_manage_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergrou_can_mention_group_id_39bf278e_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergrou_can_mention_group_id_39bf278e_fk_zerver_us FOREIGN KEY (can_mention_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergrou_can_remove_members_g_28ef9252_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergrou_can_remove_members_g_28ef9252_fk_zerver_us FOREIGN KEY (can_remove_members_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergrou_creator_id_c8fde7ca_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergrou_creator_id_c8fde7ca_fk_zerver_us FOREIGN KEY (creator_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergrou_usergroup_ptr_id_684bf3ca_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergrou_usergroup_ptr_id_684bf3ca_fk_zerver_us FOREIGN KEY (usergroup_ptr_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_namedusergroup zerver_namedusergroup_realm_id_f1b966ff_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_namedusergroup
    ADD CONSTRAINT zerver_namedusergroup_realm_id_f1b966ff_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_preregistrationuser zerver_preregistrati_multiuse_invite_id_7747603e_fk_zerver_mu; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser
    ADD CONSTRAINT zerver_preregistrati_multiuse_invite_id_7747603e_fk_zerver_mu FOREIGN KEY (multiuse_invite_id) REFERENCES zulip.zerver_multiuseinvite(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser_groups zerver_preregistrati_namedusergroup_id_6d9d3d4c_fk_zerver_na; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_groups
    ADD CONSTRAINT zerver_preregistrati_namedusergroup_id_6d9d3d4c_fk_zerver_na FOREIGN KEY (namedusergroup_id) REFERENCES zulip.zerver_namedusergroup(usergroup_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser_streams zerver_preregistrati_preregistrationuser__332ca855_fk_zerver_pr; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_streams
    ADD CONSTRAINT zerver_preregistrati_preregistrationuser__332ca855_fk_zerver_pr FOREIGN KEY (preregistrationuser_id) REFERENCES zulip.zerver_preregistrationuser(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_preregistrationuser_groups zerver_preregistrati_preregistrationuser__d806111d_fk_zerver_pr; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_preregistrationuser_groups
    ADD CONSTRAINT zerver_preregistrati_preregistrationuser__d806111d_fk_zerver_pr FOREIGN KEY (preregistrationuser_id) REFERENCES zulip.zerver_preregistrationuser(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_realm zerver_realm_can_access_all_users_692c7cc6_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_access_all_users_692c7cc6_fk_zerver_us FOREIGN KEY (can_access_all_users_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_add_custom_emoji_b6f75c21_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_add_custom_emoji_b6f75c21_fk_zerver_us FOREIGN KEY (can_add_custom_emoji_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_add_subscribers__a48fb661_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_add_subscribers__a48fb661_fk_zerver_us FOREIGN KEY (can_add_subscribers_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_create_bots_grou_f031e505_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_create_bots_grou_f031e505_fk_zerver_us FOREIGN KEY (can_create_bots_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_create_groups_id_03f8febb_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_create_groups_id_03f8febb_fk_zerver_us FOREIGN KEY (can_create_groups_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_realm zerver_realm_can_create_web_publi_725f9aa6_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_create_web_publi_725f9aa6_fk_zerver_us FOREIGN KEY (can_create_web_public_channel_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_create_write_onl_db352a71_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_create_write_onl_db352a71_fk_zerver_us FOREIGN KEY (can_create_write_only_bots_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_delete_any_messa_3a19fdec_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_delete_any_messa_3a19fdec_fk_zerver_us FOREIGN KEY (can_delete_any_message_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_delete_own_messa_f5a22b08_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_delete_own_messa_f5a22b08_fk_zerver_us FOREIGN KEY (can_delete_own_message_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_invite_users_gro_79a5cd08_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_invite_users_gro_79a5cd08_fk_zerver_us FOREIGN KEY (can_invite_users_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_manage_all_group_76b03cf7_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_manage_all_group_76b03cf7_fk_zerver_us FOREIGN KEY (can_manage_all_groups_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_manage_billing_g_5d2b10c3_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_manage_billing_g_5d2b10c3_fk_zerver_us FOREIGN KEY (can_manage_billing_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_mention_many_use_f23d5db8_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_mention_many_use_f23d5db8_fk_zerver_us FOREIGN KEY (can_mention_many_users_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_move_messages_be_35537010_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_move_messages_be_35537010_fk_zerver_us FOREIGN KEY (can_move_messages_between_channels_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_move_messages_be_894ec9a1_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_move_messages_be_894ec9a1_fk_zerver_us FOREIGN KEY (can_move_messages_between_topics_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_resolve_topics_g_24551ba1_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_resolve_topics_g_24551ba1_fk_zerver_us FOREIGN KEY (can_resolve_topics_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_can_summarize_topics_0c954718_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_can_summarize_topics_0c954718_fk_zerver_us FOREIGN KEY (can_summarize_topics_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_create_multiuse_invi_28a8b9cb_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_create_multiuse_invi_28a8b9cb_fk_zerver_us FOREIGN KEY (create_multiuse_invite_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_realm zerver_realm_moderation_request_c_1fd26794_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_moderation_request_c_1fd26794_fk_zerver_st FOREIGN KEY (moderation_request_channel_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_new_stream_announcem_dc0a0303_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_new_stream_announcem_dc0a0303_fk_zerver_st FOREIGN KEY (new_stream_announcements_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_signup_announcements_9bdc4b8b_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_signup_announcements_9bdc4b8b_fk_zerver_st FOREIGN KEY (signup_announcements_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realm zerver_realm_zulip_update_announc_b7809c68_fk_zerver_st; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realm
    ADD CONSTRAINT zerver_realm_zulip_update_announc_b7809c68_fk_zerver_st FOREIGN KEY (zulip_update_announcements_stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_realmauditlog zerver_realmauditlog_modified_user_group__56329312_fk_zerver_na; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmauditlog
    ADD CONSTRAINT zerver_realmauditlog_modified_user_group__56329312_fk_zerver_na FOREIGN KEY (modified_user_group_id) REFERENCES zulip.zerver_namedusergroup(usergroup_ptr_id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_realmdomain zerver_realmdomain_realm_id_06e7fec3_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmdomain
    ADD CONSTRAINT zerver_realmdomain_realm_id_06e7fec3_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_realmexport zerver_realmexport_acting_user_id_5d48fd1c_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmexport
    ADD CONSTRAINT zerver_realmexport_acting_user_id_5d48fd1c_fk_zerver_us FOREIGN KEY (acting_user_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_realmexport zerver_realmexport_realm_id_3f314ca8_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_realmexport
    ADD CONSTRAINT zerver_realmexport_realm_id_3f314ca8_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_savedsnippet zerver_savedsnippet_realm_id_c97e4aee_fk_zerver_realm_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_savedsnippet
    ADD CONSTRAINT zerver_savedsnippet_realm_id_c97e4aee_fk_zerver_realm_id FOREIGN KEY (realm_id) REFERENCES zulip.zerver_realm(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_savedsnippet zerver_savedsnippet_user_profile_id_43f0d808_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_savedsnippet
    ADD CONSTRAINT zerver_savedsnippet_user_profile_id_43f0d808_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_scheduledmessagenotificationemail zerver_scheduledmess_mentioned_user_group_6c2b438d_fk_zerver_na; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_scheduledmessagenotificationemail
    ADD CONSTRAINT zerver_scheduledmess_mentioned_user_group_6c2b438d_fk_zerver_na FOREIGN KEY (mentioned_user_group_id) REFERENCES zulip.zerver_namedusergroup(usergroup_ptr_id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_stream zerver_stream_can_add_subscribers__7b78ce53_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_can_add_subscribers__7b78ce53_fk_zerver_us FOREIGN KEY (can_add_subscribers_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_can_administer_chann_6d9b6d1a_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_can_administer_chann_6d9b6d1a_fk_zerver_us FOREIGN KEY (can_administer_channel_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_can_remove_subscribe_ce4fe4b7_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_can_remove_subscribe_ce4fe4b7_fk_zerver_us FOREIGN KEY (can_remove_subscribers_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_can_send_message_gro_52ab4abe_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_can_send_message_gro_52ab4abe_fk_zerver_us FOREIGN KEY (can_send_message_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_stream zerver_stream_can_subscribe_group__6e6a3b7e_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_stream
    ADD CONSTRAINT zerver_stream_can_subscribe_group__6e6a3b7e_fk_zerver_us FOREIGN KEY (can_subscribe_group_id) REFERENCES zulip.zerver_usergroup(id) DEFERRABLE INITIALLY DEFERRED;


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
-- Name: zerver_usertopic zerver_usertopic_recipient_id_2215b0a7_fk_zerver_recipient_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_usertopic_recipient_id_2215b0a7_fk_zerver_recipient_id FOREIGN KEY (recipient_id) REFERENCES zulip.zerver_recipient(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usertopic zerver_usertopic_stream_id_0ce5ea26_fk_zerver_stream_id; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_usertopic_stream_id_0ce5ea26_fk_zerver_stream_id FOREIGN KEY (stream_id) REFERENCES zulip.zerver_stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: zerver_usertopic zerver_usertopic_user_profile_id_28608df1_fk_zerver_us; Type: FK CONSTRAINT; Schema: zulip; Owner: zulip
--

ALTER TABLE ONLY zulip.zerver_usertopic
    ADD CONSTRAINT zerver_usertopic_user_profile_id_28608df1_fk_zerver_us FOREIGN KEY (user_profile_id) REFERENCES zulip.zerver_userprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

