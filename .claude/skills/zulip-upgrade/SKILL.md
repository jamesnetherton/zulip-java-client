---
name: zulip-upgrade
description: Upgrade the Zulip Java client to support a new Zulip server release. Diffs the Zulip OpenAPI spec between releases and against the client to produce a gap report (new endpoints, parameters, response fields, enum values, deprecations and removals), then implements the approved changes with tests and a changelog entry. For point releases (e.g. 12.4) it bumps the test server image and checks for backported API changes. Use this whenever the user mentions supporting, upgrading to, or testing with a new Zulip version, Zulip feature levels, the Zulip OpenAPI spec or API changelog, or bumping the Zulip Docker image, even if they don't say "upgrade".
---

# Zulip version upgrade

**The OpenAPI spec (`zerver/openapi/zulip.yaml` at the release tag) is the source of truth.**
It is what the server validates against and what https://zulip.com/api is generated from.
The API changelog is useful context, explaining *why* something changed and describing
behaviour the spec can't express, but it misses things. It doesn't re-announce a parameter
deprecated three releases ago that the client still sends, and it never mentions an endpoint
that has existed for years but was never implemented. Past upgrades shipped both kinds of change.

Missing a change is the main risk, since nothing in the build fails when an endpoint or field is
absent. So the workflow produces an explicit, reviewable gap report *before* any code is written.

