CREATE TABLE IF NOT EXISTS backups_log (
    id SERIAL PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nota TEXT
);

INSERT INTO backups_log (nota) VALUES ('Tabla backups_log creada.');