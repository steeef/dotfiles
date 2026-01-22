---
name: humanizer
description: Use when analyzing text for AI writing patterns - detects Wikipedia-documented signs like significance inflation, copula avoidance, promotional language, chatbot phrases, and 20+ other specific patterns
---

# Humanizer: AI Writing Pattern Detection

## Overview

Detect AI-generated text using Wikipedia's documented patterns from "Signs of AI writing". Provides systematic analysis across 24+ specific pattern categories with confidence levels and concrete suggestions.

## When to Use

**ALWAYS use when:**
- User invokes `/humanizer` command (even for short/simple text - user explicitly requested analysis)
- User asks to check for AI patterns or analyze text for AI writing

**Use when:**
- Reviewing text for AI writing signs
- Evaluating content authenticity
- Text shows potential AI patterns

**Don't use for:**
- Automatic rewriting (detection only)
- Grammar checking (different purpose)
- Style preferences (this is pattern recognition)
- Obviously human text when NOT explicitly requested (e.g., short factual announcements)

## Pattern Database

Wikipedia documents 24+ specific AI writing patterns across 4 categories. Each pattern has trigger phrases, confidence level, and improvement guidance.

### Content Patterns (High Confidence)

#### Undue Emphasis on Significance
**Triggers**: "stands/serves as", "is a testament/reminder", "pivotal/crucial/key role", "marking a turning point", "underscores importance"
**When to flag**: Used for mundane topics (population data, etymology, minor features)
**Example**:
- ❌ "The library was established in 1992, marking a pivotal moment in regional literacy"
- ✅ "The library was established in 1992 to serve the growing community"

#### Notability Emphasis
**Triggers**: "notable", "notably", "worth noting", "important to note", "it should be noted"
**When to flag**: Appears 3+ times in short text, used without supporting evidence
**Example**:
- ❌ "It's notable that the building notably features notable architecture"
- ✅ "The building features Gothic Revival architecture"

#### Superficial Analysis
**Triggers**: "multifaceted", "nuanced", "complex interplay", "delicate balance", "various factors"
**When to flag**: Claims complexity without explaining what's complex
**Example**:
- ❌ "The issue involves a complex interplay of various factors"
- ✅ "The issue involves budget constraints, zoning laws, and environmental concerns"

#### Promotional Language
**Triggers**: "vibrant", "dynamic", "thriving", "bustling", "diverse array/range/tapestry"
**When to flag**: Marketing adjectives in neutral context
**Example**:
- ❌ "The vibrant tapestry of local culture showcases a diverse array"
- ✅ "Local culture includes annual festivals, craft markets, and music venues"

#### Vague Attributions
**Triggers**: "some researchers", "studies show", "experts say", "it is believed"
**When to flag**: No specific citation follows
**Example**:
- ❌ "Some researchers suggest the phenomenon is significant"
- ✅ "Johnson et al. (2023) found the phenomenon affects 40% of cases"

#### Formulaic Conclusions
**Triggers**: "in conclusion", "in summary", "ultimately", "thus it can be seen"
**When to flag**: Mechanical summary that adds no new insight
**Example**:
- ❌ "In conclusion, the library serves an important role in the community"
- ✅ [End with substantive point, or omit conclusion]

### Language Patterns (High Confidence)

#### Overused AI Vocabulary
**Triggers**: "Additionally" (sentence-start), "Moreover", "Furthermore", "Consequently", "Hence", "Thus", "Therefore" (overused), "leverage", "utilize", "facilitate", "underscore", "showcase", "underline"
**When to flag**: Multiple formal connectors in short text, weak verbs replacing simple ones
**Example**:
- ❌ "Additionally, the system leverages technology to facilitate user engagement"
- ✅ "The system uses technology to increase user engagement"

#### Copula Avoidance
**Triggers**: "serves as", "acts as", "functions as", "stands as", "represents", "constitutes"
**When to flag**: Replaces simple "is/are" unnecessarily
**Example**:
- ❌ "The building serves as a community center"
- ✅ "The building is a community center"

#### Negative Parallelisms
**Triggers**: "not only... but also", "not just... but", "both... and"
**When to flag**: Used to inflate simple statements
**Example**:
- ❌ "The library provides not only books but also digital resources"
- ✅ "The library provides books and digital resources"

#### Rule of Three
**Triggers**: Lists of exactly three items, "Firstly... Secondly... Lastly"
**When to flag**: Artificial triplets where 2 or 4 items would be natural
**Example**:
- ❌ "The system is reliable, scalable, and maintainable" [when only 2 properties matter]
- ✅ "The system is reliable and scales to handle peak loads"

#### Synonym Cycling
**Triggers**: Multiple synonyms for same concept: "vital/crucial/essential/critical/pivotal/key", "showcase/highlight/demonstrate/illustrate", "comprehensive/thorough/exhaustive/complete"
**When to flag**: Rotating through synonyms to avoid repetition
**Example**:
- ❌ "This vital feature is crucial for the essential functionality of the critical system"
- ✅ "This feature is essential for core functionality"

#### False Ranges
**Triggers**: "between X and Y" where Y is absurdly high
**When to flag**: Meaningless range used to hedge
**Example**:
- ❌ "The project will take between 2 weeks and 6 months"
- ✅ "The project will take 4-6 weeks" OR "Timeline depends on resource availability"

