CREATE TABLE product (
    id VARCHAR(36),
    title VARCHAR(255) NOT NULL,
    author VARCHAR(50) NOT NULL,
    int review INT DEFAULT 0,
    price double,
    image text,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP,

    PRIMARY KEY (id),
);