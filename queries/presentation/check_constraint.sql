-- insert constraint for licence plate

ALTER TABLE Vehicle
ADD CONSTRAINT chk_license_plate_format
CHECK (licensePlate ~ '^[A-Z]{2}[0-9]{1,6}$');

-- Invalid license plate: too many digits and incorrect letter placement
INSERT INTO Vehicle (id, type, licensePlate, make, model, motorNumber, kilometers, isOperational, operationStart, lastService, gasConsumption, insurance, home)
VALUES 
(1, 'CompactCar', 'ZH12345XYZ', 'Toyota', 'Corolla', 'M123456789', 5000, true, '2021-01-01', '2023-05-01', 5.5, (1, 123), 1);


-- Invalid license plate: too many digits and incorrect letter placement
INSERT INTO Vehicle (id, type, licensePlate, make, model, motorNumber, kilometers, isOperational, operationStart, lastService, gasConsumption, insurance, home)
VALUES 
(1, 'CompactCar', 'ZH12345', 'Toyota', 'Corolla', 'M123456789', 5000, true, '2021-01-01', '2023-05-01', 5.5, (1, 123), 1);


--What happens when we already have data in the table and then want to add a constraint, which is not in in line with the data in the database?

-- add businessPartner with too long ZIP code
INSERT INTO BusinessPartner (id, address, bankAccount)
VALUES 
(1, ('Bahnhofstrasse', 10, '12345', 'Zurich'), ('UBS', '123456789012', 7000));

-- Valid ZIP code: 4 digits
INSERT INTO BusinessPartner (id, address, bankAccount)
VALUES 
(2, ('Bahnhofstrasse', 10, '8001', 'Zurich'), ('UBS', '123456789012', 7000));


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







