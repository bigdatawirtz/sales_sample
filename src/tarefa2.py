"""Tarefa 2: importe total e número de vendas de vendas_2025.csv (1,5 millóns de filas)"""
import sys
import pandas as pd

ficheiro = sys.argv[1] if len(sys.argv) > 1 else "datos/raw/vendas_2025-full.csv"

# --- Opción A: ler o ficheiro enteiro en memoria (igual que na tarefa 1) ---
# pandas non ten o límite de 1.048.576 filas dunha folla de cálculo:
# o único límite é a memoria RAM do equipo.
df = pd.read_csv(ficheiro, sep=";", decimal=",", encoding="utf-8")
assert pd.api.types.is_numeric_dtype(df["importe"]), "importe non se leu como número"
num_a, total_a = len(df), df["importe"].sum()
print(f"Memoria usada polo DataFrame: {df.memory_usage(deep=True).sum() / 1e6:.0f} MB")
del df

# --- Opción B: ler por bloques (chunks) ---
# Só ten en memoria 200.000 filas de cada vez, así que serviría
# tamén para ficheiros moito maiores que a RAM.
num_b, total_b = 0, 0.0
for bloque in pd.read_csv(ficheiro, sep=";", decimal=",", encoding="utf-8",
                          usecols=["importe"], chunksize=200_000):
    num_b += len(bloque)
    total_b += bloque["importe"].sum()

# As dúas opcións deben coincidir
assert num_a == num_b and round(total_a, 2) == round(total_b, 2)

def eur(x):
    return f"{x:,.2f} €".replace(",", "X").replace(".", ",").replace("X", ".")

print(f"Número de vendas: {num_a:,}".replace(",", "."))
print(f"Importe total:    {eur(total_a)}")
