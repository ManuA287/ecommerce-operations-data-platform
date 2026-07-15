"""Verify that the local PostgresSQL container accepts Python connections."""

from __future__ import annotations

import os
import sys

import psycopg
from dotenv import load_dotenv

REQUIRED_ENV_VARS = (
    "POSTGRES_HOST",
    "POSTGRES_PORT",
    "POSTGRES_DB",
    "POSTGRES_USER",
    "POSTGRES_PASSWORD",
)


def get_required_env_vars(name: str) -> str:
    """Return a required environment variable or raise a helpful error."""
    value = os.getenv(name)

    if value is None or not value.strip():
        raise ValueError(
            f"Required environment variable {name!r} is missing. "
            "Check your local .env file."
        )
    return value


def main() -> int:
    """Connect to PostgreSQL and execute a smll verification query."""
    load_dotenv()

    try:
        host = get_required_env_vars("POSTGRES_HOST")
        port = int(get_required_env_vars("POSTGRES_PORT"))
        database = get_required_env_vars("POSTGRES_DB")
        user = get_required_env_vars("POSTGRES_USER")
        password = get_required_env_vars("POSTGRES_PASSWORD")

        with psycopg.connect(
            host=host,
            port=port,
            dbname=database,
            user=user,
            password=password,
            connect_timeout=5,
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    SELECT
                        1 AS connection_test,
                        current_database(), 
                        current_user,
                        current_setting('server_version');
                    """
                )
                result = cursor.fetchone()

        if result is None:
            print(
                "Connection successful, but no result returned from the query.",
                file=sys.stderr,
            )
            return 1

        connection_test, current_database, current_user, server_version = result

        if connection_test != 1:
            print(
                f"Unexpected SELECT 1 result: {connection_test!r}",
                file=sys.stderr,
            )
            return 1

        print("PostgreSQL connection successful.")
        print(f"SELECT 1 result: {connection_test}")
        print(f"Database: {current_database}")
        print(f"User: {current_user}")
        print(f"PostgreSQL version: {server_version}")
        return 0

    except (RuntimeError, ValueError, psycopg.Error) as error:
        print(f"PostgreSQL connection failed: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
