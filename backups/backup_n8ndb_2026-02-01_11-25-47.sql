--
-- PostgreSQL database dump
--

\restrict KWbe71gYLzUNkkOEGUSAtRunZPzKumtIZJnamWtnQ4rTAeyzk2f84OikkPQMobV

-- Dumped from database version 15.15 (Debian 15.15-1.pgdg13+1)
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: increment_workflow_version(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increment_workflow_version() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
			BEGIN
				IF NEW."versionCounter" IS NOT DISTINCT FROM OLD."versionCounter" THEN
					NEW."versionCounter" = OLD."versionCounter" + 1;
				END IF;
				RETURN NEW;
			END;
			$$;


ALTER FUNCTION public.increment_workflow_version() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: annotation_tag_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.annotation_tag_entity (
    id character varying(16) NOT NULL,
    name character varying(24) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.annotation_tag_entity OWNER TO postgres;

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_identity (
    "userId" uuid,
    "providerId" character varying(64) NOT NULL,
    "providerType" character varying(32) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.auth_identity OWNER TO postgres;

--
-- Name: auth_provider_sync_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_provider_sync_history (
    id integer NOT NULL,
    "providerType" character varying(32) NOT NULL,
    "runMode" text NOT NULL,
    status text NOT NULL,
    "startedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "endedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    scanned integer NOT NULL,
    created integer NOT NULL,
    updated integer NOT NULL,
    disabled integer NOT NULL,
    error text
);


ALTER TABLE public.auth_provider_sync_history OWNER TO postgres;

--
-- Name: auth_provider_sync_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_provider_sync_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_provider_sync_history_id_seq OWNER TO postgres;

--
-- Name: auth_provider_sync_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_provider_sync_history_id_seq OWNED BY public.auth_provider_sync_history.id;


--
-- Name: backups_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.backups_log (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    nota text
);


ALTER TABLE public.backups_log OWNER TO postgres;

--
-- Name: backups_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.backups_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.backups_log_id_seq OWNER TO postgres;

--
-- Name: backups_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.backups_log_id_seq OWNED BY public.backups_log.id;


--
-- Name: binary_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.binary_data (
    "fileId" uuid NOT NULL,
    "sourceType" character varying(50) NOT NULL,
    "sourceId" character varying(255) NOT NULL,
    data bytea NOT NULL,
    "mimeType" character varying(255),
    "fileName" character varying(255),
    "fileSize" integer NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    CONSTRAINT "CHK_binary_data_sourceType" CHECK ((("sourceType")::text = ANY ((ARRAY['execution'::character varying, 'chat_message_attachment'::character varying])::text[])))
);


ALTER TABLE public.binary_data OWNER TO postgres;

--
-- Name: COLUMN binary_data."sourceType"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.binary_data."sourceType" IS 'Source the file belongs to, e.g. ''execution''';


--
-- Name: COLUMN binary_data."sourceId"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.binary_data."sourceId" IS 'ID of the source, e.g. execution ID';


--
-- Name: COLUMN binary_data.data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.binary_data.data IS 'Raw, not base64 encoded';


--
-- Name: COLUMN binary_data."fileSize"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.binary_data."fileSize" IS 'In bytes';


--
-- Name: chat_hub_agents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_hub_agents (
    id uuid NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(512),
    "systemPrompt" text NOT NULL,
    "ownerId" uuid NOT NULL,
    "credentialId" character varying(36),
    provider character varying(16) NOT NULL,
    model character varying(64) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    tools json DEFAULT '[]'::json NOT NULL
);


ALTER TABLE public.chat_hub_agents OWNER TO postgres;

--
-- Name: COLUMN chat_hub_agents.provider; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_agents.provider IS 'ChatHubProvider enum: "openai", "anthropic", "google", "n8n"';


--
-- Name: COLUMN chat_hub_agents.model; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_agents.model IS 'Model name used at the respective Model node, ie. "gpt-4"';


--
-- Name: COLUMN chat_hub_agents.tools; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_agents.tools IS 'Tools available to the agent as JSON node definitions';


--
-- Name: chat_hub_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_hub_messages (
    id uuid NOT NULL,
    "sessionId" uuid NOT NULL,
    "previousMessageId" uuid,
    "revisionOfMessageId" uuid,
    "retryOfMessageId" uuid,
    type character varying(16) NOT NULL,
    name character varying(128) NOT NULL,
    content text NOT NULL,
    provider character varying(16),
    model character varying(64),
    "workflowId" character varying(36),
    "executionId" integer,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "agentId" character varying(36),
    status character varying(16) DEFAULT 'success'::character varying NOT NULL,
    attachments json
);


ALTER TABLE public.chat_hub_messages OWNER TO postgres;

--
-- Name: COLUMN chat_hub_messages.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_messages.type IS 'ChatHubMessageType enum: "human", "ai", "system", "tool", "generic"';


--
-- Name: COLUMN chat_hub_messages.provider; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_messages.provider IS 'ChatHubProvider enum: "openai", "anthropic", "google", "n8n"';


--
-- Name: COLUMN chat_hub_messages.model; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_messages.model IS 'Model name used at the respective Model node, ie. "gpt-4"';


--
-- Name: COLUMN chat_hub_messages."agentId"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_messages."agentId" IS 'ID of the custom agent (if provider is "custom-agent")';


--
-- Name: COLUMN chat_hub_messages.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_messages.status IS 'ChatHubMessageStatus enum, eg. "success", "error", "running", "cancelled"';


--
-- Name: COLUMN chat_hub_messages.attachments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_messages.attachments IS 'File attachments for the message (if any), stored as JSON. Files are stored as base64-encoded data URLs.';


--
-- Name: chat_hub_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_hub_sessions (
    id uuid NOT NULL,
    title character varying(256) NOT NULL,
    "ownerId" uuid NOT NULL,
    "lastMessageAt" timestamp(3) with time zone,
    "credentialId" character varying(36),
    provider character varying(16),
    model character varying(64),
    "workflowId" character varying(36),
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "agentId" character varying(36),
    "agentName" character varying(128),
    tools json DEFAULT '[]'::json NOT NULL
);


ALTER TABLE public.chat_hub_sessions OWNER TO postgres;

--
-- Name: COLUMN chat_hub_sessions.provider; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_sessions.provider IS 'ChatHubProvider enum: "openai", "anthropic", "google", "n8n"';


--
-- Name: COLUMN chat_hub_sessions.model; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_sessions.model IS 'Model name used at the respective Model node, ie. "gpt-4"';


--
-- Name: COLUMN chat_hub_sessions."agentId"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_sessions."agentId" IS 'ID of the custom agent (if provider is "custom-agent")';


--
-- Name: COLUMN chat_hub_sessions."agentName"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_sessions."agentName" IS 'Cached name of the custom agent (if provider is "custom-agent")';


--
-- Name: COLUMN chat_hub_sessions.tools; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chat_hub_sessions.tools IS 'Tools available to the agent as JSON node definitions';


--
-- Name: credentials_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credentials_entity (
    name character varying(128) NOT NULL,
    data text NOT NULL,
    type character varying(128) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    id character varying(36) NOT NULL,
    "isManaged" boolean DEFAULT false NOT NULL,
    "isGlobal" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.credentials_entity OWNER TO postgres;

--
-- Name: data_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_table (
    id character varying(36) NOT NULL,
    name character varying(128) NOT NULL,
    "projectId" character varying(36) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.data_table OWNER TO postgres;

--
-- Name: data_table_column; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_table_column (
    id character varying(36) NOT NULL,
    name character varying(128) NOT NULL,
    type character varying(32) NOT NULL,
    index integer NOT NULL,
    "dataTableId" character varying(36) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.data_table_column OWNER TO postgres;

--
-- Name: COLUMN data_table_column.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.data_table_column.type IS 'Expected: string, number, boolean, or date (not enforced as a constraint)';


--
-- Name: COLUMN data_table_column.index; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.data_table_column.index IS 'Column order, starting from 0 (0 = first column)';


--
-- Name: event_destinations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_destinations (
    id uuid NOT NULL,
    destination jsonb NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.event_destinations OWNER TO postgres;

--
-- Name: execution_annotation_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.execution_annotation_tags (
    "annotationId" integer NOT NULL,
    "tagId" character varying(24) NOT NULL
);


ALTER TABLE public.execution_annotation_tags OWNER TO postgres;

--
-- Name: execution_annotations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.execution_annotations (
    id integer NOT NULL,
    "executionId" integer NOT NULL,
    vote character varying(6),
    note text,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.execution_annotations OWNER TO postgres;

--
-- Name: execution_annotations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.execution_annotations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.execution_annotations_id_seq OWNER TO postgres;

--
-- Name: execution_annotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.execution_annotations_id_seq OWNED BY public.execution_annotations.id;


--
-- Name: execution_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.execution_data (
    "executionId" integer NOT NULL,
    "workflowData" json NOT NULL,
    data text NOT NULL
);


ALTER TABLE public.execution_data OWNER TO postgres;

--
-- Name: execution_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.execution_entity (
    id integer NOT NULL,
    finished boolean NOT NULL,
    mode character varying NOT NULL,
    "retryOf" character varying,
    "retrySuccessId" character varying,
    "startedAt" timestamp(3) with time zone,
    "stoppedAt" timestamp(3) with time zone,
    "waitTill" timestamp(3) with time zone,
    status character varying NOT NULL,
    "workflowId" character varying(36) NOT NULL,
    "deletedAt" timestamp(3) with time zone,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.execution_entity OWNER TO postgres;

--
-- Name: execution_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.execution_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.execution_entity_id_seq OWNER TO postgres;

--
-- Name: execution_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.execution_entity_id_seq OWNED BY public.execution_entity.id;


--
-- Name: execution_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.execution_metadata (
    id integer NOT NULL,
    "executionId" integer NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.execution_metadata OWNER TO postgres;

--
-- Name: execution_metadata_temp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.execution_metadata_temp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.execution_metadata_temp_id_seq OWNER TO postgres;

--
-- Name: execution_metadata_temp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.execution_metadata_temp_id_seq OWNED BY public.execution_metadata.id;


--
-- Name: folder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.folder (
    id character varying(36) NOT NULL,
    name character varying(128) NOT NULL,
    "parentFolderId" character varying(36),
    "projectId" character varying(36) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.folder OWNER TO postgres;

--
-- Name: folder_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.folder_tag (
    "folderId" character varying(36) NOT NULL,
    "tagId" character varying(36) NOT NULL
);


ALTER TABLE public.folder_tag OWNER TO postgres;

--
-- Name: insights_by_period; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insights_by_period (
    id integer NOT NULL,
    "metaId" integer NOT NULL,
    type integer NOT NULL,
    value bigint NOT NULL,
    "periodUnit" integer NOT NULL,
    "periodStart" timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.insights_by_period OWNER TO postgres;

--
-- Name: COLUMN insights_by_period.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.insights_by_period.type IS '0: time_saved_minutes, 1: runtime_milliseconds, 2: success, 3: failure';


--
-- Name: COLUMN insights_by_period."periodUnit"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.insights_by_period."periodUnit" IS '0: hour, 1: day, 2: week';


--
-- Name: insights_by_period_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.insights_by_period ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.insights_by_period_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: insights_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insights_metadata (
    "metaId" integer NOT NULL,
    "workflowId" character varying(16),
    "projectId" character varying(36),
    "workflowName" character varying(128) NOT NULL,
    "projectName" character varying(255) NOT NULL
);


ALTER TABLE public.insights_metadata OWNER TO postgres;

--
-- Name: insights_metadata_metaId_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.insights_metadata ALTER COLUMN "metaId" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."insights_metadata_metaId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: insights_raw; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insights_raw (
    id integer NOT NULL,
    "metaId" integer NOT NULL,
    type integer NOT NULL,
    value bigint NOT NULL,
    "timestamp" timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.insights_raw OWNER TO postgres;

--
-- Name: COLUMN insights_raw.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.insights_raw.type IS '0: time_saved_minutes, 1: runtime_milliseconds, 2: success, 3: failure';


--
-- Name: insights_raw_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.insights_raw ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.insights_raw_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: installed_nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.installed_nodes (
    name character varying(200) NOT NULL,
    type character varying(200) NOT NULL,
    "latestVersion" integer DEFAULT 1 NOT NULL,
    package character varying(241) NOT NULL
);


ALTER TABLE public.installed_nodes OWNER TO postgres;

--
-- Name: installed_packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.installed_packages (
    "packageName" character varying(214) NOT NULL,
    "installedVersion" character varying(50) NOT NULL,
    "authorName" character varying(70),
    "authorEmail" character varying(70),
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.installed_packages OWNER TO postgres;

--
-- Name: invalid_auth_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invalid_auth_token (
    token character varying(512) NOT NULL,
    "expiresAt" timestamp(3) with time zone NOT NULL
);


ALTER TABLE public.invalid_auth_token OWNER TO postgres;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth_access_tokens (
    token character varying NOT NULL,
    "clientId" character varying NOT NULL,
    "userId" uuid NOT NULL
);


ALTER TABLE public.oauth_access_tokens OWNER TO postgres;

--
-- Name: oauth_authorization_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth_authorization_codes (
    code character varying(255) NOT NULL,
    "clientId" character varying NOT NULL,
    "userId" uuid NOT NULL,
    "redirectUri" character varying NOT NULL,
    "codeChallenge" character varying NOT NULL,
    "codeChallengeMethod" character varying(255) NOT NULL,
    "expiresAt" bigint NOT NULL,
    state character varying,
    used boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.oauth_authorization_codes OWNER TO postgres;

--
-- Name: COLUMN oauth_authorization_codes."expiresAt"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.oauth_authorization_codes."expiresAt" IS 'Unix timestamp in milliseconds';


--
-- Name: oauth_clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth_clients (
    id character varying NOT NULL,
    name character varying(255) NOT NULL,
    "redirectUris" json NOT NULL,
    "grantTypes" json NOT NULL,
    "clientSecret" character varying(255),
    "clientSecretExpiresAt" bigint,
    "tokenEndpointAuthMethod" character varying(255) DEFAULT 'none'::character varying NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.oauth_clients OWNER TO postgres;

--
-- Name: COLUMN oauth_clients."tokenEndpointAuthMethod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.oauth_clients."tokenEndpointAuthMethod" IS 'Possible values: none, client_secret_basic or client_secret_post';


--
-- Name: oauth_refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth_refresh_tokens (
    token character varying(255) NOT NULL,
    "clientId" character varying NOT NULL,
    "userId" uuid NOT NULL,
    "expiresAt" bigint NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.oauth_refresh_tokens OWNER TO postgres;

--
-- Name: COLUMN oauth_refresh_tokens."expiresAt"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.oauth_refresh_tokens."expiresAt" IS 'Unix timestamp in milliseconds';


--
-- Name: oauth_user_consents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth_user_consents (
    id integer NOT NULL,
    "userId" uuid NOT NULL,
    "clientId" character varying NOT NULL,
    "grantedAt" bigint NOT NULL
);


ALTER TABLE public.oauth_user_consents OWNER TO postgres;

--
-- Name: COLUMN oauth_user_consents."grantedAt"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.oauth_user_consents."grantedAt" IS 'Unix timestamp in milliseconds';


--
-- Name: oauth_user_consents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.oauth_user_consents ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.oauth_user_consents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: processed_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.processed_data (
    "workflowId" character varying(36) NOT NULL,
    context character varying(255) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.processed_data OWNER TO postgres;

--
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(36) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    icon json,
    description character varying(512)
);


ALTER TABLE public.project OWNER TO postgres;

--
-- Name: project_relation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project_relation (
    "projectId" character varying(36) NOT NULL,
    "userId" uuid NOT NULL,
    role character varying NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.project_relation OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    slug character varying(128) NOT NULL,
    "displayName" text,
    description text,
    "roleType" text,
    "systemRole" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: COLUMN role.slug; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.role.slug IS 'Unique identifier of the role for example: "global:owner"';


--
-- Name: COLUMN role."displayName"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.role."displayName" IS 'Name used to display in the UI';


--
-- Name: COLUMN role.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.role.description IS 'Text describing the scope in more detail of users';


--
-- Name: COLUMN role."roleType"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.role."roleType" IS 'Type of the role, e.g., global, project, or workflow';


--
-- Name: COLUMN role."systemRole"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.role."systemRole" IS 'Indicates if the role is managed by the system and cannot be edited';


--
-- Name: role_scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_scope (
    "roleSlug" character varying(128) NOT NULL,
    "scopeSlug" character varying(128) NOT NULL
);


ALTER TABLE public.role_scope OWNER TO postgres;

--
-- Name: scope; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scope (
    slug character varying(128) NOT NULL,
    "displayName" text,
    description text
);


ALTER TABLE public.scope OWNER TO postgres;

--
-- Name: COLUMN scope.slug; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scope.slug IS 'Unique identifier of the scope for example: "project:create"';


--
-- Name: COLUMN scope."displayName"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scope."displayName" IS 'Name used to display in the UI';


--
-- Name: COLUMN scope.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.scope.description IS 'Text describing the scope in more detail of users';


--
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    "loadOnStartup" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- Name: shared_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shared_credentials (
    "credentialsId" character varying(36) NOT NULL,
    "projectId" character varying(36) NOT NULL,
    role text NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.shared_credentials OWNER TO postgres;

--
-- Name: shared_workflow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shared_workflow (
    "workflowId" character varying(36) NOT NULL,
    "projectId" character varying(36) NOT NULL,
    role text NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.shared_workflow OWNER TO postgres;

--
-- Name: tag_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag_entity (
    name character varying(24) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    id character varying(36) NOT NULL
);


ALTER TABLE public.tag_entity OWNER TO postgres;

--
-- Name: test_case_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_case_execution (
    id character varying(36) NOT NULL,
    "testRunId" character varying(36) NOT NULL,
    "executionId" integer,
    status character varying NOT NULL,
    "runAt" timestamp(3) with time zone,
    "completedAt" timestamp(3) with time zone,
    "errorCode" character varying,
    "errorDetails" json,
    metrics json,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    inputs json,
    outputs json
);


ALTER TABLE public.test_case_execution OWNER TO postgres;

--
-- Name: test_run; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_run (
    id character varying(36) NOT NULL,
    "workflowId" character varying(36) NOT NULL,
    status character varying NOT NULL,
    "errorCode" character varying,
    "errorDetails" json,
    "runAt" timestamp(3) with time zone,
    "completedAt" timestamp(3) with time zone,
    metrics json,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.test_run OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(255),
    "firstName" character varying(32),
    "lastName" character varying(32),
    password character varying(255),
    "personalizationAnswers" json,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    settings json,
    disabled boolean DEFAULT false NOT NULL,
    "mfaEnabled" boolean DEFAULT false NOT NULL,
    "mfaSecret" text,
    "mfaRecoveryCodes" text,
    "lastActiveAt" date,
    "roleSlug" character varying(128) DEFAULT 'global:member'::character varying NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_api_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_api_keys (
    id character varying(36) NOT NULL,
    "userId" uuid NOT NULL,
    label character varying(100) NOT NULL,
    "apiKey" character varying NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    scopes json,
    audience character varying DEFAULT 'public-api'::character varying NOT NULL
);


ALTER TABLE public.user_api_keys OWNER TO postgres;

--
-- Name: variables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variables (
    key character varying(50) NOT NULL,
    type character varying(50) DEFAULT 'string'::character varying NOT NULL,
    value character varying(255),
    id character varying(36) NOT NULL,
    "projectId" character varying(36)
);


ALTER TABLE public.variables OWNER TO postgres;

--
-- Name: webhook_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.webhook_entity (
    "webhookPath" character varying NOT NULL,
    method character varying NOT NULL,
    node character varying NOT NULL,
    "webhookId" character varying,
    "pathLength" integer,
    "workflowId" character varying(36) NOT NULL
);


ALTER TABLE public.webhook_entity OWNER TO postgres;

--
-- Name: workflow_dependency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_dependency (
    id integer NOT NULL,
    "workflowId" character varying(36) NOT NULL,
    "workflowVersionId" integer NOT NULL,
    "dependencyType" character varying(32) NOT NULL,
    "dependencyKey" character varying(255) NOT NULL,
    "dependencyInfo" json,
    "indexVersionId" smallint DEFAULT 1 NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL
);


ALTER TABLE public.workflow_dependency OWNER TO postgres;

--
-- Name: COLUMN workflow_dependency."workflowVersionId"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workflow_dependency."workflowVersionId" IS 'Version of the workflow';


--
-- Name: COLUMN workflow_dependency."dependencyType"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workflow_dependency."dependencyType" IS 'Type of dependency: "credential", "nodeType", "webhookPath", or "workflowCall"';


--
-- Name: COLUMN workflow_dependency."dependencyKey"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workflow_dependency."dependencyKey" IS 'ID or name of the dependency';


--
-- Name: COLUMN workflow_dependency."dependencyInfo"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workflow_dependency."dependencyInfo" IS 'Additional info about the dependency, interpreted based on type';


--
-- Name: COLUMN workflow_dependency."indexVersionId"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workflow_dependency."indexVersionId" IS 'Version of the index structure';


--
-- Name: workflow_dependency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.workflow_dependency ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.workflow_dependency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_entity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_entity (
    name character varying(128) NOT NULL,
    active boolean NOT NULL,
    nodes json NOT NULL,
    connections json NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    settings json,
    "staticData" json,
    "pinData" json,
    "versionId" character(36) NOT NULL,
    "triggerCount" integer DEFAULT 0 NOT NULL,
    id character varying(36) NOT NULL,
    meta json,
    "parentFolderId" character varying(36) DEFAULT NULL::character varying,
    "isArchived" boolean DEFAULT false NOT NULL,
    "versionCounter" integer DEFAULT 1 NOT NULL,
    description text,
    "activeVersionId" character varying(36)
);


ALTER TABLE public.workflow_entity OWNER TO postgres;

--
-- Name: workflow_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_history (
    "versionId" character varying(36) NOT NULL,
    "workflowId" character varying(36) NOT NULL,
    authors character varying(255) NOT NULL,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    "updatedAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    nodes json NOT NULL,
    connections json NOT NULL,
    name character varying(128),
    autosaved boolean DEFAULT false NOT NULL,
    description text
);


ALTER TABLE public.workflow_history OWNER TO postgres;

--
-- Name: workflow_publish_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_publish_history (
    id integer NOT NULL,
    "workflowId" character varying(36) NOT NULL,
    "versionId" character varying(36) NOT NULL,
    event character varying(36) NOT NULL,
    "userId" uuid,
    "createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    CONSTRAINT "CHK_workflow_publish_history_event" CHECK (((event)::text = ANY ((ARRAY['activated'::character varying, 'deactivated'::character varying])::text[])))
);


ALTER TABLE public.workflow_publish_history OWNER TO postgres;

--
-- Name: COLUMN workflow_publish_history.event; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.workflow_publish_history.event IS 'Type of history record: activated (workflow is now active), deactivated (workflow is now inactive)';


--
-- Name: workflow_publish_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.workflow_publish_history ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.workflow_publish_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workflow_statistics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_statistics (
    count integer DEFAULT 0,
    "latestEvent" timestamp(3) with time zone,
    name character varying(128) NOT NULL,
    "workflowId" character varying(36) NOT NULL,
    "rootCount" integer DEFAULT 0
);


ALTER TABLE public.workflow_statistics OWNER TO postgres;

--
-- Name: workflows_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflows_tags (
    "workflowId" character varying(36) NOT NULL,
    "tagId" character varying(36) NOT NULL
);


ALTER TABLE public.workflows_tags OWNER TO postgres;

--
-- Name: auth_provider_sync_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_provider_sync_history ALTER COLUMN id SET DEFAULT nextval('public.auth_provider_sync_history_id_seq'::regclass);


--
-- Name: backups_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backups_log ALTER COLUMN id SET DEFAULT nextval('public.backups_log_id_seq'::regclass);


--
-- Name: execution_annotations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_annotations ALTER COLUMN id SET DEFAULT nextval('public.execution_annotations_id_seq'::regclass);


--
-- Name: execution_entity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_entity ALTER COLUMN id SET DEFAULT nextval('public.execution_entity_id_seq'::regclass);


--
-- Name: execution_metadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_metadata ALTER COLUMN id SET DEFAULT nextval('public.execution_metadata_temp_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Data for Name: annotation_tag_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.annotation_tag_entity (id, name, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_identity ("userId", "providerId", "providerType", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: auth_provider_sync_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_provider_sync_history (id, "providerType", "runMode", status, "startedAt", "endedAt", scanned, created, updated, disabled, error) FROM stdin;
\.


--
-- Data for Name: backups_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.backups_log (id, created_at, nota) FROM stdin;
1	2026-02-01 09:33:05.617208	Backup inicial de prueba
2	2026-02-01 10:24:42.627281	Backup OK — archivo generado: backup_n8ndb_2026-02-01_11-24-42.sql
\.


--
-- Data for Name: binary_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.binary_data ("fileId", "sourceType", "sourceId", data, "mimeType", "fileName", "fileSize", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: chat_hub_agents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_hub_agents (id, name, description, "systemPrompt", "ownerId", "credentialId", provider, model, "createdAt", "updatedAt", tools) FROM stdin;
\.


--
-- Data for Name: chat_hub_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_hub_messages (id, "sessionId", "previousMessageId", "revisionOfMessageId", "retryOfMessageId", type, name, content, provider, model, "workflowId", "executionId", "createdAt", "updatedAt", "agentId", status, attachments) FROM stdin;
\.


--
-- Data for Name: chat_hub_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_hub_sessions (id, title, "ownerId", "lastMessageAt", "credentialId", provider, model, "workflowId", "createdAt", "updatedAt", "agentId", "agentName", tools) FROM stdin;
\.


--
-- Data for Name: credentials_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credentials_entity (name, data, type, "createdAt", "updatedAt", id, "isManaged", "isGlobal") FROM stdin;
Postgres account	U2FsdGVkX199qY481JleVkO83L/CxzrxsiuAoJs9K9FdiWWrg3qVrTOJrLj2DR/tguXKykVORq8jSDIsdKTUCrcRV12Z8tD0OY7+vSmAgrA=	postgres	2026-01-31 20:01:52.541+00	2026-01-31 20:01:52.54+00	8B4veqf8KNWGC8JZ	f	f
SMTP account	U2FsdGVkX19YjQjUFUbnpQbvHoxh36BMghgLwi3aVEE6OaOXIvRLS+qdoa/x8AYB2yMhvoSgnQFO27AU0F7pifsOysMSoZr17xC3Ghog0t+oPypGlZOZRt2E4lDXZctIq6b4fE2aB1fK0B9/CJfBmKssXcszNtca3ekqsO+Ap9ZyoXwu+iRWDztYS6LmHSh9	smtp	2026-02-01 09:28:04.881+00	2026-02-01 09:28:04.88+00	6VWVaKQcD9oo6cZw	f	f
Telegram account	U2FsdGVkX18H4YtJPEbfRkaabr9X8QFd+el4oUR49kuhnWQ7SWY07VwbuO5Vbz8GSVLShqOgs0NnoR0w9V5TYn7mWB+FUbxBDIDR0dAC7K3xC6Mp4hbf3zYxLBXCLfP1	telegramApi	2026-02-01 09:24:49.698+00	2026-02-01 09:29:35.527+00	58owXAszp4WjT45r	f	f
\.


--
-- Data for Name: data_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_table (id, name, "projectId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: data_table_column; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_table_column (id, name, type, index, "dataTableId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: event_destinations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_destinations (id, destination, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: execution_annotation_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.execution_annotation_tags ("annotationId", "tagId") FROM stdin;
\.


--
-- Data for Name: execution_annotations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.execution_annotations (id, "executionId", vote, note, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: execution_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.execution_data ("executionId", "workflowData", data) FROM stdin;
1	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"select * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"staticData":{},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4"},{"error":"5","runData":"6","pinData":"7","lastNodeExecuted":"8"},{"contextData":"9","nodeExecutionStack":"10","metadata":"11","waitingExecution":"12","waitingExecutionSource":"13","runtimeData":"14"},{"nodeName":"15","mode":"16"},{"level":"17","tags":"18","description":"19","timestamp":1769938213785,"context":"20","functionality":"21","name":"22","node":"23","messages":"24","message":"25","stack":"26"},{"Webhook":"27","Execute a SQL query":"28"},{},"Execute a SQL query",{},["29"],{},{},{},{"version":1,"establishedAt":1769938213739,"source":"30"},"If","inclusive","warning",{},"Failed query: select * FROM backups_log;",{},"regular","NodeOperationError",{"parameters":"31","type":"32","typeVersion":2.6,"position":"33","id":"34","name":"8","alwaysOutputData":true,"credentials":"35"},[],"relation \\"backups_log\\" does not exist","NodeOperationError: relation \\"backups_log\\" does not exist\\n    at parsePostgresError (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/helpers/utils.ts:124:9)\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/helpers/utils.ts:279:19\\n    at processTicksAndRejections (node:internal/process/task_queues:105:5)\\n    at ExecuteContext.execute (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/actions/database/executeQuery.operation.ts:149:9)\\n    at ExecuteContext.router (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/actions/router.ts:41:17)\\n    at ExecuteContext.execute (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/PostgresV2.node.ts:26:10)\\n    at WorkflowExecute.executeNode (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1045:8)\\n    at WorkflowExecute.runNode (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1226:11)\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1662:27\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:2274:11",["36"],["37"],{"node":"38","data":"39","source":"40"},"manual",{"resource":"41","operation":"42","query":"43","options":"44"},"n8n-nodes-base.postgres",[-496,224],"b751cef2-226b-4dc5-8334-fd64c5cf7603",{"postgres":"45"},{"startTime":1769938213740,"executionIndex":0,"source":"46","hints":"47","executionTime":2,"executionStatus":"48","data":"49"},{"startTime":1769938213743,"executionIndex":1,"source":"50","hints":"51","executionTime":67,"executionStatus":"52","error":"53"},{"parameters":"54","type":"32","typeVersion":2.6,"position":"55","id":"34","name":"8","alwaysOutputData":true,"credentials":"56"},{"main":"57"},{"main":"50"},"database","executeQuery","select * FROM backups_log;",{},{"id":"58","name":"59"},[],[],"success",{"main":"60"},["61"],[],"error",{"level":"17","tags":"18","description":"19","timestamp":1769938213785,"context":"20","functionality":"21","name":"22","node":"23","messages":"24","message":"25","stack":"26"},{"resource":"41","operation":"42","query":"43","options":"62"},[-496,224],{"postgres":"63"},["64"],"8B4veqf8KNWGC8JZ","Postgres account",["65"],{"previousNode":"66"},{},{"id":"58","name":"59"},["67"],["68"],"Webhook",{"json":"69","pairedItem":"70"},{"json":"69","pairedItem":"71"},{"headers":"72","params":"73","query":"74","body":"75","webhookUrl":"76","executionMode":"77"},{"item":0},{"item":0},{"user-agent":"78","content-type":"79","host":"80","content-length":"81","expect":"82","connection":"83"},{},{},{"success":true,"message":"84"},"http://localhost:5678/webhook-test/notificacion","test","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","100-continue","Keep-Alive","Prueba desde terminal"]
2	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"CREATE USER postgres WITH PASSWORD 'Monlau2025';","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"error":"6","runData":"7","pinData":"8","lastNodeExecuted":"9"},{"contextData":"10","nodeExecutionStack":"11","metadata":"12","waitingExecution":"13","waitingExecutionSource":"14","runtimeData":"15"},{"nodeName":"9","mode":"16"},["17","9"],{"level":"18","tags":"19","description":"20","timestamp":1769938317655,"context":"21","functionality":"22","name":"23","node":"24","messages":"25","message":"26","stack":"27"},{"Webhook":"28","Execute a SQL query":"29"},{},"Execute a SQL query",{},["30"],{},{},{},{"version":1,"establishedAt":1769938317627,"source":"31"},"inclusive","Webhook","warning",{},"Failed query: CREATE USER postgres WITH PASSWORD 'Monlau2025';",{},"regular","NodeOperationError",{"parameters":"32","type":"33","typeVersion":2.6,"position":"34","id":"35","name":"9","alwaysOutputData":true,"credentials":"36"},[],"role \\"postgres\\" already exists","NodeOperationError: role \\"postgres\\" already exists\\n    at parsePostgresError (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/helpers/utils.ts:124:9)\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/helpers/utils.ts:279:19\\n    at processTicksAndRejections (node:internal/process/task_queues:105:5)\\n    at ExecuteContext.execute (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/actions/database/executeQuery.operation.ts:149:9)\\n    at ExecuteContext.router (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/actions/router.ts:41:17)\\n    at ExecuteContext.execute (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/PostgresV2.node.ts:26:10)\\n    at WorkflowExecute.executeNode (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1045:8)\\n    at WorkflowExecute.runNode (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1226:11)\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1662:27\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:2274:11",["37"],["38"],{"node":"39","data":"40","source":"41"},"manual",{"resource":"42","operation":"43","query":"44","options":"45"},"n8n-nodes-base.postgres",[-496,224],"b751cef2-226b-4dc5-8334-fd64c5cf7603",{"postgres":"46"},{"startTime":1769938213740,"executionIndex":0,"source":"47","hints":"48","executionTime":2,"executionStatus":"49","data":"50"},{"startTime":1769938317630,"executionIndex":1,"source":"51","hints":"52","executionTime":26,"executionStatus":"53","error":"54"},{"parameters":"55","type":"33","typeVersion":2.6,"position":"56","id":"35","name":"9","alwaysOutputData":true,"credentials":"57"},{"main":"58"},{"main":"51"},"database","executeQuery","CREATE USER postgres WITH PASSWORD 'Monlau2025';",{},{"id":"59","name":"60"},[],[],"success",{"main":"61"},["62"],[],"error",{"level":"18","tags":"19","description":"20","timestamp":1769938317655,"context":"21","functionality":"22","name":"23","node":"24","messages":"25","message":"26","stack":"27"},{"resource":"42","operation":"43","query":"44","options":"63"},[-496,224],{"postgres":"64"},["65"],"8B4veqf8KNWGC8JZ","Postgres account",["66"],{"previousNode":"17","previousNodeOutput":0,"previousNodeRun":0},{},{"id":"59","name":"60"},["67"],["68"],{"json":"69","pairedItem":"70"},{"json":"69","pairedItem":"71"},{"headers":"72","params":"73","query":"74","body":"75","webhookUrl":"76","executionMode":"77"},{"item":0},{"item":0},{"user-agent":"78","content-type":"79","host":"80","content-length":"81","expect":"82","connection":"83"},{},{},{"success":true,"message":"84"},"http://localhost:5678/webhook-test/notificacion","test","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","100-continue","Keep-Alive","Prueba desde terminal"]
3	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"CREATE DATABASE n8ndb OWNER postgres;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"error":"6","runData":"7","pinData":"8","lastNodeExecuted":"9"},{"contextData":"10","nodeExecutionStack":"11","metadata":"12","waitingExecution":"13","waitingExecutionSource":"14","runtimeData":"15"},{"nodeName":"9","mode":"16"},["17","9"],{"level":"18","tags":"19","description":"20","timestamp":1769938341168,"context":"21","functionality":"22","name":"23","node":"24","messages":"25","message":"26","stack":"27"},{"Webhook":"28","Execute a SQL query":"29"},{},"Execute a SQL query",{},["30"],{},{},{},{"version":1,"establishedAt":1769938341154,"source":"31"},"inclusive","Webhook","warning",{},"Failed query: CREATE DATABASE n8ndb OWNER postgres;",{},"regular","NodeOperationError",{"parameters":"32","type":"33","typeVersion":2.6,"position":"34","id":"35","name":"9","alwaysOutputData":true,"credentials":"36"},[],"database \\"n8ndb\\" already exists","NodeOperationError: database \\"n8ndb\\" already exists\\n    at parsePostgresError (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/helpers/utils.ts:124:9)\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/helpers/utils.ts:279:19\\n    at processTicksAndRejections (node:internal/process/task_queues:105:5)\\n    at ExecuteContext.execute (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/actions/database/executeQuery.operation.ts:149:9)\\n    at ExecuteContext.router (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/actions/router.ts:41:17)\\n    at ExecuteContext.execute (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/Postgres/v2/PostgresV2.node.ts:26:10)\\n    at WorkflowExecute.executeNode (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1045:8)\\n    at WorkflowExecute.runNode (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1226:11)\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1662:27\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:2274:11",["37"],["38"],{"node":"39","data":"40","source":"41"},"manual",{"resource":"42","operation":"43","query":"44","options":"45"},"n8n-nodes-base.postgres",[-496,224],"b751cef2-226b-4dc5-8334-fd64c5cf7603",{"postgres":"46"},{"startTime":1769938213740,"executionIndex":0,"source":"47","hints":"48","executionTime":2,"executionStatus":"49","data":"50"},{"startTime":1769938341156,"executionIndex":1,"source":"51","hints":"52","executionTime":12,"executionStatus":"53","error":"54"},{"parameters":"55","type":"33","typeVersion":2.6,"position":"56","id":"35","name":"9","alwaysOutputData":true,"credentials":"57"},{"main":"58"},{"main":"51"},"database","executeQuery","CREATE DATABASE n8ndb OWNER postgres;",{},{"id":"59","name":"60"},[],[],"success",{"main":"61"},["62"],[],"error",{"level":"18","tags":"19","description":"20","timestamp":1769938341168,"context":"21","functionality":"22","name":"23","node":"24","messages":"25","message":"26","stack":"27"},{"resource":"42","operation":"43","query":"44","options":"63"},[-496,224],{"postgres":"64"},["65"],"8B4veqf8KNWGC8JZ","Postgres account",["66"],{"previousNode":"17","previousNodeOutput":0,"previousNodeRun":0},{},{"id":"59","name":"60"},["67"],["68"],{"json":"69","pairedItem":"70"},{"json":"69","pairedItem":"71"},{"headers":"72","params":"73","query":"74","body":"75","webhookUrl":"76","executionMode":"77"},{"item":0},{"item":0},{"user-agent":"78","content-type":"79","host":"80","content-length":"81","expect":"82","connection":"83"},{},{},{"success":true,"message":"84"},"http://localhost:5678/webhook-test/notificacion","test","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","100-continue","Keep-Alive","Prueba desde terminal"]
6	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"INSERT INTO backups_log (nota) VALUES ('Backup inicial de prueba');","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"runData":"6","pinData":"7","lastNodeExecuted":"8"},{"contextData":"9","nodeExecutionStack":"10","metadata":"11","waitingExecution":"12","waitingExecutionSource":"13","runtimeData":"14"},{"nodeName":"8","mode":"15"},["16","8"],{"Webhook":"17","Execute a SQL query":"18"},{},"Execute a SQL query",{},[],{},{},{},{"version":1,"establishedAt":1769938385613,"source":"19"},"inclusive","Webhook",["20"],["21"],"manual",{"startTime":1769938213740,"executionIndex":0,"source":"22","hints":"23","executionTime":2,"executionStatus":"24","data":"25"},{"startTime":1769938385614,"executionIndex":1,"source":"26","hints":"27","executionTime":4,"executionStatus":"24","data":"28"},[],[],"success",{"main":"29"},["30"],[],{"main":"31"},["32"],{"previousNode":"16","previousNodeOutput":0,"previousNodeRun":0},["33"],["34"],["35"],{"json":"36","pairedItem":"37"},{"json":"38","pairedItem":"39"},{"headers":"40","params":"41","query":"42","body":"43","webhookUrl":"44","executionMode":"45"},{"item":0},{"success":true},["46"],{"user-agent":"47","content-type":"48","host":"49","content-length":"50","expect":"51","connection":"52"},{},{},{"success":true,"message":"53"},"http://localhost:5678/webhook-test/notificacion","test",{"item":0},"Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","100-continue","Keep-Alive","Prueba desde terminal"]
10	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"runData":"6","pinData":"7","lastNodeExecuted":"8"},{"contextData":"9","nodeExecutionStack":"10","metadata":"11","waitingExecution":"12","waitingExecutionSource":"13","runtimeData":"14"},{"nodeName":"8","mode":"15"},["16","17","8"],{"Webhook":"18","Execute a SQL query":"19","If":"20"},{},"If",{},[],{},{},{},{"version":1,"establishedAt":1769939789166,"source":"21"},"inclusive","Webhook","Execute a SQL query",["22"],["23"],["24"],"manual",{"startTime":1769939765928,"executionIndex":0,"source":"25","hints":"26","executionTime":1,"executionStatus":"27","data":"28"},{"startTime":1769939789167,"executionIndex":1,"source":"29","hints":"30","executionTime":13,"executionStatus":"27","data":"31"},{"startTime":1769939789180,"executionIndex":2,"source":"32","hints":"33","executionTime":2,"executionStatus":"27","data":"34"},[],[],"success",{"main":"35"},["36"],[],{"main":"37"},["38"],[],{"main":"39"},["40"],{"previousNode":"16","previousNodeOutput":0,"previousNodeRun":0},["41"],{"previousNode":"17"},["42","43"],["44"],["45"],[],["46"],{"json":"47","pairedItem":"48"},{"json":"49","pairedItem":"50"},{"json":"49","pairedItem":"51"},{"headers":"52","params":"53","query":"54","body":"55","webhookUrl":"56","executionMode":"57"},{"item":0},{"id":1,"created_at":"58","nota":"59"},{"item":0},{"item":0},{"user-agent":"60","content-type":"61","host":"62","content-length":"63","connection":"64"},{},{},{"success":true,"message":"65"},"http://localhost:5678/webhook-test/notificacion","test","2026-02-01T09:33:05.617Z","Backup inicial de prueba","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","Keep-Alive","Prueba desde terminal"]
12	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $('Webhook').item.json.body.success }}","rightValue":"\\"true\\"","operator":{"type":"string","operation":"equals"}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"error":"6","runData":"7","pinData":"8","lastNodeExecuted":"9"},{"contextData":"10","nodeExecutionStack":"11","metadata":"12","waitingExecution":"13","waitingExecutionSource":"14","runtimeData":"15"},{"nodeName":"9","mode":"16"},["17","18","9"],{"level":"19","tags":"20","description":"21","timestamp":1769939889152,"context":"22","functionality":"23","name":"24","node":"25","messages":"26","message":"27","stack":"28"},{"Webhook":"29","Execute a SQL query":"30","If":"31"},{},"If",{},["32"],{},{},{},{"version":1,"establishedAt":1769939889143,"source":"33"},"inclusive","Webhook","Execute a SQL query","warning",{},"\\n<p>Try either:</p>\\n<ol>\\n  <li>Enabling 'Convert types where required'</li>\\n  <li>Converting the first field to a string by adding <code>.toString()</code></li>\\n</ol>\\n\\t\\t\\t",{"itemIndex":0},"regular","NodeOperationError",{"parameters":"34","type":"35","typeVersion":2.3,"position":"36","id":"37","name":"9"},[],"Wrong type: 'true' is a boolean but was expecting a string [condition 0, item 0]","NodeOperationError: Wrong type: 'true' is a boolean but was expecting a string [condition 0, item 0]\\n    at extractValue (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/node-execution-context/utils/extract-value.ts:211:9)\\n    at ExecuteContext._getNodeParameter (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/node-execution-context/node-execution-context.ts:468:29)\\n    at ExecuteContext.getNodeParameter (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/node-execution-context/execute-context.ts:128:9)\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/If/V2/IfV2.node.ts:96:18\\n    at Array.forEach (<anonymous>)\\n    at ExecuteContext.execute (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-nodes-base@file+packages+nodes-base_@aws-sdk+credential-providers@3.808.0_asn1.js@5_8da18263ca0574b0db58d4fefd8173ce/node_modules/n8n-nodes-base/nodes/If/V2/IfV2.node.ts:88:23)\\n    at WorkflowExecute.executeNode (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1045:31)\\n    at WorkflowExecute.runNode (/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1226:22)\\n    at /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-core@file+packages+core_@opentelemetry+api@1.9.0_@opentelemetry+sdk-trace-base@1.30_ec37920eb95917b28efaa783206b20f3/node_modules/n8n-core/src/execution-engine/workflow-execute.ts:1662:38\\n    at processTicksAndRejections (node:internal/process/task_queues:105:5)",["38"],["39"],["40"],{"node":"41","data":"42","source":"43"},"manual",{"conditions":"44","looseTypeValidation":false,"options":"45"},"n8n-nodes-base.if",[-288,224],"268cdb69-6267-45f1-a4ff-170b421e5678",{"startTime":1769939765928,"executionIndex":0,"source":"46","hints":"47","executionTime":1,"executionStatus":"48","data":"49"},{"startTime":1769939789167,"executionIndex":1,"source":"50","hints":"51","executionTime":13,"executionStatus":"48","data":"52"},{"startTime":1769939889144,"executionIndex":2,"source":"53","hints":"54","executionTime":27,"executionStatus":"55","error":"56"},{"parameters":"57","type":"35","typeVersion":2.3,"position":"58","id":"37","name":"9"},{"main":"59"},{"main":"53"},{"options":"60","conditions":"61","combinator":"62"},{},[],[],"success",{"main":"63"},["64"],[],{"main":"65"},["66"],[],"error",{"level":"19","tags":"20","description":"21","timestamp":1769939889152,"context":"22","functionality":"23","name":"24","node":"25","messages":"26","message":"27","stack":"28"},{"conditions":"67","looseTypeValidation":false,"options":"68"},[-288,224],["69"],{"caseSensitive":true,"leftValue":"70","typeValidation":"71","version":3},["72"],"and",["73"],{"previousNode":"17","previousNodeOutput":0,"previousNodeRun":0},["74"],{"previousNode":"18","previousNodeOutput":0,"previousNodeRun":0},{"options":"75","conditions":"76","combinator":"62"},{},["77"],"","strict",{"id":"78","leftValue":"79","rightValue":"80","operator":"81"},["82"],["83"],{"caseSensitive":true,"leftValue":"70","typeValidation":"71","version":3},["84"],{"json":"85","pairedItem":"86"},"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","={{ $('Webhook').item.json.body.success }}","\\"true\\"",{"type":"87","operation":"88"},{"json":"89","pairedItem":"90"},{"json":"85","pairedItem":"91"},{"id":"78","leftValue":"79","rightValue":"80","operator":"92"},{"id":1,"created_at":"93","nota":"94"},{"item":0},"string","equals",{"headers":"95","params":"96","query":"97","body":"98","webhookUrl":"99","executionMode":"100"},{"item":0},{"item":0},{"type":"87","operation":"88"},"2026-02-01T09:33:05.617Z","Backup inicial de prueba",{"user-agent":"101","content-type":"102","host":"103","content-length":"104","connection":"105"},{},{},{"success":true,"message":"106"},"http://localhost:5678/webhook-test/notificacion","test","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","Keep-Alive","Prueba desde terminal"]
4	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"GRANT ALL PRIVILEGES ON DATABASE n8ndb TO postgres;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"runData":"6","pinData":"7","lastNodeExecuted":"8"},{"contextData":"9","nodeExecutionStack":"10","metadata":"11","waitingExecution":"12","waitingExecutionSource":"13","runtimeData":"14"},{"nodeName":"8","mode":"15"},["16","8"],{"Webhook":"17","Execute a SQL query":"18"},{},"Execute a SQL query",{},[],{},{},{},{"version":1,"establishedAt":1769938359957,"source":"19"},"inclusive","Webhook",["20"],["21"],"manual",{"startTime":1769938213740,"executionIndex":0,"source":"22","hints":"23","executionTime":2,"executionStatus":"24","data":"25"},{"startTime":1769938359959,"executionIndex":1,"source":"26","hints":"27","executionTime":21,"executionStatus":"24","data":"28"},[],[],"success",{"main":"29"},["30"],[],{"main":"31"},["32"],{"previousNode":"16","previousNodeOutput":0,"previousNodeRun":0},["33"],["34"],["35"],{"json":"36","pairedItem":"37"},{"json":"38","pairedItem":"39"},{"headers":"40","params":"41","query":"42","body":"43","webhookUrl":"44","executionMode":"45"},{"item":0},{"success":true},["46"],{"user-agent":"47","content-type":"48","host":"49","content-length":"50","expect":"51","connection":"52"},{},{},{"success":true,"message":"53"},"http://localhost:5678/webhook-test/notificacion","test",{"item":0},"Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","100-continue","Keep-Alive","Prueba desde terminal"]
5	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"CREATE TABLE backups_log (\\nid SERIAL PRIMARY KEY,\\ncreated_at TIMESTAMP DEFAULT NOW(),\\nnota TEXT\\n);","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"runData":"6","pinData":"7","lastNodeExecuted":"8"},{"contextData":"9","nodeExecutionStack":"10","metadata":"11","waitingExecution":"12","waitingExecutionSource":"13","runtimeData":"14"},{"nodeName":"8","mode":"15"},["16","8"],{"Webhook":"17","Execute a SQL query":"18"},{},"Execute a SQL query",{},[],{},{},{},{"version":1,"establishedAt":1769938378074,"source":"19"},"inclusive","Webhook",["20"],["21"],"manual",{"startTime":1769938213740,"executionIndex":0,"source":"22","hints":"23","executionTime":2,"executionStatus":"24","data":"25"},{"startTime":1769938378075,"executionIndex":1,"source":"26","hints":"27","executionTime":28,"executionStatus":"24","data":"28"},[],[],"success",{"main":"29"},["30"],[],{"main":"31"},["32"],{"previousNode":"16","previousNodeOutput":0,"previousNodeRun":0},["33"],["34"],["35"],{"json":"36","pairedItem":"37"},{"json":"38","pairedItem":"39"},{"headers":"40","params":"41","query":"42","body":"43","webhookUrl":"44","executionMode":"45"},{"item":0},{"success":true},["46"],{"user-agent":"47","content-type":"48","host":"49","content-length":"50","expect":"51","connection":"52"},{},{},{"success":true,"message":"53"},"http://localhost:5678/webhook-test/notificacion","test",{"item":0},"Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","100-continue","Keep-Alive","Prueba desde terminal"]
7	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"runData":"6","pinData":"7","lastNodeExecuted":"8"},{"contextData":"9","nodeExecutionStack":"10","metadata":"11","waitingExecution":"12","waitingExecutionSource":"13","runtimeData":"14"},{"nodeName":"8","mode":"15"},["16","8"],{"Webhook":"17","Execute a SQL query":"18"},{},"Execute a SQL query",{},[],{},{},{},{"version":1,"establishedAt":1769938396781,"source":"19"},"inclusive","Webhook",["20"],["21"],"manual",{"startTime":1769938213740,"executionIndex":0,"source":"22","hints":"23","executionTime":2,"executionStatus":"24","data":"25"},{"startTime":1769938396781,"executionIndex":1,"source":"26","hints":"27","executionTime":9,"executionStatus":"24","data":"28"},[],[],"success",{"main":"29"},["30"],[],{"main":"31"},["32"],{"previousNode":"16","previousNodeOutput":0,"previousNodeRun":0},["33"],["34"],["35"],{"json":"36","pairedItem":"37"},{"json":"38","pairedItem":"39"},{"headers":"40","params":"41","query":"42","body":"43","webhookUrl":"44","executionMode":"45"},{"item":0},{"id":1,"created_at":"46","nota":"47"},{"item":0},{"user-agent":"48","content-type":"49","host":"50","content-length":"51","expect":"52","connection":"53"},{},{},{"success":true,"message":"54"},"http://localhost:5678/webhook-test/notificacion","test","2026-02-01T09:33:05.617Z","Backup inicial de prueba","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","100-continue","Keep-Alive","Prueba desde terminal"]
8	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"staticData":{},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{},{"runData":"4","pinData":"5","lastNodeExecuted":"6"},{"contextData":"7","nodeExecutionStack":"8","metadata":"9","waitingExecution":"10","waitingExecutionSource":"11","runtimeData":"12"},{"Webhook":"13","Execute a SQL query":"14","If":"15","Send a text message NOK":"16","Send email1":"17"},{},"Send email1",{},[],{},{},{},{"version":1,"establishedAt":1769938462791,"source":"18"},["19"],["20"],["21"],["22"],["23"],"manual",{"startTime":1769938462792,"executionIndex":0,"source":"24","hints":"25","executionTime":1,"executionStatus":"26","data":"27"},{"startTime":1769938462794,"executionIndex":1,"source":"28","hints":"29","executionTime":10,"executionStatus":"26","data":"30"},{"startTime":1769938462805,"executionIndex":2,"source":"31","hints":"32","executionTime":8,"executionStatus":"26","data":"33"},{"startTime":1769938462814,"executionIndex":3,"source":"34","hints":"35","executionTime":324,"executionStatus":"26","data":"36"},{"startTime":1769938463139,"executionIndex":4,"source":"37","hints":"38","executionTime":1781,"executionStatus":"26","data":"39"},[],[],"success",{"main":"40"},["41"],[],{"main":"42"},["43"],[],{"main":"44"},["45"],[],{"main":"46"},["47"],[],{"main":"48"},["49"],{"previousNode":"50"},["51"],{"previousNode":"52"},["53","54"],{"previousNode":"55","previousNodeOutput":1},["56"],{"previousNode":"55","previousNodeOutput":1},["57"],["58"],"Webhook",["59"],"Execute a SQL query",[],["60"],"If",["61"],["62"],{"json":"63","pairedItem":"64"},{"json":"65","pairedItem":"66"},{"json":"65","pairedItem":"67"},{"json":"68","pairedItem":"69"},{"json":"70","pairedItem":"71"},{"headers":"72","params":"73","query":"74","body":"75","webhookUrl":"76","executionMode":"77"},{"item":0},{"id":1,"created_at":"78","nota":"79"},{"item":0},{"item":0},{"ok":true,"result":"80"},{"item":0},{"accepted":"81","rejected":"82","ehlo":"83","envelopeTime":365,"messageTime":546,"messageSize":806,"response":"84","envelope":"85","messageId":"86"},{"item":0},{"user-agent":"87","content-type":"88","host":"89","content-length":"90","connection":"91"},{},{},{"success":true,"message":"92"},"http://localhost:5678/webhook-test/notificacion","test","2026-02-01T09:33:05.617Z","Backup inicial de prueba",{"message_id":73,"from":"93","chat":"94","date":1769938464,"text":"95","entities":"96","link_preview_options":"97"},["98"],[],["99","100","101","102","103","104","105"],"250 2.0.0 OK  1769938466 ffacd0b85a97d-435e10edfe7sm34950734f8f.14 - gsmtp",{"from":"98","to":"106"},"<2540498f-7300-ba72-1d00-be3ede327c39@gmail.com>","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","Keep-Alive","Prueba desde terminal",{"id":8366319180,"is_bot":true,"first_name":"107","username":"108"},{"id":8271192543,"first_name":"109","last_name":"110","type":"111"},"No se han encontrado ningún registro\\n\\nThis message was sent automatically with n8n",["112","113"],{"is_disabled":true},"eliapinedamoreno@gmail.com","SIZE 35882577","8BITMIME","AUTH LOGIN PLAIN XOAUTH2 PLAIN-CLIENTTOKEN OAUTHBEARER XOAUTH","ENHANCEDSTATUSCODES","PIPELINING","CHUNKING","SMTPUTF8",["98"],"n8n backup bot","n8n_elia_bot","Elia","Pineda Moreno","private",{"offset":38,"length":41,"type":"114"},{"offset":79,"length":3,"type":"115","url":"116"},"italic","text_link","https://n8n.io/?utm_source=n8n-internal&utm_medium=powered_by&utm_campaign=n8n-nodes-base.telegram_2f0896337a473e290ee2ea94008cfbbb94d7e57e611f0b0a4024e14be1a88f86"]
9	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"staticData":{},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4"},{"runData":"5","pinData":"6","lastNodeExecuted":"7"},{"contextData":"8","nodeExecutionStack":"9","metadata":"10","waitingExecution":"11","waitingExecutionSource":"12","runtimeData":"13"},{"nodeName":"7","mode":"14"},{"Webhook":"15"},{},"Webhook",{},[],{},{},{},{"version":1,"establishedAt":1769939765927,"source":"16"},"inclusive",["17"],"manual",{"startTime":1769939765928,"executionIndex":0,"source":"18","hints":"19","executionTime":1,"executionStatus":"20","data":"21"},[],[],"success",{"main":"22"},["23"],["24"],{"json":"25","pairedItem":"26"},{"headers":"27","params":"28","query":"29","body":"30","webhookUrl":"31","executionMode":"32"},{"item":0},{"user-agent":"33","content-type":"34","host":"35","content-length":"36","connection":"37"},{},{},{"success":true,"message":"38"},"http://localhost:5678/webhook-test/notificacion","test","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","Keep-Alive","Prueba desde terminal"]
11	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.body.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"runData":"6","pinData":"7","lastNodeExecuted":"8"},{"contextData":"9","nodeExecutionStack":"10","metadata":"11","waitingExecution":"12","waitingExecutionSource":"13","runtimeData":"14"},{"nodeName":"8","mode":"15"},["16","17","8"],{"Webhook":"18","Execute a SQL query":"19","If":"20"},{},"If",{},[],{},{},{},{"version":1,"establishedAt":1769939811862,"source":"21"},"inclusive","Webhook","Execute a SQL query",["22"],["23"],["24"],"manual",{"startTime":1769939765928,"executionIndex":0,"source":"25","hints":"26","executionTime":1,"executionStatus":"27","data":"28"},{"startTime":1769939789167,"executionIndex":1,"source":"29","hints":"30","executionTime":13,"executionStatus":"27","data":"31"},{"startTime":1769939811863,"executionIndex":2,"source":"32","hints":"33","executionTime":10,"executionStatus":"27","data":"34"},[],[],"success",{"main":"35"},["36"],[],{"main":"37"},["38"],[],{"main":"39"},["40"],{"previousNode":"16","previousNodeOutput":0,"previousNodeRun":0},["41"],{"previousNode":"17","previousNodeOutput":0,"previousNodeRun":0},["42","43"],["44"],["45"],[],["46"],{"json":"47","pairedItem":"48"},{"json":"49","pairedItem":"50"},{"json":"49","pairedItem":"51"},{"headers":"52","params":"53","query":"54","body":"55","webhookUrl":"56","executionMode":"57"},{"item":0},{"id":1,"created_at":"58","nota":"59"},{"item":0},{"item":0},{"user-agent":"60","content-type":"61","host":"62","content-length":"63","connection":"64"},{},{},{"success":true,"message":"65"},"http://localhost:5678/webhook-test/notificacion","test","2026-02-01T09:33:05.617Z","Backup inicial de prueba","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","Keep-Alive","Prueba desde terminal"]
13	{"id":"isoQysSMexnHA8Q8","name":"My workflow","active":false,"activeVersionId":null,"nodes":[{"parameters":{"resource":"database","operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $('Webhook').item.json.body.success }}","rightValue":"\\"true\\"","operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"looseTypeValidation":false,"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"Se ha encontrado al menos un registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","emailFormat":"html","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"resource":"email","operation":"send","fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","emailFormat":"html","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"preBuiltAgentsCalloutTelegram":"","resource":"message","operation":"sendMessage","chatId":"8271192543","text":"No se han encontrado ningún registro","replyMarkup":"none","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"multipleMethods":false,"httpMethod":"POST","path":"notificacion","authentication":"none","responseMode":"onReceived","contentTypeNotice":"","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}],"connections":{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}},"settings":{"executionOrder":"v1"},"pinData":{}}	[{"version":1,"startData":"1","resultData":"2","executionData":"3"},{"destinationNode":"4","runNodeFilter":"5"},{"runData":"6","pinData":"7","lastNodeExecuted":"8"},{"contextData":"9","nodeExecutionStack":"10","metadata":"11","waitingExecution":"12","waitingExecutionSource":"13","runtimeData":"14"},{"nodeName":"8","mode":"15"},["16","17","8"],{"Webhook":"18","Execute a SQL query":"19","If":"20"},{},"If",{},[],{},{},{},{"version":1,"establishedAt":1769939897572,"source":"21"},"inclusive","Webhook","Execute a SQL query",["22"],["23"],["24"],"manual",{"startTime":1769939765928,"executionIndex":0,"source":"25","hints":"26","executionTime":1,"executionStatus":"27","data":"28"},{"startTime":1769939789167,"executionIndex":1,"source":"29","hints":"30","executionTime":13,"executionStatus":"27","data":"31"},{"startTime":1769939897573,"executionIndex":2,"source":"32","hints":"33","executionTime":2,"executionStatus":"27","data":"34"},[],[],"success",{"main":"35"},["36"],[],{"main":"37"},["38"],[],{"main":"39"},["40"],{"previousNode":"16","previousNodeOutput":0,"previousNodeRun":0},["41"],{"previousNode":"17","previousNodeOutput":0,"previousNodeRun":0},["42","43"],["44"],["45"],["46"],[],{"json":"47","pairedItem":"48"},{"json":"49","pairedItem":"50"},{"json":"49","pairedItem":"51"},{"headers":"52","params":"53","query":"54","body":"55","webhookUrl":"56","executionMode":"57"},{"item":0},{"id":1,"created_at":"58","nota":"59"},{"item":0},{"item":0},{"user-agent":"60","content-type":"61","host":"62","content-length":"63","connection":"64"},{},{},{"success":true,"message":"65"},"http://localhost:5678/webhook-test/notificacion","test","2026-02-01T09:33:05.617Z","Backup inicial de prueba","Mozilla/5.0 (Windows NT; Windows NT 10.0; es-ES) WindowsPowerShell/5.1.26100.7705","application/json","localhost:5678","53","Keep-Alive","Prueba desde terminal"]
\.


--
-- Data for Name: execution_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.execution_entity (id, finished, mode, "retryOf", "retrySuccessId", "startedAt", "stoppedAt", "waitTill", status, "workflowId", "deletedAt", "createdAt") FROM stdin;
1	f	manual	\N	\N	2026-02-01 09:30:13.733+00	2026-02-01 09:30:13.811+00	\N	error	isoQysSMexnHA8Q8	\N	2026-02-01 09:30:13.716+00
2	f	manual	\N	\N	2026-02-01 09:31:57.614+00	2026-02-01 09:31:57.657+00	\N	error	isoQysSMexnHA8Q8	\N	2026-02-01 09:31:57.587+00
3	f	manual	\N	\N	2026-02-01 09:32:21.149+00	2026-02-01 09:32:21.169+00	\N	error	isoQysSMexnHA8Q8	\N	2026-02-01 09:32:21.14+00
4	t	manual	\N	\N	2026-02-01 09:32:39.951+00	2026-02-01 09:32:39.981+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:32:39.934+00
5	t	manual	\N	\N	2026-02-01 09:32:58.07+00	2026-02-01 09:32:58.104+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:32:58.062+00
6	t	manual	\N	\N	2026-02-01 09:33:05.609+00	2026-02-01 09:33:05.619+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:33:05.599+00
7	t	manual	\N	\N	2026-02-01 09:33:16.777+00	2026-02-01 09:33:16.791+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:33:16.769+00
8	t	manual	\N	\N	2026-02-01 09:34:22.787+00	2026-02-01 09:34:24.921+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:34:22.777+00
9	t	manual	\N	\N	2026-02-01 09:56:05.925+00	2026-02-01 09:56:05.93+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:56:05.912+00
10	t	manual	\N	\N	2026-02-01 09:56:29.162+00	2026-02-01 09:56:29.183+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:56:29.151+00
11	t	manual	\N	\N	2026-02-01 09:56:51.858+00	2026-02-01 09:56:51.874+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:56:51.849+00
12	f	manual	\N	\N	2026-02-01 09:58:09.139+00	2026-02-01 09:58:09.173+00	\N	error	isoQysSMexnHA8Q8	\N	2026-02-01 09:58:09.129+00
13	t	manual	\N	\N	2026-02-01 09:58:17.57+00	2026-02-01 09:58:17.575+00	\N	success	isoQysSMexnHA8Q8	\N	2026-02-01 09:58:17.562+00
\.


--
-- Data for Name: execution_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.execution_metadata (id, "executionId", key, value) FROM stdin;
\.


--
-- Data for Name: folder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.folder (id, name, "parentFolderId", "projectId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: folder_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.folder_tag ("folderId", "tagId") FROM stdin;
\.


--
-- Data for Name: insights_by_period; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insights_by_period (id, "metaId", type, value, "periodUnit", "periodStart") FROM stdin;
\.


--
-- Data for Name: insights_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insights_metadata ("metaId", "workflowId", "projectId", "workflowName", "projectName") FROM stdin;
\.


--
-- Data for Name: insights_raw; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insights_raw (id, "metaId", type, value, "timestamp") FROM stdin;
\.


--
-- Data for Name: installed_nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.installed_nodes (name, type, "latestVersion", package) FROM stdin;
\.


--
-- Data for Name: installed_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.installed_packages ("packageName", "installedVersion", "authorName", "authorEmail", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: invalid_auth_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invalid_auth_token (token, "expiresAt") FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1587669153312	InitialMigration1587669153312
2	1589476000887	WebhookModel1589476000887
3	1594828256133	CreateIndexStoppedAt1594828256133
4	1607431743768	MakeStoppedAtNullable1607431743768
5	1611144599516	AddWebhookId1611144599516
6	1617270242566	CreateTagEntity1617270242566
7	1620824779533	UniqueWorkflowNames1620824779533
8	1626176912946	AddwaitTill1626176912946
9	1630419189837	UpdateWorkflowCredentials1630419189837
10	1644422880309	AddExecutionEntityIndexes1644422880309
11	1646834195327	IncreaseTypeVarcharLimit1646834195327
12	1646992772331	CreateUserManagement1646992772331
13	1648740597343	LowerCaseUserEmail1648740597343
14	1652254514002	CommunityNodes1652254514002
15	1652367743993	AddUserSettings1652367743993
16	1652905585850	AddAPIKeyColumn1652905585850
17	1654090467022	IntroducePinData1654090467022
18	1658932090381	AddNodeIds1658932090381
19	1659902242948	AddJsonKeyPinData1659902242948
20	1660062385367	CreateCredentialsUserRole1660062385367
21	1663755770893	CreateWorkflowsEditorRole1663755770893
22	1664196174001	WorkflowStatistics1664196174001
23	1665484192212	CreateCredentialUsageTable1665484192212
24	1665754637025	RemoveCredentialUsageTable1665754637025
25	1669739707126	AddWorkflowVersionIdColumn1669739707126
26	1669823906995	AddTriggerCountColumn1669823906995
27	1671535397530	MessageEventBusDestinations1671535397530
28	1671726148421	RemoveWorkflowDataLoadedFlag1671726148421
29	1673268682475	DeleteExecutionsWithWorkflows1673268682475
30	1674138566000	AddStatusToExecutions1674138566000
31	1674509946020	CreateLdapEntities1674509946020
32	1675940580449	PurgeInvalidWorkflowConnections1675940580449
33	1676996103000	MigrateExecutionStatus1676996103000
34	1677236854063	UpdateRunningExecutionStatus1677236854063
35	1677501636754	CreateVariables1677501636754
36	1679416281778	CreateExecutionMetadataTable1679416281778
37	1681134145996	AddUserActivatedProperty1681134145996
38	1681134145997	RemoveSkipOwnerSetup1681134145997
39	1690000000000	MigrateIntegerKeysToString1690000000000
40	1690000000020	SeparateExecutionData1690000000020
41	1690000000030	RemoveResetPasswordColumns1690000000030
42	1690000000030	AddMfaColumns1690000000030
43	1690787606731	AddMissingPrimaryKeyOnExecutionData1690787606731
44	1691088862123	CreateWorkflowNameIndex1691088862123
45	1692967111175	CreateWorkflowHistoryTable1692967111175
46	1693491613982	ExecutionSoftDelete1693491613982
47	1693554410387	DisallowOrphanExecutions1693554410387
48	1694091729095	MigrateToTimestampTz1694091729095
49	1695128658538	AddWorkflowMetadata1695128658538
50	1695829275184	ModifyWorkflowHistoryNodesAndConnections1695829275184
51	1700571993961	AddGlobalAdminRole1700571993961
52	1705429061930	DropRoleMapping1705429061930
53	1711018413374	RemoveFailedExecutionStatus1711018413374
54	1711390882123	MoveSshKeysToDatabase1711390882123
55	1712044305787	RemoveNodesAccess1712044305787
56	1714133768519	CreateProject1714133768519
57	1714133768521	MakeExecutionStatusNonNullable1714133768521
58	1717498465931	AddActivatedAtUserSetting1717498465931
59	1720101653148	AddConstraintToExecutionMetadata1720101653148
60	1721377157740	FixExecutionMetadataSequence1721377157740
61	1723627610222	CreateInvalidAuthTokenTable1723627610222
62	1723796243146	RefactorExecutionIndices1723796243146
63	1724753530828	CreateAnnotationTables1724753530828
64	1724951148974	AddApiKeysTable1724951148974
65	1726606152711	CreateProcessedDataTable1726606152711
66	1727427440136	SeparateExecutionCreationFromStart1727427440136
67	1728659839644	AddMissingPrimaryKeyOnAnnotationTagMapping1728659839644
68	1729607673464	UpdateProcessedDataValueColumnToText1729607673464
69	1729607673469	AddProjectIcons1729607673469
70	1730386903556	CreateTestDefinitionTable1730386903556
71	1731404028106	AddDescriptionToTestDefinition1731404028106
72	1731582748663	MigrateTestDefinitionKeyToString1731582748663
73	1732271325258	CreateTestMetricTable1732271325258
74	1732549866705	CreateTestRun1732549866705
75	1733133775640	AddMockedNodesColumnToTestDefinition1733133775640
76	1734479635324	AddManagedColumnToCredentialsTable1734479635324
77	1736172058779	AddStatsColumnsToTestRun1736172058779
78	1736947513045	CreateTestCaseExecutionTable1736947513045
79	1737715421462	AddErrorColumnsToTestRuns1737715421462
80	1738709609940	CreateFolderTable1738709609940
81	1739549398681	CreateAnalyticsTables1739549398681
82	1740445074052	UpdateParentFolderIdColumn1740445074052
83	1741167584277	RenameAnalyticsToInsights1741167584277
84	1742918400000	AddScopesColumnToApiKeys1742918400000
85	1745322634000	ClearEvaluation1745322634000
86	1745587087521	AddWorkflowStatisticsRootCount1745587087521
87	1745934666076	AddWorkflowArchivedColumn1745934666076
88	1745934666077	DropRoleTable1745934666077
89	1747824239000	AddProjectDescriptionColumn1747824239000
90	1750252139166	AddLastActiveAtColumnToUser1750252139166
91	1750252139166	AddScopeTables1750252139166
92	1750252139167	AddRolesTables1750252139167
93	1750252139168	LinkRoleToUserTable1750252139168
94	1750252139170	RemoveOldRoleColumn1750252139170
95	1752669793000	AddInputsOutputsToTestCaseExecution1752669793000
96	1753953244168	LinkRoleToProjectRelationTable1753953244168
97	1754475614601	CreateDataStoreTables1754475614601
98	1754475614602	ReplaceDataStoreTablesWithDataTables1754475614602
99	1756906557570	AddTimestampsToRoleAndRoleIndexes1756906557570
100	1758731786132	AddAudienceColumnToApiKeys1758731786132
101	1758794506893	AddProjectIdToVariableTable1758794506893
102	1759399811000	ChangeValueTypesForInsights1759399811000
103	1760019379982	CreateChatHubTables1760019379982
104	1760020000000	CreateChatHubAgentTable1760020000000
105	1760020838000	UniqueRoleNames1760020838000
106	1760116750277	CreateOAuthEntities1760116750277
107	1760314000000	CreateWorkflowDependencyTable1760314000000
108	1760965142113	DropUnusedChatHubColumns1760965142113
109	1761047826451	AddWorkflowVersionColumn1761047826451
110	1761655473000	ChangeDependencyInfoToJson1761655473000
111	1761773155024	AddAttachmentsToChatHubMessages1761773155024
112	1761830340990	AddToolsColumnToChatHubTables1761830340990
113	1762177736257	AddWorkflowDescriptionColumn1762177736257
114	1762763704614	BackfillMissingWorkflowHistoryRecords1762763704614
115	1762771264000	ChangeDefaultForIdInUserTable1762771264000
116	1762771954619	AddIsGlobalColumnToCredentialsTable1762771954619
117	1762847206508	AddWorkflowHistoryAutoSaveFields1762847206508
118	1763047800000	AddActiveVersionIdColumn1763047800000
119	1763048000000	ActivateExecuteWorkflowTriggerWorkflows1763048000000
120	1763572724000	ChangeOAuthStateColumnToUnboundedVarchar1763572724000
121	1763716655000	CreateBinaryDataTable1763716655000
122	1764167920585	CreateWorkflowPublishHistoryTable1764167920585
123	1765448186933	BackfillMissingWorkflowHistoryRecords1765448186933
\.


--
-- Data for Name: oauth_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth_access_tokens (token, "clientId", "userId") FROM stdin;
\.


--
-- Data for Name: oauth_authorization_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth_authorization_codes (code, "clientId", "userId", "redirectUri", "codeChallenge", "codeChallengeMethod", "expiresAt", state, used, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth_clients (id, name, "redirectUris", "grantTypes", "clientSecret", "clientSecretExpiresAt", "tokenEndpointAuthMethod", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: oauth_refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth_refresh_tokens (token, "clientId", "userId", "expiresAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: oauth_user_consents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oauth_user_consents (id, "userId", "clientId", "grantedAt") FROM stdin;
\.


--
-- Data for Name: processed_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.processed_data ("workflowId", context, "createdAt", "updatedAt", value) FROM stdin;
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project (id, name, type, "createdAt", "updatedAt", icon, description) FROM stdin;
0CN8XszDlJ5vvU6x	Elia Pineda Moreno <eliapinmortec3@gmail.com>	personal	2026-01-31 20:00:08.338+00	2026-01-31 20:00:31.474+00	\N	\N
\.


--
-- Data for Name: project_relation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project_relation ("projectId", "userId", role, "createdAt", "updatedAt") FROM stdin;
0CN8XszDlJ5vvU6x	e5488568-93d0-4754-800b-c743b6623ca3	project:personalOwner	2026-01-31 20:00:08.338+00	2026-01-31 20:00:08.338+00
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (slug, "displayName", description, "roleType", "systemRole", "createdAt", "updatedAt") FROM stdin;
global:owner	Owner	Owner	global	t	2026-01-31 20:00:10.45+00	2026-01-31 20:00:11.132+00
global:admin	Admin	Admin	global	t	2026-01-31 20:00:10.45+00	2026-01-31 20:00:11.132+00
global:member	Member	Member	global	t	2026-01-31 20:00:10.45+00	2026-01-31 20:00:11.132+00
project:admin	Project Admin	Full control of settings, members, workflows, credentials and executions	project	t	2026-01-31 20:00:10.45+00	2026-01-31 20:00:11.206+00
project:personalOwner	Project Owner	Project Owner	project	t	2026-01-31 20:00:10.45+00	2026-01-31 20:00:11.206+00
project:editor	Project Editor	Create, edit, and delete workflows, credentials, and executions	project	t	2026-01-31 20:00:10.45+00	2026-01-31 20:00:11.206+00
project:viewer	Project Viewer	Read-only access to workflows, credentials, and executions	project	t	2026-01-31 20:00:10.45+00	2026-01-31 20:00:11.206+00
credential:owner	Credential Owner	Credential Owner	credential	t	2026-01-31 20:00:11.217+00	2026-01-31 20:00:11.217+00
credential:user	Credential User	Credential User	credential	t	2026-01-31 20:00:11.217+00	2026-01-31 20:00:11.217+00
workflow:owner	Workflow Owner	Workflow Owner	workflow	t	2026-01-31 20:00:11.225+00	2026-01-31 20:00:11.225+00
workflow:editor	Workflow Editor	Workflow Editor	workflow	t	2026-01-31 20:00:11.225+00	2026-01-31 20:00:11.225+00
\.


--
-- Data for Name: role_scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_scope ("roleSlug", "scopeSlug") FROM stdin;
global:owner	annotationTag:create
global:owner	annotationTag:read
global:owner	annotationTag:update
global:owner	annotationTag:delete
global:owner	annotationTag:list
global:owner	auditLogs:manage
global:owner	banner:dismiss
global:owner	community:register
global:owner	communityPackage:install
global:owner	communityPackage:uninstall
global:owner	communityPackage:update
global:owner	communityPackage:list
global:owner	credential:share
global:owner	credential:shareGlobally
global:owner	credential:move
global:owner	credential:create
global:owner	credential:read
global:owner	credential:update
global:owner	credential:delete
global:owner	credential:list
global:owner	externalSecretsProvider:sync
global:owner	externalSecretsProvider:create
global:owner	externalSecretsProvider:read
global:owner	externalSecretsProvider:update
global:owner	externalSecretsProvider:delete
global:owner	externalSecretsProvider:list
global:owner	externalSecret:list
global:owner	externalSecret:use
global:owner	eventBusDestination:test
global:owner	eventBusDestination:create
global:owner	eventBusDestination:read
global:owner	eventBusDestination:update
global:owner	eventBusDestination:delete
global:owner	eventBusDestination:list
global:owner	ldap:sync
global:owner	ldap:manage
global:owner	license:manage
global:owner	logStreaming:manage
global:owner	orchestration:read
global:owner	project:create
global:owner	project:read
global:owner	project:update
global:owner	project:delete
global:owner	project:list
global:owner	saml:manage
global:owner	securityAudit:generate
global:owner	sourceControl:pull
global:owner	sourceControl:push
global:owner	sourceControl:manage
global:owner	tag:create
global:owner	tag:read
global:owner	tag:update
global:owner	tag:delete
global:owner	tag:list
global:owner	user:resetPassword
global:owner	user:changeRole
global:owner	user:enforceMfa
global:owner	user:create
global:owner	user:read
global:owner	user:update
global:owner	user:delete
global:owner	user:list
global:owner	variable:create
global:owner	variable:read
global:owner	variable:update
global:owner	variable:delete
global:owner	variable:list
global:owner	projectVariable:create
global:owner	projectVariable:read
global:owner	projectVariable:update
global:owner	projectVariable:delete
global:owner	projectVariable:list
global:owner	workersView:manage
global:owner	workflow:share
global:owner	workflow:execute
global:owner	workflow:move
global:owner	workflow:create
global:owner	workflow:read
global:owner	workflow:update
global:owner	workflow:delete
global:owner	workflow:list
global:owner	folder:create
global:owner	folder:read
global:owner	folder:update
global:owner	folder:delete
global:owner	folder:list
global:owner	folder:move
global:owner	insights:list
global:owner	oidc:manage
global:owner	provisioning:manage
global:owner	dataTable:create
global:owner	dataTable:read
global:owner	dataTable:update
global:owner	dataTable:delete
global:owner	dataTable:list
global:owner	dataTable:readRow
global:owner	dataTable:writeRow
global:owner	dataTable:listProject
global:owner	role:manage
global:owner	mcp:manage
global:owner	mcp:oauth
global:owner	mcpApiKey:create
global:owner	mcpApiKey:rotate
global:owner	chatHub:manage
global:owner	chatHub:message
global:owner	chatHubAgent:create
global:owner	chatHubAgent:read
global:owner	chatHubAgent:update
global:owner	chatHubAgent:delete
global:owner	chatHubAgent:list
global:owner	breakingChanges:list
global:admin	annotationTag:create
global:admin	annotationTag:read
global:admin	annotationTag:update
global:admin	annotationTag:delete
global:admin	annotationTag:list
global:admin	auditLogs:manage
global:admin	banner:dismiss
global:admin	community:register
global:admin	communityPackage:install
global:admin	communityPackage:uninstall
global:admin	communityPackage:update
global:admin	communityPackage:list
global:admin	credential:share
global:admin	credential:shareGlobally
global:admin	credential:move
global:admin	credential:create
global:admin	credential:read
global:admin	credential:update
global:admin	credential:delete
global:admin	credential:list
global:admin	externalSecretsProvider:sync
global:admin	externalSecretsProvider:create
global:admin	externalSecretsProvider:read
global:admin	externalSecretsProvider:update
global:admin	externalSecretsProvider:delete
global:admin	externalSecretsProvider:list
global:admin	externalSecret:list
global:admin	externalSecret:use
global:admin	eventBusDestination:test
global:admin	eventBusDestination:create
global:admin	eventBusDestination:read
global:admin	eventBusDestination:update
global:admin	eventBusDestination:delete
global:admin	eventBusDestination:list
global:admin	ldap:sync
global:admin	ldap:manage
global:admin	license:manage
global:admin	logStreaming:manage
global:admin	orchestration:read
global:admin	project:create
global:admin	project:read
global:admin	project:update
global:admin	project:delete
global:admin	project:list
global:admin	saml:manage
global:admin	securityAudit:generate
global:admin	sourceControl:pull
global:admin	sourceControl:push
global:admin	sourceControl:manage
global:admin	tag:create
global:admin	tag:read
global:admin	tag:update
global:admin	tag:delete
global:admin	tag:list
global:admin	user:resetPassword
global:admin	user:changeRole
global:admin	user:enforceMfa
global:admin	user:create
global:admin	user:read
global:admin	user:update
global:admin	user:delete
global:admin	user:list
global:admin	variable:create
global:admin	variable:read
global:admin	variable:update
global:admin	variable:delete
global:admin	variable:list
global:admin	projectVariable:create
global:admin	projectVariable:read
global:admin	projectVariable:update
global:admin	projectVariable:delete
global:admin	projectVariable:list
global:admin	workersView:manage
global:admin	workflow:share
global:admin	workflow:execute
global:admin	workflow:move
global:admin	workflow:create
global:admin	workflow:read
global:admin	workflow:update
global:admin	workflow:delete
global:admin	workflow:list
global:admin	folder:create
global:admin	folder:read
global:admin	folder:update
global:admin	folder:delete
global:admin	folder:list
global:admin	folder:move
global:admin	insights:list
global:admin	oidc:manage
global:admin	provisioning:manage
global:admin	dataTable:create
global:admin	dataTable:read
global:admin	dataTable:update
global:admin	dataTable:delete
global:admin	dataTable:list
global:admin	dataTable:readRow
global:admin	dataTable:writeRow
global:admin	dataTable:listProject
global:admin	role:manage
global:admin	mcp:manage
global:admin	mcp:oauth
global:admin	mcpApiKey:create
global:admin	mcpApiKey:rotate
global:admin	chatHub:manage
global:admin	chatHub:message
global:admin	chatHubAgent:create
global:admin	chatHubAgent:read
global:admin	chatHubAgent:update
global:admin	chatHubAgent:delete
global:admin	chatHubAgent:list
global:admin	breakingChanges:list
global:member	annotationTag:create
global:member	annotationTag:read
global:member	annotationTag:update
global:member	annotationTag:delete
global:member	annotationTag:list
global:member	eventBusDestination:test
global:member	eventBusDestination:list
global:member	tag:create
global:member	tag:read
global:member	tag:update
global:member	tag:list
global:member	user:list
global:member	variable:read
global:member	variable:list
global:member	dataTable:list
global:member	mcp:oauth
global:member	mcpApiKey:create
global:member	mcpApiKey:rotate
global:member	chatHub:message
global:member	chatHubAgent:create
global:member	chatHubAgent:read
global:member	chatHubAgent:update
global:member	chatHubAgent:delete
global:member	chatHubAgent:list
project:admin	credential:share
project:admin	credential:move
project:admin	credential:create
project:admin	credential:read
project:admin	credential:update
project:admin	credential:delete
project:admin	credential:list
project:admin	project:read
project:admin	project:update
project:admin	project:delete
project:admin	project:list
project:admin	sourceControl:push
project:admin	projectVariable:create
project:admin	projectVariable:read
project:admin	projectVariable:update
project:admin	projectVariable:delete
project:admin	projectVariable:list
project:admin	workflow:execute
project:admin	workflow:move
project:admin	workflow:create
project:admin	workflow:read
project:admin	workflow:update
project:admin	workflow:delete
project:admin	workflow:list
project:admin	folder:create
project:admin	folder:read
project:admin	folder:update
project:admin	folder:delete
project:admin	folder:list
project:admin	folder:move
project:admin	dataTable:create
project:admin	dataTable:read
project:admin	dataTable:update
project:admin	dataTable:delete
project:admin	dataTable:readRow
project:admin	dataTable:writeRow
project:admin	dataTable:listProject
project:personalOwner	credential:share
project:personalOwner	credential:move
project:personalOwner	credential:create
project:personalOwner	credential:read
project:personalOwner	credential:update
project:personalOwner	credential:delete
project:personalOwner	credential:list
project:personalOwner	project:read
project:personalOwner	project:list
project:personalOwner	workflow:share
project:personalOwner	workflow:execute
project:personalOwner	workflow:move
project:personalOwner	workflow:create
project:personalOwner	workflow:read
project:personalOwner	workflow:update
project:personalOwner	workflow:delete
project:personalOwner	workflow:list
project:personalOwner	folder:create
project:personalOwner	folder:read
project:personalOwner	folder:update
project:personalOwner	folder:delete
project:personalOwner	folder:list
project:personalOwner	folder:move
project:personalOwner	dataTable:create
project:personalOwner	dataTable:read
project:personalOwner	dataTable:update
project:personalOwner	dataTable:delete
project:personalOwner	dataTable:readRow
project:personalOwner	dataTable:writeRow
project:personalOwner	dataTable:listProject
project:editor	credential:create
project:editor	credential:read
project:editor	credential:update
project:editor	credential:delete
project:editor	credential:list
project:editor	project:read
project:editor	project:list
project:editor	projectVariable:create
project:editor	projectVariable:read
project:editor	projectVariable:update
project:editor	projectVariable:delete
project:editor	projectVariable:list
project:editor	workflow:execute
project:editor	workflow:create
project:editor	workflow:read
project:editor	workflow:update
project:editor	workflow:delete
project:editor	workflow:list
project:editor	folder:create
project:editor	folder:read
project:editor	folder:update
project:editor	folder:delete
project:editor	folder:list
project:editor	dataTable:create
project:editor	dataTable:read
project:editor	dataTable:update
project:editor	dataTable:delete
project:editor	dataTable:readRow
project:editor	dataTable:writeRow
project:editor	dataTable:listProject
project:viewer	credential:read
project:viewer	credential:list
project:viewer	project:read
project:viewer	project:list
project:viewer	projectVariable:read
project:viewer	projectVariable:list
project:viewer	workflow:read
project:viewer	workflow:list
project:viewer	folder:read
project:viewer	folder:list
project:viewer	dataTable:read
project:viewer	dataTable:readRow
project:viewer	dataTable:listProject
credential:owner	credential:share
credential:owner	credential:move
credential:owner	credential:read
credential:owner	credential:update
credential:owner	credential:delete
credential:user	credential:read
workflow:owner	workflow:share
workflow:owner	workflow:execute
workflow:owner	workflow:move
workflow:owner	workflow:read
workflow:owner	workflow:update
workflow:owner	workflow:delete
workflow:editor	workflow:execute
workflow:editor	workflow:read
workflow:editor	workflow:update
\.


--
-- Data for Name: scope; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scope (slug, "displayName", description) FROM stdin;
annotationTag:create	Create Annotation Tag	Allows creating new annotation tags.
annotationTag:read	annotationTag:read	\N
annotationTag:update	annotationTag:update	\N
annotationTag:delete	annotationTag:delete	\N
annotationTag:list	annotationTag:list	\N
annotationTag:*	annotationTag:*	\N
auditLogs:manage	auditLogs:manage	\N
auditLogs:*	auditLogs:*	\N
banner:dismiss	banner:dismiss	\N
banner:*	banner:*	\N
community:register	community:register	\N
community:*	community:*	\N
communityPackage:install	communityPackage:install	\N
communityPackage:uninstall	communityPackage:uninstall	\N
communityPackage:update	communityPackage:update	\N
communityPackage:list	communityPackage:list	\N
communityPackage:manage	communityPackage:manage	\N
communityPackage:*	communityPackage:*	\N
credential:share	credential:share	\N
credential:shareGlobally	credential:shareGlobally	\N
credential:move	credential:move	\N
credential:create	credential:create	\N
credential:read	credential:read	\N
credential:update	credential:update	\N
credential:delete	credential:delete	\N
credential:list	credential:list	\N
credential:*	credential:*	\N
externalSecretsProvider:sync	externalSecretsProvider:sync	\N
externalSecretsProvider:create	externalSecretsProvider:create	\N
externalSecretsProvider:read	externalSecretsProvider:read	\N
externalSecretsProvider:update	externalSecretsProvider:update	\N
externalSecretsProvider:delete	externalSecretsProvider:delete	\N
externalSecretsProvider:list	externalSecretsProvider:list	\N
externalSecretsProvider:*	externalSecretsProvider:*	\N
externalSecret:list	externalSecret:list	\N
externalSecret:use	externalSecret:use	\N
externalSecret:*	externalSecret:*	\N
eventBusDestination:test	eventBusDestination:test	\N
eventBusDestination:create	eventBusDestination:create	\N
eventBusDestination:read	eventBusDestination:read	\N
eventBusDestination:update	eventBusDestination:update	\N
eventBusDestination:delete	eventBusDestination:delete	\N
eventBusDestination:list	eventBusDestination:list	\N
eventBusDestination:*	eventBusDestination:*	\N
ldap:sync	ldap:sync	\N
ldap:manage	ldap:manage	\N
ldap:*	ldap:*	\N
license:manage	license:manage	\N
license:*	license:*	\N
logStreaming:manage	logStreaming:manage	\N
logStreaming:*	logStreaming:*	\N
orchestration:read	orchestration:read	\N
orchestration:list	orchestration:list	\N
orchestration:*	orchestration:*	\N
project:create	project:create	\N
project:read	project:read	\N
project:update	project:update	\N
project:delete	project:delete	\N
project:list	project:list	\N
project:*	project:*	\N
saml:manage	saml:manage	\N
saml:*	saml:*	\N
securityAudit:generate	securityAudit:generate	\N
securityAudit:*	securityAudit:*	\N
sourceControl:pull	sourceControl:pull	\N
sourceControl:push	sourceControl:push	\N
sourceControl:manage	sourceControl:manage	\N
sourceControl:*	sourceControl:*	\N
tag:create	tag:create	\N
tag:read	tag:read	\N
tag:update	tag:update	\N
tag:delete	tag:delete	\N
tag:list	tag:list	\N
tag:*	tag:*	\N
user:resetPassword	user:resetPassword	\N
user:changeRole	user:changeRole	\N
user:enforceMfa	user:enforceMfa	\N
user:create	user:create	\N
user:read	user:read	\N
user:update	user:update	\N
user:delete	user:delete	\N
user:list	user:list	\N
user:*	user:*	\N
variable:create	variable:create	\N
variable:read	variable:read	\N
variable:update	variable:update	\N
variable:delete	variable:delete	\N
variable:list	variable:list	\N
variable:*	variable:*	\N
projectVariable:create	projectVariable:create	\N
projectVariable:read	projectVariable:read	\N
projectVariable:update	projectVariable:update	\N
projectVariable:delete	projectVariable:delete	\N
projectVariable:list	projectVariable:list	\N
projectVariable:*	projectVariable:*	\N
workersView:manage	workersView:manage	\N
workersView:*	workersView:*	\N
workflow:share	workflow:share	\N
workflow:execute	workflow:execute	\N
workflow:move	workflow:move	\N
workflow:activate	workflow:activate	\N
workflow:deactivate	workflow:deactivate	\N
workflow:create	workflow:create	\N
workflow:read	workflow:read	\N
workflow:update	workflow:update	\N
workflow:delete	workflow:delete	\N
workflow:list	workflow:list	\N
workflow:*	workflow:*	\N
folder:create	folder:create	\N
folder:read	folder:read	\N
folder:update	folder:update	\N
folder:delete	folder:delete	\N
folder:list	folder:list	\N
folder:move	folder:move	\N
folder:*	folder:*	\N
insights:list	insights:list	\N
insights:*	insights:*	\N
oidc:manage	oidc:manage	\N
oidc:*	oidc:*	\N
provisioning:manage	provisioning:manage	\N
provisioning:*	provisioning:*	\N
dataTable:create	dataTable:create	\N
dataTable:read	dataTable:read	\N
dataTable:update	dataTable:update	\N
dataTable:delete	dataTable:delete	\N
dataTable:list	dataTable:list	\N
dataTable:readRow	dataTable:readRow	\N
dataTable:writeRow	dataTable:writeRow	\N
dataTable:listProject	dataTable:listProject	\N
dataTable:*	dataTable:*	\N
execution:delete	execution:delete	\N
execution:read	execution:read	\N
execution:retry	execution:retry	\N
execution:list	execution:list	\N
execution:get	execution:get	\N
execution:*	execution:*	\N
workflowTags:update	workflowTags:update	\N
workflowTags:list	workflowTags:list	\N
workflowTags:*	workflowTags:*	\N
role:manage	role:manage	\N
role:*	role:*	\N
mcp:manage	mcp:manage	\N
mcp:oauth	mcp:oauth	\N
mcp:*	mcp:*	\N
mcpApiKey:create	mcpApiKey:create	\N
mcpApiKey:rotate	mcpApiKey:rotate	\N
mcpApiKey:*	mcpApiKey:*	\N
chatHub:manage	chatHub:manage	\N
chatHub:message	chatHub:message	\N
chatHub:*	chatHub:*	\N
chatHubAgent:create	chatHubAgent:create	\N
chatHubAgent:read	chatHubAgent:read	\N
chatHubAgent:update	chatHubAgent:update	\N
chatHubAgent:delete	chatHubAgent:delete	\N
chatHubAgent:list	chatHubAgent:list	\N
chatHubAgent:*	chatHubAgent:*	\N
breakingChanges:list	breakingChanges:list	\N
breakingChanges:*	breakingChanges:*	\N
*	*	\N
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (key, value, "loadOnStartup") FROM stdin;
ui.banners.dismissed	["V1"]	t
features.ldap	{"loginEnabled":false,"loginLabel":"","connectionUrl":"","allowUnauthorizedCerts":false,"connectionSecurity":"none","connectionPort":389,"baseDn":"","bindingAdminDn":"","bindingAdminPassword":"","firstNameAttribute":"","lastNameAttribute":"","emailAttribute":"","loginIdAttribute":"","ldapIdAttribute":"","userFilter":"","synchronizationEnabled":false,"synchronizationInterval":60,"searchPageSize":0,"searchTimeout":60,"enforceEmailUniqueness":true}	t
userManagement.authenticationMethod	email	t
features.sourceControl.sshKeys	{"encryptedPrivateKey":"U2FsdGVkX18xkryYZoQSBbXFiSWYmfKyxd1+9Y9Av+StvhuWJTN50GYsSkZjzdxOhIOLEvfClD/7aH7kcQcMyQlj+dFSi5Plm7Q9Jw2jYdRz5hOs1cqM1V8ZIBiebohMgNrCPfxg+x+2LZIt0HdUDLJCKNPTwMx92vFfealwO+3Qz/DdWZ30ifBon8Hz2ofnQvn6Sa0LV/OTAcw5gX8rxf7DPAq2vpJWvEFTuQkwO8eHEu7NmTcACiUGkAwsmPjAfIygeAJgaimWk8wFJjAin4wif19eEzV8TdOPG/cTPnde+qLcS+v3gu3tsXL3Yp4AdxvYoad5q0V1E/a0yTMlFqZPzf8WumjgjV30C55cGS+rGgC/qGehZihU7tfRImS1ozRiT8uI6dzZKma23wgzrmDC9MjFGGBGfVz9ikqBLUjd41IVHeR+W3A9XS/bRBZLeH5dw1dUaEPa918YZ6sulaR4mI+X9Gtjgjm6O1YHeNdaW6oi+/65qih6x9lgLPks3V70QYqX7Cxcl6QeRPuxZpEoDQtzMmMwz9SQ4q/+myXFkMyRRvK3od+rnrTJXpbB","publicKey":"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJ0NmqE16Rn9TlzGr1YBitVwYGZuj6nMNjtWvrCun8h n8n deploy key"}	t
features.sourceControl	{"branchName":"main","connectionType":"ssh","keyGeneratorType":"ed25519"}	t
userManagement.isInstanceOwnerSetUp	true	t
\.


--
-- Data for Name: shared_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shared_credentials ("credentialsId", "projectId", role, "createdAt", "updatedAt") FROM stdin;
8B4veqf8KNWGC8JZ	0CN8XszDlJ5vvU6x	credential:owner	2026-01-31 20:01:52.541+00	2026-01-31 20:01:52.541+00
58owXAszp4WjT45r	0CN8XszDlJ5vvU6x	credential:owner	2026-02-01 09:24:49.698+00	2026-02-01 09:24:49.698+00
6VWVaKQcD9oo6cZw	0CN8XszDlJ5vvU6x	credential:owner	2026-02-01 09:28:04.881+00	2026-02-01 09:28:04.881+00
\.


--
-- Data for Name: shared_workflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shared_workflow ("workflowId", "projectId", role, "createdAt", "updatedAt") FROM stdin;
isoQysSMexnHA8Q8	0CN8XszDlJ5vvU6x	workflow:owner	2026-01-31 20:02:00.424+00	2026-01-31 20:02:00.424+00
\.


--
-- Data for Name: tag_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag_entity (name, "createdAt", "updatedAt", id) FROM stdin;
\.


--
-- Data for Name: test_case_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_case_execution (id, "testRunId", "executionId", status, "runAt", "completedAt", "errorCode", "errorDetails", metrics, "createdAt", "updatedAt", inputs, outputs) FROM stdin;
\.


--
-- Data for Name: test_run; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_run (id, "workflowId", status, "errorCode", "errorDetails", "runAt", "completedAt", metrics, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, email, "firstName", "lastName", password, "personalizationAnswers", "createdAt", "updatedAt", settings, disabled, "mfaEnabled", "mfaSecret", "mfaRecoveryCodes", "lastActiveAt", "roleSlug") FROM stdin;
e5488568-93d0-4754-800b-c743b6623ca3	eliapinmortec3@gmail.com	Elia	Pineda Moreno	$2a$10$25grDxskRKCHe84AKUjtbevNNbRkLaMgzy4OtETAYhHcaTqc4qxuW	{"version":"v4","personalization_survey_submitted_at":"2026-01-31T20:00:34.162Z","personalization_survey_n8n_version":"2.0.3"}	2026-01-31 20:00:06.545+00	2026-02-01 10:21:22.983+00	{"userActivated": false}	f	f	\N	\N	2026-02-01	global:owner
\.


--
-- Data for Name: user_api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_api_keys (id, "userId", label, "apiKey", "createdAt", "updatedAt", scopes, audience) FROM stdin;
\.


--
-- Data for Name: variables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variables (key, type, value, id, "projectId") FROM stdin;
\.


--
-- Data for Name: webhook_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.webhook_entity ("webhookPath", method, node, "webhookId", "pathLength", "workflowId") FROM stdin;
\.


--
-- Data for Name: workflow_dependency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_dependency (id, "workflowId", "workflowVersionId", "dependencyType", "dependencyKey", "dependencyInfo", "indexVersionId", "createdAt") FROM stdin;
\.


--
-- Data for Name: workflow_entity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_entity (name, active, nodes, connections, "createdAt", "updatedAt", settings, "staticData", "pinData", "versionId", "triggerCount", id, meta, "parentFolderId", "isArchived", "versionCounter", description, "activeVersionId") FROM stdin;
My workflow	f	[{"parameters":{"operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $('Webhook').item.json.body.success }}","rightValue":"\\"true\\"","operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"chatId":"8271192543","text":"Se ha encontrado al menos un registro","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"chatId":"8271192543","text":"No se han encontrado ningún registro","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"httpMethod":"POST","path":"notificacion","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}]	{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}}	2026-01-31 20:02:00.424+00	2026-02-01 10:21:22.995+00	{"executionOrder":"v1"}	\N	{}	a965813c-812d-411a-b7ad-c0bdc3b04a7a	0	isoQysSMexnHA8Q8	{"templateCredsSetupCompleted":true}	\N	f	3	\N	\N
\.


--
-- Data for Name: workflow_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_history ("versionId", "workflowId", authors, "createdAt", "updatedAt", nodes, connections, name, autosaved, description) FROM stdin;
6bc5ab15-d826-4207-b158-794169058694	isoQysSMexnHA8Q8	Elia Pineda Moreno	2026-01-31 20:02:00.424+00	2026-01-31 20:02:00.424+00	[{"parameters":{"operation":"executeQuery","query":"select * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"chatId":"8271192543","text":"Se ha encontrado al menos un registro","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6"},{"parameters":{"fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055"},{"parameters":{"fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af"},{"parameters":{"chatId":"8271192543","text":"No se han encontrado ningún registro","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db"},{"parameters":{"httpMethod":"POST","path":"notificacion","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}]	{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}}	\N	f	\N
4f8917b3-0471-481d-a34c-861d4c86d27a	isoQysSMexnHA8Q8	Elia Pineda Moreno	2026-02-01 09:56:50.693+00	2026-02-01 09:56:50.693+00	[{"parameters":{"operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $json.body.success }}","rightValue":0,"operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"chatId":"8271192543","text":"Se ha encontrado al menos un registro","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"chatId":"8271192543","text":"No se han encontrado ningún registro","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"httpMethod":"POST","path":"notificacion","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}]	{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}}	\N	f	\N
a965813c-812d-411a-b7ad-c0bdc3b04a7a	isoQysSMexnHA8Q8	Elia Pineda Moreno	2026-02-01 10:21:23.002+00	2026-02-01 10:21:23.002+00	[{"parameters":{"operation":"executeQuery","query":"SELECT * FROM backups_log;","options":{}},"type":"n8n-nodes-base.postgres","typeVersion":2.6,"position":[-496,224],"id":"b751cef2-226b-4dc5-8334-fd64c5cf7603","name":"Execute a SQL query","alwaysOutputData":true,"credentials":{"postgres":{"id":"8B4veqf8KNWGC8JZ","name":"Postgres account"}}},{"parameters":{"conditions":{"options":{"caseSensitive":true,"leftValue":"","typeValidation":"strict","version":3},"conditions":[{"id":"4edc2b41-cffe-4dfb-bded-e8ab55fec1ac","leftValue":"={{ $('Webhook').item.json.body.success }}","rightValue":"\\"true\\"","operator":{"type":"boolean","operation":"true","singleValue":true}}],"combinator":"and"},"options":{}},"type":"n8n-nodes-base.if","typeVersion":2.3,"position":[-288,224],"id":"268cdb69-6267-45f1-a4ff-170b421e5678","name":"If"},{"parameters":{"chatId":"8271192543","text":"Se ha encontrado al menos un registro","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,0],"id":"87fa99da-ccc0-4d3f-aeb2-b9b3a271d05f","name":"Send a text message","webhookId":"9ca79a81-e644-4147-8485-9ffee263b0f6","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup OK","html":"=<h2 style=\\"color:green;\\">Backup OK</h2>\\n<p>Se han encontrado registros en <strong>backups_log</strong>.</p>\\n<p>Fecha comprobación: {{$now}}</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,176],"id":"391ef67f-3f22-4f9a-ae87-bfc3e349ffe3","name":"Send email","webhookId":"cdb96753-5779-4029-9463-d0651a8ed055","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"fromEmail":"eliapinedamoreno@gmail.com","toEmail":"eliapinedamoreno@gmail.com","subject":"Backup NOK","html":"<h2 style=\\"color:red;\\">Backup NOK</h2>\\n<p>No se han encontrado registros en la tabla <strong>backups_log</strong>.</p>\\n<p>Revisar proceso de copias inmediatamente.</p>\\n","options":{}},"type":"n8n-nodes-base.emailSend","typeVersion":2.1,"position":[0,496],"id":"e0e1b85a-57b6-40b7-9d38-c9241a8b33b7","name":"Send email1","webhookId":"0504a9ad-ff59-42ff-9323-fe18ce9b73af","credentials":{"smtp":{"id":"6VWVaKQcD9oo6cZw","name":"SMTP account"}}},{"parameters":{"chatId":"8271192543","text":"No se han encontrado ningún registro","additionalFields":{}},"type":"n8n-nodes-base.telegram","typeVersion":1.2,"position":[0,336],"id":"8e7069bc-90db-46d9-a8e3-ebaf6fd93228","name":"Send a text message NOK","webhookId":"7fae5ac5-2305-4c67-970d-f186be8066db","credentials":{"telegramApi":{"id":"58owXAszp4WjT45r","name":"Telegram account"}}},{"parameters":{"httpMethod":"POST","path":"notificacion","options":{}},"type":"n8n-nodes-base.webhook","typeVersion":2.1,"position":[-672,224],"id":"feccca3c-5a2c-4bed-8728-b6a22f8a7f0f","name":"Webhook","webhookId":"8cdd1580-3d56-4430-8468-3ac621018a0e"}]	{"Execute a SQL query":{"main":[[{"node":"If","type":"main","index":0}]]},"If":{"main":[[{"node":"Send a text message","type":"main","index":0},{"node":"Send email","type":"main","index":0}],[{"node":"Send a text message NOK","type":"main","index":0},{"node":"Send email1","type":"main","index":0}]]},"Webhook":{"main":[[{"node":"Execute a SQL query","type":"main","index":0}]]}}	\N	f	\N
\.


--
-- Data for Name: workflow_publish_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_publish_history (id, "workflowId", "versionId", event, "userId", "createdAt") FROM stdin;
\.


--
-- Data for Name: workflow_statistics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_statistics (count, "latestEvent", name, "workflowId", "rootCount") FROM stdin;
1	2026-02-01 09:30:13.699+00	data_loaded	isoQysSMexnHA8Q8	1
4	2026-02-01 09:58:09.199+00	manual_error	isoQysSMexnHA8Q8	0
9	2026-02-01 09:58:17.588+00	manual_success	isoQysSMexnHA8Q8	0
\.


--
-- Data for Name: workflows_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflows_tags ("workflowId", "tagId") FROM stdin;
\.


--
-- Name: auth_provider_sync_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_provider_sync_history_id_seq', 1, false);


--
-- Name: backups_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.backups_log_id_seq', 2, true);


--
-- Name: execution_annotations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.execution_annotations_id_seq', 1, false);


--
-- Name: execution_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.execution_entity_id_seq', 13, true);


--
-- Name: execution_metadata_temp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.execution_metadata_temp_id_seq', 1, false);


--
-- Name: insights_by_period_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insights_by_period_id_seq', 1, false);


--
-- Name: insights_metadata_metaId_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."insights_metadata_metaId_seq"', 1, false);


--
-- Name: insights_raw_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insights_raw_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 123, true);


--
-- Name: oauth_user_consents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oauth_user_consents_id_seq', 1, false);


--
-- Name: workflow_dependency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_dependency_id_seq', 1, false);


--
-- Name: workflow_publish_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workflow_publish_history_id_seq', 1, false);


--
-- Name: test_run PK_011c050f566e9db509a0fadb9b9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_run
    ADD CONSTRAINT "PK_011c050f566e9db509a0fadb9b9" PRIMARY KEY (id);


--
-- Name: installed_packages PK_08cc9197c39b028c1e9beca225940576fd1a5804; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installed_packages
    ADD CONSTRAINT "PK_08cc9197c39b028c1e9beca225940576fd1a5804" PRIMARY KEY ("packageName");


--
-- Name: execution_metadata PK_17a0b6284f8d626aae88e1c16e4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_metadata
    ADD CONSTRAINT "PK_17a0b6284f8d626aae88e1c16e4" PRIMARY KEY (id);


--
-- Name: project_relation PK_1caaa312a5d7184a003be0f0cb6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_relation
    ADD CONSTRAINT "PK_1caaa312a5d7184a003be0f0cb6" PRIMARY KEY ("projectId", "userId");


--
-- Name: chat_hub_sessions PK_1eafef1273c70e4464fec703412; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_sessions
    ADD CONSTRAINT "PK_1eafef1273c70e4464fec703412" PRIMARY KEY (id);


--
-- Name: folder_tag PK_27e4e00852f6b06a925a4d83a3e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folder_tag
    ADD CONSTRAINT "PK_27e4e00852f6b06a925a4d83a3e" PRIMARY KEY ("folderId", "tagId");


--
-- Name: role PK_35c9b140caaf6da09cfabb0d675; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "PK_35c9b140caaf6da09cfabb0d675" PRIMARY KEY (slug);


--
-- Name: project PK_4d68b1358bb5b766d3e78f32f57; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT "PK_4d68b1358bb5b766d3e78f32f57" PRIMARY KEY (id);


--
-- Name: workflow_dependency PK_52325e34cd7a2f0f67b0f3cad65; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_dependency
    ADD CONSTRAINT "PK_52325e34cd7a2f0f67b0f3cad65" PRIMARY KEY (id);


--
-- Name: invalid_auth_token PK_5779069b7235b256d91f7af1a15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invalid_auth_token
    ADD CONSTRAINT "PK_5779069b7235b256d91f7af1a15" PRIMARY KEY (token);


--
-- Name: shared_workflow PK_5ba87620386b847201c9531c58f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared_workflow
    ADD CONSTRAINT "PK_5ba87620386b847201c9531c58f" PRIMARY KEY ("workflowId", "projectId");


--
-- Name: folder PK_6278a41a706740c94c02e288df8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folder
    ADD CONSTRAINT "PK_6278a41a706740c94c02e288df8" PRIMARY KEY (id);


--
-- Name: data_table_column PK_673cb121ee4a8a5e27850c72c51; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table_column
    ADD CONSTRAINT "PK_673cb121ee4a8a5e27850c72c51" PRIMARY KEY (id);


--
-- Name: annotation_tag_entity PK_69dfa041592c30bbc0d4b84aa00; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.annotation_tag_entity
    ADD CONSTRAINT "PK_69dfa041592c30bbc0d4b84aa00" PRIMARY KEY (id);


--
-- Name: oauth_refresh_tokens PK_74abaed0b30711b6532598b0392; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_refresh_tokens
    ADD CONSTRAINT "PK_74abaed0b30711b6532598b0392" PRIMARY KEY (token);


--
-- Name: chat_hub_messages PK_7704a5add6baed43eef835f0bfb; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_messages
    ADD CONSTRAINT "PK_7704a5add6baed43eef835f0bfb" PRIMARY KEY (id);


--
-- Name: execution_annotations PK_7afcf93ffa20c4252869a7c6a23; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_annotations
    ADD CONSTRAINT "PK_7afcf93ffa20c4252869a7c6a23" PRIMARY KEY (id);


--
-- Name: oauth_user_consents PK_85b9ada746802c8993103470f05; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_user_consents
    ADD CONSTRAINT "PK_85b9ada746802c8993103470f05" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: installed_nodes PK_8ebd28194e4f792f96b5933423fc439df97d9689; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installed_nodes
    ADD CONSTRAINT "PK_8ebd28194e4f792f96b5933423fc439df97d9689" PRIMARY KEY (name);


--
-- Name: shared_credentials PK_8ef3a59796a228913f251779cff; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared_credentials
    ADD CONSTRAINT "PK_8ef3a59796a228913f251779cff" PRIMARY KEY ("credentialsId", "projectId");


--
-- Name: test_case_execution PK_90c121f77a78a6580e94b794bce; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_case_execution
    ADD CONSTRAINT "PK_90c121f77a78a6580e94b794bce" PRIMARY KEY (id);


--
-- Name: user_api_keys PK_978fa5caa3468f463dac9d92e69; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_keys
    ADD CONSTRAINT "PK_978fa5caa3468f463dac9d92e69" PRIMARY KEY (id);


--
-- Name: execution_annotation_tags PK_979ec03d31294cca484be65d11f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_annotation_tags
    ADD CONSTRAINT "PK_979ec03d31294cca484be65d11f" PRIMARY KEY ("annotationId", "tagId");


--
-- Name: webhook_entity PK_b21ace2e13596ccd87dc9bf4ea6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.webhook_entity
    ADD CONSTRAINT "PK_b21ace2e13596ccd87dc9bf4ea6" PRIMARY KEY ("webhookPath", method);


--
-- Name: insights_by_period PK_b606942249b90cc39b0265f0575; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insights_by_period
    ADD CONSTRAINT "PK_b606942249b90cc39b0265f0575" PRIMARY KEY (id);


--
-- Name: workflow_history PK_b6572dd6173e4cd06fe79937b58; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_history
    ADD CONSTRAINT "PK_b6572dd6173e4cd06fe79937b58" PRIMARY KEY ("versionId");


--
-- Name: scope PK_bfc45df0481abd7f355d6187da1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT "PK_bfc45df0481abd7f355d6187da1" PRIMARY KEY (slug);


--
-- Name: oauth_clients PK_c4759172d3431bae6f04e678e0d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_clients
    ADD CONSTRAINT "PK_c4759172d3431bae6f04e678e0d" PRIMARY KEY (id);


--
-- Name: workflow_publish_history PK_c788f7caf88e91e365c97d6d04a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_publish_history
    ADD CONSTRAINT "PK_c788f7caf88e91e365c97d6d04a" PRIMARY KEY (id);


--
-- Name: processed_data PK_ca04b9d8dc72de268fe07a65773; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.processed_data
    ADD CONSTRAINT "PK_ca04b9d8dc72de268fe07a65773" PRIMARY KEY ("workflowId", context);


--
-- Name: settings PK_dc0fe14e6d9943f268e7b119f69ab8bd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT "PK_dc0fe14e6d9943f268e7b119f69ab8bd" PRIMARY KEY (key);


--
-- Name: oauth_access_tokens PK_dcd71f96a5d5f4bf79e67d322bf; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT "PK_dcd71f96a5d5f4bf79e67d322bf" PRIMARY KEY (token);


--
-- Name: data_table PK_e226d0001b9e6097cbfe70617cb; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table
    ADD CONSTRAINT "PK_e226d0001b9e6097cbfe70617cb" PRIMARY KEY (id);


--
-- Name: user PK_ea8f538c94b6e352418254ed6474a81f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_ea8f538c94b6e352418254ed6474a81f" PRIMARY KEY (id);


--
-- Name: insights_raw PK_ec15125755151e3a7e00e00014f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insights_raw
    ADD CONSTRAINT "PK_ec15125755151e3a7e00e00014f" PRIMARY KEY (id);


--
-- Name: chat_hub_agents PK_f39a3b36bbdf0e2979ddb21cf78; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_agents
    ADD CONSTRAINT "PK_f39a3b36bbdf0e2979ddb21cf78" PRIMARY KEY (id);


--
-- Name: insights_metadata PK_f448a94c35218b6208ce20cf5a1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insights_metadata
    ADD CONSTRAINT "PK_f448a94c35218b6208ce20cf5a1" PRIMARY KEY ("metaId");


--
-- Name: oauth_authorization_codes PK_fb91ab932cfbd694061501cc20f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_authorization_codes
    ADD CONSTRAINT "PK_fb91ab932cfbd694061501cc20f" PRIMARY KEY (code);


--
-- Name: binary_data PK_fc3691585b39408bb0551122af6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.binary_data
    ADD CONSTRAINT "PK_fc3691585b39408bb0551122af6" PRIMARY KEY ("fileId");


--
-- Name: role_scope PK_role_scope; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_scope
    ADD CONSTRAINT "PK_role_scope" PRIMARY KEY ("roleSlug", "scopeSlug");


--
-- Name: oauth_user_consents UQ_083721d99ce8db4033e2958ebb4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_user_consents
    ADD CONSTRAINT "UQ_083721d99ce8db4033e2958ebb4" UNIQUE ("userId", "clientId");


--
-- Name: data_table_column UQ_8082ec4890f892f0bc77473a123; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table_column
    ADD CONSTRAINT "UQ_8082ec4890f892f0bc77473a123" UNIQUE ("dataTableId", name);


--
-- Name: data_table UQ_b23096ef747281ac944d28e8b0d; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table
    ADD CONSTRAINT "UQ_b23096ef747281ac944d28e8b0d" UNIQUE ("projectId", name);


--
-- Name: user UQ_e12875dfb3b1d92d7d7c5377e2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e2" UNIQUE (email);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY ("providerId", "providerType");


--
-- Name: auth_provider_sync_history auth_provider_sync_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_provider_sync_history
    ADD CONSTRAINT auth_provider_sync_history_pkey PRIMARY KEY (id);


--
-- Name: backups_log backups_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backups_log
    ADD CONSTRAINT backups_log_pkey PRIMARY KEY (id);


--
-- Name: credentials_entity credentials_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credentials_entity
    ADD CONSTRAINT credentials_entity_pkey PRIMARY KEY (id);


--
-- Name: event_destinations event_destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_destinations
    ADD CONSTRAINT event_destinations_pkey PRIMARY KEY (id);


--
-- Name: execution_data execution_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_data
    ADD CONSTRAINT execution_data_pkey PRIMARY KEY ("executionId");


--
-- Name: execution_entity pk_e3e63bbf986767844bbe1166d4e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_entity
    ADD CONSTRAINT pk_e3e63bbf986767844bbe1166d4e PRIMARY KEY (id);


--
-- Name: workflow_statistics pk_workflow_statistics; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_statistics
    ADD CONSTRAINT pk_workflow_statistics PRIMARY KEY ("workflowId", name);


--
-- Name: workflows_tags pk_workflows_tags; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows_tags
    ADD CONSTRAINT pk_workflows_tags PRIMARY KEY ("workflowId", "tagId");


--
-- Name: tag_entity tag_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag_entity
    ADD CONSTRAINT tag_entity_pkey PRIMARY KEY (id);


--
-- Name: variables variables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_pkey PRIMARY KEY (id);


--
-- Name: workflow_entity workflow_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_entity
    ADD CONSTRAINT workflow_entity_pkey PRIMARY KEY (id);


--
-- Name: IDX_070b5de842ece9ccdda0d9738b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_070b5de842ece9ccdda0d9738b" ON public.workflow_publish_history USING btree ("workflowId", "versionId");


--
-- Name: IDX_14f68deffaf858465715995508; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_14f68deffaf858465715995508" ON public.folder USING btree ("projectId", id);


--
-- Name: IDX_1d8ab99d5861c9388d2dc1cf73; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_1d8ab99d5861c9388d2dc1cf73" ON public.insights_metadata USING btree ("workflowId");


--
-- Name: IDX_1e31657f5fe46816c34be7c1b4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_1e31657f5fe46816c34be7c1b4" ON public.workflow_history USING btree ("workflowId");


--
-- Name: IDX_1ef35bac35d20bdae979d917a3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_1ef35bac35d20bdae979d917a3" ON public.user_api_keys USING btree ("apiKey");


--
-- Name: IDX_56900edc3cfd16612e2ef2c6a8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_56900edc3cfd16612e2ef2c6a8" ON public.binary_data USING btree ("sourceType", "sourceId");


--
-- Name: IDX_5f0643f6717905a05164090dde; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_5f0643f6717905a05164090dde" ON public.project_relation USING btree ("userId");


--
-- Name: IDX_60b6a84299eeb3f671dfec7693; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_60b6a84299eeb3f671dfec7693" ON public.insights_by_period USING btree ("periodStart", type, "periodUnit", "metaId");


--
-- Name: IDX_61448d56d61802b5dfde5cdb00; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_61448d56d61802b5dfde5cdb00" ON public.project_relation USING btree ("projectId");


--
-- Name: IDX_63d7bbae72c767cf162d459fcc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_63d7bbae72c767cf162d459fcc" ON public.user_api_keys USING btree ("userId", label);


--
-- Name: IDX_8e4b4774db42f1e6dda3452b2a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_8e4b4774db42f1e6dda3452b2a" ON public.test_case_execution USING btree ("testRunId");


--
-- Name: IDX_97f863fa83c4786f1956508496; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_97f863fa83c4786f1956508496" ON public.execution_annotations USING btree ("executionId");


--
-- Name: IDX_UniqueRoleDisplayName; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_UniqueRoleDisplayName" ON public.role USING btree ("displayName");


--
-- Name: IDX_a3697779b366e131b2bbdae297; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_a3697779b366e131b2bbdae297" ON public.execution_annotation_tags USING btree ("tagId");


--
-- Name: IDX_a4ff2d9b9628ea988fa9e7d0bf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_a4ff2d9b9628ea988fa9e7d0bf" ON public.workflow_dependency USING btree ("workflowId");


--
-- Name: IDX_ae51b54c4bb430cf92f48b623f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_ae51b54c4bb430cf92f48b623f" ON public.annotation_tag_entity USING btree (name);


--
-- Name: IDX_c1519757391996eb06064f0e7c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_c1519757391996eb06064f0e7c" ON public.execution_annotation_tags USING btree ("annotationId");


--
-- Name: IDX_cec8eea3bf49551482ccb4933e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_cec8eea3bf49551482ccb4933e" ON public.execution_metadata USING btree ("executionId", key);


--
-- Name: IDX_d6870d3b6e4c185d33926f423c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_d6870d3b6e4c185d33926f423c" ON public.test_run USING btree ("workflowId");


--
-- Name: IDX_e48a201071ab85d9d09119d640; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_e48a201071ab85d9d09119d640" ON public.workflow_dependency USING btree ("dependencyKey");


--
-- Name: IDX_e7fe1cfda990c14a445937d0b9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_e7fe1cfda990c14a445937d0b9" ON public.workflow_dependency USING btree ("dependencyType");


--
-- Name: IDX_execution_entity_deletedAt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_execution_entity_deletedAt" ON public.execution_entity USING btree ("deletedAt");


--
-- Name: IDX_role_scope_scopeSlug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_role_scope_scopeSlug" ON public.role_scope USING btree ("scopeSlug");


--
-- Name: IDX_workflow_entity_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_entity_name" ON public.workflow_entity USING btree (name);


--
-- Name: idx_07fde106c0b471d8cc80a64fc8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_07fde106c0b471d8cc80a64fc8 ON public.credentials_entity USING btree (type);


--
-- Name: idx_16f4436789e804e3e1c9eeb240; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_16f4436789e804e3e1c9eeb240 ON public.webhook_entity USING btree ("webhookId", method, "pathLength");


--
-- Name: idx_812eb05f7451ca757fb98444ce; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_812eb05f7451ca757fb98444ce ON public.tag_entity USING btree (name);


--
-- Name: idx_execution_entity_stopped_at_status_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_execution_entity_stopped_at_status_deleted_at ON public.execution_entity USING btree ("stoppedAt", status, "deletedAt") WHERE (("stoppedAt" IS NOT NULL) AND ("deletedAt" IS NULL));


--
-- Name: idx_execution_entity_wait_till_status_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_execution_entity_wait_till_status_deleted_at ON public.execution_entity USING btree ("waitTill", status, "deletedAt") WHERE (("waitTill" IS NOT NULL) AND ("deletedAt" IS NULL));


--
-- Name: idx_execution_entity_workflow_id_started_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_execution_entity_workflow_id_started_at ON public.execution_entity USING btree ("workflowId", "startedAt") WHERE (("startedAt" IS NOT NULL) AND ("deletedAt" IS NULL));


--
-- Name: idx_workflows_tags_workflow_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_workflows_tags_workflow_id ON public.workflows_tags USING btree ("workflowId");


--
-- Name: pk_credentials_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pk_credentials_entity_id ON public.credentials_entity USING btree (id);


--
-- Name: pk_tag_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pk_tag_entity_id ON public.tag_entity USING btree (id);


--
-- Name: pk_workflow_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pk_workflow_entity_id ON public.workflow_entity USING btree (id);


--
-- Name: project_relation_role_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_relation_role_idx ON public.project_relation USING btree (role);


--
-- Name: project_relation_role_project_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX project_relation_role_project_idx ON public.project_relation USING btree ("projectId", role);


--
-- Name: user_role_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_role_idx ON public."user" USING btree ("roleSlug");


--
-- Name: variables_global_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX variables_global_key_unique ON public.variables USING btree (key) WHERE ("projectId" IS NULL);


--
-- Name: variables_project_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX variables_project_key_unique ON public.variables USING btree ("projectId", key) WHERE ("projectId" IS NOT NULL);


--
-- Name: workflow_entity workflow_version_increment; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER workflow_version_increment BEFORE UPDATE ON public.workflow_entity FOR EACH ROW EXECUTE FUNCTION public.increment_workflow_version();


--
-- Name: processed_data FK_06a69a7032c97a763c2c7599464; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.processed_data
    ADD CONSTRAINT "FK_06a69a7032c97a763c2c7599464" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: workflow_entity FK_08d6c67b7f722b0039d9d5ed620; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_entity
    ADD CONSTRAINT "FK_08d6c67b7f722b0039d9d5ed620" FOREIGN KEY ("activeVersionId") REFERENCES public.workflow_history("versionId") ON DELETE RESTRICT;


--
-- Name: insights_metadata FK_1d8ab99d5861c9388d2dc1cf733; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insights_metadata
    ADD CONSTRAINT "FK_1d8ab99d5861c9388d2dc1cf733" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE SET NULL;


--
-- Name: workflow_history FK_1e31657f5fe46816c34be7c1b4b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_history
    ADD CONSTRAINT "FK_1e31657f5fe46816c34be7c1b4b" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: chat_hub_messages FK_1f4998c8a7dec9e00a9ab15550e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_messages
    ADD CONSTRAINT "FK_1f4998c8a7dec9e00a9ab15550e" FOREIGN KEY ("revisionOfMessageId") REFERENCES public.chat_hub_messages(id) ON DELETE CASCADE;


--
-- Name: oauth_user_consents FK_21e6c3c2d78a097478fae6aaefa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_user_consents
    ADD CONSTRAINT "FK_21e6c3c2d78a097478fae6aaefa" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: insights_metadata FK_2375a1eda085adb16b24615b69c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insights_metadata
    ADD CONSTRAINT "FK_2375a1eda085adb16b24615b69c" FOREIGN KEY ("projectId") REFERENCES public.project(id) ON DELETE SET NULL;


--
-- Name: chat_hub_messages FK_25c9736e7f769f3a005eef4b372; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_messages
    ADD CONSTRAINT "FK_25c9736e7f769f3a005eef4b372" FOREIGN KEY ("retryOfMessageId") REFERENCES public.chat_hub_messages(id) ON DELETE CASCADE;


--
-- Name: execution_metadata FK_31d0b4c93fb85ced26f6005cda3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_metadata
    ADD CONSTRAINT "FK_31d0b4c93fb85ced26f6005cda3" FOREIGN KEY ("executionId") REFERENCES public.execution_entity(id) ON DELETE CASCADE;


--
-- Name: shared_credentials FK_416f66fc846c7c442970c094ccf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared_credentials
    ADD CONSTRAINT "FK_416f66fc846c7c442970c094ccf" FOREIGN KEY ("credentialsId") REFERENCES public.credentials_entity(id) ON DELETE CASCADE;


--
-- Name: variables FK_42f6c766f9f9d2edcc15bdd6e9b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT "FK_42f6c766f9f9d2edcc15bdd6e9b" FOREIGN KEY ("projectId") REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: chat_hub_agents FK_441ba2caba11e077ce3fbfa2cd8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_agents
    ADD CONSTRAINT "FK_441ba2caba11e077ce3fbfa2cd8" FOREIGN KEY ("ownerId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: project_relation FK_5f0643f6717905a05164090dde7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_relation
    ADD CONSTRAINT "FK_5f0643f6717905a05164090dde7" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: project_relation FK_61448d56d61802b5dfde5cdb002; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_relation
    ADD CONSTRAINT "FK_61448d56d61802b5dfde5cdb002" FOREIGN KEY ("projectId") REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: insights_by_period FK_6414cfed98daabbfdd61a1cfbc0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insights_by_period
    ADD CONSTRAINT "FK_6414cfed98daabbfdd61a1cfbc0" FOREIGN KEY ("metaId") REFERENCES public.insights_metadata("metaId") ON DELETE CASCADE;


--
-- Name: oauth_authorization_codes FK_64d965bd072ea24fb6da55468cd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_authorization_codes
    ADD CONSTRAINT "FK_64d965bd072ea24fb6da55468cd" FOREIGN KEY ("clientId") REFERENCES public.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: chat_hub_messages FK_6afb260449dd7a9b85355d4e0c9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_messages
    ADD CONSTRAINT "FK_6afb260449dd7a9b85355d4e0c9" FOREIGN KEY ("executionId") REFERENCES public.execution_entity(id) ON DELETE SET NULL;


--
-- Name: insights_raw FK_6e2e33741adef2a7c5d66befa4e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insights_raw
    ADD CONSTRAINT "FK_6e2e33741adef2a7c5d66befa4e" FOREIGN KEY ("metaId") REFERENCES public.insights_metadata("metaId") ON DELETE CASCADE;


--
-- Name: workflow_publish_history FK_6eab5bd9eedabe9c54bd879fc40; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_publish_history
    ADD CONSTRAINT "FK_6eab5bd9eedabe9c54bd879fc40" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: oauth_access_tokens FK_7234a36d8e49a1fa85095328845; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT "FK_7234a36d8e49a1fa85095328845" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: installed_nodes FK_73f857fc5dce682cef8a99c11dbddbc969618951; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.installed_nodes
    ADD CONSTRAINT "FK_73f857fc5dce682cef8a99c11dbddbc969618951" FOREIGN KEY (package) REFERENCES public.installed_packages("packageName") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: oauth_access_tokens FK_78b26968132b7e5e45b75876481; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT "FK_78b26968132b7e5e45b75876481" FOREIGN KEY ("clientId") REFERENCES public.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: chat_hub_sessions FK_7bc13b4c7e6afbfaf9be326c189; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_sessions
    ADD CONSTRAINT "FK_7bc13b4c7e6afbfaf9be326c189" FOREIGN KEY ("credentialId") REFERENCES public.credentials_entity(id) ON DELETE SET NULL;


--
-- Name: folder FK_804ea52f6729e3940498bd54d78; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folder
    ADD CONSTRAINT "FK_804ea52f6729e3940498bd54d78" FOREIGN KEY ("parentFolderId") REFERENCES public.folder(id) ON DELETE CASCADE;


--
-- Name: shared_credentials FK_812c2852270da1247756e77f5a4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared_credentials
    ADD CONSTRAINT "FK_812c2852270da1247756e77f5a4" FOREIGN KEY ("projectId") REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: test_case_execution FK_8e4b4774db42f1e6dda3452b2af; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_case_execution
    ADD CONSTRAINT "FK_8e4b4774db42f1e6dda3452b2af" FOREIGN KEY ("testRunId") REFERENCES public.test_run(id) ON DELETE CASCADE;


--
-- Name: data_table_column FK_930b6e8faaf88294cef23484160; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table_column
    ADD CONSTRAINT "FK_930b6e8faaf88294cef23484160" FOREIGN KEY ("dataTableId") REFERENCES public.data_table(id) ON DELETE CASCADE;


--
-- Name: folder_tag FK_94a60854e06f2897b2e0d39edba; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folder_tag
    ADD CONSTRAINT "FK_94a60854e06f2897b2e0d39edba" FOREIGN KEY ("folderId") REFERENCES public.folder(id) ON DELETE CASCADE;


--
-- Name: execution_annotations FK_97f863fa83c4786f19565084960; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_annotations
    ADD CONSTRAINT "FK_97f863fa83c4786f19565084960" FOREIGN KEY ("executionId") REFERENCES public.execution_entity(id) ON DELETE CASCADE;


--
-- Name: chat_hub_agents FK_9c61ad497dcbae499c96a6a78ba; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_agents
    ADD CONSTRAINT "FK_9c61ad497dcbae499c96a6a78ba" FOREIGN KEY ("credentialId") REFERENCES public.credentials_entity(id) ON DELETE SET NULL;


--
-- Name: chat_hub_sessions FK_9f9293d9f552496c40e0d1a8f80; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_sessions
    ADD CONSTRAINT "FK_9f9293d9f552496c40e0d1a8f80" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE SET NULL;


--
-- Name: execution_annotation_tags FK_a3697779b366e131b2bbdae2976; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_annotation_tags
    ADD CONSTRAINT "FK_a3697779b366e131b2bbdae2976" FOREIGN KEY ("tagId") REFERENCES public.annotation_tag_entity(id) ON DELETE CASCADE;


--
-- Name: shared_workflow FK_a45ea5f27bcfdc21af9b4188560; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared_workflow
    ADD CONSTRAINT "FK_a45ea5f27bcfdc21af9b4188560" FOREIGN KEY ("projectId") REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: workflow_dependency FK_a4ff2d9b9628ea988fa9e7d0bf8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_dependency
    ADD CONSTRAINT "FK_a4ff2d9b9628ea988fa9e7d0bf8" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: oauth_user_consents FK_a651acea2f6c97f8c4514935486; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_user_consents
    ADD CONSTRAINT "FK_a651acea2f6c97f8c4514935486" FOREIGN KEY ("clientId") REFERENCES public.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_refresh_tokens FK_a699f3ed9fd0c1b19bc2608ac53; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_refresh_tokens
    ADD CONSTRAINT "FK_a699f3ed9fd0c1b19bc2608ac53" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: folder FK_a8260b0b36939c6247f385b8221; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folder
    ADD CONSTRAINT "FK_a8260b0b36939c6247f385b8221" FOREIGN KEY ("projectId") REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: oauth_authorization_codes FK_aa8d3560484944c19bdf79ffa16; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_authorization_codes
    ADD CONSTRAINT "FK_aa8d3560484944c19bdf79ffa16" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: chat_hub_messages FK_acf8926098f063cdbbad8497fd1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_messages
    ADD CONSTRAINT "FK_acf8926098f063cdbbad8497fd1" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE SET NULL;


--
-- Name: oauth_refresh_tokens FK_b388696ce4d8be7ffbe8d3e4b69; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth_refresh_tokens
    ADD CONSTRAINT "FK_b388696ce4d8be7ffbe8d3e4b69" FOREIGN KEY ("clientId") REFERENCES public.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: workflow_publish_history FK_b4cfbc7556d07f36ca177f5e473; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_publish_history
    ADD CONSTRAINT "FK_b4cfbc7556d07f36ca177f5e473" FOREIGN KEY ("versionId") REFERENCES public.workflow_history("versionId") ON DELETE CASCADE;


--
-- Name: workflow_publish_history FK_c01316f8c2d7101ec4fa9809267; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_publish_history
    ADD CONSTRAINT "FK_c01316f8c2d7101ec4fa9809267" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: execution_annotation_tags FK_c1519757391996eb06064f0e7c8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_annotation_tags
    ADD CONSTRAINT "FK_c1519757391996eb06064f0e7c8" FOREIGN KEY ("annotationId") REFERENCES public.execution_annotations(id) ON DELETE CASCADE;


--
-- Name: data_table FK_c2a794257dee48af7c9abf681de; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_table
    ADD CONSTRAINT "FK_c2a794257dee48af7c9abf681de" FOREIGN KEY ("projectId") REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: project_relation FK_c6b99592dc96b0d836d7a21db91; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project_relation
    ADD CONSTRAINT "FK_c6b99592dc96b0d836d7a21db91" FOREIGN KEY (role) REFERENCES public.role(slug);


--
-- Name: test_run FK_d6870d3b6e4c185d33926f423c8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_run
    ADD CONSTRAINT "FK_d6870d3b6e4c185d33926f423c8" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: shared_workflow FK_daa206a04983d47d0a9c34649ce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shared_workflow
    ADD CONSTRAINT "FK_daa206a04983d47d0a9c34649ce" FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: folder_tag FK_dc88164176283de80af47621746; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folder_tag
    ADD CONSTRAINT "FK_dc88164176283de80af47621746" FOREIGN KEY ("tagId") REFERENCES public.tag_entity(id) ON DELETE CASCADE;


--
-- Name: user_api_keys FK_e131705cbbc8fb589889b02d457; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_api_keys
    ADD CONSTRAINT "FK_e131705cbbc8fb589889b02d457" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: chat_hub_messages FK_e22538eb50a71a17954cd7e076c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_messages
    ADD CONSTRAINT "FK_e22538eb50a71a17954cd7e076c" FOREIGN KEY ("sessionId") REFERENCES public.chat_hub_sessions(id) ON DELETE CASCADE;


--
-- Name: test_case_execution FK_e48965fac35d0f5b9e7f51d8c44; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_case_execution
    ADD CONSTRAINT "FK_e48965fac35d0f5b9e7f51d8c44" FOREIGN KEY ("executionId") REFERENCES public.execution_entity(id) ON DELETE SET NULL;


--
-- Name: chat_hub_messages FK_e5d1fa722c5a8d38ac204746662; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_messages
    ADD CONSTRAINT "FK_e5d1fa722c5a8d38ac204746662" FOREIGN KEY ("previousMessageId") REFERENCES public.chat_hub_messages(id) ON DELETE CASCADE;


--
-- Name: chat_hub_sessions FK_e9ecf8ede7d989fcd18790fe36a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_hub_sessions
    ADD CONSTRAINT "FK_e9ecf8ede7d989fcd18790fe36a" FOREIGN KEY ("ownerId") REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user FK_eaea92ee7bfb9c1b6cd01505d56; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_eaea92ee7bfb9c1b6cd01505d56" FOREIGN KEY ("roleSlug") REFERENCES public.role(slug);


--
-- Name: role_scope FK_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_scope
    ADD CONSTRAINT "FK_role" FOREIGN KEY ("roleSlug") REFERENCES public.role(slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: role_scope FK_scope; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_scope
    ADD CONSTRAINT "FK_scope" FOREIGN KEY ("scopeSlug") REFERENCES public.scope(slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_identity auth_identity_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT "auth_identity_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: execution_data execution_data_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_data
    ADD CONSTRAINT execution_data_fk FOREIGN KEY ("executionId") REFERENCES public.execution_entity(id) ON DELETE CASCADE;


--
-- Name: execution_entity fk_execution_entity_workflow_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.execution_entity
    ADD CONSTRAINT fk_execution_entity_workflow_id FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: webhook_entity fk_webhook_entity_workflow_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.webhook_entity
    ADD CONSTRAINT fk_webhook_entity_workflow_id FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: workflow_entity fk_workflow_parent_folder; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_entity
    ADD CONSTRAINT fk_workflow_parent_folder FOREIGN KEY ("parentFolderId") REFERENCES public.folder(id) ON DELETE CASCADE;


--
-- Name: workflow_statistics fk_workflow_statistics_workflow_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_statistics
    ADD CONSTRAINT fk_workflow_statistics_workflow_id FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- Name: workflows_tags fk_workflows_tags_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows_tags
    ADD CONSTRAINT fk_workflows_tags_tag_id FOREIGN KEY ("tagId") REFERENCES public.tag_entity(id) ON DELETE CASCADE;


--
-- Name: workflows_tags fk_workflows_tags_workflow_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflows_tags
    ADD CONSTRAINT fk_workflows_tags_workflow_id FOREIGN KEY ("workflowId") REFERENCES public.workflow_entity(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict KWbe71gYLzUNkkOEGUSAtRunZPzKumtIZJnamWtnQ4rTAeyzk2f84OikkPQMobV

