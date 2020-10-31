create table SHIP_TYPE (
    ship_type varchar(9) not null,
    tonnage float4,
    hull varchar(9),
    
    primary key (ship_type)
) engine=InnoDB;

create table SHIP (
    ship_name varchar(9) not null,
    owner_name varchar(20),
    s_type varchar(9) not null,
    
    primary key (ship_name),
    foreign key (s_type) references SHIP_TYPE(ship_type)
) engine=InnoDB;

create table TIME_STAMP (
    time_id int not null,
    ship_date date,
    ship_time time,
    
    primary key (time_id)
) engine=InnoDB;

create table SHIP_MOVEMENT (
    s_name varchar(9) not null,
    time_stamp int not null,
    latitude float4,
    longtigude float4,
    
    primary key (time_stamp),
    foreign key (s_name) references SHIP(ship_name) on delete cascade,
    foreign key (time_stamp) references TIME_STAMP(time_id) on delete cascade
) engine=InnoDB;

create table STATE_COUNTRY (
    state_country_name varchar(20) not null,
    continent varchar(9),
    
    primary key (state_country_name)
) engine=InnoDB;

create table SEA_OCEAN_LAKE (
    sea_ocean_lake_name varchar(9) not null,
    
    primary key (sea_ocean_lake_name)
) engine=InnoDB;

create table PORT (
    port_name varchar(9) not null,
    sc_name varchar(20) not null,
    sol_name varchar(9) not null,
    ship_port varchar(9),
    
	primary key (port_name),
    foreign key (ship_port) references SHIP(ship_name),
    foreign key (sc_name) references STATE_COUNTRY(state_country_name) on delete cascade,
	foreign key (sol_name) references SEA_OCEAN_LAKE(sea_ocean_lake_name)
) engine=InnoDB;

create table PORT_VISIT (
    p_name varchar(9) not null,
    port_visit_id varchar(9) not null,
    start_date date not null,
    end_date date,
    
    primary key (port_visit_id, start_date),
    foreign key (p_name) references PORT(port_name) on delete cascade
) engine=InnoDB;


create table SHIP_AT_PORT (
    ship_id varchar(9),
    port_id varchar(9),
    visit_id varchar(9) not null,
    
    primary key (ship_id, port_id, visit_id),
    foreign key (ship_id) references SHIP(ship_name) on delete cascade,
    foreign key (port_id) references PORT(port_name) on delete cascade,
    foreign key (visit_id) references PORT_VISIT(port_visit_id) on delete cascade
) engine=InnoDB;

