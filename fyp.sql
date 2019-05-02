-- phpMyAdmin SQL Dump
-- version 4.6.6
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 03, 2019 at 12:07 AM
-- Server version: 10.3.7-MariaDB
-- PHP Version: 5.6.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fyp`
--

-- --------------------------------------------------------

--
-- Table structure for table `certificate`
--

CREATE TABLE `certificate` (
  `certid` int(8) NOT NULL COMMENT 'Unique certificate ID in the database',
  `proof_hash` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'The merkle root or simple hash of the data recorded on the Blockchain',
  `proof_type` varchar(16) COLLATE utf8_unicode_ci NOT NULL COMMENT 'The type of proof presented, 01 Simple File, 02 Simple data, 10 Merkle',
  `proof_txid` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'The transaction id which records the proof',
  `proof_chain` varchar(16) COLLATE utf8_unicode_ci NOT NULL COMMENT 'The blockchain which txid belongs to',
  `issuance_date` date NOT NULL COMMENT 'The issuance date of cert or transaction time on blockchain',
  `recepient_id` int(8) NOT NULL COMMENT 'users:id which owns the certificate',
  `issuer_id` int(8) NOT NULL COMMENT 'institution:id which issues the certificate',
  `proof_file_hash` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'For 01,10, the SHA256 hash of the file',
  `proof_file_path` varchar(256) COLLATE utf8_unicode_ci NOT NULL COMMENT 'For 01,10, the location of the certified document is stored',
  `proof_data_hash` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'For 02, 10, the hash of the simple data or metadata',
  `proof_data` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'For 02,10, the data provieded for proof',
  `proof_file_permission` int(2) DEFAULT NULL COMMENT 'For 01,10, the permission for us to share data to other users',
  `proof_data_permission` int(2) NOT NULL COMMENT 'For 02,10, the permission for us to share data to other users',
  `proof_level` int(4) NOT NULL COMMENT 'Indication of check failure. 1: mismatched proof, 2 issuer no pubkey, 3 issuer pubkey not in tx, 4 receiver pubkey not in tx, 5 only hash for merkle provided'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chatroom`
--

