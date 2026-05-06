CREATE TABLE SystemConfiguration (
    SystemID INT PRIMARY KEY,
    SystemName NVARCHAR(100),
    SettingsBinary BINARY(1) NOT NULL  -- 1 byte = 8 possible settings
);

-- Helper: Insert settings using bitwise values
-- Bit positions: 
--   1 = EnableLogging (bit 0, value 1)
--   2 = EnableEmail (bit 1, value 2)
--   3 = RequireAuth (bit 2, value 4)
--   4 = IsActive (bit 3, value 8)

-- Insert a row: EnableLogging + EnableEmail + IsActive = 1 + 2 + 8 = 11
INSERT INTO SystemConfiguration (SystemID, SystemName, SettingsBinary)
VALUES (1, 'MainServer', 11);  -- 0x0B = decimal 11 (binary 00001011)

-- Insert another row: RequireAuth only = 4
INSERT INTO SystemConfiguration (SystemID, SystemName, SettingsBinary)
VALUES (2, 'BackupServer', 4);  -- 0x04 = decimal 4 (binary 00000100)

-- Read settings and check individual flags using bitwise AND
SELECT 
    SystemName,
    SettingsBinary,
    CASE WHEN SettingsBinary & 1 = 1 THEN 'ON' ELSE 'OFF' END AS EnableLogging,
    CASE WHEN SettingsBinary & 2 = 2 THEN 'ON' ELSE 'OFF' END AS EnableEmail,
    CASE WHEN SettingsBinary & 4 = 4 THEN 'ON' ELSE 'OFF' END AS RequireAuth,
    CASE WHEN SettingsBinary & 8 = 8 THEN 'ON' ELSE 'OFF' END AS IsActive
FROM SystemConfiguration;

-- Update a setting: Turn on RequireAuth for MainServer (add 4 to current 11 = 15)
UPDATE SystemConfiguration
SET SettingsBinary = SettingsBinary | 4
WHERE SystemID = 1;

-- Turn off EnableEmail for MainServer (subtract 2)
UPDATE SystemConfiguration
SET SettingsBinary = SettingsBinary & ~2
WHERE SystemID = 1;

-- Verify final settings
SELECT 
    SystemName,
    SettingsBinary,
    CASE WHEN SettingsBinary & 1 = 1 THEN 'ON' ELSE 'OFF' END AS EnableLogging,
    CASE WHEN SettingsBinary & 2 = 2 THEN 'ON' ELSE 'OFF' END AS EnableEmail,
    CASE WHEN SettingsBinary & 4 = 4 THEN 'ON' ELSE 'OFF' END AS RequireAuth,
    CASE WHEN SettingsBinary & 8 = 8 THEN 'ON' ELSE 'OFF' END AS IsActive
FROM SystemConfiguration;