# AI Writing Pattern Database

Wikipedia documents 35+ specific AI writing patterns across 7 categories. Each pattern has trigger phrases, confidence level, and improvement guidance.

Words marked *(→ AI Vocab)* also appear in the Overused AI Vocabulary list, which tracks era-specific clustering. Each category explains why the word is problematic in *that* context, so the cross-listing is intentional.

---

## Content Patterns (High Confidence)

### Undue Emphasis on Significance
**Triggers**: "stands/serves as", "is a testament/reminder", "pivotal/crucial/key role/moment" *(→ AI Vocab)*, "marking/shaping the", "underscores/highlights its importance/significance" *(→ AI Vocab)*, "reflects broader", "symbolizing its ongoing/enduring/lasting" *(→ AI Vocab)*, "contributing to the", "setting the stage for", "represents/marks a shift", "key turning point", "evolving landscape" *(→ AI Vocab)*, "focal point", "indelible mark", "deeply rooted", "testament" *(→ AI Vocab)*
**When to flag**: Used for mundane topics (population data, etymology, minor features). In biology/nature writing, watch for inflated ecosystem connections and conservation status emphasis when status is unknown.
**Example**:

- ❌ "The library was established in 1992, marking a pivotal moment in regional literacy"
- ✅ "The library was established in 1992 to serve the growing community"

### Notability and Attribution Emphasis
**Triggers**: "notable", "notably", "worth noting", "important to note", "independent coverage", "media outlets", "profiled in", "featured in", "cited in", "active social media presence", "maintains a strong digital presence"
**When to flag**: Asserting notability by listing media coverage without summarizing what sources actually said; echoing notability guidelines rather than demonstrating them; 3+ "notable/notably" in short text
**Example**:

- ❌ "Her insights have been featured in Wired, Refinery29, and other prominent media outlets"
- ✅ "She argued in Wired (2024) that AI regulation needs sector-specific approaches"

**Subtypes**:

- **Trivial source attribution**: LLMs over-emphasize named sources in body text for mundane or uncontroversial facts a human would footnote or skip. Example: "The restaurant has also been mentioned in ABC News coverage relating to incidents in the surrounding precinct." High confidence when the attribution adds no information and the reference doesn't support the claim.
- **Named-source misattribution** (RAG models): Chatbots with web access attach analysis statements to specific named sources regardless of whether those sources say anything close. Example: "Roger Ebert highlighted the lasting influence of the film" — the source says nothing of the sort. Check: does the cited source actually say what's attributed to it?

### Superficial Analysis
**Triggers**: "highlighting/underscoring/emphasizing..." *(→ AI Vocab)*, "ensuring...", "reflecting/symbolizing...", "contributing to...", "cultivating/fostering..." *(→ AI Vocab)* (figurative), "encompassing...", "valuable insights", "align/resonate with", "multifaceted", "nuanced", "complex interplay", "delicate balance", "various factors"
**When to flag**: Claims complexity without explaining what's complex; attaches a present participle ("-ing") phrase at the end of sentences to add shallow analysis; attributes analysis to unnamed sources
**Example**:

- ❌ "The founding of the institute represented a significant shift, contributing to the socio-economic development of the region"
- ✅ "The institute was founded in 1989 to produce regional statistics independently"

### Promotional Language
**Triggers**: "vibrant" *(→ AI Vocab)*, "dynamic", "thriving", "bustling", "diverse array/range/tapestry" *(→ AI Vocab)*, "boasts a" *(→ Copula Avoidance)*, "rich" (figurative), "profound", "enhancing its", "showcasing" *(→ AI Vocab)*, "exemplifies", "commitment to", "natural beauty", "nestled", "in the heart of", "groundbreaking" (figurative), "renowned", "featuring"
**When to flag**: Marketing adjectives in neutral context; happens even when LLMs are prompted to use encyclopedic tone
**Example**:

- ❌ "Nestled in the heart of the valley, this vibrant town boasts a rich cultural tapestry"
- ✅ "The town, located in the central valley, hosts annual craft markets and music festivals"

**Subtypes**:

