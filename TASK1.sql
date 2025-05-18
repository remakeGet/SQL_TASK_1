insert into musicians(name) values ('The Beatles');
insert into musicians(name) values ('Nirvana');
insert into musicians(name) values ('Queen');
insert into musicians(name) values ('BTS');

insert into genres(title) values('Rock');
insert into genres(title) values('Pop');
insert into genres(title) values('Hip-Hop');

insert into musician_genre(musician_id, genre_id) values(1,1);
insert into musician_genre(musician_id, genre_id) values(2,2);
insert into musician_genre(musician_id, genre_id) values(3,2);
insert into musician_genre(musician_id, genre_id) values(4,3);

insert into albums(title, year) values('Abbey Road', 2020);
insert into albums(title, year) values('A Night at the Opera', 2019);
insert into albums(title, year) values('Nevermind', 2018);
insert into albums(title, year) values('Map of the Soul', 2018);

insert into tracklist(title, duration, album_id) values('Come Together', 260, 1);
insert into tracklist(title, duration, album_id) values('Bohemian Rhapsody', 355, 2);
insert into tracklist(title, duration, album_id) values('Smells Like Teen Spirit',240, 3);
insert into tracklist(title, duration, album_id) values('My dynamite', 199, 4);
insert into tracklist(title, duration, album_id) values('Hey Jude', 431, 1);
insert into tracklist(title, duration, album_id) values('We Will Rock You', 122, 2);

insert into collection(title, year) values('The Best', 2020);
insert into collection(title, year) values('Greatest Hits', 2019);
insert into collection(title, year) values('MTV Unplugged in New York', 2018);
insert into collection(title, year) values('BTS, The Best', 2018);

insert into album_musician(album_id, musician_id) values(1, 1);
insert into album_musician(album_id, musician_id) values(2, 2);
insert into album_musician(album_id, musician_id) values(3, 3);
insert into album_musician(album_id, musician_id) values(4, 4);

insert into track_collection(track_id, collection_id) values(1, 1);
insert into track_collection(track_id, collection_id) values(5, 1);
insert into track_collection(track_id, collection_id) values(2, 2);
insert into track_collection(track_id, collection_id) values(6, 2);
insert into track_collection(track_id, collection_id) values(3, 3);
insert into track_collection(track_id, collection_id) values(4, 4);
