# Humanizer Skill

AI writing pattern detection based on Wikipedia's "Signs of AI writing" article.

## Source

This skill implements patterns documented in Wikipedia's collaborative research on AI-generated text detection:

**Original Source:** https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing

The Wikipedia article is maintained by the Wikipedia community and evolves as AI writing patterns change. This skill provides a snapshot of patterns as of February 2026.

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

The skill detects 30+ specific patterns across 7 categories:
- **Content Patterns**: Significance inflation, notability/attribution emphasis, superficial analysis, promotional language, vague attributions, challenges/prospects formula
- **Language Patterns**: AI vocabulary, copula avoidance, elegant variation, negative parallelisms, rule of three, false ranges
- **Style Patterns**: Em dash overuse, excessive boldface, title case, emoji, curly quotes, unusual tables
- **Communication**: Collaborative chatbot phrases, knowledge-cutoff disclaimers, placeholder text, sycophantic tone, filler, hedging
- **Historical**: Didactic disclaimers (declining), formulaic conclusions (declining)
- **Structural**: Sudden style shifts, verbose edit descriptions
- **Ineffective Indicators**: Known false positives to avoid

## License

Pattern documentation sourced from Wikipedia under CC BY-SA 4.0.
Skill implementation: See repository root for license.
