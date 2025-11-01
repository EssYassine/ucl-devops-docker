# 🤖 Local AI Chat Interface (LibreChat + Ollama + Context7 MCP)

This project sets up a **local ChatGPT-like interface** using Docker. Everything runs **locally** — no cloud services, no API keys, just local AI.

&nbsp;

## 🧩 Components

- **LibreChat**: Web interface for chatting with AI models  
- **Ollama**: Local LLM backend running the `qwen2.5:3b` model  
- **Context7 MCP**: Local integration layer for memory and context handling

&nbsp;

## 🏗️ Architecture

```scss
                   ┌─────────────────────────┐
                   │       Web Browser       │
                   │ (http://localhost:3080) |
                   └────────────┬────────────┘
                                │
                                	            ▼
                      ┌────────────────────┐
                      │     LibreChat      │
                      │ (Frontend + API)   │
                      └─────────┬──────────┘
                                │
                                |
            ┌─────────────────────────────────────┐
                  ▼                                     		   ▼
  ┌────────────────────┐               ┌────────────────────┐
  │       Ollama       │               │   Context7 MCP     │
  │ (qwen2.5:3b model) │               │ (local integration)│
  └────────────────────┘               └────────────────────┘
```


All components run in isolated Docker containers connected via the same network.

&nbsp;

## ⚙️ Setup

**1. Clone the repository and navigate to the directory**
```bash
git clone https://github.com/<yourusername>/8-ai.git
cd 8-ai
```

**2. Run the setup script**
```bash
bash setup.sh
```
The script will:

- Start all Docker services

- Pull the ```qwen2.5:3b``` model

- Configure LibreChat to use Ollama

- Start Context7 MCP integration

&nbsp;

## ⚙️ Access the Interface

Once setup completes:
👉 Open http://localhost:3080

You’ll see the LibreChat interface — select the `qwen2.5:3b` model and start chatting locally.

&nbsp;

## ✅ Verification Steps

**1. Confirm everything works:**

```bash
docker ps        # should show librechat, ollama, and context7 containers
curl http://localhost:11434/api/tags   # should list qwen2.5:3b model
```
you should see containers for:

- `librechat`
- `ollama`
- `context7`

Confirm the model is available:

```bash
curl http://localhost:11434/api/tags
```

→ should list `qwen2.5:3b`

**2. Visit** http://localhost:3080.

**3. Try chatting** — responses should come from the local Qwen model (`qwen2.5:3b`).

&nbsp;

## 🧩 Troubleshooting

| Problem                    | Possible Fix                                             |
| -------------------------- | -------------------------------------------------------- |
| LibreChat not loading      | Check if port 3080 is free                               |
| Ollama model not found     | Run `ollama pull qwen2.5:3b`                             |
| Context7 integration fails | Ensure container name matches in `docker-compose.yml`    |
| Model slow to respond      | The first generation may take time while the model loads |

&nbsp;

## 🧩 Troubleshooting

```bash
.
├── docker-compose.yml   # Docker setup for all components
├── librechat/           # LibreChat configuration files
│   └── config/
├── setup.sh             # One-step installation and startup script
└── README.md            # Documentation
```

&nbsp;

## 📚 What You’ll Learn

- Running **multi-container AI applications**

- Integrating **local AI models** via Docker

- Managing **service dependencies** and environment configuration

- Building **production-ready setup scripts and docs**

✅ Once everything is running, you’ll have your own private, local ChatGPT-like system — fast, secure, and fully offline!
