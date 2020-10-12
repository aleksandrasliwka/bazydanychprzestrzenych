-- 1) Utworzenie nowej bazy danych o nazwie s304201 --
CREATE DATABASE s304201;

-- 2) dodanie schematu o nazwie firma --
CREATE SCHEMA firma;

-- 3)Stworzenie roli o nazwie ksiegowosc i nadanie uprawnien tylko do odczytu --
CREATE ROLE ksiegowosc;
GRANT CONNECT ON DATABASE s304201 TO ksiegowosc;
GRANT USAGE ON SCHEMA firma TO ksiegowosc;  
GRANT SELECT ON ALL TABLES IN SCHEMA firma TO ksiegowosc; 

-- 4) Dodanie tabel
-- tabela pracownicy --
CREATE TABLE firma.pracownicy(
	id_pracownika SERIAL,
	imie VARCHAR(20),
	nazwisko VARCHAR(40),
	adres VARCHAR(50),
	telefon VARCHAR(12));
	
-- tabela godziny -- 
CREATE TABLE firma.godziny(
	id_godziny VARCHAR(3),
	data DATE,
	liczba_godzin INT,
	id_pracownika SERIAL);

-- tabela pensja --
CREATE TABLE firma.pensja(
	id_pensji VARCHAR(3),
	stanowisko VARCHAR(30),
	kwota MONEY);
	
-- tabela premia --
CREATE TABLE firma.premia(
	id_premii VARCHAR(3),
	rodzaj VARCHAR(50), 
	kwota MONEY);

-- tabela wynagrodzenie --
CREATE TABLE firma.wynagrodzenie(
	id_wynagrodzenia VARCHAR(3),
	data DATE,
	id_pracownika SERIAL,
	id_godziny VARCHAR(3),
	id_pensji VARCHAR(3),
	id_premii VARCHAR(3));
	
-- b) Ustawienie klucza głównego dla każdej tabeli – użycie polecenia ALTER TABLE
ALTER TABLE firma.pracownicy ADD PRIMARY KEY (id_pracownika);
ALTER TABLE firma.godziny ADD PRIMARY KEY (id_godziny);
ALTER TABLE firma.pensja ADD PRIMARY KEY (id_pensji);
ALTER TABLE firma.premia ADD PRIMARY KEY (id_premii);
ALTER TABLE firma.wynagrodzenie ADD PRIMARY KEY (id_wynagrodzenia);

-- c) Zastanowienie się jakie relacje zachodzą pomiędzy tabelami, a następnie dodanie kluczy obcych tam, gdzie występują
ALTER TABLE firma.godziny ADD FOREIGN KEY (id_pracownika) REFERENCES firma.pracownicy (id_pracownika);
ALTER TABLE firma.wynagrodzenie ADD FOREIGN KEY (id_pracownika) REFERENCES firma.pracownicy (id_pracownika);
ALTER TABLE firma.wynagrodzenie ADD FOREIGN KEY (id_godziny) REFERENCES firma.godziny (id_godziny);
ALTER TABLE firma.wynagrodzenie ADD FOREIGN KEY (id_pensji) REFERENCES firma.pensja (id_pensji);
ALTER TABLE firma.wynagrodzenie ADD FOREIGN KEY (id_premii) REFERENCES firma.premia (id_premii);

-- e)
COMMENT ON TABLE firma.pracownicy IS 'Tabela z danymi pracowników firmy';
COMMENT ON TABLE firma.godziny IS 'Tabela z ilością przepracowanych godzin przez pracowników firmy (standardowo -160h/miesiąc)';
COMMENT ON TABLE firma.pensja IS 'Tabela z poszczególnymi pensjami dla danego stanowiska';
COMMENT ON TABLE firma.premia IS 'Tabela z możliwymi do uzyskania premiami';
COMMENT ON TABLE firma.wynagrodzenie IS 'Tabela z zestawieniem wynagrodzeń dla każdego pracownika';

-- 5) Wypelnienie tabel trescia 
-- a) W tabeli godziny, dodanie pol przechowujących informacje o miesiącu oraz numerze tygodnia danego roku (rok ma 53 tygodnie). Oba mają być typu DATE.
ALTER TABLE firma.godziny ADD miesiac INT;
ALTER TABLE firma.godziny ADD tydzien INT;

-- b) W tabeli wynagrodzenie zamiana pola data na typ tekstowy
ALTER TABLE firma.wynagrodzenie ALTER COLUMN data SET DATA TYPE VARCHAR(20);

