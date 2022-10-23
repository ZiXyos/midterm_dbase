SET check_function_bodies = false;

CREATE TYPE actions_type AS ENUM('M', 'R');

CREATE TYPE certif_auth_type AS ENUM('foreign', 'local');

CREATE TYPE locations_type AS ENUM('Hotel', 'Airport', 'Aquatic Center');

CREATE TABLE vehicules(
    vehicule_id varchar(5) NOT NULL,
    registration_id varchar(7),
    manufacturer varchar(20),
    model varchar,
    color varchar,
    odometer integer NOT NULL,
    suitable bool NOT NULL,
    capacity integer NOT NULL,
    maintenance_status_id uuid NOT NULL,
    CONSTRAINT vehicules_pkey PRIMARY KEY(vehicule_id),
    CONSTRAINT odometer_fk UNIQUE(odometer)
);

CREATE TABLE maintenance_status(
    id uuid NOT NULL,
    action_types actions_type NOT NULL,
    action_description text,
    final_cost integer NOT NULL,
    date date NOT NULL,
    vehicules_odometer integer NOT NULL,
    CONSTRAINT maintenance_status_pkey PRIMARY KEY(id)
);

CREATE TABLE drivers(
    license_number integer NOT NULL,
    "name" varchar,
    clearance_level integer NOT NULL,
    "language" varchar NOT NULL,
    "STLVT_id" uuid NOT NULL,
    "FATL_id" uuid,
    CONSTRAINT drivers_pkey PRIMARY KEY(license_number)
);

CREATE TABLE "STLVT"(
    id uuid NOT NULL,
    "level" integer NOT NULL,
    qualification_date date NOT NULL,
    certifying_auth certif_auth_type NOT NULL,
    CONSTRAINT "STLVT_pkey" PRIMARY KEY(id)
);

CREATE TABLE "FATL"(
    id uuid NOT NULL,
    "level" integer NOT NULL,
    qualification_date date NOT NULL,
    CONSTRAINT "FATL_pkey" PRIMARY KEY(id)
);

CREATE TABLE bookings(
    ref_number integer NOT NULL,
    drivers_license_number integer NOT NULL,
    trips_id integer NOT NULL,
    game_officials_id integer NOT NULL,
    CONSTRAINT bookings_pkey PRIMARY KEY(ref_number)
);

CREATE TABLE trips(
    id integer NOT NULL,
    vehicule_id varchar(5) NOT NULL,
    pickup_location_name varchar NOT NULL,
    dropoff_location_name varchar NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    CONSTRAINT trips_pkey PRIMARY KEY(id)
);

CREATE TABLE game_officials(
    id integer NOT NULL,
    based_city varchar NOT NULL,
    "name" varchar NOT NULL,
    "role" varchar NOT NULL,
    pref_lang varchar NOT NULL,
    country varchar NOT NULL,
    CONSTRAINT game_officials_pkey PRIMARY KEY(id)
);

CREATE TABLE country(
country_name varchar NOT NULL, most_spoken_lang varchar[] NOT NULL,
    CONSTRAINT country_pkey PRIMARY KEY(country_name)
);

CREATE TABLE pickup(
    location_name varchar NOT NULL,
    street_nb integer NOT NULL,
    city varchar NOT NULL,
    location_type locations_type NOT NULL,
    CONSTRAINT pickup_pkey PRIMARY KEY(location_name)
);

CREATE TABLE dropoff(
    location_name varchar NOT NULL,
    street_nb integer NOT NULL,
    city varchar NOT NULL,
    location_type locations_type NOT NULL,
    CONSTRAINT dropoff_pkey PRIMARY KEY(location_name)
);

ALTER TABLE maintenance_status
    ADD CONSTRAINT maintenance_status_vehicules_odometer_fkey
        FOREIGN KEY (vehicules_odometer) REFERENCES vehicules (odometer);

ALTER TABLE vehicules
    ADD CONSTRAINT vehicules_maintenance_status_id_fkey
        FOREIGN KEY (maintenance_status_id) REFERENCES maintenance_status (id);

ALTER TABLE drivers
    ADD CONSTRAINT "drivers_STLVT_id_fkey"
        FOREIGN KEY ("STLVT_id") REFERENCES "STLVT" (id);

ALTER TABLE drivers
    ADD CONSTRAINT "drivers_FATL_id_fkey"
        FOREIGN KEY ("FATL_id") REFERENCES "FATL" (id);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_drivers_license_number_fkey
        FOREIGN KEY (drivers_license_number) REFERENCES drivers (license_number)
    ;

ALTER TABLE bookings
    ADD CONSTRAINT bookings_trips_id_fkey
        FOREIGN KEY (trips_id) REFERENCES trips (id);

ALTER TABLE game_officials
    ADD CONSTRAINT game_officials_country_fkey
        FOREIGN KEY (country) REFERENCES country (country_name);

ALTER TABLE bookings
    ADD CONSTRAINT bookings_game_officials_id_fkey
        FOREIGN KEY (game_officials_id) REFERENCES game_officials (id);

ALTER TABLE trips
    ADD CONSTRAINT trips_vehicule_id_fkey
        FOREIGN KEY (vehicule_id) REFERENCES vehicules (vehicule_id);

ALTER TABLE trips
    ADD CONSTRAINT trips_pickup_location_name_fkey
        FOREIGN KEY (pickup_location_name) REFERENCES pickup (location_name);

ALTER TABLE trips
    ADD CONSTRAINT trips_dropoff_location_name_fkey
        FOREIGN KEY (dropoff_location_name) REFERENCES dropoff (location_name);
