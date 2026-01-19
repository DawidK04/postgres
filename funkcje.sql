-- --- funkcje tekstowe
-- CREATE OR REPLACE FUNCTION nazwa(user_id_in INT)
-- RETURNS typ_danych AS
-- $$
-- DECLARE
--     -- deklaracje zmiennych
--     licznik INT := 0;
-- BEGIN
--     -- ciało funkcji 
--     RETURN licznik;
-- END;
-- $$ LANGUAGE plpgsql;
-- sql
-- plpython3u
-- CREATE OR REPLACE FUNCTION nazwa(user_id_in INT)

--- funkcje tekstowe
-- funkcja normalizująca email(małe litery, bez spacji)

CREATE OR REPLACE FUNCTION normalize_email(raw_email TEXT)
RETURNS TEXT AS $$
BEGIN 
RETURN lower(trim(raw_email));
END;
$$ LANGUAGE plpgsql;

--- funkcje matematyczne
--losowanie wartości od 1 do 100

CREATE OR REPLACE FUNCTION random_int_1_100()
RETURNS INT AS $$
BEGIN 
RETURN floor(random() * 100 + 1)::INT
END;
$$ LANGUAGE plpgsql;

--- funkcje czasu i daty

now() / current_timestamp()
age()

date_part() / extract()

-- napisz funkcję sprawdzającą czy data jest weekendem

CREATE OR REPLACE FUNCTION is_weekend(d DATE)
RETURNS BOOLEAN AS $$
DECLARE
    dat_num INT;
BEGIN
    day_num := extract(ISODOW from d)
    RETURN day_num IN (6,7)
END;
$$ LANGUAGE plpgsql;

--- funkcje agregujące

sum()
count()
min/max
avg

string agg(kolumna, separator)
json_agg(kolumna)

--- funkcje generujące

generate_series(start, stop)

unnest(array)

