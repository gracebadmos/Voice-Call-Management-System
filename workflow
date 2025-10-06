{
  "name": "AI Lead Qualification & Consultation Booking",
  "nodes": [
    {
      "parameters": {
        "promptType": "define",
        "text": "=You are [YOUR_NAME]'s AI automation consultant assistant. You help local businesses (HVAC, legal, real estate, etc.) understand how AI agents can solve their problems.\n\nCurrent date and time: {{ new Date().toISOString() }}\n\nYour role:\n- Ask about their business type and main pain points\n- Provide specific automation examples for their industry  \n- Qualify leads for consultation booking\n- Be professional but conversational\n- Always use the Think tool before complex responses\n\nCurrent conversation: {{ $json.chatInput }}\n\nInstructions:\n1. First, use the Think tool to analyze what the user needs\n2. Respond with relevant automation examples for their business\n3. Ask qualifying questions about budget, timeline, and urgency\n4. For high-value leads (enterprise, urgent needs, good budget), suggest booking consultation\n5. For others, offer resources and nurture relationship\n\nAvailable MCP Tools:\n- Gmail: send_email, create_draft, get_emails, reply_email\n- Calendar: create_event, get_events, check_availability, update_event\n\nFor HIGH quality leads with nextAction 'book_consultation':\n1. Use create_event to schedule consultation (2 days from now, 1 hour duration)\n2. Use send_email to send professional confirmation\n3. Include client name, business type, and consultation details",
        "hasOutputParser": true,
        "options": {}
      },
      "type": "@n8n/n8n-nodes-langchain.agent",
      "typeVersion": 2.2,
      "position": [-1200, 96],
      "id": "7a1e5b0f-211b-4f60-89ec-35103724135e",
      "name": "AI Agent"
    },
    {
      "parameters": {
        "model": "anthropic/claude-3.5-sonnet",
        "options": {}
      },
      "type": "@n8n/n8n-nodes-langchain.lmChatOpenRouter",
      "typeVersion": 1,
      "position": [-1840, 320],
      "id": "d309ab7a-0e00-4f15-9423-c21c62810cb7",
      "name": "OpenRouter Chat Model",
      "credentials": {
        "openRouterApi": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "OpenRouter account"
        }
      }
    },
    {
      "parameters": {
        "batchSize": 2,
        "options": {}
      },
      "type": "n8n-nodes-base.splitInBatches",
      "typeVersion": 3,
      "position": [-880, 96],
      "id": "2dc1b413-89af-407c-bf2d-77dee19ad6ff",
      "name": "Split Text & Audio"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "480614c7-a150-444d-8d9e-0261b513eb47",
              "name": "response",
              "value": "={{ $json.output }}",
              "type": "string"
            },
            {
              "id": "5def972e-b207-49e4-9b0c-788e89a47410",
              "name": "responseType",
              "value": "text",
              "type": "string"
            },
            {
              "id": "e1497979-5a9e-4126-a75d-c419beba3531",
              "name": "timestamp",
              "value": "={{ new Date().toISOString() }}",
              "type": "string"
            }
          ]
        },
        "options": {}
      },
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.4,
      "position": [-656, -80],
      "id": "81076e28-a550-4f3f-b1c5-330dede07814",
      "name": "Format Text Response"
    },
    {
      "parameters": {
        "method": "POST",
        "url": "https://api.openai.com/v1/audio/speech",
        "sendHeaders": true,
        "headerParameters": {
          "parameters": [
            {
              "name": "Authorization",
              "value": "Bearer YOUR_OPENAI_API_KEY_HERE"
            }
          ]
        },
        "sendBody": true,
        "specifyBody": "json",
        "jsonBody": "={\n  \"model\": \"tts-1\",\n  \"input\": \"{{ $json.output }}\",\n  \"voice\": \"alloy\",\n  \"response_format\": \"mp3\"\n}",
        "options": {}
      },
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.2,
      "position": [-640, 112],
      "id": "62d8dfec-f2d1-442b-9066-3f2dd708b8a5",
      "name": "Eleven Labs TTS"
    },
    {
      "parameters": {},
      "type": "n8n-nodes-base.merge",
      "typeVersion": 3.2,
      "position": [-448, 112],
      "id": "2445d2ea-925d-420c-9b83-3c7726fd9c91",
      "name": "Combine Text + Audio"
    },
    {
      "parameters": {
        "conditions": {
          "options": {
            "caseSensitive": true,
            "leftValue": "",
            "typeValidation": "strict",
            "version": 2
          },
          "conditions": [
            {
              "id": "1dae42e2-7d5c-403d-a1fa-84075745d424",
              "leftValue": "={{ $json.nextAction }}",
              "rightValue": "book_consultation",
              "operator": {
                "type": "string",
                "operation": "notEquals"
              }
            }
          ],
          "combinator": "or"
        },
        "options": {}
      },
      "type": "n8n-nodes-base.if",
      "typeVersion": 2.2,
      "position": [-288, 112],
      "id": "461cdb27-cff6-49e3-ae34-fc7b0d932952",
      "name": "Qualification Check"
    },
    {
      "parameters": {
        "description": "Use this tool to think through complex problems step by step before responding"
      },
      "type": "@n8n/n8n-nodes-langchain.toolThink",
      "typeVersion": 1.1,
      "position": [-1712, 320],
      "id": "ed766b20-c033-4054-8272-cefd4b3e4ebb",
      "name": "Think"
    },
    {
      "parameters": {
        "options": {}
      },
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1.4,
      "position": [-16, 112],
      "id": "913f9753-a6fb-4ec3-983f-dee2b8052db9",
      "name": "Respond to Webhook"
    },
    {
      "parameters": {
        "schemaType": "manual",
        "inputSchema": "{\n  \"type\": \"object\",\n  \"properties\": {\n    \"response\": {\n      \"type\": \"string\"\n    },\n    \"leadQuality\": {\n      \"type\": \"string\", \n      \"enum\": [\"high\", \"medium\", \"low\"]\n    },\n    \"businessType\": {\n      \"type\": \"string\"\n    },\n    \"urgency\": {\n      \"type\": \"string\", \n      \"enum\": [\"urgent\", \"moderate\", \"low\"]\n    },\n    \"nextAction\": {\n      \"type\": \"string\", \n      \"enum\": [\"book_consultation\", \"send_resources\", \"nurture\"]\n    }\n  }\n}"
      },
      "type": "@n8n/n8n-nodes-langchain.outputParserStructured",
      "typeVersion": 1.3,
      "position": [-432, 320],
      "id": "235dcad2-aaa7-429a-8351-0477fe4ae9a1",
      "name": "Structured Output Parser"
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Creates a new event on the primary Google Calendar. Requires 'Start' time, 'End' time. Optionally accepts 'Attendees' (email list) and 'Summary' (Meeting Title) and 'Description'.\n\nExpects 'Start' and 'End' times as ISO 8601 strings with timezone offsets (e.g., YYYY-MM-DDTHH:MM:SSZ or YYYY-MM-DDTHH:MM:SS+HH:MM).",
        "calendar": {
          "__rl": true,
          "value": "YOUR_EMAIL_HERE",
          "mode": "id"
        },
        "start": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Start', ``, 'string') }}",
        "end": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('End', ``, 'string') }}",
        "additionalFields": {
          "attendees": [
            "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Attendees', ``, 'string') }}"
          ],
          "description": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Description', ``, 'string') }}",
          "summary": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Summary', ``, 'string') }}"
        }
      },
      "type": "n8n-nodes-base.googleCalendarTool",
      "typeVersion": 1.3,
      "position": [-1584, 320],
      "id": "109f9561-7a19-4052-8b90-d1b2e1fff49f",
      "name": "CreateEvent",
      "credentials": {
        "googleCalendarOAuth2Api": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Google Calendar account"
        }
      }
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Retrieves details for a specific event from the Google Calendar. Requires the unique 'Event_ID'.",
        "operation": "get",
        "calendar": {
          "__rl": true,
          "value": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Calendar', ``, 'string') }}",
          "mode": "id",
          "__regex": "(^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*)"
        },
        "eventId": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Event_ID', ``, 'string') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.googleCalendarTool",
      "typeVersion": 1.3,
      "position": [-1456, 320],
      "id": "2ec73846-e7f2-491b-9e48-b796e0c4dcf8",
      "name": "GetEvent",
      "credentials": {
        "googleCalendarOAuth2Api": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Google Calendar account"
        }
      }
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Updates an existing event on the Google Calendar. Requires the 'Event_ID' of the event to update, along with the new field values (e.g., 'Description', 'Location', times, attendees).",
        "operation": "update",
        "calendar": {
          "__rl": true,
          "value": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Calendar', ``, 'string') }}",
          "mode": "id",
          "__regex": "(^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*)"
        },
        "eventId": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Event_ID', ``, 'string') }}",
        "updateFields": {
          "attendeesUi": {
            "values": {
              "attendees": []
            }
          },
          "description": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Description', ``, 'string') }}",
          "location": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Location', ``, 'string') }}"
        }
      },
      "type": "n8n-nodes-base.googleCalendarTool",
      "typeVersion": 1.3,
      "position": [-1328, 320],
      "id": "ad98b8e1-3dfa-4222-9330-8f3ad672ddf9",
      "name": "UpdateEvent",
      "credentials": {
        "googleCalendarOAuth2Api": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Google Calendar account"
        }
      }
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Checks the free/busy status for the primary Google Calendar within a given time window. Requires 'Start_Time' and 'End_Time' to define the query range.",
        "resource": "calendar",
        "calendar": {
          "__rl": true,
          "value": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Calendar', ``, 'string') }}",
          "mode": "id",
          "__regex": "(^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*)"
        },
        "timeMin": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Start_Time', ``, 'string') }}",
        "timeMax": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('End_Time', ``, 'string') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.googleCalendarTool",
      "typeVersion": 1.3,
      "position": [-1200, 320],
      "id": "a2ecfedf-1ae0-463e-ae6f-9b25219f5e83",
      "name": "getAvailability",
      "credentials": {
        "googleCalendarOAuth2Api": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Google Calendar account"
        }
      }
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Creates a draft email in the connected Gmail account. It does NOT send the email, only saves it as a draft. Requires 'Subject' and 'Message' body",
        "resource": "draft",
        "subject": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Subject', ``, 'string') }}",
        "emailType": "html",
        "message": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Message', ``, 'string') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.gmailTool",
      "typeVersion": 2.1,
      "position": [-1072, 320],
      "id": "fa567621-4b4d-4a7f-a95d-1955373e978f",
      "name": "Create Draft",
      "webhookId": "WEBHOOK_ID_PLACEHOLDER",
      "credentials": {
        "gmailOAuth2": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Gmail account"
        }
      }
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Replies to a specific existing email thread in Gmail. Requires the 'Message_ID' of the thread to reply to, and the 'Message' body for the reply",
        "operation": "reply",
        "messageId": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Message_ID', ``, 'string') }}",
        "message": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Message', ``, 'string') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.gmailTool",
      "typeVersion": 2.1,
      "position": [-944, 320],
      "id": "d6807934-1225-4a0f-8ebb-ef3f49ea599f",
      "name": "Reply Email",
      "webhookId": "WEBHOOK_ID_PLACEHOLDER",
      "credentials": {
        "gmailOAuth2": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Gmail account"
        }
      }
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Retrieves emails from the connected Gmail account. Allows filtering to find specific emails based on various criteria. Available optional filters:\n*   `Search` (string): General search query matching keywords in subject, body, or sender (uses Gmail's standard search syntax like 'from:sender@example.com subject:urgent').\n*   `Sender` (string): Filter for emails specifically FROM this email address.\n*   `Received_After` (string): Only retrieve emails received AFTER this date or date/time (e.g., '2024-04-10', '2024-04-10T10:00:00Z').\n*   `Received_Before` (string): Only retrieve emails received BEFORE this date or date/time (e.g., '2024-04-11', '2024-04-10T18:30:00Z').\nSpecify `Return_All` (boolean) as true to fetch all matching emails, otherwise a default limit applies. If no filters are provided, it retrieves recent emails.",
        "operation": "getAll",
        "returnAll": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Return_All', ``, 'boolean') }}",
        "filters": {
          "q": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Search', ``, 'string') }}",
          "receivedAfter": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Received_After', ``, 'string') }}",
          "receivedBefore": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Received_Before', ``, 'string') }}",
          "sender": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Sender', ``, 'string') }}"
        }
      },
      "type": "n8n-nodes-base.gmailTool",
      "typeVersion": 2.1,
      "position": [-816, 320],
      "id": "c19a5601-d556-4cda-b5ac-a56f4002a4ba",
      "name": "Get Emails",
      "webhookId": "WEBHOOK_ID_PLACEHOLDER",
      "credentials": {
        "gmailOAuth2": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Gmail account"
        }
      }
    },
    {
      "parameters": {
        "options": {}
      },
      "type": "@n8n/n8n-nodes-langchain.chatTrigger",
      "typeVersion": 1.3,
      "position": [-1456, 96],
      "id": "95ad5f9b-124b-42b8-8a22-b4257180a402",
      "name": "When chat message received",
      "webhookId": "WEBHOOK_ID_PLACEHOLDER"
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Retrieves a list of events from the primary Google Calendar occurring within a specified time window. Requires 'Start_Time' (After) and 'End_Time' (Before). Can optionally 'Return_All' events in the range.",
        "operation": "getAll",
        "calendar": {
          "__rl": true,
          "value": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Calendar', ``, 'string') }}",
          "mode": "id",
          "__regex": "(^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*)"
        },
        "returnAll": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Return_All', ``, 'boolean') }}",
        "timeMin": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('After', ``, 'string') }}",
        "timeMax": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Before', ``, 'string') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.googleCalendarTool",
      "typeVersion": 1.3,
      "position": [-688, 320],
      "id": "b7dfe973-3ba9-4451-ac45-c46cb25dcb99",
      "name": "getManyEvent",
      "credentials": {
        "googleCalendarOAuth2Api": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Google Calendar account"
        }
      }
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Sends a new email using the connected Gmail account. Requires the recipient ('To'), 'Subject', and 'Message' body.",
        "sendTo": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('To', ``, 'string') }}",
        "subject": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Subject', ``, 'string') }}",
        "message": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Message', ``, 'string') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.gmailTool",
      "typeVersion": 2.1,
      "position": [-560, 320],
      "id": "0179f4f4-1b84-40ed-90b3-dccfd009d07b",
      "name": "Send Email",
      "webhookId": "WEBHOOK_ID_PLACEHOLDER",
      "credentials": {
        "gmailOAuth2": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Gmail account"
        }
      }
    }
  ],
  "connections": {
    "OpenRouter Chat Model": {
      "ai_languageModel": [
        [
          {
            "node": "AI Agent",
            "type": "ai_languageModel",
            "index": 0
          }
        ]
      ]
    },
    "AI Agent": {
      "main": [
        [
          {
            "node": "Split Text & Audio",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Split Text & Audio": {
      "main": [
        [
          {
            "node": "Format Text Response",
            "type": "main",
            "index": 0
          }
        ],
        [
          {
            "node": "Eleven Labs TTS",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Format Text Response": {
      "main": [
        [
          {
            "node": "Combine Text + Audio",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Eleven Labs TTS": {
      "main": [
        [
          {
            "node": "Combine Text + Audio",
            "type": "main",
            "index": 1
          }
        ]
      ]
    },
    "Combine Text + Audio": {
      "main": [
        [
          {
            "node": "Qualification Check",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Think": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "Qualification Check": {
      "main": [
        [
          {
            "node": "Respond to Webhook",
            "type": "main",
            "index": 0
          }
        ],
        [
          {
            "node": "Respond to Webhook",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Structured Output Parser": {
      "ai_outputParser": [
        [
          {
            "node": "AI Agent",
            "type": "ai_outputParser",
            "index": 0
          }
        ]
      ]
    },
    "CreateEvent": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "GetEvent": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "UpdateEvent": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "getAvailability": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "Create Draft": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "Reply Email": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "Get Emails": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "When chat message received": {
      "main": [
        [
          {
            "node": "AI Agent",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "getManyEvent": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    },
    "Send Email": {
      "ai_tool": [
        [
          {
            "node": "AI Agent",
            "type": "ai_tool",
            "index": 0
          }
        ]
      ]
    }
  },
  "settings": {
    "executionOrder": "v1"
  },
  "pinData": {}
}
