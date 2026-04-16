---
name: humanizer
description: The skill for "is this AI-written?" or "make this sound more human." Use whenever a specific text sample is in question and the core concern is AI authenticity — student submissions suspected of AI authorship, blog/wiki drafts that feel off, PR commit messages that smell like boilerplate, cover letters that sound robotic, paragraphs an editor flagged. Detects copula avoidance, ChatGPT vocabulary, significance inflation, and 30+ other documented AI tells. Also rewrites flagged sections. Not for grammar checks, summarization, or style edits where AI detection is not the concern.
---

# Humanizer: AI Writing Pattern Detection

Detect AI-generated text using Wikipedia's documented patterns from "Signs of AI writing". Provides systematic analysis across 35+ specific pattern categories with confidence levels and concrete suggestions. Patterns are backed by academic research (Kobak et al., Reinhart et al., Juzek & Ward, Russell et al.).

**Before analyzing**: Read `references/patterns.md` — it contains the full pattern database organized by category.

## Caveats

- Patterns are indicators, not proof. Use confidence levels.
- Each AI model has a distinctive idiolect; patterns typical for ChatGPT may not apply to Gemini or Claude.
- Expert LLM users correctly identify AI text ~90% of the time, meaning ~10% false positive rate even for experts.
- Do not rely solely on automated AI detection tools (GPTZero, etc.) — they have non-trivial error rates and can be fooled by paraphrasing.

## When to Use

**ALWAYS use when:**
- User invokes `/humanizer` command (even for short/simple text - user explicitly requested analysis)
- User asks to check for AI patterns or analyze text for AI writing

**Don't use for:**
- Grammar checking, summarization, or style improvements where AI detection is not the concern
- Obviously human text when NOT explicitly requested (e.g., short factual announcements)

## Detection Strategy

1. **Read `references/patterns.md`** — load the full pattern database before scanning.

2. **Scan high-confidence patterns first**:
   - Content: significance inflation, notability/attribution emphasis (incl. named-source misattribution), superficial analysis, promotional language, vague attributions, challenges/prospects formula, title-as-proper-noun leads
   - Language: AI vocabulary (check era clustering), copula avoidance, elegant variation
   - Markup: chatbot citation artifacts, ChatGPT attribution markup, hallucinated citations/references
   - Communication: collaborative chatbot phrases, knowledge-cutoff disclaimers, placeholder text

3. **Check for pattern clusters** — multiple patterns in the same sentence = higher confidence. "Additionally" + "serves as" + "pivotal" in one sentence is very likely AI. Look for present participle ("-ing") chains at sentence ends.

4. **Verify with context** — is the pattern inappropriate for this text type? Would a human expert in this domain write this way? Consider the specific AI model's idiolect.

5. **Give concrete suggestions** — don't just flag. Show the specific rewrite. "The building is a community center" not "serves as a community center."

## Output Format

```markdown
## Analysis Results

**Text analyzed**: [word count] words

### High Confidence Patterns (N)
1. **Pattern Name** - "trigger phrase" (location)
   Text: "...exact quote..."
   Issue: [Why it's flagged — specific to this instance]
   Suggestion: [Concrete alternative for this specific case]

### Medium Confidence Patterns (N)
[Same format, note these may be stylistic choices]

### Low Confidence / Context-Dependent (N)
[Same format, explicitly note these need human judgment]

### Summary
- **Total findings**: N patterns across M categories
- **Confidence breakdown**: X high, Y medium, Z low
- **Recommendation**: [Prioritization guidance]
```

## Ineffective Indicators

Do NOT flag these (false positives):
- Perfect grammar or spelling
- Bland or robotic prose style (not specific to AI)
- Academic or formal vocabulary (domain-appropriate in many contexts)
- Conjunctions at sentence starts (normal English)

## Common Mistakes

- **Flagging every instance**: Consider density and context — one "additionally" may be fine, five in a paragraph is suspicious.
- **Overclaiming**: Patterns are indicators, not proof. Never say "definitely AI."
- **Generic suggestions**: Show the actual rewrite, not "be more specific."
- **Missing clusters**: When you find one pattern, check the surrounding sentences for others.
- **Ignoring context**: "Vibrant" in marketing copy is fine; in an encyclopedia entry it's suspicious.
- **Over-weighting historical patterns**: "It's important to note" was a strong tell in 2023; newer models use it rarely. Downweight accordingly.

## Updating Patterns

Wikipedia's "Signs of AI writing" article evolves as AI writing changes. To update:

1. Browse: <https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing>
2. Run `update-patterns.sh` to fetch latest wikitext (`curl` required — WebFetch gets 403'd by Wikipedia)
3. Review changes and update `references/patterns.md`
4. Update `last_updated` below

Last updated: 2026-04-15 (Wikipedia revision: 2026-04-15T23:42:51Z)
