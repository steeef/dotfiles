# Code comments

Applies whenever writing or reviewing comments in any language.

- IMPORTANT: Comment blocks ≤7 words; function/identifier names ≤4 words; user-facing message strings ≤10 words.
- IMPORTANT: No temporal comments — don't explain what code used to do or why it changed; git history covers that. Comment only non-obvious WHY: why the obvious approach fails and this one works.
- Active voice, no filler words, no stage directions; pick the most common word among synonyms.
- Legacy file cleanup: strip all comments first, then re-add one by one, justifying each against these rules before writing it.
- Mechanically enforced (line comments + Python docstrings) by the
  `comment-style` claude-hooks plugin, which denies the edit outright — this
  rule still governs judgment calls the hook can't check (real WHY vs
  restated WHAT, other languages' block comments).

## Examples

Bad (what, not why; multi-line):

```python
# Loop through all the users in the list and check if
# each one is active before appending them to the result
for u in users:
    if u.active:
        result.append(u)
```

Good (why, one line — omit entirely if there's no non-obvious why):

```python
# skip soft-deleted users; active flag lags the delete by one sync cycle
for u in users:
    if u.active:
        result.append(u)
```

Bad (restates the function name):

```python
# Retry the request
def retry_request(): ...
```

Good (the non-obvious constraint):

```python
# 3 tries: upstream rate-limits burst above that
def retry_request(): ...
```
