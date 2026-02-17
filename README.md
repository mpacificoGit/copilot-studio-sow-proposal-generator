# SOW & Proposal Generation - Copilot Studio Solution

## Overview
This Copilot Studio solution automates the generation of Statements of Work (SOWs) and Proposals from meeting transcripts and notes. The solution uses a multi-agent architecture with one master orchestrator and three specialized subagents.

## Architecture

### Master Orchestrator Agent
The main orchestrator manages the entire workflow:
- Gathers user inputs (meeting transcripts, notes, document type)
- Routes requests to appropriate subagents
- Coordinates data flow between agents
- Compiles final output for the user

### Subagents

1. **Document Research Agent**
   - Connects to SharePoint sites and libraries
   - Searches and retrieves prior SOWs and proposals
   - Extracts relevant patterns, structures, and content
   - Provides templates and examples to other agents

2. **Offerings & Capabilities Agent**
   - Reasons over company offerings and capabilities
   - Matches client needs to available services
   - Provides recommendations for scope and deliverables
   - Ensures alignment with organizational capabilities

3. **Document Generation Agent**
   - Creates structured SOW or proposal documents
   - Applies formatting and branding standards
   - Integrates content from research and offerings agents
   - Generates final polished output

## Use Cases
- Generate SOWs from meeting transcripts
- Create proposals based on client discussions
- Standardize document formatting across the organization
- Leverage historical knowledge from past engagements

## Prerequisites
- Microsoft Copilot Studio license
- SharePoint access for document repositories
- Power Automate for SharePoint integration

## Quick Start
1. Run `./package-solution.sh` to build the importable solution ZIP
2. Import `SOWProposalGeneration_1_0_0_0.zip` into your Copilot Studio environment via Settings > Solutions
3. Configure SharePoint connections and enable generative AI on each agent
4. See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed setup instructions

## Project Structure
```
├── README.md
├── DEPLOYMENT.md
├── package-solution.sh              # Builds importable solution ZIP
├── solution/                         # Power Platform solution (importable)
│   ├── [Content_Types].xml
│   ├── solution.xml                  # Solution manifest
│   ├── customizations.xml            # Component references
│   ├── botcomponents/                # Agent definitions
│   │   ├── sowprop_SOWProposalOrchestrator.json
│   │   ├── sowprop_DocumentResearchAgent.json
│   │   ├── sowprop_OfferingsCapabilitiesAgent.json
│   │   └── sowprop_DocumentGenerationAgent.json
│   ├── Topics/                       # Conversation topics
│   │   ├── sowprop_GenerateSOW.json
│   │   ├── sowprop_GenerateProposal.json
│   │   └── sowprop_Greeting.json
│   └── Workflows/                    # Power Automate cloud flows
│       ├── SharePoint-DocumentSearch.json
│       └── Generate-Word-Document.json
├── orchestrator/                     # Agent design docs
│   ├── orchestrator-agent.yaml
│   └── instructions.md
├── subagents/
│   ├── document-research/
│   │   ├── agent.yaml
│   │   └── instructions.md
│   ├── offerings-capabilities/
│   │   ├── agent.yaml
│   │   └── instructions.md
│   └── document-generation/
│       ├── agent.yaml
│       └── instructions.md
├── connectors/                       # Flow reference schemas
│   ├── sharepoint-connector.json
│   └── power-automate-flows.json
└── templates/
    ├── sow-template.docx
    └── proposal-template.docx
```

## License
MIT License
