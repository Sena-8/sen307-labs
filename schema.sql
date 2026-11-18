-- =====================================================================
-- VUA-SEN307 Week 6 Practical: Lab 4 (DML)
-- File: data.sql
-- =====================================================================
USE sen307_11274;

-- ---------------------------------------------------------------------
-- RESET: empties the tables (structure stays) and restarts the ID
-- counters at 1 so the IDs used below are correct.
-- ---------------------------------------------------------------------
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE CourseAllocation;
TRUNCATE TABLE Enrolment;
TRUNCATE TABLE Student;
TRUNCATE TABLE Lecturer;
TRUNCATE TABLE Course;
TRUNCATE TABLE Department;
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

-- =====================================================================
-- PART 1: Departments and Courses (provided)
-- Each description is on ONE line (Weeks 12-13 search these).
-- =====================================================================
INSERT INTO Department (dept_name) VALUES
('Software Engineering'),
('Computer Science'),
('Artificial Intelligence'),
('Data Science'),
('Cybersecurity');

INSERT INTO Course (course_code, course_title, credit_units, description, dept_id) VALUES
('SEN307', 'Database Systems', 3,
'Relational database design, SQL queries, normalization, transactions and indexing using MySQL.',
(SELECT dept_id FROM Department WHERE dept_name = 'Software Engineering')),
('SEN301', 'Software Architecture', 3,
'Architectural styles, design patterns, microservices and how to structure large software systems.',
(SELECT dept_id FROM Department WHERE dept_name = 'Software Engineering')),
('COS301', 'Operating Systems', 3,
'Processes, threads, CPU scheduling, memory management and file systems.',
(SELECT dept_id FROM Department WHERE dept_name = 'Computer Science')),
('COS305', 'Computer Networks', 3,
'TCP/IP, routing, switching, LAN and WAN design and network protocols.',
(SELECT dept_id FROM Department WHERE dept_name = 'Computer Science')),
('AIN301', 'Introduction to Artificial Intelligence', 3,
'Intelligent agents, search algorithms, knowledge representation and reasoning.',
(SELECT dept_id FROM Department WHERE dept_name = 'Artificial Intelligence')),
('AIN305', 'Machine Learning', 3,
'Supervised and unsupervised learning, neural networks, deep learning and model evaluation.',
(SELECT dept_id FROM Department WHERE dept_name = 'Artificial Intelligence')),
('AIN307', 'Natural Language Processing', 3,
'Text processing, word embeddings, language models, sentiment analysis and chatbots.',
(SELECT dept_id FROM Department WHERE dept_name = 'Artificial Intelligence')),
('DTS301', 'Data Visualization and Analytics', 2,
'Exploratory data analysis, charts, dashboards and telling stories with data.',
(SELECT dept_id FROM Department WHERE dept_name = 'Data Science')),
('DTS305', 'Big Data Technologies', 3,
'Distributed storage and processing of very large datasets with Hadoop and Spark.',
(SELECT dept_id FROM Department WHERE dept_name = 'Data Science')),
('CYB301', 'Network Security', 3,
'Firewalls, cryptography, intrusion detection and protecting networks from attacks.',
(SELECT dept_id FROM Department WHERE dept_name = 'Cybersecurity'));

-- Check: 5 departments, 10 courses in total
SELECT d.dept_name, COUNT(c.course_id) AS courses
FROM Department d LEFT JOIN Course c ON d.dept_id = c.dept_id
GROUP BY d.dept_name;

-- IDs must be departments 1-5 and courses 1-10 (SEN307 = 1 ... CYB301 = 10)
SELECT dept_id, dept_name FROM Department;
SELECT course_id, course_code FROM Course;

-- =====================================================================
-- PART 2: Your own data
-- =====================================================================

-- Step 1: Lecturers (10), two per department
INSERT INTO Lecturer (staff_no, full_name, email, dept_id) VALUES
('VUA/ST/101', 'Dr Amaka Okafor',     'a.okafor@vua.edu.ng',     1),
('VUA/ST/102', 'Dr Musa Bello',       'm.bello@vua.edu.ng',      1),
('VUA/ST/103', 'Prof Ngozi Eze',      'n.eze@vua.edu.ng',        2),
('VUA/ST/104', 'Dr Ibrahim Yusuf',    'i.yusuf@vua.edu.ng',      2),
('VUA/ST/105', 'Dr Chinedu Nwosu',    'c.nwosu@vua.edu.ng',      3),
('VUA/ST/106', 'Dr Fatima Abdullahi', 'f.abdullahi@vua.edu.ng',  3),
('VUA/ST/107', 'Dr Tunde Adebayo',    't.adebayo@vua.edu.ng',    4),
('VUA/ST/108', 'Dr Blessing Ojo',     'b.ojo@vua.edu.ng',        4),
('VUA/ST/109', 'Dr Emeka Okonkwo',    'e.okonkwo@vua.edu.ng',    5),
('VUA/ST/110', 'Dr Halima Sani',      'h.sani@vua.edu.ng',       5);

