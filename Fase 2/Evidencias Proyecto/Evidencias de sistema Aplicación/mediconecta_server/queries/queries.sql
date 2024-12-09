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

DROP TABLE usuarios;

-- Para setear el valor del ID cuando es autoincrement
SELECT setval('usuarios_id_seq', (SELECT MAX(id) FROM usuarios));

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

CREATE TABLE ficha_medica (
    id SERIAL PRIMARY KEY,  -- Identificador único
    id_cita INT NOT NULL,  -- ID de la cita, referencia a la tabla de citas
    id_paciente INT NOT NULL,  -- ID del paciente, referencia a la tabla de pacientes
    id_doctor INT NOT NULL,  -- ID del doctor, referencia a la tabla de doctores

    motivo_consulta TEXT,  -- Motivo de la consulta
    peso DECIMAL(5, 2),  -- Peso en kg
    altura DECIMAL(5, 2),  -- Altura en cm
    presion_arterial VARCHAR(10),  -- Presión arterial (ej: "120/80")
    frecuencia_cardiaca INT,  -- Frecuencia cardíaca en ppm
    frecuencia_respiratoria INT,  -- Frecuencia respiratoria

    examen_fisico TEXT,  -- Descripción del examen físico
    diagnostico TEXT,  -- Diagnóstico del paciente
    tratamiento TEXT,  -- Detalles del tratamiento
    
    medicamento_1 VARCHAR(255),  -- Descripción del medicamento 1
    frecuencia_medicamento_1 INT,  -- Frecuencia del medicamento 1 (cada cuántas horas)
    dias_medicamento_1 INT,  -- Días del medicamento 1
    medicamento_2 VARCHAR(255),  -- Descripción del medicamento 2
    frecuencia_medicamento_2 INT,  -- Frecuencia del medicamento 2 (cada cuántas horas)
    dias_medicamento_2 INT,  -- Días del medicamento 2
    recordatorio TEXT,  -- Descripción del recordatorio
    frecuencia_recordatorio INT,  -- Repetir cada cuántos días
    dias_recordatorio INT  -- Días del recordatorio
);

CREATE TABLE recordatorios_medicamentos (
    id SERIAL PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_doctor INT NOT NULL,
    id_ficha_medica INT NOT NULL,
    desc_medicamento VARCHAR(100) NOT NULL,
    frecuencia INT, -- Frecuencia en horas, por ejemplo, cada 8 horas
    duracion_dias INT, -- Duración en días, por ejemplo, por 5 días
);

CREATE TABLE registro_salud (
    id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL,
    nivel_glucosa INT NOT NULL,
    presion_arterial INT NOT NULL,
    frecuencia_cardiaca INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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