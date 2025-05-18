--Количество исполнителей в каждом жанре:
SELECT g.title AS genre, COUNT(DISTINCT t2.track_id) AS artist_count
FROM Genres g
join musician_genre mg on g.genre_id = mg.genre_id 
join musicians m2 on mg.musician_id = m2.musician_id 
join album_musician am on am.musician_id = m2.musician_id 
join albums a on a.album_id = am.album_id 
join tracklist t2 on t2.album_id = a.album_id 
GROUP BY g.title;
--Количество треков, вошедших в альбомы 2019–2020 годов:
SELECT COUNT(t.album_id) AS track_count
FROM tracklist t
JOIN Albums a ON t.album_id = a.album_id
WHERE a.year BETWEEN 2019 AND 2020;
--Средняя продолжительность треков по каждому альбому:
SELECT a.title AS album_title, AVG(t2.duration) AS average_duration
FROM Albums a
JOIN tracklist t2 ON a.album_id = t2.album_id
GROUP BY a.title;
--Все исполнители, которые не выпустили альбомы в 2020 году:
SELECT DISTINCT m.name 
FROM musicians m
WHERE m.musician_id  NOT IN (
    SELECT DISTINCT am.musician_id 
    FROM album_musician am
    JOIN Albums al ON am.album_id = al.album_id
    WHERE al.year = 2020);
--Названия сборников, в которых присутствует конкретный исполнитель:
SELECT distinct c.title 
FROM collection c
JOIN track_collection ct ON c.collection_id = ct.collection_id
JOIN tracklist t ON ct.track_id = t.track_id
join albums a2 on a2.album_id = t.album_id 
join album_musician am on am.album_id = a2.album_id 
join musicians m on m.musician_id = am.musician_id 
WHERE m.name = 'The Beatles'; 



