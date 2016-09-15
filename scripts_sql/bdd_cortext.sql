CREATE DATABASE IF NOT EXISTS ct_auth;

USE ct_auth;

GRANT ALL PRIVILEGES ON ct_auth.* TO 'ct_auth'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;


CREATE DATABASE IF NOT EXISTS ct_assets;

USE ct_assets;

GRANT ALL PRIVILEGES ON ct_assets.* TO 'ct_assets'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;

CREATE TABLE IF NOT EXISTS `document` (
  `hash` varchar(256) NOT NULL COMMENT 'md5 du fullname (path+filename)',
  `fullname` text NOT NULL COMMENT 'path+filename reel',
  `username` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`hash`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE DATABASE IF NOT EXISTS ct_manager DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;

USE ct_manager;

GRANT ALL PRIVILEGES ON ct_manager.* TO 'ct_manager'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;

CREATE TABLE IF NOT EXISTS `job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `script_path` text,
  `result_path` text,
  `log_path` text,
  `upload_path` text,
  `state` bigint(20) NOT NULL DEFAULT '0',
  `user_id` bigint(20) NOT NULL,
  `script_id` bigint(20) NOT NULL,
  `corpu_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `document_path` text COMMENT 'document hash',
  `context` text,
  PRIMARY KEY (`id`),
  KEY `script_id_idx` (`script_id`),
  KEY `corpu_id_idx` (`corpu_id`),
  KEY `user_id_idx` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;

CREATE TABLE IF NOT EXISTS `script` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  `script_path` text NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `ispublic` tinyint(1) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 ;


CREATE DATABASE IF NOT EXISTS `nano`;

USE `nano`;

GRANT ALL PRIVILEGES ON nano.* TO 'nano'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;
