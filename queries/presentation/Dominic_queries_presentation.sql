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




