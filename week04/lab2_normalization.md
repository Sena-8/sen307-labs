# Lab 2: Database Design and Normalization

**Course:** VUA-SEN307 Database Systems
**Name:** Dzeremo Thelma Senater
**Matric number:** VUG/SEN/24/11274
**Scenario:** University course-registration system (Students, Courses, Lecturers, Departments, Enrolments)

---

## 1. Unnormalized table

| matric_no | student_name | student_dept | course_codes | course_titles | lecturers | lecturer_depts | session |
|---|---|---|---|---|---|---|---|
| 20231234 | Ada Obi | Software Engineering | SEN307, SEN301 | Database Systems, Software Architecture | Dr A. Okafor, Dr M. Bello | Software Eng., Software Eng. | 2026/2027 |
| 20231235 | John Musa | Computer Science | SEN307, COS301 | Database Systems, Operating Systems | Dr A. Okafor, Mrs F. Eze | Software Eng., Computer Sci. | 2026/2027 |
| 20231236 | Grace Okon | Software Engineering | SEN301 | Software Architecture | Dr M. Bello | Software Eng. | 2026/2027 |

**Problem:** several cells hold more than one value (for example `course_codes`), and the same department is spelled two different ways ("Software Engineering" and "Software Eng.").

---

## 2. First Normal Form (1NF)

Primary key: **(matric_no, course_code)** (no single column is unique on its own).

| matric_no | student_name | student_dept | course_code | course_title | lecturer | lecturer_dept | session |
|---|---|---|---|---|---|---|---|
| 20231234 | Ada Obi | Software Engineering | SEN307 | Database Systems | Dr A. Okafor | Software Eng. | 2026/2027 |
| 20231234 | Ada Obi | Software Engineering | SEN301 | Software Architecture | Dr M. Bello | Software Eng. | 2026/2027 |
| 20231235 | John Musa | Computer Science | SEN307 | Database Systems | Dr A. Okafor | Software Eng. | 2026/2027 |
| 20231235 | John Musa | Computer Science | COS301 | Operating Systems | Mrs F. Eze | Computer Sci. | 2026/2027 |
| 20231236 | Grace Okon | Software Engineering | SEN301 | Software Architecture | Dr M. Bello | Software Eng. | 2026/2027 |

**What I fixed:** I split the multi-valued cells so every row holds exactly one student-course pair, and chose (matric_no, course_code) as the composite primary key.

---

## 3. Second Normal Form (2NF)

Partial dependencies found (attributes that depend on only part of the key):

- `student_name` and `student_dept` depend only on `matric_no`.
- `course_title` depends only on `course_code`.
- `lecturer` and `lecturer_dept` depend on the course (and session), not on the student.

**Student**

| matric_no (PK) | student_name | student_dept |
|---|---|---|
| 20231234 | Ada Obi | Software Engineering |
| 20231235 | John Musa | Computer Science |
| 20231236 | Grace Okon | Software Engineering |

**Course**

| course_code (PK) | course_title |
|---|---|
| SEN307 | Database Systems |
| SEN301 | Software Architecture |
| COS301 | Operating Systems |

**Course_Lecturer**

| course_code (PK, FK) | session (PK) | lecturer | lecturer_dept |
|---|---|---|---|
| SEN307 | 2026/2027 | Dr A. Okafor | Software Eng. |
| SEN301 | 2026/2027 | Dr M. Bello | Software Eng. |
| COS301 | 2026/2027 | Mrs F. Eze | Computer Sci. |

**Enrolment**

| matric_no (PK, FK) | course_code (PK, FK) | session |
|---|---|---|
| 20231234 | SEN307 | 2026/2027 |
| 20231234 | SEN301 | 2026/2027 |
| 20231235 | SEN307 | 2026/2027 |
| 20231235 | COS301 | 2026/2027 |
| 20231236 | SEN301 | 2026/2027 |

**What I fixed:** I moved every attribute that depended on only part of the composite key into its own table, giving Student, Course, Course_Lecturer and Enrolment.

---

## 4. Third Normal Form (3NF)

Transitive dependencies found (a non-key column depending on another non-key column):

- `student_dept` describes a department, not the student. If a department is renamed, every student row would need updating.
- `lecturer_dept` describes the lecturer's department, not the course.

**Department**

| dept_id (PK) | dept_name |
|---|---|
| 1 | Software Engineering |
| 2 | Computer Science |

**Student**

| student_id (PK) | matric_no | full_name | dept_id (FK) |
|---|---|---|---|
| 1 | 20231234 | Ada Obi | 1 |
| 2 | 20231235 | John Musa | 2 |
| 3 | 20231236 | Grace Okon | 1 |

**Lecturer**

| lecturer_id (PK) | full_name | dept_id (FK) |
|---|---|---|
| 1 | Dr A. Okafor | 1 |
| 2 | Dr M. Bello | 1 |
| 3 | Mrs F. Eze | 2 |

**Course**

| course_id (PK) | course_code | course_title |
|---|---|---|
| 1 | SEN307 | Database Systems |
| 2 | SEN301 | Software Architecture |
| 3 | COS301 | Operating Systems |

**Enrolment** (links Student and Course: a many-to-many relationship)

| enrolment_id (PK) | student_id (FK) | course_id (FK) | session |
|---|---|---|---|
| 1 | 1 | 1 | 2026/2027 |
| 2 | 1 | 2 | 2026/2027 |
| 3 | 2 | 1 | 2026/2027 |
| 4 | 2 | 3 | 2026/2027 |
| 5 | 3 | 2 | 2026/2027 |

**Teaching** (links Course and Lecturer per session: a many-to-many relationship)

| teaching_id (PK) | course_id (FK) | lecturer_id (FK) | session |
|---|---|---|---|
| 1 | 1 | 1 | 2026/2027 |
| 2 | 2 | 2 | 2026/2027 |
| 3 | 3 | 3 | 2026/2027 |

**What I fixed:** I moved department details into a Department table and linked to it with foreign keys, so each department is stored once. Lecturers got their own table, and a Teaching table records which lecturer teaches which course in which session.

---

## 5. Final schema

```
Department (dept_id PK, dept_name)
Student    (student_id PK, matric_no UNIQUE, full_name, dept_id FK -> Department)
Lecturer   (lecturer_id PK, full_name, dept_id FK -> Department)
Course     (course_id PK, course_code UNIQUE, course_title)
Enrolment  (enrolment_id PK, student_id FK -> Student, course_id FK -> Course, session)
Teaching   (teaching_id PK, course_id FK -> Course, lecturer_id FK -> Lecturer, session)
```

**Relationships**

- Department 1 : N Student
- Department 1 : N Lecturer
- Student M : N Course (through Enrolment)
- Course M : N Lecturer (through Teaching)
