CREATE EXTENSION pg_trgm;

CREATE TABLE users (
    username VARCHAR(25) PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    current_city TEXT NOT NULL,
    current_state TEXT NOT NULL,
    phone_number TEXT UNIQUE,
    profile_img TEXT DEFAULT 'http://profile.img',
    password TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    is_private BOOLEAN NOT NULL DEFAULT FALSE,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    game_date TEXT NOT NULL,
    game_time TEXT NOT NULL,
    game_address TEXT NOT NULL,
    game_city TEXT NOT NULL,
    game_state TEXT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE users_games (
    game_id INTEGER REFERENCES games ON DELETE CASCADE,
    username TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (game_id, username)
);

CREATE TABLE games_comments (
    id SERIAL PRIMARY KEY,
    game_id INTEGER REFERENCES games ON DELETE CASCADE,
    username TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    comment TEXT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE users_threads (
    id TEXT NOT NULL,
    username TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    PRIMARY KEY (id, username)
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    party_id TEXT NOT NULL,
    message_from TEXT NOT NULL,
    message TEXT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (party_id, message_from) REFERENCES users_threads ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE inactive_messages (
    message_id INTEGER REFERENCES messages ON UPDATE CASCADE ON DELETE CASCADE,
    username TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE is_following (
    following_user TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    followed_user TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (followed_user, following_user)
);

CREATE TABLE users_invites (
    id SERIAL PRIMARY KEY,
    game_id INTEGER REFERENCES games ON DELETE CASCADE,
    from_user TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    to_user TEXT REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    status TEXT DEFAULT 'pending',
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

