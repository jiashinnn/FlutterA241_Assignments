-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 09, 2024 at 02:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `membership_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(3) NOT NULL,
  `user_firstName` varchar(50) NOT NULL,
  `user_lastName` varchar(50) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_phone` varchar(40) NOT NULL,
  `user_pass` varchar(40) NOT NULL,
  `user_cPass` varchar(40) NOT NULL,
  `user_dateRegister` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_firstName`, `user_lastName`, `user_email`, `user_phone`, `user_pass`, `user_cPass`, `user_dateRegister`) VALUES
(1, 'Aurora', 'Lim', 'aurora@gmail.com', '011-123456789', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-11-06 15:43:57'),
(2, 'Jia Shin', 'Lim', 'jiashinlim@gmail.com', '012-34567890', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-11-06 15:49:13'),
(3, 'Abby', 'Goh', 'abbygoh@gmail.com', '012-34567890', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-11-06 15:58:53'),
(4, 'ooi', 'xin rhu', 'oxr11@gmail.com', '01138180136', 'f41af406e358a1a27aad828073dcd14cd2c4c175', 'f41af406e358a1a27aad828073dcd14cd2c4c175', '2024-11-06 16:04:04'),
(5, 'Pooh', 'Winne', 'pooh@gmail.com', '0169274946', '14532522850758307ce366ac8c3f562dbe2bdbe6', '14532522850758307ce366ac8c3f562dbe2bdbe6', '2024-11-06 17:32:45'),
(6, 'soochyi lenglui', 'cheng', 'lenglui123@gmail.com', '1234567890', 'eec0798bdb12eeb92bc94b27b319443babee393d', 'eec0798bdb12eeb92bc94b27b319443babee393d', '2024-11-06 19:46:46'),
(7, 'Yuqi', 'Song', 'yuqisong@gmail.com', '012-123456789', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-11-06 20:40:44'),
(8, 'Gigi', 'Song', 'gigisong@gmail.com', '012-123456789', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-11-06 21:09:22'),
(9, 'Jia Shin', 'Lim', 'jiashin0604@gmail.com', '012-123456789', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '2024-11-08 17:55:21');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
