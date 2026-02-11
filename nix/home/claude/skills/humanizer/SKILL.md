---
name: humanizer
description: Use when analyzing text for AI writing patterns - detects Wikipedia-documented signs like significance inflation, copula avoidance, promotional language, chatbot phrases, and 30+ other specific patterns
---

# Humanizer: AI Writing Pattern Detection

## Overview

Detect AI-generated text using Wikipedia's documented patterns from "Signs of AI writing". Provides systematic analysis across 30+ specific pattern categories with confidence levels and concrete suggestions. Patterns are backed by academic research (Kobak et al., Reinhart et al., Juzek & Ward, Russell et al.).

## Caveats

- Patterns are indicators, not proof. Use confidence levels.
- Each AI model has a distinctive idiolect; patterns typical for ChatGPT may not apply to Gemini or Claude.
- Expert LLM users correctly identify AI text ~90% of the time, meaning ~10% false positive rate even for experts.
- Do not rely solely on automated AI detection tools (GPTZero, etc.) — they have non-trivial error rates and can be fooled by paraphrasing.

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

Wikipedia documents 30+ specific AI writing patterns across 5 categories. Each pattern has trigger phrases, confidence level, and improvement guidance.

### Content Patterns (High Confidence)

#### Undue Emphasis on Significance
**Triggers**: "stands/serves as", "is a testament/reminder", "pivotal/crucial/key role/moment", "marking/shaping the", "underscores/highlights its importance/significance", "reflects broader", "symbolizing its ongoing/enduring/lasting", "contributing to the", "setting the stage for", "represents/marks a shift", "key turning point", "evolving landscape", "focal point", "indelible mark", "deeply rooted"
**When to flag**: Used for mundane topics (population data, etymology, minor features). In biology/nature writing, watch for inflated ecosystem connections and conservation status emphasis when status is unknown.
**Example**:
- ❌ "The library was established in 1992, marking a pivotal moment in regional literacy"
- ✅ "The library was established in 1992 to serve the growing community"

#### Notability and Attribution Emphasis
**Triggers**: "notable", "notably", "worth noting", "important to note", "independent coverage", "media outlets", "profiled in", "featured in", "cited in", "active social media presence", "maintains a strong digital presence"
**When to flag**: Asserting notability by listing media coverage without summarizing what sources actually said; echoing notability guidelines rather than demonstrating them; 3+ "notable/notably" in short text
**Example**:
- ❌ "Her insights have been featured in Wired, Refinery29, and other prominent media outlets"
- ✅ "She argued in Wired (2024) that AI regulation needs sector-specific approaches"

#### Superficial Analysis
**Triggers**: "highlighting/underscoring/emphasizing...", "ensuring...", "reflecting/symbolizing...", "contributing to...", "cultivating/fostering..." (figurative), "encompassing...", "valuable insights", "align/resonate with", "multifaceted", "nuanced", "complex interplay", "delicate balance", "various factors"
**When to flag**: Claims complexity without explaining what's complex; attaches a present participle ("-ing") phrase at the end of sentences to add shallow analysis; attributes analysis to unnamed sources
**Example**:
- ❌ "The founding of the institute represented a significant shift, contributing to the socio-economic development of the region"
- ✅ "The institute was founded in 1989 to produce regional statistics independently"

#### Promotional Language
**Triggers**: "vibrant", "dynamic", "thriving", "bustling", "diverse array/range/tapestry", "boasts a", "rich" (figurative), "profound", "enhancing its", "showcasing", "exemplifies", "commitment to", "natural beauty", "nestled", "in the heart of", "groundbreaking" (figurative), "renowned"
**When to flag**: Marketing adjectives in neutral context; happens even when LLMs are prompted to use encyclopedic tone
**Example**:
- ❌ "Nestled in the heart of the valley, this vibrant town boasts a rich cultural tapestry"
- ✅ "The town, located in the central valley, hosts annual craft markets and music festivals"

#### Vague Attributions and Overgeneralization
**Triggers**: "some researchers", "studies show", "experts say/argue", "it is believed", "industry reports", "observers have cited", "some critics argue", "several sources/publications" (when only 1-2 are cited), "such as" (before exhaustive lists presented as non-exhaustive)
**When to flag**: No specific citation follows; exaggerates number of sources; presents one person's view as widely held
**Example**:
- ❌ "Several publications have cited her work as groundbreaking" [cites only 2 articles]
- ✅ "The LA Times and Time Magazine profiled her work in 2024"

#### Challenges and Future Prospects Formula
**Triggers**: "Despite its... faces several challenges...", "Despite these challenges", "Challenges and Legacy", "Future Outlook", "Future Prospects"
**When to flag**: Rigid formulaic section that begins acknowledging positives, lists vague challenges, ends with optimistic speculation. Often appears at the end of articles.
**Example**:
- ❌ "Despite its vibrant cultural scene, the city faces several challenges including infrastructure and economic development. Despite these challenges, ongoing initiatives promise a brighter future."
- ✅ [Omit, or state specific challenges with evidence: "Traffic congestion increased 30% between 2020-2024 (City Report, 2024)"]

