create table if not exists public.cities (
     id serial primary key,
     geom geometry(Point,4326) not null,
     name text not null,
     population int not null,
     region text not null
);