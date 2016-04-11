-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u1
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Lun 11 Avril 2016 à 19:17
-- Version du serveur :  5.5.47-0+deb8u1
-- Version de PHP :  5.6.19-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `ct_manager`
--

--
-- Contenu de la table `job`
--

INSERT INTO `job` (`id`, `label`, `script_path`, `result_path`, `log_path`, `upload_path`, `state`, `user_id`, `script_id`, `corpu_id`, `created_at`, `updated_at`, `document_path`, `context`) VALUES
(1, 'Data Parser->dummy-algues-vertes.zip-1460391758977', '/vagrant/cortext-methods/parser_science/parser_science_se.py', '/vagrant/cortext-assets/server/app/../documents/5023/502331dcaaa17f723528e6e7c909d8af/1', '', '', 9, 2, 8, 0, '2016-04-11 19:00:13', '2016-04-11 19:00:34', '/vagrant/cortext-assets/server/app/../documents/e1b3/e1b3494529c420961fe785e09f8778bf/dummy-algues-vertes.zip', '{"project_id":"1","analysis_id":2,"callback_json":"http:\\/\\/10.10.10.10:3000\\/api\\/project\\/1\\/analysis\\/2","username":"root@cortext.dev"}'),
(2, 'Data Parser->dummy-ecoserv-scopus.zip-1460394253560', '/vagrant/cortext-methods/parser_science/parser_science_se.py', '/vagrant/cortext-assets/server/app/../documents/a812/a812b46d6781d61496899b8a0f0bc345/2', '', '', 9, 2, 8, 9223372036854775807, '2016-04-11 19:04:57', '2016-04-11 19:05:14', '/vagrant/cortext-assets/server/app/../documents/73e6/73e67cd0d2a3aed251bdab0185fd6fc2/dummy-ecoserv-scopus.zip', '{"project_id":"2","analysis_id":4,"callback_json":"http:\\/\\/10.10.10.10:3000\\/api\\/project\\/2\\/analysis\\/4","username":"root@cortext.dev"}');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
