create database performance;
use performance;

create table players(
player_id int primary key,
name varchar(50),
country varchar(50),
role varchar(50)
);

insert into players(player_id, name, country, role)
values(1, 'Virat Kohli', 'India', 'Batsman'),
(2, 'Mitchell Starc', 'Australia', 'Bowler'),
(3, 'Hardhik Pandya', 'India', 'All-Rounder');

create table matches(
match_id int primary key,
match_date date,
opposite_team varchar(50),
venue varchar(100)
);

insert into matches(match_id, match_date, opposite_team, venue)
values(201, '2024-06-29', 'South Africa', 'Lords Stadium'),
(203, '2024-08-12', 'Australia', 'Eden Gardens'),
(205, '2024-09-13', 'England', 'M Chinnaswamy Stadium');

create table batting_performance(
player_id int,
match_id int,
runs_scored int,
balls_faced int,
fours int,
sixes int,
primary key(player_id, match_id),
foreign key(player_id)references players(player_id),
foreign key(match_id)references matches(match_id)
); 

insert into batting_performance(player_id, match_id, runs_scored, balls_faced, fours, sixes)
values(1, 201, 76, 59, 4, 2),
(2, 203, 56, 31, 3, 5),
(3, 205, 78, 98, 7, 5);

create table bowling_performance(
player_id int,
match_id int,
overs_bowled decimal(3, 1),
runs_conceded int,
wickets_taken int,
economy_rate decimal(4, 2),
primary key(player_id, match_id),
foreign key(player_id)references players(player_id),
foreign key(match_id)references matches(match_id)
);

insert into bowling_performance(player_id, match_id, overs_bowled, runs_conceded, wickets_taken, economy_rate)
values(1, 201, 10.0, 45, 2, 8.25),
(2, 203, 5.0, 31, 1, 7.25),
(3, 205, 7.0, 35, 2, 8.75);

select * from players;

select * from matches;

select * from batting_performance;

select * from bowling_performance;

-- QUERIES --

-- 1) player wise batting_average

select p.name, sum(batp.runs_scored)/count(batp.match_id) AS batting_average
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name;

-- 2) player strike rate

select p.name, sum(batp.runs_scored) / sum(balls_faced) * 100 AS strike_rate
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name;

-- 3) total runs scored by each batsman

select p.name, sum(batp.runs_scored) AS total_runs
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name
order by total_runs desc;

-- 4) player wise bowling average 

select p.name, sum(bowp.runs_conceded) / sum(bowp.wickets_taken) AS bowling_average
from players p
join bowling_performance bowp
on p.player_id = bowp.player_id
group by p.name;

-- 5) player economy rate

select p.name, sum(bowp.runs_conceded) / sum(bowp.overs_bowled) AS economy_rate
from players p
join bowling_performance bowp
on p.player_id = bowp.player_id
group by p.name
order by economy_rate desc;

-- 6) top scorers in a single match

select p.name, batp.runs_scored
from players p
join batting_performance batp
on p.player_id = batp.player_id
where match_id = 203
order by runs_scored desc
limit 1;

-- 7) best bowling figures in a single match

select p.name, bowp.wickets_taken
from players p
join bowling_performance bowp
on p.player_id = bowp.player_id
where  bowp.match_id in (203, 205)
order by wickets_taken desc
limit 2;

-- 8) player performance in all matches

select p.name, batp.runs_scored, batp.balls_faced, batp.fours, batp.sixes, bowp.runs_conceded, bowp.wickets_taken, bowp.economy_rate
from players p
join batting_performance batp
on p.player_id = batp.player_id
left join bowling_performance bowp
on p.player_id = bowp.player_id
where p.player_id in (2, 3);

-- 9) top 5 runs scorers

select p.name, sum(batp.runs_scored) AS Total_runs
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name
order by Total_runs desc
limit 5; 

-- 10) best bowling average for players with atleast 2 wickets

select p.name, sum(bowp.runs_conceded) / sum(bowp.wickets_taken) AS bowling_average
from players p
join bowling_performance bowp
on p.player_id = bowp.player_id
group by p.name
having sum(bowp.wickets_taken) >= 2
order by bowling_average desc;

-- 11) player wise total fours and sixes

select p.name, sum(batp.fours) AS total_fours,
sum(batp.sixes) AS total_sixes
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name
order by total_fours desc, total_sixes desc;

-- 12) best economy rate of bowlers

select p.name, sum(bowp.economy_rate) AS Economy_rate
from players p
join bowling_performance bowp
on p.player_id = bowp.player_id
group by p.name
order by Economy_rate asc;

-- 13) average runs scored per match for each player

select p.name, avg(batp.runs_scored) AS avearge_runs_scored
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name;

-- 14) total matches played by each player

select p.name, count(distinct batp.match_id) AS total_matches_played
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name;

-- 15) most consistent batsman(minimum runs scored in each matches)

select p.name, min(batp.runs_scored) AS minimum_runs_scored
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name;

-- 16) players with 50 or more runs in a match

select p.name
from players p
join batting_performance batp
on p.player_id = batp.player_id
where batp.runs_scored >= 50;

-- 17) total matches won by each player 

SELECT p.name, 
       COUNT(m.match_id) AS total_matches_won
FROM Players p
JOIN batting_performance batp 
    ON p.player_id = batp.player_id
JOIN Matches m 
    ON bp.match_id = m.match_id
WHERE m.result = 'Won' -- Ensure your Matches table has a result column
GROUP BY p.name;

-- 18) most wickets in a match

select p.name, max(bowp.wickets_taken) AS most_wickets
from players p
join bowling_performance bowp
on p.player_id = bowp.player_id
group by p.name;

-- 19) players with strike rate and total_runs

select p.name, sum(batp.runs_scored) / sum(batp.balls_faced) * 100  AS batsman_strike_rate,
sum(batp.runs_scored) AS total_runs_scored
from players p
join batting_performance batp
on p.player_id = batp.player_id
group by p.name;

-- 20) bowlers with most overs bowled

select p.name, count(bowp.overs_bowled) AS total_overs
from players p
join bowling_performance bowp
on p.player_id = bowp.player_id
group by p.name
order by total_overs desc;

