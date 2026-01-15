______________________________________________________________________

## name: git-commit-message description: Generates well-formatted git commit messages following project conventions and best practices. Use this skill when asked to write, create, draft, or generate a commit message, when committing staged changes, or when the user mentions "commit", "commit message", or "git commit". license: MIT metadata: author: grammy-jiang version: "1.0"

# Git Commit Message Generator

Generate commit messages that follow project conventions and best practices.

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

1. Analyze the staged changes or described changes
1. Identify the primary intent (feature, fix, refactor, docs, etc.)
1. Write a concise imperative header (\<= 50 chars)
1. If changes are non-trivial, write a body explaining what and why
1. Add footer with issue references or co-authors if applicable

## Format Template

```
<Title: imperative, capitalized, no period, <= 50 chars>

<Body: explain what and why, wrap at 72 chars>

<Footer: issue refs, breaking changes, co-authors>
```

## Examples

### Simple fix (header only)

```
Fix null pointer exception in user login flow
```

### Feature with body

```
Add OAuth 2.0 authentication support

Implement OAuth 2.0 login using the external provider library.
This introduces a new callback endpoint and updates the user
model with OAuth tokens for secure authentication.

Closes #42
```

### Breaking change

```
Refactor API response format for consistency

Standardize all API endpoints to return responses in a unified
JSON structure with status, data, and error fields.

BREAKING CHANGE: API responses now use a new envelope format.
Clients must update their parsing logic.

Closes #128
```

### With co-author

```
Improve caching in user profile API

Reduce database queries by implementing Redis caching for
frequently accessed user profile data. This improves response
times by approximately 40%.

Co-authored-by: Jane Doe <jane@users.noreply.github.com>
```

## Rules

- One logical change per commit
- Be specific about the affected scope/component
- Never use vague messages like "Fix stuff", "Update", or "Changes"
- Do not reference "this commit" or use personal pronouns ("I fixed...")
- Focus on implications and motivations, not code mechanics