Pick the path from the user's request:
- **Point release** (`X.Y`, Y > 0, e.g. "test with Zulip 12.4") → [Point release](#point-release)
- **Major release** (`X.0`, e.g. "add Zulip 13 support") → [Major release](#major-release)

## Tools

Keep all working files (spec reports, changelog extract, gap report, cached specs) in
`.claude/zulip-upgrade/`. It's gitignored, and unlike `target/` it survives `mvn clean`, which
phase 2 runs.

Both scripts run from the repo root.

- `.claude/skills/zulip-upgrade/scripts/spec_report.sh <old> <new>` diffs two spec versions and
  checks the client against `<new>`. Specs are cached in `.claude/zulip-upgrade/openapi/`. It runs
  `SpecReport.java` on the project's test classpath, which includes Jackson YAML. Sections:
  - **Operations added / removed**, each marked with the client classes that implement it or `NOT IMPLEMENTED`
  - **Changes to existing operations**: params and response fields added, removed, deprecated,
    retyped, or with enum values added/removed. Response fields are flattened to paths like
    `subscriptions[].can_create_topic_group`.
  - **Client parameters not accepted by `<new>`**: names a request class sends that its operation
    no longer defines. These are usually stale params that need removing (breaking change).
  - **Client parameters deprecated in `<new>`**
  - **Client classes linked to unknown operations**: javadoc links that don't match an operationId
  - **Pre-existing gaps**: operations and params that existed before `<new>` and the client still
    lacks
- `python3 -I .claude/skills/zulip-upgrade/scripts/api_changelog.py <version>` prints the API
  changelog's feature-level entries for a release, with the client classes for each `/api/` link.

The client is matched to operations through `https://zulip.com/api/<operationId>` javadoc links,
so a wrong or missing link shows up as `NOT IMPLEMENTED` or as an unknown operation. Before you
call something missing, grep for its path in `*RequestConstants.java`. If the class exists, the
fix is the link, and you should list that fix in the report too.

## Point release

Past examples: `git log --oneline -i --grep='Test with Zulip'`. Usually a one-line change.

1. Find the latest image tag: `gh release list -R zulip/docker-zulip --limit 10`. Tags look like
   `X.Y-N`. Update `ghcr.io/zulip/zulip-server:` in `src/test/resources/docker/docker-compose.yml`.
   Compare the rest of that file with upstream's `compose.yaml` at the same release tag. The
   supporting images (rabbitmq, postgres, ...) sometimes change too.
2. `spec_report.sh <previous point tag> X.Y` (e.g. `12.3 12.4`) to catch backported API changes.
   It's usually empty or close to it. If something the client should expose turns up, tell the
   user before going further, since it may belong in the next major's work.
3. Refresh `zulip.sql` with `refreshdb.sh X.Y` ([below](#refreshing-zulipsql)). Point releases
   can ship migrations too (12.3 did), and the dump should match the image the tests run on.
   If the script reports no new migrations, keep the regenerated dump out of the commit:
   `git checkout -- src/test/resources/docker/zulip.sql`.
4. Refresh the emoji enum if the emoji map changed in this release; see
   [Refreshing generated enums](#refreshing-generated-enums). Point releases usually don't change it,
   but check.
5. If Docker is available, run the integration tests ([below](#running-integration-tests)) and
   fix any the new server breaks.
6. Commit as `Test with Zulip X.Y`, but only when the user asks.

## Major release

### Phase 1: Gap report (then stop for review)

1. **Find the tracking issue**: `gh issue list --search "Zulip X" --state open`. Past upgrade
   commits referenced it with `Fixes #NNN`.
2. **Choose versions.** Old = `<X-1>.0`. New = the latest `X.Y` tag (the one the Docker image will
   use; check `gh release list -R zulip/docker-zulip`).
3. **Run the spec report**: `spec_report.sh <X-1>.0 <X.Y> > .claude/zulip-upgrade/zulip-X-spec-report.md`.
   This is your checklist; every line in its change and client sections needs a decision.
4. **Run the changelog** for context: `api_changelog.py X > .claude/zulip-upgrade/zulip-X-changelog.md`. Use it
   to understand intent, and to pick up changes that have no spec footprint: behaviour, permission,
   units or meaning (e.g. a timestamp switching from milliseconds to seconds), and error semantics.
   It also gives you the feature level for each change. Entries for `X.Y` point releases are
   backports, so they're in scope.
5. **Classify every item** in the spec report:
   - **New endpoint**: added operations marked `NOT IMPLEMENTED`
   - **New request param**: params added to implemented operations
   - **New response field**: check the response class *and* any model it populates (`User`,
     `Stream`, ...). Many `POST /register` and `GET /events` fields describe state the client doesn't
     model. Check `RegisterEventQueueApiResponse` and the `api/event` classes before proposing work,
     and group these items rather than listing dozens individually.
   - **New enum value**: compare against the Java enum the client uses for that field/param
   - **Breaking**: removed params/fields/operations, client params not accepted by the new spec,
     deprecated params the client sends, and enum values removed
   - **Deserialisation risk**: for every *type change* on a response field the client models,
     open the Java field and check it still deserialises. An int becoming a string, or a scalar
     becoming an object, throws at runtime even though the changelog may describe it as minor.
     List these under breaking changes.
   - **Wrong javadoc link**: from the unknown-operations section, or a `NOT IMPLEMENTED` that turns
     out to exist. Some links point at doc pages rather than operations (`api-keys`,
     `construct-narrow`, `group-setting-values`), and those are fine. A wrong link on a request
     class also makes the report attribute its params to the wrong operation, so fix links before
     trusting the "not accepted" entries for that class.
   - **Enum deserialisation**: for every new enum value in a response, check whether the Java
     enum's `@JsonCreator` falls back to an `UNKNOWN` constant or calls `valueOf`. If it calls
     `valueOf`, the new value throws, which makes the whole response fail.
   - **Pre-existing gap**: endpoints/params the client never implemented. List them separately so
     the user can choose which to take on; past upgrades filled some of these in.
   - **No client change**: say why in one line, so the user can see each item was considered
6. **Check housekeeping.** These change every major:
   - Docker image tag (and the supporting images, compared with upstream `compose.yaml`)
   - `Emoji` and `EventType` enums → regenerate from the new tag
     ([Refreshing generated enums](#refreshing-generated-enums))
   - `CHANGELOG.adoc` → a section for the `pom.xml` version (minus `-SNAPSHOT`) if it doesn't exist
   - `zulip.sql` test DB dump → migrate to the new server ([below](#refreshing-zulipsql))
   - `COMPATIBILITY.adoc` is updated in the release-prep commit, not here; just mention it
7. **Write the gap report** to `.claude/zulip-upgrade/zulip-X-gap-report.md` and summarise it in chat:

   ```markdown
   # Zulip X gap report (<X-1>.0 → X.Y, feature levels A–B)

   ## Summary
   N new endpoints · N new params · N new fields · N enum values · N breaking · N pre-existing gaps

   ## Breaking changes
   | FL | Change | Client impact | Proposed action |

   ## Work items
   | FL | Category | Change | Affected classes | Proposed action |

   ## Pre-existing gaps (optional)
   | Endpoint / param | Notes |

   ## No client change
   | FL | Change | Reason |

   ## Housekeeping
   - [ ] ...

   ## Questions
   ```

   Questions should cover anything where the Java API shape isn't obvious (new return type vs.
   keeping the old one, renaming vs. aliasing) and endpoints that need OAuth or external services
   and so can't be integration-tested.

   Before presenting, check that every item in the spec report's change and client sections
   appears somewhere in the gap report.
8. **Stop and ask the user to review.** They may drop items, pull in pre-existing gaps, or decide
   how a breaking change should look. Don't start Phase 2 until they say so.

### Phase 2: Implement

Read `references/conventions.md` before writing code. It describes how each kind of change is
implemented here and points at template classes. Then:

1. Do the housekeeping first, including the image bump and `refreshdb.sh`, so everything after
   it is tested against the right server.
2. Work through the approved items one domain (message, stream, user, server...) at a time:
   main code, unit test plus fixture, IT where feasible. Take parameter names, types and response
   shapes from the spec (`.claude/zulip-upgrade/openapi/zulip-X.Y.yaml`), not from the changelog prose.
   After each domain, run `./mvnw test -Dtest=Zulip<Domain>ApiTest`.
3. Breaking changes: remove or rename, fix all callers, and add a `CHANGELOG.adoc` bullet for each.
4. Regenerate `Emoji` and `EventType` ([Refreshing generated enums](#refreshing-generated-enums)).
   Do `EventType` after any new `*Event` classes compile.
5. Run `./mvnw clean package` for the full unit suite. Formatter and impsort run on compile, so
   reformatted files are expected.
6. **Re-run `spec_report.sh`.** Every item you implemented should now be gone from the
   `NOT IMPLEMENTED`, not-accepted and unknown-operation lists. Anything left should be a
   deliberate skip.
7. Run the integration tests if Docker is available ([below](#running-integration-tests)).
8. `CHANGELOG.adoc`: add `* Zulip X support` under **Enhancements** and the **Breaking changes**
   bullets, following the existing wording style.
9. Report back: what's done, what was skipped and why, and what couldn't be tested. Commit as
   `Add support for Zulip X` with `Fixes #NNN` when there's an issue, but only when the user asks.

## Refreshing generated enums

`Emoji.java` and `EventType.java` are generated from upstream files pinned to a Zulip tag. They don't
update themselves, so treat each one as an explicit task on every bump.

**Emoji**: set the tag in `EmojiEnumGenerator.ZULIP_EMOJI_JSON` to the new release, then:

```bash
./mvnw test -Dtest=EmojiEnumGenerator -Demoji.generate
git diff --stat -- '**/Emoji.java'
git diff -U0 -- '**/Emoji.java' | grep '^-    [A-Z]'   # removed constants
```

For a point release, first check whether the map changed at all, and skip the regeneration if it
didn't: `diff <(curl -sfL <old-tag url>) <(curl -sfL <new-tag url>)`.
- **Added emoji**: mention them under Enhancements in `CHANGELOG.adoc` (a count is enough).
- **Removed or renamed constants** break callers that use them. List each one under Breaking
  changes. If Zulip renamed an emoji, say what replaces it.

**EventType**: set the tag in `EventTypeEnumGenerator.ZULIP_OPENAPI_YAML`, make sure any new
`*Event` classes compile, then run `./mvnw test -Dtest=EventTypeEnumGenerator -Devent.type.generate`.
New event types should match the spec report's `events[].type` enum additions.

## Running integration tests

`src/test/resources/docker/setupzulip.sh` starts the stack, loads `zulip.sql` and writes
`zuliprc` to the repo root. Then run `./mvnw verify`, or `-Dit.test=Zulip<Domain>IT` for one class.
The IT harness fails any request whose response reports `ignored_parameters_unsupported`, so it
catches stale params at runtime too. ITs are skipped without `zuliprc`, so a green build with no
server proves nothing about them. Say clearly if they didn't run.

### Refreshing zulip.sql

`zulip.sql` is a `pg_dump` of a seeded test server: realm 2 is `testing`; `test@test.com` /
`testing123!` is a realm owner with `can_create_users`; there are a few channels and messages.
The integration tests assume that data, and the dump's schema has to match the server image.
So after **every image bump**, major or point, the dump has to be migrated forward.

Bump the image tag in `docker-compose.yml` first. The refresh migrates to whatever image that file
points at, and refuses to run if the version doesn't match the one you pass in.

```bash
src/test/resources/docker/refreshdb.sh X.Y
```

The script:
1. starts a clean stack on the configured image
2. loads the existing dump and restarts, so the docker-zulip entrypoint runs `manage.py migrate`
3. checks that no migrations are unapplied and that the container's `version.py` reports `X.Y`
   (not via the API, since API requests write rows into the database)
4. dumps the database with `regenerate.sh`, then checks that `test@test.com` can still log in
5. prints the feature level and the applied-migration count before and after

The dump is taken before any tests run, so it contains no test data. Never dump after running
the ITs.

Run it yourself if Docker (or Podman with `docker compose`) is available and ports 80/443 are
free; it takes several minutes, so run it in the background. Then:
- Expect some unavoidable churn: a new random `\restrict` key from pg_dump on every dump, and
  scheduled onboarding emails being sent and removed once their date has passed.
- Check the diff is a schema migration, not a data change. Expect new columns, tables and
  `django_migrations` rows, plus some row churn in session-like tables. Unexpected deletions of
  users, channels or messages mean something went wrong.
- Run `src/test/resources/docker/createzuliprc.sh` (the stack is still up) and then the ITs.
- Leave the stack running for the user, or `docker compose down` from `src/test/resources/docker`.

If the script fails, report the failing step and the last lines of `docker compose logs zulip`,
then hand back to the user. Don't hand-edit `zulip.sql`. If migrating forward is truly broken,
the fallback is to rebuild the test realm from scratch, which needs the user:
`createrealm.sh` prints a realm creation link; sign up `test@test.com` / `testing123!` with realm
name `testing`; copy `enablecreateuser.sh` into the zulip container and run it; recreate
whatever channels and messages the ITs need; then `regenerate.sh`.
