--DEL 1
--Oppgave 1
--Kjøre SQL-script for å opprette databasen.

--Oppgave 2a
SELECT navn, oppdaget, stjerne 
FROM planet 
WHERE stjerne = 'Proxima Centauri' ;

--Oppgave 2b
SELECT DISTINCT oppdaget
FROM planet 
WHERE stjerne = 'TRAPPIST-1' OR stjerne = 'Kepler-154' ;

--Oppgave 2c
SELECT count(*) AS antMasseNull 
FROM planet 
WHERE masse IS NULL;

--Oppgave 2d
SELECT navn, masse 
FROM planet 
WHERE oppdaget = '2020' AND masse > (SELECT avg(masse)
                                     FROM planet) ;

--Oppgave 2e
SELECT max(oppdaget) AS max, 
       min(oppdaget) AS min, 
       max(oppdaget) - min(oppdaget) AS antAAr 
FROM planet ;

--Oppgave 3a
SELECT navn 
FROM planet, materie 
WHERE planet.navn = materie.planet AND materie.molekyl = 'H2O' 
                                   AND (masse > 3 AND masse < 10) ;

--Oppgave 3b
SELECT DISTINCT planet.navn
FROM planet, stjerne, materie 
WHERE stjerne.navn = planet.stjerne AND avstand < stjerne.masse * 12 
                                    AND molekyl = 'H' ;

--Oppgave 3c*
/*Oppgaven var litt uklar for meg, antok at oppgaven spør etter planetene
som har masse større enn 10 og avstanden er mindre enn 50.*/
SELECT planet.navn from planet, stjerne  where planet.masse > 10 AND avstand < 50 ;

/*Oppgave 4
Her ser vi at Nils har brukt NATURAL JOIN for å joine stjerne tabellen med
planet tabellen. Det som skjer her er at NATURAL JOIN vil kunne joine kollonnene
med samme navn. I dette tilfelle så vil planet.navn og planet masse, joines med
stjerne.navn og stjerne.masse. Han er ute etter planeter med avstand på 8000, og
de vil ikke bli kunne hentet ut ettersom navna på stjernene og planetene blir 
slått sammen. 
*/

--DEL 2
--Oppgave 5a
INSERT INTO stjerne 
VALUES ('Sola', 0, 1.0) ;

--Oppgave 5b
INSERT INTO planet 
VALUES ('Jorda', 0.003146, null, 'Sola') ;

--Oppgave 6
CREATE TABLE observasjon (
    observasjons_id int PRIMARY KEY, 
    tid_oberservert TIMESTAMP NOT NULL,
    planet_observert text NOT NULL,
    kommentar text
) ;