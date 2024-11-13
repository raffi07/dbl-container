
-- SQL Exercises
-- 1
-- alle Mitglieder
-- all members

SELECT * FROM member;

-- 2
-- alle Fahrzeuge
-- all vehicles

SELECT * FROM vehicle;

-- 3
-- alle Personenwagen
-- all motor cars

SELECT * FROM motorcar;

-- 4
-- alle Limousinen
-- all limousines

SELECT * FROM limousine;

-- 5
-- Aktuelles Datum und Uhrzeit
-- current date and time

SELECT current_timestamp;

-- 6
-- die vollen Namen aller Personen (Wenn nicht anders spezifiziert, ist ab jetzt mit “Name” immer der volle Name, d.h. “vorname nachname”, gemeint)
-- the full names of all persons (unless specified otherwise, from now on the full name, “firstname lastname” is required whenever “name” is mentioned)

SELECT firstname || ' ' || lastname AS full_name
FROM person;

-- 7
-- die Namen aller persoenlichen Mitglieder
-- the names of all person members

SELECT firstname || ' ' || lastname AS full_name
FROM personmember;

-- 8
-- die Namen und Heimatstationen der persoenlichen Mitglieder, sortiert nach Station
-- the names and home location of the person members, in the order of the home locations

SELECT
    firstname || ' ' || lastname AS full_name,
    homelocation
FROM personmember
ORDER BY homelocation;

-- 9
-- die Namen und Heimatstation der Genossenschaftsmitglieder, sortiert nach Namen der Heimatstation
-- names and home locations of the coop members sorted by home location name

SELECT
    firstname || ' ' || lastname AS full_name,
    name
FROM coopmember AS c
LEFT JOIN location AS l ON l.id = c.homelocation
ORDER BY name;

-- 10
-- die Kennzeichen, Marken und Modelle aller Fahrzeuge
-- the licenseplate, make, and model of all vehicles

SELECT
    licenseplate,
    make,
    model
FROM vehicle;

-- 11
-- die Marken und Modelle der Fahrzeuge mit Namen der Heimatstation
-- Make, model, and name of the home location of the vehicles

SELECT
    make,
    model,
    name
FROM vehicle AS v
JOIN location AS l ON l.id = v.home;

-- 12
-- die Marken und Modelle der Fahrzeuge mit dem Namen der Heimatstation. Auch die Fahrzeuge ohne Heimatstation sollen angezeigt werden.
-- Make, model, and name of the home location of the vehicles. The make and model of vehicles without home location should be shown as well

SELECT
    make,
    model,
    name
FROM vehicle AS v
LEFT JOIN location AS l on l.id = v.home;

-- 13
-- die Marken und Modelle der Fahrzeuge mit Heimatstation. Auch die Fahrzeuge ohne Heimatstation und die Stationen ohne Fahrzeuge sollen angezeigt werden.
-- Make, model, and name of the home location of the vehicles. The make and model of vehicles without home location as well as the locations without vehicles should be shown as well

SELECT
    make,
    model,
    name
FROM vehicle AS v
FULL OUTER JOIN location AS l on l.id = v.home;

-- 14
-- Fahrzeuge ohne Heimatstation
-- Vehicles without a home location

SELECT
    *
FROM vehicle
WHERE home IS NULL;

-- 15
-- Stationen ohne Fahrzeuge
-- Locations without vehicles

SELECT *
FROM location AS l
FULL OUTER JOIN vehicle AS v ON v.home = l.id
WHERE v.id IS NULL;

-- 16
-- die Kuerzel, Namen und Addressen der Stationen
-- short name, long name, and address of the locations

SELECT shortname, name, address
FROM location;

-- 17
-- die Kuerzel, Namen und Orte der Stationen
-- short name, long name, and city of the locations

SELECT shortname, name, (address).city
FROM location;

-- 18
-- die Reservationen des Fahrzeugs 'ZH-1020'
-- the reservation of vehicle 'ZH-1020'

SELECT r.*, v.licenseplate
FROM reservation AS r
LEFT JOIN vehicle AS v ON v.id = r.vehicle
WHERE licenseplate = 'ZH-1020';

-- 19
-- die Reservationen des Mitglieds mit der Nummer 1000
-- the reservations of the member with member number 1000

SELECT r.*, membernr
FROM reservation AS r
LEFT JOIN member AS m ON m.id = r.member
WHERE membernr = 1000;

-- 20
-- die offenen (zukünftigen) Reservationen des Mitglieds mit der Nummer 1000
-- open (future) reservations of the member number 1000

SELECT r.*, membernr, "interval"
FROM reservation AS r
LEFT JOIN member AS m ON m.id = r.member
WHERE membernr = 1000
AND (interval).begints > current_timestamp;


-- 21
-- alle Fahrzeuge in Zürich
-- all vehicles whose home location is in the city of Zurich

SELECT v.*, city
FROM vehicle AS v
LEFT JOIN location AS l ON v.home = l.id
LEFT JOIN LATERAL (
    SELECT (address).city AS city
    ) ON TRUE
WHERE city = 'Zuerich';

-- 22
-- die Anzahl Limousinen pro Station
-- the locations and number of limousines at each location

SELECT loc.id, loc.name, COUNT(limo.id) AS limo_count
FROM location AS loc
LEFT JOIN limousine AS limo ON limo.home = loc.id
GROUP BY loc.id, loc.name;

-- 23
-- alle offenen (unbezahlten) Rechnungen
-- all open invoices (unpaid)

SELECT *
FROM invoice
WHERE ispaid = FALSE;

-- 24
-- alle ueberfaelligen Rechnungen
-- all overdue invoices

SELECT *
FROM invoice
WHERE duedate > '2024-10-10';

-- 25
-- alle Reservationen, die noch nicht in Rechnung gestellt wurden
-- all reservations that have not yet been billed

SELECT r.*
FROM reservation AS r
LEFT JOIN invoice AS i ON r.member = i.member
WHERE i.id IS NULL;

-- 26
-- die Rechnungen des Mitglieds mit der Nummer 1000
-- the invoices for member number 1000

SELECT
    i.*,
    m.membernr
FROM invoice AS i
LEFT JOIN member AS m ON m.id = i.member
WHERE membernr = 1000;

-- 27
-- die Kennzeichen der Fahrzeuge der Benutzungen
-- the license plates of the vehicles which have been used (not only reserved)

SELECT DISTINCT v.licenseplate
FROM useofvehicle AS u
LEFT JOIN reservation AS r ON u.reservation = r.resnumber
LEFT JOIN vehicle AS v ON v.id = r.vehicle;

-- 28
-- die Namen der persoenlichen Mitglieder zusammen mit der Angabe, ob sie bereits einen Unfall hatten
-- the names of the person members plus the indication if the members have had an accident

SELECT
    firstname,
    lastname,
    hadaccident
FROM personmember;

-- 29
-- die Namen der persoenlichen Mitglieder zusammen mit der Angabe, ob sie bereits einen Unfall hatten (schoen formattiert)
-- the names of the person members plus the indication if the members have had an accident (nicely formattted)

SELECT
    firstname || ' ' || lastname AS name,
    hadaccident
FROM personmember;

-- 30
-- welche persoenlichen  Mitglieder hatten bereits einen Unfall?
-- which person members have had an accident?

SELECT *
FROM personmember
WHERE hadaccident = TRUE;

-- 31
-- die den einzelnen Benutzungen zugrundeliegenden Kilometerpreise
-- the correct price per kilometer for each use

SELECT u.*,
       i.total / u.kilometers::numeric AS price_per_kilometer
FROM useofvehicle AS u
LEFT JOIN invoice AS i ON u.invoice = i.invoicenumber;

-- 32
-- Entfernungsbasierte Kosten der Benutzungen
-- the distance-based prices for the vehicle uses

