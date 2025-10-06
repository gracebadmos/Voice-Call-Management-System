# AI Lead Qualification & Consultation Booking Workflow

An n8n workflow template for automating lead qualification, consultation booking, and follow-up communications using AI agents, Gmail, and Google Calendar.

## 🎯 **Workflow Features:**

This template includes:

- ✅ **AI-Powered Lead Qualification** - Automatically qualifies leads based on conversation
- ✅ **Multi-Channel Response** - Text + Audio (TTS) responses
- ✅ **Smart Calendar Booking** - Auto-schedules consultations for high-quality leads
- ✅ **Email Automation** - Sends confirmations and follow-ups
- ✅ **Structured Output** - Captures lead quality, urgency, and next actions
- ✅ **Gmail Integration** - Full email management (send, draft, reply, search)
- ✅ **Calendar Management** - Create, update, check availability
- ✅ **Think Tool** - AI analyzes complex queries step-by-step

---

## 📋 **Setup Instructions:**

After importing this workflow, you need to:

### 1. **Create Credentials:**
   - **OpenRouter Account** - Get API key from https://openrouter.ai/
   - **Gmail OAuth2** - Connect your Gmail account
   - **Google Calendar OAuth2** - Connect your Google Calendar account
   - **OpenAI API** (for text-to-speech) - Get API key from https://platform.openai.com/

### 2. **Update the AI Agent Prompt:**
   - Replace `[YOUR_NAME]` with your actual name
   - Update business types to match your target industries
   - Customize the automation examples for your services

### 3. **Configure Gmail Tools:**
   - All Gmail tool nodes will automatically use your connected Gmail credential
   - The email address in the "CreateEvent" node calendar field will need to match your Gmail

### 4. **Configure TTS Node (Eleven Labs TTS):**
   - Add your OpenAI API key in the Authorization header
   - Or optionally replace with Eleven Labs if you prefer their service

### 5. **Test the Workflow:**
   - Activate the workflow
   - Use the chat trigger to test conversations
   - Verify calendar events are created correctly
   - Check that emails are sent properly

---

## 🔧 **Technical Details:**

**Nodes Included:**
- AI Agent (with structured output parser)
- OpenRouter Chat Model (Claude 3.5 Sonnet)
- Chat Trigger (webhook-based)
- Split in Batches (for parallel text/audio processing)
- HTTP Request (OpenAI TTS)
- Merge (combines responses)
- IF node (qualification routing)
- Gmail Tools (5 nodes: Send, Draft, Reply, Get, Search)
- Google Calendar Tools (5 nodes: Create, Get, Update, Check Availability, Get Many)
- Think Tool (reasoning enhancement)
- Respond to Webhook

**Lead Qualification Categories:**
- High, Medium, Low
- Urgency: Urgent, Moderate, Low
- Next Actions: book_consultation, send_resources, nurture

---

## 💡 **Customization Tips:**

### 1. **Adjust Lead Qualification Logic:**
   - Modify the structured output schema to track additional fields
   - Update the IF node conditions for different qualification criteria

### 2. **Enhance the AI Prompt:**
   - Add industry-specific terminology
   - Include pricing information
   - Add qualification questions specific to your services

### 3. **Add More Tools:**
   - CRM integration (HubSpot, Salesforce)
   - SMS notifications (Twilio)
   - Slack notifications for new leads

### 4. **Customize TTS:**
   - Change voice in the OpenAI TTS request
   - Adjust speech speed/format
   - Or switch to Eleven Labs for more voice options

---

## 📥 **Installation:**

1. Download the `workflow.json` file from this repository
2. In your n8n instance, go to **Workflows** → **Import from File**
3. Select the downloaded JSON file
4. Follow the setup instructions above
5. Activate and test!

---

## 🚀 **Ready to Use!**

This workflow is production-ready and can be customized for various industries including:
- HVAC services
- Legal practices
- Real estate agencies
- Consulting businesses
- Any service-based business needing lead qualification

---

## 📞 **Support:**

For questions or issues with this workflow template, please open an issue in this repository.

---

## 📄 **License:**

Feel free to use and modify this workflow for your business needs.
