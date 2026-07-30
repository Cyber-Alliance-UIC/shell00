# Security architecture

## Threat model

Students have full read/write access to their own repository, including
`.github/workflows/` and `grader/`. That means a student *could*, in
principle:

1. Read the checker source and reverse-engineer what output is expected
   (this is fine — the exercises are simple enough that this isn't really
   a "leak", and reading test code is normal software engineering practice).
2. Edit the checker to always print PASS.
3. Edit the workflow file to skip the grader entirely.

The design below stops (2) and (3) from silently succeeding, and ensures the
*real* expected outputs / edge-case answers never live in the student repo
at all.

## What never goes in the student repo

- Full reference solutions (`solutions/`) — these live in a **separate,
  private** repository: `Cyber-Alliance-UIC/shell00-solutions`, visible only
  to the `mentors` team.
- Any "secret" expected values beyond what's derivable from the public
  subject (e.g. hidden edge-case fixtures) — these can be added as encrypted
  GitHub Actions secrets or pulled from the private solutions repo at CI
  time via a fine-scoped deploy key, if a future exercise needs them. The
  current `shell00` checkers are simple enough that all expected values are
  computed at grading time (e.g. `$USER`, arithmetic), so no secret store is
  required yet — but the pattern is ready to extend.

## Grader tamper protection

Every CI run computes a SHA-256 hash of the entire `grader/` directory and
compares it against a `GRADER_SHA256` repository variable that only
repository **admins** (mentors, via the org) can set. If a student edits any
file under `grader/`, the hashes won't match and the workflow fails with
`grader/ directory has been modified`, regardless of what the (tampered)
grader itself would have printed.

To (re)compute the expected hash after a legitimate grader update:

```bash
find grader -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | awk '{print $1}'
```

Set the result as a repository variable named `GRADER_SHA256`
(Settings → Secrets and variables → Actions → Variables) on the **template**
repo before Classroom clones it, or push it to each student repo via the
Classroom "autograding" propagation step (see `CLASSROOM_SETUP.md`).

## Workflow tamper protection

Classroom's built-in branch protection (configurable per assignment) can
require the `classroom.yml` workflow to run and pass before a submission is
considered "accepted" for grading purposes — this is set from the GitHub
Classroom assignment dashboard, not from within the repo, so students can't
disable it from their own copy.

## Principle of least exposure

- `starter/` — public, editable by students. Contains only skeletons.
- `grader/` — public but hash-verified. Contains *how to check*, never the
  private/edge-case answers.
- `shell00-solutions` (separate private repo) — real solutions, mentor-only.
  Used by mentors to sanity-check the grader and to help students 1:1, never
  synced into student repos.
