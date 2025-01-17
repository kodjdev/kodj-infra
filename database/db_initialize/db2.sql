DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS meetups;
DROP TABLE IF EXISTS meetup_registrations;
DROP TABLE IF EXISTS speakers;
DROP TABLE IF EXISTS meetup_comments;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS keynote_sessions;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS speaker_categories;
DROP TABLE IF EXISTS job_offers;
DROP TABLE IF EXISTS news;
DROP TABLE IF EXISTS job_offer_comments;
DROP TABLE IF EXISTS news_comments;



CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contact_phone VARCHAR(255) NOT NULL DEFAULT '',
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
    category_id INT -- we connect the job titles (predefined)
);

CREATE TABLE meetups (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    parking BOOLEAN DEFAULT TRUE,
    location VARCHAR(255),
    max_seats INT NOT NULL DEFAULT 0, 
    meetup_date VARCHAR(255) NOT NULL DEFAULT '', 
    start_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,  
    end_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,         
    organizer_id INT, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    type ENUM('upcoming', 'past', 'ongoing') NOT NULL  DEFAULT "upcoming"
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


CREATE TABLE job_offers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    tags_id INT, 
    category_id INT NOT NULL DEFAULT 0,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    company_name VARCHAR(255) NOT NULL,
    required_experience VARCHAR(255) NOT NULL,
    technologies TEXT,
    job_offer_status ENUM('open', 'closed', 'filled', 'pending') NOT NULL DEFAULT 'open',
    job_type ENUM('full_time', 'part_time', 'contract', 'internship') NOT NULL DEFAULT 'full_time',
    job_benefits TEXT, 
    remote BOOLEAN DEFAULT FALSE,
    place_of_work VARCHAR(255),
    salary_range VARCHAR(255), 
    image_url TEXT NOT NULL DEFAULT '',
    contact_phone VARCHAR(255) NOT NULL DEFAULT '',
    contact_email VARCHAR(255) NOT NULL DEFAULT '',
    twitter_profile VARCHAR(255) NOT NULL DEFAULT '',
    linkedin_profile VARCHAR(255) NOT NULL DEFAULT '',
    facebook_profile VARCHAR(255) NOT NULL DEFAULT '',
    instagram_profile VARCHAR(100) NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tags_id INT,
    user_id INT,
    category_id INT NOT NULL DEFAULT 0,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    type ENUM('tech', 'meeetup', 'social') NOT NULL  DEFAULT "tech",
    image_url TEXT NOT NULL DEFAULT '', 
    contact_phone VARCHAR(255) NOT NULL DEFAULT '',
    contact_email VARCHAR(255) NOT NULL DEFAULT '',
    twitter_profile VARCHAR(255) NOT NULL DEFAULT '',
    linkedin_profile VARCHAR(255) NOT NULL DEFAULT '',
    facebook_profile VARCHAR(255) NOT NULL DEFAULT '',  
    instagram_handle VARCHAR(100) NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE speakers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,  
    meetup_id INT, 
    position VARCHAR(255) NOT NULL DEFAULT '',
    bio TEXT NOT NULL DEFAULT '', 
    rating DECIMAL(3, 2) DEFAULT 0.00,
    short_description VARCHAR(255) DEFAULT '',
    experiance VARCHAR(255) NOT NULL DEFAULT '',
    topic VARCHAR(255) NOT NULL DEFAULT '',
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

CREATE TABLE job_offer_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,  
    job_offer_id INT, 
    comment TEXT, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);


CREATE TABLE news_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,  
    news_id INT,  
    comment TEXT,  
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT, 
    meetup_id INT, 
    description TEXT,  
    media_url VARCHAR(255) NOT NULL DEFAULT '', 
    media_type ENUM('image', 'video', 'audio', 'other') NOT NULL DEFAULT 'other',
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

CREATE TABLE tags (
    tags_id AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE job_tags (
    PRIMARY KEY(job_offer_id, tags_id),
    job_offer_id INT,
    tags_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)


ALTER TABLE meetups  
    ADD CONSTRAINT fk_meetups_organizer FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE meetup_registrations 
    ADD CONSTRAINT fk_meetup_registrations_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_meetup_registrations_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id) ON DELETE CASCADE;

ALTER TABLE speakers 
    ADD CONSTRAINT fk_speakers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_speakers_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id) ON DELETE CASCADE;

ALTER TABLE meetup_comments 
    ADD CONSTRAINT fk_meetup_comments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_meetup_comments_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id) ON DELETE CASCADE;

ALTER TABLE reviews 
    ADD CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_reviews_meetup FOREIGN KEY (meetup_id) REFERENCES meetups(id) ON DELETE CASCADE;

ALTER TABLE speaker_categories 
    ADD CONSTRAINT fk_speaker_categories_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_speaker_categories_speaker FOREIGN KEY (speaker_id) REFERENCES speakers(id) ON DELETE CASCADE;

ALTER TABLE job_offers
    ADD CONSTRAINT fk_job_offers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_job_offers_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;

ALTER TABLE news
    ADD CONSTRAINT fk_news_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_news_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;

ALTER TABLE job_offer_comments
    ADD CONSTRAINT fk_job_offer_comments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_job_offer_comments_job_offer FOREIGN KEY (job_offer_id) REFERENCES job_offers(id) ON DELETE CASCADE;

ALTER TABLE news_comments
    ADD CONSTRAINT fk_news_comments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_news_comments_news FOREIGN KEY (news_id) REFERENCES news(id) ON DELETE CASCADE;
