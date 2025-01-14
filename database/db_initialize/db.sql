DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS upcoming_events;
DROP TABLE IF EXISTS past_events;
DROP TABLE IF EXISTS meetup_registrations;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS speakers;
DROP TABLE IF EXISTS meetup_comments;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS speaker_expertises;
DROP TABLE IF EXISTS speakers;
DROP TABLE IF EXISTS expertises;

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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    max
);

CREATE TABLE upcoming_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    participant_number INT NOT NULL DEFAULT 0, 
    meetup_date VARCHAR(255) NOT NULL DEFAULT '',
    organizer_id INT, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    max_seats int NOT NULL DEFAULT 0,
    seats_capacity varchar(10) NOT NULL,
    snacks varchar(30) NO NULL DEFAULT ''

);

CREATE TABLE past_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    participant_number INT NOT NULL DEFAULT 0, 
    meetup_date VARCHAR(255) NOT NULL DEFAULT '',
    organizer_id INT, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    max_seats int NOT NULL DEFAULT 0,
    seats_capacity varchar(10) NOT NULL,
    snacks varchar(30) NO NULL DEFAULT ''
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

CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,  
    title VARCHAR(255) NOT NULL,
    content TEXT,
    image_url TEXT NOT NULL DEFAULT '', 
    contact_phone VARCHAR(255) NOT NULL DEFAULT '',
    contact_email VARCHAR(255) NOT NULL DEFAULT '',
    twitter_profile VARCHAR(255) NOT NULL DEFAULT '',
    linkedin_profile VARCHAR(255) NOT NULL DEFAULT '',
    facebook_profile VARCHAR(255) NOT NULL DEFAULT '',  
    instagram_handle VARCHAR(100) NOT NULL DEFAULT '',
    post_type ENUM('job_offer', 'news') NOT NULL,  
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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
    media_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE speakers (
    speaker_id INT AUTO_INCREMENT PRIMARY KEY, 
    user_id INT,                               
    meetup_id INT,                             
    name VARCHAR(100) NOT NULL,              
    position VARCHAR(100),                   
    category VARCHAR(50),                    
    linkedin_url VARCHAR(255),                           
    FOREIGN KEY (user_id) REFERENCES users(id),             -- F Key to Users Table
    FOREIGN KEY (meetup_id) REFERENCES upcoming_events(id)  -- F Key to Upcoming Events
);

CREATE TABLE expertises (
    expertise_id INT PRIMARY KEY AUTO_INCREMENT,
    field_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE speaker_expertises (
    speaker_id VARCHAR(50),
    expertise_id INT,
    PRIMARY KEY (speaker_id, expertise_id),
    FOREIGN KEY (speaker_id) REFERENCES Speakers(speaker_id),
    FOREIGN KEY (expertise_id) REFERENCES Expertises(expertise_id)
);


ALTER TABLE upcoming_events  
     ADD CONSTRAINT fk_meetups_organizer FOREIGN KEY (organizer_id) REFERENCES users(id);

ALTER TABLE past_events  
    ADD CONSTRAINT fk_past_events_organizer FOREIGN KEY (organizer_id) REFERENCES users(id);

ALTER TABLE meetup_registrations 
    ADD CONSTRAINT fk_meetup_registrations_user FOREIGN KEY (user_id) REFERENCES users(id),
    ADD CONSTRAINT fk_meetup_registrations_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id);

ALTER TABLE posts 
    ADD CONSTRAINT fk_posts_user FOREIGN KEY (user_id) REFERENCES users(id);

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