### Style Patterns (Medium Confidence)

#### Em Dash Overuse
**Triggers**: 3+ em dashes in paragraph, em dashes interrupting simple sentences
**When to flag**: Used for complexity instead of clarity
**Example**:
- ❌ "The system – which was developed in 2020 – provides users with access to – among other things – digital resources"
- ✅ "The system (developed in 2020) provides users with digital resources and other materials"

#### Excessive Boldface
**Triggers**: Multiple bold words in short paragraph
**When to flag**: Artificial emphasis throughout text
**Note**: Legitimate uses exist (headings, UI elements)

#### Inline Headers (Wikipedia-specific)
**Triggers**: Bold text mid-paragraph functioning as subheading
**When to flag**: Wikipedia articles with sections not properly formatted

#### Unnatural Title Case
**Triggers**: Title Case in Mid-Sentence
**When to flag**: Capitalization rules applied inconsistently

#### Emoji Usage (Context-dependent)
**Triggers**: Emojis in formal/neutral text
**When to flag**: Inappropriate tone for context

#### Curly Quotes in Code
**Triggers**: "curly quotes" instead of "straight quotes" in technical text
**When to flag**: Technical documentation with typographic quotes

### Communication & Filler (High Confidence)

#### Chatbot Phrases
**Triggers**: "I hope this helps", "Feel free to", "Don't hesitate to", "I'd be happy to", "I understand that"
**When to flag**: Conversational phrases in written content
**Example**:
- ❌ "I hope this article helps you understand the topic. Feel free to explore related articles"
- ✅ "See related articles for more information"

#### Disclaimers
**Triggers**: "It's important to note", "It should be mentioned", "It's worth noting", "One should keep in mind"
**When to flag**: Hedging without adding information
**Example**:
- ❌ "It's important to note that the library opened in 1992"
- ✅ "The library opened in 1992"

#### Sycophantic Tone
**Triggers**: "excellent question", "great point", "absolutely", "certainly", "definitely" (overused)
**When to flag**: Excessive agreement/enthusiasm in neutral text

#### Filler Expressions
**Triggers**: "in terms of", "when it comes to", "with regard to", "as it relates to", "from the perspective of"
**When to flag**: Padding that delays the point
**Example**:
- ❌ "In terms of functionality, when it comes to user experience, the system provides value"
- ✅ "The system provides good functionality and user experience"

#### Excessive Hedging
**Triggers**: "may", "might", "could", "potentially", "possibly", "arguably" (stacked)
**When to flag**: Multiple hedges in one sentence
**Example**:
- ❌ "This could potentially arguably be considered possibly useful"
- ✅ "This may be useful" OR "This is useful"

#### Generic Conclusions
**Triggers**: "That being said", "At the end of the day", "All things considered", "When all is said and done"
**When to flag**: Conclusion that summarizes without insight

## Output Format

When analyzing text, provide:

```
## Analysis Results

**Text analyzed**: [word count] words

### High Confidence Patterns (N)
[For each pattern:]
1. **Pattern Name** - "trigger phrase" (location reference)
   Text: "...exact quote from text..."
   Issue: [Why it's flagged - specific to this instance]
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

## Detection Strategy

1. **Scan for high-confidence patterns first**
   - Content: significance inflation, promotional language, vague attributions
   - Language: AI vocabulary, copula avoidance
   - Communication: chatbot phrases, disclaimers, filler

2. **Check for pattern clusters**
   - Multiple patterns in same sentence = higher confidence
   - Example: "Additionally" + "serves as" + "pivotal" = very likely AI

3. **Verify with context**
   - Is the pattern inappropriate for this text type?
   - Would a human expert in this domain write this way?

4. **Provide specific locations**
   - Quote exact phrase with surrounding context
   - Reference paragraph/line if available

5. **Give concrete suggestions**
   - Don't just flag - show how to fix
   - Specific rewrites, not generic advice

## Common Mistakes

**Mistake**: Flagging every em dash or "additionally"
**Fix**: Consider density and context - one instance may be fine, five in a paragraph is suspicious

**Mistake**: Claiming text is "definitely AI"
**Fix**: Patterns are indicators, not proof. Use confidence levels.

**Mistake**: Generic suggestions like "be more specific"
**Fix**: Show the actual rewrite: "The library is a community center" not "serves as a community center"

**Mistake**: Missing pattern clusters
**Fix**: When you find one pattern, check surroundings for others

**Mistake**: Ignoring context
**Fix**: "Vibrant" in marketing copy is fine; in encyclopedia entry is suspicious

## Real-World Impact

This skill enables:
- Systematic detection using Wikipedia's research-backed patterns
- Consistent pattern naming (not ad-hoc descriptions)
- Confidence-based prioritization (fix high-confidence patterns first)
- Concrete improvement suggestions (not vague "be more human")
- Educational value (learn what makes writing sound AI-generated)

## Updating Patterns

Wikipedia's "Signs of AI writing" article evolves as AI writing changes. To update:

1. Check Wikipedia for new patterns: https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing
2. Run `update-patterns.sh` to fetch latest wikitext
3. Review changes and update pattern database above
4. Test with known AI-generated samples
5. Update `last_updated` in frontmatter

Last updated: 2026-01-22 (Wikipedia revision: January 2026)
