# Deployment Guide - SOW & Proposal Generation Solution

## Overview
This guide walks you through deploying the multi-agent Copilot Studio solution for automated SOW and proposal generation.

## Prerequisites

### Required Licenses
- Microsoft Copilot Studio license (per-user or capacity-based)
- Microsoft 365 E3/E5 or Business Premium
- Power Automate Premium (for SharePoint connectors)

### Required Permissions
- Copilot Studio environment administrator
- SharePoint site collection administrator (for document libraries)
- Power Platform administrator (for connector setup)

### Technical Requirements
- SharePoint Online with document libraries for SOWs and Proposals
- Power Automate environment
- Service account for SharePoint access

## Solution Package

This repository includes a pre-built Power Platform solution package that can be imported directly into your Copilot Studio environment. This is the recommended deployment method.

### Building the Solution Package
Run the packaging script from the repository root:

```bash
./package-solution.sh
```

This produces `SOWProposalGeneration_1_0_0_0.zip` containing all agents, topics, and Power Automate flow definitions.

### Importing the Solution
1. Navigate to [Copilot Studio](https://copilotstudio.microsoft.com)
2. Go to **Settings > Solutions** (or use the [Power Apps maker portal](https://make.powerapps.com) > Solutions)
3. Click **Import solution**
4. Upload `SOWProposalGeneration_1_0_0_0.zip`
5. When prompted, configure the required connections:
   - **SharePoint Online** - authenticate with your service account
   - **Word Online (Business)** - authenticate for document template population
6. Click **Import** and wait for the process to complete

### What the Solution Includes

| Component | Type | Description |
|-----------|------|-------------|
| SOW Proposal Orchestrator | Agent (Bot) | Master orchestrator that coordinates the full workflow |
| Document Research Agent | Agent (Bot) | Searches SharePoint for prior SOWs and proposals |
| Offerings and Capabilities Agent | Agent (Bot) | Matches client needs to organizational services |
| Document Generation Agent | Agent (Bot) | Generates polished SOW/Proposal documents |
| Generate SOW | Topic | Conversation flow for SOW creation |
| Generate Proposal | Topic | Conversation flow for Proposal creation |
| Greeting | Topic | Welcome message and capability overview |
| SharePoint-DocumentSearch | Cloud Flow | Power Automate flow for SharePoint document search |
| Generate-Word-Document | Cloud Flow | Power Automate flow for Word document generation |

### Post-Import Configuration
After importing the solution, complete these steps:

1. **Set the SharePoint site URL** - Edit both Power Automate flows and update the `SharePointSiteUrl` parameter to point to your SharePoint site
2. **Enable generative AI** - For each agent, go to Settings > Generative AI and enable it
3. **Publish each agent** - Agents are imported in draft state and must be published before use

Then proceed with the remaining deployment steps below for SharePoint setup, knowledge base configuration, and testing.

---

## Deployment Steps

### Step 1: Environment Setup

#### 1.1 Create Copilot Studio Environment
1. Navigate to [Copilot Studio](https://copilotstudio.microsoft.com)
2. Create a new environment or select existing
3. Name: `SOW-Proposal-Production`
4. Region: Select appropriate region for your organization
5. Security group: Assign appropriate security group
6. Import the solution package (see [Solution Package](#solution-package) above)

#### 1.2 Configure Generative AI
1. For each imported agent, navigate to Settings > Generative AI
2. Enable generative AI capabilities
3. Select the desired AI model from the built-in options provided by Copilot Studio
4. Configure content moderation settings as appropriate for your organization

### Step 2: SharePoint Configuration

#### 2.1 Create Document Libraries
Create the following SharePoint libraries:

```
Site: [Your SharePoint Site]
├── SOWs/
│   ├── Columns: Client, Date, Status, Services, Value
│   └── Views: Active SOWs, By Client, By Date
├── Proposals/
│   ├── Columns: Client, Date, Status, Services, Value
│   └── Views: Active Proposals, By Client, By Date
├── Templates/
│   ├── SOW-Template.docx
│   └── Proposal-Template.docx
└── Offerings-Database/
    └── ServicesCapabilities.xlsx
```

#### 2.2 Configure SharePoint Permissions
1. Create service account: `svc-copilot-docs@yourdomain.com`
2. Grant read access to SOWs, Proposals, Templates libraries
3. Grant read access to Offerings-Database
4. Document the account credentials securely

#### 2.3 Set Up Metadata
Add the following columns to SOWs and Proposals libraries:

| Column Name | Type | Required | Description |
|-------------|------|----------|-------------|
| Client | Text | Yes | Client organization name |
| ProjectName | Text | No | Name of the project |
| DocumentType | Choice | Yes | SOW or Proposal |
| Status | Choice | Yes | Draft, Submitted, Approved, Completed |
| Services | Multi-choice | No | Services included |
| Value | Currency | No | Project value |
| Industry | Choice | No | Client industry vertical |
| DateCreated | Date | Yes | Creation date |
| Keywords | Text | No | Searchable keywords |

### Step 3: Power Automate Flows

#### 3.1 SharePoint Search Flow
Create flow: `SharePoint-DocumentSearch`

**Trigger:** HTTP Request (called by agents)

**Actions:**
1. Parse JSON input
2. Search SharePoint (Get files from library)
3. Filter by criteria
4. Apply ranking algorithm
5. Return results as JSON

**Flow Template Location:** `/connectors/sharepoint-connector.json`

#### 3.2 Document Generation Flow
Create flow: `Generate-Word-Document`

**Trigger:** HTTP Request (called by Document Generation Agent)

**Actions:**
1. Receive document content JSON
2. Populate Word template
3. Apply formatting
4. Save to SharePoint
5. Return document URL

**Flow Template Location:** `/connectors/power-automate-flows.json`

### Step 4: Configure Copilot Studio Agents

> **Note:** If you imported the solution package, all agents and topics are already created. Follow the steps below to verify configuration and apply any customizations.

#### 4.1 Verify Master Orchestrator
1. Open the `SOW Proposal Orchestrator` agent in Copilot Studio
2. Verify the instructions are loaded (or paste from `/orchestrator/instructions.md`)
3. Enable generative AI in agent settings
4. Confirm the three subagent references are connected

#### 4.2 Verify Subagents

**Document Research Agent:**
1. Open the `Document Research Agent`
2. Verify instructions are loaded (or paste from `/subagents/document-research/instructions.md`)
3. Confirm connectors are configured:
   - SharePoint connector
   - Power Automate flow: `SharePoint-DocumentSearch`
4. Test connection

**Offerings & Capabilities Agent:**
1. Open the `Offerings Capabilities Agent`
2. Verify instructions are loaded (or paste from `/subagents/offerings-capabilities/instructions.md`)
3. Upload knowledge base:
   - Services catalog
   - Capabilities matrix
   - Pricing guidelines
4. Configure data sources

**Document Generation Agent:**
1. Open the `Document Generation Agent`
2. Verify instructions are loaded (or paste from `/subagents/document-generation/instructions.md`)
3. Confirm connectors are configured:
   - Power Automate flow: `Generate-Word-Document`
4. Test generation

#### 4.3 Verify Topics
1. Open the Master Orchestrator
2. Navigate to Topics > Manage topics
3. Verify the following topics exist and are enabled:
   - **Generate SOW** - Conversation flow for SOW creation
   - **Generate Proposal** - Conversation flow for Proposal creation
   - **Greeting** - Welcome message and capability overview
4. Each topic should already have actions configured to call the appropriate subagents
5. If topics are missing, recreate them using the definitions in `/solution/Topics/`

### Step 5: Knowledge Base Setup

#### 5.1 Upload Service Offerings
1. Navigate to Knowledge > Data sources
2. Add new source: SharePoint
3. Point to: `/Offerings-Database/ServicesCapabilities.xlsx`
4. Configure columns mapping
5. Enable auto-refresh (daily)

#### 5.2 Index Historical Documents
1. Add data source: SharePoint document library
2. Select: SOWs and Proposals libraries
3. Enable full-text indexing
4. Configure search ranking
5. Run initial indexing

### Step 6: Testing

#### 6.1 Unit Testing
Test each agent individually:

**Document Research Agent:**
```
Input: {
  "client_name": "Contoso Corporation",
  "document_type": "Proposal",
  "keywords": ["cloud", "Azure"]
}

Expected: Returns list of relevant documents
```

**Offerings & Capabilities Agent:**
```
Input: {
  "client_requirements": "Migrate to Azure cloud",
  "project_scope": "Infrastructure migration"
}

Expected: Returns matched services and pricing
```

**Document Generation Agent:**
```
Input: {
  "document_type": "SOW",
  "client_name": "Test Client",
  "capabilities_analysis": {...}
}

Expected: Generates complete SOW document
```

#### 6.2 Integration Testing
Test full workflow:

1. Provide meeting transcript to orchestrator
2. Verify orchestrator calls all subagents
3. Check data flow between agents
4. Verify document generation
5. Review output quality

#### 6.3 User Acceptance Testing
1. Create test scenarios with real data
2. Invite pilot users
3. Collect feedback
4. Iterate on prompts and configurations

### Step 7: Security & Compliance

#### 7.1 Access Controls
1. Configure role-based access:
   - Sales team: Can use orchestrator
   - Managers: Can approve outputs
   - IT admins: Full administrative access
2. Enable audit logging
3. Configure data loss prevention (DLP) policies

#### 7.2 Data Privacy
1. Review all agent instructions for compliance
2. Ensure no PII is logged unnecessarily
3. Configure data retention policies
4. Enable encryption at rest and in transit

#### 7.3 Compliance
1. Add legal disclaimers to generated documents
2. Configure approval workflows for high-value proposals
3. Enable version control
4. Set up archiving for historical documents

### Step 8: Monitoring & Maintenance

#### 8.1 Set Up Monitoring
1. Enable Copilot Studio analytics
2. Create Power BI dashboard for usage metrics
3. Configure alerts for errors
4. Track quality metrics:
   - Document generation success rate
   - Average response time
   - User satisfaction scores

#### 8.2 Maintenance Plan
- **Weekly:** Review error logs and user feedback
- **Monthly:** Update service offerings catalog
- **Quarterly:** Retrain agents with new successful documents
- **Annually:** Review and update legal terms and compliance

### Step 9: User Enablement

#### 9.1 Create User Documentation
1. Quick start guide
2. Video tutorials
3. FAQ document
4. Best practices guide

#### 9.2 Training Sessions
1. Schedule live training for sales team
2. Create on-demand training videos
3. Set up support channel (Teams/Slack)
4. Designate power users as champions

#### 9.3 Launch Communication
1. Announce solution availability
2. Share success criteria
3. Provide support contact information
4. Set expectations for quality and use cases

## Configuration Files

### Environment Variables
Create `.env` file (do not commit to source control):

```env
SHAREPOINT_SITE_URL=https://yourtenant.sharepoint.com/sites/YourSite
SHAREPOINT_CLIENT_ID=your-client-id
SHAREPOINT_CLIENT_SECRET=your-client-secret

POWER_AUTOMATE_SEARCH_FLOW=https://flow.microsoft.com/...
POWER_AUTOMATE_GENERATE_FLOW=https://flow.microsoft.com/...

COPILOT_STUDIO_ENV=production
```

### Connector Configuration
Import `/connectors/sharepoint-connector.json` for SharePoint integration
Import `/connectors/power-automate-flows.json` for automation workflows

## Troubleshooting

### Common Issues

**Agent not responding:**
- Check Copilot Studio service health
- Verify generative AI is enabled in agent settings
- Check network connectivity
- Review error logs in Copilot Studio

**SharePoint search returning no results:**
- Verify service account permissions
- Check SharePoint indexing status
- Validate search query syntax
- Ensure metadata is populated

**Document generation failing:**
- Check Power Automate flow status
- Verify Word template is accessible
- Review document size limits
- Check for special characters in content

**Quality issues with generated documents:**
- Review agent instructions for clarity
- Provide more context in prompts
- Update knowledge base with better examples
- Adjust temperature settings (lower = more consistent)

## Support & Resources

### Documentation
- Copilot Studio: https://docs.microsoft.com/copilot-studio
- Power Automate: https://docs.microsoft.com/power-automate
- SharePoint: https://docs.microsoft.com/sharepoint

### Support Contacts
- Technical Support: [your-support-email]
- Product Owner: [product-owner-email]
- Microsoft Support: https://support.microsoft.com

## Rollback Plan

If issues arise post-deployment:

1. **Immediate:** Disable orchestrator agent
2. **Communicate:** Notify users of temporary outage
3. **Investigate:** Review logs and identify issue
4. **Restore:** Revert to previous working version
5. **Fix:** Address issues in development environment
6. **Redeploy:** Test thoroughly before re-enabling

## Success Metrics

Track these KPIs post-deployment:

- **Adoption:** Number of documents generated per week
- **Efficiency:** Time saved vs. manual creation (target: 70% reduction)
- **Quality:** User satisfaction score (target: 4/5 or higher)
- **Accuracy:** Percentage of documents needing minimal edits (target: 80%)
- **Success Rate:** Percentage of generations that succeed (target: 95%)

## Next Steps

After successful deployment:

1. Gather user feedback
2. Iterate on agent instructions
3. Expand knowledge base
4. Add new document types (MSAs, addendums)
5. Integrate with CRM for automatic trigger
6. Implement advanced analytics

## Version History

- v1.0.0 (2024-02-15): Initial deployment guide
