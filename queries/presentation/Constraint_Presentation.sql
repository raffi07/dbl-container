-------------------------------------------------------------------------------------------------------------
------------------------------------ CHECK CONSTRAINTS ------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- insert constraint for licence plate

ALTER TABLE Vehicle
ADD CONSTRAINT chk_license_plate_format
CHECK (licensePlate ~ '^[A-Z]{2}[0-9]{1,6}$');

-- Invalid license plate: too many digits and incorrect letter placement
INSERT INTO Vehicle (id, type, licensePlate, make, model, motorNumber, kilometers, isOperational, operationStart, lastService, gasConsumption, insurance, home)
VALUES 
(1, 'CompactCar', 'ZH12345XYZ', 'Toyota', 'Corolla', 'M123456789', 5000, true, '2021-01-01', '2023-05-01', 5.5, (1, 123), 1);


select * from VEHICLE;

-- Invalid license plate: too many digits and incorrect letter placement
INSERT INTO Vehicle (id, type, licensePlate, make, model, motorNumber, kilometers, isOperational, operationStart, lastService, gasConsumption, insurance, home)
VALUES 
(1, 'CompactCar', 'ZH12345', 'Toyota', 'Corolla', 'M123456789', 5000, true, '2021-01-01', '2023-05-01', 5.5, (1, 123), 1);

select * from VEHICLE;


--What happens when we already have data in the table and then want to add a constraint, which is not in in line with the data in the database?

-- add businessPartner with too long ZIP code
INSERT INTO BusinessPartner (id, address, bankAccount)
VALUES 
(1, ('Bahnhofstrasse', 10, '12345', 'Zurich'), ('UBS', '123456789012', 7000));

-- Valid ZIP code: 4 digits
INSERT INTO BusinessPartner (id, address, bankAccount)
VALUES 
(2, ('Bahnhofstrasse', 10, '8001', 'Zurich'), ('UBS', '123456789012', 7000));

select * from businesspartner;

-- add new constraint, to check that ZIP is only 4 digits
ALTER TABLE BusinessPartner
ADD CONSTRAINT chk_zipcode_format
CHECK ((address).zipCode ~ '^[0-9]{4}$');

-- add new constraint, to check that ZIP is only 4 digits --NOT VALID
ALTER TABLE BusinessPartner
ADD CONSTRAINT chk_zipcode_format
CHECK ((address).zipCode ~ '^[0-9]{4}$') not valid;

select * from businesspartner;

-- add businessPartner with too long ZIP code
INSERT INTO BusinessPartner (id, address, bankAccount)
VALUES 
(3, ('Bahnhofstrasse', 10, '12345', 'Zurich'), ('UBS', '123456789012', 7000));

select * from businesspartner;

-- problem -- update other column of already inconsistent data
update BusinessPartner
set bankaccount.accountnumber = 123456789011
where id = 1;

-------------------------------------------------------------------------------------------------------------
------------------------------------ NOT NULL/UNIQUE CONSTRAINTS --------------------------------------------
-------------------------------------------------------------------------------------------------------------
SELECT * 
FROM company

-- Show that table is empty

INSERT INTO company (
    id,
    address,
    bankaccount,
    companyname
) VALUES (
    1,
    ROW('Sesamestreet', 123, '8050', 'Zuerich'), 
    ROW('1234567890', 'DE123456', 789),
    'Tech Innovations Inc.'
);

-- Insert this twice to show it's possible
-- Try to enforce unique constraint on id -> doesn't work

DELETE FROM company

-- Delete, then add constraint

ALTER TABLE company
ADD CONSTRAINT unique_id UNIQUE (id);

-- Show that inserting the same id doesn't work anymore
-- However, multiple NULL values are still possible as id

ALTER TABLE company
ALTER COLUMN id SET NOT NULL;

-- Now, the values have to be unique and not null

ALTER TABLE company
ADD PRIMARY KEY (id);

-- Note that we could do the same just by using a PK constraint
--> Transition for the person covering the PK constraint

-------------------------------------------------------------------------------------------------------------
------------------------------------ PRIMARY KEY CONSTRAINTS ------------------------------------------------
-------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS CarReservation;

-- definition

create table Location
       (id             integer primary key ,
	shortName          char(3) ,
	name               varchar(20) ,
	nextLocation       integer, -- reference to location
	secondNextLocation integer, -- reference to location
	leaseContract      integer -- reference to LeaseContract
       );

-- composite definition

CREATE TABLE CarReservation (
    car_id         INTEGER,
    start_time     TIMESTAMP,
    end_time       TIMESTAMP,
    user_id        INTEGER,       -- ID of the user making the reservation
    location_id    INTEGER,       -- Pickup location ID
    PRIMARY KEY (car_id, start_time)
);

 -- uniqueness and not null
