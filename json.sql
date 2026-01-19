CREATE TABLE c2products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    specs JSONB -- Tu dzieje się magia
);

INSERT INTO c2products (name, specs) VALUES
('Laptop Pro', '{ "cpu": "M1", "ram": "16GB", "ports": ["usb-c", "hdmi"], "available": true }'),
('Running Shoes', '{ "size": 42, "color": "red", "brand": "Nike", "available": true }'),
('Smart Watch', '{ "brand": "Apple", "features": {"gps": true, "lte": false} }');

{
    "cpu": "M1",
    "ram": "16GB",
    "ports": ["usb-c", "hdmi"],
    "available": True
}

-> zwraca obiekt JSON "16GB"
->> zwraca czysty kod 16GB

SELECT name, specs->>'color' as color
FROM c2products
WHERE specs ->> 'color' = 'red';

CREATE INDEX idx_products_specs ON c2products USING GIN(specs);

@> - "zawiera"

SELECT * FROM c2products
WHERE specs @> '{"brand": "Apple"}';

json_set
jsonb_set

UPDATE c2products
SET specs = jsonb_set(specs, '{features, lte}', 'true'::jsonb)
WHERE name = 'Smart Watch';

UPDATE c2products
SET specs = specs - 'available'