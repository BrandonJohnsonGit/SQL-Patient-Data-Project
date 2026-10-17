SELECT * FROM health_data.ocd_patient;
USE health_data;

-- Count of patients by gender and average obs score --

SELECT
	Gender,
    COUNT(`Patient ID`) AS patient_count,
    ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2) AS avg_obs_score
FROM ocd_patient
GROUP BY Gender;


-- From 1 above, calculate the patient_count percentages -- 


WITH gender_count AS 
	(SELECT
		Gender,
		COUNT(`Patient ID`) AS patient_count,
		ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2) AS avg_obs_score
FROM ocd_patient
GROUP BY Gender),
total AS
	(SELECT 
		SUM(patient_count) AS total_count
	FROM gender_count)
SELECT
	g.Gender, 
	g.patient_count,
	g.avg_obs_score,
	ROUND((patient_count/t.total_count) * 100, 2) AS percentage
FROM gender_count g
JOIN total t;


-- Count the patients MoM --
set sql_safe_updates = 0;

UPDATE ocd_patient
SET `OCD Diagnosis Date` = str_to_date(`OCD Diagnosis Date`, '%m/%d/%Y')
WHERE str_to_date(`OCD Diagnosis Date`, '%m/%d/%Y') is not null;

ALTER TABLE ocd_patient
MODIFY COLUMN `OCD Diagnosis Date` DATE;

SELECT
	date_format(`OCD Diagnosis Date`, '%Y-%m-01 00:00:00') AS month,
    COUNT(`Patient ID`) as patient_count
FROM ocd_patient
GROUP BY month
ORDER BY month;


-- most common obs type and avg obs score --
    
SELECT
	`Obsession Type`,
    COUNT(`Patient ID`) AS patient_count,
    ROUND(AVG(`Y-BOCS Score (Obsessions)`), 2) AS avg_obs_score
FROM ocd_patient
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


-- most common comp type and avg comp score --

SELECT
	`Compulsion Type`,
    COUNT(`Patient ID`) AS patient_count,
    ROUND(AVG(`Y-BOCS Score (Compulsions)`), 2) AS avg_comp_score
FROM ocd_patient
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

