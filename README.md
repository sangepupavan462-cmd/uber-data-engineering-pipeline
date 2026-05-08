# Uber Data Engineering Pipeline

## Introduction

This project implements a Modern Data Engineering Pipeline for Uber (NYC TLC) trip data using Google Cloud Platform. The pipeline ingests raw taxi trip records, applies dimensional star-schema modeling, loads the results into BigQuery, and produces a final analytics table ready for reporting and visualization.

---

## Technologies Used

- **Language:** Python 3.10+
- **Pipeline Orchestration:** Mage AI
- **Data Processing:** Pandas
- **Cloud Platform:** Google Cloud Platform (GCP)
- **Data Warehouse:** Google BigQuery
- **Raw Storage:** Google Cloud Storage
- **Visualization:** Looker Studio
- **Version Control:** GitHub

---

## Project Structure

```
uber-data-engineering-pipeline/
|
|-- mage-files/
|   |-- extract.py        # Data Loader - fetches CSV from GCS
|   |-- transform.py      # Transformer - builds star schema
|   |-- load.py           # Data Exporter - writes to BigQuery
|
|-- data/
|   |-- uber_data.csv     # Sample NYC TLC trip dataset
|
|-- analytics_query.sql   # Final BigQuery analytics SQL
|-- commands.txt          # Setup commands reference
|-- README.md
```

---

## Data Model (Star Schema)

The transformation layer converts the flat raw CSV into a star schema with 7 dimension tables and 1 fact table.

**Dimension Tables:**
- datetime_dim - Pickup and dropoff timestamps with hour, day, month, weekday breakdowns
- passenger_count_dim - Distinct passenger count values
- trip_distance_dim - Distinct trip distances
- rate_code_dim - Rate type codes mapped to names (Standard, JFK, Newark, etc.)
- pickup_location_dim - Pickup GPS coordinates
- dropoff_location_dim - Drop-off GPS coordinates
- payment_type_dim - Payment method codes mapped to names

**Fact Table:**
- fact_table - Trip-level records with FK references to all dimensions and all fare metrics

---

## Dataset

**Source:** NYC Taxi and Limousine Commission (TLC) - Yellow Taxi Trip Records

Key fields: pickup/dropoff timestamps, GPS coordinates, trip distance, passenger count, payment type, and fare breakdown.

---

## Setup and Installation

### 1. Clone the repository
```bash
git clone https://github.com/sangepupavan462-cmd/uber-data-engineering-pipeline.git
cd uber-data-engineering-pipeline
```

### 2. Create and activate virtual environment
```bash
python -m venv venv
source venv/bin/activate
```

### 3. Install dependencies
```bash
pip install mage-ai pandas google-cloud google-cloud-bigquery
```

### 4. Configure GCP credentials
- Create a GCP project and enable BigQuery and Cloud Storage APIs
- Create a Service Account with BigQuery Admin and Storage Admin roles
- Download the JSON key and update io_config.yaml in your Mage project folder

### 5. Start Mage AI
```bash
mage start uber_pipeline
```
Open http://localhost:6789 in your browser.

### 6. Build the pipeline in Mage UI
Create a new Standard batch pipeline and add three blocks in order:
1. Data Loader - use code from mage-files/extract.py
2. Transformer - use code from mage-files/transform.py
3. Data Exporter - use code from mage-files/load.py (update your GCP Project ID)

### 7. Run the analytics query
After the pipeline runs, execute analytics_query.sql in BigQuery to create the final tbl_analytics table.

---

## BigQuery Tables Created

| Table | Type | Description |
|---|---|---|
| datetime_dim | Dimension | Timestamp breakdowns |
| passenger_count_dim | Dimension | Passenger counts |
| trip_distance_dim | Dimension | Trip distances |
| rate_code_dim | Dimension | Rate type mapping |
| pickup_location_dim | Dimension | Pickup coordinates |
| dropoff_location_dim | Dimension | Drop-off coordinates |
| payment_type_dim | Dimension | Payment method mapping |
| fact_table | Fact | Core trip metrics |
| tbl_analytics | Analytics | Final joined analytics table |

---

## Future Improvements

- Add scheduled pipeline triggers in Mage AI for automated daily runs
- Implement real-time streaming with Pub/Sub and Dataflow
- Add data quality validation and anomaly detection blocks
- Build a full interactive Looker Studio dashboard

---

## Author

**sangepupavan462-cmd**
Data Engineering Portfolio Project
Built on Google Cloud Platform using Mage AI and BigQuery