SELECT u.*,
       i.total - u.fuelcosts AS distance_based_price
FROM useofvehicle AS u
LEFT JOIN invoice AS i ON u.invoice = i.invoicenumber;

-- 33
-- Die Summe der Benutzungsdauern pro Tag
-- the sum (of hours) of vehicle uses per day

SELECT* -- TODO
FROM useofvehicle;

-- 34
-- Die durchschnittliche Benutzungsdauer
-- The average duration of vehicle use

SELECT ROUND(AVG(hours), 2)
FROM useofvehicle;

-- 35
-- die kürzeste Entfernung, die während einer Benutzung zurückgelegt wurde
-- The shortest distance (in kilometers) driven in a single vehicle use

SELECT MIN(kilometers)
FROM useofvehicle;

-- 36
-- die durchschnittliche Entfernung pro Benutzung
-- the average distance driven per vehicle use

SELECT ROUND(AVG(kilometers))
FROM useofvehicle;

-- 37
-- die Summe der Entfernungen, die pro Fahrzeug zurückgelegt wurde
-- the sum of distances driven per vehicle

SELECT vehicle, SUM(kilometers) AS sum_distance_per_vehicle
FROM useofvehicle AS u
LEFT JOIN reservation AS r ON u.reservation = r.resnumber
GROUP BY vehicle;

-- 38
-- die durchschnittliche Entfernungen, die pro Fahrzeug zurückgelegt wurde (in allen Reservationen)
-- the average distance driven per vehicle (in all reservations)

SELECT vehicle, ROUND(AVG(kilometers), 2) AS avg_distance_per_vehicle
FROM useofvehicle AS u
LEFT JOIN reservation AS r ON u.reservation = r.resnumber
GROUP BY vehicle;

-- 39
-- die Namen und Jahresgebuehren der persoenlichen Mitglieder
-- the names and yearly fees of the person members

SELECT firstname || ' ' || lastname AS name, basicfee - reduction AS yearly_fees
FROM personmember AS p
LEFT JOIN memberfees AS m ON m.membertype = p.type;


-- 40
-- die Namen  und Jahresgebuehren der Firmenmitglieder
-- the names and yearly fees of the company members

SELECT companyname, basicfee - reduction AS yearly_fees
FROM companymember AS p
LEFT JOIN memberfees AS m ON m.membertype = p.type;

-- 41
-- die Namen und Jahresgebuehren der Genossenschaftsmitglieder
-- the names  and yearly fees of the coop members

SELECT firstname || ' ' || lastname AS name, COALESCE(basicfee, 0) - COALESCE(reduction, 0) AS yearly_fees
FROM coopmember AS p
LEFT JOIN memberfees AS m ON m.membertype = p.type;

-- 42
-- die Namen und Jahresgebuehren aller Mitglieder
-- the names and yearly fees of all members

SELECT firstname || ' ' || lastname AS name, COALESCE(basicfee, 0) - COALESCE(reduction, 0) AS yearly_fees
FROM personmember AS p
LEFT JOIN memberfees AS m ON m.membertype = p.type
UNION ALL
SELECT companyname, COALESCE(basicfee,0) - COALESCE(reduction,0) AS yearly_fees
FROM companymember AS p
LEFT JOIN memberfees AS m ON m.membertype = p.type
UNION ALL
SELECT firstname || ' ' || lastname AS name, COALESCE(basicfee, 0) - COALESCE(reduction, 0) AS yearly_fees
FROM coopmember AS p
LEFT JOIN memberfees AS m ON m.membertype = p.type;;


-- 43
-- alle saeumigen Mitglieder
-- the members with due and open invoices

SELECT m.*, ispaid
FROM invoice AS i
LEFT JOIN member AS m ON m.membernr = i.member
WHERE ispaid = FALSE;

-- 44
-- alle saeumigen persoenlichen Mitglieder
-- the person members with due and open invoices

