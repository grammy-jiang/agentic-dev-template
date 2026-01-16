---
name: git-commit-message
description: Creates high-quality git commit messages following Conventional Commits format. Use when user asks to commit changes, commit the code, create a commit, write a commit message, commit staged files, save changes to git, or any variation of committing code with proper commit messaging. Also use for commit message review and suggestions.
license: MIT
metadata:
  author: grammy-jiang
  version: "1.2"
---

# Git Commit Message Skill

Create well-structured, meaningful commit messages for staging and committing code changes.

## When to Activate This Skill

This skill automatically activates when the user requests any of the following:

- **Commit actions:** "commit", "commit these changes", "commit this", "commit the code", "commit my changes", "commit the staged changes"
- **Message creation:** "write a commit message", "create a commit message", "generate a commit message", "draft a commit message"
- **Git operations:** "save to git", "check in", "commit and push", "git commit"
- **Multi-part requests:** "commit with a message", "stage and commit", "commit changes with a proper message"
- **Message review:** "review my commit message", "is this a good commit message", "check my commit message"

## Commit Message Structure

A commit message has three parts: **header** (required), **body** (optional),
and **footer** (optional).

### Header (Subject Line)

1. Use imperative mood (e.g., "Add", "Fix", "Update", not "Added", "Fixed",
   "Updated")
1. Start with a capital letter
1. Do not end with a period
1. Limit to 50 characters maximum
1. Complete the sentence: "If applied, this commit will..."

### Body

1. Separate from header with a blank line
1. Wrap lines at 72 characters
1. Explain **what** changed and **why** (not how)
1. Include relevant context, background, or reasoning

### Footer

1. Reference issues: `Closes #123`, `Fixes #456`, `See also: #789`
1. Note breaking changes: `BREAKING CHANGE: description`
1. Add co-authors: `Co-authored-by: name <email@example.com>`

## Steps to Create a Commit

Follow this workflow whenever a user requests a commit:

1. **View staged changes** to understand what's being committed:
   - Run: `git diff --cached` to see all staged changes
   - If no output, inform user and suggest `git add` first

2. **Analyze the diff** to identify:
   - Primary purpose: Is this a feature, fix, docs update, refactor, etc.?
   - Scope/component: What module or area is affected?
   - Impact: Is this a breaking change?
   - Related issues: Any issue numbers mentioned or context provided?

3. **Select the commit type** (Conventional Commits):
   - `feat`: new feature or capability
   - `fix`: bug fix or corrections
   - `refactor`: restructuring without behavior change
   - `docs`: documentation changes
   - `style`: formatting, whitespace, linting (no logic change)
   - `test`: test additions or updates
   - `chore`: maintenance, dependencies, build config
   - `perf`: performance improvements
   - `ci`: CI/CD pipeline changes
   - `revert`: reverting a previous commit

4. **Craft the commit message** in three parts:
   - **Header (required):** `<type>(<scope>): <description>` - max 50 characters
   - **Body (if needed):** Blank line, then explain *what* and *why* - wrap at 72 chars
   - **Footer (if needed):** Blank line, then add issue refs, breaking changes, co-authors

5. **Present the message** to user for approval before executing

6. **Execute the commit** once approved:
   ```bash
   git commit -m "header" -m "body" -m "footer"
   ```
   Or use multi-line if multiple sections:
   ```bash
   git commit
   ```

7. **Confirm success** by showing the new commit:
   ```bash
   git log -1 --pretty=format:"%h - %s"
   ```

## Format and Examples

### Message Structure

```
<type>(<scope>): <description>

[optional body explaining what and why, not how]

[optional footer with issue refs, breaking changes, or co-authors]
```

