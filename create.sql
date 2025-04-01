CREATE TABLE fitness_club (
    club_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(200),
    phone VARCHAR(20)
);


CREATE TABLE employee (
    employee_id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50),
    phone VARCHAR(20),
    salary DECIMAL(10, 2),
    club_id INT,
    valid_from TIMESTAMP,
    valid_to TIMESTAMP,
    FOREIGN KEY (club_id) REFERENCES fitness_club(club_id)
);



CREATE TABLE client (
    client_id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    phone VARCHAR(20)
);


CREATE TABLE group_exercise (
    exercise_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(100),
    trainer_id INT,
    club_id INT,
    FOREIGN KEY (trainer_id) REFERENCES employee(employee_id),
    FOREIGN KEY (club_id) REFERENCES fitness_club(club_id)
);


CREATE TABLE season_ticket (
    ticket_id INT NOT NULL PRIMARY KEY,
    client_id INT,
    type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    price DECIMAL(10, 2),
    is_active BOOLEAN,
    FOREIGN KEY (client_id) REFERENCES client(client_id)
);


CREATE TABLE season_ticket_group_exercise (
    ticket_group_id INT NOT NULL PRIMARY KEY,
    exercise_id INT,
    ticket_id INT,
    FOREIGN KEY (exercise_id) REFERENCES group_exercise(exercise_id),
    FOREIGN KEY (ticket_id) REFERENCES season_ticket(ticket_id)
);


CREATE TABLE group_exercise_schedule (
    schedule_id INT NOT NULL PRIMARY KEY,
    exercise_id INT,
    week_day VARCHAR(10),
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (exercise_id) REFERENCES group_exercise(exercise_id)
);


CREATE TABLE fitness_club_working_time (
    time_id INT NOT NULL PRIMARY KEY,
    club_id INT,
    week_day VARCHAR(10),
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (club_id) REFERENCES fitness_club(club_id)
);