SELECT p.*, ispaid
FROM invoice AS i
LEFT JOIN personmember AS p ON p.membernr = i.member
WHERE ispaid = FALSE;


-- 45
-- die Namen der saeumigen persoenlichen Mitglieder
-- the full names of person members with due and open invoices

SELECT p.firstname || ' ' || p.lastname AS name, ispaid
FROM invoice AS i
LEFT JOIN personmember AS p ON p.membernr = i.member
WHERE ispaid = FALSE;

-- 46
-- die Namen der saeumigen persoenlichen Mitglieder (nun jedes Mitglied nur einmal !)
-- the full names of person members with due and open invoices (make sure that each name appears only once)

SELECT DISTINCT ON (membernr) p.firstname || ' ' || p.lastname AS name, ispaid
FROM invoice AS i
LEFT JOIN personmember AS p ON p.membernr = i.member
WHERE ispaid = FALSE;

-- 47
-- alle persoenlichen Mitglieder, die in einem Ort wohnen, in dem es eine Station mit Limousinen gibt
-- all person members living in a city with a location which has limousines

-- 48
-- die Reservationsen fuer Fahrzeuge beliebigen Typs an der station ust
-- all reservations for vehicles of any category at the location ust

-- 49
-- die Reservationsen fuer Fahrzeuge beliebigen Typs an der station ust am 11.11.2024 von 9-10 Uhr
-- all reservations for vehicles of any category at the location ust on 11.11.2024 at 9-10

-- 50
-- alle Fahrzeuge beliebigen Typs, die am 11.11.2024 um 9:00 Uhr frei waren
-- all vehicles which are free on 11.11.2024 at 9:00

-- 51
-- alle Fahrzeuge beliebigen Typs an der Station ust, die am 11.11.2024 um 9:00 Uhr frei waren
-- all vehicles at location ust which are free on 11.11.2024 at 9:00

-- 52
-- alle PKWs mit Kindersitz an der Station grs, die am 11.11.2024 um 9:00 Uhr frei waren
-- all motor cars with a child seat at location ust which are free on 11.11.2024 at 9:00

-- 53
-- Kennzeichen mit der Angabe, ob das Fahrzeug am 11.11..2024 von 9-10 Uhr frei war
-- all license plates together with the information whether the vehicle was free on 11.11..2024 from 9-10

-- 54
-- die Kennzeichen der Fahrzeuge zusammen mit der Anzahl der Reservationen am 11.11.2024 von 9-10 Uhr
-- all license plates with the number of reservations free on 09.09.2024 from 9-10

-- 55
-- die Kuerzel der Stationen zusammen mit der Anzahl der Fahrzeuge, die am 11.11.2024 von 9-10 Uhr frei sind
-- the short names of locations with the number of vehicles at each location which are free on 11.11.2024 from 9-10

-- 56
-- Benutzer ohne Reservationen
-- members without any reservations

-- 57
-- die Kennzeichen und Anzahl der Reservationen der einzelnen Fahrzeuge
-- the license plates and number of reservations of each vehicle

-- 58
-- der hoechste Kilometerstand eines Fahrzeugs
-- the maximum odometer value

-- 59
-- das Fahrzeug mit dem hoechsten Kilometerstand
-- the vehicle with the highest odometer value

-- 60
-- der höchste Benzinverbrauch eines Fahrzeugs
-- the highest fuel consumption of all vehicles

-- 61
-- das Fahrzeug mit dem höchsten Benzinverbrauch
-- the vehicle with the highest fuel consumption

-- 62
-- die Anzahl Limousinen pro Station
-- the number of limousines per location

-- 63
-- die maximale Anzahl Limousinen an einer Station
-- the highest number of limousines per location

-- 64
-- Die Station mit der maximalen Anzahl Limos
-- the location with the highest number of limousines

-- 65
-- alle Stationen, die (ueber die Nachbarschaftsbeziehung) in maximal vier Schritten von Mönchaltorf (moe) erreichbar sind
-- all locations that are reachable (via the nextLocation relationship) in no more than four steps from location moe

