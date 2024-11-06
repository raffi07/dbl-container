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