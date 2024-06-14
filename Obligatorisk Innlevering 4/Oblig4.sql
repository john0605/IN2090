--DEL 1
--Oppgave 1 Oppvarming
SELECT f.title,
    p.firstname || ', ' || p.lastname AS Navn,
    fchar.filmcharacter
FROM person AS p
    INNER JOIN filmparticipation AS fpart USING (personid)
    INNER JOIN film AS f USING (filmid)
    INNER JOIN filmcharacter AS fchar USING (partid)
WHERE f.title = 'Star Wars';


--Oppgave 2 Land
SELECT fc.country,
    COUNT(*) AS ant
FROM filmcountry AS fc
GROUP BY country
ORDER BY ant DESC;


--Oppgave 3 Spilletider
SELECT avg(runningtime.time::int),
    country
FROM runningtime
WHERE country IS NOT null
    AND runningtime.time ~ '^\d$'
GROUP BY country
HAVING count(runningtime.time) >= 200;


--Oppgave 4 Komplekse mennesker
SELECT f.title,
    count(*) AS antGenre
FROM film AS f
    JOIN filmgenre AS fg USING (filmid)
GROUP BY f.filmid,
    title
ORDER BY antGenre DESC,
    title
LIMIT 10;


--Oppgave 6 Vennskap
SELECT DISTINCT p.firstname || ', ' || p.lastname AS navn1,
    p2.firstname || ', ' || p2.lastname AS navn2
FROM film
    INNER JOIN filmcountry USING (filmid)
    INNER JOIN filmparticipation AS fpart USING (filmid)
    INNER JOIN filmparticipation AS fpart2 USING (filmid)
    INNER JOIN person AS p ON (p.personid = fpart.personid)
    INNER JOIN person AS p2 ON (p2.personid = fpart2.personid)
WHERE fpart.personid < fpart2.personid
    AND filmcountry.country = 'Norway'
GROUP BY navn1,
    navn2
HAVING count(*) > 40;


--DEL 2
--Oppgave 7 Mot
SELECT DISTINCT f.title,
    f.prodyear
FROM film AS f
    INNER JOIN filmgenre AS fg ON (f.filmid = fg.filmid)
    INNER JOIN filmcountry AS fcoun ON (f.filmid = fcoun.filmid)
WHERE (
        f.title LIKE '%Night%'
        OR f.title
        LIKE '%Dark%'
    )
    OR (
        f.title LIKE '%Night%'
        AND f.title
        LIKE '%Dark%'
    )
    AND (
        (
            fg.genre = 'Horror'
            OR fcoun.country LIKE 'Romania'
        )
        OR (
            fg.genre = 'Horror'
            AND fcoun.country = 'Romania'
        )
    )
ORDER BY f.prodyear DESC;


--Oppgave 8 Lunsj*


--Oppgave 9 Introspeksjon
/*Usikker på om jeg har gjort det riktig her. Antok at
 oppgaven spør om filmer som enten har Horror eller Sci-fi*/
SELECT count(filmid) AS AntFilmerUten
FROM filmgenre AS fg
WHERE NOT fg.genre = 'Horror'
    OR NOT fg.genre = 'Sci-Fi';


--Oppgave 10 Kompetansehevning
WITH Krav AS(
    SELECT f.title,
        fRat.rank,
        fRat.votes,
        f.filmid
    FROM filmitem AS fm
        NATURAL JOIN filmrating AS fRat
        NATURAL JOIN film AS f
    WHERE fRat.votes > 1000
        and fRat.rank >= 8 AND fRat.rank <= 10
        and fm.filmtype = 'C'
),
rankVote AS(
    (
        SELECT Krav.title,
            Krav.rank,
            Krav.votes,
            Krav.filmid
        FROM Krav
        GROUP BY Krav.title,
            Krav.rank,
            Krav.votes,
            Krav.filmid
        ORDER BY Krav.rank DESC,
            Krav.votes DESC
        LIMIT 10
    )
    UNION
    (
        SELECT Krav.title,
            Krav.rank,
            Krav.votes,
            Krav.filmid
        FROM Krav
            INNER JOIN filmparticipation AS fpart ON (fpart.filmid = Krav.filmid)
            INNER JOIN person AS p ON (fpart.personid = p.personid)
        WHERE p.firstname = 'Harrison'
            AND p.lastname = 'Ford'
    )
    UNION
    (
        SELECT Krav.title,
            Krav.rank,
            Krav.votes,
            Krav.filmid
        FROM Krav
            INNER JOIN filmgenre AS fgen ON (Krav.filmid = fgen.filmid)
        WHERE fgen.genre = 'Comedy'
            OR fgen.genre = 'Romance'
    )
)
SELECT rankVote.title,
    (
        SELECT count(*)
        from filmlanguage AS flang
        WHERE (rankVote.filmid  = flang.filmid)
    )
FROM rankVote
ORDER BY rankVote.title;