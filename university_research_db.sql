-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 21, 2025 at 12:42 PM
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
-- Database: `university_research_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDeliverableByStatus` (IN `tempStatus` ENUM('Completed','Pending','In Progress','Canceled'))   BEGIN
	SELECT *
    FROM project_deliverable
    WHERE project_deliverable.status LIKE tempStatus;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetFundingForProject` (IN `tempProjectID` INT, OUT `ConcatenatedOrgs` VARCHAR(255))   BEGIN
	SELECT GROUP_CONCAT(funding_sources.organisation,", ") INTO ConcatenatedOrgs
    FROM funding_sources
    INNER JOIN projects ON projects.project_id = funding_sources.project_id
    WHERE projects.project_id = tempProjectID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetResearchersWorkingOnProject` (IN `tempProjectID` INT)   BEGIN
SELECT researcher.*
FROM researcher INNER JOIN project_researchers ON project_researchers.researcher_id=researcher.researcher_id
INNER JOIN projects ON project_researchers.project_id = projects.project_id
WHERE projects.project_id = tempProjectID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `director`
--

CREATE TABLE `director` (
  `director_id` int(11) NOT NULL,
  `researcher_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `director`
--

INSERT INTO `director` (`director_id`, `researcher_id`) VALUES
(3, 1),
(1, 3),
(2, 6),
(4, 7);

--
-- Triggers `director`
--
DELIMITER $$
CREATE TRIGGER `add_researcher_for_director` BEFORE INSERT ON `director` FOR EACH ROW BEGIN
	INSERT INTO researcher (researcher.role, researcher.full_name) VALUES ('director', null);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `start_project_on_funding` AFTER INSERT ON `director` FOR EACH ROW BEGIN
	UPDATE researcher
    SET role = "director"
    WHERE researcher.researcher_id = NEW.researcher_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `funding_sources`
--

CREATE TABLE `funding_sources` (
  `funding_source_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `organisation` varchar(255) NOT NULL,
  `category` enum('Equipment','Travel','Salaries') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `funding_sources`
--

INSERT INTO `funding_sources` (`funding_source_id`, `project_id`, `organisation`, `category`) VALUES
(1, 1, 'ANC', 'Travel'),
(2, 1, 'ANC', 'Salaries'),
(3, 2, 'KZN', 'Equipment'),
(4, 2, 'ANC', 'Salaries'),
(5, 3, 'Yi Long Ma', 'Salaries'),
(6, 3, 'Oracle', 'Travel'),
(7, 4, 'Arsenal', 'Equipment'),
(8, 4, 'Open Window', 'Travel'),
(9, 5, 'Tsungai Org', 'Equipment'),
(10, 6, 'Tsungai Org', 'Equipment'),
(11, 6, 'Google', 'Travel');

--
-- Triggers `funding_sources`
--
DELIMITER $$
CREATE TRIGGER `halt_project` BEFORE DELETE ON `funding_sources` FOR EACH ROW BEGIN
	UPDATE project_deliverable
    SET project_deliverable.status = "pending"
    WHERE project_deliverable.project_id=OLD.project_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `lab`
--

CREATE TABLE `lab` (
  `lab_id` int(11) NOT NULL,
  `research_area` enum('renewable_energy','biotechnology','artificial_intelligence') NOT NULL,
  `director_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lab`
--

INSERT INTO `lab` (`lab_id`, `research_area`, `director_id`) VALUES
(1, 'renewable_energy', 1),
(2, 'biotechnology', 1),
(3, 'artificial_intelligence', 2),
(4, 'biotechnology', 2);

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `project_id` int(11) NOT NULL,
  `lab_id` int(11) NOT NULL,
  `project_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`project_id`, `lab_id`, `project_name`) VALUES
(1, 1, 'Sun Death Laser'),
(2, 2, 'Micro Mozzies'),
(3, 2, 'Jurassic Park'),
(4, 3, 'T800'),
(5, 3, 'DV200'),
(6, 4, 'ManUnited But Good');

-- --------------------------------------------------------

--
-- Table structure for table `project_deliverable`
--

CREATE TABLE `project_deliverable` (
  `deliverable_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('Completed','In Progress','Pending','Canceled') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project_deliverable`
--

INSERT INTO `project_deliverable` (`deliverable_id`, `project_id`, `due_date`, `status`) VALUES
(1, 1, '2026-08-21', 'In Progress'),
(2, 2, '2024-08-21', 'Canceled'),
(3, 6, '2026-08-21', 'Pending'),
(4, 3, '2025-08-22', 'Completed'),
(5, 4, '2077-08-22', 'Pending'),
(6, 5, '2025-08-21', 'In Progress'),
(7, 2, '2026-08-21', 'In Progress');

-- --------------------------------------------------------

--
-- Table structure for table `project_researchers`
--

CREATE TABLE `project_researchers` (
  `project_researcher_id` int(11) NOT NULL,
  `researcher_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project_researchers`
--

INSERT INTO `project_researchers` (`project_researcher_id`, `researcher_id`, `project_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(7, 1, 3),
(8, 2, 1),
(9, 2, 4),
(10, 4, 3),
(11, 5, 2),
(12, 5, 6),
(13, 6, 6);

-- --------------------------------------------------------

--
-- Table structure for table `researcher`
--

CREATE TABLE `researcher` (
  `researcher_id` int(11) NOT NULL,
  `role` enum('researcher','director','student','postdoctorate') NOT NULL,
  `full_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `researcher`
--

INSERT INTO `researcher` (`researcher_id`, `role`, `full_name`) VALUES
(1, 'director', 'David Jones'),
(2, 'researcher', 'Jeff Joff'),
(3, 'director', 'Kai Koi'),
(4, 'student', 'Tsungai Manu'),
(5, 'postdoctorate', 'Jeff Bozes'),
(6, 'director', 'David Gold'),
(7, 'director', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `director`
--
ALTER TABLE `director`
  ADD PRIMARY KEY (`director_id`),
  ADD KEY `researcher_id` (`researcher_id`);

--
-- Indexes for table `funding_sources`
--
ALTER TABLE `funding_sources`
  ADD PRIMARY KEY (`funding_source_id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `lab`
--
ALTER TABLE `lab`
  ADD PRIMARY KEY (`lab_id`),
  ADD KEY `director_id` (`director_id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`project_id`),
  ADD KEY `lab_id` (`lab_id`);

--
-- Indexes for table `project_deliverable`
--
ALTER TABLE `project_deliverable`
  ADD PRIMARY KEY (`deliverable_id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `project_researchers`
--
ALTER TABLE `project_researchers`
  ADD PRIMARY KEY (`project_researcher_id`),
  ADD KEY `researcher_id` (`researcher_id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `researcher`
--
ALTER TABLE `researcher`
  ADD PRIMARY KEY (`researcher_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `director`
--
ALTER TABLE `director`
  MODIFY `director_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `funding_sources`
--
ALTER TABLE `funding_sources`
  MODIFY `funding_source_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `lab`
--
ALTER TABLE `lab`
  MODIFY `lab_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `project_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `project_deliverable`
--
ALTER TABLE `project_deliverable`
  MODIFY `deliverable_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `project_researchers`
--
ALTER TABLE `project_researchers`
  MODIFY `project_researcher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `researcher`
--
ALTER TABLE `researcher`
  MODIFY `researcher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `director`
--
ALTER TABLE `director`
  ADD CONSTRAINT `director_ibfk_1` FOREIGN KEY (`researcher_id`) REFERENCES `researcher` (`researcher_id`);

--
-- Constraints for table `funding_sources`
--
ALTER TABLE `funding_sources`
  ADD CONSTRAINT `funding_sources_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`);

--
-- Constraints for table `lab`
--
ALTER TABLE `lab`
  ADD CONSTRAINT `lab_ibfk_1` FOREIGN KEY (`director_id`) REFERENCES `director` (`director_id`);

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`lab_id`) REFERENCES `lab` (`lab_id`);

--
-- Constraints for table `project_deliverable`
--
ALTER TABLE `project_deliverable`
  ADD CONSTRAINT `project_deliverable_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`);

--
-- Constraints for table `project_researchers`
--
ALTER TABLE `project_researchers`
  ADD CONSTRAINT `project_researchers_ibfk_1` FOREIGN KEY (`researcher_id`) REFERENCES `researcher` (`researcher_id`),
  ADD CONSTRAINT `project_researchers_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
