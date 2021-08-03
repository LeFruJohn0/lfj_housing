ALTER TABLE vrp_users ADD inhouse int NOT NULL DEFAULT 0;

CREATE TABLE `lfj_housing` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `sellingprice` int(11) NOT NULL,
  `type` text NOT NULL,
  `status` tinyint(1) NOT NULL,
  `x` varchar(255) NOT NULL,
  `y` varchar(255) NOT NULL,
  `z` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


ALTER TABLE `lfj_housing`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `lfj_housing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