- **Cultural Heritage Inflation**: LLMs inflate cultural heritage significance even for mundane topics (e.g., a country's electronics industry, a town's road network). Additional triggers: "rich cultural heritage", "breathtaking", "gateway to", "stands as a vibrant"
- **Press-Release/Commercial Tone**: When writing about people or companies, LLMs adopt promotional press-release language. Additional triggers: "align with goals of", "powerful emotional presence", "reducing its environmental footprint", "fostering community development"

### Vague Attributions and Overgeneralization
**Triggers**: "some researchers", "studies show", "experts say/argue", "it is believed", "industry reports", "observers have cited", "some critics argue", "several sources/publications" (when only 1-2 are cited), "such as" (before exhaustive lists presented as non-exhaustive)
**When to flag**: No specific citation follows; exaggerates number of sources; presents one person's view as widely held
**Example**:

- ❌ "Several publications have cited her work as groundbreaking" [cites only 2 articles]
- ✅ "The LA Times and Time Magazine profiled her work in 2024"

### Challenges and Future Prospects Formula
**Triggers**: "Despite its... faces several challenges...", "Despite these challenges", "Challenges and Legacy", "Future Outlook", "Future Prospects"
**When to flag**: Rigid formulaic section that begins acknowledging positives, lists vague challenges, ends with optimistic speculation. Often appears at the end of articles.
**Example**:

- ❌ "Despite its vibrant cultural scene, the city faces several challenges including infrastructure and economic development. Despite these challenges, ongoing initiatives promise a brighter future."
- ✅ [Omit, or state specific challenges with evidence: "Traffic congestion increased 30% between 2020-2024 (City Report, 2024)"]

### Leads Treating Titles as Proper Nouns
**Triggers**: Opening sentence defines the document/article/section title as a standalone real-world entity; treating descriptive phrases or compound titles as proper nouns; "X is a curated compilation of...", "X refers to the...", "X is the chronological list of..."
**When to flag**: High confidence when the title is a descriptive phrase (not a proper noun) and the opening sentence formally defines it as an entity. Common in AI-generated blog posts, documentation pages, and wiki articles.
**Example**:

- ❌ "'List of songs about Mexico' is a curated compilation of musical works that reference Mexico"
- ✅ "The following songs reference Mexico in their lyrics or themes"

---

## Language Patterns (High Confidence)

### Overused AI Vocabulary
**Triggers**: "Additionally" (sentence-start), "Moreover", "Furthermore", "Consequently", "Hence", "Thus", "Therefore" (overused), "bolstered", "leverage", "meticulous/meticulously", "utilize", "facilitate", "underscore" (verb), "showcase", "underline", "align with", "crucial", "delve" (declining sharply post-2024), "emphasizing", "enduring", "enhance", "fostering", "garner", "highlight" (verb), "interplay", "intricate/intricacies", "key" (adjective), "landscape" (abstract), "pivotal", "tapestry" (abstract), "testament", "valuable", "vibrant"

Words appearing here that also appear in other categories are cross-listed because each context explains a different failure mode: "vibrant" in Promotional Language explains the marketing-tone problem; here it explains the statistical overuse problem. Both framings apply simultaneously.

**Era clustering**:

- 2023–mid 2024 (GPT-4): Additionally, boasts, bolstered, crucial, delve, emphasizing, enduring, garner, intricate/intricacies, interplay, key, landscape, meticulous/meticulously, pivotal, underscore, tapestry, testament, valuable, vibrant
- Mid-2024–mid 2025 (GPT-4o): align with, bolstered, crucial, emphasizing, enhance, enduring, fostering, highlighting, pivotal, showcasing, underscore, vibrant
- Mid-2025+ (GPT-5): emphasizing, enhance, highlighting, showcasing — plus the notability/attribution cluster (Wikipedia explicitly links GPT-5 era to "Undue Emphasis on Notability, Attribution, and Media Coverage" patterns)

**When to flag**: Multiple formal connectors in short text; weak verbs replacing simple ones; research shows statistically elevated usage in AI text (Kobak et al.)
**Example**:

- ❌ "Additionally, the system leverages technology to facilitate user engagement"
- ✅ "The system uses technology to increase user engagement"

### Copula Avoidance
**Triggers**: "serves as", "acts as", "functions as", "stands as", "represents", "constitutes", "boasts/features/offers [a]" *(→ Promotional Language)*
**When to flag**: Replaces simple "is/are" unnecessarily. Research shows >10% decrease in "is"/"are" usage in AI text. Particularly visible in AI copyedits.
**Example**:

