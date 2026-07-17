# Data Directory

This directory contains documentation for the local data used by the project.

Raw and generated data files are intentionally excluded from Git. They must be downloaded or generated locally.

## Local directory structure

```text
data/
├── README.md
├── raw/
│   └── olist/
└── processed/
```

## Primary data source

- **Dataset:** Brazilian E-Commerce Public Dataset by Olist
- **Provider:** Olist
- **Distribution platform:** Kaggle
- **Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **License:** Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
- **License reference:** [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
- **Downloaded:** 2026-07-17
- **Local path:** `data/raw/olist/`

The source CSV files are not redistributed through this repository. Users must download them from the original Kaggle source and comply with the dataset license.

## Phase 1 source files

The initial ingestion and analytics workflow uses the following files:

- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_customers_dataset.csv`
- `olist_products_dataset.csv`
- `olist_sellers_dataset.csv`
- `product_category_name_translation.csv`

## Deferred source files

The following files are retained locally but are not part of the initial pipeline:

- `olist_order_reviews_dataset.csv`
- `olist_geolocation_dataset.csv`

Reviews may later support customer-satisfaction analysis. Geolocation data may later support map visualizations and distance-related analyses.

## Raw data policy

Files inside `data/raw/` must not be modified manually.

Cleaning, type conversion, deduplication, validation, and other transformations will be implemented reproducibly using Python, SQL, or PostgreSQL staging models.
```
