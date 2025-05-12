USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'MusicIndustry')
BEGIN
    ALTER DATABASE MusicIndustry SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MusicIndustry;
END
GO

CREATE DATABASE MusicIndustry;
GO

USE MusicIndustry;
GO

-- Исполнитель
CREATE TABLE Artist
(
    ArtistID INT NOT NULL,
    Name NVARCHAR(64) NOT NULL,
    Country NVARCHAR(32),
    ActiveSince INT
) AS NODE;

-- Альбом
CREATE TABLE Album
(
    AlbumID INT NOT NULL,
    Title NVARCHAR(128) NOT NULL,
    ReleaseYear INT,
    RecordLabel NVARCHAR(64)
) AS NODE;

-- Жанр
CREATE TABLE Genre
(
    GenreID INT NOT NULL,
    Name NVARCHAR(64) NOT NULL,
    Description NVARCHAR(256)
) AS NODE;

-- Исполнитель создал альбом
CREATE TABLE Created
(
    CONSTRAINT EC_Created CONNECTION (Artist TO Album)
) AS EDGE;

-- Альбом относится к жанру
CREATE TABLE BelongsTo
(
    CONSTRAINT EC_BelongsTo CONNECTION (Album TO Genre)
) AS EDGE;

-- Исполнитель сотрудничал с другим исполнителем
CREATE TABLE CollaboratedWith
(
    CollaborationType NVARCHAR(64),
    Year INT
) AS EDGE;

-- Заполнение таблицы Artist
INSERT INTO Artist (ArtistID, Name, Country, ActiveSince)
VALUES 
    (1, 'The Beatles', 'UK', 1960),
    (2, 'Pink Floyd', 'UK', 1965),
    (3, 'Led Zeppelin', 'UK', 1968),
    (4, 'Queen', 'UK', 1970),
    (5, 'Metallica', 'USA', 1981),
    (6, 'Nirvana', 'USA', 1987),
    (7, 'Radiohead', 'UK', 1985),
    (8, 'David Bowie', 'UK', 1962),
    (9, 'Michael Jackson', 'USA', 1964),
    (10, 'Madonna', 'USA', 1979),
    (11, 'Elton John', 'UK', 1962),
    (12, 'Eminem', 'USA', 1988);

-- Заполнение таблицы Album
INSERT INTO Album (AlbumID, Title, ReleaseYear, RecordLabel)
VALUES 
    (1, 'Abbey Road', 1969, 'Apple Records'),
    (2, 'The Dark Side of the Moon', 1973, 'Harvest'),
    (3, 'Led Zeppelin IV', 1971, 'Atlantic'),
    (4, 'A Night at the Opera', 1975, 'EMI'),
    (5, 'Master of Puppets', 1986, 'Elektra'),
    (6, 'Nevermind', 1991, 'DGC'),
    (7, 'OK Computer', 1997, 'Parlophone'),
    (8, 'The Rise and Fall of Ziggy Stardust', 1972, 'RCA'),
    (9, 'Thriller', 1982, 'Epic'),
    (10, 'Like a Virgin', 1984, 'Sire'),
    (11, 'Goodbye Yellow Brick Road', 1973, 'MCA'),
    (12, 'The Marshall Mathers LP', 2000, 'Aftermath');

-- Заполнение таблицы Genre
INSERT INTO Genre (GenreID, Name)
VALUES 
    (1, 'Rock'),
    (2, 'Progressive Rock'),
    (3, 'Heavy Metal'),
    (4, 'Grunge'),
    (5, 'Alternative Rock'),
    (6, 'Pop'),
    (7, 'Hip Hop'),
    (8, 'Glam Rock');

-- Связи Created (Artist -> Album)
INSERT INTO Created ($from_id, $to_id)
VALUES 
    ((SELECT $node_id FROM Artist WHERE ArtistID = 1), (SELECT $node_id FROM Album WHERE AlbumID = 1)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 2), (SELECT $node_id FROM Album WHERE AlbumID = 2)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 3), (SELECT $node_id FROM Album WHERE AlbumID = 3)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 4), (SELECT $node_id FROM Album WHERE AlbumID = 4)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 5), (SELECT $node_id FROM Album WHERE AlbumID = 5)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 6), (SELECT $node_id FROM Album WHERE AlbumID = 6)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 7), (SELECT $node_id FROM Album WHERE AlbumID = 7)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 8), (SELECT $node_id FROM Album WHERE AlbumID = 8)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 9), (SELECT $node_id FROM Album WHERE AlbumID = 9)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 10), (SELECT $node_id FROM Album WHERE AlbumID = 10)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 11), (SELECT $node_id FROM Album WHERE AlbumID = 11)),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 12), (SELECT $node_id FROM Album WHERE AlbumID = 12));

-- Связи BelongsTo (Album -> Genre)
INSERT INTO BelongsTo ($from_id, $to_id)
VALUES 
    ((SELECT $node_id FROM Album WHERE AlbumID = 1), (SELECT $node_id FROM Genre WHERE GenreID = 1)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 2), (SELECT $node_id FROM Genre WHERE GenreID = 2)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 3), (SELECT $node_id FROM Genre WHERE GenreID = 1)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 4), (SELECT $node_id FROM Genre WHERE GenreID = 1)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 5), (SELECT $node_id FROM Genre WHERE GenreID = 3)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 6), (SELECT $node_id FROM Genre WHERE GenreID = 4)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 7), (SELECT $node_id FROM Genre WHERE GenreID = 5)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 8), (SELECT $node_id FROM Genre WHERE GenreID = 8)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 9), (SELECT $node_id FROM Genre WHERE GenreID = 6)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 10), (SELECT $node_id FROM Genre WHERE GenreID = 6)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 11), (SELECT $node_id FROM Genre WHERE GenreID = 6)),
    ((SELECT $node_id FROM Album WHERE AlbumID = 12)	, (SELECT $node_id FROM Genre WHERE GenreID = 7));

