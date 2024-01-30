CREATE USER pokedexuser WITH PASSWORD pokedex;
CREATE DATABASE pokexexdb;
REVOKE ALL ON DATABASE pokedexdb FROM pokedexuser;
GRANT CONNECT ON DATABASE pokedexdb TO pokedexuser;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO pokedexuser;
