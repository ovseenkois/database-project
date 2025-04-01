-- топ-5 самых дорогих активных абонементов 
SELECT t.ticket_id, c.first_name, c.last_name, t.type, t.price
FROM season_ticket t
JOIN client c ON t.client_id = c.client_id
WHERE t.is_active = TRUE
ORDER BY t.price DESC
LIMIT 5;

-- кол-во групповых занятий каждого типа
SELECT name, COUNT(*) as class_count
FROM group_exercise
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY class_count DESC;


-- клиенты с абонементами срок действия которых истекает в этом месяце
SELECT c.client_id, c.first_name, c.last_name, t.end_date
FROM client c
JOIN season_ticket t ON c.client_id = t.client_id
WHERE t.end_date IN (
    SELECT end_date 
    FROM season_ticket 
    WHERE end_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '1 month')
)
AND t.is_active = TRUE;

-- распределение тренеров по клубам.
SELECT fc.name, COUNT(e.employee_id) as trainer_count
FROM fitness_club fc
LEFT JOIN employee e ON fc.club_id = e.club_id AND e.position = 'Тренер'
GROUP BY fc.club_id, fc.name
ORDER BY trainer_count DESC;

-- занятия которые посещает конкретный клиент
SELECT ge.name, ge.exercise_id
FROM group_exercise ge
WHERE EXISTS (
    SELECT 1
    FROM season_ticket_group_exercise stge
    JOIN season_ticket st ON stge.ticket_id = st.ticket_id
    WHERE stge.exercise_id = ge.exercise_id
    AND st.client_id = 1
);

-- рейтинг тренеров по количеству проводимых занятий
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    COUNT(ge.exercise_id) as classes_count,
    RANK() OVER (ORDER BY COUNT(ge.exercise_id) DESC) as rank
FROM employee e
LEFT JOIN group_exercise ge ON e.employee_id = ge.trainer_id
WHERE e.position LIKE '%Тренер%'
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY classes_count DESC;

-- сравнение зарплат тренеров со средней по их клубу
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    fc.name as club_name,
    AVG(e.salary) OVER (PARTITION BY e.club_id) as avg_club_salary,
    e.salary - AVG(e.salary) OVER (PARTITION BY e.club_id) as diff_from_avg
FROM employee e
JOIN fitness_club fc ON e.club_id = fc.club_id
WHERE e.position = 'Тренер'
ORDER BY diff_from_avg DESC;

-- расписание занятий с информацией о клубе
SELECT 
    ges.schedule_id,
    ge.name as exercise_name,
    fc.name as club_name,
    ges.week_day,
    ges.start_time,
    ges.end_time
FROM group_exercise_schedule ges
FULL JOIN group_exercise ge ON ges.exercise_id = ge.exercise_id
FULL JOIN fitness_club fc ON ge.club_id = fc.club_id
ORDER BY fc.name, ges.week_day, ges.start_time;

-- самый популярный клуб по количеству клиентов
SELECT 
    fc.club_id,
    fc.name AS club_name,
    COUNT(DISTINCT st.client_id) AS client_count
FROM 
    fitness_club fc
LEFT JOIN 
    employee e ON fc.club_id = e.club_id
LEFT JOIN 
    group_exercise ge ON e.employee_id = ge.trainer_id
LEFT JOIN 
    season_ticket_group_exercise stge ON ge.exercise_id = stge.exercise_id
LEFT JOIN 
    season_ticket st ON stge.ticket_id = st.ticket_id
WHERE 
    st.is_active = TRUE
GROUP BY 
    fc.club_id, fc.name
ORDER BY 
    client_count DESC
LIMIT 1;

-- кол-во активных абонементов каждого типа
SELECT 
    type AS ticket_type,
    COUNT(*) AS active_tickets_count
FROM 
    season_ticket
WHERE 
    is_active = TRUE
GROUP BY 
    type
ORDER BY 
    active_tickets_count DESC;

