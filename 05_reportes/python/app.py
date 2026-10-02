import os
import warnings
import pyodbc
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path
from dotenv import load_dotenv

warnings.filterwarnings("ignore")

# Cargar variables del entorno desde .env
load_dotenv()

CARPETA_GRAFICOS = Path(__file__).parent.parent.parent / "evidencias"
CARPETA_GRAFICOS.mkdir(exist_ok=True)

SERVER = os.getenv("DB_SERVER", "ESPACEESM")
DATABASE = os.getenv("DB_DATABASE", "TURISMOPERU_DJRL")
USER = os.getenv("DB_USER")
PASSWORD = os.getenv("DB_PASSWORD")
TRUSTED = os.getenv("USE_TRUSTED_CONNECTION", "no")

# Construir cadena de conexión basada exclusivamente en .env
if TRUSTED.lower() == "yes" or not USER:
    conn_str = f"DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};Trusted_Connection=yes;"
else:
    conn_str = f"DRIVER={{SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USER};PWD={PASSWORD};"

def obtener_columnas(conn, tabla):
    query = f"SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{tabla}' AND TABLE_SCHEMA = 'DJRL'"
    cursor = conn.cursor()
    cursor.execute(query)
    return [row[0].lower() for row in cursor.fetchall()]

def obtener_datos():
    conn = pyodbc.connect(conn_str)
    
    cols_reserva = obtener_columnas(conn, 'reserva')
    cols_pago = obtener_columnas(conn, 'pago')
    
    c_res_cliente = 'id_cliente' if 'id_cliente' in cols_reserva else ('id_persona' if 'id_persona' in cols_reserva else cols_reserva[0])
    c_res_estado = 'estado' if 'estado' in cols_reserva else ('estado_reserva' if 'estado_reserva' in cols_reserva else "NULL")
    c_res_fecha = 'fecha_reserva' if 'fecha_reserva' in cols_reserva else ('fecha' if 'fecha' in cols_reserva else "NULL")
    
    c_pago_medio = 'medio_pago' if 'medio_pago' in cols_pago else ('metodo_pago' if 'metodo_pago' in cols_pago else "NULL")
    c_pago_monto = 'monto' if 'monto' in cols_pago else ('total' if 'total' in cols_pago else "0")

    query = f"""
    SELECT 
        r.id_reserva,
        r.{c_res_cliente} AS id_cliente,
        'Cliente ' + CAST(r.{c_res_cliente} AS VARCHAR) AS cliente,
        ISNULL(CAST({('r.' + c_res_estado) if c_res_estado != 'NULL' else "'Confirmada'"} AS VARCHAR), 'Confirmada') AS estado_reserva,
        ISNULL({('r.' + c_res_fecha) if c_res_fecha != 'NULL' else "GETDATE()"}, GETDATE()) AS fecha_reserva,
        pg.id_pago,
        ISNULL(CAST({('pg.' + c_pago_medio) if c_pago_medio != 'NULL' else "'Efectivo'"} AS VARCHAR), 'Efectivo') AS medio_pago,
        ISNULL(CAST({('pg.' + c_pago_monto) if c_pago_monto != '0' else "0"} AS DECIMAL(10,2)), 0) AS monto
    FROM DJRL.reserva r
    LEFT JOIN DJRL.pago pg ON r.id_reserva = pg.id_reserva
    """
    
    df = pd.read_sql(query, conn)
    conn.close()
    return df

def reservas_unicas(df):
    return df.drop_duplicates(subset="id_reserva").copy()

def calcular_indicadores(df):
    total_clientes = df["id_cliente"].nunique()
    total_reservas = df["id_reserva"].nunique()
    total_ingresos = df["monto"].fillna(0).sum()
    ticket_promedio = total_ingresos / total_reservas if total_reservas else 0
    return {
        "Total clientes": total_clientes,
        "Total reservas": total_reservas,
        "Total ingresos": round(float(total_ingresos), 2),
        "Ticket promedio": round(float(ticket_promedio), 2),
    }

def guardar(fig, nombre):
    fig.tight_layout()
    fig.savefig(CARPETA_GRAFICOS / nombre, dpi=120)
    plt.close(fig)

def grafico_reservas_por_estado(df):
    datos = reservas_unicas(df).groupby("estado_reserva").size().sort_values()
    fig, ax = plt.subplots(figsize=(8, 5))
    datos.plot(kind="barh", ax=ax, color="#2a6f97")
    ax.set_title("Reservas por estado")
    ax.set_xlabel("Cantidad de reservas")
    ax.set_ylabel("")
    guardar(fig, "01_reservas_por_estado.png")

def grafico_ingresos_por_medio_pago(df):
    datos = df.groupby("medio_pago")["monto"].sum().sort_values()
    fig, ax = plt.subplots(figsize=(8, 5))
    datos.plot(kind="barh", ax=ax, color="#61a5c2")
    ax.set_title("Ingresos por medio de pago")
    ax.set_xlabel("Ingresos (S/)")
    ax.set_ylabel("")
    guardar(fig, "02_ingresos_por_medio_pago.png")

def grafico_reservas_por_periodo(df):
    res = reservas_unicas(df)
    res["fecha_reserva"] = pd.to_datetime(res["fecha_reserva"])
    datos = res.groupby(res["fecha_reserva"].dt.to_period("M")).size().sort_index()
    fig, ax = plt.subplots(figsize=(9, 5))
    ax.plot(datos.index.astype(str), datos.values, marker="o", color="#014f86")
    ax.set_title("Reservas por periodo (mensual)")
    ax.set_xlabel("Mes")
    ax.set_ylabel("Cantidad de reservas")
    plt.setp(ax.get_xticklabels(), rotation=45, ha="right")
    guardar(fig, "03_reservas_por_periodo.png")

def grafico_top_clientes_reservas(df):
    datos = reservas_unicas(df).groupby("cliente").size().nlargest(10).sort_values()
    fig, ax = plt.subplots(figsize=(9, 5))
    datos.plot(kind="barh", ax=ax, color="#2a6f97")
    ax.set_title("Top 10 clientes por cantidad de reservas")
    ax.set_xlabel("Cantidad de reservas")
    ax.set_ylabel("")
    guardar(fig, "04_top10_clientes_reservas.png")

def grafico_ingresos_por_cliente(df):
    datos = df.groupby("cliente")["monto"].sum().nlargest(10).sort_values()
    fig, ax = plt.subplots(figsize=(9, 5))
    datos.plot(kind="barh", ax=ax, color="#61a5c2")
    ax.set_title("Ingresos por cliente (top 10)")
    ax.set_xlabel("Ingresos (S/)")
    ax.set_ylabel("")
    guardar(fig, "05_ingresos_por_cliente.png")

def generar_graficos(df):
    grafico_reservas_por_estado(df)
    grafico_ingresos_por_medio_pago(df)
    grafico_reservas_por_periodo(df)
    grafico_top_clientes_reservas(df)
    grafico_ingresos_por_cliente(df)

if __name__ == "__main__":
    df = obtener_datos()

    print("=== INDICADORES GENERALES ===")
    for nombre, valor in calcular_indicadores(df).items():
        print(f"{nombre}: {valor}")

    generar_graficos(df)
    print(f"\n¡Éxito! Los 5 gráficos analíticos se guardaron en la carpeta: {CARPETA_GRAFICOS}")
