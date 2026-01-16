---
name: git-commit-message
description: Generates well-formatted git commit messages following Conventional Commits and best practices. Use this skill when the user asks to commit, write/create/draft a commit message, commit staged changes, or mentions "commit", "commit message", "git commit", or wants to save changes to git. Also use when reviewing diffs before committing or when creating commits interactively.
license: MIT
metadata:
  author: grammy-jiang
  version: "1.1"
---

# Git Commit Message Generator

Generate commit messages that follow project conventions and best practices.

## When to Use This Skill

Activate this skill when the user:

- Says "commit" or "commit these changes" or "commit staged changes"
- Asks to "write a commit message" or "generate a commit message"
- Mentions "git commit" or "save to git" or "check in changes"
- Wants to review changes before committing
- Asks for commit message suggestions or examples

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

## Steps to Generate a Commit Message

Follow these steps when generating a commit message:

1. **Check for staged changes** using `git diff --cached` (if not already provided by the user)
1. **Analyze the changes** to understand what was modified, added, or removed
1. **Identify the primary intent:**
   - feat: new feature
   - fix: bug fix
   - refactor: code refactoring
   - docs: documentation changes
   - style: formatting, whitespace (no logic change)
   - test: adding or updating tests
   - chore: maintenance tasks
   - perf: performance improvements
   - ci: CI/CD configuration changes
   - revert: reverting a previous commit
1. **Write a concise imperative header** (\<= 50 chars) in format: `<type>(<scope>): <description>`
1. **Add body if non-trivial** to explain what and why (not how), wrapped at 72 chars
1. **Add footer if needed** with issue references, breaking changes, or co-authors
1. **Present the commit message** to the user for review before committing

## Format Template

```
<type>(<scope>): <description>

[optional body explaining what and why]

[optional footer with issue refs, breaking changes, co-authors]
```

**Conventional Commits types:**

- `feat`: new feature
- `fix`: bug fix
- `refactor`: code restructuring
- `docs`: documentation
- `style`: formatting (no logic change)
- `test`: test changes
- `chore`: maintenance
- `perf`: performance
- `ci`: CI/CD changes
- `revert`: revert previous commit

**Scope examples:** `auth`, `api`, `ui`, `database`, `config`, module/component name

## Examples

### Simple fix (header only)

```
fix(auth): handle null pointer in user login flow
```

### Feature with Conventional Commits format

```
feat(oauth): add OAuth 2.0 authentication support

Implement OAuth 2.0 login using the external provider library.
This introduces a new callback endpoint and updates the user
model with OAuth tokens for secure authentication.

Closes #42
```

### Breaking change

```
refactor(api)!: standardize response format

Standardize all API endpoints to return responses in a unified
JSON structure with status, data, and error fields.

BREAKING CHANGE: API responses now use a new envelope format.
Clients must update their parsing logic.

Closes #128
```

### With co-author

```
perf(cache): improve user profile API caching

Reduce database queries by implementing Redis caching for
frequently accessed user profile data. This improves response
times by approximately 40%.

Co-authored-by: Jane Doe <jane@users.noreply.github.com>
```

### Documentation update

```
docs(readme): update installation instructions

Add steps for Docker-based setup and troubleshooting section
for common installation issues on Windows.
```

### Test addition

```
test(api): add integration tests for auth endpoints

Cover happy path, invalid credentials, and rate limiting
scenarios for login and registration endpoints.
```

## Rules

- **One logical change per commit** - keep commits focused and atomic
- **Use imperative mood** - "Add feature" not "Added feature" or "Adds feature"
- **Capitalize first word** - start title with capital letter
- **No period at end** - don't end the title with a period
- **50 character title limit** - keep subject line concise
- **72 character body wrap** - wrap body text for readability
- **Separate title and body** - use blank line between title and body
- **Explain what and why** - not how (the diff shows how)
- **Be specific about scope** - mention affected module/component
- **Never use vague messages** - avoid "Fix stuff", "Update", "Changes"
- **No meta-references** - don't say "this commit" or "in this PR"
- **No personal pronouns** - avoid "I fixed", use "Fix" instead
- **Include issue references** - use `Closes #123`, `Fixes #456`, `See #789`
- **Mark breaking changes** - use `!` or `BREAKING CHANGE:` in footer
- **Focus on implications** - explain impact and motivation, not code mechanics

## Workflow Integration

When the user wants to commit:

1. **Check staged changes first** if not already visible:

   ```bash
   git diff --cached
   ```

1. **Generate the commit message** following the format above

1. **Present the message** to the user for review

1. **If approved, create the commit**:

   ```bash
   git commit -m "type(scope): description" -m "body text" -m "footer text"
   ```

   Or use interactive editor:

   ```bash
   git commit
   ```

1. **Confirm the commit** was created successfully:

   ```bash
   git log -1 --pretty=format:"%h - %s"
   ```

## Common Scenarios

### User says "commit this"

1. Check `git diff --cached` to see staged changes
1. Generate appropriate commit message
1. Present for approval
1. Execute commit if approved

### User says "write a commit message for these changes"

1. Analyze the provided changes or check staged
1. Generate message following conventions
1. Present the formatted message

### User says "commit with message X"

1. Review their message against best practices
1. Suggest improvements if needed (format, clarity, completeness)
1. Use their message if already good

### No staged changes

1. Inform user no changes are staged
1. Suggest reviewing `git status` and `git add` if needed
