# E-commerce Operations Data Platform

**Status:** In progress  
**Target completion:** October 2026

## Project context

A fictional e-commerce operations team needs a reliable view of orders, revenue, customers, products, delivery performance, and data quality. The available data comes from a public e-commerce dataset and will later be enriched with contextual data from a public REST API.

The current process is assumed to be fragmented and difficult to reproduce. This project therefore focuses on building a small but production-oriented analytics data platform rather than only creating a one-off notebook.

## Project goal

The goal is to build a reproducible end-to-end data pipeline that:

1. ingests raw data from CSV files and a public REST API,
2. stores the original data in a PostgreSQL raw layer,
3. cleans and standardizes the data in a staging layer,
4. transforms it into an analytics-ready star schema,
5. checks data quality with automated tests,
6. exposes business metrics in a Power BI dashboard,
7. runs locally with Docker Compose,
8. executes automated tests with GitHub Actions, and
9. optionally reproduces one part of the workflow in Microsoft Fabric.

## Career objective

This portfolio project supports my preparation for the following entry-level roles:

- **Primary target:** Junior Data Engineer
- **Secondary targets:** Analytics Engineer, BI Developer, and Technical Data Analyst

The project is designed to demonstrate practical skills in Python, SQL, PostgreSQL, REST APIs, Pandas, data modeling, ETL/ELT, data quality, testing, Docker, CI/CD, Power BI, and cloud data fundamentals.

## Business questions

The first version of the platform will answer five measurable business questions covering sales, orders, delivery performance, customer regions, and sellers.

### 1. Sales performance

**How does monthly gross merchandise value develop over time, and what is the month-over-month growth rate?**

Gross merchandise value, abbreviated as **GMV**, will be calculated as the sum of item prices for delivered orders. Freight costs are reported separately and are not included in GMV.

**Primary metrics:**

- Monthly GMV
- Month-over-month GMV change
- Month-over-month GMV growth rate
- Freight value

**Primary dimensions:**

- Purchase month
- Purchase year

**Main source files:**

- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`

### 2. Order development

**How does monthly order volume develop, and what proportion of orders are delivered, cancelled, or assigned another status?**

Each order will be counted once using its unique `order_id`.

**Primary metrics:**

- Number of orders
- Number of delivered orders
- Number of cancelled orders
- Delivery rate
- Cancellation rate

**Primary dimensions:**

- Purchase month
- Order status

**Main source file:**

- `olist_orders_dataset.csv`

### 3. Delivery performance

**What proportion of delivered orders arrive after their estimated delivery date, and how many days late are delayed orders on average?**

An order will be classified as late when its actual delivery date is later than its estimated delivery date. Only delivered orders with both dates available will be included.

**Primary metrics:**

- Number of delivered orders
- Number of late deliveries
- Late-delivery rate
- Average days late
- Average delivery duration

**Primary dimensions:**

- Purchase month
- Customer state

**Main source files:**

- `olist_orders_dataset.csv`
- `olist_customers_dataset.csv`

### 4. Regional performance

**Which customer states generate the highest GMV, and how do their order volume and average order value differ?**

The regional analysis will initially use the customer state. City-level and geolocation-based analyses may be added later.

**Primary metrics:**

- GMV
- Number of delivered orders
- Average order value
- Share of total GMV

**Primary dimensions:**

- Customer state

**Main source files:**

- `olist_customers_dataset.csv`
- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`

### 5. Seller performance

**Which sellers generate the highest GMV, and what proportion of total GMV is contributed by the ten highest-performing sellers?**

Seller performance will initially focus on sales contribution. Delivery and customer-review metrics may be added in a later project phase.

**Primary metrics:**

- GMV per seller
- Number of delivered orders per seller
- Number of order items per seller
- Share of total GMV
- Cumulative GMV share of the top ten sellers

**Primary dimensions:**

- Seller
- Seller state

**Main source files:**

- `olist_order_items_dataset.csv`
- `olist_orders_dataset.csv`
- `olist_sellers_dataset.csv`

## Metric assumptions

The following initial definitions will be used consistently across SQL queries and Power BI measures:

