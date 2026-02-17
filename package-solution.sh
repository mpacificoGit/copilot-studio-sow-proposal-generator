#!/bin/bash
#
# Package the Copilot Studio solution into an importable ZIP file.
#
# Usage:
#   ./package-solution.sh
#
# Output:
#   SOWProposalGeneration_1_0_0_0.zip in the project root directory.
#
# This ZIP can be imported into a Power Platform environment via:
#   1. Copilot Studio > Settings > Solutions > Import solution
#   2. Power Platform Admin Center > Solutions > Import
#   3. Power Apps maker portal (make.powerapps.com) > Solutions > Import
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOLUTION_DIR="${SCRIPT_DIR}/solution"
OUTPUT_FILE="${SCRIPT_DIR}/SOWProposalGeneration_1_0_0_0.zip"

# Verify solution directory exists
if [ ! -d "${SOLUTION_DIR}" ]; then
  echo "Error: solution/ directory not found at ${SOLUTION_DIR}"
  exit 1
fi

# Verify required files exist
REQUIRED_FILES=(
  "[Content_Types].xml"
  "solution.xml"
  "customizations.xml"
  "botcomponents/sowprop_SOWProposalOrchestrator.json"
  "botcomponents/sowprop_DocumentResearchAgent.json"
  "botcomponents/sowprop_OfferingsCapabilitiesAgent.json"
  "botcomponents/sowprop_DocumentGenerationAgent.json"
  "Topics/sowprop_GenerateSOW.json"
  "Topics/sowprop_GenerateProposal.json"
  "Topics/sowprop_Greeting.json"
  "Workflows/SharePoint-DocumentSearch.json"
  "Workflows/Generate-Word-Document.json"
)

echo "Verifying solution files..."
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "${SOLUTION_DIR}/${file}" ]; then
    echo "Error: Required file missing: ${file}"
    exit 1
  fi
done
echo "All required files present."

# Remove old ZIP if it exists
if [ -f "${OUTPUT_FILE}" ]; then
  rm "${OUTPUT_FILE}"
  echo "Removed previous package."
fi

# Create the solution ZIP
echo "Packaging solution..."
cd "${SOLUTION_DIR}"
zip -r "${OUTPUT_FILE}" \
  "[Content_Types].xml" \
  solution.xml \
  customizations.xml \
  botcomponents/ \
  Topics/ \
  Workflows/

echo ""
echo "Solution packaged successfully: ${OUTPUT_FILE}"
echo ""
echo "To import into Copilot Studio:"
echo "  1. Go to https://copilotstudio.microsoft.com"
echo "  2. Navigate to Settings > Solutions"
echo "  3. Click 'Import solution'"
echo "  4. Upload SOWProposalGeneration_1_0_0_0.zip"
echo "  5. Follow the prompts to configure connections (SharePoint, Word Online)"
echo ""
echo "After import, you will need to:"
echo "  - Configure the SharePointSiteUrl parameter in both Power Automate flows"
echo "  - Set up SharePoint and Word Online connector authentication"
echo "  - Upload your Word templates to /Templates/ in SharePoint"
echo "  - Enable generative AI on each agent under Settings > Generative AI"
echo "  - Publish each agent"
