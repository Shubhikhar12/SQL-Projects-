create database movie_recommendations;
use movie_recommendations;

create table users(
user_id int primary key,
user_name varchar(50),
email varchar(50),
created_at date
);

insert into users(User_id, user_name, email, created_at)
values(1, 'John Doe', 'John@gmail.com', '2023-01-15'),
(2, 'Alice Smith', 'Alice@yahoo.com', '2023-02-20'),
(3, 'Bob Johnson', 'Bob@gmail.com', '2023-03-10');

create table movie_table(
movie_id int primary key,
title varchar(100),
release_year varchar(50),
genre_id int,
duration_minutes int
);

insert into movie_table(movie_id, title, release_year, genre_id, duration_minutes)
values(1, 'Inception', '2010', 1, '148'),
(2, 'The Dark Knight', '2008', 1, '152'),
(3, 'The GodFather', '1972', 2, '175'),
(4, 'Titanic', '1997', 3, '195');

create table genres(
genre_id int primary key,
genre_name varchar(50)
);

insert into genres(genre_id, genre_name)
values(1, 'Action'),
(2, 'Crime'),
(3, 'Romance'),
(4, 'Comedy');

create table ratings(
rating_id int primary key,
user_id int,
movie_id int, 
ratings int, 
rated_at date,
foreign key(user_id) references user(user_id),
foreign key(movie_id) references movie_table(movie_id)
);

insert into ratings(rating_id, user_id, movie_id, ratings, rated_at)
values(1, 1, 1, 5.0, '2024-01-01'),
(2, 1, 2, 4.5, '2024-01-03'),
(3, 2, 1, 4.0, '2024-01-04'),
(4, 3, 4, 4.8, '2024-01-05');

create table movie_genre(
id int primary key, 
movie_id int,
genre_id int,
foreign key(movie_id) references movie_table(movie_id),
foreign key(genre_id) references genres(genre_id)
);

insert into movie_genre(id, movie_id, genre_id)
values(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 4, 3);



                                                -- SQL BASIC QUERIES

-- 1) Retrieve all movies released after 2000:

select * from movie_table
where release_year > 2000;             

-- 2) List all users who registered in 2023:

select user_name, email
from user
where created_at between 2023-01-15 and 2023-01-12;                                 

-- 3) Get the names of all genres available:

select genre_name 
from genres;  

-- 4) Find all movies with a duration greater than 150 minutes:

select * from movie_table
where duration_minutes > 150;

										-- SQL AGGREGATE QUERIES
                                        
-- 5) Calculate the average rating for each movie:

select m.title, avg(r.ratings) AS avg_rating
from movie_table m
join ratings r on m.movie_id = r.movie_id
group by m.title;                               

-- 6) Count the total number of ratings provided by each user:

select u.user_name, count(r.ratings) AS total_number_of_ratings
from users u
join ratings r on u.user_id = r.user_id
group by u.user_name;

-- 7) Get the total number of movies per genre:

select count(m.movie_id) AS total_number_of_movies, g.genre_name
from movie_table m
join genres g on m.genre_id = g.genre_id
group by m.movie_id;

											-- SQL JOIN QUERIES
                                            
-- 8) List all movies and their genres:

select title, genre_name from movie_table m
join genres g on m.genre_id = g.genre_id;      

-- 9) Retrieve all ratings given by a specific user (e.g., user_id = 2):

select u.user_name, r.ratings
from users u
join ratings r on u.user_id = r.user_id
where u.user_id = 2;         

-- 10) Find all users who rated a specific movie (e.g., movie_id = 1):

select u.user_name, r.ratings
from users u
join ratings r on u.user_id = r.user_id
where r.movie_id = 1;

									   -- SQL FILTERING AND SORTING QUERIES                                                 

-- 11) Get the top 3 highest-rated movies:

select m.title, avg(r.ratings) AS avg_rating
from movie_table m
join ratings r on m.movie_id = r.movie_id
group by m.title
order by avg_rating DESC
limit 3;        

-- 12) Find all movies with an average rating of 4.5 or higher:

select m.title, avg(r.ratings) AS avg_rating
from movie_table m
join ratings r on m.movie_id = r.movie_id
group by m.title
having avg_rating >= 4.5;

-- 13) Get the most active user (user with the highest number of ratings):

select u.user_name, count(r.ratings) AS highest_number_of_ratings 
from users u
join ratings r on u.user_id = r.user_id
group by u.user_name;

										-- SQL SUBQUERIES 
                                        
-- 14) Find movies not rated by a specific user (e.g., user_id = 1):

SELECT m.title 
FROM movie_table m
WHERE m.movie_id NOT IN (
    SELECT r.movie_id 
    FROM ratings r 
    WHERE r.user_id = 1
);


-- 15) Retrieve the genre(s) with the highest number of movies:

select g.genre_name, count(m.movie_id) AS highest_number_of_movies
from genres g
join movie_table m on g.genre_id = m.genre_id
group by g.genre_name;