from mcp.server.fastmcp import FastMCP
import subprocess
import sys
from pathlib import Path
import urllib.request
import json
from datetime import datetime
# Webhook
N8N_WEBHOOK_URL = "http://localhost:5678/webhook-test/notificacion"
mcp = FastMCP("N8N Backup Manager")
BASE_DIR = Path(__file__).parent
SCRIPT_PATH = BASE_DIR / "backup_n8ndb.py"
BACKUPS_DIR = BASE_DIR / "backups_n8n"
def notificar_a_n8n(es_exito: bool, detalle: str):
    try:
        payload = {
            "success": es_exito, # leer nodo IF
            "message": detalle # envío de Telegram
        }
        data = json.dumps(payload).encode('utf-8')
        req = urllib.request.Request(
            N8N_WEBHOOK_URL,
            data=data,
            headers={'Content-Type': 'application/json'}
        )
        with urllib.request.urlopen(req) as response:
            return response.status
    except Exception as e:
        print(f"Error al conectar con n8n: {e}")
@mcp.tool()
def realizar_backup_manual() -> str:
    if not SCRIPT_PATH.exists():
        return "❌ Error: Script de backup no encontrado."
    try:
        result = subprocess.run(
            [sys.executable, str(SCRIPT_PATH)],
            capture_output=True,
            text=True
        )
        salida = result.stdout.strip()
        if result.returncode == 0:
            mensaje = (
                "✅ Backup OK\n"
                f"{salida}\n"
                f"Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
            )
            notificar_a_n8n(True, mensaje)
            return mensaje
        else:
            error = result.stderr.strip()
            mensaje = f"❌ Backup ERROR\n{error}"
            notificar_a_n8n(False, mensaje)
            return mensaje
    except Exception as e:
        mensaje = f"❌ Error crítico: {str(e)}"
        notificar_a_n8n(False, mensaje)
        return mensaje

@mcp.tool()
def simular_error_backup() -> str:
    """Simula un fallo en el proceso para probar las alertas de n8n."""
    mensaje = "❌ Error SIMULADO (Prueba de sistema)"
    notificar_a_n8n(False, mensaje)
    return mensaje

# ... (mantén tu función listar_backups_existentes)
# herramienta para listar
@mcp.tool()
def listar_backups_existentes() -> str:
    if not BACKUPS_DIR.exists(): return "No hay carpeta de backups."
    archivos = list(BACKUPS_DIR.glob("*.sql"))
    if not archivos: return "Carpeta vacía."
    archivos.sort(key=lambda x: x.stat().st_mtime, reverse=True)
    reporte = [f"🗂 Encontrados {len(archivos)} backups:\n"]
    for f in archivos:
        dt = datetime.fromtimestamp(f.stat().st_mtime).strftime('%Y-%m-%d %H:%M')
        sz = f.stat().st_size / (1024 * 1024)
        reporte.append(f"- {f.name} ({dt} | {sz:.2f} MB)")
    return "\n".join(reporte)
# herramienta para simular errores
if __name__ == "__main__":
    mcp.run()