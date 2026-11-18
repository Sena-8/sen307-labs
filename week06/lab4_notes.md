In Part 4 I got **Error 1451: Cannot delete or update a parent row: a foreign
key constraint fails** when I tried to delete the "Library and Information
Science" department. MySQL refuses because the Student table has a foreign key
on dept_id that points to Department, and the Transfer Student record still
references that department. If the department were deleted, the student would
be left pointing to a department that no longer exists (an orphan record),
which would break referential integrity.

I fixed it by first running an UPDATE to move the Transfer Student into the
Software Engineering department, so no student depended on the department
anymore, and then running the DELETE, which succeeded. The student was moved
rather than lost.

Another fix would have been to define the foreign key with ON DELETE CASCADE
(which deletes the dependent students automatically, so data would be lost) or
ON DELETE SET NULL (which sets their dept_id to NULL, so the students stay but
have no department). Alternatively, I could have deleted the dependent student
first and then the department.