- ❌ "The building serves as a community center"
- ✅ "The building is a community center"
**Note**: Less reliable when AI is imitating a well-known format (e.g., encyclopedia leads, README templates). LLMs trained on such formats have plenty of examples to emulate.

### Negative Parallelisms
**Triggers**: "not only... but also", "not just... but", "both... and", "It is not just about..., it's...", negation-then-assertion patterns ("not ..., it's ..."), "Not X, but Y" subtypes: "is not..., but...", "no..., no..., just..."
**When to flag**: Used to inflate simple statements; multi-sentence negative parallelisms spanning paragraphs
**Example**:

- ❌ "The library provides not only books but also digital resources"
- ✅ "The library provides books and digital resources"

### Rule of Three
**Triggers**: Lists of exactly three items ("adjective, adjective, and adjective"), "Firstly... Secondly... Lastly"
**When to flag**: Artificial triplets where 2 or 4 items would be natural; used for superficial analysis
**Example**:

- ❌ "The system is reliable, scalable, and maintainable" [when only 2 properties matter]
- ✅ "The system is reliable and scales to handle peak loads"

### Elegant Variation (formerly "Synonym Cycling")
**Triggers**: Multiple synonyms for same concept: "vital/crucial/essential/critical/pivotal/key", "showcase/highlight/demonstrate/illustrate", "comprehensive/thorough/exhaustive/complete"
**When to flag**: Rotating through synonyms to avoid repetition. Caused by repetition-penalty mechanisms in LLMs that penalize reusing the same word, forcing synonym substitution even when repetition would be clearer.
**Example**:

- ❌ "Soviet artistic constraints" → "state-imposed artistic norms" → "confines of state ideology" [same concept cycled through synonyms]
- ✅ Pick one term and use it consistently

### False Ranges
**Triggers**: "between X and Y" where Y is absurdly high, "from X to Y" with meaningless breadth
**When to flag**: Meaningless range used to hedge. Legitimate ranges are quantitative (10-15 km), qualitative (warm to hot), or merisms (young and old). False ranges span so wide they convey no information.
**Example**:

- ❌ "The project will take between 2 weeks and 6 months"
- ✅ "The project will take 4-6 weeks" OR "Timeline depends on resource availability"

---

## Style Patterns (Medium Confidence)

### Em Dash Overuse
**Triggers**: 3+ em dashes in paragraph, em dashes interrupting simple sentences
**When to flag**: Used for complexity instead of clarity. Note: GPT-5.1 (Nov 2025) actively suppresses em dashes; declining as indicator in newer models.
**Example**:

- ❌ "The system — which was developed in 2020 — provides users with access to — among other things — digital resources"
- ✅ "The system (developed in 2020) provides users with digital resources and other materials"

### Excessive Boldface
**Triggers**: Multiple bold words/phrases in short paragraph, "Key Takeaways" sections
**When to flag**: Artificial emphasis throughout text; bold inline headers in vertical lists. Pattern inherited from READMEs, fan wikis, sales pitches, and slide decks.
**Note**: Legitimate uses exist (headings, UI elements). Some newer LLMs have instructions to avoid this.

### Unnatural Title Case
**Triggers**: Title Case In Section Headings Or Mid-Sentence
**When to flag**: Capitalizing all main words in headings where sentence case is standard; inconsistent capitalization rules

### Emoji Usage (Context-dependent)
**Triggers**: Emojis in formal/neutral text, emoji-decorated section headings, emoji bullet points
**When to flag**: Inappropriate tone for context; most common in informal pasted chatbot output

### Curly Quotes in Technical Text
**Triggers**: "curly quotes" instead of "straight quotes" in code or technical text
**When to flag**: Technical documentation with typographic quotes. ChatGPT and DeepSeek produce curly quotes; Claude and Gemini typically do not. Also produced by macOS smart quotes and Microsoft Word.

### Unusual Tables
**Triggers**: Small tables where prose would suffice
**When to flag**: LLMs create tabular formatting for information that reads better as sentences

