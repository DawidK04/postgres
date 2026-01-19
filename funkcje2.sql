CREATE OR REPLACE FUNCTION generate_order_code(user_id INT)
RETURNS TEXT AS $$
DECLARE
    current_year TEXT;
    random_part TEXT;
BEGIN
    current_year := EXTRACT(YEAR FROM CURRENT_DATE)::TEXT;
    random_part := LPAD(FLOOR(RANDOM() * 1000)::TEXT, 3, '0');
    RETURN 'ORD-' || current_year || '-' || user_id::TEXT || '-' || random_part;
END;
$$ LANGUAGE plpgsql;

---

-- ========================
-- opis


-- ========================

CREATE OR REPLACE PROCEDURE sp_nazwa_procedury(
    IN p_name INT,
    OUT p_out INT,
    INOUT p_inout INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_
    -- deklaracja zmiennych
BEGIN
    -- logika procedury

    RAISE NOTICE
    RAISE EXCEPTION
END;
$$;



-- dodanie użytkownika

CREATE OR REPLACE PROCEDURE sp_user_create(
    p_email VARCHAR(255),
    p_password TEXT,
    p_manager_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_manager_email VARCHAR(255)
BEGIN
    -- logika procedury
    
    --check sprawdzajacy czy dany user istnieje
    SELECT email INTO v_manager_email 
    FROM c2users
    WHERE id = p_manager_id;

    IF EXISTS(
        SELECT email INTO v_manager_email FROM c2users WHERE id = p_manager_id;
    )
    THEN 
        RAISE EXCEPTION

    IF EXISTS(
        SELECT 1 FROM c2users WHERE email = p_email
    )
    THEN 
        RAISE EXCEPTION 'Użytkownik % już istnieje w bazie c2users.', p_email;
    END IF;
    
    INSERT INTO c2users (email, password_hash, manager_id)
    VALUES (p_email, p_password, p_manager_id);

    RAISE NOTICE 'Dodano użytkownika % do bazy c2users z id managera %', p_email, p_manager_id;

END;
$$;

CALL sp_user_create('bababa@abab.pl', 'klklkl', 1);

---

CREATE OR REPLACE PROCEDURE sp_forms_and_questions_create(
    p_title VARCHAR(255),
    p_owner_id INT,
    p_questions TEXT[],
    OUT p_form_id INT,
    OUT p_questions_count INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_question TEXT;
BEGIN

    p_questions_count := array_length(p_questions, 1);

    INSERT INTO c2forms (title, owner_id)
    VALUES (p_title, p_owner_id)
    RETURNING form_id INTO p_form_id;

    FOREACH v_question IN ARRAY p_questions
    LOOP 
        INSERT INTO c2questions (form_id, question_text, question_type)
        VALUES (p_form_id, v_question, 'text');
    END LOOP;

    RAISE NOTICE 'Utworzono formularz % z % pytaniami.',p_title, p_questions_count;

END;
$$;

CALL sp_forms_and_questions_create ('Ankieta', 1, ARRAY['Pytanie 1', 'Pytanie 2'], NULL, NULL);