### Language Patterns (High Confidence)

#### Overused AI Vocabulary
**Triggers**: "Additionally" (sentence-start), "Moreover", "Furthermore", "Consequently", "Hence", "Thus", "Therefore" (overused), "leverage", "utilize", "facilitate", "underscore" (verb), "showcase", "underline", "align with", "crucial", "delve" (declining post-2024), "emphasizing", "enduring", "enhance", "fostering", "garner", "highlight" (verb), "interplay", "intricate/intricacies", "key" (adjective), "landscape" (abstract), "pivotal", "tapestry" (abstract), "testament", "valuable", "vibrant"
**When to flag**: Multiple formal connectors in short text; weak verbs replacing simple ones; research shows statistically elevated usage in AI text (Kobak et al.)
**Example**:
- ❌ "Additionally, the system leverages technology to facilitate user engagement"
- ✅ "The system uses technology to increase user engagement"

#### Copula Avoidance
**Triggers**: "serves as", "acts as", "functions as", "stands as", "represents", "constitutes", "boasts/features/offers [a]"
**When to flag**: Replaces simple "is/are" unnecessarily. Research shows >10% decrease in "is"/"are" usage in AI text. Particularly visible in AI copyedits.
**Example**:
- ❌ "The building serves as a community center"
- ✅ "The building is a community center"

#### Negative Parallelisms
**Triggers**: "not only... but also", "not just... but", "both... and", "It is not just about..., it's...", negation-then-assertion patterns ("not ..., it's ...")
**When to flag**: Used to inflate simple statements; multi-sentence negative parallelisms spanning paragraphs
**Example**:
- ❌ "The library provides not only books but also digital resources"
- ✅ "The library provides books and digital resources"

#### Rule of Three
**Triggers**: Lists of exactly three items ("adjective, adjective, and adjective"), "Firstly... Secondly... Lastly"
**When to flag**: Artificial triplets where 2 or 4 items would be natural; used for superficial analysis
**Example**:
- ❌ "The system is reliable, scalable, and maintainable" [when only 2 properties matter]
- ✅ "The system is reliable and scales to handle peak loads"

#### Elegant Variation (formerly "Synonym Cycling")
**Triggers**: Multiple synonyms for same concept: "vital/crucial/essential/critical/pivotal/key", "showcase/highlight/demonstrate/illustrate", "comprehensive/thorough/exhaustive/complete"
**When to flag**: Rotating through synonyms to avoid repetition. Caused by repetition-penalty mechanisms in LLMs that penalize reusing the same word, forcing synonym substitution even when repetition would be clearer.
**Example**:
- ❌ "Soviet artistic constraints" → "state-imposed artistic norms" → "confines of state ideology" [same concept cycled through synonyms]
- ✅ Pick one term and use it consistently

#### False Ranges
**Triggers**: "between X and Y" where Y is absurdly high, "from X to Y" with meaningless breadth
**When to flag**: Meaningless range used to hedge. Legitimate ranges are quantitative (10-15 km), qualitative (warm to hot), or merisms (young and old). False ranges span so wide they convey no information.
**Example**:
- ❌ "The project will take between 2 weeks and 6 months"
- ✅ "The project will take 4-6 weeks" OR "Timeline depends on resource availability"

### Style Patterns (Medium Confidence)

#### Em Dash Overuse
**Triggers**: 3+ em dashes in paragraph, em dashes interrupting simple sentences
**When to flag**: Used for complexity instead of clarity. Note: may be less common in newer AI models (late 2025+).
**Example**:
- ❌ "The system — which was developed in 2020 — provides users with access to — among other things — digital resources"
- ✅ "The system (developed in 2020) provides users with digital resources and other materials"

#### Excessive Boldface
**Triggers**: Multiple bold words/phrases in short paragraph, "Key Takeaways" sections
**When to flag**: Artificial emphasis throughout text; bold inline headers in vertical lists. Pattern inherited from READMEs, fan wikis, sales pitches, and slide decks.
**Note**: Legitimate uses exist (headings, UI elements). Some newer LLMs have instructions to avoid this.

#### Unnatural Title Case
**Triggers**: Title Case In Section Headings Or Mid-Sentence
**When to flag**: Capitalizing all main words in headings where sentence case is standard; inconsistent capitalization rules

#### Emoji Usage (Context-dependent)
**Triggers**: Emojis in formal/neutral text, emoji-decorated section headings, emoji bullet points
**When to flag**: Inappropriate tone for context; most common in informal pasted chatbot output

#### Curly Quotes in Technical Text
**Triggers**: \u201ccurly quotes\u201d instead of "straight quotes" in code or technical text
**When to flag**: Technical documentation with typographic quotes. Note: ChatGPT and DeepSeek produce curly quotes; Claude and Gemini typically do not. Also produced by macOS smart quotes and Microsoft Word.

#### Unusual Tables
**Triggers**: Small tables where prose would suffice
**When to flag**: LLMs create tabular formatting for information that reads better as sentences

### Communication Patterns (High Confidence)

