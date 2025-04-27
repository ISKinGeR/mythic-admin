-- Create admin_logs table
CREATE TABLE IF NOT EXISTS admin_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL UNIQUE,
    Name VARCHAR(100) DEFAULT 'Unknown',
    Source INT,
    Status VARCHAR(20) DEFAULT 'Offline',
    AP VARCHAR(20) DEFAULT 'N/A',
    StaffGroup VARCHAR(50) DEFAULT 'None',
    Disconnected TINYINT(1) DEFAULT 0,
    DisconnectReason VARCHAR(255),
    Logged TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_identifier (identifier)
);

-- Create admin_history table
CREATE TABLE IF NOT EXISTS admin_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_identifier VARCHAR(50) NOT NULL,
    event VARCHAR(100) NOT NULL,
    date VARCHAR(50),
    extrainfo TEXT,
    target_identifier VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_admin_identifier (admin_identifier),
    FOREIGN KEY (admin_identifier) REFERENCES admin_logs(identifier) ON DELETE CASCADE
);