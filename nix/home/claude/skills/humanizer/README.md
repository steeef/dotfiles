# Humanizer Skill

AI writing pattern detection based on Wikipedia's "Signs of AI writing" article.

## Source

This skill implements patterns documented in Wikipedia's collaborative research on AI-generated text detection:

**Original Source:** https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing

The Wikipedia article is maintained by the Wikipedia community and evolves as AI writing patterns change. This skill provides a snapshot of patterns as of January 2026.

## Usage

Invoke with `/humanizer` command in Claude Code, then paste or describe the text to analyze.

## Updating

To sync with latest Wikipedia patterns:

```bash
cd ~/.dotfiles/nix/home/claude/skills/humanizer/
./update-patterns.sh
```

Review the snapshot, update SKILL.md with new patterns, and run `hms` to deploy.

## Pattern Categories

The skill detects 24+ specific patterns across 4 categories:
- **Content Patterns**: Significance inflation, promotional language, vague attributions
- **Language Patterns**: AI vocabulary, copula avoidance, synonym cycling
- **Style Patterns**: Em dash overuse, excessive boldface, formatting issues
- **Communication**: Chatbot phrases, disclaimers, filler expressions

## License

Pattern documentation sourced from Wikipedia under CC BY-SA 4.0.
Skill implementation: See repository root for license.
