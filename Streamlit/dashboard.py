import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

# Set page config for a professional "Project Argus" look
st.set_page_config(page_title="Project Argus | AML AI Investigator", layout="wide")

st.title("🔍 Project Argus: Agentic AML Investigator")
st.subheader("Graph-Based Circular Loop Detection & AI Adjudication")

# Get the current Snowflake session
session = get_active_session()

# --- 1. Sidebar for Controls ---
st.sidebar.header("Investigation Settings")
model_choice = st.sidebar.selectbox("Cortex Model", ["mistral-7b", "llama3-70b"])
risk_threshold = st.sidebar.slider("Minimum Risk Score", 1, 10, 5)

# --- 2. Fetch Circular Loops from Gold Layer ---
def get_circular_loops():
    query = """
    SELECT 
        SUSPECT_ENTITY,
        INTERMEDIARY_1,
        INTERMEDIARY_2,
        FINAL_RECIPIENT,
        TOTAL_VOLUME
    FROM GOLD.AGENT_CONTEXT_CIRCULAR_LOOPS
    """
    return session.sql(query).to_pandas()

# --- 3. Fetch AI Adjudications ---
def get_ai_reports(model):
    # This calls the live Cortex function directly from the UI
    query = f"""
    SELECT 
        SUSPECT_ENTITY,
        SNOWFLAKE.CORTEX.COMPLETE(
            '{model}', 
            CONCAT('Analyze this circular loop for entity: ', SUSPECT_ENTITY, 
                   '. Explain why this indicates high-risk money laundering in 2 sentences.')
        ) as AI_REPORT
    FROM GOLD.AGENT_CONTEXT_CIRCULAR_LOOPS
    LIMIT 5
    """
    return session.sql(query).to_pandas()

# --- UI Layout ---
col1, col2 = st.columns([1, 1])

with col1:
    st.markdown("### 🕸 Detected Circular Paths")
    loops_df = get_circular_loops()
    if not loops_df.empty:
        st.dataframe(loops_df, use_container_width=True)
    else:
        st.info("No circular loops detected in the current Graph layer.")

with col2:
    st.markdown("### 🤖 Agentic Adjudication (Cortex AI)")
    if st.button("Generate Investigation Reports"):
        with st.spinner("AI Agent is investigating graph paths..."):
            reports_df = get_ai_reports(model_choice)
            for index, row in reports_df.iterrows():
                with st.expander(f"Report for {row['SUSPECT_ENTITY']}"):
                    st.write(row['AI_REPORT'])
                    st.caption(f"Generated via {model_choice}")

# --- 4. Graph Visualization Placeholder ---
st.divider()
st.markdown("### 📊 Network Lineage")
st.info("In a production build, you can use `streamlit-agraph` or `pyvis` here to render the NODES and EDGES tables visually.")