CREATE TABLE `chatroom` (
  `id` int(16) NOT NULL COMMENT 'Unique chat id',
  `sender` int(16) NOT NULL COMMENT 'users:id Sender of the chat',
  `receiver` int(16) NOT NULL COMMENT 'users:id Receiver of the chat',
  `message` text NOT NULL COMMENT 'content of the chat',
  `time` datetime NOT NULL COMMENT 'When the chat is posted'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `education`
--

CREATE TABLE `education` (
  `id` int(8) NOT NULL COMMENT 'unique education/qualification id',
  `uid` int(8) NOT NULL COMMENT 'user who has the qualification',
  `issuer_id` int(8) NOT NULL COMMENT 'institution:id who issue the qualification',
  `title` varchar(128) NOT NULL COMMENT 'title of the qualification',
  `class` varchar(128) NOT NULL COMMENT 'tier of the qualification',
  `issuance_date` date NOT NULL COMMENT 'when the qualification is issued',
  `send_time` datetime NOT NULL COMMENT 'when the qualification is registed on the platform',
  `certid` int(8) NOT NULL DEFAULT 0 COMMENT 'certificate:id proof which belongs to the qualification',
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `institution`
--

CREATE TABLE `institution` (
  `id` int(16) NOT NULL COMMENT 'unique institution page id',
  `pubkey` varchar(256) NOT NULL,
  `chain` varchar(16) NOT NULL,
  `name` varchar(128) NOT NULL COMMENT 'name of institution',
  `description` text NOT NULL COMMENT 'description of institution',
  `reg_date` date NOT NULL COMMENT 'registration date of page',
  `bind_uid` int(8) NOT NULL DEFAULT 0 COMMENT 'the users:id which has permission to change page content',
  `type` varchar(32) NOT NULL COMMENT 'the textual group type of the institution',
  `website` varchar(1024) NOT NULL DEFAULT '' COMMENT 'official website of institution',
  `profile_img` varchar(256) DEFAULT '',
  `cover_img` varchar(256) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `id` int(12) NOT NULL COMMENT 'Unique post id',
  `uid` int(8) NOT NULL COMMENT 'users:id of user who post the content',
  `content` text NOT NULL COMMENT 'Content of the post',
  `send_time` datetime NOT NULL COMMENT 'When the post is created',
  `parent_post` int(12) NOT NULL COMMENT 'If the post is a reply or comment to a post, this will be post:id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pubkey`
--

CREATE TABLE `pubkey` (
  `key_id` int(16) NOT NULL,
  `pubkey` varchar(128) NOT NULL,
  `chain` varchar(32) NOT NULL COMMENT 'the blockchain of pubkey',
  `id` int(8) NOT NULL COMMENT 'key owner',
  `id_type` int(11) NOT NULL COMMENT '0:User,1:Institution',
  `signature` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `relationship`
--

CREATE TABLE `relationship` (
  `id` int(16) NOT NULL COMMENT 'ID of relationship',
  `source` int(8) NOT NULL COMMENT 'Initiator of relationship',
  `target` int(8) NOT NULL COMMENT 'Target of relationship',
  `status` varchar(16) NOT NULL COMMENT 'Status of relationship',
  `time` datetime NOT NULL COMMENT 'The last updated time of relationship'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(8) NOT NULL COMMENT 'Auto generated userid',
  `username` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT 'unique username user select',
  `first_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL COMMENT 'personal information of user first name',
  `last_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL COMMENT 'personal information of user last name',
  `dob` date NOT NULL COMMENT 'personal information of user date of birth',
  `email` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'personal information of user email',
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL COMMENT 'sha256 hashed password',
  `tag_line` varchar(128) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'tagline that shows on user homepage',
  `current_job` varchar(64) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'current occupation that shows on user homepage',
  `current_job_title` varchar(32) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'title of current occupation that shows on user homepage',
  `current_edu` varchar(64) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'current educational status of user',
  `current_edu_title` varchar(32) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'the qualification of user',
  `reg_date` date NOT NULL DEFAULT current_timestamp() COMMENT 'user registration date',
  `is_institution` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'if this user is a institution page manager,1. If user is retail user, 0',
  `cover_img` varchar(512) COLLATE utf8_unicode_ci DEFAULT '',
  `profile_img` varchar(512) COLLATE utf8_unicode_ci DEFAULT '',
  `privacy` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `certificate`
--
ALTER TABLE `certificate`
  ADD PRIMARY KEY (`certid`),
  ADD KEY `recepient_id` (`recepient_id`),
  ADD KEY `issuer_id` (`issuer_id`);

--
-- Indexes for table `chatroom`
--
ALTER TABLE `chatroom`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender` (`sender`),
  ADD KEY `receiver` (`receiver`);

--
-- Indexes for table `education`
--
ALTER TABLE `education`
  ADD PRIMARY KEY (`id`),
  ADD KEY `certid` (`certid`),
  ADD KEY `issuer_id` (`issuer_id`);

--
-- Indexes for table `institution`
--
ALTER TABLE `institution`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bind_uid` (`bind_uid`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uid` (`uid`);

--
-- Indexes for table `pubkey`
--
ALTER TABLE `pubkey`
  ADD PRIMARY KEY (`key_id`);

--
-- Indexes for table `relationship`
--
ALTER TABLE `relationship`
  ADD PRIMARY KEY (`id`),
  ADD KEY `source` (`source`),
  ADD KEY `target` (`target`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `certificate`
--
ALTER TABLE `certificate`
  MODIFY `certid` int(8) NOT NULL AUTO_INCREMENT COMMENT 'Unique certificate ID in the database', AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `chatroom`
--
ALTER TABLE `chatroom`
  MODIFY `id` int(16) NOT NULL AUTO_INCREMENT COMMENT 'Unique chat id', AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `education`
--
ALTER TABLE `education`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT COMMENT 'unique education/qualification id', AUTO_INCREMENT=37;
--
-- AUTO_INCREMENT for table `institution`
--
ALTER TABLE `institution`
  MODIFY `id` int(16) NOT NULL AUTO_INCREMENT COMMENT 'unique institution page id', AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `post`
--
ALTER TABLE `post`
  MODIFY `id` int(12) NOT NULL AUTO_INCREMENT COMMENT 'Unique post id', AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT for table `pubkey`
--
ALTER TABLE `pubkey`
  MODIFY `key_id` int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `relationship`
--
ALTER TABLE `relationship`
  MODIFY `id` int(16) NOT NULL AUTO_INCREMENT COMMENT 'ID of relationship', AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT COMMENT 'Auto generated userid', AUTO_INCREMENT=23;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
