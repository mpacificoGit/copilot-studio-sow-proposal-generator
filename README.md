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

## Deployment
See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed setup instructions.

## Project Structure
```
├── README.md
├── DEPLOYMENT.md
├── orchestrator/
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
├── connectors/
│   ├── sharepoint-connector.json
│   └── power-automate-flows.json
└── templates/
    ├── sow-template.docx
    └── proposal-template.docx
```

## License
MIT License