INSERT INTO firma.pracownicy VALUES('1', 'Marek', 'Potocki', 'Długa 28', '829765989');
INSERT INTO firma.pracownicy VALUES('2', 'Jan', 'Knap', 'Karmelicka 2', '413765989');
INSERT INTO firma.pracownicy VALUES('3', 'Antoni', 'Adam', 'Krzywa 13', '312265960');
INSERT INTO firma.pracownicy VALUES('4', 'Jerzy', 'Penar', 'Zdrojowa 2', '789456231');
INSERT INTO firma.pracownicy VALUES('5', 'Michał', 'Zimka', '3 Maja 34', '891462896');
INSERT INTO firma.pracownicy VALUES('6', 'Marian', 'Kowalski', 'Nadbrzeżna 67', '593812389');
INSERT INTO firma.pracownicy VALUES('7', 'Patryk', 'Nowak', 'Podwale 45', '765989333');
INSERT INTO firma.pracownicy VALUES('8', 'Szymon', 'Kałuża', 'Warszawska 90', '246712351');
INSERT INTO firma.pracownicy VALUES('9', 'Klara', 'Pniak', 'Wiejska 9', '132765989');
INSERT INTO firma.pracownicy VALUES('10', 'Wacław', 'Piasek', 'Rzeszowska 4', '765989111');

INSERT INTO firma.godziny VALUES('g1', '2019-05-05', '160', '10', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g2', '2019-05-05', '179', '9', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g3', '2019-05-05', '150', '2', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g4', '2019-05-05', '160', '3', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g5', '2019-05-05', '160', '4', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g6', '2019-05-05', '167', '1', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g7', '2019-05-05', '170', '7', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g8', '2019-05-05', '163', '5', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g9', '2019-05-05', '190', '6', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));
INSERT INTO firma.godziny VALUES('g10', '2019-05-05', '175', '8', (SELECT DATE_PART ('month', TIMESTAMP '2019-05-05')), (SELECT DATE_PART ('week', TIMESTAMP '2019-05-05')));

INSERT INTO firma.pensja VALUES('p1', 'kierownik', '2500');
INSERT INTO firma.pensja VALUES('p2', 'manager', '2100');
INSERT INTO firma.pensja VALUES('p3', 'menadżer produktu', '1800');
INSERT INTO firma.pensja VALUES('p4', 'informatyk', '4000');
INSERT INTO firma.pensja VALUES('p5', 'kontroler finansowy', '3500');
INSERT INTO firma.pensja VALUES('p6', 'dyrektor biura zarządu', '5000');
INSERT INTO firma.pensja VALUES('p7', 'dostawca', '1600');
INSERT INTO firma.pensja VALUES('p8', 'menadżer produktu', '2200');
INSERT INTO firma.pensja VALUES('p9', 'księgowa', '2000');
INSERT INTO firma.pensja VALUES('p10', 'sprzątaczka', '950');

INSERT INTO firma.premia VALUES('b1', 'Premia regulaminowa', 500.00);
INSERT INTO firma.premia VALUES('b2', 'Premia uznaniowa', 700.00);
INSERT INTO firma.premia VALUES('b3', 'Premia zadaniowa', 400.00);
INSERT INTO firma.premia VALUES('b4', 'Premia motywacyjna', 400.00);
INSERT INTO firma.premia VALUES('b5', 'Premia indywidualna', 500.00);
INSERT INTO firma.premia VALUES('b6', 'Premia świąteczna', 500.00);
INSERT INTO firma.premia VALUES('b7', 'Brak', 0.00);
INSERT INTO firma.premia VALUES('b8', 'Premia zespołowa', 300.00);
INSERT INTO firma.premia VALUES('b9', 'Premia kwartalna', 600.00);
INSERT INTO firma.premia VALUES('b10', 'Premia dla najlepszego pracownika', 1000.00);

INSERT INTO firma.wynagrodzenie VALUES('w1', '2019-05-05', '10', 'g1', 'p5', 'b7');
INSERT INTO firma.wynagrodzenie VALUES('w2', '2019-05-05', '9', 'g2', 'p4', 'b3');
INSERT INTO firma.wynagrodzenie VALUES('w3', '2019-05-05', '2', 'g3', 'p7', 'b4');
INSERT INTO firma.wynagrodzenie VALUES('w4', '2019-05-05', '6', 'g9', 'p1', 'b5');
INSERT INTO firma.wynagrodzenie VALUES('w5', '2019-05-05', '5', 'g8', 'p5', 'b7');
INSERT INTO firma.wynagrodzenie VALUES('w6', '2019-05-05', '1', 'g6', 'p2', 'b6');
INSERT INTO firma.wynagrodzenie VALUES('w7', '2019-05-05', '7', 'g7', 'p10', 'b8');
INSERT INTO firma.wynagrodzenie VALUES('w8', '2019-05-05', '4', 'g5', 'p8', 'b1');
INSERT INTO firma.wynagrodzenie VALUES('w9', '2019-05-05', '8', 'g10', 'p8', 'b9');
INSERT INTO firma.wynagrodzenie VALUES('w10', '2019-05-05', '3', 'g4', 'p8', 'b10');

-- 6) Wykonanie nastepujacych zapytan
-- a) wyświetlenie tylko id pracownika oraz jego nazwiska --
SELECT id_pracownika, nazwisko
FROM firma.pracownicy KP

-- b) wyświetlenie id pracowników, których płaca jest większa niż 1000 --
SELECT id_pracownika
FROM firma.wynagrodzenie KW, firma.pensja PENSJA
WHERE PENSJA.id_pensji = KW.id_pensji AND PENSJA.kwota > '1000';

-- c) wyświetlenie id pracowników nieposiadających premii, których płaca jest większa niż 2000 --
SELECT id_pracownika
FROM firma.wynagrodzenie KW, firma.pensja PENSJA, firma.premia PREMIA
WHERE PENSJA.id_pensji = KW.id_pensji  
AND PREMIA.id_premii = KW.id_premii 
AND PREMIA.kwota IS NULL AND PENSJA.kwota > '2000';

-- d) wyświetlenie pracowników, których pierwsza litera imienia zaczyna się na literę 'J' --
SELECT * FROM firma.pracownicy
WHERE imie LIKE 'J%';

-- e) wyświetlenie pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’--
SELECT * 
FROM firma.pracownicy 
WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';

-- f) wyświetlenie imienia i nazwiska pracowników oraz liczby ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 h miesięcznie --
SELECT imie, nazwisko, (liczba_godzin - 160) AS nadgodziny
FROM firma.pracownicy FP, firma.godziny FG
WHERE FP.id_pracownika = FG.id_pracownika AND FG.liczba_godzin >160;

-- g) wyświetlenie imienia i nazwiska pracowników których pensja zawiera się w przedziale 1500 – 3000 PLN --
SELECT imie, nazwisko
FROM firma.pracownicy FP, firma.wynagrodzenie FW, firma.pensja PENSJA
WHERE FP.id_pracownika = FW.id_pracownika AND PENSJA.id_pensji = FW.id_pensji 
AND PENSJA.kwota BETWEEN '1500' AND '3000';

-- h) wyświetlenie imienia i nazwiska pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii --
SELECT imie, nazwisko 
FROM firma.pracownicy FP, firma.godziny FG, firma.premia PREMIA, firma.wynagrodzenie FW
WHERE FP.id_pracownika = FG.id_pracownika 
AND FG.id_godziny = FW.id_godziny 
AND PREMIA.id_premii = FW.id_premii
AND PREMIA.kwota IS NULL AND FG.liczba_godzin > 160;

-- 7) Wykonanie poniższych polecen
-- a) uszeregowanie pracowników według pensji 
SELECT imie, nazwisko, kwota AS pensja 
FROM firma.pracownicy FP, firma.wynagrodzenie FW, firma.pensja PENSJA
WHERE FP.id_pracownika = FW.id_pracownika AND  PENSJA.id_pensji = FW.id_pensji 
ORDER BY PENSJA.kwota;

-- b) uszeregowanie pracowników według pensji i premii malejąco --
SELECT imie, nazwisko, PENSJA.kwota AS pensja, PREMIA.kwota AS premia
FROM firma.pracownicy FP, firma.wynagrodzenie FW, firma.pensja PENSJA, firma.premia PREMIA
WHERE FW.id_pracownika = FP.id_pracownika 
AND PENSJA.id_pensji = FW.id_pensji  
AND PREMIA.id_premii = FW.id_premii 
ORDER BY PENSJA.kwota DESC, PREMIA.kwota DESC;

-- c) zliczenie i pogrupowanie pracowników według pola ‘stanowisko’
SELECT COUNT(stanowisko) AS liczba_stanowisko, stanowisko 
FROM firma.pensja PENSJA
JOIN firma.wynagrodzenie FW
ON PENSJA.id_pensji = FW.id_pensji 
GROUP BY(stanowisko);

-- d) policzenie średniej, minimalnej i maksymalnej płacy dla stanowiska ‘menadżer produktu’ --
SELECT AVG(kwota::money::numeric::float8) AS średnia_płaca, MIN(kwota), MAX(kwota) 
FROM firma.pensja PENSJA
WHERE stanowisko LIKE 'menadżer produktu';

-- e) policzenie sumy wszystkich wynagrodzeń --
SELECT SUM(pensja.kwota)+SUM(premia.kwota) AS suma_wynagrodzeń 
FROM firma.pensja PENSJA, firma.premia PREMIA, firma.wynagrodzenie KW
WHERE PENSJA.id_pensji = FW.id_pensji
AND PREMIA.id_premii = FW.id_premii;