-- Связи CollaboratedWith (Artist -> Artist)
-- Связи CollaboratedWith (Artist -> Artist)
INSERT INTO CollaboratedWith ($from_id, $to_id, CollaborationType, Year)
VALUES 
    ((SELECT $node_id FROM Artist WHERE ArtistID = 1), (SELECT $node_id FROM Artist WHERE ArtistID = 8), 'Guest Appearance', 1967),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 4), (SELECT $node_id FROM Artist WHERE ArtistID = 11), 'Duet', 1992),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 8), (SELECT $node_id FROM Artist WHERE ArtistID = 9), 'Backing Vocals', 1985),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 10), (SELECT $node_id FROM Artist WHERE ArtistID = 12), 'Remix', 2002),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 11), (SELECT $node_id FROM Artist WHERE ArtistID = 9), 'Songwriting', 1991),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 2), (SELECT $node_id FROM Artist WHERE ArtistID = 7), 'Live Performance', 2000),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 6), (SELECT $node_id FROM Artist WHERE ArtistID = 5), 'Cover Song', 1992),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 3), (SELECT $node_id FROM Artist WHERE ArtistID = 4), 'Jam Session', 1977),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 7), (SELECT $node_id FROM Artist WHERE ArtistID = 8), 'Tribute Album', 2003),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 9), (SELECT $node_id FROM Artist WHERE ArtistID = 10), 'Charity Single', 1985),
    ((SELECT $node_id FROM Artist WHERE ArtistID = 5), (SELECT $node_id FROM Artist WHERE ArtistID = 11), 'Concert', 1999);

-- ЗАПРОСЫ С ИСПОЛЬЗОВАНИЕМ MATCH

-- 1. Найти все альбомы, созданные британскими исполнителями
SELECT 
    a.Name AS Artist,
    al.Title AS Album,
    al.ReleaseYear
FROM 
    Artist a,
    Album al,
    Created c
WHERE 
    MATCH(a-(c)->al)
    AND a.Country = 'UK'
ORDER BY 
    al.ReleaseYear;

-- 2. Найти все жанры, к которым относятся альбомы Metallica
SELECT 
    g.Name AS Genre,
    al.Title AS Album
FROM 
    Artist a,
    Album al,
    Genre g,
    Created c,
    BelongsTo b
WHERE 
    MATCH(a-(c)->al-(b)->g)
    AND a.Name = 'Metallica';

-- 3. Найти всех исполнителей, которые сотрудничали с David Bowie
SELECT 
    a2.Name AS Collaborator,
    cw.CollaborationType,
    cw.Year
FROM 
    Artist a1,
    Artist a2,
    CollaboratedWith cw
WHERE 
    MATCH(a1-(cw)->a2)
    AND a1.Name = 'David Bowie'
ORDER BY 
    cw.Year;

-- 4. Найти все альбомы в жанре Rock с годом выпуска после 1980
SELECT 
    al.Title AS Album,
    a.Name AS Artist,
    al.ReleaseYear
FROM 
    Artist a,
    Album al,
    Genre g,
    Created c,
    BelongsTo b
WHERE 
    MATCH(a-(c)->al-(b)->g)
    AND g.Name = 'Rock'
    AND al.ReleaseYear > 1980
ORDER BY 
    al.ReleaseYear DESC;

-- 5. Найти все сотрудничества между американскими и британскими исполнителями
SELECT 
    a1.Name AS AmericanArtist,
    a2.Name AS BritishArtist,
    cw.CollaborationType,
    cw.Year
FROM 
    Artist a1,
    Artist a2,
    CollaboratedWith cw
WHERE 
    MATCH(a1-(cw)->a2)
    AND a1.Country = 'USA'
    AND a2.Country = 'UK'
ORDER BY 
    cw.Year DESC;

-- ЗАПРОСЫ С ИСПОЛЬЗОВАНИЕМ SHORTEST_PATH

-- 1. Найти все пути сотрудничества от The Beatles до других исполнителей (любой длины)
SELECT 
    a1.Name AS StartArtist,
    STRING_AGG(a2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS CollaborationPath
FROM 
    Artist AS a1,
    CollaboratedWith FOR PATH AS cw,
    Artist FOR PATH AS a2
WHERE 
    MATCH(SHORTEST_PATH(a1(-(cw)->a2)+))
    AND a1.Name = 'The Beatles';

-- 2. Найти пути сотрудничества от Michael Jackson до других исполнителей (максимум 3 шага)

SELECT 
    a1.Name AS Artist1,
    a2.Name AS Artist2,
    cw.CollaborationType,
    cw.Year
FROM 
    Artist a1,
    Artist a2,
    CollaboratedWith cw
WHERE 
    MATCH(a1-(cw)->a2)
    AND a1.Name = 'Michael Jackson'
ORDER BY 
    cw.Year;
