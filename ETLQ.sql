create table airplane (
    registration_number nvarchar(100) primary key,
    model nvarchar(100),
    capacity_number int,
    year_of_made nvarchar(100)
);

create table ticket (
    ticket_number int primary key,
    ticket_date nvarchar(100),
    ticket_seat nvarchar(100),
    ticket_class nvarchar(100),
    passnger_name nvarchar(100),
	passnger_sex nchar constraint ticket_sex_ck check ((passnger_sex = 'M') or (passnger_sex = 'F'))
);

create table airport (
	airport_id int primary key,
	airport_name nvarchar(100),
    airport_city nvarchar(100),
	airport_country nvarchar(100)
);

create table flight (
    flight_number int primary key,
    departure_city nvarchar(100),
	arrival_city nvarchar(100),
	departure_date nvarchar(100),
	departure_time nvarchar(100),
	arrival_date nvarchar(100),
	arival_time nvarchar(100)
);

create table flight_fact (
	registration_key nvarchar(100),
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