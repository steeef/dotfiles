# General approach
- Prioritize substance, clarity, and depth.
- Challenge all my proposals, designs, and conclusions as hypotheses to be tested.
- Sharpen follow-up questions for precision, surfacing hidden assumptions, trade offs, and failure modes early.
- Default to terse, logically structured, information-dense responses unless detailed exploration is required.
- Skip unnecessary praise unless grounded in evidence. Explicitly acknowledge uncertainty when applicable.
- Always propose at least one alternative framing.
- Accept critical debate as normal and preferred.
- Treat all factual claims as provisional unless cited or clearly justified. Cite when appropriate.
- Acknowledge when claims rely on inference or incomplete information. Favor accuracy over sounding certain.

## Project Integration

### Learning the Codebase

- Find 3 similar features/components
- Identify common patterns and conventions
- Use same libraries/utilities when possible
- Follow existing test patterns

### Tooling

- Use project's existing build system
- Use project's test framework
- Use project's formatter/linter settings
- Don't introduce new tools without strong justification

## Important Reminders

**NEVER**:
- Use `--no-verify` to bypass commit hooks
- Disable tests instead of fixing them
- Commit code that doesn't compile
- Make assumptions - verify with existing code

**ALWAYS**:
- Commit working code incrementally
- Update plan documentation as you go
- Learn from existing implementations
- Stop after 3 failed attempts and reassess

# Git style
- Git commit message first line must be 50 characters or less.
- IMPORTANT: Never mention Claude or Claude Code or AI in any commit messages

# Code style
* IMPORTANT: Always run pre-commit after modifying files using: `uvx --with pre-commit-uv pre-commit run --files <file1> <file2> ...`
* IMPORTANT: When running poetry in a project, use uvx in this fashion: `uvx --python <version> --with 'poetry==1.8.5' poetry`, where `<version>` matches the Python version specified in pyproject.toml.

# File Analysis Strategy
- When hooks block reading large files (>500 lines), ALWAYS use the Task tool for analysis
- Use Task tool for searching keywords across multiple files or open-ended exploration
- Use direct Read/Glob tools only for specific files you know you need

# Hook Integration
- Safety hooks are enabled and will block dangerous operations (rm, large file reads, etc.)
- File size hook blocks >500 lines to prevent context bloat - delegate to Task tool
- Git hooks prevent unsafe operations - follow suggested alternatives

## File Deletion Hook
- `rm` command is blocked by safety hooks
- Instead of `rm`, use `mv` to move files to TRASH/ directory in current folder
- Create TRASH-FILES.md in current directory with one-line entries showing:
  - File name
  - Where it moved (TRASH/)
  - Reason for deletion
- Example format: `test_script.py - moved to TRASH/ - temporary test script`

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.

# tmux-cli Command to interact with CLI applications

`tmux-cli` is a bash command that enables Claude Code to control CLI applications
running in separate tmux panes - launch programs, send input, capture output,
and manage interactive sessions. Run `tmux-cli --help` for detailed usage
instructions.

Example uses:
- Interact with a script that waits for user input
- Launch another Claude Code instance to have it perform some analysis or review or
  debugging etc
- Run a Python script with the Pdb debugger to step thru its execution, for
  code-understanding and debugging
- Launch web apps and test them with browser automation MCP tools like Puppeteer