-- 66
-- der durchschnittliche Spritverbrauch pro Fahrzeug
-- the average fuel consumption (per 100km) per vehicle

-- 67
-- der maximale durchschnittliche Spritverbrauch pro Fahrzeug
-- the highest average fuel consumption per vehicle

-- 68
-- das Fahrzeug mit dem maximalen Spritverbrauch
-- the vehicle with the highest average fuel consumption

-- 69
-- der maximale, minimale und durchschnittliche Spritverbrauch pro Fahrzeugtyp
-- the highest, average, and smallest average fuel consumption by vehicle category

-- 70
-- maximaler Spritverbrauch pro Fahrzeug und Benutzer
-- the highest fuel consumption by member and vehicle (for a single reservation)

-- 71
-- der Benutzer und das Fahrzeug mit dem hoechsten Benzinverbrauch (für eine einzelne Benutzung)
-- member and vehicle with the highest fuel consumption (for a single reservation)

-- 72
-- das Fahrzeug mit dem maximalen Spritverbrauch
-- the vehicle with the highest fuel consumption  (NOT per kilometer)

-- 73
-- Kategorien und der höchste Kilometerstand pro Kategorie
-- Vehicle categories and the highest odometer value for each category

-- 74
-- Kategorien und der höchste Kilometerstand pro Kategorie sowie das Kennzeichen des Fahrzeugs (dieser Kategorie) mit diesem Kilometerstand
-- Vehicle categories and the highest odometer value for each category, plus the license plate of the vehicle with this odometer value

-- 75
-- Die Benutzungsdauern der Reservationen
-- the duration of the reservations

-- 76
-- Die Benutzungsdauern der Reservationen (jeden Wert nur einmal)
-- the duration of the reservations, list each value only once

-- 77
-- Die Benutzungsdauern der Reservationen (jeden Wert nur einmal), die längste Benutzung zuerst
-- the duration of the reservations, list each value only once and sort from largest to smallest

-- 78
-- Ein Histogramm der Benutzungsdauern der Reservationen, d.h. zu jeder Dauer die Angabe, wie oft sie vorkommt
-- a histogram of reservation durations, i.e., for each duration calculate how often it occurs

-- 79
-- die Kennzeichen und Anzahl der Reservationen der einzelnen Fahrzeuge, 
-- absteigend sortiert nach Anzahl der Reservationen, zusammen mit der 
-- kummulierten Summe der Reservationen und dem Anteil des Fahrzeugs an dieser 
-- kummulierten Summe (kummulierte Summe = Summe der Reservationen aller Fahrzeuge 
-- bis einschliesslich des aktuellen in der Liste)
-- the license plates and number of reservations per vehicle. order should be 
-- by number of reservations (largest to smallest). Also compute the cummulated sum of the 
-- reservations and the contribution of the current vehicle to the cummulated sum

-- 80
-- Jahr und Monat der Reservationen (Reservationsbeginn, jede Kombination nur einmal)
-- year and month of reservations (reservation begin; each combination only once)

-- 81
-- Jahr und Monat der Reservationen und Anzahl der Reservationen in diesem Monat (ausschlaggebend ist der Reservationsbeginn)
-- year and month of reservations and number of reservations during this month (use reservation begin)

-- 82
-- Jahr und Monat der Reservationen und Summe der Reservationsdauern in diesem Monat (ausschlaggebend ist der Reservationsbeginn)
-- year and month of reservations and sum of reservation durations during this month (use reservation begin)

-- 83
-- Jahr und Monat der Reservationen und Anzahl der Reservationen in diesem Monat (ausschlaggebend ist der Reservationsbeginn); und Bildung einer Rangliste innerhalb der einzelnen Jahre
-- year and month of reservations and number of reservations during this month (use reservation begin). Sort according to number of reservations within each year

