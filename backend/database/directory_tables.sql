-- Mental Health Directory Database Schema

-- Table for official 58 Wilayas of Algeria
CREATE TABLE IF NOT EXISTS wilayas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name_fr VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Professionals
CREATE TABLE IF NOT EXISTS professionals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    professional_type VARCHAR(100), -- e.g., Psychiatre, Psychologue clinicien
    specialty VARCHAR(255),
    gender ENUM('MALE', 'FEMALE', 'UNKNOWN') DEFAULT 'UNKNOWN',
    phone_primary VARCHAR(20),
    phone_secondary VARCHAR(20),
    email VARCHAR(255),
    wilaya_id INT NOT NULL,
    commune VARCHAR(255),
    address TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    consultation_online BOOLEAN DEFAULT FALSE,
    children BOOLEAN DEFAULT FALSE,
    adolescents BOOLEAN DEFAULT FALSE,
    adults BOOLEAN DEFAULT FALSE,
    description TEXT,
    verification_status ENUM('VERIFIE', 'A_VERIFIER', 'SOURCE_SECONDAIRE', 'INFORMATION_INCOMPLETE', 'FERME') DEFAULT 'A_VERIFIER',
    last_verified_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (wilaya_id) REFERENCES wilayas(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Establishments
CREATE TABLE IF NOT EXISTS establishments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    establishment_type VARCHAR(100), -- e.g., EHS, EPH, Cabinet
    public_private ENUM('PUBLIC', 'PRIVE', 'INCONNU') DEFAULT 'INCONNU',
    specialty VARCHAR(255),
    phone_primary VARCHAR(20),
    phone_secondary VARCHAR(20),
    email VARCHAR(255),
    wilaya_id INT NOT NULL,
    commune VARCHAR(255),
    address TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    opening_hours TEXT,
    description TEXT,
    verification_status ENUM('VERIFIE', 'A_VERIFIER', 'SOURCE_SECONDAIRE', 'INFORMATION_INCOMPLETE', 'FERME') DEFAULT 'A_VERIFIER',
    last_verified_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (wilaya_id) REFERENCES wilayas(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Sources
CREATE TABLE IF NOT EXISTS sources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    source_name VARCHAR(255) NOT NULL,
    source_type VARCHAR(100), -- e.g., Google Maps, Docteur360
    source_url TEXT,
    retrieved_at DATETIME,
    notes TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Relation between professional and source
CREATE TABLE IF NOT EXISTS professional_sources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    professional_id INT NOT NULL,
    source_id INT NOT NULL,
    source_reference VARCHAR(255),
    retrieved_at DATETIME,
    verification_status VARCHAR(50),
    FOREIGN KEY (professional_id) REFERENCES professionals(id),
    FOREIGN KEY (source_id) REFERENCES sources(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Relation between establishment and source
CREATE TABLE IF NOT EXISTS establishment_sources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    establishment_id INT NOT NULL,
    source_id INT NOT NULL,
    source_reference VARCHAR(255),
    retrieved_at DATETIME,
    verification_status VARCHAR(50),
    FOREIGN KEY (establishment_id) REFERENCES establishments(id),
    FOREIGN KEY (source_id) REFERENCES sources(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for duplicate candidates
CREATE TABLE IF NOT EXISTS duplicate_candidates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    record_type ENUM('PROFESSIONAL', 'ESTABLISHMENT') NOT NULL,
    record_a_id INT NOT NULL,
    record_b_id INT NOT NULL,
    similarity_score DECIMAL(5, 2),
    reason TEXT,
    resolution_status ENUM('PENDING', 'MERGED', 'DISMISSED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for directory reports
CREATE TABLE IF NOT EXISTS directory_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    record_type ENUM('PROFESSIONAL', 'ESTABLISHMENT') NOT NULL,
    record_id INT NOT NULL,
    report_type VARCHAR(100), -- e.g., incorrect_phone, closed
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'REVIEWED', 'RESOLVED') DEFAULT 'PENDING',
    reviewed_by INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Indexes for performance
CREATE INDEX idx_prof_wilaya ON professionals(wilaya_id);
CREATE INDEX idx_prof_type ON professionals(professional_type);
CREATE INDEX idx_prof_status ON professionals(verification_status);
CREATE INDEX idx_est_wilaya ON establishments(wilaya_id);
CREATE INDEX idx_est_type ON establishments(establishment_type);
CREATE INDEX idx_est_pub_priv ON establishments(public_private);