### Inline-Header Vertical Lists
**Triggers**: Bold inline headers in bullet/numbered lists: "1. **Topic**: description...", "- **Key point**: explanation..."
**When to flag**: Inherited from READMEs, fan wikis, and listicles. Strong signal in encyclopedic or formal prose where plain lists or paragraphs are standard.

### Markdown in Non-Markdown Contexts
**Triggers**: `**bold**` instead of native formatting, `##` for headings, fenced code blocks in non-Markdown environments
**When to flag**: High confidence when mixed with other markup systems (HTML, wikitext, rich-text editors). Strong signal of pasted chatbot output.

### Skipping Heading Levels
**Triggers**: Jumping from h1/h2 directly to h3+; excessive `###` nesting
**When to flag**: Chatbots trained on Markdown default to `###`; legitimate documents use sequential heading levels.

### Thematic Breaks Before Headings
**Triggers**: Horizontal rules (`----`, `---`, `***`) inserted before every heading or section break
**When to flag**: Medium confidence. Chatbots insert thematic breaks as section separators. Legitimate in some contexts (slide decks, changelogs).

---

## Markup Patterns (High Confidence)

### Chatbot Citation Artifacts
**Triggers**: `turn0search0`, `citeturn0search1` (ChatGPT citation placeholders), `contentReference[oaicite:0]{index=0}` (ChatGPT reference bugs), `utm_source=chatgpt.com` / `utm_source=openai` in URLs, `[attached_file:1]` (Perplexity), `grok_card` tags (Grok)
**When to flag**: Any of these in published content is near-certain chatbot output. Check URLs for tracking parameters too.

### ChatGPT Attribution Markup
**Triggers**: `({"attribution":{"attributableIndex":"X-Y"}})` appended to sentences, JSON-formatted attribution metadata in plain text
**When to flag**: Very high confidence ChatGPT artifact. Near-certain indicator of unedited ChatGPT paste.

### Hallucinated Citations
**Triggers**: Multiple broken URLs (404s with no archive), DOIs resolving to unrelated articles, invalid ISBN checksums, book citations lacking page numbers or URLs, batch of citations sharing the same old access-date
**When to flag**: High confidence when multiple citation red flags cluster. Three subtypes: (1) broken external links — URLs that 404, (2) invalid identifiers — bad ISBN checksums, malformed DOIs, (3) mismatched DOIs — resolve to real but completely unrelated articles. Verify DOIs and ISBNs before flagging.

### Hallucinated Internal References
**Triggers**: Links to non-existent pages, API endpoints, function names, or shortcuts; references to non-existent sections within the same document
**When to flag**: High confidence. In code docs, watch for references to non-existent APIs or modules; in wikis, fake shortcuts or policy references.

### Template/Markup Transclusion Errors
**Triggers**: Rendered maintenance banners in discussion text; template syntax executing instead of displaying; missing code fences around markup references
**When to flag**: Medium confidence, context-dependent (most relevant in wiki/CMS contexts). AI writes template/macro names in literal syntax (e.g., `{{Example}}`) when discussing them rather than quoting them. Generalizes: AI incorrectly invokes system-specific markup syntax when referencing it as text.
**Example**:

- ❌ Talk page comment: "I added {{Unreliable sources}} to flag the issue" → banner renders
- ✅ "I added the `{{Unreliable sources}}` tag to flag the issue"

---

## Communication Patterns (High Confidence)

### Collaborative Communication
**Triggers**: "I hope this helps", "Feel free to", "Don't hesitate to", "I'd be happy to", "I understand that", "Of course!", "Certainly!", "Would you like...", "here is a", "more detailed breakdown"
**When to flag**: Conversational chatbot phrases in written content; pasted advice or meta-commentary
**Example**:

- ❌ "I hope this article helps you understand the topic. Feel free to explore related articles"
- ✅ "See related articles for more information"

### AI-Generated Defensive Text
**Triggers**: "each claim is verified", "content is neutral and encyclopedic", "adhering to [platform] guidelines", "ensuring neutrality", selectively citing specific rules/policies to argue compliance, "I used AI only as a drafting tool"
**When to flag**: Medium confidence. When challenged on AI authorship, AI-assisted users produce boilerplate rebuttals asserting content is neutral, verified, and compliant — often using the same patterns being challenged. Also manifests as policy-citation overload.
**Example**:

