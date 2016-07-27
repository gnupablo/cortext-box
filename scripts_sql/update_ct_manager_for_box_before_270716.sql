/* A jouer sur toutes la BDD ct_manager de toutes les box installées avant le 27 juillet 2016, après c'est intégré dans les scripts de création */

DROP VIEW `restart_queued_job`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `restart_queued_job` AS select `job`.`id` AS `id`,`job`.`state` AS `state`,`ct_auth`.`users`.`name` AS `user`,`job`.`label` AS `label`,`job`.`created_at` AS `created_at`,timediff(now(),`job`.`created_at`) AS `since_creation`,`job`.`updated_at` AS `updated_at`,timediff(now(),`job`.`updated_at`) AS `since_last_update` from (`job` join `ct_auth`.`users`) where ((`job`.`user_id` = `ct_auth`.`users`.`id`) and (`job`.`state` > 1) and (`job`.`state` < 4)) order by `job`.`created_at` desc;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `running_job` AS select `job`.`id` AS `id`,`job`.`state` AS `state`,`ct_auth`.`users`.`name` AS `user`,`job`.`label` AS `label`,`job`.`created_at` AS `created_at`,timediff(now(),`job`.`created_at`) AS `since_creation`,`job`.`updated_at` AS `updated_at`,timediff(now(),`job`.`updated_at`) AS `since_last_update` from (`job` join `ct_auth`.`users`) where ((`job`.`user_id` = `ct_auth`.`users`.`id`) and (`job`.`state` = 4)) order by `job`.`created_at` desc;
