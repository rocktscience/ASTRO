-- ============================================================
-- ASTRO Reference Database (reference_db)
-- Version: 1.0
-- Description: Static reference data for ASTRO platform
-- ============================================================

DROP DATABASE IF EXISTS reference_db;
CREATE DATABASE reference_db 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

USE reference_db;

-- ============================================================
-- CORE REFERENCE TABLES
-- ============================================================

-- Status Types (Universal)
CREATE TABLE status (
    id TINYINT UNSIGNED PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    applies_to VARCHAR(100) NOT NULL, -- 'universal', 'work', 'recording', etc.
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_applies_to (applies_to),
    INDEX idx_active (is_active)
) ENGINE=InnoDB;

-- Asset Types
CREATE TABLE asset_type (
    id TINYINT UNSIGNED PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    table_name VARCHAR(64) NOT NULL,
    id_prefix CHAR(1) NOT NULL UNIQUE, -- W for Work, R for Recording, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Languages (ISO 639-1)
CREATE TABLE language (
    id CHAR(2) PRIMARY KEY, -- ISO 639-1 code
    iso_639_3 CHAR(3) NULL,
    name_english VARCHAR(100) NOT NULL,
    name_native VARCHAR(100) NOT NULL,
    is_supported BOOLEAN DEFAULT FALSE, -- For UI translations
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_supported (is_supported)
) ENGINE=InnoDB;

-- Countries (ISO 3166-1)
CREATE TABLE country (
    id CHAR(2) PRIMARY KEY, -- ISO 3166-1 alpha-2
    iso_alpha_3 CHAR(3) NOT NULL UNIQUE,
    iso_numeric CHAR(3) NOT NULL UNIQUE,
    name_english VARCHAR(100) NOT NULL,
    name_native VARCHAR(100) NULL,
    capital VARCHAR(100) NULL,
    continent VARCHAR(50) NOT NULL,
    currency_id CHAR(3) NULL,
    phone_code VARCHAR(10) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_continent (continent),
    INDEX idx_currency (currency_id)
) ENGINE=InnoDB;

-- Currencies (ISO 4217)
CREATE TABLE currency (
    id CHAR(3) PRIMARY KEY, -- ISO 4217 code
    numeric_code CHAR(3) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    symbol VARCHAR(10) NULL,
    decimals TINYINT DEFAULT 2,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_active (is_active)
) ENGINE=InnoDB;

-- ============================================================
-- MUSIC INDUSTRY SPECIFIC
-- ============================================================

-- Societies (PROs, MROs, etc.)
CREATE TABLE society (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    acronym VARCHAR(20) NULL,
    country_id CHAR(2) NOT NULL,
    society_type VARCHAR(50) NOT NULL, -- PRO, MRO, CMO, etc.
    ipi_number VARCHAR(11) NULL UNIQUE,
    cae_number VARCHAR(9) NULL UNIQUE,
    website VARCHAR(255) NULL,
    email VARCHAR(255) NULL,
    phone VARCHAR(50) NULL,
    address TEXT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    supports_cwr BOOLEAN DEFAULT FALSE,
    cwr_version VARCHAR(10) NULL,
    supports_ddex BOOLEAN DEFAULT FALSE,
    ddex_version VARCHAR(10) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES country(id),
    INDEX idx_type (society_type),
    INDEX idx_active (is_active)
) ENGINE=InnoDB;

-- DSPs (Digital Service Providers)
CREATE TABLE dsp (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    dsp_type VARCHAR(50) NOT NULL, -- streaming, download, social, etc.
    website VARCHAR(255) NULL,
    api_endpoint VARCHAR(255) NULL,
    supports_ddex BOOLEAN DEFAULT FALSE,
    ddex_version VARCHAR(10) NULL,
    reporting_currency_id CHAR(3) NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reporting_currency_id) REFERENCES currency(id),
    INDEX idx_type (dsp_type),
    INDEX idx_active (is_active)
) ENGINE=InnoDB;

