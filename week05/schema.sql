   SHOW DATABASES;
   USE sen307_11274;
   SELECT DATABASE();
   
      CREATE TABLE Department (
   dept_id INT PRIMARY KEY AUTO_INCREMENT,
   dept_name VARCHAR(100) NOT NULL UNIQUE
   );

   CREATE TABLE Lecturer (
   lecturer_id INT PRIMARY KEY AUTO_INCREMENT,
   staff_no VARCHAR(20) NOT NULL UNIQUE,
   full_name VARCHAR(100) NOT NULL,
   email VARCHAR(100) UNIQUE,
   dept_id INT NOT NULL,
   FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
   );

   CREATE TABLE Student (
   student_id INT PRIMARY KEY AUTO_INCREMENT,
   matric_no VARCHAR(20) NOT NULL UNIQUE,
   full_name VARCHAR(100) NOT NULL,
   gender ENUM('M','F'),
   date_of_birth DATE,
   dept_id INT,
   FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
   );

   CREATE TABLE Course (
   course_id INT PRIMARY KEY AUTO_INCREMENT,
   course_code VARCHAR(10) NOT NULL UNIQUE,
   course_title VARCHAR(150) NOT NULL,
   credit_units TINYINT NOT NULL DEFAULT 3,
   description TEXT,
   dept_id INT,
   FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
   );

   CREATE TABLE Enrolment (
   enrolment_id INT PRIMARY KEY AUTO_INCREMENT,
   student_id INT NOT NULL,
   course_id INT NOT NULL,
   academic_session VARCHAR(9) NOT NULL DEFAULT '2026/2027',
   semester ENUM('First','Second') NOT NULL DEFAULT 'First',
   enrolled_on DATE DEFAULT (CURRENT_DATE),
   UNIQUE (student_id, course_id, academic_session),
   FOREIGN KEY (student_id) REFERENCES Student(student_id),
   FOREIGN KEY (course_id) REFERENCES Course(course_id)
   );

   CREATE TABLE CourseAllocation (
   allocation_id INT PRIMARY KEY AUTO_INCREMENT,
   course_id INT NOT NULL,
   lecturer_id INT NOT NULL,
   academic_session VARCHAR(9) NOT NULL DEFAULT '2026/2027',
   UNIQUE (course_id, lecturer_id, academic_session),
   FOREIGN KEY (course_id) REFERENCES Course(course_id),
   FOREIGN KEY (lecturer_id) REFERENCES Lecturer(lecturer_id)
   );

   ALTER TABLE Student ADD COLUMN phone VARCHAR(15) AFTER full_name;
   ALTER TABLE Course ADD CONSTRAINT chk_credit_units CHECK (credit_units BETWEEN 1 AND 6);