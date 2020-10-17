CREATE EXTENSION postgis;

CREATE TABLE budynki (id INTEGER, nazwa VARCHAR(30), the_geom1 GEOMETRY);
CREATE TABLE drogi (id INTEGER, nazwa VARCHAR(30), the_geom2 GEOMETRY);
CREATE TABLE punkty_informacyjne (id INTEGER, nazwa VARCHAR(30), the_geom3 GEOMETRY);

INSERT INTO budynki VALUES (1, 'BuildingA', ST_GeomFromText('POLYGON((8 1.5, 8 4, 10.5 4, 10.5 1.5, 8 1.5))', 0));
INSERT INTO budynki VALUES (2, 'BuildingB', ST_GeomFromText('POLYGON((4 5, 4 7, 6 7, 6 5, 4 5))', 0));
INSERT INTO budynki VALUES (3, 'BuildingC', ST_GeomFromText('POLYGON((3 6, 3 8, 5 8, 5 6, 3 6))', 0));
INSERT INTO budynki VALUES (4, 'BuildingD', ST_GeomFromText('POLYGON((9 8, 9 9, 10 9, 10 8, 9 8))', 0));
INSERT INTO budynki VALUES (5, 'BuildingF', ST_GeomFromText('POLYGON((1 1, 1 2, 2 2, 2 1, 1 1))', 0));

INSERT INTO drogi VALUES (1, 'Road X', ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)', 0));
INSERT INTO drogi VALUES (2, 'Road Y', ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)', 0));

INSERT INTO punkty_informacyjne VALUES (1, 'G', ST_GeomFromText('POINT(1 3.5)', 0));
INSERT INTO punkty_informacyjne VALUES (2, 'H', ST_GeomFromText('POINT(5.5 1.5)', 0));
INSERT INTO punkty_informacyjne VALUES (3, 'I', ST_GeomFromText('POINT(9.5 6)', 0));
INSERT INTO punkty_informacyjne VALUES (4, 'J', ST_GeomFromText('POINT(6.5 6)', 0));
INSERT INTO punkty_informacyjne VALUES (5, 'K', ST_GeomFromText('POINT(6 9.5)', 0));

-- a.	Wyznacz całkowitą długość dróg w analizowanym mieście
SELECT SUM (ST_Length(the_geom2)) FROM drogi;	

-- b.	Wypisz geometrię (WKT), pole powierzchni oraz obwód poligonu reprezentującego budynek o nazwie BuildingA. 
SELECT ST_AsText(the_geom1) AS GEOMETRY, ST_AREA(the_geom1) AS powierzchnia, ST_PERIMETER(the_geom1) AS obwod 
FROM budynki WHERE nazwa='BuildingA';


-- c.	Wypisz nazwy i pola powierzchni wszystkich poligonów w warstwie budynki. Wyniki posortuj alfabetycznie.  
SELECT nazwa, ST_AREA(the_geom1) AS powierzchnia FROM budynki ORDER BY nazwa ASC;

-- d.	Wypisz nazwy i obwody 2 budynków o największej powierzchni.  
SELECT nazwa, ST_PERIMETER(the_geom1) AS obwod FROM budynki ORDER BY ST_AREA(the_geom1) DESC LIMIT 2; 

-- e.	Wyznacz najkrótszą odległość między budynkiem BuildingC a punktem G.  
SELECT ST_Distance(
		ST_GeomFromText('POLYGON((3 6, 3 8, 5 8, 5 6, 3 6))', 0)::geometry,
		ST_GeomFromText('POINT(1 3.5)', 0)::geometry
	) AS min_odl;

SELECT ST_Distance(the_geom1, the_geom3) 
FROM budynki, punkty_informacyjne
WHERE budynki.nazwa='BuildingC' AND punkty_informacyjne.nazwa='G'

-- f.	Wypisz pole powierzchni tej części budynku BuildingC, która znajduje się w odległości większej niż 0.5 od budynku BuildingB.
CREATE TABLE buf1 AS SELECT ST_Buffer(the_geom1, 0.5) AS bufor FROM budynki WHERE nazwa='BuildingB';
CREATE TABLE buf2 AS SELECT the_geom1 FROM budynki WHERE nazwa='BuildingC';
SELECT ST_Area(ST_Difference(the_geom1, bufor)) AS powierzchnia FROM buf2, buf1;

-- g.	Wybierz te budynki, których centroid (ST_Centroid) znajduje się powyżej drogi o nazwie RoadX.  
SELECT ST_Y(ST_CENTROID(the_geom1)) AS X FROM budynki WHERE ST_Y(ST_CENTROID(the_geom1)) > 4.5;

-- 8. Oblicz pole powierzchni tych części budynku BuildingC i poligonu o współrzędnych (4 7, 6 7, 6 8, 4 8, 4 7), które nie są wspólne dla tych dwóch obiektów.
SELECT ST_Area(ST_Difference(the_geom1, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', 0))) 
AS pole FROM buf2;
