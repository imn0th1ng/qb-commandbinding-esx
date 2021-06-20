CREATE TABLE `mykeybinds` (
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`keymeta` LONGTEXT NULL DEFAULT '[]' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`identifier`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
