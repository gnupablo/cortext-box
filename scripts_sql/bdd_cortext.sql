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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getNextJob` AS select `job`.`id` AS `id`,`job`.`script_path` AS `script_path`,`job`.`result_path` AS `result_path`,`job`.`context` AS `context`,`job`.`state` AS `state`,`ct_auth`.`users`.`name` AS `user`,`job`.`label` AS `label`,`job`.`created_at` AS `created_at`,`job`.`updated_at` AS `updated_at` from (`job` join `ct_auth`.`users`) where ((`job`.`state` = '1') and (`job`.`user_id` = `ct_auth`.`users`.`id`)) order by `job`.`id` limit 1;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jobWaitingForWorker` AS select `job`.`id` AS `id`,`job`.`script_path` AS `script_path`,`job`.`result_path` AS `result_path`,`job`.`context` AS `context`,`job`.`state` AS `state`,`job`.`user_id` AS `user_id`,`job`.`label` AS `label`,`job`.`created_at` AS `created_at`,`job`.`updated_at` AS `updated_at`,`ct_auth`.`users`.`name` AS `user`,`script`.`label` AS `script` from ((`job` left join `ct_auth`.`users` on((`job`.`user_id` = `ct_auth`.`users`.`id`))) left join `script` on((`job`.`script_id` = `script`.`id`))) where (`job`.`state` = '2') order by `job`.`id`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitor_job` AS select `job`.`id` AS `id`,`job`.`state` AS `state`,`ct_auth`.`users`.`name` AS `user`,`job`.`label` AS `label`,`job`.`created_at` AS `created_at`,`job`.`updated_at` AS `updated_at`,`job`.`context` AS `context`,`job`.`result_path` AS `result_path`,`script`.`label` AS `script` from ((`job` left join `ct_auth`.`users` on((`job`.`user_id` = `ct_auth`.`users`.`id`))) left join `script` on((`job`.`script_id` = `script`.`id`))) order by `job`.`id` desc;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `non_9_job` AS select `job`.`id` AS `id`,`job`.`state` AS `state`,`ct_auth`.`users`.`name` AS `user`,`job`.`label` AS `label`,`job`.`created_at` AS `created_at`,`job`.`updated_at` AS `updated_at`,`job`.`context` AS `context`,`job`.`result_path` AS `result_path` from (`job` join `ct_auth`.`users`) where ((`job`.`user_id` = `ct_auth`.`users`.`id`) and (`job`.`state` < 9)) order by `job`.`id` desc;