-- Step 2: Students (20). Row 1 is YOU (student_id 1).
INSERT INTO Student (matric_no, full_name, gender, date_of_birth, dept_id) VALUES
('11274',    'Dzeremo Themla Senater', 'F', '2008-03-08', 1),
('20231301', 'Ada Obi',                'F', '2005-03-14', 1),
('20231302', 'John Musa',              'M', '2004-11-02', 2),
('20231303', 'Chioma Nnamdi',          'F', '2003-07-21', 2),
('20231304', 'Abdul Lawal',            'M', '2006-01-09', 3),
('20231305', 'Zainab Garba',           'F', '2005-09-30', 3),
('20231306', 'Oluwaseun Ajayi',        'M', '2004-02-18', 4),
('20231307', 'Ifeoma Chukwu',          'F', '2006-06-25', 4),
('20231308', 'Peter Danjuma',          'M', '2003-12-05', 5),
('20231309', 'Hauwa Suleiman',         'F', '2007-04-12', 5),
('20231310', 'Kelechi Okeke',          'M', '2005-08-19', 1),
('20231311', 'Blessing Akpan',         'F', '2004-10-03', 1),
('20231312', 'Samuel Ibe',             'M', '2006-03-27', 2),
('20231313', 'Aisha Mohammed',         'F', '2005-12-15', 3),
('20231314', 'David Ogunleye',         'M', '2003-05-08', 4),
('20231315', 'Mercy Ekong',            'F', '2007-01-22', 5),
('20231316', 'Yakubu Haruna',          'M', '2004-07-14', 2),
('20231317', 'Grace Amadi',            'F', '2006-09-06', 1),
('20231318', 'Tochukwu Eze',           'M', '2005-11-29', 3),
('20231319', 'Rukayya Bala',           'F', '2003-02-17', 4);

-- Step 3: check IDs (students 1-20 with you as 1, lecturers 1-10)
SELECT student_id, matric_no, full_name FROM Student;
SELECT lecturer_id, full_name FROM Lecturer;

-- Enrolments (40). Students 19 and 20 are left out on purpose
-- (no enrolments, needed for LEFT JOIN labs). Course 1 has 8 students.
INSERT INTO Enrolment (student_id, course_id) VALUES
(1,1),(1,2),(1,5),
(2,1),(2,2),(2,6),
(3,1),(3,3),(3,4),
(4,1),(4,3),(4,8),
(5,1),(5,5),
(6,1),(6,7),
(7,1),(7,9),
(8,1),(8,10),
(9,2),(9,10),
(10,2),(10,9),
(11,2),(11,3),
(12,3),(12,4),
(13,4),(13,8),
(14,5),(14,6),
(15,6),(15,7),
(16,7),(16,8),
(17,9),(17,10),
(18,4),(18,5);

-- Course allocations (11). Course 1 has TWO lecturers (1 and 2).
INSERT INTO CourseAllocation (course_id, lecturer_id) VALUES
(1,1),(1,2),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,5),
(8,7),
(9,8),
(10,10);

-- =====================================================================
-- PART 3: UPDATE a record (move YOU to Computer Science, dept 2)
-- =====================================================================
SELECT matric_no, full_name, dept_id FROM Student WHERE matric_no = '11274';

SET SQL_SAFE_UPDATES = 0;
UPDATE Student SET dept_id = 2 WHERE matric_no = '11274';
SET SQL_SAFE_UPDATES = 1;

SELECT matric_no, full_name, dept_id FROM Student WHERE matric_no = '11274';

-- =====================================================================
-- PART 4: Referential integrity
-- =====================================================================
-- Step 1: create a department that has a student in it
INSERT INTO Department (dept_name) VALUES ('Library and Information Science');

INSERT INTO Student (matric_no, full_name, dept_id)
VALUES ('20239999', 'Transfer Student',
(SELECT dept_id FROM Department WHERE dept_name = 'Library and Information Science'));

-- Step 2: this DELETE is MEANT to fail with Error 1451.
-- Run it ALONE and screenshot the error.
DELETE FROM Department WHERE dept_name = 'Library and Information Science';

-- Step 3: the correct fix. Move the student first, then delete.
SET SQL_SAFE_UPDATES = 0;
UPDATE Student
SET dept_id = (SELECT dept_id FROM Department WHERE dept_name = 'Software Engineering')
WHERE matric_no = '20239999';

DELETE FROM Department WHERE dept_name = 'Library and Information Science';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM Department;   -- back to 5 departments

-- =====================================================================
-- FINAL CHECK: screenshot this result
-- =====================================================================
SELECT 'Departments' AS tbl, COUNT(*) AS total FROM Department
UNION ALL SELECT 'Lecturers', COUNT(*) FROM Lecturer
UNION ALL SELECT 'Students', COUNT(*) FROM Student
UNION ALL SELECT 'Courses', COUNT(*) FROM Course
UNION ALL SELECT 'Enrolments', COUNT(*) FROM Enrolment
UNION ALL SELECT 'Allocations', COUNT(*) FROM CourseAllocation;