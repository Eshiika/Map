#!/bin/bash

set -e

psql -U postgres -d postgres -a -f /database/seed.sql
echo "Database initialized successfully."

psql -U postgres -d postgres -c "COPY cities FROM '/database/cities.csv' DELIMITER ',' CSV HEADER;"
echo "Database seeded successfully."