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

The first version of the platform will answer the following questions:

1. How do order volume and revenue develop over time?
2. Which product categories, sellers, and regions contribute most to revenue?
3. How high is the late-delivery rate, and where are delays concentrated?
4. How does the average order value change by period and segment?
5. Which data quality issues could make the analysis unreliable?

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
| Data sources | CSV and REST API | Planned |
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
- [ ] Public dataset selected and documented
- [ ] Local PostgreSQL environment created
- [ ] First source table loaded
- [ ] First ten SQL queries completed
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

The exact public dataset and API will be selected and documented in the next milestone. Source links, usage conditions, and any relevant licenses will be listed here before data files are added to the repository.

## Author

**Manuel Audino**  
Bachelor's degree in Software Engineering  
Currently building practical experience for entry-level data engineering and analytics roles.
