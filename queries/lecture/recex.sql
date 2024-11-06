
create table verbindung(von varchar(3), 
	                nach varchar(3));

insert into verbindung values('ZRH', 'CHI'),
                             ('ZRH', 'SFO'),
			     ('SFO', 'LAX'),
			     ('LAX', 'LAS'),
			     ('ZRH', 'GOT'),
			     ('SFO', 'OGG'),
			     ('LHR', 'LAX'),
			     ('LAX', 'SFO'),
			     ('GOT', 'LAX'),
			     ('LAX', 'JFK'),
			     ('JFK', 'LAS');

with recursive transverbindung(von, nach, stops, weg) as
   ((select von, nach, 0, von || '-' || nach
       from verbindung
      where von = 'ZRH')
    union all
    (select v.von, v.nach, stops + 1, weg || '-' || v.nach 
       from verbindung v join transverbindung t on t.nach = v.von
      where stops <= 2))
select * from transverbindung;

with recursive transverbindung(von, nach, stops, weg) as
   ((select von, nach, 0, von || '-' || nach
       from verbindung
      where von = 'ZRH')
    union all
    (select v.von, v.nach, stops + 1, weg || '-' || v.nach 
       from verbindung v join transverbindung t on t.nach = v.von
      where stops <= 2))
select t1.* from transverbindung t1
 where not exists (select t2.*
	             from transverbindung t2
		    where t1.nach = t2.nach
		          and t2.stops < t1.stops);
