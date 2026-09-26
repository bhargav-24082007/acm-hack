# MarketSphere (MochaTrade) Policy Engine - Project Explanation

## Overview
MarketSphere is an intelligent policy engine and Retrieval-Augmented Generation (RAG) application. It is designed to analyze, parse, and enforce financial regulatory policies across different jurisdictions. 

By leveraging local LLMs (via Ollama) and a robust vector search stack, the application ingests dense regulatory documents, extracts structured rules (like capital requirements or leverage caps), and provides a user-friendly interface to query compliance metrics.

---

## Architecture Flowchart

Below is the high-level architecture diagram showing how the system components interact:

```mermaid
flowchart TD
    %% User and UI
    User([User / Mentor]) <--> UI[Frontend Interface\n(Vanilla JS, HTML/CSS)]
    
    %% API Gateway
    UI <--> API[FastAPI Backend\nmain.py, routers]
    
    %% Backend Services Layer
    subgraph Backend [Backend Services]
        API --> SVC_RAG[RAG Services\nretriever.py, parser.py]
        API --> SVC_DB[Data Services\nsource_service.py]
        API --> SVC_EXTRACT[LLM Services\nextractor.py, evaluator.py]
    end
    
    %% External / Local Tools
    subgraph AI Engine
        SVC_EXTRACT <--> OLLAMA[Ollama\nLocal LLM: llama3.2]
        SVC_RAG <--> OLLAMA
    end
    
    %% Databases
    subgraph Data Stores
        SVC_RAG <--> CHROMA[(ChromaDB\nVector Storage)]
        SVC_RAG <--> MINIO[(MinIO\nObject Storage)]
        SVC_DB <--> PGSQL[(PostgreSQL / SQLite\nRelational DB)]
    end
    
    %% Data flow indications
    MINIO -. "Raw Policy Documents" .-> SVC_RAG
    CHROMA -. "Document Embeddings" .-> SVC_RAG
    PGSQL -. "Metadata & Rules" .-> SVC_DB
```

---

## Folder Structure & Key Components

Here is a breakdown of the critical directories in the project:

### 1. `frontend/`
- Contains the static presentation layer (`index.html`, `app.js`, `analyzer.js`, `style.css`).
- Served directly by the FastAPI backend, turning the project into a single-server deployment.

### 2. `core/` & `services/` (The Brain)
- **`core/`**: Houses the infrastructure wrappers. Includes `chunker.py` (breaks text into manageable tokens for the AI), `uploader.py` (handles MinIO S3 logic), `database.py` (SQL alchemy setup), and `embeddings.py`.
- **`services/`**: The business logic. Contains `rule_analyzer.py`, `extractor.py`, and `country_compliance.py`. This is where raw text gets transformed into structured compliance rules using the LLM.

### 3. `data/`
- Contains the raw assets, specifically `regulatory_policies` (which holds real-world txt files from authorities like the CFTC, FCA, ASIC).
- Includes the `extracted_15_countries_rules.json` file, demonstrating the output of the LLM extracting structured data from the raw policies.

### 4. `docker-compose.yml` & `config.py`
- **Docker Compose**: Orchestrates the heavy dependencies—MinIO (mock S3), ChromaDB (Vector DB), PostgreSQL (Data), and Ollama (Local AI Engine).
- **`config.py`**: Centralizes environment variables, mapping out the connection strings and tuning the RAG engine (e.g., `chunk_size = 1000`, `retrieval_k = 5`).

---

## What to Mention to Your Mentor

When presenting this project, hit these **key talking points** to demonstrate a strong grasp of modern AI engineering:

1. **Privacy-First Local AI**:
   - Emphasize that the project uses **Ollama** (`llama3.2:3b`). By running the model locally, sensitive financial compliance data never leaves the organization's network. This is a massive selling point in FinTech.

2. **Advanced RAG (Retrieval-Augmented Generation)**:
   - Point out that the system doesn't just ask an LLM questions blindly. It uses **ChromaDB** to find relevant sections of policy documents and feeds those specific chunks into the LLM context. 
   - You can highlight the use of the `sentence-transformers/all-MiniLM-L6-v2` tokenizer defined in `config.py` to create embeddings.

3. **Robust Data Infrastructure (Separation of Concerns)**:
   - Explain how the data layer is architected like an enterprise system:
     - **MinIO (S3)** holds the raw, unstructured `.txt` or `.pdf` regulatory documents.
     - **ChromaDB** holds the semantic vector embeddings.
     - **PostgreSQL / SQLite** holds the highly structured relational metadata (e.g., country tables, leverage caps).

4. **Practical Automation**:
   - Show how the AI actually extracts structured parameters (like 1:50 leverage caps for the US CFTC) out of dense legal jargon. This turns manual compliance auditing into an automated, scalable pipeline. 
   - Mention the `run-demo.bat` file, which proves the application is containerized, repeatable, and easily deployable for a local showcase.
