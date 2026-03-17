create table if not exists public.cities (
     id serial primary key,
     name text not null,
     latitude float not null,
     longitude float not null,
     region text not null,
     population int not null
);