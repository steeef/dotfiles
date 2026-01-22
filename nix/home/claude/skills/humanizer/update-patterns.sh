#!/usr/bin/env bash
# update-patterns.sh - Fetch latest Wikipedia "Signs of AI writing" content
#
# Usage: ./update-patterns.sh
#
# This script fetches the current wikitext of Wikipedia's "Signs of AI writing"
# article for manual review and integration into SKILL.md

set -euo pipefail

WIKI_PAGE="Wikipedia:Signs_of_AI_writing"
TIMESTAMP=$(date +%Y-%m-%d)
SNAPSHOT_FILE="wp-snapshot-${TIMESTAMP}.txt"

echo "Fetching Wikipedia article: ${WIKI_PAGE}"
echo "Timestamp: ${TIMESTAMP}"
echo ""

# Fetch wikitext via Wikipedia API
curl -s "https://en.wikipedia.org/w/api.php?action=parse&page=${WIKI_PAGE}&format=json&prop=wikitext" \
  | jq -r '.parse.wikitext["*"]' > "$SNAPSHOT_FILE"

if [ -s "$SNAPSHOT_FILE" ]; then
    echo "✓ Saved snapshot to ${SNAPSHOT_FILE}"
    echo ""
    echo "Preview (first 50 lines):"
    echo "========================="
    head -50 "$SNAPSHOT_FILE"
    echo "========================="
    echo ""
    echo "Next steps:"
    echo "1. Review full content: less ${SNAPSHOT_FILE}"
    echo "2. Compare with current SKILL.md patterns"
    echo "3. Update SKILL.md with new/changed patterns"
    echo "4. Test updated skill with known AI samples"
    echo "5. Update 'last_updated' date in SKILL.md frontmatter"
    echo "6. Run 'hms' to deploy changes"
    echo ""
    echo "Archive old snapshots after confirming updates."
else
    echo "✗ Error: Failed to fetch content or empty response"
    exit 1
fi
