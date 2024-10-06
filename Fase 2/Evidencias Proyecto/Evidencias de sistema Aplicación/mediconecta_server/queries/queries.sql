-- CREATE TABLES

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    fecha_nacimiento DATE,
    genero VARCHAR(10),
    tipo_usuario VARCHAR(50) NOT NULL, -- Puede ser 'paciente' o 'doctor'
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE usuarios
ADD COLUMN password VARCHAR(255) NOT NULL;

CREATE TABLE especialidades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL -- Ejemplo: 'Cardiología', 'Pediatría', etc.
);


CREATE TABLE doctores (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE, -- Relación con la tabla de usuarios
    licencia_medica VARCHAR(50) NOT NULL,
    direccion_consulta VARCHAR(200),
    especialidad_id INT REFERENCES especialidades(id) ON DELETE SET NULL, -- Relación con la tabla de especialidades
    UNIQUE (usuario_id)  -- Garantiza que un usuario solo pueda ser asociado con un doctor
);


CREATE TABLE disponibilidades (
    id SERIAL PRIMARY KEY,
    doctor_id INT REFERENCES doctores(id) ON DELETE CASCADE, -- Relación con la tabla de doctores
    fecha DATE NOT NULL, -- Fecha específica de la disponibilidad
    hora_inicio TIME NOT NULL, -- Hora de inicio de la disponibilidad
    hora_fin TIME NOT NULL, -- Hora de fin de la disponibilidad
    UNIQUE (doctor_id, fecha, hora_inicio, hora_fin) -- Garantiza que no haya solapamiento en la disponibilidad
);


CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES usuarios(id) ON DELETE CASCADE, -- Relación con la tabla de usuarios (paciente)
    doctor_id INT REFERENCES doctores(id) ON DELETE CASCADE,   -- Relación con la tabla de doctores
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    motivo TEXT, -- Razón de la cita
    estado VARCHAR(50) DEFAULT 'pendiente' -- Estado de la cita (pendiente, confirmada, cancelada, etc.)
);


-- INSERTS

INSERT INTO usuarios (nombre, email, telefono, fecha_nacimiento, genero, tipo_usuario)
VALUES ('Juan Pérez', 'juan.perez@example.com', '555-1234', '1970-01-15', 'M', 'paciente');

INSERT INTO usuarios (nombre, email, telefono, fecha_nacimiento, genero, tipo_usuario)
VALUES ('Dra. Maria López', 'maria.lopez@example.com', '555-5678', '1980-03-22', 'F', 'doctor');

INSERT INTO especialidades (nombre) VALUES ('Cardiología');
INSERT INTO especialidades (nombre) VALUES ('Pediatría');

INSERT INTO doctores (usuario_id, licencia_medica, direccion_consulta, especialidad_id)
VALUES (2, 'LIC-123456', 'Av. Siempre Viva 742', 1); -- Relaciona con la Dra. Maria López y Cardiología

INSERT INTO disponibilidades (doctor_id, fecha, hora_inicio, hora_fin)
VALUES (1, '2024-08-21', '09:00:00', '12:00:00');

INSERT INTO disponibilidades (doctor_id, fecha, hora_inicio, hora_fin)
VALUES (1, '2024-08-22', '14:00:00', '17:00:00');

INSERT INTO citas (paciente_id, doctor_id, fecha, hora, motivo)
VALUES (1, 1, '2023-08-21', '09:30:00', 'Consulta de rutina');