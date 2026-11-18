USE sen307_11274;

SELECT 'Departments' AS tbl, COUNT(*) AS total FROM Department
UNION ALL SELECT 'Lecturers', COUNT(*) FROM Lecturer
UNION ALL SELECT 'Students', COUNT(*) FROM Student
UNION ALL SELECT 'Courses', COUNT(*) FROM Course
UNION ALL SELECT 'Enrolments', COUNT(*) FROM Enrolment
UNION ALL SELECT 'Allocations', COUNT(*) FROM CourseAllocation;

-- Task 1 (worked example): every student and their courses,-- including students with no enrolments
SELECT s.full_name, c.course_title
FROM Student s
LEFT JOIN Enrolment e ON s.student_id = e.student_id
LEFT JOIN Course c    
ON e.course_id  = c.course_id
ORDER BY s.full_name;

-- Task 2: Courses with their lecturers (INNER JOIN)
-- Explanation: Course and Lecturer are not linked directly, so the query goes
-- Course -> CourseAllocation -> Lecturer using two INNER JOINs. INNER JOIN
-- keeps only rows with a match on both sides. SEN307 appears twice because
-- two lecturers teach it.
SELECT c.course_code, c.course_title, l.full_name AS lecturer
FROM Course c
INNER JOIN CourseAllocation ca ON c.course_id = ca.course_id
INNER JOIN Lecturer l ON ca.lecturer_id = l.lecturer_id
ORDER BY c.course_code, l.full_name;

-- Task 3: Students and their courses (LEFT JOIN)
-- Explanation: LEFT JOIN keeps every row from the left table (Student), even
-- when there is no matching enrolment. For those students the course_title
-- column shows NULL.
SELECT s.full_name, c.course_title
FROM Student s
LEFT JOIN Enrolment e ON s.student_id = e.student_id
LEFT JOIN Course c ON e.course_id = c.course_id
ORDER BY s.full_name;

-- Task 3 (part 2): only the students with no courses
-- Explanation: Same query as above, but WHERE c.course_title IS NULL keeps
-- only the students who have no enrolment.
SELECT s.full_name, c.course_title
FROM Student s
LEFT JOIN Enrolment e ON s.student_id = e.student_id
LEFT JOIN Course c ON e.course_id = c.course_id
WHERE c.course_title IS NULL
ORDER BY s.full_name;

-- Task 4: Filtering with AND / OR / IN / BETWEEN
-- Explanation: This query combines AND, IN and BETWEEN. It returns female
-- students in Software Engineering (dept 1) or Artificial Intelligence
-- (dept 3) who were born between 2004-01-01 and 2005-12-31. IN replaces
-- "dept_id = 1 OR dept_id = 3", and BETWEEN includes both end dates.
SELECT matric_no, full_name, gender, date_of_birth, dept_id
FROM Student
WHERE gender = 'F'
  AND dept_id IN (1, 3)
  AND date_of_birth BETWEEN '2004-01-01' AND '2005-12-31'
ORDER BY full_name;

-- Task 5: Paginating enrolments with LIMIT and OFFSET
-- Explanation: LIMIT 10 returns 10 rows at a time and OFFSET skips rows
-- already shown. Page 1 starts at OFFSET 0, page 2 at OFFSET 10.
-- ORDER BY is required with LIMIT because without it MySQL does not
-- guarantee any row order, so pages could repeat or skip rows.

-- Page 1 (rows 1-10)
SELECT enrolment_id, student_id, course_id
FROM Enrolment
ORDER BY enrolment_id
LIMIT 10 OFFSET 0;

-- Page 2 (rows 11-20)
SELECT enrolment_id, student_id, course_id
FROM Enrolment
ORDER BY enrolment_id
LIMIT 10 OFFSET 10;

-- Challenge: Task 3 rewritten with RIGHT JOIN
-- Explanation: RIGHT JOIN keeps every row from the right table. Starting from
-- Course and working right, Student is last, so all students are kept and the
-- result is the same as the LEFT JOIN version.
SELECT s.full_name, c.course_title
FROM Course c
RIGHT JOIN Enrolment e ON c.course_id = e.course_id
RIGHT JOIN Student s ON e.student_id = s.student_id
ORDER BY s.full_name;
-- Which is easier to read? The LEFT JOIN version. It starts with Student, the
-- main table, and follows the data in a natural order. The RIGHT JOIN version
-- has to start from Course and read backwards to reach Student.