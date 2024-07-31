-- Gaming Tournament and Player Management System
create database PROJECT ;

-- Players table
CREATE TABLE Players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    birthdate DATE,
    join_date DATE
);

-- Games table
CREATE TABLE Games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    release_year YEAR
);

-- Tournaments table
CREATE TABLE Tournaments (
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_name VARCHAR(100) NOT NULL,
    game_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

-- Teams table
CREATE TABLE Teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL,
    captain_id INT,
    tournament_id INT,
    FOREIGN KEY (captain_id) REFERENCES Players(player_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id)
);

-- Matches table
CREATE TABLE Matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_id INT,
    match_date DATETIME,
    team1_id INT,
    team2_id INT,
    winner_id INT,
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id),
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
    FOREIGN KEY (winner_id) REFERENCES Teams(team_id)
);

-- Match_Details table
CREATE TABLE Match_Details (
    match_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT,
    player_id INT,
    kills INT,
    deaths INT,
    assists INT,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Tournament_Results table
CREATE TABLE Tournament_Results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_id INT,
    team_id INT,
    position INT,
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Player_Stats table
CREATE TABLE Player_Stats (
    player_stat_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT,
    game_id INT,
    matches_played INT,
    total_kills INT,
    total_deaths INT,
    FOREIGN KEY (player_id) REFERENCES Players(player_id),
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

-- Team_Stats table
CREATE TABLE Team_Stats (
    team_stat_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT,
    tournament_id INT,
    matches_played INT,
    matches_won INT,
    matches_lost INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id)
);

-- Prizes table
CREATE TABLE Prizes (
    prize_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_id INT,
    prize_name VARCHAR(100) NOT NULL,
    prize_amount DECIMAL(10, 2),
    FOREIGN KEY (tournament_id) REFERENCES Tournaments(tournament_id)
);

-- Inserting into Games table
INSERT INTO Games (game_name, genre, release_year)
VALUES ('League of Legends', 'MOBA', 2009),
       ('Counter-Strike: Global Offensive', 'FPS', 2012),
       ('Fortnite', 'Battle Royale', 2017);

-- Inserting into Players table
INSERT INTO Players (player_name, email, birthdate, join_date)
VALUES ('John Doe', 'john.doe@example.com', '1995-03-15', '2015-01-01'),
       ('Jane Smith', 'jane.smith@example.com', '1998-07-21', '2016-02-10'),
       ('Alice Johnson', 'alice.johnson@example.com', '1990-11-03', '2017-05-20');

-- Inserting into Tournaments table
INSERT INTO Tournaments (tournament_name, game_id, start_date, end_date)
VALUES ('Summer Championship', 1, '2023-07-01', '2023-07-15'),
       ('Winter Tournament', 2, '2023-12-10', '2023-12-25'),
       ('Spring Cup', 3, '2024-04-01', '2024-04-15');

-- Inserting into Teams table
INSERT INTO Teams (team_name, captain_id, tournament_id)
VALUES ('Team A', 1, 1),
       ('Team B', 2, 1),
       ('Team C', 3, 2),
       ('Team D', 1, 3);

-- Inserting into Matches table
INSERT INTO Matches (tournament_id, match_date, team1_id, team2_id, winner_id)
VALUES (1, '2023-07-05 15:00:00', 1, 2, 1),
       (1, '2023-07-06 16:30:00', 3, 4, 3),
       (2, '2023-12-12 18:00:00', 2, 3, 3);

-- Inserting into Match_Details table
INSERT INTO Match_Details (match_id, player_id, kills, deaths, assists)
VALUES 
    (1, 1, 10, 2, 5),
    (1, 2, 8, 3, 7),
    (2, 3, 12, 1, 4),
    (2, 1, 6, 4, 3),
    (3, 2, 9, 5, 2),
    (3, 3, 11, 3, 6);

SELECT player_id FROM Players WHERE player_id IN (1, 2, 3, 4, 5, 6);



-- Inserting into Tournament_Results table
INSERT INTO Tournament_Results (tournament_id, team_id, position)
VALUES (1, 1, 1),
       (1, 2, 2),
       (2, 3, 1),
       (3, 4, 1);

-- Inserting into Player_Stats table
INSERT INTO Player_Stats (player_id, game_id, matches_played, total_kills, total_deaths)
VALUES 
    (1, 1, 3, 25, 10),
    (2, 1, 2, 20, 8),
    (3, 2, 4, 40, 15);


UPDATE Players SET player_id = 6 WHERE player_id IS NULL;

SELECT player_id FROM Players;

-- Inserting into Team_Stats table
INSERT INTO Team_Stats (team_id, tournament_id, matches_played, matches_won, matches_lost)
VALUES (1, 1, 2, 2, 0),
       (2, 1, 2, 0, 2),
       (3, 2, 1, 1, 0),
       (4, 3, 1, 1, 0);

-- Inserting into Prizes table
INSERT INTO Prizes (tournament_id, prize_name, prize_amount)
VALUES (1, 'First Place Prize', 1000.00),
       (1, 'Second Place Prize', 500.00),
       (2, 'Champion Prize', 750.00),
       (3, 'Winner Prize', 1200.00);

-- Retrieve all players and their total kills:

SELECT player_name, (
    SELECT SUM(kills)
    FROM Match_Details
    WHERE Match_Details.player_id = Players.player_id
) AS total_kills
FROM Players;

-- Find tournaments with prize amounts and the number of teams participating:

SELECT Tournaments.tournament_name, (
    SELECT COUNT(*)
    FROM Teams
    WHERE Teams.tournament_id = Tournaments.tournament_id
) AS num_teams, (
    SELECT SUM(prize_amount)
    FROM Prizes
    WHERE Prizes.tournament_id = Tournaments.tournament_id
) AS total_prize_amount
FROM Tournaments;

-- Calculate win rate for each team in a tournament:

CREATE VIEW WinRates AS
SELECT Teams.team_name, 
       COUNT(Matches.match_id) AS matches_played,
       SUM(CASE WHEN Matches.winner_id = Teams.team_id THEN 1 ELSE 0 END) AS matches_won,
       ROUND((SUM(CASE WHEN Matches.winner_id = Teams.team_id THEN 1 ELSE 0 END) / COUNT(Matches.match_id)) * 100, 2) AS win_rate
FROM Teams
LEFT JOIN Matches ON Teams.team_id = Matches.team1_id OR Teams.team_id = Matches.team2_id
GROUP BY Teams.team_name;

SELECT * FROM WinRates;

-- Retrieve top players with the highest total kills:

SELECT player_name as top_player, total_kills
FROM (
    SELECT Players.player_name,
           SUM(Match_Details.kills) AS total_kills
    FROM Players
    INNER JOIN Match_Details ON Players.player_id = Match_Details.player_id
    GROUP BY Players.player_name
    ORDER BY total_kills DESC
    LIMIT 5
) AS TopPlayers;

-- List tournaments and their champions:

SELECT Tournaments.tournament_name, Teams.team_name AS champion_team
FROM Tournaments
INNER JOIN Teams ON Tournaments.tournament_id = Teams.tournament_id
INNER JOIN Matches ON Teams.team_id = Matches.winner_id AND Tournaments.tournament_id = Matches.tournament_id;

-- Player Performance Comparison:

SELECT p.player_name,
       SUM(ps.total_kills) AS total_kills,
       SUM(ps.total_deaths) AS total_deaths
FROM Players p
JOIN Player_Stats ps ON p.player_id = ps.player_id
WHERE p.player_id IN (1, 2)
GROUP BY p.player_name;

-- List all Players 

SELECT player_name, email
FROM Players;

--  Players in a Specific Team:

SELECT p.player_name
FROM Players p
JOIN Teams t ON p.player_id = t.captain_id
WHERE t.team_name = 'Team A';

-- Games by Genre:

SELECT game_name, genre, release_year
FROM Games;

-- Teams and Their Captains

SELECT t.team_name, p.player_name AS captain_name
FROM Teams t
JOIN Players p ON t.captain_id = p.player_id;

-- Players with Most Matches Played

SELECT p.player_name, COUNT(*) AS matches_played
FROM Players p
JOIN Player_Stats ps ON p.player_id = ps.player_id
GROUP BY p.player_name
ORDER BY matches_played DESC
LIMIT 5;