-- consulta con los nombres de los cursos:
SELECT 
    s.students_id AS student_id,
    s.students_name AS student_name,
    GROUP_CONCAT(c.courses_name ORDER BY c.courses_name) AS enrolled_courses
FROM 
    students s
JOIN 
    grades g ON s.students_id = g.grades_students_id
JOIN 
    courses c ON g.grades_courses_id = c.courses_id
GROUP BY 
    s.students_id
ORDER BY 
    COUNT(c.courses_id) DESC;


-- consulta con el total de cursos por alumno:
SELECT 
    s.students_id AS student_id,
    s.students_name AS student_name,
    COUNT(c.courses_id) AS total_courses
FROM 
    students s
JOIN 
    grades g ON s.students_id = g.grades_students_id
JOIN 
    courses c ON g.grades_courses_id = c.courses_id
GROUP BY 
    s.students_id
ORDER BY 
    total_courses DESC;

