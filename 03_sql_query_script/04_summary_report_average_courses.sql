-- Crear un informe resumido de los cursos y sus calificaciones promedio, 
-- ordenados desde el curso más desafiante 
-- (curso con la calificación promedio más baja) hasta el curso más fácil.
SELECT 
    c.courses_id AS course_id,
    c.courses_name AS course_name,
    AVG(g.grade) AS average_grade
FROM 
    courses c
JOIN 
    grades g ON c.courses_id = g.grades_courses_id
GROUP BY 
    c.courses_id, c.courses_name
ORDER BY 
    average_grade ASC;