#!/usr/bin/env bash
# fixture.sh DIR : build the "invoicer" test project (stdlib-only Python, unittest) with one planted bug:
# a price with a thousands separator ("$1,250.00") crashes parsing.
set -euo pipefail
d=$1; mkdir -p "$d/invoicer" "$d/tests"; cd "$d"
cat > pyproject.toml <<'X'
[project]
name = "invoicer"
version = "0.1.0"
requires-python = ">=3.10"
X
: > invoicer/__init__.py; : > tests/__init__.py
cat > invoicer/core.py <<'X'
"""Invoice totals from CSV line items: description,quantity,unit_price."""
import csv
from decimal import Decimal


def parse_amount(text):
    """Turn a price string such as "12.50" or "$12.50" into a Decimal."""
    return Decimal(text.strip().lstrip("$"))


def read_items(path):
    with open(path, newline="") as f:
        return [
            {"description": r["description"], "quantity": int(r["quantity"]), "unit_price": parse_amount(r["unit_price"])}
            for r in csv.DictReader(f)
        ]


def subtotal(items):
    return sum((i["quantity"] * i["unit_price"] for i in items), Decimal("0"))


def total(items, tax_rate=Decimal("0")):
    s = subtotal(items)
    return (s + s * tax_rate).quantize(Decimal("0.01"))
X
cat > invoicer/__main__.py <<'X'
import argparse
from decimal import Decimal

from .core import read_items, subtotal, total


def main(argv=None):
    p = argparse.ArgumentParser(prog="invoicer", description="Print the total for a CSV of line items.")
    p.add_argument("csv_file")
    p.add_argument("--tax", default="0", help="tax rate as a fraction, e.g. 0.08")
    a = p.parse_args(argv)
    items = read_items(a.csv_file)
    print(f"items: {len(items)}")
    print(f"subtotal: {subtotal(items):.2f}")
    print(f"total: {total(items, Decimal(a.tax)):.2f}")


if __name__ == "__main__":
    main()
X
cat > tests/test_core.py <<'X'
import unittest
from decimal import Decimal

from invoicer.core import parse_amount, subtotal, total


class CoreTest(unittest.TestCase):
    def test_parse_plain(self):
        self.assertEqual(parse_amount("12.50"), Decimal("12.50"))

    def test_parse_dollar(self):
        self.assertEqual(parse_amount("$3.00"), Decimal("3.00"))

    def test_total_with_tax(self):
        items = [{"description": "a", "quantity": 2, "unit_price": Decimal("10.00")}]
        self.assertEqual(subtotal(items), Decimal("20.00"))
        self.assertEqual(total(items, Decimal("0.08")), Decimal("21.60"))
X
printf '# invoicer\n\nPrints the total for a CSV of invoice line items.\n\n    python -m invoicer items.csv --tax 0.08\n\nCSV columns: description, quantity, unit_price.\n' > README.md
printf 'description,quantity,unit_price\nWidget,2,"$1,250.00"\nBolt,10,0.25\n' > sample.csv
printf 'test:\n\tpython3 -m unittest discover -s tests -t .\n' > Makefile
printf '__pycache__/\n.swe/\n' > .gitignore
git init -q -b main .
git -c user.name=eval -c user.email=eval@example.com add -A
git -c user.name=eval -c user.email=eval@example.com commit -qm "invoicer: CSV invoice totals"
