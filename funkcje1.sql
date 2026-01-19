SELECT count(*) FROM c2questions WHERE form_id = 2;

CREATE OR REPLACE FUNCTION get_questions_count(form_id_in INT)
RETURNS INT AS $$
SELECT count(*) FROM c2questions WHERE form_id = form_id_in
$$ LANGUAGE SQL;

--- psql zmienne i warunki 

CREATE OR REPLACE FUNCTION get_user_status(form_id_in INT)
RETURNS TEXT AS $$
DECLARE
    form_count INT;
    status_user TEXT;
BEGIN 
    SELECT count(1) INTO form_count FROM c2forms WHERE user_id = user_id_in;
    IF form_count > 5 THEN status_user := 'Power user';
    ELSIF form_count > 0 THEN status_user := 'Regular user';
    ELSE status_user := 'New user';
    END IF;
    RETURN status_user;
END;
$$ LANGUAGE plpgsql;

--- stwórz listę tytułów formularzy danego użytkownika oddzielone od siebie średnikiem

CREATE OR REPLACE FUNCTION list_user_forms(user_id_in INT)
RETURNS TEXT AS $$
DECLARE
    r RECORD;
    output TEXT := '';
BEGIN
    FOR r IN 
        SELECT title FROM c2forms WHERE owner_id = user_id_in
    LOOP
        output := output || r.title || '; ';
    END LOOP;

    RETURN output;

END;
$$ LANGUAGE plpgsql;