-- Clinic management system database
-- Create a database for a clinic management system
create database salesDB;
use salesDB;


-- Table for storing specialties
-- This table will store the different medical specialties offered at the clinic
CREATE TABLE specialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Medical specialties offered at the clinic';


-- Table for doctors
-- This table will store information about doctors working at the clinic
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialty_id INT NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_doctor_email CHECK (email LIKE '%@%.%')
) COMMENT 'Doctors working at the clinic';

-- Table for patients
-- This table will store information about patients registered at the clinic
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_patient_email CHECK (email LIKE '%@%.%' OR email IS NULL),
    CONSTRAINT chk_patient_age CHECK (date_of_birth <= DATE('1900-01-01'))
) COMMENT 'Patients registered at the clinic';


-- Table for appointments
-- This table will store information about appointments made by patients
CREATE TABLE appointment_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT
) COMMENT 'Possible statuses for appointments';

-- Table for appointment statuses
-- This table will store the different statuses an appointment can have
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status_id INT NOT NULL DEFAULT 1, -- Default to 'Scheduled'
    reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (status_id) REFERENCES appointment_status(status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_appointment_time CHECK (end_time > start_time),
  -- Ensure that the appointment does not overlap with existing appointments
    CONSTRAINT uc_doctor_timeslot UNIQUE (doctor_id, appointment_date, start_time)
) COMMENT 'Appointment bookings between patients and doctors';

-- Table for appointment history
-- This table will store the history of appointments for patients
CREATE TABLE medical_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT,
    notes TEXT,
    record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) COMMENT 'Medical records and history for patients';

-- Table for clinic staff
-- This table will store information about non-doctor staff working at the clinic
CREATE TABLE clinic_staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_staff_email CHECK (email LIKE '%@%.%')
) COMMENT 'Non-doctor staff working at the clinic';


-- Table for clinic rooms
-- This table will store information about the rooms available in the clinic
CREATE TABLE clinic_rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    floor INT NOT NULL,
    specialty_id INT,
    capacity INT DEFAULT 1,
    available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) COMMENT 'Consultation rooms in the clinic';

-- Table for room assignments
-- This table will store the assignments of rooms to appointments
CREATE TABLE room_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    room_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES clinic_rooms(room_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT uc_appointment_room UNIQUE (appointment_id)
) COMMENT 'Room assignments for appointments';



-- Insert initial data for appointment statuses
INSERT INTO appointment_status (status_name, description) VALUES
('Scheduled', 'Appointment is booked and confirmed'),
('Completed', 'Appointment has been completed'),
('Cancelled', 'Appointment was cancelled by patient or clinic'),
('No-Show', 'Patient did not arrive for appointment'),
('Rescheduled', 'Appointment was moved to another time');

-- Insert sample medical specialties
INSERT INTO specialties (specialty_name, description) VALUES
('General Practice', 'Primary care and general health services'),
('Cardiology', 'Heart and cardiovascular system specialists'),
('Dermatology', 'Skin, hair, and nail conditions'),
('Pediatrics', 'Medical care for infants, children, and adolescents'),
('Orthopedics', 'Musculoskeletal system specialists');

-- Create indexes for better performance
CREATE INDEX idx_doctor_specialty ON doctors(specialty_id);
CREATE INDEX idx_appointment_patient ON appointments(patient_id);
CREATE INDEX idx_appointment_doctor ON appointments(doctor_id);
CREATE INDEX idx_appointment_date ON appointments(appointment_date);
CREATE INDEX idx_medical_record_patient ON medical_records(patient_id);