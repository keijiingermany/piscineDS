#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
customer_dir="${1:-"$script_dir/../customer"}"

export PGHOST="${PGHOST:-localhost}"
export PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-kuehara}"
export PGDATABASE="${PGDATABASE:-piscineds}"

if [ -z "${PGPASSWORD:-}" ] && [ -z "${PGPASSFILE:-}" ]; then
    printf 'PostgreSQL password: ' >&2
    read -r -s pg_password
    printf '\n' >&2

    pgpass_file="$(mktemp)"
    chmod 600 "$pgpass_file"
    trap 'rm -f "$pgpass_file"' EXIT

    escaped_password=${pg_password//\\/\\\\}
    escaped_password=${escaped_password//:/\\:}
    printf '%s:%s:%s:%s:%s\n' \
        "$PGHOST" "$PGPORT" "$PGDATABASE" "$PGUSER" "$escaped_password" \
        > "$pgpass_file"
    unset pg_password escaped_password
    export PGPASSFILE="$pgpass_file"
fi

if [ ! -d "$customer_dir" ]; then
    printf 'Customer directory does not exist: %s\n' "$customer_dir" >&2
    exit 1
fi

found_csv=0
for csv_path in "$customer_dir"/*.csv; do
    [ -f "$csv_path" ] || continue
    found_csv=1
    filename="${csv_path##*/}"
    table_name="${filename%.csv}"

    case "$table_name" in
        ''|*[!a-zA-Z0-9_]*)
            printf 'Invalid table name derived from filename: %s\n' "$filename" >&2
            exit 1
            ;;
    esac

    psql -v ON_ERROR_STOP=1 -v table_name="$table_name" <<'SQL'
DROP TABLE IF EXISTS :"table_name";

CREATE TABLE :"table_name" (
    event_time TIMESTAMP NOT NULL,
    event_type VARCHAR(32) NOT NULL,
    product_id INTEGER NOT NULL,
    price NUMERIC(12, 2) NOT NULL,
    user_id BIGINT NOT NULL,
    user_session UUID
);
SQL

    psql -v ON_ERROR_STOP=1 \
        -c "\copy \"$table_name\" (event_time, event_type, product_id, price, user_id, user_session) FROM '$csv_path' WITH (FORMAT csv, HEADER true, NULL '')"
done

if [ "$found_csv" -eq 0 ]; then
    printf 'No CSV files found in: %s\n' "$customer_dir" >&2
    exit 1
fi
