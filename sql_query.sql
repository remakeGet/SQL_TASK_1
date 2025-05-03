CREATE TABLE IF NOT EXISTS genres(
  genre_id SERIAL PRIMARY KEY,
  title VARCHAR(40) NOT NULL);

CREATE TABLE IF NOT EXISTS musucians(
  musician_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL);

CREATE TABLE IF NOT EXISTS albums(
  album_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  title VARCHAR(40) NOT NULL);

CREATE TABLE IF NOT EXISTS collection(
  collection_id  SERIAL PRIMARY KEY,
  title VARCHAR(40) NOT NULL,
  year INT NOT NULL);

CREATE TABLE IF NOT EXISTS tracklist(
  track_id SERIAL PRIMARY KEY,
  title VARCHAR(40) NOT NULL,
  duration INT NOT NULL,
  album_id NOT NULL, 
              FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS album_Musician(
  album_Musician_ID SERIAL PRIMARY KEY,
  album_id INT NOT NULL,
  musician_id INT NOT NULL,
              CONSTRAINT fk_album FOREIGN KEY(album_id) REFERENCES albums(album_id) ON DELETE CASCADE,
              CONSTRAINT fk_musician FOREIGN KEY(musician_id) REFERENCES musicians(musician_id) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS Musician_Genre(
  Musician_Genre_ID SERIAL PRIMARY KEY,
  musician_id INT NOT NULL,
  genre_id INT NOT NULL,
              CONSTRAINT fk_musician FOREIGN KEY(musician_id) REFERENCES musicians(musician_id) ON DELETE CASCADE,
              CONSTRAINT fk_genres FOREIGN KEY(genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS Track_Collection(
  TrackCollection_ID SERIAL PRIMARY KEY,
  track_id INT NOT NULL,
  collection_id INT NOT NULL,
              CONSTRAINT fk_track FOREIGN KEY(track_id) REFERENCES tracklist(track_id) ON DELETE CASCADE,
              CONSTRAINT fk_collection FOREIGN KEY(collection_id) REFERENCES collection(collection_id) ON DELETE CASCADE);