**Key Rules:**
- **Imperative mood:** Use "Add", "Fix", "Update" (not "Added", "Fixed", "Updated")
- **Capital first letter:** Start with uppercase
- **No period:** Don't end header with a period
- **50 char header max:** Keep subject line concise
- **72 char body wrap:** Wrap body text for terminal readability
- **Blank line separation:** Separate header from body and body from footer
- **Explain why:** Focus on motivation and implications, not code mechanics
- **Be specific:** Mention the component or module affected
- **No vague messages:** Avoid "Fix stuff", "Update", "Changes" without context
- **No meta-commentary:** Don't say "this commit" or "in this PR"
- **No personal pronouns:** Avoid "I fixed" – use imperative instead

### Example Commits

**Simple fix (feature or bug):**
```
fix(auth): handle null pointer in user login flow
```

**Feature with body:**
```
feat(oauth): add OAuth 2.0 authentication support

Implement OAuth 2.0 login using the external provider library.
This introduces a new callback endpoint and updates the user
model with OAuth tokens for secure authentication.

Closes #42
```

**Breaking change:**
```
refactor(api)!: standardize response format

Standardize all API endpoints to return responses in a unified
JSON structure with status, data, and error fields.

BREAKING CHANGE: API responses now use a new envelope format.
Clients must update their parsing logic.

Closes #128
```

**With co-author:**
```
perf(cache): improve user profile API caching

Reduce database queries by implementing Redis caching for
frequently accessed user profile data. This improves response
times by approximately 40%.

Co-authored-by: Jane Doe <jane@users.noreply.github.com>
```

**Documentation update:**
```
docs(readme): update installation instructions

Add steps for Docker-based setup and troubleshooting section
for common installation issues on Windows.
```

**Test addition:**
```
test(api): add integration tests for auth endpoints

Cover happy path, invalid credentials, and rate limiting
scenarios for login and registration endpoints.
```

## Quality Standards

Every commit message must follow these rules:

- **One logical change per commit** – keep commits focused and atomic
- **Describe impact, not mechanics** – explain what changed and why, not the code mechanics
- **Complete the sentence** – your header should complete: "If applied, this commit will..."
- **Include scope when possible** – `fix(module)` is clearer than just `fix`
- **Reference related issues** – use `Closes #123`, `Fixes #456`, `Related to #789`
- **Flag breaking changes** – use `!` in header or `BREAKING CHANGE:` in footer
- **Provide context** – body text should explain the *why* and *what*, not the *how*
- **Use past-tense body** – describe what was done in past tense in the body
- **No abbreviations** – spell out terms clearly for future readers
- **Keep it focused** – if the message is hard to write concisely, the change may be too broad

## Workflow and Common Scenarios

### Scenario 1: User says "commit these changes"

1. Run `git diff --cached` to see what's staged
2. Analyze the changes to understand the primary purpose
3. Generate an appropriate commit message
4. Present it to the user for review
5. Once approved, execute: `git commit -m "..."`
6. Show confirmation: `git log -1`

### Scenario 2: User provides changes but no staged files

1. Inform the user: "I don't see staged changes. Let's stage them first."
2. Suggest: "Run `git add <files>` to stage the changes"
3. Then proceed with commit message generation

### Scenario 3: User says "write a commit message for these changes"

1. If changes are provided, analyze them
2. If not, check `git diff --cached` for context
3. Generate the message following conventions
4. Present for approval
5. Do not commit until user confirms

### Scenario 4: User says "commit the staged changes with a good message"

1. Check `git diff --cached`
2. Analyze and generate message
3. Show the message and ask: "Does this look good?"
4. Execute commit on approval

### Scenario 5: User has no staged changes

1. Run `git status` to verify
2. Inform user: "No staged changes to commit."
3. Suggest next steps: "Would you like to stage some files first?"

### Scenario 6: Multiple unrelated changes are staged

1. Alert user: "These staged changes appear to affect different areas"
2. Suggest: "Consider breaking this into separate commits: one for X, one for Y"
3. Offer to create multiple commit messages if desired
4. Or proceed with single commit if user confirms intention