-- Territory Groups
CREATE TABLE territory_group (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_standard BOOLEAN DEFAULT FALSE, -- CISAC standard territories
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Territory Group Members
CREATE TABLE territory_group_member (
    territory_group_id INT UNSIGNED NOT NULL,
    country_id CHAR(2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (territory_group_id, country_id),
    FOREIGN KEY (territory_group_id) REFERENCES territory_group(id),
    FOREIGN KEY (country_id) REFERENCES country(id)
) ENGINE=InnoDB;

-- Roles (for contributors)
CREATE TABLE role (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    role_type VARCHAR(50) NOT NULL, -- creator, performer, technical, business
    description TEXT,
    cwr_code VARCHAR(3) NULL,
    ddex_code VARCHAR(20) NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_type (role_type)
) ENGINE=InnoDB;

-- Rights Types
CREATE TABLE rights_type (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL, -- performance, mechanical, sync, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category)
) ENGINE=InnoDB;

-- Musical Keys
CREATE TABLE musical_key (
    id TINYINT UNSIGNED PRIMARY KEY,
    code VARCHAR(3) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    is_major BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Genres
CREATE TABLE genre (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    parent_id INT UNSIGNED NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES genre(id),
    INDEX idx_parent (parent_id)
) ENGINE=InnoDB;

-- Instruments
CREATE TABLE instrument (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL, -- string, wind, percussion, etc.
    cisac_code VARCHAR(10) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category)
) ENGINE=InnoDB;

-- ============================================================
-- COMPLIANCE & STANDARDS
-- ============================================================

-- CWR Record Types
CREATE TABLE cwr_record_type (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code CHAR(3) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    group_type VARCHAR(50) NOT NULL, -- header, work, recording, etc.
    cwr_version VARCHAR(10) NOT NULL,
    field_count INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_group (group_type),
    INDEX idx_version (cwr_version)
) ENGINE=InnoDB;

-- DDEX Message Types
CREATE TABLE ddex_message_type (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    namespace VARCHAR(255) NOT NULL,
    schema_version VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_version (schema_version)
) ENGINE=InnoDB;

-- ============================================================
-- BUSINESS RULES
-- ============================================================

-- Subscription Tiers
CREATE TABLE subscription_tier (
    id TINYINT UNSIGNED PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    max_assets INT NOT NULL,
    max_users INT NOT NULL,
    max_api_calls_per_month INT NOT NULL,
    price_monthly DECIMAL(10,2) NOT NULL,
    price_yearly DECIMAL(10,2) NOT NULL,
    features JSON NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_active (is_active)
) ENGINE=InnoDB;

-- Payment Methods
CREATE TABLE payment_method (
    id TINYINT UNSIGNED PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    processor VARCHAR(50) NOT NULL, -- stripe, paypal, etc.
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- SYSTEM CONFIGURATION
-- ============================================================

-- System Settings
CREATE TABLE system_setting (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT NOT NULL,
    data_type VARCHAR(20) NOT NULL, -- string, integer, boolean, json
    description TEXT,
    is_editable BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_category_key (category, setting_key),
    INDEX idx_category (category)
) ENGINE=InnoDB;

-- API Rate Limit Tiers
CREATE TABLE rate_limit_tier (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    requests_per_minute INT NOT NULL,
    requests_per_hour INT NOT NULL,
    requests_per_day INT NOT NULL,
    burst_size INT DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- STORED PROCEDURES & FUNCTIONS
-- ============================================================

DELIMITER $$

-- Function to get territory countries
CREATE FUNCTION get_territory_countries(p_territory_code VARCHAR(50))
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_countries TEXT DEFAULT '';
    
    SELECT GROUP_CONCAT(tgm.country_id ORDER BY tgm.country_id SEPARATOR ',')
    INTO v_countries
    FROM territory_group tg
    JOIN territory_group_member tgm ON tg.id = tgm.territory_group_id
    WHERE tg.code = p_territory_code;
    
    RETURN v_countries;
END$$

-- Procedure to initialize reference data
CREATE PROCEDURE init_reference_data()
BEGIN
    -- Insert Status Types
    INSERT INTO status (id, code, name, applies_to) VALUES
    (1, 'ACTIVE', 'Active', 'universal'),
    (2, 'INACTIVE', 'Inactive', 'universal'),
    (3, 'DRAFT', 'Draft', 'universal'),
    (4, 'PENDING', 'Pending', 'universal'),
    (5, 'APPROVED', 'Approved', 'universal'),
    (6, 'REJECTED', 'Rejected', 'universal'),
    (7, 'PUBLISHED', 'Published', 'work,recording'),
    (8, 'UNPUBLISHED', 'Unpublished', 'work,recording'),
    (9, 'REGISTERED', 'Registered', 'work,recording'),
    (10, 'UNREGISTERED', 'Unregistered', 'work,recording');
    
    -- Insert Asset Types
    INSERT INTO asset_type (id, code, name, table_name, id_prefix) VALUES
    (1, 'WORK', 'Musical Work', 'work', 'W'),
    (2, 'RECORDING', 'Sound Recording', 'recording', 'R'),
    (3, 'RELEASE', 'Release', 'release', 'L'),
    (4, 'PERSON', 'Person', 'person', 'P'),
    (5, 'ORGANIZATION', 'Organization', 'organization', 'O'),
    (6, 'AGREEMENT', 'Agreement', 'agreement', 'A'),
    (7, 'ROYALTY', 'Royalty Statement', 'royalty_statement', 'Y'),
    (8, 'SYNC', 'Sync License', 'sync_license', 'S'),
    (9, 'NFT', 'NFT', 'nft', 'N'),
    (10, 'TOKEN', 'Fan Token', 'fan_token', 'T');
    
    -- Insert Languages
    INSERT INTO language (id, iso_639_3, name_english, name_native, is_supported) VALUES
    ('en', 'eng', 'English', 'English', TRUE),
    ('es', 'spa', 'Spanish', 'Español', TRUE),
    ('fr', 'fra', 'French', 'Français', TRUE),
    ('de', 'deu', 'German', 'Deutsch', TRUE),
    ('ja', 'jpn', 'Japanese', '日本語', TRUE),
    ('ko', 'kor', 'Korean', '한국어', TRUE),
    ('zh', 'zho', 'Chinese', '中文', TRUE),
    ('pt', 'por', 'Portuguese', 'Português', TRUE),
    ('ru', 'rus', 'Russian', 'Русский', TRUE),
    ('ar', 'ara', 'Arabic', 'العربية', TRUE),
    ('hi', 'hin', 'Hindi', 'हिन्दी', TRUE),
    ('it', 'ita', 'Italian', 'Italiano', TRUE),
    ('nl', 'nld', 'Dutch', 'Nederlands', TRUE),
    ('pl', 'pol', 'Polish', 'Polski', TRUE),
    ('tr', 'tur', 'Turkish', 'Türkçe', TRUE),
    ('sv', 'swe', 'Swedish', 'Svenska', TRUE),
    ('da', 'dan', 'Danish', 'Dansk', TRUE),
    ('no', 'nor', 'Norwegian', 'Norsk', TRUE),
    ('fi', 'fin', 'Finnish', 'Suomi', TRUE),
    ('he', 'heb', 'Hebrew', 'עברית', TRUE),
    ('vi', 'vie', 'Vietnamese', 'Tiếng Việt', TRUE),
    ('th', 'tha', 'Thai', 'ไทย', TRUE),
    ('id', 'ind', 'Indonesian', 'Bahasa Indonesia', TRUE),
    ('sw', 'swa', 'Swahili', 'Kiswahili', TRUE),
    ('ms', 'msa', 'Malay', 'Bahasa Melayu', TRUE),
    ('bn', 'ben', 'Bengali', 'বাংলা', TRUE),
    ('ta', 'tam', 'Tamil', 'தமிழ்', TRUE),
    ('te', 'tel', 'Telugu', 'తెలుగు', TRUE),
    ('mr', 'mar', 'Marathi', 'मराठी', TRUE),
    ('ur', 'urd', 'Urdu', 'اردو', TRUE),
    ('el', 'ell', 'Greek', 'Ελληνικά', TRUE),
    ('hu', 'hun', 'Hungarian', 'Magyar', TRUE),
    ('cs', 'ces', 'Czech', 'Čeština', TRUE),
    ('sk', 'slk', 'Slovak', 'Slovenčina', TRUE),
    ('ro', 'ron', 'Romanian', 'Română', TRUE),
    ('am', 'amh', 'Amharic', 'አማርኛ', TRUE),
    ('yo', 'yor', 'Yoruba', 'Yorùbá', TRUE),
    ('ig', 'ibo', 'Igbo', 'Igbo', TRUE),
    ('ha', 'hau', 'Hausa', 'Hausa', TRUE),
    ('uk', 'ukr', 'Ukrainian', 'Українська', TRUE),
    ('sr', 'srp', 'Serbian', 'Српски', TRUE),
    ('hr', 'hrv', 'Croatian', 'Hrvatski', TRUE),
    ('sl', 'slv', 'Slovenian', 'Slovenščina', TRUE),
    ('lt', 'lit', 'Lithuanian', 'Lietuvių', TRUE),
    ('lv', 'lav', 'Latvian', 'Latviešu', TRUE),
    ('et', 'est', 'Estonian', 'Eesti', TRUE),
    ('tl', 'tgl', 'Tagalog', 'Tagalog', TRUE),
    ('ka', 'kat', 'Georgian', 'ქართული', FALSE),
    ('gu', 'guj', 'Gujarati', 'ગુજરાતી', FALSE),
    ('kn', 'kan', 'Kannada', 'ಕನ್ನಡ', FALSE),
    ('ml', 'mal', 'Malayalam', 'മലയാളം', FALSE),
    ('pa', 'pan', 'Punjabi', 'ਪੰਜਾਬੀ', FALSE),
    ('si', 'sin', 'Sinhala', 'සිංහල', FALSE),
    ('af', 'afr', 'Afrikaans', 'Afrikaans', FALSE),
    ('zu', 'zul', 'Zulu', 'isiZulu', FALSE),
    ('xh', 'xho', 'Xhosa', 'isiXhosa', FALSE),
    ('bg', 'bul', 'Bulgarian', 'Български', FALSE),
    ('bs', 'bos', 'Bosnian', 'Bosanski', FALSE),
    ('mk', 'mkd', 'Macedonian', 'Македонски', FALSE),
    ('hy', 'hye', 'Armenian', 'Հայերեն', FALSE),
    ('az', 'aze', 'Azerbaijani', 'Azərbaycan', FALSE),
    ('kk', 'kaz', 'Kazakh', 'Қазақша', FALSE),
    ('uz', 'uzb', 'Uzbek', 'O‘zbek', FALSE);
    
    -- Insert Currencies
    INSERT INTO currency (id, numeric_code, name, symbol, decimals, is_active) VALUES
    ('USD', '840', 'US Dollar', '$', 2, TRUE),
    ('EUR', '978', 'Euro', '€', 2, TRUE),
    ('GBP', '826', 'British Pound', '£', 2, TRUE),
    ('JPY', '392', 'Japanese Yen', '¥', 0, TRUE),
    ('CNY', '156', 'Chinese Yuan', '¥', 2, TRUE),
    ('KRW', '410', 'South Korean Won', '₩', 0, TRUE),
    ('INR', '356', 'Indian Rupee', '₹', 2, TRUE),
    ('BRL', '986', 'Brazilian Real', 'R$', 2, TRUE),
    ('CAD', '124', 'Canadian Dollar', '$', 2, TRUE),
    ('AUD', '036', 'Australian Dollar', '$', 2, TRUE),
    ('MXN', '484', 'Mexican Peso', '$', 2, TRUE),
    ('RUB', '643', 'Russian Ruble', '₽', 2, TRUE),
    ('SGD', '702', 'Singapore Dollar', '$', 2, TRUE),
    ('HKD', '344', 'Hong Kong Dollar', '$', 2, TRUE),
    ('NZD', '554', 'New Zealand Dollar', '$', 2, TRUE),
    ('ZAR', '710', 'South African Rand', 'R', 2, TRUE),
    ('NGN', '566', 'Nigerian Naira', '₦', 2, TRUE),
    ('AED', '784', 'United Arab Emirates Dirham', 'د.إ', 2, TRUE),
    ('PHP', '608', 'Philippine Peso', '₱', 2, TRUE),
    ('VND', '704', 'Vietnamese Dong', '₫', 0, TRUE),
    ('THB', '764', 'Thai Baht', '฿', 2, TRUE),
    ('IDR', '360', 'Indonesian Rupiah', 'Rp', 2, TRUE),
    ('MYR', '458', 'Malaysian Ringgit', 'RM', 2, TRUE),
    ('KES', '404', 'Kenyan Shilling', 'KSh', 2, TRUE),
    ('PLN', '985', 'Polish Zloty', 'zł', 2, TRUE),
    ('TRY', '949', 'Turkish Lira', '₺', 2, TRUE),
    ('SEK', '752', 'Swedish Krona', 'kr', 2, TRUE),
    ('DKK', '208', 'Danish Krone', 'kr', 2, TRUE),
    ('NOK', '578', 'Norwegian Krone', 'kr', 2, TRUE),
    ('CHF', '756', 'Swiss Franc', 'CHF', 2, TRUE),
    ('ILS', '376', 'Israeli New Shekel', '₪', 2, TRUE),
    ('COP', '170', 'Colombian Peso', '$', 2, TRUE),
    ('ARS', '032', 'Argentine Peso', '$', 2, TRUE),
    ('CLP', '152', 'Chilean Peso', '$', 0, TRUE),
    ('PEN', '604', 'Peruvian Sol', 'S/', 2, TRUE),
    ('GHS', '936', 'Ghanaian Cedi', '₵', 2, TRUE),
    ('EGP', '818', 'Egyptian Pound', '£', 2, TRUE),
    ('UAH', '980', 'Ukrainian Hryvnia', '₴', 2, TRUE),
    ('SAR', '682', 'Saudi Riyal', '﷼', 2, TRUE),
    ('TWD', '901', 'New Taiwan Dollar', 'NT$', 2, TRUE),
    ('ETB', '230', 'Ethiopian Birr', 'Br', 2, FALSE),
    ('ZMW', '967', 'Zambian Kwacha', 'ZK', 2, FALSE),
    ('TZS', '834', 'Tanzanian Shilling', 'TSh', 2, FALSE),
    ('UGX', '800', 'Ugandan Shilling', 'USh', 0, FALSE),
    ('DZD', '012', 'Algerian Dinar', 'د.ج', 2, FALSE),
    ('MAD', '504', 'Moroccan Dirham', 'د.م.', 2, FALSE),
    ('BWP', '072', 'Botswana Pula', 'P', 2, FALSE),
    ('NAD', '516', 'Namibian Dollar', '$', 2, FALSE),
    ('BAM', '977', 'Bosnia-Herzegovina Convertible Mark', 'KM', 2, FALSE),
    ('GEL', '981', 'Georgian Lari', '₾', 2, FALSE),
    ('AMD', '051', 'Armenian Dram', '֏', 2, FALSE),
    ('AZN', '944', 'Azerbaijani Manat', '₼', 2, FALSE),
    ('KZT', '398', 'Kazakhstani Tenge', '₸', 2, FALSE),
    ('UZS', '860', 'Uzbekistani Som', 'сўм', 2, FALSE);
    
    -- Insert Major Countries
    INSERT INTO country (id, iso_alpha_3, iso_numeric, name_english, continent, currency_id, phone_code) VALUES
    ('US', 'USA', '840', 'United States', 'North America', 'USD', '+1'),
    ('GB', 'GBR', '826', 'United Kingdom', 'Europe', 'GBP', '+44'),
    ('CA', 'CAN', '124', 'Canada', 'North America', 'CAD', '+1'),
    ('AU', 'AUS', '036', 'Australia', 'Oceania', 'AUD', '+61'),
    ('DE', 'DEU', '276', 'Germany', 'Europe', 'EUR', '+49'),
    ('FR', 'FRA', '250', 'France', 'Europe', 'EUR', '+33'),
    ('ES', 'ESP', '724', 'Spain', 'Europe', 'EUR', '+34'),
    ('IT', 'ITA', '380', 'Italy', 'Europe', 'EUR', '+39'),
    ('JP', 'JPN', '392', 'Japan', 'Asia', 'JPY', '+81'),
    ('KR', 'KOR', '410', 'South Korea', 'Asia', 'KRW', '+82'),
    ('CN', 'CHN', '156', 'China', 'Asia', 'CNY', '+86'),
    ('IN', 'IND', '356', 'India', 'Asia', 'INR', '+91'),
    ('BR', 'BRA', '076', 'Brazil', 'South America', 'BRL', '+55'),
    ('MX', 'MEX', '484', 'Mexico', 'North America', 'MXN', '+52'),
    ('RU', 'RUS', '643', 'Russia', 'Europe/Asia', 'RUB', '+7'),
    ('NL', 'NLD', '528', 'Netherlands', 'Europe', 'EUR', '+31'),
    ('SE', 'SWE', '752', 'Sweden', 'Europe', 'SEK', '+46'),
    ('NO', 'NOR', '578', 'Norway', 'Europe', 'NOK', '+47'),
    ('DK', 'DNK', '208', 'Denmark', 'Europe', 'DKK', '+45'),
    ('BE', 'BEL', '056', 'Belgium', 'Europe', 'EUR', '+32');
    
    -- Insert Major Societies
    INSERT INTO society (code, name, acronym, country_id, society_type, supports_cwr, cwr_version, supports_ddex) VALUES
    ('ASCAP', 'American Society of Composers, Authors and Publishers', 'ASCAP', 'US', 'PRO', TRUE, '3.1', TRUE),
    ('BMI', 'Broadcast Music, Inc.', 'BMI', 'US', 'PRO', TRUE, '3.1', TRUE),
    ('SESAC', 'SESAC Inc.', 'SESAC', 'US', 'PRO', TRUE, '3.1', FALSE),
    ('SOCAN', 'Society of Composers, Authors and Music Publishers of Canada', 'SOCAN', 'CA', 'PRO', TRUE, '3.1', TRUE),
    ('PRS', 'Performing Right Society', 'PRS', 'GB', 'PRO', TRUE, '3.1', TRUE),
    ('MCPS', 'Mechanical-Copyright Protection Society', 'MCPS', 'GB', 'MRO', TRUE, '3.1', TRUE),
    ('SACEM', 'Société des auteurs, compositeurs et éditeurs de musique', 'SACEM', 'FR', 'PRO', TRUE, '3.1', TRUE),
    ('GEMA', 'Gesellschaft für musikalische Aufführungs- und mechanische Vervielfältigungsrechte', 'GEMA', 'DE', 'PRO', TRUE, '3.1', TRUE),
    ('JASRAC', 'Japanese Society for Rights of Authors, Composers and Publishers', 'JASRAC', 'JP', 'PRO', TRUE, '3.1', FALSE),
    ('KOMCA', 'Korea Music Copyright Association', 'KOMCA', 'KR', 'PRO', TRUE, '3.1', FALSE),
    ('APRA', 'Australasian Performing Right Association', 'APRA', 'AU', 'PRO', TRUE, '3.1', TRUE),
    ('AMCOS', 'Australasian Mechanical Copyright Owners Society', 'AMCOS', 'AU', 'MRO', TRUE, '3.1', TRUE),
    ('SIAE', 'Società Italiana degli Autori ed Editori', 'SIAE', 'IT', 'PRO', TRUE, '3.1', FALSE),
    ('SGAE', 'Sociedad General de Autores y Editores', 'SGAE', 'ES', 'PRO', TRUE, '3.1', FALSE),
    ('BUMA', 'Buma Association', 'BUMA', 'NL', 'PRO', TRUE, '3.1', TRUE),
    ('STEMRA', 'Stemra', 'STEMRA', 'NL', 'MRO', TRUE, '3.1', TRUE),
    ('STIM', 'Svenska Tonsättares Internationella Musikbyrå', 'STIM', 'SE', 'PRO', TRUE, '3.1', TRUE),
    ('SABAM', 'Société d\'Auteurs Belge', 'SABAM', 'BE', 'PRO', TRUE, '3.1', TRUE),
    ('HFA', 'Harry Fox Agency', 'HFA', 'US', 'MRO', TRUE, '3.1', TRUE),
    ('MLC', 'Mechanical Licensing Collective', 'MLC', 'US', 'MRO', FALSE, NULL, TRUE);
    
    -- Insert Major DSPs
    INSERT INTO dsp (code, name, dsp_type, supports_ddex, reporting_currency_id) VALUES
    ('SPOTIFY', 'Spotify', 'streaming', TRUE, 'USD'),
    ('APPLE_MUSIC', 'Apple Music', 'streaming', TRUE, 'USD'),
    ('YOUTUBE', 'YouTube', 'streaming', TRUE, 'USD'),
    ('AMAZON_MUSIC', 'Amazon Music', 'streaming', TRUE, 'USD'),
    ('DEEZER', 'Deezer', 'streaming', TRUE, 'EUR'),
    ('TIDAL', 'Tidal', 'streaming', TRUE, 'USD'),
    ('SOUNDCLOUD', 'SoundCloud', 'streaming', FALSE, 'USD'),
    ('PANDORA', 'Pandora', 'streaming', TRUE, 'USD'),
    ('QOBUZ', 'Qobuz', 'streaming', TRUE, 'EUR'),
    ('NAPSTER', 'Napster', 'streaming', TRUE, 'USD'),
    ('BANDCAMP', 'Bandcamp', 'download', FALSE, 'USD'),
    ('ITUNES', 'iTunes Store', 'download', TRUE, 'USD'),
    ('BEATPORT', 'Beatport', 'download', TRUE, 'USD'),
    ('TIKTOK', 'TikTok', 'social', FALSE, 'USD'),
    ('INSTAGRAM', 'Instagram', 'social', FALSE, 'USD'),
    ('FACEBOOK', 'Facebook', 'social', FALSE, 'USD'),
    ('TRILLER', 'Triller', 'social', FALSE, 'USD');
    
    -- Insert Territory Groups
INSERT INTO territory_group (code, name, is_standard) VALUES
    ('WORLD', 'Worldwide', TRUE),
    ('EU', 'European Union', TRUE),
    ('NAFTA', 'North American Free Trade Agreement', TRUE),
    ('APAC', 'Asia-Pacific', TRUE),
    ('LATAM', 'Latin America', TRUE),
    ('MENA', 'Middle East and North Africa', TRUE),
    ('SSA', 'Sub-Saharan Africa', TRUE),
    ('COMMONWEALTH', 'Commonwealth Nations', TRUE),
    ('OECD', 'OECD Countries', TRUE),
    ('ASEAN', 'Association of Southeast Asian Nations', TRUE),
    ('BRICS', 'Brazil, Russia, India, China, South Africa', TRUE),
    ('ANZ', 'Australia and New Zealand', TRUE),
    ('CIS', 'Commonwealth of Independent States', TRUE),
    ('NORDIC', 'Nordic Countries', TRUE);
    
    -- Insert Roles
    INSERT INTO role (code, name, role_type, cwr_code, display_order) VALUES
    ('COMPOSER', 'Composer', 'creator', 'C', 1),
    ('LYRICIST', 'Lyricist', 'creator', 'A', 2),
    ('PUBLISHER', 'Publisher', 'business', 'E', 3),
    ('SUB_PUBLISHER', 'Sub-Publisher', 'business', 'SE', 4),
    ('ADMINISTRATOR', 'Administrator', 'business', 'AM', 5),
    ('PERFORMER', 'Performer', 'performer', NULL, 6),
    ('PRODUCER', 'Producer', 'technical', NULL, 7),
    ('ENGINEER', 'Engineer', 'technical', NULL, 8),
    ('MIXER', 'Mixing Engineer', 'technical', NULL, 9),
    ('MASTERING', 'Mastering Engineer', 'technical', NULL, 10),
    ('ARRANGER', 'Arranger', 'creator', 'AR', 11),
    ('REMIXER', 'Remixer', 'creator', NULL, 12),
    ('FEATURED', 'Featured Artist', 'performer', NULL, 13),
    ('MUSICIAN', 'Musician', 'performer', NULL, 14),
    ('VOCALIST', 'Vocalist', 'performer', NULL, 15);
    
    -- Insert Rights Types
    INSERT INTO rights_type (code, name, category) VALUES
    ('PERFORMANCE', 'Performance Rights', 'performance'),
    ('MECHANICAL', 'Mechanical Rights', 'mechanical'),
    ('SYNC', 'Synchronization Rights', 'sync'),
    ('MASTER', 'Master Recording Rights', 'master'),
    ('PRINT', 'Print Rights', 'print'),
    ('GRAND', 'Grand Rights', 'performance'),
    ('DIGITAL', 'Digital Rights', 'digital'),
    ('STREAMING', 'Streaming Rights', 'digital'),
    ('DOWNLOAD', 'Download Rights', 'digital'),
    ('RINGTONE', 'Ringtone Rights', 'digital'),
    ('KARAOKE', 'Karaoke Rights', 'mechanical'),
    ('SAMPLE', 'Sample Rights', 'master'),
    ('REMIX', 'Remix Rights', 'master'),
    ('BROADCAST', 'Broadcast Rights', 'performance'),
    ('ONLINE', 'Online Rights', 'digital');
    
    -- Insert Musical Keys
    INSERT INTO musical_key (id, code, name, is_major) VALUES
    (1, 'C', 'C Major', TRUE),
    (2, 'Am', 'A Minor', FALSE),
    (3, 'G', 'G Major', TRUE),
    (4, 'Em', 'E Minor', FALSE),
    (5, 'D', 'D Major', TRUE),
    (6, 'Bm', 'B Minor', FALSE),
    (7, 'A', 'A Major', TRUE),
    (8, 'F#m', 'F# Minor', FALSE),
    (9, 'E', 'E Major', TRUE),
    (10, 'C#m', 'C# Minor', FALSE),
    (11, 'B', 'B Major', TRUE),
    (12, 'G#m', 'G# Minor', FALSE),
    (13, 'F#', 'F# Major', TRUE),
    (14, 'D#m', 'D# Minor', FALSE),
    (15, 'Db', 'Db Major', TRUE),
    (16, 'Bbm', 'Bb Minor', FALSE),
    (17, 'Ab', 'Ab Major', TRUE),
    (18, 'Fm', 'F Minor', FALSE),
    (19, 'Eb', 'Eb Major', TRUE),
    (20, 'Cm', 'C Minor', FALSE),
    (21, 'Bb', 'Bb Major', TRUE),
    (22, 'Gm', 'G Minor', FALSE),
    (23, 'F', 'F Major', TRUE),
    (24, 'Dm', 'D Minor', FALSE);
    
    -- Insert Genres (hierarchical)
    INSERT INTO genre (code, name, parent_id) VALUES
    ('ROCK', 'Rock', NULL),
    ('POP', 'Pop', NULL),
    ('HIPHOP', 'Hip Hop', NULL),
    ('ELECTRONIC', 'Electronic', NULL),
    ('JAZZ', 'Jazz', NULL),
    ('CLASSICAL', 'Classical', NULL),
    ('COUNTRY', 'Country', NULL),
    ('RNB', 'R&B', NULL),
    ('LATIN', 'Latin', NULL),
    ('REGGAE', 'Reggae', NULL),
    ('BLUES', 'Blues', NULL),
    ('FOLK', 'Folk', NULL),
    ('METAL', 'Metal', NULL),
    ('SOUL', 'Soul', NULL),
    ('GOSPEL', 'Gospel', NULL),
    ('WORLD', 'World', NULL),
    ('INDIE', 'Indie', NULL),
    ('ALTERNATIVE', 'Alternative', NULL),
    ('SOUNDTRACK', 'Soundtrack', NULL),
    ('KPOP', 'K-Pop', NULL);
    
    -- Insert Subscription Tiers
    INSERT INTO subscription_tier (id, code, name, max_assets, max_users, max_api_calls_per_month, price_monthly, price_yearly, features) VALUES
    (1, 'LAUNCHPAD', 'Launchpad', 50, 1, 1000, 0.00, 0.00, 
        '{"catalog_management": true, "basic_royalties": true, "basic_analytics": true, "cwr_export": false, "api_access": false, "custom_agreements": false, "blockchain": false, "support": "community"}'),
    (2, 'ASCEND', 'Ascend', 500, 5, 10000, 29.00, 290.00,
        '{"catalog_management": true, "basic_royalties": true, "basic_analytics": true, "cwr_export": true, "api_access": true, "custom_agreements": true, "blockchain": false, "support": "email"}'),
    (3, 'PRO', 'Pro', 5000, 20, 100000, 199.00, 1990.00,
        '{"catalog_management": true, "advanced_royalties": true, "advanced_analytics": true, "cwr_export": true, "api_access": true, "custom_agreements": true, "blockchain": true, "support": "priority"}'),
    (4, 'ENTERPRISE', 'Enterprise', 999999, 999999, 999999999, 0.00, 0.00,
        '{"catalog_management": true, "advanced_royalties": true, "advanced_analytics": true, "cwr_export": true, "api_access": true, "custom_agreements": true, "blockchain": true, "support": "dedicated", "custom_features": true}');
    
    -- Insert CWR Record Types
    INSERT INTO cwr_record_type (code, name, group_type, cwr_version, field_count) VALUES
    -- Headers
    ('HDR', 'Header Record', 'header', '3.1', 20),
    ('GRH', 'Group Header', 'header', '3.1', 15),
    ('TRL', 'Group Trailer', 'header', '3.1', 10),
    -- Work Records
    ('NWR', 'New Work Registration', 'work', '3.1', 45),
    ('REV', 'Revised Work Registration', 'work', '3.1', 45),
    ('ISW', 'Notification of ISWC', 'work', '3.1', 20),
    ('EXC', 'Existing Work in Conflict', 'work', '3.1', 25),
    -- Work Detail Records
    ('ALT', 'Alternate Title', 'work_detail', '3.1', 15),
    ('PER', 'Performing Artist', 'work_detail', '3.1', 20),
    ('REC', 'Recording Detail', 'work_detail', '3.1', 25),
    ('ORN', 'Work Origin', 'work_detail', '3.1', 15),
    ('INS', 'Instrumentation', 'work_detail', '3.1', 20),
    ('COM', 'Component', 'work_detail', '3.1', 25),
    ('VER', 'Original Work', 'work_detail', '3.1', 20),
    -- Interested Party Records
    ('SPU', 'Publisher Controlled by Submitter', 'party', '3.1', 40),
    ('SPT', 'Publisher Controlled by Other Society', 'party', '3.1', 40),
    ('SWR', 'Writer Controlled by Submitter', 'party', '3.1', 35),
    ('SWT', 'Writer Controlled by Other Society', 'party', '3.1', 35),
    ('PWR', 'Publisher for Writer', 'party', '3.1', 30),
    ('OPU', 'Other Publisher', 'party', '3.1', 35),
    ('OWR', 'Other Writer', 'party', '3.1', 30),
    -- Territory Records
    ('TER', 'Territory of Control', 'territory', '3.1', 20),
    -- Agreement Records
    ('AGR', 'Agreement', 'agreement', '3.1', 30),
    ('IPA', 'Interested Party Agreement', 'agreement', '3.1', 25),
    -- Acknowledgement Records
    ('ACK', 'Acknowledgement', 'acknowledgement', '3.1', 20),
    ('ERR', 'Error', 'acknowledgement', '3.1', 25),
    ('MSG', 'Message', 'acknowledgement', '3.1', 15);
    
    -- Insert DDEX Message Types
    INSERT INTO ddex_message_type (code, name, namespace, schema_version) VALUES
    ('ERN', 'Electronic Release Notification', 'http://ddex.net/xml/ern/41', '4.1'),
    ('RIN', 'Recording Information Notification', 'http://ddex.net/xml/rin/11', '1.1'),
    ('DSR', 'Digital Sales Report', 'http://ddex.net/xml/dsr/11', '1.1'),
    ('LCR', 'License Request', 'http://ddex.net/xml/lcr/10', '1.0'),
    ('MWN', 'Musical Work Notification', 'http://ddex.net/xml/mwn/11', '1.1'),
    ('WSDC', 'Web Service Description', 'http://ddex.net/xml/wsdc/10', '1.0');
    
    -- Insert System Settings
    INSERT INTO system_setting (category, setting_key, setting_value, data_type, description) VALUES
    ('general', 'platform_name', 'ASTRO', 'string', 'Platform display name'),
    ('general', 'platform_url', 'https://astrorightsadmin.com', 'string', 'Platform URL'),
    ('general', 'support_email', 'support@astrorightsadmin.com', 'string', 'Support email address'),
    ('general', 'default_currency', 'USD', 'string', 'Default currency code'),
    ('general', 'default_language', 'en', 'string', 'Default language code'),
    ('security', 'password_min_length', '8', 'integer', 'Minimum password length'),
    ('security', 'password_require_uppercase', 'true', 'boolean', 'Require uppercase letter'),
    ('security', 'password_require_lowercase', 'true', 'boolean', 'Require lowercase letter'),
    ('security', 'password_require_number', 'true', 'boolean', 'Require number'),
    ('security', 'password_require_special', 'true', 'boolean', 'Require special character'),
    ('security', 'session_timeout_minutes', '30', 'integer', 'Session timeout in minutes'),
    ('security', 'max_login_attempts', '5', 'integer', 'Max login attempts before lockout'),
    ('security', 'lockout_duration_minutes', '30', 'integer', 'Account lockout duration'),
    ('api', 'rate_limit_enabled', 'true', 'boolean', 'Enable API rate limiting'),
    ('api', 'default_page_size', '50', 'integer', 'Default API page size'),
    ('api', 'max_page_size', '1000', 'integer', 'Maximum API page size'),
    ('royalty', 'minimum_payment_threshold', '10.00', 'decimal', 'Minimum payment threshold'),
    ('royalty', 'payment_processing_days', '7', 'integer', 'Days to process payments'),
    ('cwr', 'default_version', '3.1', 'string', 'Default CWR version'),
    ('cwr', 'sender_type', 'PB', 'string', 'CWR sender type code'),
    ('ddex', 'default_version', '4.1', 'string', 'Default DDEX version'),
    ('blockchain', 'ethereum_network', 'mainnet', 'string', 'Ethereum network'),
    ('blockchain', 'solana_network', 'mainnet-beta', 'string', 'Solana network'),
    ('ai', 'metadata_validation_enabled', 'true', 'boolean', 'Enable AI metadata validation'),
    ('ai', 'similarity_threshold', '0.85', 'decimal', 'Similarity threshold for matching');
    
    -- Insert Rate Limit Tiers
    INSERT INTO rate_limit_tier (code, name, requests_per_minute, requests_per_hour, requests_per_day) VALUES
    ('BASIC', 'Basic', 60, 1000, 10000),
    ('STANDARD', 'Standard', 120, 5000, 50000),
    ('PREMIUM', 'Premium', 300, 10000, 100000),
    ('UNLIMITED', 'Unlimited', 9999, 99999, 999999);
    
    -- Insert Payment Methods
    INSERT INTO payment_method (id, code, name, processor) VALUES
    (1, 'STRIPE_CARD', 'Credit/Debit Card', 'stripe'),
    (2, 'STRIPE_BANK', 'Bank Transfer', 'stripe'),
    (3, 'PAYPAL', 'PayPal', 'paypal'),
    (4, 'WIRE', 'Wire Transfer', 'manual'),
    (5, 'CRYPTO', 'Cryptocurrency', 'crypto');
    
END$$

DELIMITER ;

-- ============================================================
-- INITIAL DATA LOAD
-- ============================================================

CALL init_reference_data();

-- ============================================================
-- REFERENCE DATA VIEWS
-- ============================================================

-- View for active societies with contact info
CREATE VIEW v_active_societies AS
SELECT 
    s.id,
    s.code,
    s.name,
    s.acronym,
    s.country_id,
    c.name_english AS country_name,
    s.society_type,
    s.ipi_number,
    s.website,
    s.email,
    s.supports_cwr,
    s.cwr_version,
    s.supports_ddex,
    s.ddex_version
FROM society s
JOIN country c ON s.country_id = c.id
WHERE s.is_active = TRUE
ORDER BY s.name;

-- View for territories with countries
CREATE VIEW v_territory_countries AS
SELECT 
    tg.id AS territory_id,
    tg.code AS territory_code,
    tg.name AS territory_name,
    c.id AS country_id,
    c.name_english AS country_name,
    c.iso_alpha_3 AS country_code_3
FROM territory_group tg
JOIN territory_group_member tgm ON tg.id = tgm.territory_group_id
JOIN country c ON tgm.country_id = c.id
ORDER BY tg.name, c.name_english;

-- View for subscription features
CREATE VIEW v_subscription_features AS
SELECT 
    st.id,
    st.code,
    st.name,
    st.max_assets,
    st.max_users,
    st.max_api_calls_per_month,
    st.price_monthly,
    st.price_yearly,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.catalog_management')) AS catalog_management,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.basic_royalties')) AS basic_royalties,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.advanced_royalties')) AS advanced_royalties,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.basic_analytics')) AS basic_analytics,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.advanced_analytics')) AS advanced_analytics,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.cwr_export')) AS cwr_export,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.api_access')) AS api_access,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.custom_agreements')) AS custom_agreements,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.blockchain')) AS blockchain,
    JSON_UNQUOTE(JSON_EXTRACT(st.features, '$.support')) AS support_level
FROM subscription_tier st
WHERE st.is_active = TRUE
ORDER BY st.display_order;

-- ============================================================
-- GRANTS (adjust as needed for your setup)
-- ============================================================

-- Create application user if not exists
-- CREATE USER IF NOT EXISTS 'astro_app'@'%' IDENTIFIED BY 'your_secure_password';

-- Grant privileges
-- GRANT SELECT, INSERT, UPDATE ON reference_db.* TO 'astro_app'@'%';
-- GRANT DELETE ON reference_db.system_setting TO 'astro_app'@'%';
-- GRANT EXECUTE ON reference_db.* TO 'astro_app'@'%';

-- FLUSH PRIVILEGES;