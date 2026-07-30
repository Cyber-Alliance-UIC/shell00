# GitHub Classroom setup — step by step

## 1. Prerequisites

- A GitHub organization: `Cyber-Alliance-UIC` (free — GitHub orgs and
  Classroom are free; GitHub Actions minutes are free for public repos and
  come with a generous free tier for private repos too).
- Admin access to that org.
- A `mentors` team inside the org (Settings → Teams → New team), containing
  all mentor GitHub accounts.

## 2. Prepare the template repository

1. Push this whole `shell00/` folder as a new repo, e.g.
   `Cyber-Alliance-UIC/shell00-template`.
2. Go to **Settings → General** in that repo and enable
   **"Template repository"**.
3. Go to **Settings → Secrets and variables → Actions → Variables** and add
   `GRADER_SHA256` (see `SECURITY.md` for how to compute it). This value
   will be copied into each student repo automatically by Classroom when it
   clones the template (repo variables/secrets are not copied by default —
   see step 6 for the workaround).

## 3. Create the private solutions repo (optional but recommended)

1. Create `Cyber-Alliance-UIC/shell00-solutions`, visibility **Private**.
2. Give the `mentors` team **Write** access, and make sure no student team
   has any access at all.
3. Store real reference solutions and any hidden fixtures there.

## 4. Create a Classroom "Classroom" (org)

1. Go to <https://classroom.github.com/>.
2. **New classroom** → connect it to the `Cyber-Alliance-UIC` organization.
3. Name it e.g. `Cyber Alliance UIC`.

## 5. Create the `shell00` assignment

1. Inside the Classroom, click **New assignment**.
2. **Assignment type:** Individual assignment (or Group, if you want
   pair-programming rooms).
3. **Assignment title:** `shell00`.
4. **Repository visibility:** Private (each student only sees their own).
5. **Add students as collaborators**: on (so mentors can push hints).
6. **Starter code repository:** select `shell00-template`.
7. **Add GitHub Actions to autograding:** GitHub Classroom will detect the
   `.github/workflows/classroom.yml` file and treat the job's exit code as
   the pass/fail signal automatically — no separate "autograding tests" UI
   configuration needed. You can optionally *also* add explicit Classroom
   "autograding tests" that just re-run `./grader/run.sh` for a friendlier
   Classroom UI summary, but it's not required since our own workflow
   already fails the run on any exercise failure.
8. **Deadline:** set if desired.

## 6. Naming convention

Classroom auto-generates repos as:

```
shell00-<github-username>
```

or, if you enabled the "identify students by roster" feature:

```
shell00-<student-identifier>
```

Recommended: import a roster (Classroom → Students → Add roster) mapping
real names/IDs to GitHub usernames, so repo names stay meaningful
(`shell00-jdoe23` instead of a random handle).

## 7. Propagating `GRADER_SHA256` to every student repo

Repository variables set on a template are **not** automatically copied to
repos created from it. Options, easiest first:

- **Simplest:** hardcode the expected hash directly as a fallback constant
  inside `classroom.yml` instead of a repo variable (fine for a low-stakes
  club setting — trade-off is you must edit the workflow file itself,
  re-triggering the "did the student edit the workflow" question, so pin it
  and treat any diff from the template's `.github/` folder as suspicious
  during manual review).
- **Automated:** use a small script with the GitHub CLI (`gh`) and the
  Classroom REST API to loop over all student repos after creation and set
  the variable via `gh variable set GRADER_SHA256 --repo <org>/<repo>
  --body <hash>`. Run this once per assignment right after Classroom
  finishes provisioning repos.
- **Org-wide:** set an **organization-level** Actions variable
  `GRADER_SHA256` (Org Settings → Secrets and variables → Actions →
  Variables → New organization variable), scoped to "All repositories" or
  a specific repo selection including future `shell*` repos. This is
  visible to every repo in the org automatically, no per-repo scripting
  needed, and is the recommended approach.

## 8. Verifying everything works

1. Accept the assignment yourself as a test student (use a throwaway/alt
   account, or Classroom's "Accept as instructor" test flow if available).
2. Clone the generated repo, deliberately leave `ex00` unsolved, push.
3. Confirm the Actions run shows ❌ FAIL with `ex00` listed as failing.
4. Solve `ex00`, push again, confirm ✅ PASS.

## 9. Repeating for future modules (shell01, c00, ...)

1. Duplicate the `shell00-template` repo (Use this template → Create a new
   repository), rename to `shell01-template`, etc.
2. Update `subject.md`, `starter/`, and `grader/tests/*.sh` for the new
   exercises.
3. Recompute and update `GRADER_SHA256`.
4. Repeat steps 4–8 above for the new module.
