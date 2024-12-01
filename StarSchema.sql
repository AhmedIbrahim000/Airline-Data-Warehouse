create table airplane (
    registration_number varchar(100) primary key,
    model varchar(100),
    capacity_number int,
    year_of_made varchar(100)
);

create table ticket (
    ticket_number int primary key,
    ticket_date varchar(100),
    ticket_seat varchar(100),
    ticket_class varchar(100),
    passnger_name varchar(100),
	passnger_sex char constraint ticket_sex_ck check ((passnger_sex = 'M') or (passnger_sex = 'F'))
);

create table airport (
	airport_id int primary key,
	airport_name varchar(100),
    airport_city varchar(100),
	airport_country varchar(100)
);

create table flight (
    flight_number int primary key,
    departure_city varchar(100),
	arrival_city varchar(100),
	departure_date varchar(100),
	departure_time varchar(100),
	arrival_date varchar(100),
	arival_time varchar(100)
);

create table flight_fact (
	registration_key varchar(100),
	flight_key int,
	airport_key int,
	ticket_key int,
	total_ticket_sold int,
	number_of_flights_monthly int,
	constraint sales_fact_pks primary key(registration_key, flight_key, airport_key, ticket_key)
);

--------------------------------------alter tables--------------------------------------------------------------------------------
alter table flight_fact add constraint flight_fact_registration_key_fk  foreign key (registration_key)  references airplane(registration_number);
alter table flight_fact add constraint flight_fact_flight_key_fk  foreign key (flight_key) references flight(flight_number);
alter table flight_fact add constraint flight_fact_airport_key_fk foreign key (airport_key) references airport(airport_id);
alter table flight_fact add constraint flight_fact_ticket_key_fk     foreign key (ticket_key) references ticket(ticket_number);

--------------------------------------insert--------------------------------------------------------------------------------
insert into airplane values ('1001', 'A310', '245', '1970');
insert into airplane values ('1002', 'A312', '250', '1975');
insert into airplane values ('1003', 'B767', '216', '1978');
insert into airplane values ('1004', 'B747', '216', '1978');
insert into airplane values ('1005', 'A350', '220', '1980');
insert into airplane values ('1006', 'A320', '180', '1980');
insert into airplane values ('1007', 'A319', '170', '1977');
insert into airplane values ('1008', 'A321', '175', '1977');
insert into airplane values ('1009', 'A330', '293', '1978');
insert into airplane values ('1010', 'B777', '368', '1995');


insert into flight values ('301', 'NEW YORK', 'LONDON', '2022-12-20', '17:30', '2022-12-20','19:30');
insert into flight values ('302', 'san francisco', 'NEW YORK', '2022-12-23', '01:00', '2022-12-20','09:30');
insert into flight values ('303', 'cairo', 'LONDON', '2022-12-24', '17:30', '2022-12-24','09:30');
insert into flight values ('304', 'cairo', 'LONDON', '2022-12-25', '12:30', '2022-12-25','15:30');
insert into flight values ('305', 'roma', 'manchester', '2022-12-28', '10:30', '2022-12-28','12:30');
insert into flight values ('306', 'dubai', 'cairo', '2022-12-20', '06:30', '2022-12-20','08:30');
insert into flight values ('307', 'cairo', 'istanbol', '2022-12-29', '11:00', '2022-12-29','13:30');
insert into flight values ('308', 'istanbol', 'manchester', '2022-12-26', '08:45', '2022-12-26','10:05');
insert into flight values ('309', 'manchester', 'paris', '2022-12-26', '19:30', '2022-12-26','22:00');
insert into flight values ('310', 'doha', 'puenos aires', '2022-12-26', '02:25', '2022-12-25','22:25');


insert into airport values ('200', 'cairo international airport', 'cairo', 'egypt');
insert into airport values ('201', 'hamad international airport', 'doha', 'qatar');
insert into airport values ('202', 'john f kenedy', 'new york', 'USA');
insert into airport values ('203', 'istanbul international airport', 'istanbul', 'turkey');
insert into airport values ('204', 'heathrow international airport ', 'london', 'UK');
insert into airport values ('205', 'dubai international airport', 'dubai', 'UAE');
insert into airport values ('206', 'king abulaziaz international airport', 'jeddah', 'KSA');
insert into airport values ('207', 'san francisco international airport', 'san francisco', 'USA');
insert into airport values ('208', 'leonardo da vinci international airport', 'roma', 'italia');
insert into airport values ('209', 'charal de gol ', 'paris', 'france');
insert into airport values ('210', 'manchester international airport ', 'manchester', 'UK');


insert into ticket values ('10', '2022-12-20', 'a1', 'business', 'jhon', 'M');
insert into ticket values ('20', '2022-12-23', 'a32', 'first class', 'david', 'M');
insert into ticket values ('30', '2022-12-24', 'j25', 'economy', 'simon', 'M');
insert into ticket values ('40', '2022-12-25', 'c33', 'first class', 'jack', 'M');
insert into ticket values ('50', '2022-12-28', 'f24', 'economy', 'maria', 'F');
insert into ticket values ('60', '2022-12-20', 'j31', 'business', 'mohamed', 'M');
insert into ticket values ('70', '2022-12-29', 'c23', 'business', 'ramadan', 'M');
insert into ticket values ('80', '2022-12-26', 'l18', 'economy', 'ali', 'M');
insert into ticket values ('90', '2022-12-26', 'i40', 'first class', 'abdelrahman', 'M');
insert into ticket values ('100', '2022-12-26', 'b30', 'economy', 'nora', 'F');


insert into flight_fact values ('1001', '301', '202', '10', 245, 1);
insert into flight_fact values ('1002', '302', '207', '20', 250, 1);
insert into flight_fact values ('1003', '303', '200', '30', 648, 3);
insert into flight_fact values ('1004', '304', '200', '40', 600, 3);
insert into flight_fact values ('1005', '305', '208', '50', 220, 1);
insert into flight_fact values ('1006', '306', '205', '60', 180, 1);
insert into flight_fact values ('1007', '307', '200', '70', 300, 3);
insert into flight_fact values ('1008', '308', '203', '80', 175, 1);
insert into flight_fact values ('1009', '309', '210', '90', 293, 1);
insert into flight_fact values ('1010', '310', '201', '100', 368, 1);
--------------------------------------

SELECT a.airport_name, sum(f.number_of_flights_monthly) as Total, sum(f.total_ticket_sold) as 'total ticket sold'
FROM flight_fact f
join flight fl on fl.flight_number = f.flight_key
join airport a on a.airport_id = f.airport_key
where fl.departure_date between '2022-12-20' and '2022-12-29'
group by a.airport_name;