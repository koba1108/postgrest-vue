-- Create the users table
CREATE TYPE USER_ROLE AS ENUM ('GUEST', 'USER', 'ADMIN');
CREATE TABLE public.users
(
    id    serial PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role  USER_ROLE    NOT NULL DEFAULT 'USER'
);

-- Insert some users
INSERT INTO public.users (name, email, role)
VALUES ('admin user', 'admin-user@example.com', 'ADMIN'),
       ('normal user', 'normal-user@example.com', 'USER');
