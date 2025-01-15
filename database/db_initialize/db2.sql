DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS meetups;
DROP TABLE IF EXISTS meetup_registrations;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS speakers;
DROP TABLE IF EXISTS meetup_comments;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS content_blocks;
DROP TABLE IF EXISTS keynote_sessions;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS speaker_categories;


CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, 
    google_id VARCHAR(255) UNIQUE, 
    apple_id VARCHAR(255) UNIQUE,   
    github_id VARCHAR(255) UNIQUE, 
    profile_picture_url VARCHAR(255) NOT NULL DEFAULT '', 
    first_name VARCHAR(100) NOT NULL DEFAULT '',  
    last_name VARCHAR(100) NOT NULL DEFAULT '',    
    locale VARCHAR(50) NOT NULL DEFAULT '',      
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE meetups (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    parking BOOLEAN DEFAULT TRUE,
    location VARCHAR(255),
    max_seats INT NOT NULL DEFAULT 0, 
    meetup_date VARCHAR(255) NOT NULL DEFAULT '', 
    organizer_id INT, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE meetup_registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT, 
    meetup_id INT,  
    status ENUM('pending', 'accepted','rejected') NOT NULL DEFAULT 'pending',   
    cancelled BOOLEAN DEFAULT FALSE,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY (user_id, meetup_id)
);

CREATE TABLE keynote_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    meetup_id INT NOT NULL,          
    subject VARCHAR(255) NOT NULL,   
    speaker_id INT NOT NULL,         
    start_time TIMESTAMP NOT NULL,  
    end_time TIMESTAMP,         
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (meetup_id) REFERENCES meetups(id),
    FOREIGN KEY (speaker_id) REFERENCES speakers(id)
);

CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,  
    category_id INT NOT NULL DEFAULT 0,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    image_url TEXT NOT NULL DEFAULT '', 
    contact_phone VARCHAR(255) NOT NULL DEFAULT '',
    contact_email VARCHAR(255) NOT NULL DEFAULT '',
    twitter_profile VARCHAR(255) NOT NULL DEFAULT '',
    linkedin_profile VARCHAR(255) NOT NULL DEFAULT '',
    facebook_profile VARCHAR(255) NOT NULL DEFAULT '',  
    instagram_handle VARCHAR(100) NOT NULL DEFAULT '',
    post_type ENUM('job_offer', 'news', 'article') NOT NULL DEFAULT 'news', 
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE speakers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,  
    meetup_id INT, 
    position VARCHAR(255) NOT NULL DEFAULT '',
    bio TEXT NOT NULL DEFAULT '',  
    linkedin_url VARCHAR(255) NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE meetup_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,  
    meetup_id INT,  
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE post_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,  
    post_id INT,  
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT, 
    meetup_id INT, 
    description TEXT,  
    media_url VARCHAR(255) NOT NULL DEFAULT '', 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,  
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE speaker_categories (
    PRIMARY KEY (speaker_id, category_id),
    speaker_id INT,
    category_id INT
);

CREATE TABLE content_blocks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT, 
    block_type ENUM('text', 'image') NOT NULL,  
    content TEXT,  
    image_url TEXT,  
    image_description TEXT,  
    block_order INT NOT NULL DEFAULT 0,  
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


ALTER TABLE meetups  
     ADD CONSTRAINT fk_meetups_organizer FOREIGN KEY (organizer_id) REFERENCES users(id);

ALTER TABLE meetup_registrations 
    ADD CONSTRAINT fk_meetup_registrations_user FOREIGN KEY (user_id) REFERENCES users(id),
    ADD CONSTRAINT fk_meetup_registrations_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id);

ALTER TABLE posts 
    ADD CONSTRAINT fk_posts_user FOREIGN KEY (user_id) REFERENCES users(id),
    ADD CONSTRAINT fk_posts_category FOREIGN KEY (category_id) REFERENCES categories(id);

ALTER TABLE speakers 
    ADD CONSTRAINT fk_speakers_user FOREIGN KEY (user_id) REFERENCES users(id),
    ADD CONSTRAINT fk_speakers_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id);

ALTER TABLE meetup_comments 
    ADD CONSTRAINT fk_meetup_comments_user FOREIGN KEY (user_id) REFERENCES users(id),
    ADD CONSTRAINT fk_meetup_comments_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id);

ALTER TABLE reviews 
    ADD CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id),
    ADD CONSTRAINT fk_reviews_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id);


ALTER TABLE post_comments 
    ADD CONSTRAINT fk_post_comments_user FOREIGN KEY (user_id) REFERENCES users(id),
    ADD CONSTRAINT fk_post_comments_post FOREIGN KEY (post_id) REFERENCES posts(id);

ALTER TABLE speaker_categories 
    ADD CONSTRAINT fk_speaker_categories_category FOREIGN KEY (category_id) REFERENCES categories(id),
    ADD CONSTRAINT fk_speaker_categories_speaker FOREIGN KEY (speaker_id) REFERENCES speakers(id);

ALTER TABLE content_blocks 
     ADD CONSTRAINT fk_content_blocks FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE;