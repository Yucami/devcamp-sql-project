-- La nota media que otorga cada profesor:
SELECT 
    c.courses_professors_id AS professor_id,
    p.professors_name,
    AVG(g.grade) AS average_grade
FROM 
    grades g
JOIN 
    courses c ON g.grades_courses_id = c.courses_id
JOIN 
    professors p ON c.courses_professors_id = p.professors_id
GROUP BY 
    c.courses_professors_id, p.professors_name;
