create table items_sold (
   brand   varchar(10),
   size    char,
   sales   int);

insert into items_sold values
('Foo', 'L', 10),
('Foo', 'M', 20),
('Bar', 'M', 15),
('Bar', 'L', 5),
('Bar', null, 3),
(null, 'L', 2);

SELECT brand, size, sum(sales)
  FROM items_sold
 GROUP BY GROUPING SETS ((brand), (size), ());

SELECT brand, grouping(brand) as brand_grouping,
       size, grouping(size) as size_grouping,
       sum(sales)
  FROM items_sold GROUP BY GROUPING SETS ( (brand), (size), ());

SELECT (case when grouping(brand) = 1 then 'ALL'
                                  else brand end) as brand,
       (case when grouping(size) = 1 then 'ALL'
                                  else size end) as size,
       sum(sales)
  FROM items_sold
 GROUP BY GROUPING SETS ( (brand), (size), ());

SELECT brand, size, sum(sales)
  FROM items_sold
 GROUP BY  cube (brand, size );

SELECT (case when grouping(brand) = 1 then 'ALL'
                                  else brand end) as brand,
       (case when grouping(size) = 1 then 'ALL'
                                  else size end) as size,
       sum(sales)
  FROM items_sold
 GROUP BY  cube (brand, size );

SELECT brand, size, sum(sales)
  FROM items_sold
 GROUP BY  rollup (brand, size );

SELECT (case when grouping(brand) = 1 then 'ALL'
                                  else brand end) as brand,
       (case when grouping(size) = 1 then 'ALL'
                                  else size end) as size,
       sum(sales)
  FROM items_sold
 GROUP BY  rollup (brand, size );

