
CREATE TABLE IF NOT EXISTS `properties` (
  `name` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `charidentifier` int(11) DEFAULT 0,
  `storage` longtext DEFAULT '{}',
  `wardrobe` longtext DEFAULT '{}',
  `furniture` longtext DEFAULT '[]',
  `ledger` int(11) DEFAULT 0,
  `upgrade` int(2) DEFAULT 0,
  `keyholders` longtext DEFAULT '[]',
  `owned` int(1) DEFAULT 0,
  `duration` int(11) DEFAULT 0,
  `paid` int(1) DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
