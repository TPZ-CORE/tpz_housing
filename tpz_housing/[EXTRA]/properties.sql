
-- Dumping structure for table tpzcore.properties
CREATE TABLE IF NOT EXISTS `properties` (
  `name` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `charidentifier` int(11) DEFAULT 0,
  `storage` longtext DEFAULT '{}',
  `wardrobe` longtext DEFAULT '{}',
  `ledger` int(11) DEFAULT 0,
  `keyholders` longtext DEFAULT '[]',
  `owned` int(1) DEFAULT 0,
  `duration` int(11) DEFAULT 0,
  `paid` int(1) DEFAULT 0,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;