- **GMV:** Sum of `price` from order items belonging to delivered orders.
- **Freight value:** Sum of `freight_value`, reported separately from GMV.
- **Order count:** Distinct count of `order_id`.
- **Average order value:** GMV divided by the number of distinct delivered orders.
- **Late delivery:** An order where `order_delivered_customer_date` is later than `order_estimated_delivery_date`.
- **Days late:** Difference in days between the actual and estimated delivery dates for late orders.
- **Customer region:** Initially represented by `customer_state`.
- **Seller contribution:** Seller GMV divided by total GMV.

These definitions may be refined after the initial data profiling, but any changes will be documented before analytical results are published.

## Data quality objectives

In addition to answering the business questions, the pipeline will verify whether the source data is sufficiently reliable for analysis.

The initial data-quality checks will examine:

- whether `order_id` is unique in the orders dataset,
- whether required identifiers are missing,
- whether order items reference existing orders,
- whether products and sellers referenced by order items exist,
- whether monetary values are negative or missing,
- whether timestamps follow a logically valid sequence,
- whether delivered orders contain the required delivery dates,
- whether repeated pipeline runs create duplicate records, and
- whether joins unexpectedly increase row counts.

Data-quality results will be documented separately from business KPIs so that analytical findings and technical reliability remain clearly distinguishable.

## First source-table import

The first imported source table is `raw.olist_orders`, based on the local `olist_orders_dataset.csv` file.

The table uses one row per order and contains:

- order and customer identifiers,
- the current or final order status,
- the purchase timestamp,
- payment-approval and carrier timestamps,
- the actual customer-delivery timestamp, and
- the estimated delivery timestamp.

Source identifiers and statuses are stored as text. Source timestamps are stored as PostgreSQL `timestamp without time zone` values because the CSV does not contain explicit timezone offsets.

The import was validated by checking:

- the source and database row counts,
- the number of distinct `order_id` values,
- the order-status distribution,
- the available purchase-date range,
- missing optional timestamps, and
- potentially illogical delivery dates.

The original CSV remains in the Git-ignored `data/raw/olist/` directory. Table creation and validation queries are versioned under `sql/raw/` and `sql/validation/`.

## Planned architecture

```text
Public dataset (CSV)       Public REST API
          |                       |
          +----------+------------+
                     |
              Python ingestion
                     |
             PostgreSQL raw layer
                     |
          SQL / Pandas transformations
                     |
          staging and analytics marts
                     |
              dimensional model
                     |
              Power BI dashboard

Cross-cutting concerns: pytest, logging, Git, Docker, and GitHub Actions
```

## Planned technology stack

| Area | Technology | Current status |
|---|---|---|
| Programming | Python | Planned |
| Data manipulation | Pandas | Planned |
| Querying and transformation | SQL | Planned |
| Database | PostgreSQL | Implemented locally |
| Data sources | Olist CSV dataset and planned REST API | Dataset selected |
| Data modeling | Relational model and star schema | Planned |
| Testing | pytest and data quality checks | Planned |
| Containers | Docker and Docker Compose | Integrated locally |
| Version control | Git and GitHub | In progress |
| CI | GitHub Actions | Planned |
| Visualization | Power BI | Planned |
| Cloud extension | Microsoft Fabric | Optional milestone |

The status table will be updated only after a component has been implemented and documented.

## Roadmap

| Period | Focus | Planned deliverable |
|---|---|---|
| July 14-19, 2026 | Project setup | Repository, README, initial business questions, and development environment |
| July 20-August 2, 2026 | SQL, PostgreSQL, and data modeling | Raw tables, source model, star schema, and analytical SQL queries |
| August 3-16, 2026 | Python, Pandas, and REST APIs | Reusable ingestion scripts, validation, logging, and API integration |
| August 17-30, 2026 | ETL/ELT, testing, Docker, and CI | Raw/staging/mart pipeline, pytest suite, Docker Compose, and GitHub Actions |
| August 31-September 13, 2026 | Power BI and communication | Dashboard, KPIs, findings, screenshots, and project documentation |
| September 14-20, 2026 | Azure/Fabric fundamentals | Small Fabric workflow or documented cloud architecture extension |
| September 21-October 31, 2026 | Portfolio and interview preparation | Project polishing, technical explanations, and targeted improvements |

