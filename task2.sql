--самый длинный трек
SELECT title, duration 
FROM tracklist
ORDER BY duration DESC 
LIMIT 1;
--Треки продолжительностью более 3,5 минут
SELECT title, duration 
FROM tracklist
WHERE DURATION >= 240;
--Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT title 
FROM collection
WHERE year BETWEEN 2018 AND 2020;
--Исполнители, чьё имя состоит из одного слова
SELECT name 
FROM musicians
WHERE name NOT LIKE '% %';
--Название треков, которые содержат слово «мой» или «my»
SELECT title 
FROM tracklist 
WHERE title LIKE '%мой%' OR title LIKE '%my%';