-- 84
-- gleich wie oben, Summe der Reservationsdauern anstatt Anzahl Reservationen
-- same as above, but use sum of reservation durations instead of reservation count

-- 85
-- Jahr und Monat der Reservationen und Summe der Reservationsdauern in diesem Monat 
-- (ausschlaggebend ist der Reservationsbeginn); und Bildung einer Rangliste innerhalb der einzelnen Jahre. Ausgabe der auf der Rangliste führenden beiden Monate
-- same as above, but use sum of reservation durations instead of reservation count.  Return only the first two months

-- 86
-- gleitender 3-Monatsdurchschnitt der Reservationsanzahlen
-- calculate the 3-months moving average of reservation counts

-- 87
-- monatsweise kummulierte Summe der Reservationszahlen innerhalb eines Jahres
-- calculate the cumulated sums of monthly reservation counts per year

-- 88
-- Einteilung der Monate des Jahres 2024 in Tertile (drei Quantile) gemäss der Anzahl Reservationen
-- assign the months of the year 2024 to tertiles (three quantiles) based on the number of reservations per month

-- 89
-- Anzahl Reservationen gruppiert nach den Dimensionen Mitglied, Fahrzeug, Station
-- The number of reservations grouped over the dimensions member, vehicle, and location

-- 90
-- Anzahl Reservationen gruppiert nach allen möglichen Kombinationen der  Dimensionen Mitglied und Fahrzeugtyp
-- The number of reservations grouped over all possible combinations of the dimensions member (member number) and vehicle type.

-- 91
-- Anzahl Reservationen gruppiert nach allen möglichen Kombinationen der  Dimensionen Mitglied und Fahrzeugtyp, so dass auch Mitglieder und Fahrzeugtypen ohne Reservationen aufgeführt werden
-- The number of reservations grouped over all possible combinations of the dimensions member (member number) and vehicle type such that also types and members without reservations are shown.

-- 92
-- Anzahl Reservationen gruppiert nach allen möglichen Kombinationen der  Dimensionen 
-- Mitglied und Fahrzeugtyp, so dass auch Mitglieder und Fahrzeugtypen ohne Reservationen aufgeführt werden. Ausserdem sollen All- und Nullwerte unterschieden werden.
-- The number of reservations grouped over all possible combinations of the dimensions 
-- member (member number) and vehicle type such that also types and members without reservations are shown. In addition distinguish all and null values.

-- 93
-- Anzahl Reservationen hierarchisch gruppiert nach Jahr, Monat und Tag des Reservationsbeginns
-- The number of reservations hierarchically grouped over year, month, and day of the reservation begin

-- 94
-- alle Benutzer, die fern der Heimat reserviert haben (Fahrzeugstandort <> Heimatstandort des Benutzers)
-- all members who have reserved a vehicle at a location other than their home location

-- 95
-- alle Benutzer, die fern der Heimat reserviert haben (Fahrzeugstandort <> Heimatstandort des Benutzers), obwohl es den Fahrzeugtyp an der Heimatstation gibt
-- all members who have reserved a vehicle at a location other than their home location even though the vehicle type exists at their home location

-- 96
-- alle Benutzer, die fern der Heimat reserviert haben (Fahrzeugstandort <> Heimatstandort des Benutzers), obwohl es den Fahrzeugtyp an der Heimatstation gibt und eines der Fahrzeuge des gewuenschten Typs frei war/wäre.
-- all members who have reserved a vehicle at a location other than their home location even though the vehicle type exists at their home location and a vehicle of the desired time would be free during the interval in question

-- 97
-- ein Belegungsplan fuer das Auto '194 SUA' fuer den 11.11. 2024 und die folgenden beiden Tage
-- a free/busy plan for the vehicle '194 SUA' for 11.11. 2024 and the following two days

-- 98
-- ein Belegungsplan fuer die Station Greifensee fuer den 11.11. 2024
-- a free/busy plan for the location Greifensee  for 11.11. 2024

