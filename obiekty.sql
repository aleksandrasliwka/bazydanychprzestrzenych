CREATE EXTENSION postgis;

-- 1.Utwórz tabelę obiekty. W tabeli umieść nazwy i geometrie obiektów przedstawionych poniżej. Układ odniesienia ustal jako niezdefiniowany.
CREATE TABLE obiekty( ID INT, name VARCHAR(40), geometria GEOMETRY);

INSERT INTO obiekty VALUES 
(1, 'obiekt1', ST_GeomFromText('MULTICURVE((0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1), CIRCULARSTRING(3 1, 4 2, 5 1), (5 1, 6 1))', 0));

INSERT INTO obiekty VALUES 
(2, 'obiekt2',ST_GeomFromText('CURVEPOLYGON(COMPOUNDCURVE((14 6, 10 6, 10 2),CIRCULARSTRING(10 2, 12 0, 14 2, 16 4, 14 6)),CIRCULARSTRING(11 2, 13 2, 11 2))',0));

INSERT INTO obiekty VALUES 
(3, 'obiekt3', ST_GeomFromText('POLYGON((12 13, 7 15, 10 17, 12 13))', 0));

INSERT INTO obiekty VALUES 
(4, 'obiekt4', ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)', 0));

INSERT INTO obiekty VALUES 
(5, 'obiekt5', ST_GeomFromText('MULTIPOINT Z((30 30 59), (38 32 234))',0));

INSERT INTO obiekty VALUES 
(6, 'obiekt6', ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2), POINT(4 2))',0));

-----
-- 1. Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół najkrótszej linii łączącej obiekt 3 i 4.
SELECT ST_Area(ST_Buffer(ST_ShortestLine((
	SELECT geometria FROM obiekty WHERE name LIKE 'obiekt3'), (
		SELECT geometria FROM obiekty WHERE name LIKE 'obiekt4')), 5)) AS powierzchnia

-- 2. Zamień obiekt4 na poligon. Jaki warunek musi być spełniony, aby można było wykonać to zadanie? Zapewnij te warunki.
-- By warunek był spełiony, obiekt 4 musi być obiektem zamkniętym. Należy dodać jedną linie.
UPDATE obiekty SET geometria = ST_GeomFromText('POLYGON((20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20))', 0) 
WHERE name LIKE 'obiekt4';

-- 3. W tabeli obiekty, jako obiekt7 zapisz obiekt złożony z obiektu 3 i obiektu 4
INSERT INTO obiekty VALUES ( 7, 'obiekt7', (
	SELECT ST_Union((
		SELECT geometria FROM obiekty WHERE name LIKE 'obiekt3' ), (
			SELECT geometria FROM obiekty WHERE name LIKE 'obiekt4' ))));

-- 4. Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone wokół obiektów nie zawierających łuków.
SELECT SUM( ST_Area( ST_Buffer( obiekty.geometria, 5 ))) AS powierzchnia FROM obiekty 
WHERE ST_HasArc( obiekty.geometria ) = false;