- ❌ "Every fact in this article is supported by high-quality, third-party sources. Claiming 'AI' as a pretext to delete documented information is a violation of [policy]."
- ✅ [Human defense: specific, informal, references actual passages]

### Knowledge-Cutoff Disclaimers
**Triggers**: "as of my last knowledge update", "not widely available/documented", "based on available information", "keeps personal life private", "information about X is limited"
**When to flag**: Disclaimers about training data limitations; speculative statements about why information is missing
**Example**:

- ❌ "As of my last knowledge update in 2024, the company's revenue figures are not widely documented"
- ✅ [Omit if information is unavailable, or cite a source]

### Placeholder Text and Templates
**Triggers**: "[Your Name]", "[Describe the specific section]", "INSERT_SOURCE_URL", "PASTE_URL_HERE", "2025-XX-XX", "[Entertainer's Name]", Mad-Libs-style fill-in-the-blank templates
**When to flag**: Unfilled template variables left by users who pasted LLM output without completing it

### Sycophantic Tone
**Triggers**: "excellent question", "great point", "absolutely", "certainly", "definitely" (overused)
**When to flag**: Excessive agreement/enthusiasm in neutral text

### Filler Expressions
**Triggers**: "in terms of", "when it comes to", "with regard to", "as it relates to", "from the perspective of"
**When to flag**: Padding that delays the point
**Example**:

- ❌ "In terms of functionality, when it comes to user experience, the system provides value"
- ✅ "The system provides good functionality and user experience"

### Excessive Hedging
**Triggers**: "may", "might", "could", "potentially", "possibly", "arguably" (stacked)
**When to flag**: Multiple hedges in one sentence
**Example**:

- ❌ "This could potentially arguably be considered possibly useful"
- ✅ "This may be useful" OR "This is useful"

### Generic Conclusions
**Triggers**: "That being said", "At the end of the day", "All things considered", "When all is said and done"
**When to flag**: Conclusion that summarizes without insight

---

## Historical Patterns (Lower Confidence — declining in newer models)

### Didactic Disclaimers (common 2022–2024)
**Triggers**: "It's important to note", "It should be mentioned", "It's worth noting", "One should keep in mind", "it's important/critical/crucial to note/remember/consider"
**When to flag**: Very common in 2023 LLMs, declining sharply by 2025. Downweight confidence accordingly.
**Example**:

- ❌ "It's important to note that the library opened in 1992"
- ✅ "The library opened in 1992"

### Formulaic Conclusions (common pre-2025)
**Triggers**: "in conclusion", "in summary", "ultimately", "thus it can be seen", "Overall"
**When to flag**: Mechanical summary with no new insight. Declining in newer models.
**Example**:

- ❌ "In conclusion, the library serves an important role in the community"
- ✅ [End with substantive point, or omit conclusion]

### Prompt Refusal Artifacts (declining since 2024)
**Triggers**: "as an AI language model", "I cannot offer medical/legal advice", "I'm not able to provide", "I don't have personal opinions"
**When to flag**: Safety-layer refusal text pasted into published content. Was very common in 2023; newer models are less trigger-happy.

### Abrupt Cut-Offs
**Triggers**: Mid-sentence truncation, incomplete lists, text ending with a comma or conjunction
**When to flag**: Token-limit truncation where the user pasted output without noticing it was cut short.

---

## Structural Indicators (Medium Confidence)

### Sudden Style Shifts
**Triggers**: Abrupt changes in grammar quality, vocabulary level, or English variety mid-text
**When to flag**: One section reads casually while another is formally polished; British/American English inconsistency within same text

### Verbose Meta-Descriptions
**Triggers**: Overly formal first-person descriptions of changes/edits, "I revised the content to provide a neutral description adhering to...", submission statements explaining why content meets guidelines, "adhering to encyclopedic standards", "ensuring neutrality"
**When to flag**: High confidence when combined with guideline-parroting language.

### Subject Lines and Templates
**Triggers**: "Subject: Request for..." pasted from email-style chatbot output, pre-placed maintenance/review templates in new content, form-letter openings ("Dear [Title]", "I am writing to...")
**When to flag**: Chatbot email/letter templates pasted without adaptation into non-email contexts.
