-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 16, 2025 at 03:23 PM
-- Server version: 10.3.39-MariaDB-cll-lve
-- PHP Version: 8.1.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `threenqs_membership_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_cart`
--

CREATE TABLE `tbl_cart` (
  `cart_id` int(4) NOT NULL,
  `product_id` int(4) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `product_filename` varchar(100) NOT NULL,
  `quantity` int(4) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `cart_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_cart`
--

INSERT INTO `tbl_cart` (`cart_id`, `product_id`, `product_name`, `product_filename`, `quantity`, `price`, `total_price`, `cart_date`) VALUES
(13, 11, 'My Sweet Lord T-shirt', 'product-11.png', 4, 35.00, 140.00, '2024-12-12 16:41:12'),
(14, 1, 'Black Hand T-shirt', 'product-1.png', 1, 35.00, 35.00, '2024-12-12 16:52:17'),
(15, 5, 'Nimrod Soft Feel Stylus Ballpen', 'product-5.png', 1, 3.30, 3.30, '2024-12-28 09:50:00'),
(16, 9, 'Chair White T-shirt', 'product-9.png', 1, 17.50, 17.50, '2025-01-16 11:46:58');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_memberships`
--

CREATE TABLE `tbl_memberships` (
  `membership_id` int(6) NOT NULL,
  `membership_name` varchar(100) NOT NULL,
  `membership_description` text NOT NULL,
  `membership_price` decimal(10,2) NOT NULL,
  `membership_benefits` text NOT NULL,
  `membership_duration` varchar(50) NOT NULL,
  `membership_terms` text NOT NULL,
  `membership_filename` varchar(30) NOT NULL,
  `membership_dateCreated` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_memberships`
--

INSERT INTO `tbl_memberships` (`membership_id`, `membership_name`, `membership_description`, `membership_price`, `membership_benefits`, `membership_duration`, `membership_terms`, `membership_filename`, `membership_dateCreated`) VALUES
(1, 'Basic Membership', 'This plan includes access to standard features such as newsletters, forums, and community support.', 50.00, 'Access to standard features and tools. Community support for troubleshooting. Discounts on selected services. Monthly newsletters with tips and updates. Access to exclusive member forums.', '1 Year', 'Membership is valid for one year. No refunds for early cancellation. Benefits may change without prior notice. Usage restricted to individual purposes only. Renewal required to retain benefits.', 'membership_basic.png', '2025-01-09 06:49:13'),
(2, 'Premium Membership', 'Unlock premium benefits with priority access to events, resources, and enhanced tools.', 100.00, 'Priority access to all new features. Free entry to premium events and webinars. Higher discounts on services and products. Exclusive access to VIP lounges and resources. Advanced customization options for tools.', '1 Year', 'Membership is valid for one year. Strictly non-transferable. Early cancellation forfeits all benefits. Access to events requires prior registration. Benefits may vary based on availability.', 'membership_premium.png', '2025-01-09 06:50:43'),
(3, 'Corporate Plan', 'Designed for businesses. This plan offers tools to help manage and grow your company effectively.', 500.00, 'Access to business analytics and tools. Priority customer support. Collaboration features for teams. Discounts on corporate events and workshops. Access to premium business templates and resources.', '1 Year', 'Membership is valid for one year. Cannot be transferred or shared between individuals. Early cancellation fees apply. Renewal required before expiration to avoid service interruption. Usage limited to business purposes only.', 'membership_corporate.png', '2025-01-09 06:50:43'),
(4, 'VIP Membership', 'Experience exclusive benefits. Enjoy 24/7 dedicated support and access to premium services.', 200.00, '24/7 dedicated support. Exclusive access to VIP-only content and events. Personalized recommendations and services. Free upgrades on selected features. Priority access to new features and beta programs.', '6 Months', 'Membership is valid for six months. Non-refundable upon purchase. Exclusive benefits are subject to availability. Misuse of services may result in termination without refund. Renewal offers may differ annually.', 'membership_vip.png', '2025-01-09 06:51:38'),
(5, 'Student Plan', 'Specially crafted for students. This plan provides resources and tools to enhance academic performance.', 30.00, 'Discounts on educational resources. Free access to student-only webinars and workshops. Tools to help manage academic life. Access to internship and job opportunity portals. Free technical support during business hours.', '1 Year', 'Proof of student status is required. Membership is valid for one year. Limited to one membership per student. Cannot be used for commercial purposes. Renewal requires updated student verification.', 'membership_student.png', '2025-01-09 06:51:38');

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
(2, 'Upcoming Event: Networking Brunch', 'Join us for an exclusive networking brunch this Saturday at Green Valley Clubhouse. Connect with fellow members and industry experts while enjoying great food and company. Spots are limited, so make sure to RSVP today! haha\n\n', '2024-11-25 16:00:03.256193', 15, 2),
(3, 'Member Spotlight: Achievements of the Month', 'Congratulations to our star members of the month! This month, we celebrate Alex Johnson for outstanding contributions in community volunteering and Maria Fernandez for her entrepreneurial achievements. Keep up the fantastic work!', '2024-11-25 16:00:25.998411', 1, 0),
(4, 'Exclusive Member Discounts: This Week\'s Deals', 'We are excited to announce some exclusive deals for our members! Get 15% off all products at our partner store \'FitLife\' and enjoy 10% off your next spa visit. Log in to your member dashboard to get your discount codes now!', '2024-11-25 16:00:46.784414', 2, 1),
(5, 'Join Our New Wellness Workshop', 'Our popular wellness workshop series is back! Join us on the 10th of December for a session on \'Mindfulness & Stress Relief\', led by an expert wellness coach. Don\'t miss this opportunity to relax and learn valuable techniques for well-being.', '2024-11-25 16:01:06.366380', 2, 1),
(6, 'Volunteer Opportunities: Make a Difference', 'Looking for ways to give back to the community? We have some exciting volunteer opportunities lined up this month. From environmental clean-ups to helping local shelters, there are many ways you can make an impact. Sign up through the member portal!', '2024-11-25 16:01:26.112417', 0, 0),
(7, 'Member Appreciation Day! A Special Thank You', 'We are dedicating a whole day to thank our amazing members! Come celebrate with us at our headquarters for free goodies, raffle prizes, and exclusive workshops. Your support is what makes our community thrive!', '2024-11-25 16:02:31.329773', 1, 0),
(8, 'Monthly Fitness Challenge! Win Rewards!', 'Are you ready to take your fitness journey to the next level? Participate in our monthly fitness challenge and stand a chance to win exciting rewards! Complete the challenge goals and earn points that you can redeem for exclusive prizes.', '2024-11-25 16:09:38.820386', 1, 0),
(9, 'New Features Alert! Check Out What\'s New', 'We\'ve added new features to enhance your experience! You can now easily track your event registrations, interact with other members in community discussions, and earn badges for active participation. Check out these exciting features today!', '2024-11-25 16:09:57.746866', 1, 1),
(10, 'Upcoming Webinar: Financial Planning Tips', 'Join us on Wednesday for an insightful webinar on \'Financial Planning for a Secure Future\'. Our guest speaker, financial expert Sarah Peterson, will cover budgeting tips, saving strategies, and investment basics to help you secure your future.', '2024-11-25 16:10:17.861526', 1, 1),
(12, 'Refer a Friend and Earn Rewards', 'Invite your friends to join our community and earn referral bonuses! For every successful referral, you get a $20 voucher that you can use for our upcoming events or member services. Let\'s grow our community together!', '2024-11-25 17:16:45.964089', 0, 0),
(13, 'Member Survey. Share Your Thoughts!', 'We value your feedback! Please take a few minutes to complete our member survey and let us know how we can improve your experience. All participants will be entered into a draw to win a free month of membership!', '2024-11-25 17:17:10.459355', 0, 0),
(14, 'Exclusive Pre-Launch Product for Members', 'We are launching a brand-new line of products, and as a valued member, you get early access! Check out our pre-launch event next week, and be among the first to explore these new offerings. Pre-orders are available for members only.', '2024-11-25 17:17:35.258575', 0, 0),
(15, 'Safety Guidelines for Upcoming Events', 'Your safety is our top priority. For all upcoming in-person events, please remember to follow the safety guidelines, including mask-wearing and social distancing. We are committed to providing a safe environment for all our members.', '2024-11-25 17:17:59.210587', 1, 1),
(16, 'Thank You for Attending Our Charity Gala!', 'We want to thank everyone who attended our charity gala last week. It was a huge success, and we raised over $10,000 for our local children\'s hospital. Your participation truly made a difference!', '2024-11-25 17:18:24.092906', 3, 0),
(17, 'Winter Sale Extravaganza!', 'Get ready for amazing discounts this winter! Exclusive deals available for members only. Don\'t miss out!', '2024-11-25 19:06:24.195320', 3, 0),
(18, 'Member Referral Program', 'Invite your friends to join and earn rewards! Enjoy special bonuses for every successful referral.', '2024-11-25 19:06:48.537971', 0, 0),
(19, 'Upcoming Webinar: Financial Planning Tips', 'Join us on Thursday for an insightful webinar on \'Effective Financial Planning for the Future\'. Register now!', '2024-11-25 19:07:14.487083', 3, 0),
(20, 'Introducing Our New Loyalty Program', 'We are excited to announce our new loyalty program. Earn points with every purchase and redeem for exclusive rewards.', '2024-11-25 19:07:38.642793', 4, 0),
(21, 'Exclusive Event: Summer Fitness Challenge', 'Participate in our summer fitness challenge! Get personalized coaching and track your progress with other members.', '2024-11-25 19:07:59.565178', 0, 0),
(22, 'Your Account Summary', 'Check out your latest account summary and make the most out of your membership benefits. Log in for details.', '2024-11-25 19:08:25.776426', 2, 0),
(23, 'Special Announcement: New Mobile App!', 'We are thrilled to announce our new mobile app for seamless access to all your membership benefits. haha', '2024-11-25 19:08:54.446709', 2, 0),
(24, 'New Workshops Available', 'We have added new workshops to enhance your skills and knowledge. Check out our event calendar now!', '2024-11-25 19:09:13.941711', 4, 1),
(25, 'Member Spotlight: Jane Doe Success Story', 'Learn how Jane used her membership to achieve her health and wellness goals. Get inspired today!', '2024-11-25 19:09:33.774695', 0, 0),
(26, 'Early Bird Tickets Available!', 'Book your tickets for our upcoming networking event at a discounted rate. Limited seats available!', '2024-11-25 19:10:15.312119', 9, 1),
(27, 'Reminder: Renew Your Membership Today', 'Renew your membership now to continue enjoying all the benefits and perks. We are excited to have you with us!', '2024-11-25 19:10:55.503088', 20, 6),
(29, 'Fitness Masterclass with Top Trainers', 'Join our masterclass with expert trainers to take your fitness journey to the next level.', '2024-11-25 19:11:35.395749', 4, 1),
(30, 'New Feature Alert: Enhanced User Dashboard', 'Experience our updated user dashboard with better navigation and more features to simplify your experience.', '2024-11-25 19:11:57.592123', 0, 0),
(31, 'Tips for Boosting Productivity', 'Check out our top tips for boosting productivity and achieving your goals faster.', '2024-11-25 19:12:19.255017', 0, 0),
(32, 'Monthly Member Meetup', 'Connect with other members during our monthly meetup. Network, socialize, and grow your connections. Hope to see you soon!!!', '2024-11-25 19:12:55.573377', 2, 0),
(33, 'Exclusive Offers for Platinum Members', 'Enjoy exclusive discounts on products and services as part of our Platinum Member benefits.', '2024-11-25 19:13:20.708686', 5, 0),
(34, 'Career Development Workshops', 'Advance your career with our upcoming workshops covering topics from leadership to effective communication', '2024-11-25 19:13:41.229502', 6, 2),
(35, 'Holiday Hours Announcement', 'Please note our adjusted hours of operation during the holidays. Happy holidays!', '2024-11-25 19:14:02.487203', 9, 1),
(36, 'Special Charity Event: Join Us!', 'Join us for a special charity event to make a positive impact. Lets give back together!', '2024-11-25 19:14:32.936833', 10, 2),
(37, 'Your Membership Benefits at a Glance', 'Get a quick overview of your exclusive member benefits. Make sure you are getting the most out of your membership.', '2024-11-25 19:14:53.218216', 1, 0),
(38, 'New Blog Post: Staying Healthy During Winter', 'Learn top tips for staying active and healthy during the colder months. Read the blog now!', '2024-11-25 19:15:25.628019', 6, 1),
(40, 'Health & Wellness Survey', 'We value your input! Participate in our wellness survey and help us provide better services for you.', '2024-11-25 19:16:08.120460', 0, 0),
(44, 'Upcoming Networking Event: Connect with the Best', 'Join us at our upcoming networking event, tailored specifically for professionals looking to expand their network. This virtual event will feature leaders in various industries, breakout sessions for focused discussions, and opportunities for one-on-one virtual meet-ups. Don\'t miss your chance to make valuable connections that can help you grow.', '2024-11-26 13:59:48.256752', 1, 0),
(45, 'Learn from Experts: Marketing Trends in 2024', 'Marketing is constantly evolving, and to help you stay ahead, we are hosting a webinar on \'Marketing Trends in 2024.\' You\'ll learn about emerging trends, effective strategies, and tools to help you enhance your campaigns. Featuring experts in digital marketing, this is a session you don\'t want to miss. Secure your spot today and be ready for the future of marketing.See you', '2024-11-26 15:10:18.752888', 1, 0),
(46, 'Masterclass: Public Speaking for Professionals', 'Public speaking is a crucial skill for any professional. Join our upcoming masterclass, where experienced speakers will share techniques to help you overcome anxiety, structure a powerful presentation, and connect with your audience. Participants will also have the opportunity to practice in front of peers and receive personalized feedback. Limited spots available, register soon! Thank you!', '2024-11-26 15:31:29.096633', 111, 49),
(47, 'Refer a Friend and Earn Membership Rewards!', 'Invite your friends to join our community and earn rewards for each successful referral. It\'s easy to share the benefits of membership, and now you get rewarded too! Each friend you refer who signs up gets an exclusive welcome gift, and you earn points towards discounts, exclusive events, and more. Start referring today!', '2024-11-27 00:42:25.346078', 43, 21),
(49, 'Announcing New Member Discounts with Partners!', 'We are proud to announce new partnerships that will bring you exclusive discounts on a wide range of products and services. From travel deals to tech gadgets, as a valued member, you will have access to the best offers. Visit our Member Deals page to see the latest discounts available and start saving today!', '2024-11-27 18:45:27.518895', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payments`
--

CREATE TABLE `tbl_payments` (
  `payment_id` int(6) NOT NULL,
  `user_id` int(6) NOT NULL,
  `membership_id` int(6) NOT NULL,
  `payment_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('Paid','Pending') NOT NULL,
  `payment_datePurchased` datetime NOT NULL DEFAULT current_timestamp(),
  `payment_dateExpired` datetime NOT NULL,
  `membership_status` enum('Active','Expired') NOT NULL DEFAULT 'Active',
  `receipt_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `tbl_payments`
--

INSERT INTO `tbl_payments` (`payment_id`, `user_id`, `membership_id`, `payment_amount`, `payment_status`, `payment_datePurchased`, `payment_dateExpired`, `membership_status`, `receipt_id`) VALUES
(1, 1, 5, 30.00, 'Paid', '2024-01-14 23:32:05', '2025-01-14 15:32:05', 'Expired', 'n4i83dbi'),
(2, 1, 4, 200.00, 'Paid', '2025-01-14 23:38:49', '2025-07-14 15:38:49', 'Active', 'pn8ggkr8'),
(3, 1, 1, 50.00, 'Paid', '2025-01-15 13:08:44', '2026-01-15 05:08:44', 'Active', 'zg0ze50p'),
(4, 1, 5, 30.00, 'Paid', '2025-01-15 17:45:46', '2026-01-15 09:45:46', 'Active', 'snziai6m'),
(5, 1, 5, 30.00, 'Paid', '2025-01-15 18:12:06', '2026-01-15 10:12:06', 'Active', 'xzbgd2m5'),
(6, 1, 1, 50.00, 'Paid', '2025-01-15 23:10:03', '2026-01-15 15:10:03', 'Active', 'gnojtwgg'),
(7, 1, 2, 100.00, 'Paid', '2025-01-16 02:06:34', '2026-01-15 18:06:34', 'Active', 'o2du5vxa'),
(8, 1, 3, 500.00, 'Paid', '2025-01-16 02:10:30', '2026-01-15 18:10:30', 'Active', 'uuthk0zr'),
(9, 1, 4, 200.00, 'Paid', '2025-01-16 09:13:11', '2025-07-16 01:13:11', 'Active', 'nop1kzuh'),
(10, 1, 3, 500.00, 'Paid', '2025-01-16 09:15:54', '2026-01-16 01:15:54', 'Active', 'zy5nuhtg'),
(11, 1, 2, 100.00, 'Paid', '2025-01-16 09:24:24', '2026-01-16 01:24:24', 'Active', 'unwuctox'),
(22, 13, 5, 30.00, 'Paid', '2025-01-16 11:50:21', '2026-01-16 03:50:21', 'Active', '3hrorejq'),
(23, 13, 1, 50.00, 'Paid', '2025-01-16 11:55:49', '2026-01-16 03:55:49', 'Active', '58cpy4bn'),
(24, 13, 5, 30.00, 'Paid', '2025-01-16 14:16:10', '2026-01-16 06:16:10', 'Active', 'lsp6xy6o'),
(25, 13, 3, 500.00, 'Pending', '2025-01-16 14:20:08', '2026-01-16 06:20:08', 'Active', '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_products`
--

CREATE TABLE `tbl_products` (
  `product_id` int(4) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `product_description` varchar(800) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `product_quantity` int(5) NOT NULL,
  `product_category` varchar(30) NOT NULL,
  `product_filename` varchar(20) NOT NULL,
  `product_rating` int(2) NOT NULL,
  `product_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_products`
--

INSERT INTO `tbl_products` (`product_id`, `product_name`, `product_description`, `product_price`, `product_quantity`, `product_category`, `product_filename`, `product_rating`, `product_date`) VALUES
(1, 'Black Hand T-shirt', 'Artwork is printed on a 100% Ringspun Cotton black unisex T-Shirt', 35.00, 1000, 'T-shirts', 'product-1.png', 4, '2024-12-11 16:14:29'),
(2, 'Navyblue Baseball Cap', 'They say that \"everything old is new again\". In the case of flat vs. curved brim baseball caps, everything old is new, then old, then new, then old...then new and old... The t...', 20.00, 1000, 'Caps', 'product-2.png', 3, '2024-12-11 18:48:31'),
(3, 'Kuching City Mug', '11oz inner trim column mug with Soccer ball handle\r\nand it is ceramic.\r\n ', 20.50, 999, 'Mugs', 'product-3.png', 4, '2024-12-11 21:06:23'),
(4, '7oz Long Handle Cotton Bags', 'Our 7oz Long Handle Cotton Bags combine lasting brand awareness with budget-friendly prices to offer an environmentally-conscious item that suits all manners of companies and target audiences. From giveaways at events such as university open days and industry conferences to a welcome gift to your new employees, these branded tote bags are sure to shine your organisation in a green light.\r\n', 10.90, 999, 'Bags', 'product-4.png', 5, '2024-12-11 21:10:12'),
(5, 'Nimrod Soft Feel Stylus Ballpen', 'Our Nimrod Soft Feel Stylus Ballpens are stylish promotional metal pens with a high perceived value but at a great low-cost. The result? Fantastic value for money promotional pen that is sure to advertise your brand with every single use. These stylish branded pens combine a click action ballpen with a handy soft touch stylus, enabling the recipient to use them for both jotting down notes and using a touch-screen device without leaving finger marks. ', 3.30, 878, 'Stationeries', 'product-5.png', 5, '2024-12-11 21:11:44'),
(6, 'Honda Umbrella', 'Honda Malaysia Official Licensed Product\r\n-Honda Stylish Umbrella. (HOT) (Last 100 Units)\r\n-Strong and Durable', 65.99, 100, 'Others', 'product-6.png', 5, '2024-12-11 21:14:42'),
(7, 'Black Guitar T-shirt', 'In celebration of George Harrison’s Living In The Material World 50th Anniversary release, this new T-Shirt design is printed on a 100% Ringspun Cotton black unisex garment with custom \"George Harrison\" neck label print.', 35.00, 987, 'T-shirts', 'product-7.png', 5, '2024-12-11 23:57:43'),
(8, 'Violet Hand T-shirt', 'In celebration of George Harrison’s Living In The Material World 50th Anniversary release comes this exclusive \'Violet Hand\' design printed on a 100% Ringspun Cotton unisex T-Shirt with custom \"George Harrison\" neck label print.', 35.00, 999, 'T-shirts', 'product-8.png', 5, '2024-12-12 00:02:18'),
(9, 'Chair White T-shirt', 'Celebrate George Harrison\'s \"All Things Must Pass\" with this new design inspired by the artwork from George\'s classic album.', 17.50, 999, 'T-shirts', 'product-9.png', 4, '2024-12-12 00:02:18'),
(10, 'Garden Baby Blue T-shirt', 'Celebrate George\'s classic album, \"All Things Must Pass\", with this new design inspired by the photo shoot for the album.\r\n- Unisex\r\n- 100% Cotton\r\n- Baby Blue T-shirt', 35.00, 999, 'T-shirts', 'product-10.png', 5, '2024-12-12 00:03:40'),
(11, 'My Sweet Lord T-shirt', 'George Harrison \"My Sweet Lord\" vintage floral design T-Shirt inspired by George\'s classic hit single.\r\n- 100% cotton\r\n- Unisex \r\n- Color: Olive\r\n- Custom George Harrison printed neck label', 35.00, 999, 'T-shirts', 'product-11.png', 5, '2024-12-12 00:04:33');

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
(1, 'Aurora', 'Lim', 'aurora@gmail.com', '011-1234567', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2024-11-06 15:43:57'),
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
(12, 'jiayee', 'lim', 'jiayeelim@gmail.com', '012-72099998', 'ff46b391c0804af3cf60733f8ff8634ec33f25ff', 'ff46b391c0804af3cf60733f8ff8634ec33f25ff', '2024-11-10 17:14:58'),
(13, 'Little', 'Pony', 'mylittlepony000101@gmail.com', '012-12345678', 'be50ad611bf7eebf64e13426541dbdace040eae5', 'be50ad611bf7eebf64e13426541dbdace040eae5', '2025-01-15 18:47:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `fk_product_cart` (`product_id`);

--
-- Indexes for table `tbl_memberships`
--
ALTER TABLE `tbl_memberships`
  ADD PRIMARY KEY (`membership_id`);

--
-- Indexes for table `tbl_news`
--
ALTER TABLE `tbl_news`
  ADD PRIMARY KEY (`news_id`);

--
-- Indexes for table `tbl_payments`
--
ALTER TABLE `tbl_payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `membership_id` (`membership_id`);

--
-- Indexes for table `tbl_products`
--
ALTER TABLE `tbl_products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  MODIFY `cart_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tbl_memberships`
--
ALTER TABLE `tbl_memberships`
  MODIFY `membership_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_news`
--
ALTER TABLE `tbl_news`
  MODIFY `news_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `tbl_payments`
--
ALTER TABLE `tbl_payments`
  MODIFY `payment_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `tbl_products`
--
ALTER TABLE `tbl_products`
  MODIFY `product_id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  ADD CONSTRAINT `fk_product_cart` FOREIGN KEY (`product_id`) REFERENCES `tbl_products` (`product_id`);

--
-- Constraints for table `tbl_payments`
--
ALTER TABLE `tbl_payments`
  ADD CONSTRAINT `tbl_payments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tbl_payments_ibfk_2` FOREIGN KEY (`membership_id`) REFERENCES `tbl_memberships` (`membership_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
