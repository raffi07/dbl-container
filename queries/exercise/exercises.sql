-- 1. all members

SELECT * FROM member;

-- 2. all vehicles

SELECT * FROM vehicle;

-- 3. all motor cars

SELECT * FROM motorcar;

-- 4. all limousines

SELECT * FROM limousine;

-- 5. current date and time

SELECT current_timestamp;

-- 6. the full names of all persons (unless specified otherwise, from now on the full name,
-- 'firstname lastname' is required whenever 'name' is mentioned)

SELECT firstname || ' ' || lastname AS full_name
FROM person;

-- 7. the names of all person members

SELECT firstname || ' ' || lastname AS full_name
FROM personmember;

-- 8. the names and home location of the person members, in the order of the home locations

SELECT
    firstname || ' ' || lastname AS full_name,
    homelocation
FROM personmember
ORDER BY homelocation;

-- 9. names and home locations of the coop members sorted by home location name

SELECT
    firstname || ' ' || lastname AS full_name,
    name
FROM coopmember AS c
LEFT JOIN location AS l ON l.id = c.homelocation
ORDER BY name;

-- 10. the licenseplate, make, and model of all vehicles

SELECT
    licenseplate,
    make,
    model
FROM vehicle;

-- 11. Make, model, and name of the home location of the vehicles

SELECT
    make,
    model,
    name
FROM vehicle AS v
JOIN location AS l ON l.id = v.home;

-- 12. Make, model, and name of the home location of the vehicles.
-- The make and model of vehicles without home location should be shown as well

SELECT
    make,
    model,
    name
FROM vehicle AS v
LEFT JOIN location AS l on l.id = v.home;

-- 13. Make, model, and name of the home location of the vehicles. The make and model of vehicles without home location
-- as well as the locations without vehicles should be shown as well

SELECT
    make,
    model,
    name
FROM vehicle AS v
FULL OUTER JOIN location AS l on l.id = v.home;

-- 14. Vehicles without a home location

SELECT
    *
FROM vehicle
WHERE home IS NULL;

-- 15. Locations without vehicles

SELECT *
FROM location AS l
FULL OUTER JOIN vehicle AS v ON v.home = l.id
WHERE v.id IS NULL;

-- 16. short name, long name, and address of the locations

SELECT shortname, name, address
FROM location;

-- 17. short name, long name, and city of the locations

SELECT shortname, name, (address).city
FROM location;

-- 18. the reservation of vehicle 'ZH-1020'

SELECT r.*, v.licenseplate
FROM reservation AS r
LEFT JOIN vehicle AS v ON v.id = r.vehicle
WHERE licenseplate = 'ZH-1020';

-- 19. the reservations of the member with member number 1000

SELECT r.*, membernr
FROM reservation AS r
LEFT JOIN member AS m ON m.id = r.member
WHERE membernr = 1000;

-- 20. open (future) reservations of the member number 1000

SELECT r.*, membernr, "interval"
FROM reservation AS r
LEFT JOIN member AS m ON m.id = r.member
WHERE membernr = 1000
AND (interval).begints > current_timestamp;

-- 21. all vehicles whose home location is in the city of Zurich

SELECT v.*, city
FROM vehicle AS v
LEFT JOIN location AS l ON v.home = l.id
LEFT JOIN LATERAL (
    SELECT (address).city AS city
    ) ON TRUE
WHERE city = 'Zuerich';

-- 22. the locations and number of limousines at each location

SELECT loc.id, loc.name, COUNT(limo.id) AS limo_count
FROM location AS loc
LEFT JOIN limousine AS limo ON limo.home = loc.id
GROUP BY loc.id, loc.name;

-- 23. all open invoices (unpaid)

SELECT *
FROM invoice
WHERE ispaid = FALSE;

-- 24. all overdue invoices

SELECT *
FROM invoice
WHERE duedate > '2024-10-10';

-- 25. all reservations that have not yet been billed

SELECT r.*
FROM reservation AS r
LEFT JOIN invoice AS i ON r.member = i.member
WHERE i.id IS NULL;

-- 26. the invoices for member number 1000

SELECT
    i.*,
    m.membernr
FROM invoice AS i
LEFT JOIN member AS m ON m.id = i.member
WHERE membernr = 1000;

-- 27. the license plates of the vehicles which have been used (not only reserved)

SELECT DISTINCT v.licenseplate
FROM useofvehicle AS u
LEFT JOIN reservation AS r ON u.reservation = r.resnumber
LEFT JOIN vehicle AS v ON v.id = r.vehicle;

-- 28. the names of the person members plus the indication if the members have had an accident

SELECT
    firstname,
    lastname,
    hadaccident
FROM personmember;

-- 29. the names of the person members plus the indication if the members have had an accident (nicely formatted)

SELECT
    firstname || ' ' || lastname AS name,
    hadaccident
FROM personmember;

-- 30. which person members have had an accident?

SELECT *
FROM personmember
WHERE hadaccident = TRUE;

-- 31. the correct price per kilometer for each use

SELECT u.*,
       i.total / u.kilometers::numeric AS price_per_kilometer
FROM useofvehicle AS u
LEFT JOIN invoice AS i ON u.invoice = i.invoicenumber;

-- 32. the distance-based prices for the vehicle uses

SELECT *
FROM useofvehicle AS u