#### Collaborative Communication
**Triggers**: "I hope this helps", "Feel free to", "Don't hesitate to", "I'd be happy to", "I understand that", "Of course!", "Certainly!", "Would you like...", "here is a", "more detailed breakdown"
**When to flag**: Conversational chatbot phrases in written content; pasted advice or meta-commentary; text that reads like one side of a conversation
**Example**:
- ❌ "I hope this article helps you understand the topic. Feel free to explore related articles"
- ✅ "See related articles for more information"

#### Knowledge-Cutoff Disclaimers
**Triggers**: "as of my last knowledge update", "not widely available/documented", "based on available information", "keeps personal life private", "information about X is limited"
**When to flag**: Disclaimers about training data limitations; speculative statements about why information is missing
**Example**:
- ❌ "As of my last knowledge update in 2024, the company's revenue figures are not widely documented"
- ✅ [Omit if information is unavailable, or cite a source]

#### Placeholder Text and Templates
**Triggers**: "[Your Name]", "[Describe the specific section]", "INSERT_SOURCE_URL", "PASTE_URL_HERE", "2025-XX-XX", "[Entertainer's Name]", Mad-Libs-style fill-in-the-blank templates
**When to flag**: Unfilled template variables left by users who pasted LLM output without completing it

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

### Historical Patterns (Lower Confidence — declining in newer models)

#### Didactic Disclaimers (common pre-2025)
**Triggers**: "It's important to note", "It should be mentioned", "It's worth noting", "One should keep in mind", "it's important/critical/crucial to note/remember/consider"
**When to flag**: Hedging without adding information. Was very common in ~2023 LLMs but declining in newer models.
**Example**:
- ❌ "It's important to note that the library opened in 1992"
- ✅ "The library opened in 1992"

#### Formulaic Conclusions (common pre-2025)
**Triggers**: "in conclusion", "in summary", "ultimately", "thus it can be seen", "Overall"
**When to flag**: Mechanical summary that adds no new insight. Was common in early ChatGPT but declining.
**Example**:
- ❌ "In conclusion, the library serves an important role in the community"
- ✅ [End with substantive point, or omit conclusion]

### Structural Indicators (Medium Confidence)

#### Sudden Style Shifts
**Triggers**: Abrupt changes in grammar quality, vocabulary level, or English variety mid-text
**When to flag**: One section reads casually while another is formally polished; British/American English inconsistency within same text

#### Verbose Summaries and Edit Descriptions
**Triggers**: Unusually detailed first-person descriptions of changes, "adhering to encyclopedic standards", "ensuring neutrality"
**When to flag**: Descriptions of edits or changes that are far more formal and verbose than normal

## Output Format

When analyzing text, provide:

```markdown
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

### 1. Scan for high-confidence patterns first

- Content: significance inflation, notability/attribution emphasis, superficial analysis, promotional language, vague attributions, challenges/prospects formula
- Language: AI vocabulary, copula avoidance, elegant variation
- Communication: collaborative chatbot phrases, knowledge-cutoff disclaimers, placeholder text

### 2. Check for pattern clusters

- Multiple patterns in same sentence = higher confidence
- Example: "Additionally" + "serves as" + "pivotal" = very likely AI
- Look for present participle ("-ing") chains at sentence ends

### 3. Verify with context

- Is the pattern inappropriate for this text type?
- Would a human expert in this domain write this way?
- Consider the specific AI model's idiolect (ChatGPT vs Gemini vs Claude)

### 4. Provide specific locations

- Quote exact phrase with surrounding context
- Reference paragraph/line if available

### 5. Give concrete suggestions

- Don't just flag — show how to fix
- Specific rewrites, not generic advice

## Ineffective Indicators

Do NOT flag these as AI patterns (they produce false positives):
- Perfect grammar or spelling (humans can also write correctly)
- Bland or robotic prose style (not specific to AI)
- Use of academic or formal vocabulary (domain-appropriate in many contexts)
- Use of conjunctions at sentence starts (normal English)

## Common Mistakes

**Mistake**: Flagging every em dash or "additionally"
**Fix**: Consider density and context — one instance may be fine, five in a paragraph is suspicious

**Mistake**: Claiming text is "definitely AI"
**Fix**: Patterns are indicators, not proof. Use confidence levels.

**Mistake**: Generic suggestions like "be more specific"
**Fix**: Show the actual rewrite: "The library is a community center" not "serves as a community center"

**Mistake**: Missing pattern clusters
**Fix**: When you find one pattern, check surroundings for others

**Mistake**: Ignoring context
**Fix**: "Vibrant" in marketing copy is fine; in encyclopedia entry is suspicious

**Mistake**: Flagging historical patterns at high confidence
**Fix**: "It's important to note" was a strong tell in 2023; newer models use it less. Downweight historical patterns.

## Updating Patterns

Wikipedia's "Signs of AI writing" article evolves as AI writing changes. To update:

1. Check Wikipedia for new patterns: <https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing>
2. Run `update-patterns.sh` to fetch latest wikitext
3. Review changes and update pattern database above
4. Test with known AI-generated samples
5. Update `last_updated` below

Last updated: 2026-02-10 (Wikipedia revision: February 2026)
