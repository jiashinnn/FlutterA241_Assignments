-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 27, 2024 at 11:47 AM
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
-- Table structure for table `tbl_news`
--

CREATE TABLE `tbl_news` (
  `news_id` int(3) NOT NULL,
  `news_title` varchar(300) NOT NULL,
  `news_details` varchar(1000) NOT NULL,
  `news_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `news_likes` int(3) NOT NULL,
  `news_saves` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_news`
--

INSERT INTO `tbl_news` (`news_id`, `news_title`, `news_details`, `news_date`, `news_likes`, `news_saves`) VALUES
(1, 'Welcome to Our Community!', 'We are excited to have you as part of our growing family! As a new member, you get access to exclusive events, early updates, and personalized recommendations. Stay tuned for all the amazing things we have in store for you!', '2024-11-25 14:59:40.935597', 55, 1),
(2, 'Upcoming Event: Networking Brunch', 'Join us for an exclusive networking brunch this Saturday at Green Valley Clubhouse. Connect with fellow members and industry experts while enjoying great food and company. Spots are limited, so make sure to RSVP today!', '2024-11-25 16:00:03.256193', 15, 2),
(3, 'Member Spotlight: Achievements of the Month', 'Congratulations to our star members of the month! This month, we celebrate Alex Johnson for outstanding contributions in community volunteering and Maria Fernandez for her entrepreneurial achievements. Keep up the fantastic work!', '2024-11-25 16:00:25.998411', 1, 0),
(4, 'Exclusive Member Discounts: This Week\'s Deals', 'We are excited to announce some exclusive deals for our members! Get 15% off all products at our partner store \'FitLife\' and enjoy 10% off your next spa visit. Log in to your member dashboard to get your discount codes now!', '2024-11-25 16:00:46.784414', 2, 1),
(5, 'Join Our New Wellness Workshop', 'Our popular wellness workshop series is back! Join us on the 10th of December for a session on \'Mindfulness & Stress Relief\', led by an expert wellness coach. Don’t miss this opportunity to relax and learn valuable techniques for well-being.', '2024-11-25 16:01:06.366380', 2, 1),
(6, 'Volunteer Opportunities: Make a Difference', 'Looking for ways to give back to the community? We have some exciting volunteer opportunities lined up this month. From environmental clean-ups to helping local shelters, there are many ways you can make an impact. Sign up through the member portal!', '2024-11-25 16:01:26.112417', 0, 0),
(7, 'Member Appreciation Day – A Special Thank You', 'We’re dedicating a whole day to thank our amazing members! Come celebrate with us at our headquarters for free goodies, raffle prizes, and exclusive workshops. Your support is what makes our community thrive!', '2024-11-25 16:02:31.329773', 1, 0),
(8, 'Monthly Fitness Challenge – Win Rewards!', 'Are you ready to take your fitness journey to the next level? Participate in our monthly fitness challenge and stand a chance to win exciting rewards! Complete the challenge goals and earn points that you can redeem for exclusive prizes.', '2024-11-25 16:09:38.820386', 1, 0),
(9, 'New Features Alert – Check Out What\'s New', 'We’ve added new features to enhance your experience! You can now easily track your event registrations, interact with other members in community discussions, and earn badges for active participation. Check out these exciting features today!', '2024-11-25 16:09:57.746866', 1, 1),
(10, 'Upcoming Webinar: Financial Planning Tips', 'Join us on Wednesday for an insightful webinar on \'Financial Planning for a Secure Future\'. Our guest speaker, financial expert Sarah Peterson, will cover budgeting tips, saving strategies, and investment basics to help you secure your future.', '2024-11-25 16:10:17.861526', 1, 1),
(12, 'Refer a Friend and Earn Rewards', 'Invite your friends to join our community and earn referral bonuses! For every successful referral, you get a $20 voucher that you can use for our upcoming events or member services. Let\'s grow our community together!', '2024-11-25 17:16:45.964089', 0, 0),
(13, 'Member Survey – Share Your Thoughts!', 'We value your feedback! Please take a few minutes to complete our member survey and let us know how we can improve your experience. All participants will be entered into a draw to win a free month of membership!', '2024-11-25 17:17:10.459355', 0, 0),
(14, 'Exclusive Pre-Launch Product for Members', 'We’re launching a brand-new line of products, and as a valued member, you get early access! Check out our pre-launch event next week, and be among the first to explore these new offerings. Pre-orders are available for members only.', '2024-11-25 17:17:35.258575', 0, 0),
(15, 'Safety Guidelines for Upcoming Events', 'Your safety is our top priority. For all upcoming in-person events, please remember to follow the safety guidelines, including mask-wearing and social distancing. We are committed to providing a safe environment for all our members.', '2024-11-25 17:17:59.210587', 1, 1),
(16, 'Thank You for Attending Our Charity Gala!', 'We want to thank everyone who attended our charity gala last week. It was a huge success, and we raised over $10,000 for our local children\'s hospital. Your participation truly made a difference!', '2024-11-25 17:18:24.092906', 3, 0),
(17, 'Winter Sale Extravaganza!', 'Get ready for amazing discounts this winter! Exclusive deals available for members only. Don\'t miss out!', '2024-11-25 19:06:24.195320', 3, 0),
(18, 'Member Referral Program', 'Invite your friends to join and earn rewards! Enjoy special bonuses for every successful referral.', '2024-11-25 19:06:48.537971', 0, 0),
(19, 'Upcoming Webinar: Financial Planning Tips', 'Join us on Thursday for an insightful webinar on \'Effective Financial Planning for the Future\'. Register now!', '2024-11-25 19:07:14.487083', 3, 0),
(20, 'Introducing Our New Loyalty Program', 'We’re excited to announce our new loyalty program. Earn points with every purchase and redeem for exclusive rewards.', '2024-11-25 19:07:38.642793', 4, 0),
(21, 'Exclusive Event: Summer Fitness Challenge', 'Participate in our summer fitness challenge! Get personalized coaching and track your progress with other members.', '2024-11-25 19:07:59.565178', 0, 0),
(22, 'Your Account Summary', 'Check out your latest account summary and make the most out of your membership benefits. Log in for details.', '2024-11-25 19:08:25.776426', 2, 0),
(23, 'Special Announcement: New Mobile App!', 'We\'re thrilled to announce our new mobile app for seamless access to all your membership benefits.', '2024-11-25 19:08:54.446709', 2, 0),
(24, 'New Workshops Available', 'We’ve added new workshops to enhance your skills and knowledge. Check out our event calendar now!', '2024-11-25 19:09:13.941711', 4, 1),
(25, 'Member Spotlight: Jane Doe’s Success Story', 'Learn how Jane used her membership to achieve her health and wellness goals. Get inspired today!', '2024-11-25 19:09:33.774695', 0, 0),
(26, 'Early Bird Tickets Available!', 'Book your tickets for our upcoming networking event at a discounted rate. Limited seats available!', '2024-11-25 19:10:15.312119', 9, 1),
(27, 'Reminder: Renew Your Membership Today', 'Renew your membership now to continue enjoying all the benefits and perks. We’re excited to have you with us!', '2024-11-25 19:10:55.503088', 20, 6),
(29, 'Fitness Masterclass with Top Trainers', 'Join our masterclass with expert trainers to take your fitness journey to the next level.', '2024-11-25 19:11:35.395749', 4, 1),
(30, 'New Feature Alert: Enhanced User Dashboard', 'Experience our updated user dashboard with better navigation and more features to simplify your experience.', '2024-11-25 19:11:57.592123', 0, 0),
(31, 'Tips for Boosting Productivity', 'Check out our top tips for boosting productivity and achieving your goals faster.', '2024-11-25 19:12:19.255017', 0, 0),
(32, 'Monthly Member Meetup', 'Connect with other members during our monthly meetup. Network, socialize, and grow your connections. Hope to see you soon!!!', '2024-11-25 19:12:55.573377', 2, 0),
(33, 'Exclusive Offers for Platinum Members', 'Enjoy exclusive discounts on products and services as part of our Platinum Member benefits.', '2024-11-25 19:13:20.708686', 5, 0),
(34, 'Career Development Workshops', 'Advance your career with our upcoming workshops covering topics from leadership to effective communication', '2024-11-25 19:13:41.229502', 6, 2),
(35, 'Holiday Hours Announcement', 'Please note our adjusted hours of operation during the holidays. Happy holidays!', '2024-11-25 19:14:02.487203', 9, 1),
(36, 'Special Charity Event: Join Us!', 'Join us for a special charity event to make a positive impact. Let’s give back together!', '2024-11-25 19:14:32.936833', 10, 2),
(37, 'Your Membership Benefits at a Glance', 'Get a quick overview of your exclusive member benefits. Make sure you are getting the most out of your membership.', '2024-11-25 19:14:53.218216', 1, 0),
(38, 'New Blog Post: Staying Healthy During Winter', 'Learn top tips for staying active and healthy during the colder months. Read the blog now!', '2024-11-25 19:15:25.628019', 6, 1),
(40, 'Health & Wellness Survey', 'We value your input! Participate in our wellness survey and help us provide better services for you.', '2024-11-25 19:16:08.120460', 0, 0),
(44, 'Upcoming Networking Event: Connect with the Best', 'Join us at our upcoming networking event, tailored specifically for professionals looking to expand their network. This virtual event will feature leaders in various industries, breakout sessions for focused discussions, and opportunities for one-on-one virtual meet-ups. Don\'t miss your chance to make valuable connections that can help you grow.', '2024-11-26 13:59:48.256752', 1, 0),
(45, 'Learn from Experts: Marketing Trends in 2024', 'Marketing is constantly evolving, and to help you stay ahead, we are hosting a webinar on \'Marketing Trends in 2024.\' You\'ll learn about emerging trends, effective strategies, and tools to help you enhance your campaigns. Featuring experts in digital marketing, this is a session you don\'t want to miss. Secure your spot today and be ready for the future of marketing.See you', '2024-11-26 15:10:18.752888', 1, 0),
(46, 'Masterclass: Public Speaking for Professionals', 'Public speaking is a crucial skill for any professional. Join our upcoming masterclass, where experienced speakers will share techniques to help you overcome anxiety, structure a powerful presentation, and connect with your audience. Participants will also have the opportunity to practice in front of peers and receive personalized feedback. Limited spots available, register soon! Thank you!', '2024-11-26 15:31:29.096633', 111, 49),
(47, 'Refer a Friend and Earn Membership Rewards!', 'Invite your friends to join our community and earn rewards for each successful referral. It\'s easy to share the benefits of membership, and now you get rewarded too! Each friend you refer who signs up gets an exclusive welcome gift, and you earn points towards discounts, exclusive events, and more. Start referring today!', '2024-11-27 00:42:25.346078', 43, 21),
(49, 'Announcing New Member Discounts with Partners!', 'We\'re proud to announce new partnerships that will bring you exclusive discounts on a wide range of products and services. From travel deals to tech gadgets, as a valued member, you\'ll have access to the best offers. Visit our Member Deals page to see the latest discounts available and start saving today!', '2024-11-27 18:45:27.518895', 0, 0);

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
(4, 'ooi', 'xin rhu', 'oxr11@gmail.com', '011-38180136', 'f41af406e358a1a27aad828073dcd14cd2c4c175', 'f41af406e358a1a27aad828073dcd14cd2c4c175', '2024-11-06 16:04:04'),
(5, 'Pooh', 'Winne', 'pooh@gmail.com', '016-9274946', '14532522850758307ce366ac8c3f562dbe2bdbe6', '14532522850758307ce366ac8c3f562dbe2bdbe6', '2024-11-06 17:32:45'),
(6, 'soochyi lenglui', 'cheng', 'lenglui123@gmail.com', '123-4567890', 'eec0798bdb12eeb92bc94b27b319443babee393d', 'eec0798bdb12eeb92bc94b27b319443babee393d', '2024-11-06 19:46:46'),
(7, 'Yuqi', 'Song', 'yuqisong@gmail.com', '012-123456789', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-11-06 20:40:44'),
(8, 'Gigi', 'Song', 'gigisong@gmail.com', '012-123456789', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-11-06 21:09:22'),
(9, 'Jia Shin', 'Lim', 'jiashin0604@gmail.com', '012-123456789', 'b67be151d18a7b42823a7adad386634a334c036d', 'b67be151d18a7b42823a7adad386634a334c036d', '2024-11-08 17:55:21'),
(10, 'jiashin', 'lim', 'limjiashin0604@gmail.com', '011-123456789', 'd9a7b43d50ac7e36de03e0336b56a223a640aa8b', 'd9a7b43d50ac7e36de03e0336b56a223a640aa8b', '2024-11-09 21:43:01'),
(11, 'jasmine', 'lim', 'jasminelim@gmail.com', '011-123456789', 'd9a7b43d50ac7e36de03e0336b56a223a640aa8b', 'd9a7b43d50ac7e36de03e0336b56a223a640aa8b', '2024-11-10 11:05:58'),
(12, 'jiayee', 'lim', 'jiayeelim@gmail.com', '012-72099998', 'ff46b391c0804af3cf60733f8ff8634ec33f25ff', 'ff46b391c0804af3cf60733f8ff8634ec33f25ff', '2024-11-10 17:14:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_news`
--
ALTER TABLE `tbl_news`
  ADD PRIMARY KEY (`news_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_news`
--
ALTER TABLE `tbl_news`
  MODIFY `news_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
