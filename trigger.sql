-- funkcja logiki triggera 

CREATE OR REPLACE FUNCTION nazwa_funkcji()
RETURNS TRIGGER AS 
$$
DECLARE

BEGIN
    RETURN NEW;

END
$$ LANGUAGE plpgsql

-- trigger 
CREATE TRIGGER nazwa_triggera
{BEFORE | AFTER | INSTEAD OF}
{INSERT | UPDATE | DELETE}
ON nazwa_tabeli {nazwa_widoku}
FOR EACH {ROW | STATEMENT}
[WHEN (warunek)]
EXECUTE FUNCTION nazwa_funkcji();

INSERT NEW.
UPDATE NEW. OLD.
DELETE OLD.

TG_OP = typ operacji 
TG_TABLE_NAME = nazwa nazwa_tabeli
TG_TABLE_SCHEMA = schema w ktorej przechowywana jest tabela
TG_WHEN 
TG_LEVEL = ROW, STATEMENT
TG_NARGS
TG_ARGV = tablica argumentow


-- trigger który blokuje usunięcie użytkownika w przypadku gdy posiada dodane formularze 
CREATE OR REPLACE FUNCTION prevent_user_delete()
RETURNS TRIGGER AS $$
DECLARE
    v_form_count INT :=0;
BEGIN
    SELECT count(1) INTO v_form_count FROM c2forms WHERE owner_id = OLD.user_id;
    IF v_form_count > 0 THEN
        RAISE EXCEPTION 'Nie można usunąć użytkownika % - posiada % formularzy', OLD.email, v_form_count;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_prevent_delete
BEFORE DELETE ON c2users
FOR EACH ROW
EXECUTE FUNCTION prevent_user_delete();

-- zad
CREATE TABLE IF NOT EXISTS c2users (
    user_id SERIAL PRIMARY KEY,
    email TEXT,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS c2forms (
    form_id SERIAL PRIMARY KEY,
    owner_id INT REFERENCES user(user_id),
    title TEXT,
    is_published BOOLEAN DEFAULT false
);

ALTER TABLE c2users ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
ALTER TABLE c2forms ADD COLUMN IF NOT EXISTS is_published BOOLEAN DEFAULT false;

CREATE OR REPLACE FUNCTION check_owner_active()
RETURNS TRIGGER AS $$
DECLARE
    owner_status BOOLEAN;
BEGIN
    SELECT is_active INTO owner_status
    FROM c2users
    WHERE user_id = NEW.owner_id;
    IF NEW.is_published = true AND (owner_status = false OR owner_status IS NULL) THEN
        RAISE EXCEPTION '', NEW.owner_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_form_publish
BEFORE INSERT OR UPDATE ON forms
FOR EACH ROW
EXECUTE FUNCTION check_owner_active();