-- f) policzenie sumy wynagrodzeń w ramach danego stanowiska --
SELECT stanowisko, 
SUM(pensja.kwota)+ SUM(premia.kwota) AS suma_wynagrodzeń_stanowisko 
FROM firma.pensja PENSJA, firma.premia PREMIA, firma.wynagrodzenie FW
WHERE  PENSJA.id_pensji = FW.id_pensji
AND PREMIA.id_premii = FW.id_premii 
GROUP BY (stanowisko);

-- g) wyznaczenie liczby premii przyznanych dla pracowników danego stanowiska --
SELECT COUNT(rodzaj) AS liczba_premii, stanowisko
FROM firma.premia PREMIA, firma.wynagrodzenie FW, firma.pensja PENSJA
WHERE PREMIA.id_premii = FW.id_premii
AND PENSJA.id_pensji = FW.id_pensji
GROUP BY (stanowisko);

-- h) usunięcie wszystkich pracowników mających pensję mniejszą niż 1200 zł --
DELETE FROM  firma.wynagrodzenie FW    
USING firma.pensja PENSJA
WHERE PENSJA.id_pensji = FW.id_pensji AND PENSJA.kwota < '1200' ;


-- 8) Wykonanie poniższych poleceń
-- a) Zmodyfikuj numer telefonu w tabeli pracownicy, dodając do niego kierunkowy dla Polski w nawiasie (+48) --
UPDATE firma.pracownicy SET telefon = '(+48)' || telefon


-- b) Zmodyfikuj atrybut telefonu tabeli pracownicy tak, aby numer oddzielony był myślnikami wg wzoru: ‘555-222-333’ 
-- dla numeru nie zawierającego (+48) --
UPDATE firma.pracownicy FP SET telefon = SUBSTRING(telefon, 1, 3)
|| '-'|| SUBSTRING(telefon, 3, 3)|| '-'||SUBSTRING(telefon, 6, 3) 

-- dla numeru po modyfikacji (+48) --
UPDATE firma.pracownicy FP SET telefon = SUBSTRING(telefon, 1, 8)
|| '-'|| SUBSTRING(telefon, 9, 3)|| '-'||SUBSTRING(telefon, 12, 3) 

-- c) Wyświetl dane pracownika, którego nazwisko jest najdłuższe, używając dużych liter --
SELECT UPPER(nazwisko) AS najdłuższe_drukowanymi FROM firma.pracownicy FP
WHERE LENGTH(nazwisko) = (SELECT MAX(LENGTH(nazwisko)) FROM firma.pracownicy FP )

-- d) Wyświetl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5 --
SELECT FP.*, MD5('kwota') AS md5_pensja 
FROM firma.wynagrodzenie FW, firma.pracownicy FP
WHERE FW.id_pracownika = FP.id_pracownika 

-- f) Wyświetl pracowników, ich pensje oraz premie. Wykorzystaj złączenie lewostronne. --
SELECT  FP.* , PENSJA.kwota AS pensja, PREMIA.kwota AS premia
FROM firma.pracownicy FP
LEFT JOIN firma.wynagrodzenie FW
ON FW.id_pracownika = FP.id_pracownika 
LEFT JOIN firma.pensja PENSJA
ON FW.id_pensji = PENSJA.id_pensji  
LEFT JOIN firma.premia PREMIA
ON FW.id_premii = PREMIA.id_premii 

-- 9) Raport końcowy - Utworzenie zapytania zwracającego w wyniku treść wg poniższego szablonu:
-- Pracownik Jan Nowak, w dniu 7.08.2017 otrzymał pensję całkowitą na kwotę 7540 zł, gdzie wynagrodzenie zasadnicze wynosiło: 5000 zł, premia: 2000 zł, nadgodziny: 540 zł.

SELECT CONCAT('Pracownik ', FP.imie, ' ', FP.nazwisko,' w dniu ', FG.data, ' otrzymał pensję całkowitą na kwotę ', 
			  (PENSJA.kwota + PREMIA.kwota),', gdzie wynagrodzenie zasadnicze wynosiło: ', PENSJA.kwota, ', premia: ',
			  PREMIA.kwota, ', nadgodziny: ',(liczba_godzin - 160 )) AS raport
FROM firma.pracownicy FP, firma.godziny FG, firma.premia PREMIA, firma.pensja PENSJA, firma.wynagrodzenie FW
WHERE FW.id_pracownika = FP.id_pracownika
AND FW.id_godziny = FG.id_godziny
AND FW.id_pensji = PENSJA.id_pensji
AND FW.id_premii = PREMIA.id_premii

