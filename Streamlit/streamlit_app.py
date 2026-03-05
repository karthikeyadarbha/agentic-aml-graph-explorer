import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

st.title("🔍 Project Argus: Agentic AML Investigator")
st.subheader("Graph-Based Circular Loop Detection & AI Adjudication")

session = get_active_session()

# Sidebar for Controls
st.sidebar.header("Investigation Settings")
model_choice = st.sidebar.selectbox("Cortex Model", ["mistral-7b", "llama3-70b"])
risk_threshold = st.sidebar.slider("Minimum Risk Score", 1, 10, 5)

# Fetch Circular Loops from Gold Layer
@st.cache_data
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

# Fetch AI Adjudications
def get_ai_reports(model):
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

# UI Layout
col1, col2 = st.columns([1, 1])

with col1:
    st.markdown("### 🕸 Detected Circular Paths")
    try:
        loops_df = get_circular_loops()
        if not loops_df.empty:
            st.dataframe(loops_df, hide_index=True)
        else:
            st.info("No circular loops detected in the current Graph layer.")
    except Exception as e:
        st.error(f"Error loading circular loops: {e}")

with col2:
    st.markdown("### 🤖 Agentic AI Risk Analysis")
    if st.button("Generate AI Reports"):
        with st.spinner("Cortex AI analyzing suspicious patterns..."):
            try:
                reports_df = get_ai_reports(model_choice)
                if not reports_df.empty:
                    for _, row in reports_df.iterrows():
                        with st.expander(f"Entity: {row['SUSPECT_ENTITY']}"):
                            st.write(row['AI_REPORT'])
                else:
                    st.info("No reports generated.")
            except Exception as e:
                st.error(f"Error generating AI reports: {e}")
