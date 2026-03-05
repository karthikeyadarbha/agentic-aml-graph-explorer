# 👁️ Project Argus: Agentic GraphRAG for AML Investigation

Project Argus is an enterprise-grade Anti-Money Laundering (AML) solution that utilizes a **GraphRAG (Retrieval-Augmented Generation)** architecture. By transitioning from traditional, threshold-based alerts to proactive network analysis, Argus detects complex financial crime typologies—such as 3-hop and 4-hop circular loops—and leverages an embedded LLM to generate sovereign, auditable SAR narratives.

---

## 🚀 Key Differentiators

* **Proactive Graph Traversal:** Transforms flat transaction ledgers into a Directed Knowledge Graph to programmatically detect money laundering loops using recursive SQL and Snowpark.
* **Agentic Context Fusion (GraphRAG):** Combines **Structural Context** (deterministic transaction paths) with **Semantic Context** (unstructured negative news and KYC watchlists) to eliminate hallucinations and provide high-fidelity reasoning.
* **Sovereign AI boundary:** 100% of the data storage, graph processing, vector search, and LLM inference executes within the governed Snowflake perimeter. No sensitive PII ever exits to external APIs.

---

## 📐 Technical Architecture

The platform follows a Medallion Data Architecture integrated with a specialized Agentic Intelligence Layer:



### Data Flow
1.  **Ingestion:** Event-driven loading of transaction and KYC JSON payloads from **Amazon S3** via **Snowpipe**.
2.  **Medallion Pipeline:** * **Bronze:** Raw JSON extraction.
    * **Silver:** Harmonized, typed, and cleaned relational data.
    * **Gold (Knowledge Graph):** Entities (Nodes) and Transfers (Edges) modeled for graph traversal.
3.  **Pattern Detection:** Recursive SQL logic hunts for circular loop typologies (e.g., $A \rightarrow B \rightarrow C \rightarrow A$).
4.  **Hybrid Retrieval:**
    * **Lexical:** Snowflake Search Optimization Service for exact entity ID lookups.
    * **Semantic:** Cortex Search (Vector) for conceptual risk matching in news/KYC notes.
5.  **Adjudication:** Mistral-7b (via Cortex AI) synthesizes graph and semantic context to generate a **Bespoke SAR Justification**.
6.  **Presentation:** A Streamlit-in-Snowflake dashboard allows investigators to filter by risk and review AI-generated reports.

---

## 🛠️ Technology Stack

* **Cloud Infrastructure:** Amazon S3
* **Data Platform:** Snowflake (Snowpark, Cortex AI, Cortex Search)
* **Data Modeling:** dbt (Data Build Tool)
* **LLM Inference:** Mistral-7b (Native Snowflake Cortex)
* **UI/UX:** Streamlit (Python)

---

## 📁 Repository Structure

```text
project-argus/
├── dbt_models/             # dbt transformations
│   ├── bronze/             # Raw ingestion models
│   ├── silver/             # Cleaned relational data
│   └── gold/               # Graph Nodes, Edges, & Recursive Loop views
├── streamlit_app/          # Investigator Dashboard
│   └── dashboard.py        # Streamlit-in-Snowflake source
├── prompts/                # System prompts for Cortex AI adjudication
├── data_samples/           # Mock JSON payloads for testing
└── README.md

Setup & Deployment
Snowflake Setup: Ensure CORTEX_USER permissions are granted for COMPLETE and SEARCH functions.

dbt Configuration: Configure profiles.yml to point to your Snowflake warehouse. Run dbt build.

Search Optimization: Enable SOS on the GOLD.NODES table for high-performance retrieval.

Streamlit: Upload dashboard.py to a Streamlit-in-Snowflake stage and run.