INSERT INTO Location (id, shortName, name, nextLocation, secondNextLocation, leaseContract)
VALUES
(1, 'WIN', 'Winterthur', 2, 3, 101),  -- Location A points to Location B and Location C
(2, 'OER', 'Oerlikon', NULL, NULL, 102), -- Location B is not linked to other locations
(3, 'SCH', 'Schaffhausen', 1, NULL, 103), -- Location C points back to Location A
(4, 'UST', 'Uster', 3, 1, 104);  -- Location D points to Location C and Location A

select * from  location;

-- try to insert value with already existing value for private key
INSERT INTO Location (id, shortName, name, nextLocation, secondNextLocation, leaseContract)
VALUES (1, 'WAL', 'Wallisellen', 2, 3, 105);

-- try adding values with NULL value as primary key
INSERT INTO Location (id, shortName, name, nextLocation, secondNextLocation, leaseContract)
VALUES (NULL, 'WAL', 'Wallisellen', 2, 3, 106);


-- update of private key, possible but should be avoided
UPDATE Location
SET id = 10
WHERE id = 3;

select * from location;

-- Recap:
-- ensures that each record is unique, supports efficient data retrieval,
-- facilitates creation of relationships foreign keys are mostly private keys of other relations

-------------------------------------------------------------------------------------------------------------
------------------------------------ FOREIGN KEY CONSTRAINTS ------------------------------------------------
-------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Member CASCADE;

CREATE TABLE Location (
    id INTEGER,
    shortName CHAR(3),
    name VARCHAR(20),
    nextLocation INTEGER, -- reference to location
    secondNextLocation INTEGER, -- reference to location
    leaseContract INTEGER, -- reference to LeaseContract
    address AddressT,
    map ImageT,
    PRIMARY KEY (id),
    CONSTRAINT fk_next_location FOREIGN KEY(nextLocation) REFERENCES Location(id),
    CONSTRAINT fk_second_next_location FOREIGN KEY(secondNextLocation) REFERENCES Location(id)
);

-- Happy flow
INSERT INTO Location
VALUES
    (1, 'ZRH', 'ZURICH AIRPORT', 3, 2, 4, NULL, NULL),
    (2, 'HBF', 'ZURICH MAIN STATION', 3, 1, 6, NULL, NULL),
    (3, 'UNI', 'ZURICH UNIVERSITY', 1, 2, 5, NULL, NULL);

SELECT * FROM Location;

-- Failing Insertion due to non-existent secondNextLocation
INSERT INTO Location
VALUES(4, 'WIN', 'WINTERTHUR', 1, 5, 7, NULL, NULL);

SELECT * FROM Location;

-- Adding the needed ID 
INSERT INTO Location
VALUES 
    (4, 'WIN', 'WINTERTHUR', 4, 1, 7, NULL, NULL),
    (5, 'EFF', 'EFFRETIKON', 4, 1, 8, NULL, NULL);

SELECT * FROM Location;

-- Failing deletion
DELETE FROM Location
WHERE id = 1;

-- Foreign key in a different table with ON Action
CREATE TABLE Member (
    id INTEGER,
    type VARCHAR(15),
    memberNr INTEGER,
    password VARCHAR(15),
    homeLocation INTEGER, -- reference to Location
    PRIMARY KEY (id),
    CONSTRAINT fk_location FOREIGN KEY(homeLocation) REFERENCES Location(id) 
    ON DELETE SET NULL
);

INSERT INTO Member
VALUES (1001, 'FirstMemberType', 8290, 'VGW.b;mP', 5);

SELECT * FROM Member;

-- Show NULL value upon deletion
DELETE FROM Location
WHERE id = 5;

SELECT * FROM Member;

-- Reset the FK for homeLocation in Member
INSERT INTO Location
VALUES (5, 'EFF', 'EFFRETIKON', 4, 1, 8, NULL, NULL);

UPDATE Member
SET homeLocation = 5
WHERE id = 1001;

SELECT * FROM Member;

-- Failing FK update (id = 6 doesn't exist)
UPDATE Member SET homeLocation = 6
WHERE id = 1001;

-- Delete FK constraint
ALTER TABLE Member DROP CONSTRAINT fk_location;

-- Change ON Action to CASCADE
ALTER TABLE Member
ADD CONSTRAINT fk_location FOREIGN KEY (homeLocation) REFERENCES Location(id) ON DELETE CASCADE;

-- Now delete Location with ID = 5 again
DELETE FROM Location
WHERE id = 5;

SELECT * FROM Member;

-- Reset tables
INSERT INTO Location
VALUES (5, 'EFF', 'EFFRETIKON', 4, 1, 8, NULL, NULL);
INSERT INTO Member
VALUES (1001, 'FirstMemberType', 8290, 'VGW.b;mP', 5);

-- Set ON Update
ALTER TABLE Member DROP CONSTRAINT fk_location;
ALTER TABLE Member
ADD CONSTRAINT fk_location FOREIGN KEY (homeLocation) REFERENCES Location(id) ON UPDATE CASCADE;

-- Update ID of Location
UPDATE Location
SET id = 6
WHERE id = 5;

SELECT * FROM Member;
SELECT * FROM Location;



