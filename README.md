# sql-week8

# Clinic Booking System Database

## Project Description

This is a comprehensive database management system for a medical clinic that handles patient records, doctor information, appointment scheduling, and clinic administration. The system is designed to efficiently manage all of the clinic's operations.

## Features

- Patient management with demographic and contact information
- Doctor profiles with specialty assignments
- Appointment scheduling with status tracking
- Medical record keeping
- Clinic room management
- Staff administration

## Database Schema

The database consists of 10 related tables:

1. `specialties` - Medical specialties offered
2. `doctors` - Doctor information
3. `patients` - Patient records
4. `appointment_status` - Appointment state tracking
5. `appointments` - Booking information
6. `medical_records` - Patient health history
7. `clinic_staff` - Non-doctor staff
8. `clinic_rooms` - Consultation rooms
9. `room_assignments` - Room bookings
10. `appointment_status` - Status lookup table

## Setup Instructions

1. Ensure you have MySQL installed and running
2. Execute the SQL script to create the database:
   ```bash
   mysql -u username -p < clinic_booking_system.sql
   ```

## Benchmark Usage

### Preparation

```sql
-- Create test data (10,000 sample patients)
INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone)
SELECT
    CONCAT('Patient', n),
    CONCAT('Lastname', FLOOR(RAND() * 100)),
    DATE_ADD('1950-01-01', INTERVAL FLOOR(RAND() * 70*365) DAY),
    IF(RAND() > 0.5, 'Male', 'Female'),
    CONCAT('555-', FLOOR(100 + RAND() * 900), '-', FLOOR(1000 + RAND() * 9000))
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 AS n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) a
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) b
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) c
    CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) d
) numbers
LIMIT 10000;
```
