USE cedar_valley_medical;
# Q1 Determine the total number of patients in Cedar Valley’s network.
# How many patients does Cedar Valley currently have registered in total? 
SELECT count(patient_id)
FROM patients;

#Q2 Break down the patient count by insurance provider, sorted from most to least common. 
# Which provider is most common? Least common? How many patients do each have?
SELECT count(patient_id), insurance_provider
FROM patients
GROUP BY insurance_provider
ORDER BY count(patient_id) DESC;

#Q3 Examine whether any seasonal trends appear in the total number of appointments when aggregated by month and year. 
# Identify which months and years in 2023 and 2024 recorded the highest appointment volumes. 
# Specifically when looking at the top ten month‑year combinations, determine whether any notable patterns emerge and provide an explanation on what you find.
# In your output, return the year, month number, and total appointment count for each month‑year combination, ordered from the highest to the lowest number of appointments.

SELECT COUNT(*), YEAR(appointment_date), MONTH(appointment_date)
FROM Appointments
GROUP BY YEAR(appointment_date), MONTH(appointment_date)
ORDER BY COUNT(*) DESC;

#Q4 Which patients have had more than 3 appointments in total (across any status)? 
# List their full name and total appointment count, sorted by count descending. 
# Who is the patient with the most, and how many appointments did they have?
SELECT CONCAT(p.first_name,'',p.last_name) AS fullname, COUNT(a.Appointment_id) AS totalappointments
FROM Patients p 
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(a.appointment_id) >= 3
ORDER BY totalappointments DESC; 

#Q5 Which patients have had more than 3 appointments in total (across any status)? 
# What is the total amount?
SELECT  p.patient_id, COUNT(a.Appointment_id) AS totalappointments
FROM Patients p 
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(a.appointment_id) >= 3
ORDER BY totalappointments DESC; 

SELECT COUNT(p.patient_id)
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE p.patient_id IN (
	SELECT p.patient_id
	FROM appointments
    GROUP BY p.patient_id
	HAVING COUNT(*) > 3);

#Q6 Who are the 3 least busiest doctors at the clinic, measured by number of completed appointments? 
# What are their names and how many completed appointments did they each have?
SELECT CONCAT(d.first_name,'',d.last_name) AS doctor_name, dp.department_name, COUNT(a.status) AS total_completed
FROM doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN departments dp ON d.department_id = dp.department_id
WHERE a.status = 'Completed'
GROUP BY doctor_name,  dp.department_name
ORDER BY doctor_name
LIMIT 3;

#Q7 The COO is considering a deeper partnership with 'Blue' insurance networks (e.g., Blue Cross Blue Shield). 
# Find all patients whose insurance provider contains the word 'Blue'. 
# Then break down those patients by city and count how many there are per city.
# What cities appear? What is the most common number of patients for these cities? 
# Based on the result what would you recommend to the COO?
 
SELECT city, COUNT(*) AS blue_patients
FROM patients
WHERE insurance_provider LIKE '%Blue%'
GROUP BY city, insurance_provider
ORDER BY blue_patients;

SELECT * 
FROM insurance_provider ;




