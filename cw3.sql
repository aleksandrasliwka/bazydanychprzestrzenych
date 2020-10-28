CREATE EXTENSION postgis;

-- 4.	Wyznacz liczbę budynków (tabela: popp, atrybut: f_codedesc, reprezentowane, jako punkty) położonych w odległości mniejszej niż 100000 m od głównych rzek. Budynki spełniające to kryterium zapisz do osobnej tabeli tableB.
CREATE TABLE tableB AS
SELECT (COUNT(DISTINCT p.gid)) AS liczba_budynkow
FROM majrivers m, popp p 
WHERE p.f_codedesc LIKE 'Building' 
AND ST_Intersects (ST_Buffer(m.geom, 100000), p.geom);

-- 5.	Utwórz tabelę o nazwie airportsNew. Z tabeli airports do zaimportuj nazwy lotnisk, ich geometrię, a także atrybut elev, reprezentujący wysokość n.p.m.  
SELECT name, geom, elev INTO airportsNew FROM airports;

-- a) Znajdź lotnisko, które położone jest najbardziej na zachód i najbardziej na wschód.  
SELECT NAME AS wschod, ST_Y(geom) AS wspolrzedne FROM airportsNew 
WHERE st_y(geom) IN (SELECT MAX(st_y(geom)) FROM airportsNew);
 
SELECT NAME AS wschod, ST_Y(geom) AS wspolrzedne FROM airportsNew 
WHERE st_y(geom) IN (SELECT MIN(st_y(geom)) FROM airportsNew);

-- b) Do tabeli airportsNew dodaj nowy obiekt - lotnisko, które położone jest w punkcie środkowym drogi pomiędzy lotniskami znalezionymi w punkcie a. Lotnisko nazwij airportB. Wysokość n.p.m. przyjmij dowolną.
INSERT INTO airportsNew VALUES ('airportB', (SELECT ST_Centroid (ST_ShortestLine((SELECT geom FROM airportsNew WHERE NAME LIKE 'NOATAK'),
																				 (SELECT geom FROM airportsNew WHERE name LIKE 'NIKOLSKI')))), 67);
																				 
-- 6.	Wyznacz pole powierzchni obszaru, który oddalony jest mniej niż 1000 jednostek od najkrótszej linii łączącej jezioro o nazwie ‘Iliamna Lake’ i lotnisko o nazwie „AMBLER”
SELECT ST_Area(ST_Buffer(ST_ShortestLine(l.geom, a.geom), 1000)) AS powierzchnia 
FROM lakes l, airports a 
WHERE l.names LIKE 'Iliamna Lake' AND a.name LIKE 'AMBLER';	

-- 7.	Napisz zapytanie, które zwróci sumaryczne pole powierzchni poligonów reprezentujących poszczególne typy drzew znajdujących się na obszarze tundry i bagien.  
SELECT SUM(wynik.areakm2) AS pole_powierzchni, wynik.vegdesc AS typ_drzewa
FROM (SELECT swamp.areakm2 , trees.vegdesc FROM swamp, trees WHERE ST_CONTAINS(trees.geom, swamp.geom)='true' UNION ALL
SELECT tundra.area_km2, trees.vegdesc FROM tundra, trees WHERE ST_CONTAINS(trees.geom, tundra.geom)='true') AS wynik GROUP BY wynik.vegdesc;
