import os
import shutil
import subprocess
import psycopg2
from pathlib import Path
from datetime import datetime
# =========================
# VARIABLES DE ENTORNO (A COMPLETAR POR TI)
# =========================
# TODO: debes definir/asegurar estas variables de entorno (DB_POSTGRESDB_...)
DB_HOST = os.getenv("DB_POSTGRESDB_HOST") # <-
- debe existir en el entorno
DB_PORT = os.getenv("DB_POSTGRESDB_PORT") # <-
- debe existir en el entorno
DB_NAME = os.getenv("DB_POSTGRESDB_DATABASE") # <-
- debe existir en el entorno
DB_USER = os.getenv("DB_POSTGRESDB_USER") # <-
- debe existir en el entorno
DB_PASSWORD = os.getenv("DB_POSTGRESDB_PASSWORD") # <-
- debe existir en el entorno
# Directorio donde se guardarán los .sql (el alumno puede elegir la ruta)
BACKUP_DIR = Path(os.getenv("BACKUP_DIR", str(Path.home() / "backups_n8n")))
BACKUP_DIR.mkdir(parents=True, exist_ok=True)
print("HOME:", Path.home())
print("BACKUP_DIR:", BACKUP_DIR)
# =========================
# BACKUP FILE (A COMPLETAR POR TI)
# =========================
# Aquí debes generar un "timestamp" (fecha/hora) para que cada backup tenga nombre único.
# Ejemplo de formato recomendado: YYYY-MM-DD_HH-MM-SS
# timestamp = ...
#
# Aquí debes construir el nombre del fichero .sql usando:
# - el nombre de la base de datos (DB_NAME)
# - el timestamp generado
# - la extensión .sql
timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
backup_file = BACKUP_DIR / f"backup_{DB_NAME}_{timestamp}.sql"
print("BACKUP_FILE:", backup_file)
# =========================
# COMPROBAR pg_dump
# =========================
# Verificamos que la herramienta pg_dump está instalada y accesible desde PATH
.
# Si no existe, abortamos la ejecución porque no se puede crear el backup real
.
if shutil.which("pg_dump") is None:
nota = "Backup ERROR — pg_dump no está disponible en PATH"
print("STATUS=NOK")
print(f"FILE={backup_file}")
print(f"MESSAGE={nota}")
raise SystemExit(1)
# =========================
# EJECUTAR pg_dump
# =========================
# Se construye el comando del sistema para volcar la base de datos a un ficher
o .sql
cmd = [
"pg_dump",
"-h", DB_HOST,
"-p", DB_PORT,
"-U", DB_USER,
"-d", DB_NAME,
"-f", str(backup_file),
]
# Aquí se prepara el "entorno" que se le pasará al proceso pg_dump.
# La idea es añadir una variable de entorno llamada PGPASSWORD con DB_PASSWORD
# para que pg_dump pueda autenticarse sin pedir la contraseña por teclado.
# (Se hace en una copia del entorno para no modificar el entorno global del sistema.)
#
env = os.environ.copy() # <- copia del entorno actual
env["PGPASSWORD"] = DB_PASSWORD # <- contraseña para pg_dump (no interactivo)
# Ejecutamos el comando y capturamos salida (stdout) y errores (stderr)
result = subprocess.run(cmd, env=env, capture_output=True, text=True)
# =========================
# RESULTADO FINAL
# =========================
# En este punto, el script debe decidir si el backup ha sido OK o NOK:
#
# - Si result.returncode == 0 (OK):
# - "nota" debe contener un mensaje claro de éxito.
# - Debe incluir el nombre del fichero creado (backup_file.name) para trazabilidad.
# - Se recomienda imprimir una línea humana tipo: "Backup OK → <ruta>"
#
# - Si result.returncode != 0 (NOK):
# - "nota" debe contener un mensaje claro de error.
# - Debe incluir el motivo del fallo (result.stderr) para depurar.
# - Se recomienda imprimir una línea humana tipo: "Backup ERROR → <stderr>"
#
# (debes implementar el if/else real siguiendo estas reglas.)
# Placeholder mínimo para que el resto del script funcione
# =========================
# REGISTRAR EN POSTGRESQL
# =========================
# Guardamos SIEMPRE el resultado del backup (OK o ERROR) en la tabla backups_log
conn = psycopg2.connect(
host=DB_HOST, port=DB_PORT,
dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD
)
cur = conn.cursor()
cur.execute("INSERT INTO backups_log (nota) VALUES (%s);", (nota,))
conn.commit()
cur.close()
conn.close()
print(nota)