-- phpMyAdmin SQL Dump
-- version 4.1.4
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 09-Ago-2016 às 21:17
-- Versão do servidor: 5.6.15-log
-- PHP Version: 5.5.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `kimera`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `letter`
--

CREATE TABLE IF NOT EXISTS `letter` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `permission` int(11) NOT NULL DEFAULT '0',
  `title` varchar(200) NOT NULL,
  `letter` text NOT NULL,
  `date_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Extraindo dados da tabela `letter`
--

INSERT INTO `letter` (`id`, `user_id`, `permission`, `title`, `letter`, `date_time`) VALUES
(1, 1, 0, 'Carta do Jason', 'Esta Ã© a carta do Jason!', '2016-08-08 19:26:46'),
(2, 2, 1, 'Carta do AndrÃ©', 'Exemplo de carta p/ todos!', '2016-08-08 19:28:00'),
(3, 3, 0, 'Carta do Iury', 'Teste da carta sÃ³ do Iury!', '2016-08-08 19:30:08');

-- --------------------------------------------------------

--
-- Estrutura da tabela `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `permission` int(10) NOT NULL DEFAULT '0',
  `email` varchar(200) NOT NULL,
  `password` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Extraindo dados da tabela `user`
--

INSERT INTO `user` (`id`, `permission`, `email`, `password`) VALUES
(1, 0, 'contato@jasonpiloti.com', '123'),
(2, 1, 'andre.luiz.rezende@gmail.com', '123'),
(3, 0, 'iurybarreto@gmail.com', '123');

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `letter`
--
ALTER TABLE `letter`
  ADD CONSTRAINT `letter_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