## Definition of done

The first complete version is finished when:

- [ ] the data sources and their licenses are documented,
- [ ] the ingestion process is repeatable,
- [ ] raw, staging, and mart layers are implemented,
- [ ] the analytics model has a clearly documented grain,
- [ ] repeated pipeline runs do not create unwanted duplicates,
- [ ] important data quality rules are tested,
- [ ] automated tests run successfully in GitHub Actions,
- [ ] the local environment starts through Docker Compose,
- [ ] the Power BI dashboard answers the five business questions,
- [ ] setup instructions work on a clean environment,
- [ ] architecture and data model diagrams are included, and
- [ ] no passwords, API keys, tokens, or other secrets are committed.

## Current progress

- [x] Repository name selected
- [x] Project context defined
- [x] Target roles defined
- [x] Initial roadmap defined
- [x] Public dataset selected and documented
- [x] Local PostgreSQL environment created
- [x] First source table loaded
- [x] First ten SQL queries completed
- [ ] First REST API response saved

## Planned repository structure

```text
.
|-- src/
|   |-- ingestion/
|   |-- transformation/
|   `-- database/
|-- sql/
|   |-- raw/
|   |-- staging/
|   |-- marts/
|   `-- analysis/
|-- tests/
|-- dashboard/
|-- docs/
|-- .github/workflows/
|-- Dockerfile
|-- docker-compose.yml
|-- requirements.txt
|-- .env.example
`-- README.md
```

## Local development setup

The project uses a repository-local Python virtual environment to isolate its dependencies.

**Tested with:** Python 3.11.4 on Windows using PowerShell

### 1. Clone the repository

```powershell
git clone https://github.com/ManuA287/ecommerce-operations-data-platform.git
cd ecommerce-operations-data-platform
```

### 2. Create a virtual environment

```powershell
py -m venv .venv
```

### 3. Activate the environment

```powershell
.\.venv\Scripts\Activate.ps1
```

### 4. Install the dependencies

```powershell
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

### 5. Verify the installation

```powershell
python -m pip check
python -c "import pandas, requests, psycopg, dotenv, pytest; print('Environment OK')"
```

### Deactivate the environment

```powershell
deactivate
```

The `.venv` directory and local `.env` files are not committed. The environment can be recreated from `requirements.txt`.

### Start PostgreSQL with Docker Compose

Create a local environment file from the committed template:

```powershell
Copy-Item .env.example .env
```

Replace the placeholder password in `.env`. Local `.env` files are ignored by Git and must not be committed.

Start PostgreSQL:

```powershell
docker compose up -d
```

Check the service status:

```powershell
docker compose ps
```

Verify the database from inside the container:

```powershell
docker compose exec postgres psql -U ecommerce_user -d ecommerce -c "SELECT 1 AS connection_test;"
```

Verify the connection from Python:

```powershell
python scripts\check_postgres.py
```

Stop and remove the local containers while preserving the database volume:

```powershell
docker compose down
```

To intentionally remove the local database volume and reset all data:

```powershell
docker compose down -v
```

## Data sources and licensing

### Olist Brazilian E-Commerce Public Dataset

The primary source is the **Brazilian E-Commerce Public Dataset by Olist**, distributed through Kaggle.

- **Provider:** Olist
- **Source:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- **License:** Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
- **License reference:** https://creativecommons.org/licenses/by-nc-sa/4.0/
- **Local raw-data path:** `data/raw/olist/`

The original CSV files are not included in this repository. They must be downloaded from the official source and are stored locally in the Git-ignored `data/raw/olist/` directory.

The initial pipeline uses the orders, order items, payments, customers, products, sellers, and product-category translation files. Reviews and detailed geolocation data are retained locally for possible later extensions.

Further details are documented in [`data/README.md`](data/README.md).

## Author

**Manuel Audino**  
Bachelor's degree in Software Engineering  
Currently building practical experience for entry-level data engineering and analytics roles.
