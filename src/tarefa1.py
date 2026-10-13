"""Tarefa 1: importe total e número de vendas de vendas_2025.csv"""
import sys
import pandas as pd

ficheiro = sys.argv[1] if len(sys.argv) > 1 else "datos/raw/vendas_2025.csv"

# O CSV usa ";" como separador e a coma como separador decimal
df = pd.read_csv(ficheiro, sep=";", decimal=",", encoding="utf-8")

# Comprobación rápida: a columna importe debe ser numérica
print(df.dtypes, "\n")
assert pd.api.types.is_numeric_dtype(df["importe"]), "importe non se leu como número"

num_vendas = len(df)
total = df["importe"].sum()

print(f"Número de vendas: {num_vendas:,}".replace(",", "."))
print(f"Importe total:    {total:,.2f} €".replace(",", "X").replace(".", ",").replace("X", "."))
