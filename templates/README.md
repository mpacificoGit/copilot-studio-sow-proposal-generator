# Document Templates

This folder contains Word templates for generating SOWs and Proposals.

## Template Files

### SOW-Template.docx
Statement of Work template with the following sections:
- Cover Page
- Executive Summary
- Project Background
- Scope of Work
- Deliverables
- Timeline and Milestones
- Roles and Responsibilities
- Assumptions and Dependencies
- Acceptance Criteria
- Pricing and Payment Terms
- Terms and Conditions

### Proposal-Template.docx
Proposal template with the following sections:
- Cover Page
- Executive Summary
- Understanding of Requirements
- Proposed Solution
- Project Approach and Methodology
- Deliverables and Success Criteria
- Project Timeline
- Team and Qualifications
- Investment and Pricing
- Why Choose Us
- Case Studies and References
- Terms and Conditions
- Next Steps

## Template Variables

Templates use the following merge fields that are populated by the Document Generation Agent:

### Common Variables
- `{ClientName}` - Client organization name
- `{ProjectName}` - Project title
- `{DocumentType}` - SOW or Proposal
- `{Date}` - Document date
- `{Version}` - Document version
- `{Status}` - Draft, Final, etc.

### Content Variables
- `{ExecutiveSummary}` - Executive summary content
- `{Background}` - Project background
- `{Scope}` - Scope of work
- `{Deliverables}` - Deliverables list
- `{Timeline}` - Timeline and milestones
- `{Team}` - Team composition
- `{Pricing}` - Pricing details
- `{Terms}` - Terms and conditions

## Creating Templates

1. Open Word and create a new document
2. Design your layout with company branding
3. Insert merge fields using Word's Insert > Quick Parts > Field
4. Save as .docx in this folder
5. Upload to SharePoint `/Templates` library
6. Update the Power Automate flow to reference the template

## Template Guidelines

- Use consistent fonts: Calibri or Arial
- Use heading styles (Heading 1, 2, 3) for proper structure
- Include page numbers in footer
- Add company logo in header
- Use tables for structured data (deliverables, pricing)
- Include placeholders for all required sections
- Test templates with sample data before deploying

## Customization

Templates can be customized per:
- Client (create client-specific branding)
- Industry (add industry-specific sections)
- Service type (specialized templates for cloud, security, etc.)
- Document complexity (simple vs comprehensive versions)

## Maintenance

- Review templates quarterly for updates
- Update legal terms as needed
- Refresh branding elements with marketing
- Collect user feedback for improvements
- Version control templates in SharePoint
