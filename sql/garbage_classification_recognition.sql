/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : garbage_classification_recognition

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 06/03/2026 19:39:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for chat_messages
-- ----------------------------
DROP TABLE IF EXISTS `chat_messages`;
CREATE TABLE `chat_messages`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sender_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送者ID（UUID格式）',
  `sender_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发送者名称',
  `receiver_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接收者ID（UUID格式）',
  `receiver_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接收者名称',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `message_type` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'text' COMMENT '消息类型：text/image/file',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  `read_status` enum('sending','sent','delivered','read','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'sent' COMMENT '消息状态：sending-发送中, sent-已发送, delivered-已送达, read-已读, failed-发送失败',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sender_receiver`(`sender_id` ASC, `receiver_id` ASC) USING BTREE,
  INDEX `idx_timestamp`(`timestamp` ASC) USING BTREE,
  INDEX `idx_read_status`(`read_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '即时通讯消息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat_messages
-- ----------------------------
INSERT INTO `chat_messages` VALUES (1, 'user-001', '张三', 'user-002', '李四', '你好，最近怎么样？', 'text', '2025-08-17 21:03:46', 'sent', '2025-08-17 21:03:46', '2025-08-17 21:03:46');
INSERT INTO `chat_messages` VALUES (2, 'user-002', '李四', 'user-001', '张三', '还不错，你呢？', 'text', '2025-08-17 21:03:46', 'sent', '2025-08-17 21:03:46', '2025-08-17 21:03:46');
INSERT INTO `chat_messages` VALUES (3, 'user-001', '张三', 'user-002', '李四', '我也挺好的，有空一起吃饭吧', 'text', '2025-08-17 21:03:46', 'sent', '2025-08-17 21:03:46', '2025-08-17 21:03:46');
INSERT INTO `chat_messages` VALUES (4, 'user-003', '王五', 'user-001', '张三', '明天的会议准备好了吗？', 'text', '2025-08-17 21:03:46', 'sent', '2025-08-17 21:03:46', '2025-08-17 21:03:46');
INSERT INTO `chat_messages` VALUES (5, 'user-001', '张三', 'user-003', '王五', '已经准备好了，PPT我发给你看看', 'text', '2025-08-17 21:03:46', 'sent', '2025-08-17 21:03:46', '2025-08-17 21:03:46');
INSERT INTO `chat_messages` VALUES (7, 'user001', '测试发送者', 'user002', '测试接收者', '这是一条测试消息', 'text', '2025-08-18 11:28:35', 'sent', '2025-08-18 11:28:35', '2025-08-18 11:28:35');
INSERT INTO `chat_messages` VALUES (8, '1', '测试发送者', '2', '测试接收者', '这是一条测试消息', 'text', '2025-08-18 11:29:23', 'sent', '2025-08-18 11:29:23', '2025-08-18 11:29:23');
INSERT INTO `chat_messages` VALUES (9, '1', '测试发送者', '101', '测试接收者', '这是一条测试消息', 'text', '2025-08-19 10:21:51', 'read', '2025-08-19 10:21:50', '2025-11-01 11:52:33');
INSERT INTO `chat_messages` VALUES (10, '1', '测试发送者', '100', '测试接收者', '这是一条测试消息', 'text', '2025-08-19 10:22:42', 'sent', '2025-08-19 10:22:41', '2025-08-19 10:22:41');
INSERT INTO `chat_messages` VALUES (11, '1', '测试发送者', '100', '测试接收者', '这是一条测试消息', 'text', '2025-08-19 10:23:40', 'sent', '2025-08-19 10:23:40', '2025-08-19 10:23:40');
INSERT INTO `chat_messages` VALUES (12, '1', '测试发送者', '100', '测试接收者', '这是一条测试消息', 'text', '2025-08-19 10:23:56', 'sent', '2025-08-19 10:23:56', '2025-08-19 10:23:56');
INSERT INTO `chat_messages` VALUES (13, '1', '测试发送者', '100', '测试接收者', '这是一条测试消息', 'text', '2025-08-19 10:24:53', 'sent', '2025-08-19 10:24:53', '2025-08-19 10:24:53');
INSERT INTO `chat_messages` VALUES (14, '1', '测试发送者', '100', '测试接收者', '这是一条测试消息', 'text', '2025-08-19 20:09:45', 'sent', '2025-08-19 20:09:44', '2025-08-19 20:09:44');
INSERT INTO `chat_messages` VALUES (15, 'user001', '测试发送者', 'user002', '测试接收者', '这是一条测试消息', 'text', '2025-08-19 20:12:04', 'sent', '2025-08-19 20:12:04', '2025-08-19 20:12:04');
INSERT INTO `chat_messages` VALUES (16, '1', '瑶力云', '2', '瑶力云', '446', 'text', '2025-11-01 12:25:18', 'sent', '2025-11-01 12:25:19', '2025-11-01 12:25:19');
INSERT INTO `chat_messages` VALUES (17, '2', '瑶力云', '1', '瑶力云', '123', 'text', '2025-11-01 12:25:18', 'read', '2025-11-01 12:25:19', '2025-11-01 12:26:27');
INSERT INTO `chat_messages` VALUES (18, '1', '瑶力云', '2', '瑶力云', '346eryeturtuhfgwtetwr qyeruterurwturtujwrtuirtjfgnjgfncxngfjjrfgjswftj', 'text', '2025-11-01 12:31:29', 'sent', '2025-11-01 12:31:29', '2025-11-01 12:31:29');
INSERT INTO `chat_messages` VALUES (19, '1', '瑶力云', '2', '瑶力云', 'http://localhost:8080/profile/upload/2025/11/01/H5EafLbByLU41ef4c5542311e5be2d96465f2a9b4290_20251101123446A001.jpg', 'image', '2025-11-01 12:34:46', 'sent', '2025-11-01 12:34:46', '2025-11-01 12:34:46');
INSERT INTO `chat_messages` VALUES (20, '1', '瑶力云', '2', '瑶力云', 'yeyetu4564', 'text', '2025-11-01 12:37:15', 'sent', '2025-11-01 12:37:15', '2025-11-01 12:37:15');
INSERT INTO `chat_messages` VALUES (21, '1', '瑶力云', '2', '瑶力云', 'http://localhost:8080/profile/upload/2025/11/01/PGbJ2lJMHJcTc8c41ea7c94d98f2f86ce76400cb814e_20251101124121A001.jpg', 'image', '2025-11-01 12:41:21', 'sent', '2025-11-01 12:41:21', '2025-11-01 12:41:21');
INSERT INTO `chat_messages` VALUES (22, '1', '瑶力云', '2', '瑶力云', 'http://localhost:8080/profile/upload/2025/11/01/cDqWKWbD4DPEd21e7e9106cadd46e9b20c3124187be7_20251101124128A002.jpg', 'image', '2025-11-01 12:41:28', 'sent', '2025-11-01 12:41:28', '2025-11-01 12:41:28');
INSERT INTO `chat_messages` VALUES (23, '1', '瑶力云', '100', '微信用户', '3567457', 'text', '2025-11-01 12:41:54', 'sent', '2025-11-01 12:41:54', '2025-11-01 12:41:54');
INSERT INTO `chat_messages` VALUES (24, '1', '瑶力云', '100', '微信用户', 'http://localhost:8080/profile/upload/2025/11/01/VYoGtIs1wm541cd1d4e8d35f20bae5da5746f3290bde_20251101124202A003.jpg', 'image', '2025-11-01 12:42:02', 'sent', '2025-11-01 12:42:02', '2025-11-01 12:42:02');
INSERT INTO `chat_messages` VALUES (25, '1', '瑶力云', '2', '瑶力云', '3525', 'text', '2025-11-01 13:11:16', 'sent', '2025-11-01 13:11:16', '2025-11-01 13:11:16');
INSERT INTO `chat_messages` VALUES (26, '1', '瑶力云', '2', '瑶力云', '32523', 'text', '2025-11-01 13:11:19', 'sent', '2025-11-01 13:11:19', '2025-11-01 13:11:19');
INSERT INTO `chat_messages` VALUES (27, '1', '瑶力云', '2', '瑶力云', '46346', 'text', '2025-11-01 13:11:24', 'sent', '2025-11-01 13:11:24', '2025-11-01 13:11:24');
INSERT INTO `chat_messages` VALUES (28, '1', '瑶力云', '2', '瑶力云', '57457', 'text', '2025-11-01 13:12:21', 'sent', '2025-11-01 13:12:21', '2025-11-01 13:12:21');
INSERT INTO `chat_messages` VALUES (29, '1', '瑶力云', '2', '瑶力云', 'http://localhost:8080/profile/upload/2025/11/02/金渐层_20251102122238A001.jpg', 'image', '2025-11-02 12:22:38', 'sent', '2025-11-02 12:22:38', '2025-11-02 12:22:38');

-- ----------------------------
-- Table structure for chat_sessions
-- ----------------------------
DROP TABLE IF EXISTS `chat_sessions`;
CREATE TABLE `chat_sessions`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户ID',
  `contact_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系人ID',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人名称',
  `contact_avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系人头像',
  `last_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '最后一条消息',
  `last_message_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后消息时间',
  `unread_count` int NULL DEFAULT 0 COMMENT '未读消息数',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `last_message_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '消息类型',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_contact`(`user_id` ASC, `contact_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_last_message_time`(`last_message_time` ASC) USING BTREE,
  INDEX `idx_contact_id`(`contact_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '聊天会话表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat_sessions
-- ----------------------------
INSERT INTO `chat_sessions` VALUES (7, '1', '2', '23424', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dbilOnZzX-SFW26EsAxOnwHaK6?w=198&h=293&c=7&r=0&o=7&pid=1.7&rm=3', 'http://localhost:8080/profile/upload/2025/11/02/金渐层_20251102122238A001.jpg', '2025-11-02 12:22:39', 0, '2025-08-18 11:29:23', '2025-11-02 12:22:39', 'image');
INSERT INTO `chat_sessions` VALUES (8, '2', '1', '测试232', 'http://localhost:8080/profile/upload/2025/11/01/X49iRse5M86pc6426a8df17963e29fb02e0b008751ac_20251101132957A007.jpg', 'http://localhost:8080/profile/upload/2025/11/02/金渐层_20251102122238A001.jpg', '2025-11-02 12:22:39', 11, '2025-08-18 11:29:23', '2025-11-02 12:22:39', 'image');
INSERT INTO `chat_sessions` VALUES (9, '1', '101', '232', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dbilOnZzX-SFW26EsAxOnwHaK6?w=198&h=293&c=7&r=0&o=7&pid=1.7&rm=3', 'Y', '2025-08-19 10:21:51', 0, '2025-08-19 10:21:50', '2025-11-14 11:09:31', NULL);
INSERT INTO `chat_sessions` VALUES (10, '101', '1', '3212', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dbilOnZzX-SFW26EsAxOnwHaK6?w=198&h=293&c=7&r=0&o=7&pid=1.7&rm=3', 'N', '2025-08-19 10:21:51', 0, '2025-08-19 10:21:50', '2025-11-14 11:09:38', NULL);
INSERT INTO `chat_sessions` VALUES (11, '1', '100', '1233', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dbilOnZzX-SFW26EsAxOnwHaK6?w=198&h=293&c=7&r=0&o=7&pid=1.7&rm=3', 'http://localhost:8080/profile/upload/2025/11/01/VYoGtIs1wm541cd1d4e8d35f20bae5da5746f3290bde_20251101124202A003.jpg', '2025-11-01 12:42:02', 0, '2025-08-19 10:22:41', '2025-11-01 12:42:02', 'image');
INSERT INTO `chat_sessions` VALUES (12, '100', '1', '测试1', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dbilOnZzX-SFW26EsAxOnwHaK6?w=198&h=293&c=7&r=0&o=7&pid=1.7&rm=3', 'http://localhost:8080/profile/upload/2025/11/01/VYoGtIs1wm541cd1d4e8d35f20bae5da5746f3290bde_20251101124202A003.jpg', '2025-11-01 12:42:02', 2, '2025-08-19 10:22:41', '2025-11-01 12:42:02', 'image');

-- ----------------------------
-- Table structure for garbage_category
-- ----------------------------
DROP TABLE IF EXISTS `garbage_category`;
CREATE TABLE `garbage_category`  (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '类别ID',
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类别名称',
  `category_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类别编码',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类别描述',
  `icon_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标URL',
  `color_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '颜色代码',
  `disposal_guidelines` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '处理指南',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`category_id`) USING BTREE,
  UNIQUE INDEX `uk_category_name`(`category_name` ASC) USING BTREE COMMENT '类别名称唯一索引',
  UNIQUE INDEX `uk_category_code`(`category_code` ASC) USING BTREE COMMENT '类别编码唯一索引',
  INDEX `idx_status`(`status` ASC) USING BTREE COMMENT '状态索引',
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE COMMENT '排序索引'
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '垃圾分类类别表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of garbage_category
-- ----------------------------
INSERT INTO `garbage_category` VALUES (1, '可回收物', 'recyclable', '可回收物是指适宜回收利用和资源化利用的生活废弃物，包括废纸、废塑料、废金属、废玻璃、废织物等。', 'http://localhost:8080/profile/upload/2025/12/16/0541.jpg_wh860_20251216140946A001.jpg', '#3498db', '投放要求：\n1. 纸类应尽量叠放整齐，避免揉团，纸板也应拆开叠放\n2. 塑料垃圾应清空内容物，清洁后压扁投放\n3. 玻璃类应轻投轻放，有尖锐边角的应包裹后投放\n4. 织物应叠放整齐，避免污染\n5. 金属类应清洁干燥，避免混入其他垃圾', 1, '0', 'admin', '2025-12-13 16:24:53', '', '2025-12-16 14:09:49', NULL);
INSERT INTO `garbage_category` VALUES (2, '有害垃圾', 'hazardous', '有害垃圾是指对人体健康或者自然环境造成直接或者潜在危害的生活废弃物，包括废电池、废灯管、废药品、废油漆及其容器等。', '/static/icons/hazardous.png', '#e74c3c', '投放要求：\n1. 废电池（充电电池、纽扣电池等）应保持完好，防止有害物质外漏\n2. 废灯管应保持完整，防止破损\n3. 废药品应连带包装一并投放\n4. 废油漆桶、杀虫剂罐应排空内容物后投放\n5. 有害垃圾投放时应注意轻放\n6. 易破损的应用纸或布包裹后投放', 2, '0', 'admin', '2025-12-13 16:24:53', '', NULL, NULL);
INSERT INTO `garbage_category` VALUES (3, '厨余垃圾', 'kitchen', '厨余垃圾是指居民日常生活及食品加工、饮食服务、单位供餐等活动中产生的垃圾，包括丢弃不用的菜叶、剩菜、剩饭、果皮、蛋壳、茶渣、骨头等。', '/static/icons/kitchen.png', '#27ae60', '投放要求：\n1. 厨余垃圾应沥干水分后投放\n2. 有包装物的应去除包装物后分类投放\n3. 包装物请投放到对应的可回收物或其他垃圾收集容器\n4. 纯流质的食物垃圾，如牛奶等，应直接倒入下水口\n5. 大块骨头和椰子壳等应投放到其他垃圾', 3, '0', 'admin', '2025-12-13 16:24:53', '', NULL, NULL);
INSERT INTO `garbage_category` VALUES (4, '其他垃圾', 'other', '其他垃圾是指除可回收物、有害垃圾、厨余垃圾以外的其他生活废弃物，包括砖瓦陶瓷、渣土、卫生间废纸、瓷器碎片等难以回收的废弃物。', '/static/icons/other.png', '#95a5a6', '投放要求：\n1. 在未能准确判断垃圾类别时，可投放到其他垃圾收集容器\n2. 卫生纸、餐巾纸等纸巾类因水溶性强不可回收，应投放到其他垃圾\n3. 陶瓷制品、普通一次性电池等应投放到其他垃圾\n4. 大件垃圾应预约上门收集或投放到指定地点', 4, '0', 'admin', '2025-12-13 16:24:53', '', NULL, NULL);

-- ----------------------------
-- Table structure for garbage_item
-- ----------------------------
DROP TABLE IF EXISTS `garbage_item`;
CREATE TABLE `garbage_item`  (
  `item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '物品ID',
  `category_id` bigint NOT NULL COMMENT '所属类别ID',
  `item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '物品名称',
  `item_name_pinyin` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称拼音',
  `disposal_suggestion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '处理建议',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '物品图片URL',
  `environmental_tips` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '环保小贴士',
  `search_count` int NULL DEFAULT 0 COMMENT '搜索次数',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`item_id`) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE COMMENT '类别ID索引',
  INDEX `idx_item_name`(`item_name` ASC) USING BTREE COMMENT '物品名称索引',
  INDEX `idx_item_name_pinyin`(`item_name_pinyin` ASC) USING BTREE COMMENT '拼音索引',
  INDEX `idx_status`(`status` ASC) USING BTREE COMMENT '状态索引',
  INDEX `idx_search_count`(`search_count` DESC) USING BTREE COMMENT '搜索次数索引',
  CONSTRAINT `fk_item_category` FOREIGN KEY (`category_id`) REFERENCES `garbage_category` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '垃圾物品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of garbage_item
-- ----------------------------
INSERT INTO `garbage_item` VALUES (1, 1, '报纸', 'baozhi', '叠放整齐，避免揉团，保持干燥投放', NULL, '1吨废纸可再造800公斤好纸，相当于少砍17棵大树', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (2, 1, '纸箱', 'zhixiang', '拆开压扁后投放，去除胶带', NULL, '纸箱回收再利用可减少70%的空气污染', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (3, 1, '书本', 'shuben', '叠放整齐投放，可捐赠给需要的人', NULL, '旧书回收可以节约造纸原料和能源', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (4, 1, '塑料瓶', 'suliaoping', '清空内容物，压扁后投放', NULL, '回收1个塑料瓶可节省3小时电视用电', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (5, 1, '易拉罐', 'yilaguan', '清空内容物，压扁后投放', NULL, '回收1个易拉罐可节省3小时电视用电', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (6, 1, '玻璃瓶', 'boliping', '清空内容物，轻放避免破碎', NULL, '玻璃可以100%回收再利用', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (7, 1, '旧衣服', 'jiuyifu', '清洗干净，叠放整齐投放', NULL, '旧衣物可以捐赠或回收再利用', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (8, 1, '金属罐', 'jinshuguan', '清空内容物，压扁后投放', NULL, '金属回收可以节省大量能源', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (9, 1, '牛奶盒', 'niunaihe', '清空内容物，压扁后投放', NULL, '牛奶盒可以回收制成再生纸', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (10, 1, '快递纸箱', 'kuaidzhixiang', '去除胶带，拆开压扁投放', NULL, '快递纸箱回收可减少资源浪费', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (11, 1, '废铁', 'feitie', '清洁后投放，注意安全', NULL, '废铁回收可以节省大量矿产资源', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (12, 1, '铝箔', 'lvbo', '清洁后压扁投放', NULL, '铝箔可以100%回收再利用', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (13, 1, '旧书包', 'jiushubao', '清空内容物，可捐赠', NULL, '旧书包可以捐赠给贫困地区学生', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (14, 1, '塑料桶', 'suliaotong', '清空内容物，清洗后投放', NULL, '塑料桶可以回收制成新的塑料制品', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (15, 1, '废纸板', 'feizhibn', '叠放整齐，保持干燥', NULL, '废纸板回收可以减少森林砍伐', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (16, 1, '旧鞋子', 'jiuxiezi', '清洁后配对投放', NULL, '旧鞋子可以捐赠或回收再利用', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (17, 1, '废铜', 'feitong', '清洁后投放', NULL, '废铜回收价值高，可节省矿产资源', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (18, 1, '旧床单', 'jiuchuangdan', '清洗干净，叠放整齐', NULL, '旧床单可以回收制成抹布等', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (19, 1, '废玻璃', 'feiboli', '轻放避免破碎，碎片需包裹', NULL, '玻璃回收可以无限次循环利用', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (20, 1, '旧毛巾', 'jiumaojin', '清洗干净后投放', NULL, '旧毛巾可以回收制成工业抹布', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (21, 2, '废电池', 'feidianchi', '保持完好，防止有害物质外漏', NULL, '1节电池可污染60万升水，请妥善处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (22, 2, '废灯管', 'feidenguan', '保持完整，防止破损', NULL, '灯管含汞，破损会造成环境污染', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (23, 2, '过期药品', 'guoqiyaopin', '连带包装一并投放', NULL, '过期药品随意丢弃会污染土壤和水源', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (24, 2, '废油漆桶', 'feiyouqitong', '排空内容物后投放', NULL, '油漆含有害化学物质，需专门处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (25, 2, '杀虫剂', 'shachongji', '排空内容物后投放', NULL, '杀虫剂含有毒物质，需专门处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (26, 2, '废水银温度计', 'feishuiyinwenduji', '保持完整，防止水银外漏', NULL, '水银有毒，需专门回收处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (27, 2, '废荧光灯', 'feiyingguangdeng', '保持完整，轻放', NULL, '荧光灯含汞，需专门处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (28, 2, '废农药瓶', 'feinongyaoping', '排空内容物，不要清洗', NULL, '农药瓶残留有毒物质，需专门处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (29, 2, '指甲油', 'zhijiayou', '连带瓶子一起投放', NULL, '指甲油含有害化学物质', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (30, 2, '废墨盒', 'feimohe', '保持完整投放', NULL, '墨盒含有害物质，需专门回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (31, 2, '废胶片', 'feijiaopin', '保持干燥投放', NULL, '胶片含银等重金属，需专门处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (32, 2, '废相纸', 'feixiangzhi', '保持干燥投放', NULL, '相纸含化学物质，需专门处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (33, 2, '纽扣电池', 'niukoudianchi', '保持完好投放', NULL, '纽扣电池含汞，污染严重', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (34, 2, '充电电池', 'chongdiandianchi', '保持完好投放', NULL, '充电电池含重金属，需回收处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (35, 2, '废消毒剂', 'feixiaodji', '排空内容物后投放', NULL, '消毒剂含有害化学物质', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (36, 2, '废染发剂', 'feiranfaji', '排空内容物后投放', NULL, '染发剂含有害化学物质', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (37, 2, '废X光片', 'feiXguangpian', '保持干燥投放', NULL, 'X光片含银，需专门回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (38, 2, '废血压计', 'feixueyaji', '保持完整投放', NULL, '血压计含水银，需专门处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (39, 2, '废机油', 'feijiyou', '密封后投放', NULL, '机油污染土壤和水源', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (40, 2, '废硒鼓', 'feixigu', '保持完整投放', NULL, '硒鼓含有害物质，需专门回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (41, 3, '剩菜剩饭', 'shengcaishengfan', '沥干水分后投放', NULL, '厨余垃圾可以堆肥，变废为宝', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (42, 3, '果皮', 'guopi', '沥干水分后投放', NULL, '果皮可以堆肥，制成有机肥料', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (43, 3, '蛋壳', 'danke', '沥干水分后投放', NULL, '蛋壳富含钙质，可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (44, 3, '茶叶渣', 'chayezha', '沥干水分后投放', NULL, '茶叶渣可以堆肥或除臭', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (45, 3, '菜叶', 'caiye', '沥干水分后投放', NULL, '菜叶可以堆肥，制成有机肥料', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (46, 3, '瓜子壳', 'guazike', '直接投放', NULL, '瓜子壳可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (47, 3, '花生壳', 'huashengke', '直接投放', NULL, '花生壳可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (48, 3, '鱼骨', 'yugu', '沥干水分后投放', NULL, '鱼骨可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (49, 3, '虾壳', 'xiake', '沥干水分后投放', NULL, '虾壳富含钙质，可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (50, 3, '蟹壳', 'xieke', '沥干水分后投放', NULL, '蟹壳可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (51, 3, '过期食品', 'guoqishipin', '去除包装后投放', NULL, '过期食品可以堆肥处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (52, 3, '西瓜皮', 'xiguapi', '沥干水分后投放', NULL, '西瓜皮水分多，需沥干', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (53, 3, '香蕉皮', 'xiangjiaopi', '直接投放', NULL, '香蕉皮可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (54, 3, '苹果核', 'pingguohe', '直接投放', NULL, '苹果核可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (55, 3, '玉米棒', 'yumibang', '直接投放', NULL, '玉米棒可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (56, 3, '豆腐渣', 'doufuzha', '沥干水分后投放', NULL, '豆腐渣可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (57, 3, '面包屑', 'mianbaoxie', '直接投放', NULL, '面包屑可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (58, 3, '米饭', 'mifan', '沥干水分后投放', NULL, '米饭可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (59, 3, '面条', 'miantiao', '沥干水分后投放', NULL, '面条可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (60, 3, '中药渣', 'zhongyaozha', '沥干水分后投放', NULL, '中药渣可以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (61, 4, '卫生纸', 'weishengzhi', '直接投放', NULL, '卫生纸水溶性强，不可回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (62, 4, '餐巾纸', 'canjinzhi', '直接投放', NULL, '餐巾纸已污染，不可回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (63, 4, '烟蒂', 'yandi', '熄灭后投放', NULL, '烟蒂降解需要很长时间', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (64, 4, '尘土', 'chentu', '直接投放', NULL, '尘土属于不可回收物', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (65, 4, '陶瓷碎片', 'taocisuipian', '包裹后投放，注意安全', NULL, '陶瓷不可回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (66, 4, '一次性餐具', 'yicixingcanju', '清空食物残渣后投放', NULL, '一次性餐具难以回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (67, 4, '污染纸张', 'wuranzhizhang', '直接投放', NULL, '污染的纸张不可回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (68, 4, '猫砂', 'maosha', '直接投放', NULL, '猫砂属于其他垃圾', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (69, 4, '宠物粪便', 'chongwufenbian', '包裹后投放', NULL, '宠物粪便需妥善处理', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (70, 4, '破旧陶瓷', 'pojiutaoci', '包裹后投放', NULL, '陶瓷不可回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (71, 4, '大骨头', 'dagutou', '直接投放', NULL, '大骨头难以堆肥，属于其他垃圾', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (72, 4, '椰子壳', 'yezike', '直接投放', NULL, '椰子壳难以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (73, 4, '榴莲壳', 'liulianke', '直接投放', NULL, '榴莲壳难以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (74, 4, '核桃壳', 'hetaoke', '直接投放', NULL, '核桃壳难以堆肥', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (75, 4, '创可贴', 'chuangketie', '直接投放', NULL, '创可贴属于其他垃圾', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (76, 4, '口罩', 'kouzhao', '直接投放', NULL, '口罩属于其他垃圾', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (77, 4, '内衣裤', 'neiyiku', '直接投放', NULL, '内衣裤不宜回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (78, 4, '旧毛巾', 'jiumaojin', '直接投放', NULL, '污染严重的毛巾属于其他垃圾', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (79, 4, '一次性杯子', 'yicixingbeizi', '直接投放', NULL, '一次性杯子难以回收', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);
INSERT INTO `garbage_item` VALUES (80, 4, '干燥剂', 'ganzaoji', '直接投放', NULL, '干燥剂属于其他垃圾', 0, '0', 'admin', '2025-12-13 16:25:06', '', NULL);

-- ----------------------------
-- Table structure for garbage_knowledge_article
-- ----------------------------
DROP TABLE IF EXISTS `garbage_knowledge_article`;
CREATE TABLE `garbage_knowledge_article`  (
  `article_id` bigint NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '关联分类ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '文章内容',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览次数',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`article_id`) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE COMMENT '分类ID索引',
  INDEX `idx_status`(`status` ASC) USING BTREE COMMENT '状态索引',
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE COMMENT '排序索引',
  INDEX `idx_view_count`(`view_count` DESC) USING BTREE COMMENT '浏览次数索引'
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '垃圾分类知识文章表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of garbage_knowledge_article
-- ----------------------------
INSERT INTO `garbage_knowledge_article` VALUES (1, 1, '可回收物分类指南', '<h2>什么是可回收物？</h2><p>可回收物是指适宜回收利用和资源化利用的生活废弃物。主要包括：</p><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>废纸</strong>：报纸、书本、纸箱、纸袋等</li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>废塑料</strong>：塑料瓶、塑料袋、塑料桶等</li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>废金属</strong>：易拉罐、金属罐、废铁等</li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>废玻璃</strong>：玻璃瓶、玻璃杯等</li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><strong>废织物</strong>：旧衣服、旧床单、旧毛巾等</li></ol><h2>投放要求</h2><p>1. 纸类应尽量叠放整齐，避免揉团</p><p>2. 塑料垃圾应清空内容物，清洁后压扁投放</p><p>3. 玻璃类应轻投轻放，有尖锐边角的应包裹后投放</p>', 'http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg', 7, 1, '0', 'admin', '2025-12-13 16:25:15', '', '2026-03-06 19:19:48');
INSERT INTO `garbage_knowledge_article` VALUES (2, 1, '废纸回收的环保意义', '<h2>废纸回收的重要性</h2>\r\n<p>废纸回收是资源循环利用的重要环节。据统计：</p>\r\n<ul>\r\n<li>1吨废纸可再造800公斤好纸</li>\r\n<li>相当于少砍17棵大树</li>\r\n<li>可节约用水100吨</li>\r\n<li>减少35%的水污染</li>\r\n</ul>\r\n<h2>哪些纸可以回收？</h2>\r\n<p>报纸、书本、纸箱、办公用纸、广告纸等干净的纸张都可以回收。</p>\r\n<h2>哪些纸不能回收？</h2>\r\n<p>卫生纸、餐巾纸、纸尿裤等已污染的纸张不能回收。</p>', 'http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg', 2, 2, '0', 'admin', '2025-12-13 16:25:15', '', '2025-12-16 13:56:45');
INSERT INTO `garbage_knowledge_article` VALUES (3, 2, '有害垃圾的危害与处理', '<h2>什么是有害垃圾？</h2>\r\n<p>有害垃圾是指对人体健康或自然环境造成直接或潜在危害的生活废弃物。</p>\r\n<h2>常见有害垃圾</h2>\r\n<ul>\r\n<li><strong>废电池</strong>：含汞、铅、镉等重金属</li>\r\n<li><strong>废灯管</strong>：含汞蒸气</li>\r\n<li><strong>废药品</strong>：含化学成分</li>\r\n<li><strong>废油漆</strong>：含有机溶剂</li>\r\n</ul>\r\n<h2>危害有多大？</h2>\r\n<p>1节废电池可以污染60万升水，相当于一个人一生的用水量！</p>', 'http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg', 3, 1, '0', 'admin', '2025-12-13 16:25:15', '', '2025-12-16 13:56:48');
INSERT INTO `garbage_knowledge_article` VALUES (4, 2, '废电池的正确处理方式', '<h2>废电池为什么有害？</h2>\r\n<p>电池中含有汞、铅、镉等重金属，这些物质会污染土壤和水源，进入食物链后危害人体健康。</p>\r\n<h2>如何正确处理？</h2>\r\n<ul>\r\n<li>保持电池完好，防止有害物质外漏</li>\r\n<li>投放到有害垃圾收集容器</li>\r\n<li>不要随意丢弃到普通垃圾桶</li>\r\n</ul>\r\n<h2>小贴士</h2>\r\n<p>尽量使用可充电电池，减少一次性电池的使用。</p>', 'http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg', 0, 2, '0', 'admin', '2025-12-13 16:25:15', '', '2025-12-16 11:38:55');
INSERT INTO `garbage_knowledge_article` VALUES (5, 3, '厨余垃圾的分类与处理', '<h2>什么是厨余垃圾？</h2>\r\n<p>厨余垃圾是指居民日常生活及食品加工中产生的垃圾，主要包括：</p>\r\n<ul>\r\n<li>剩菜剩饭</li>\r\n<li>果皮果核</li>\r\n<li>蛋壳</li>\r\n<li>茶叶渣</li>\r\n<li>菜叶菜根</li>\r\n</ul>\r\n<h2>投放要求</h2>\r\n<p>1. 沥干水分后投放</p>\r\n<p>2. 去除包装物后分类投放</p>\r\n<p>3. 纯流质食物直接倒入下水口</p>', 'http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg', 0, 1, '0', 'admin', '2025-12-13 16:25:15', '', '2025-12-16 11:38:55');
INSERT INTO `garbage_knowledge_article` VALUES (6, 3, '厨余垃圾堆肥小知识', '<h2>厨余垃圾可以变废为宝</h2>\r\n<p>厨余垃圾经过堆肥处理，可以变成有机肥料，用于种植花草蔬菜。</p>\r\n<h2>家庭堆肥方法</h2>\r\n<ul>\r\n<li>准备一个堆肥桶</li>\r\n<li>将厨余垃圾切碎</li>\r\n<li>加入适量土壤</li>\r\n<li>定期翻动</li>\r\n<li>2-3个月后即可使用</li>\r\n</ul>', 'http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg', 0, 2, '0', 'admin', '2025-12-13 16:25:15', '', '2025-12-16 11:38:55');
INSERT INTO `garbage_knowledge_article` VALUES (7, 4, '其他垃圾的正确投放', '<h2>什么是其他垃圾？</h2>\r\n<p>其他垃圾是指除可回收物、有害垃圾、厨余垃圾以外的其他生活废弃物。</p>\r\n<h2>常见其他垃圾</h2>\r\n<ul>\r\n<li>卫生纸、餐巾纸</li>\r\n<li>烟蒂</li>\r\n<li>陶瓷碎片</li>\r\n<li>一次性餐具</li>\r\n<li>大骨头、椰子壳</li>\r\n</ul>\r\n<h2>投放提示</h2>\r\n<p>在无法准确判断垃圾类别时，可投放到其他垃圾收集容器。</p>', 'http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg', 0, 1, '0', 'admin', '2025-12-13 16:25:15', '', '2025-12-16 11:38:55');
INSERT INTO `garbage_knowledge_article` VALUES (8, 4, '容易分错的垃圾', '<h2>这些垃圾容易分错</h2>\r\n<ul>\r\n<li><strong>卫生纸</strong>：虽然是纸，但属于其他垃圾</li>\r\n<li><strong>大骨头</strong>：虽然是厨余，但属于其他垃圾</li>\r\n<li><strong>椰子壳</strong>：虽然是果壳，但属于其他垃圾</li>\r\n<li><strong>一次性杯子</strong>：虽然是塑料，但难以回收</li>\r\n</ul>\r\n<h2>记忆口诀</h2>\r\n<p>能卖钱的蓝桶桶，易腐烂的绿桶桶，有毒有害红桶桶，没人要的灰桶桶。</p>', 'http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg', 0, 2, '0', 'admin', '2025-12-13 16:25:15', '', '2025-12-16 11:38:55');

-- ----------------------------
-- Table structure for garbage_quiz_question
-- ----------------------------
DROP TABLE IF EXISTS `garbage_quiz_question`;
CREATE TABLE `garbage_quiz_question`  (
  `question_id` bigint NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `article_id` bigint NULL DEFAULT NULL COMMENT '关联文章ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '关联分类ID',
  `question_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目内容',
  `option_a` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '选项A',
  `option_b` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '选项B',
  `option_c` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '选项C',
  `option_d` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '选项D',
  `correct_answer` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '正确答案（A/B/C/D）',
  `explanation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '答案解析',
  `points_value` int NULL DEFAULT 10 COMMENT '题目分值',
  `difficulty` tinyint NULL DEFAULT 1 COMMENT '难度等级（1简单 2中等 3困难）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`question_id`) USING BTREE,
  INDEX `idx_article_id`(`article_id` ASC) USING BTREE COMMENT '文章ID索引',
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE COMMENT '分类ID索引',
  INDEX `idx_difficulty`(`difficulty` ASC) USING BTREE COMMENT '难度索引',
  INDEX `idx_status`(`status` ASC) USING BTREE COMMENT '状态索引'
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '垃圾分类测验题目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of garbage_quiz_question
-- ----------------------------
INSERT INTO `garbage_quiz_question` VALUES (1, 1, 1, '以下哪种垃圾属于可回收物？', '卫生纸', '塑料瓶', '剩菜剩饭', '废电池', 'B', '塑料瓶是可回收物，可以回收再利用制成新的塑料制品。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (2, 1, 1, '废纸回收后可以用来做什么？', '填埋处理', '焚烧发电', '再造新纸', '制作肥料', 'C', '废纸可以回收再造成新纸，1吨废纸可再造800公斤好纸。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (3, 2, 1, '以下哪种纸张不能回收？', '报纸', '书本', '卫生纸', '纸箱', 'C', '卫生纸已经被污染，水溶性强，不能回收。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (4, 3, 2, '以下哪种垃圾属于有害垃圾？', '塑料袋', '废电池', '果皮', '旧衣服', 'B', '废电池含有汞、铅、镉等重金属，属于有害垃圾。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (5, 3, 2, '一节废电池可以污染多少升水？', '6升', '60升', '6000升', '60万升', 'D', '一节废电池可以污染60万升水，相当于一个人一生的用水量。', 10, 2, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (6, 4, 2, '过期药品应该如何处理？', '直接扔进垃圾桶', '冲入下水道', '投放到有害垃圾桶', '埋入土中', 'C', '过期药品属于有害垃圾，应投放到有害垃圾收集容器。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (7, 5, 3, '以下哪种垃圾属于厨余垃圾？', '大骨头', '蛋壳', '椰子壳', '卫生纸', 'B', '蛋壳属于厨余垃圾，可以堆肥处理。大骨头和椰子壳因为难以堆肥，属于其他垃圾。', 10, 2, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (8, 5, 3, '厨余垃圾投放前应该怎么做？', '直接投放', '沥干水分', '用塑料袋包好', '切碎后投放', 'B', '厨余垃圾投放前应沥干水分，减少异味和渗漏。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (9, 6, 3, '厨余垃圾堆肥后可以变成什么？', '塑料', '玻璃', '有机肥料', '金属', 'C', '厨余垃圾经过堆肥处理，可以变成有机肥料，用于种植。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (10, 7, 4, '以下哪种垃圾属于其他垃圾？', '塑料瓶', '废电池', '果皮', '卫生纸', 'D', '卫生纸虽然是纸，但已被污染且水溶性强，属于其他垃圾。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (11, 7, 4, '大骨头应该投放到哪个垃圾桶？', '可回收物', '有害垃圾', '厨余垃圾', '其他垃圾', 'D', '大骨头虽然是厨余，但因为难以堆肥，应投放到其他垃圾桶。', 10, 2, '0', 'admin', '2025-12-13 16:25:15', '', NULL);
INSERT INTO `garbage_quiz_question` VALUES (12, 8, 4, '垃圾分类的口诀是什么？', '红黄蓝绿四个桶', '能卖钱的蓝桶桶，易腐烂的绿桶桶', '大的小的分开放', '干的湿的分开放', 'B', '能卖钱的蓝桶桶（可回收），易腐烂的绿桶桶（厨余），有毒有害红桶桶，没人要的灰桶桶（其他）。', 10, 1, '0', 'admin', '2025-12-13 16:25:15', '', NULL);

-- ----------------------------
-- Table structure for garbage_recognition_record
-- ----------------------------
DROP TABLE IF EXISTS `garbage_recognition_record`;
CREATE TABLE `garbage_recognition_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原图URL',
  `thumbnail_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '缩略图URL',
  `recognized_item_id` bigint NULL DEFAULT NULL COMMENT '识别到的物品ID',
  `recognized_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '识别结果名称',
  `category_id` bigint NULL DEFAULT NULL COMMENT '分类ID',
  `confidence_score` decimal(5, 2) NULL DEFAULT NULL COMMENT '置信度（0-100）',
  `points_earned` int NULL DEFAULT 0 COMMENT '获得积分',
  `recognition_source` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '识别来源（1拍照 2相册）',
  `recognition_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '识别时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE COMMENT '用户ID索引',
  INDEX `idx_recognition_time`(`recognition_time` DESC) USING BTREE COMMENT '识别时间索引',
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE COMMENT '分类ID索引',
  INDEX `idx_recognized_item_id`(`recognized_item_id` ASC) USING BTREE COMMENT '物品ID索引',
  INDEX `idx_del_flag`(`del_flag` ASC) USING BTREE COMMENT '删除标志索引',
  INDEX `idx_user_time`(`user_id` ASC, `recognition_time` DESC) USING BTREE COMMENT '用户时间复合索引'
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '垃圾识别记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of garbage_recognition_record
-- ----------------------------
INSERT INTO `garbage_recognition_record` VALUES (1, 1, NULL, NULL, NULL, '屏幕截图', 4, 0.00, 0, '1', '2025-12-16 12:08:37', '0', '2025-12-16 12:08:37');
INSERT INTO `garbage_recognition_record` VALUES (2, 1, NULL, NULL, NULL, '屏幕截图', 4, 0.00, 0, '1', '2025-12-16 12:09:41', '0', '2025-12-16 12:09:41');
INSERT INTO `garbage_recognition_record` VALUES (3, 1, NULL, NULL, NULL, '玩具', 0, 0.00, 0, '1', '2025-12-16 12:11:10', '0', '2025-12-16 12:11:10');
INSERT INTO `garbage_recognition_record` VALUES (4, 1, NULL, NULL, NULL, '猪蹄（生）', 4, 0.00, 0, '1', '2025-12-16 12:15:25', '0', '2025-12-16 12:15:25');
INSERT INTO `garbage_recognition_record` VALUES (5, 1, NULL, NULL, NULL, '夫妻肺片', 4, 0.00, 0, '1', '2025-12-16 13:55:25', '0', '2025-12-16 13:55:25');
INSERT INTO `garbage_recognition_record` VALUES (6, 1, NULL, NULL, NULL, '书籍', 0, 0.00, 0, '1', '2025-12-17 17:59:53', '0', '2025-12-17 17:59:53');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (20, 'garbage_category', '垃圾分类类别表', NULL, NULL, 'GarbageCategory', 'crud', 'element-ui', 'com.yaoliyun.system', 'system', 'category', '垃圾分类类别', 'ruoyi', '0', '/', '{\"parentMenuId\":2179}', 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34', NULL);
INSERT INTO `gen_table` VALUES (21, 'garbage_item', '垃圾物品表', NULL, NULL, 'GarbageItem', 'crud', 'element-ui', 'com.yaoliyun.system', 'system', 'item', '垃圾物品', 'ruoyi', '0', '/', '{\"parentMenuId\":2179}', 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04', NULL);
INSERT INTO `gen_table` VALUES (23, 'garbage_knowledge_article', '垃圾分类知识文章表', NULL, NULL, 'GarbageKnowledgeArticle', 'crud', 'element-ui', 'com.yaoliyun.system', 'system', 'article', '垃圾分类知识文章', 'ruoyi', '0', '/', '{\"parentMenuId\":2179}', 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47', NULL);
INSERT INTO `gen_table` VALUES (24, 'garbage_quiz_question', '垃圾分类测验题目表', NULL, NULL, 'GarbageQuizQuestion', 'crud', 'element-ui', 'com.yaoliyun.system', 'system', 'question', '垃圾分类测验题目', 'ruoyi', '0', '/', '{\"parentMenuId\":2179}', 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23', NULL);
INSERT INTO `gen_table` VALUES (25, 'garbage_recognition_record', '垃圾识别记录表', NULL, NULL, 'GarbageRecognitionRecord', 'crud', 'element-ui', 'com.yaoliyun.system', 'system', 'record', '垃圾识别记录', 'ruoyi', '0', '/', '{\"parentMenuId\":2179}', 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19', NULL);
INSERT INTO `gen_table` VALUES (28, 'sys_user', '用户信息表', NULL, NULL, 'SysUser', 'crud', '', 'com.yaoliyun.system', 'system', 'user', '用户信息', 'ruoyi', '0', '/', NULL, 'admin', '2025-12-16 10:02:23', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `is_foreign_key` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否外键（1是 0否）',
  `foreign_table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联表名',
  `foreign_column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联字段名',
  `foreign_display_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'name' COMMENT '关联表显示字段',
  `foreign_display_field_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联字段自定义名称（Java属性名）',
  `foreign_display_field_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '外键显示字段配置（JSON格式，包含每个显示字段的列表显示、查询等配置）',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 194 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (78, 20, 'category_id', '类别ID', 'bigint', 'Long', 'categoryId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 1, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (79, 20, 'category_name', '类别名称', 'varchar(50)', 'String', 'categoryName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 2, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (80, 20, 'category_code', '类别编码', 'varchar(20)', 'String', 'categoryCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 3, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (81, 20, 'description', '类别描述', 'varchar(500)', 'String', 'description', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', '0', NULL, NULL, 'name', NULL, NULL, 4, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (82, 20, 'icon_url', '图标URL', 'varchar(255)', 'String', 'iconUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'imageUpload', '', '0', NULL, NULL, 'name', NULL, NULL, 5, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (83, 20, 'color_code', '颜色代码', 'varchar(20)', 'String', 'colorCode', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 6, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (84, 20, 'disposal_guidelines', '处理指南', 'text', 'String', 'disposalGuidelines', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', '0', NULL, NULL, 'name', NULL, NULL, 7, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (85, 20, 'sort_order', '排序号', 'int', 'Long', 'sortOrder', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 8, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (86, 20, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'sys_normal_disable', '0', NULL, NULL, 'name', NULL, NULL, 9, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (87, 20, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 10, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (88, 20, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 11, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (89, 20, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 12, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (90, 20, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 13, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (91, 20, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', '0', NULL, NULL, 'name', NULL, NULL, 14, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:09:34');
INSERT INTO `gen_table_column` VALUES (92, 21, 'item_id', '物品ID', 'bigint', 'Long', 'itemId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 1, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (93, 21, 'category_id', '所属类别ID（关联垃圾分类类别表）', 'bigint', 'Long', 'categoryId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', '1', 'garbage_category', 'category_id', 'category_name', 'categoryName', '[{\"foreignField\":\"category_name\",\"javaFieldName\":\"categoryName\",\"fieldComment\":\"类别名称\",\"isList\":\"1\",\"isQuery\":\"0\",\"queryType\":\"EQ\"}]', 2, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (94, 21, 'item_name', '物品名称', 'varchar(100)', 'String', 'itemName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 3, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (95, 21, 'item_name_pinyin', '名称拼音', 'varchar(200)', 'String', 'itemNamePinyin', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 4, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (96, 21, 'disposal_suggestion', '处理建议', 'text', 'String', 'disposalSuggestion', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', '0', NULL, NULL, 'name', NULL, NULL, 5, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (97, 21, 'image_url', '物品图片URL', 'varchar(255)', 'String', 'imageUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'imageUpload', '', '0', NULL, NULL, 'name', NULL, NULL, 6, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (98, 21, 'environmental_tips', '环保小贴士', 'text', 'String', 'environmentalTips', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', '0', NULL, NULL, 'name', NULL, NULL, 7, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (99, 21, 'search_count', '搜索次数', 'int', 'Long', 'searchCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 8, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (100, 21, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'sys_normal_disable', '0', NULL, NULL, 'name', NULL, NULL, 9, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (101, 21, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 10, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (102, 21, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 11, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (103, 21, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 12, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (104, 21, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 13, 'admin', '2025-12-16 10:02:13', '', '2025-12-16 10:13:04');
INSERT INTO `gen_table_column` VALUES (110, 23, 'article_id', '文章ID', 'bigint', 'Long', 'articleId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 1, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (111, 23, 'category_id', '关联分类ID', 'bigint', 'Long', 'categoryId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', '1', 'garbage_category', 'category_id', 'category_name', 'categoryName', '[{\"foreignField\":\"category_name\",\"javaFieldName\":\"categoryName\",\"fieldComment\":\"类别名称\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}]', 2, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (112, 23, 'title', '文章标题', 'varchar(200)', 'String', 'title', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 3, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (113, 23, 'content', '文章内容', 'text', 'String', 'content', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'editor', '', '0', NULL, NULL, 'name', NULL, NULL, 4, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (114, 23, 'cover_image', '封面图片', 'varchar(255)', 'String', 'coverImage', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'imageUpload', '', '0', NULL, NULL, 'name', NULL, NULL, 5, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (115, 23, 'view_count', '浏览次数', 'int', 'Long', 'viewCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 6, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (116, 23, 'sort_order', '排序号', 'int', 'Long', 'sortOrder', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 7, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (117, 23, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'sys_normal_disable', '0', NULL, NULL, 'name', NULL, NULL, 8, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (118, 23, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 9, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (119, 23, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 10, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (120, 23, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 11, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (121, 23, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 12, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:04:47');
INSERT INTO `gen_table_column` VALUES (122, 24, 'question_id', '题目ID', 'bigint', 'Long', 'questionId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 1, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (123, 24, 'article_id', '关联文章ID', 'bigint', 'Long', 'articleId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', '1', 'garbage_knowledge_article', 'article_id', 'title', 'title', '[{\"foreignField\":\"title\",\"javaFieldName\":\"title\",\"fieldComment\":\"文章标题\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}]', 2, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (124, 24, 'category_id', '关联分类ID', 'bigint', 'Long', 'categoryId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', '1', 'garbage_category', 'category_id', 'category_name', 'categoryName', '[{\"foreignField\":\"category_name\",\"javaFieldName\":\"categoryName\",\"fieldComment\":\"类别名称\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}]', 3, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (125, 24, 'question_content', '题目内容', 'text', 'String', 'questionContent', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'textarea', '', '0', NULL, NULL, 'name', NULL, NULL, 4, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (126, 24, 'option_a', '选项A', 'varchar(200)', 'String', 'optionA', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 5, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (127, 24, 'option_b', '选项B', 'varchar(200)', 'String', 'optionB', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 6, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (128, 24, 'option_c', '选项C', 'varchar(200)', 'String', 'optionC', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 7, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (129, 24, 'option_d', '选项D', 'varchar(200)', 'String', 'optionD', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 8, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (130, 24, 'correct_answer', '正确答案（A/B/C/D）', 'char(1)', 'String', 'correctAnswer', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 9, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (131, 24, 'explanation', '答案解析', 'text', 'String', 'explanation', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'checkbox', '', '0', NULL, NULL, 'name', NULL, NULL, 10, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (132, 24, 'points_value', '题目分值', 'int', 'Long', 'pointsValue', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 11, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (133, 24, 'difficulty', '难度等级（1简单 2中等 3困难）', 'tinyint', 'Long', 'difficulty', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'quiz_difficulty', '0', NULL, NULL, 'name', NULL, NULL, 12, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (134, 24, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', 'sys_normal_disable', '0', NULL, NULL, 'name', NULL, NULL, 13, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (135, 24, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 14, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (136, 24, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 15, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (137, 24, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 16, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (138, 24, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 17, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 11:31:23');
INSERT INTO `gen_table_column` VALUES (139, 25, 'record_id', '记录ID', 'bigint', 'Long', 'recordId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 1, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (140, 25, 'user_id', '用户ID', 'bigint', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', '', '1', 'sys_user', 'user_id', 'nick_name', 'nickName', '[{\"foreignField\":\"nick_name\",\"javaFieldName\":\"nickName\",\"fieldComment\":\"用户昵称\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}]', 2, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (141, 25, 'image_url', '原图URL', 'varchar(255)', 'String', 'imageUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'imageUpload', '', '0', NULL, NULL, 'name', NULL, NULL, 3, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (142, 25, 'thumbnail_url', '缩略图URL', 'varchar(255)', 'String', 'thumbnailUrl', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'imageUpload', '', '0', NULL, NULL, 'name', NULL, NULL, 4, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (143, 25, 'recognized_item_id', '识别到的物品ID', 'bigint', 'Long', 'recognizedItemId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 5, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (144, 25, 'recognized_name', '识别结果名称', 'varchar(100)', 'String', 'recognizedName', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 6, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (145, 25, 'category_id', '分类ID', 'bigint', 'Long', 'categoryId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', '1', 'garbage_category', 'category_id', 'category_name', 'categoryName', '[{\"foreignField\":\"category_name\",\"javaFieldName\":\"categoryName\",\"fieldComment\":\"类别名称\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}]', 7, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (146, 25, 'confidence_score', '置信度（0-100）', 'decimal(5,2)', 'BigDecimal', 'confidenceScore', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 8, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (147, 25, 'points_earned', '获得积分', 'int', 'Long', 'pointsEarned', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 9, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (148, 25, 'recognition_source', '识别来源（1拍照 2相册）', 'char(1)', 'String', 'recognitionSource', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', 'garbage_recognition_source', '0', NULL, NULL, 'name', NULL, NULL, 10, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (149, 25, 'recognition_time', '识别时间', 'datetime', 'Date', 'recognitionTime', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 11, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (150, 25, 'del_flag', '删除标志（0存在 2删除）', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 12, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (151, 25, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 13, 'admin', '2025-12-16 10:02:14', '', '2025-12-16 10:08:19');
INSERT INTO `gen_table_column` VALUES (167, 28, 'user_id', '用户ID', 'bigint', 'Long', 'userId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 1, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (168, 28, 'dept_id', '部门ID', 'bigint', 'Long', 'deptId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 2, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (169, 28, 'user_name', '用户账号', 'varchar(30)', 'String', 'userName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 3, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (170, 28, 'nick_name', '用户昵称', 'varchar(30)', 'String', 'nickName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 4, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (171, 28, 'user_type', '用户类型（00系统用户）', 'varchar(2)', 'String', 'userType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', '0', NULL, NULL, 'name', NULL, NULL, 5, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (172, 28, 'email', '用户邮箱', 'varchar(50)', 'String', 'email', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 6, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (173, 28, 'phonenumber', '手机号码', 'varchar(11)', 'String', 'phonenumber', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 7, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (174, 28, 'sex', '用户性别（0男 1女 2未知）', 'char(1)', 'String', 'sex', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', '0', NULL, NULL, 'name', NULL, NULL, 8, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (175, 28, 'avatar', '头像地址', 'varchar(512)', 'String', 'avatar', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', '0', NULL, NULL, 'name', NULL, NULL, 9, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (176, 28, 'password', '密码', 'varchar(100)', 'String', 'password', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 10, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (177, 28, 'status', '账号状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', '0', NULL, NULL, 'name', NULL, NULL, 11, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (178, 28, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 12, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (179, 28, 'login_ip', '最后登录IP', 'varchar(128)', 'String', 'loginIp', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 13, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (180, 28, 'login_date', '最后登录时间', 'datetime', 'Date', 'loginDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 14, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (181, 28, 'pwd_update_date', '密码最后更新时间', 'datetime', 'Date', 'pwdUpdateDate', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 15, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (182, 28, 'wechat_openid', '微信openid', 'varchar(64)', 'String', 'wechatOpenid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 16, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (183, 28, 'wechat_unionid', '微信unionid', 'varchar(64)', 'String', 'wechatUnionid', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 17, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (184, 28, 'wechat_session_key', '微信会话密钥', 'varchar(64)', 'String', 'wechatSessionKey', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 18, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (185, 28, 'login_type', '登录类型（password密码登录 wechat微信登录）', 'varchar(10)', 'String', 'loginType', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', '', '0', NULL, NULL, 'name', NULL, NULL, 19, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (186, 28, 'total_points', '总积分', 'int', 'Long', 'totalPoints', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 20, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (187, 28, 'user_level', '用户等级', 'int', 'Long', 'userLevel', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 21, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (188, 28, 'recognition_count', '识别次数', 'int', 'Long', 'recognitionCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 22, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (189, 28, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 23, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (190, 28, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 24, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (191, 28, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', '0', NULL, NULL, 'name', NULL, NULL, 25, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (192, 28, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', '0', NULL, NULL, 'name', NULL, NULL, 26, 'admin', '2025-12-16 10:02:23', '', NULL);
INSERT INTO `gen_table_column` VALUES (193, 28, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', '0', NULL, NULL, 'name', NULL, NULL, 27, 'admin', '2025-12-16 10:02:23', '', NULL);

-- ----------------------------
-- Table structure for gen_table_foreign_key
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_foreign_key`;
CREATE TABLE `gen_table_foreign_key`  (
  `fk_id` bigint NOT NULL AUTO_INCREMENT COMMENT '外键ID',
  `table_id` bigint NOT NULL COMMENT '表ID',
  `column_id` bigint NULL DEFAULT NULL COMMENT '字段ID',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字段名称（外键字段）',
  `ref_table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联表名',
  `ref_column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联字段名',
  `ref_table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联表注释',
  `ref_column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联字段注释',
  `ref_class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联表类名',
  `ref_java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联表Java字段名',
  `ref_display_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'name' COMMENT '关联表显示字段（用于下拉框显示）',
  `ref_display_field_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联字段自定义名称（Java属性名）',
  `constraint_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '约束名称',
  `is_enabled` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否启用关联（1是 0否）',
  `relation_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N:1' COMMENT '关联类型（1:1单对一，1:N单对多，N:1多对一，N:N多对多）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（EQ等于、NE不等于、GT大于、LT小于、LIKE模糊、BETWEEN范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'select' COMMENT '显示类型（select下拉框、radio单选框等）',
  `field_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外键字段描述（用于页面显示的中文名称）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`fk_id`) USING BTREE,
  INDEX `idx_table_id`(`table_id` ASC) USING BTREE,
  INDEX `idx_column_id`(`column_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成外键关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_foreign_key
-- ----------------------------
INSERT INTO `gen_table_foreign_key` VALUES (2, 11, 35, 'test_id', 'yaoliyun_test', 'id', '测试', '编号', 'YaoliyunTest', 'id', 'name', NULL, 'fk_test_main_test_id', '1', 'N:1', '1', '0', 'EQ', 'select', NULL, 'admin', '2025-10-18 11:00:37', '', NULL);
INSERT INTO `gen_table_foreign_key` VALUES (3, 12, 38, 'test_id', 'yaoliyun_test', 'id', '测试', '编号', 'YaoliyunTest', 'id', 'name', NULL, 'fk_test_main_test_id', '1', 'N:1', '1', '0', 'EQ', 'select', NULL, 'admin', '2025-10-18 11:16:04', '', NULL);
INSERT INTO `gen_table_foreign_key` VALUES (4, 13, 41, 'test_id', 'yaoliyun_test', 'id', '测试', '编号', 'YaoliyunTest', 'id', 'name', NULL, 'fk_test_main_test_id', '1', 'N:1', '1', '0', 'EQ', 'select', NULL, 'admin', '2025-10-18 11:29:28', '', NULL);
INSERT INTO `gen_table_foreign_key` VALUES (5, 14, 44, 'test_id', 'yaoliyun_test', 'id', '测试', '编号', 'YaoliyunTest', 'id', 'name', NULL, 'fk_test_main_test_id', '1', 'N:1', '1', '0', 'EQ', 'select', NULL, 'admin', '2025-10-18 11:32:12', '', NULL);
INSERT INTO `gen_table_foreign_key` VALUES (6, 21, 93, 'category_id', 'garbage_category', 'category_id', '垃圾分类类别表', '类别ID', 'GarbageCategory', 'categoryId', 'name', NULL, 'fk_item_category', '1', 'N:1', '1', '0', 'EQ', 'select', NULL, 'admin', '2025-12-16 10:02:13', '', NULL);
INSERT INTO `gen_table_foreign_key` VALUES (7, 22, 106, 'item_id', 'garbage_item', 'item_id', '垃圾物品表', '物品ID', 'GarbageItem', 'itemId', 'name', NULL, 'fk_keyword_item', '1', 'N:1', '1', '0', 'EQ', 'select', NULL, 'admin', '2025-12-16 10:02:13', '', NULL);

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-08-07 11:38:58', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-08-07 11:38:58', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-08-07 11:38:58', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-08-07 11:38:58', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2025-08-07 11:38:58', 'admin', '2025-08-07 12:29:17', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-08-07 11:38:58', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2025-08-07 11:38:58', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2025-08-07 11:38:58', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (100, 'UniApp项目路径', 'uniapp.project.path', '../yaoliyun-uniapp', 'Y', 'admin', '2025-08-24 17:16:44', '', NULL, 'UniApp项目的相对路径，用于页面文件操作');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '瑶力云科技', 0, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '瑶力云', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 247 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 1, '正常', '0', 'uniapp_page_status', '', 'primary', 'Y', '0', 'admin', '2025-08-24 17:16:44', '', NULL, '页面正常状态');
INSERT INTO `sys_dict_data` VALUES (101, 2, '停用', '1', 'uniapp_page_status', '', 'danger', 'N', '0', 'admin', '2025-08-24 17:16:44', '', NULL, '页面停用状态');
INSERT INTO `sys_dict_data` VALUES (102, 1, '默认', 'default', 'uniapp_navigation_style', '', 'primary', 'Y', '0', 'admin', '2025-08-24 17:16:44', '', NULL, '默认导航栏样式');
INSERT INTO `sys_dict_data` VALUES (103, 2, '自定义', 'custom', 'uniapp_navigation_style', '', 'info', 'N', '0', 'admin', '2025-08-24 17:16:44', '', NULL, '自定义导航栏样式');
INSERT INTO `sys_dict_data` VALUES (104, 1, '否', '0', 'uniapp_is_tabbar', '', 'info', 'Y', '0', 'admin', '2025-08-24 17:16:44', '', NULL, '非TabBar页面');
INSERT INTO `sys_dict_data` VALUES (105, 2, '是', '1', 'uniapp_is_tabbar', '', 'success', 'N', '0', 'admin', '2025-08-24 17:16:44', '', NULL, 'TabBar页面');
INSERT INTO `sys_dict_data` VALUES (214, 1, '首页', 'index', 'sys_template_type', '', 'primary', 'Y', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '首页模板');
INSERT INTO `sys_dict_data` VALUES (215, 2, '列表页', 'list', 'sys_template_type', '', 'success', 'N', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '列表页模板');
INSERT INTO `sys_dict_data` VALUES (216, 3, '详情页', 'detail', 'sys_template_type', '', 'info', 'N', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '详情页模板');
INSERT INTO `sys_dict_data` VALUES (217, 4, '表单页', 'form', 'sys_template_type', '', 'warning', 'N', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '表单页模板');
INSERT INTO `sys_dict_data` VALUES (218, 5, '登录页', 'login', 'sys_template_type', '', 'danger', 'N', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '登录页模板');
INSERT INTO `sys_dict_data` VALUES (219, 6, '用户中心', 'user', 'sys_template_type', '', 'purple', 'N', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '用户中心模板');
INSERT INTO `sys_dict_data` VALUES (220, 1, '通用', 'common', 'sys_template_category', '', 'primary', 'Y', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '通用模板');
INSERT INTO `sys_dict_data` VALUES (221, 2, '电商', 'ecommerce', 'sys_template_category', '', 'success', 'N', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '电商类模板');
INSERT INTO `sys_dict_data` VALUES (222, 3, '社交', 'social', 'sys_template_category', '', 'info', 'N', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '社交类模板');
INSERT INTO `sys_dict_data` VALUES (223, 4, '工具', 'tool', 'sys_template_category', '', 'warning', 'N', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '工具类模板');
INSERT INTO `sys_dict_data` VALUES (224, 5, '房地产', 'house', 'sys_template_category', NULL, 'danger', 'N', '0', 'admin', '2025-09-03 10:21:48', 'admin', '2025-09-03 10:22:10', '房地产模板');
INSERT INTO `sys_dict_data` VALUES (225, 6, '旅游', 'travel', 'sys_template_category', NULL, 'success', 'N', '0', 'admin', '2025-09-03 16:08:05', 'admin', '2025-09-03 16:08:12', NULL);
INSERT INTO `sys_dict_data` VALUES (226, 7, '金融', 'money', 'sys_template_category', NULL, 'warning', 'N', '0', 'admin', '2025-09-03 16:13:19', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (227, 8, '教育', 'education', 'sys_template_category', NULL, 'danger', 'N', '0', 'admin', '2025-09-03 16:20:40', 'admin', '2025-09-03 16:20:48', NULL);
INSERT INTO `sys_dict_data` VALUES (228, 1, '可回收物', 'recyclable', 'garbage_category_type', '', 'primary', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '可回收物');
INSERT INTO `sys_dict_data` VALUES (229, 2, '有害垃圾', 'hazardous', 'garbage_category_type', '', 'danger', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '有害垃圾');
INSERT INTO `sys_dict_data` VALUES (230, 3, '厨余垃圾', 'kitchen', 'garbage_category_type', '', 'success', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '厨余垃圾');
INSERT INTO `sys_dict_data` VALUES (231, 4, '其他垃圾', 'other', 'garbage_category_type', '', 'info', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '其他垃圾');
INSERT INTO `sys_dict_data` VALUES (232, 1, '拍照识别', '1', 'garbage_recognition_source', '', 'primary', 'Y', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '通过拍照进行识别');
INSERT INTO `sys_dict_data` VALUES (233, 2, '相册上传', '2', 'garbage_recognition_source', '', 'success', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '从相册上传图片识别');
INSERT INTO `sys_dict_data` VALUES (234, 1, '识别奖励', 'recognition', 'points_change_type', '', 'primary', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '垃圾识别获得积分');
INSERT INTO `sys_dict_data` VALUES (235, 2, '答题奖励', 'quiz', 'points_change_type', '', 'success', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '答题正确获得积分');
INSERT INTO `sys_dict_data` VALUES (236, 3, '兑换消耗', 'exchange', 'points_change_type', '', 'warning', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '积分兑换消耗');
INSERT INTO `sys_dict_data` VALUES (237, 4, '管理员调整', 'admin', 'points_change_type', '', 'info', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '管理员手动调整积分');
INSERT INTO `sys_dict_data` VALUES (238, 5, '签到奖励', 'checkin', 'points_change_type', '', 'primary', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '每日签到获得积分');
INSERT INTO `sys_dict_data` VALUES (239, 1, '环保新手', '1', 'user_level_type', '', 'info', 'Y', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '0-99积分');
INSERT INTO `sys_dict_data` VALUES (240, 2, '环保达人', '2', 'user_level_type', '', 'primary', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '100-499积分');
INSERT INTO `sys_dict_data` VALUES (241, 3, '环保卫士', '3', 'user_level_type', '', 'success', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '500-1999积分');
INSERT INTO `sys_dict_data` VALUES (242, 4, '环保先锋', '4', 'user_level_type', '', 'warning', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '2000-4999积分');
INSERT INTO `sys_dict_data` VALUES (243, 5, '环保大使', '5', 'user_level_type', '', 'danger', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '5000积分以上');
INSERT INTO `sys_dict_data` VALUES (244, 1, '简单', '1', 'quiz_difficulty', '', 'success', 'Y', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '简单难度');
INSERT INTO `sys_dict_data` VALUES (245, 2, '中等', '2', 'quiz_difficulty', '', 'warning', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '中等难度');
INSERT INTO `sys_dict_data` VALUES (246, 3, '困难', '3', 'quiz_difficulty', '', 'danger', 'N', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '困难难度');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '页面状态', 'uniapp_page_status', '0', 'admin', '2025-08-24 17:16:44', '', NULL, 'UniApp页面状态字典');
INSERT INTO `sys_dict_type` VALUES (101, '导航栏样式', 'uniapp_navigation_style', '0', 'admin', '2025-08-24 17:16:44', '', NULL, 'UniApp导航栏样式字典');
INSERT INTO `sys_dict_type` VALUES (102, '是否TabBar页面', 'uniapp_is_tabbar', '0', 'admin', '2025-08-24 17:16:44', '', NULL, '是否为TabBar页面字典');
INSERT INTO `sys_dict_type` VALUES (105, '页面模板类型', 'sys_template_type', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '页面模板类型字典');
INSERT INTO `sys_dict_type` VALUES (106, '页面模板分类', 'sys_template_category', '0', 'admin', '2025-01-26 10:45:00', '', NULL, '页面模板分类字典');
INSERT INTO `sys_dict_type` VALUES (107, '垃圾分类类型', 'garbage_category_type', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '垃圾分类类型字典');
INSERT INTO `sys_dict_type` VALUES (108, '识别来源', 'garbage_recognition_source', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '垃圾识别来源字典');
INSERT INTO `sys_dict_type` VALUES (109, '积分变化类型', 'points_change_type', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '用户积分变化类型字典');
INSERT INTO `sys_dict_type` VALUES (110, '用户等级', 'user_level_type', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '用户等级字典');
INSERT INTO `sys_dict_type` VALUES (111, '题目难度', 'quiz_difficulty', '0', 'admin', '2025-12-13 16:24:40', '', NULL, '测验题目难度字典');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-08-07 11:38:58', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (1, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-10-24 12:28:39');
INSERT INTO `sys_logininfor` VALUES (2, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-24 12:29:07');
INSERT INTO `sys_logininfor` VALUES (3, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 11:44:34');
INSERT INTO `sys_logininfor` VALUES (4, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 11:50:03');
INSERT INTO `sys_logininfor` VALUES (5, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 12:12:41');
INSERT INTO `sys_logininfor` VALUES (6, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 12:13:05');
INSERT INTO `sys_logininfor` VALUES (7, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 12:14:54');
INSERT INTO `sys_logininfor` VALUES (8, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 13:19:03');
INSERT INTO `sys_logininfor` VALUES (9, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 13:41:51');
INSERT INTO `sys_logininfor` VALUES (10, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 13:42:24');
INSERT INTO `sys_logininfor` VALUES (11, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-01 14:52:36');
INSERT INTO `sys_logininfor` VALUES (12, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-02 12:22:19');
INSERT INTO `sys_logininfor` VALUES (13, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-02 12:29:38');
INSERT INTO `sys_logininfor` VALUES (14, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-11-02 12:53:22');
INSERT INTO `sys_logininfor` VALUES (15, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-11-06 11:44:55');
INSERT INTO `sys_logininfor` VALUES (16, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 11:45:40');
INSERT INTO `sys_logininfor` VALUES (17, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 12:18:13');
INSERT INTO `sys_logininfor` VALUES (18, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-11-06 12:38:23');
INSERT INTO `sys_logininfor` VALUES (19, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 12:38:31');
INSERT INTO `sys_logininfor` VALUES (20, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 13:21:59');
INSERT INTO `sys_logininfor` VALUES (21, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-11 17:22:32');
INSERT INTO `sys_logininfor` VALUES (22, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-11 19:11:35');
INSERT INTO `sys_logininfor` VALUES (23, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-11-14 10:47:46');
INSERT INTO `sys_logininfor` VALUES (24, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-14 10:47:55');
INSERT INTO `sys_logininfor` VALUES (25, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-14 11:10:44');
INSERT INTO `sys_logininfor` VALUES (26, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-13 16:00:47');
INSERT INTO `sys_logininfor` VALUES (27, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-16 10:01:07');
INSERT INTO `sys_logininfor` VALUES (28, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-16 11:30:43');
INSERT INTO `sys_logininfor` VALUES (29, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-16 11:34:14');
INSERT INTO `sys_logininfor` VALUES (30, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-16 13:40:27');
INSERT INTO `sys_logininfor` VALUES (31, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-16 13:51:32');
INSERT INTO `sys_logininfor` VALUES (32, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-16 13:57:20');
INSERT INTO `sys_logininfor` VALUES (33, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-12-16 14:02:52');
INSERT INTO `sys_logininfor` VALUES (34, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2025-12-16 14:06:09');
INSERT INTO `sys_logininfor` VALUES (35, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-16 14:06:14');
INSERT INTO `sys_logininfor` VALUES (36, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '退出成功', '2025-12-16 14:07:57');
INSERT INTO `sys_logininfor` VALUES (37, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-16 14:08:37');
INSERT INTO `sys_logininfor` VALUES (38, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-17 17:57:33');
INSERT INTO `sys_logininfor` VALUES (39, 'admin', '127.0.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-17 18:02:42');
INSERT INTO `sys_logininfor` VALUES (40, 'admin', '127.0.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2026-03-06 19:19:39');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2210 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-08-07 11:38:58', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '1', '0', '', 'monitor', 'admin', '2025-08-07 11:38:58', 'admin', '2025-12-13 16:00:58', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '1', '0', '', 'tool', 'admin', '2025-08-07 11:38:58', 'admin', '2025-12-17 18:02:53', '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '瑶力云官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '1', '0', '', 'guide', 'admin', '2025-08-07 11:38:58', 'admin', '2025-10-24 12:08:52', '瑶力云官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-08-07 11:38:58', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-08-07 11:38:58', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-08-07 11:38:58', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '1', '0', 'system:dept:list', 'tree', 'admin', '2025-08-07 11:38:58', 'admin', '2025-12-13 16:01:07', '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '1', '0', 'system:post:list', 'post', 'admin', '2025-08-07 11:38:58', 'admin', '2025-12-13 16:01:13', '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-08-07 11:38:58', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-08-07 11:38:58', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-08-07 11:38:58', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-08-07 11:38:58', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-08-07 11:38:58', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-08-07 11:38:58', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-08-07 11:38:58', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-08-07 11:38:58', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-08-07 11:38:58', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-08-07 11:38:58', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-08-07 11:38:58', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-08-07 11:38:58', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-08-07 11:38:58', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-08-07 11:38:58', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-08-07 11:38:58', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '聊天管理', 0, 6, 'chat', NULL, NULL, '', 1, 0, 'M', '1', '0', '', 'message', 'admin', '2025-08-17 21:04:01', 'admin', '2025-10-24 12:24:10', '聊天管理目录');
INSERT INTO `sys_menu` VALUES (2001, '聊天消息', 2000, 1, 'message', 'system/chat/message/index', NULL, '', 1, 0, 'C', '0', '0', 'system:chat:list', 'wechat', 'admin', '2025-08-17 21:04:01', 'admin', '2025-08-18 17:56:32', '聊天消息菜单');
INSERT INTO `sys_menu` VALUES (2002, '聊天消息查询', 2001, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:query', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, '聊天消息新增', 2001, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:add', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, '聊天消息修改', 2001, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:edit', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '聊天消息删除', 2001, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:remove', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '聊天消息导出', 2001, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:export', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '聊天会话', 2000, 2, 'session', 'system/chat/session/index', NULL, '', 1, 0, 'C', '0', '0', 'system:chat:list', 'peoples', 'admin', '2025-08-17 21:04:01', '', NULL, '聊天会话菜单');
INSERT INTO `sys_menu` VALUES (2008, '聊天会话查询', 2007, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:query', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '聊天会话新增', 2007, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:add', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '聊天会话修改', 2007, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:edit', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '聊天会话删除', 2007, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'system:chat:remove', '', 'admin', '2025-08-17 21:04:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, 'WebSocket管理', 2000, 3, 'websocket', 'system/chat/websocket/index', NULL, '', 1, 0, 'C', '0', '0', 'system:chat:list', 'link', 'admin', '2025-08-17 21:20:39', '', NULL, 'WebSocket管理菜单');
INSERT INTO `sys_menu` VALUES (2013, '页面管理', 2025, 6, 'uniappPage', 'system/uniappPage/index', '', '', 1, 0, 'C', '0', '0', 'system:uniappPage:list', 'phone', 'admin', '2025-08-24 17:16:44', 'admin', '2025-08-26 10:39:45', 'UniApp页面管理菜单');
INSERT INTO `sys_menu` VALUES (2014, 'UniApp页面查询', 2013, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:query', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, 'UniApp页面新增', 2013, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:add', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, 'UniApp页面修改', 2013, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:edit', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, 'UniApp页面删除', 2013, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:remove', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, 'UniApp页面导出', 2013, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:export', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2019, '创建页面文件', 2013, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:create', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '删除页面文件', 2013, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:delete', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '同步页面配置', 2013, 8, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:sync', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '更新页面配置', 2013, 9, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:update', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '备份页面配置', 2013, 10, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:backup', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '验证页面路径', 2013, 11, '', '', '', '', 1, 0, 'F', '0', '0', 'system:uniappPage:validate', '', 'admin', '2025-08-24 17:16:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2025, '移动端管理', 0, 2, 'uniapp', NULL, NULL, '', 1, 0, 'M', '1', '0', '', 'wechat', 'admin', '2025-08-26 10:39:24', 'admin', '2025-10-24 12:08:43', '');
INSERT INTO `sys_menu` VALUES (2039, '页面模板管理', 0, 2, 'pageTemplate', NULL, NULL, '', 1, 0, 'M', '1', '0', '', 'clipboard', 'admin', '2025-01-26 11:00:00', 'admin', '2025-10-24 12:08:48', '页面模板管理目录');
INSERT INTO `sys_menu` VALUES (2040, '模板管理', 2039, 1, 'template', 'system/pageTemplate/index', NULL, '', 1, 0, 'C', '0', '0', 'system:pageTemplate:list', 'list', 'admin', '2025-01-26 11:00:00', 'admin', '2025-08-26 11:16:14', '页面模板管理菜单');
INSERT INTO `sys_menu` VALUES (2041, '模板分类', 2039, 2, 'category', 'system/pageTemplate/category', NULL, '', 1, 0, 'C', '0', '0', 'system:pageTemplate:category', 'cascader', 'admin', '2025-01-26 11:00:00', 'admin', '2025-08-26 11:16:33', '模板分类管理菜单');
INSERT INTO `sys_menu` VALUES (2042, '模板统计', 2039, 3, 'statistics', 'system/pageTemplate/statistics', NULL, '', 1, 0, 'C', '0', '0', 'system:pageTemplate:statistics', 'chart', 'admin', '2025-01-26 11:00:00', 'admin', '2025-08-26 11:16:49', '模板使用统计菜单');
INSERT INTO `sys_menu` VALUES (2043, '模板查询', 2, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:query', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '模板新增', 2, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:add', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '模板修改', 2, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:edit', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '模板删除', 2, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:remove', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '模板导出', 2, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:export', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '复制代码', 2, 6, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:copy', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2049, '使用模板', 2, 7, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:use', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '分类查询', 3, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:category:query', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '分类新增', 3, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:category:add', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '分类修改', 3, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:category:edit', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '分类删除', 3, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:pageTemplate:category:remove', '#', 'admin', '2025-01-26 11:00:00', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '数据库管理', 3, 4, 'dbmanage', 'tool/dbmanage/index', NULL, '', 1, 0, 'C', '0', '0', 'tool:dbmanage:list', 'cascader', 'admin', '2025-09-05 17:45:59', 'admin', '2025-09-05 20:46:15', '数据库管理菜单');
INSERT INTO `sys_menu` VALUES (2061, '数据库管理查询', 2060, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:query', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '数据库管理新增', 2060, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:add', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '数据库管理修改', 2060, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:edit', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '数据库管理删除', 2060, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:remove', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2065, '数据库管理导出', 2060, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:export', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2066, 'SQL执行', 2060, 6, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:execute', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2067, '表操作', 2060, 7, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:table', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2068, '字段管理', 2060, 8, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:column', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '索引管理', 2060, 9, '', '', NULL, '', 1, 0, 'F', '0', '0', 'tool:dbmanage:index', '#', 'admin', '2025-09-05 17:45:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2179, '垃圾分类识别管理', 0, 0, 'garbage', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'clipboard', 'admin', '2025-12-16 10:03:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2180, '知识文章', 2179, 1, 'article', 'system/article/index', NULL, '', 1, 0, 'C', '0', '0', 'system:article:list', '#', 'admin', '2025-12-16 10:17:08', 'admin', '2025-12-16 10:18:36', '垃圾分类知识文章菜单');
INSERT INTO `sys_menu` VALUES (2181, '垃圾分类知识文章查询', 2180, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:article:query', '#', 'admin', '2025-12-16 10:17:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2182, '垃圾分类知识文章新增', 2180, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:article:add', '#', 'admin', '2025-12-16 10:17:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2183, '垃圾分类知识文章修改', 2180, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:article:edit', '#', 'admin', '2025-12-16 10:17:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2184, '垃圾分类知识文章删除', 2180, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:article:remove', '#', 'admin', '2025-12-16 10:17:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2185, '垃圾分类知识文章导出', 2180, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:article:export', '#', 'admin', '2025-12-16 10:17:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2186, '测验题目', 2179, 1, 'question', 'system/question/index', NULL, '', 1, 0, 'C', '0', '0', 'system:question:list', '#', 'admin', '2025-12-16 10:17:13', 'admin', '2025-12-16 10:18:44', '垃圾分类测验题目菜单');
INSERT INTO `sys_menu` VALUES (2187, '垃圾分类测验题目查询', 2186, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:question:query', '#', 'admin', '2025-12-16 10:17:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2188, '垃圾分类测验题目新增', 2186, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:question:add', '#', 'admin', '2025-12-16 10:17:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2189, '垃圾分类测验题目修改', 2186, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:question:edit', '#', 'admin', '2025-12-16 10:17:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2190, '垃圾分类测验题目删除', 2186, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:question:remove', '#', 'admin', '2025-12-16 10:17:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2191, '垃圾分类测验题目导出', 2186, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:question:export', '#', 'admin', '2025-12-16 10:17:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2192, '识别记录', 2179, 1, 'record', 'system/record/index', NULL, '', 1, 0, 'C', '0', '0', 'system:record:list', '#', 'admin', '2025-12-16 10:17:19', 'admin', '2025-12-16 10:18:50', '垃圾识别记录菜单');
INSERT INTO `sys_menu` VALUES (2193, '垃圾识别记录查询', 2192, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:record:query', '#', 'admin', '2025-12-16 10:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2194, '垃圾识别记录新增', 2192, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:record:add', '#', 'admin', '2025-12-16 10:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2195, '垃圾识别记录修改', 2192, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:record:edit', '#', 'admin', '2025-12-16 10:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2196, '垃圾识别记录删除', 2192, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:record:remove', '#', 'admin', '2025-12-16 10:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2197, '垃圾识别记录导出', 2192, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:record:export', '#', 'admin', '2025-12-16 10:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2198, '分类类别', 2179, 1, 'category', 'system/category/index', NULL, '', 1, 0, 'C', '0', '0', 'system:category:list', '#', 'admin', '2025-12-16 10:17:23', 'admin', '2025-12-16 10:18:59', '垃圾分类类别菜单');
INSERT INTO `sys_menu` VALUES (2199, '垃圾分类类别查询', 2198, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:category:query', '#', 'admin', '2025-12-16 10:17:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2200, '垃圾分类类别新增', 2198, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:category:add', '#', 'admin', '2025-12-16 10:17:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2201, '垃圾分类类别修改', 2198, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:category:edit', '#', 'admin', '2025-12-16 10:17:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2202, '垃圾分类类别删除', 2198, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:category:remove', '#', 'admin', '2025-12-16 10:17:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2203, '垃圾分类类别导出', 2198, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:category:export', '#', 'admin', '2025-12-16 10:17:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2204, '垃圾物品', 2179, 1, 'item', 'system/item/index', NULL, '', 1, 0, 'C', '0', '0', 'system:item:list', '#', 'admin', '2025-12-16 10:17:28', '', NULL, '垃圾物品菜单');
INSERT INTO `sys_menu` VALUES (2205, '垃圾物品查询', 2204, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:item:query', '#', 'admin', '2025-12-16 10:17:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2206, '垃圾物品新增', 2204, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:item:add', '#', 'admin', '2025-12-16 10:17:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2207, '垃圾物品修改', 2204, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:item:edit', '#', 'admin', '2025-12-16 10:17:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2208, '垃圾物品删除', 2204, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:item:remove', '#', 'admin', '2025-12-16 10:17:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2209, '垃圾物品导出', 2204, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'system:item:export', '#', 'admin', '2025-12-16 10:17:28', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (10, '212', '1', 0x3C703E3C696D67207372633D222F70726F642D6170692F70726F66696C652F75706C6F61642F323032352F30392F31312FE98791E6B890E5B1825F3230323530393131313730313234413030312E6A7067223E3C2F703E, '0', 'admin', '2025-09-11 17:01:30', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 251 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (107, '标记消息已读', 2, 'com.yaoliyun.web.controller.system.ChatController.markAsRead()', 'PUT', 1, 'admin', '研发部门', '/system/chat/read/2/1', '127.0.0.1', '内网IP', '\"2\" \"1\"', '{\"msg\":\"标记已读成功\",\"code\":200}', 0, NULL, '2025-11-02 12:48:27', 6);
INSERT INTO `sys_oper_log` VALUES (108, '标记消息已读', 2, 'com.yaoliyun.web.controller.system.ChatController.markAsRead()', 'PUT', 1, 'admin', '研发部门', '/system/chat/read/2/1', '127.0.0.1', '内网IP', '\"2\" \"1\"', '{\"msg\":\"标记已读成功\",\"code\":200}', 0, NULL, '2025-11-02 12:48:46', 7);
INSERT INTO `sys_oper_log` VALUES (109, '标记消息已读', 2, 'com.yaoliyun.web.controller.system.ChatController.markAsRead()', 'PUT', 1, 'admin', '研发部门', '/system/chat/read/1/1', '127.0.0.1', '内网IP', '\"1\" \"1\"', '{\"msg\":\"标记已读成功\",\"code\":200}', 0, NULL, '2025-11-02 12:53:39', 13);
INSERT INTO `sys_oper_log` VALUES (110, '标记消息已读', 2, 'com.yaoliyun.web.controller.system.ChatController.markAsRead()', 'PUT', 1, 'admin', '研发部门', '/system/chat/read/2/1', '127.0.0.1', '内网IP', '\"2\" \"1\"', '{\"msg\":\"标记已读成功\",\"code\":200}', 0, NULL, '2025-11-02 12:53:41', 6);
INSERT INTO `sys_oper_log` VALUES (111, '标记消息已读', 2, 'com.yaoliyun.web.controller.system.ChatController.markAsRead()', 'PUT', 1, 'admin', '研发部门', '/system/chat/read/100/1', '127.0.0.1', '内网IP', '\"100\" \"1\"', '{\"msg\":\"标记已读成功\",\"code\":200}', 0, NULL, '2025-11-02 12:53:43', 7);
INSERT INTO `sys_oper_log` VALUES (112, '标记消息已读', 2, 'com.yaoliyun.web.controller.system.ChatController.markAsRead()', 'PUT', 1, 'admin', '研发部门', '/system/chat/read/101/1', '127.0.0.1', '内网IP', '\"101\" \"1\"', '{\"msg\":\"标记已读成功\",\"code\":200}', 0, NULL, '2025-11-02 12:53:47', 4);
INSERT INTO `sys_oper_log` VALUES (113, '标记消息已读', 2, 'com.yaoliyun.web.controller.system.ChatController.markAsRead()', 'PUT', 1, 'admin', '研发部门', '/system/chat/read/100/1', '127.0.0.1', '内网IP', '\"100\" \"1\"', '{\"msg\":\"标记已读成功\",\"code\":200}', 0, NULL, '2025-11-02 12:54:13', 8);
INSERT INTO `sys_oper_log` VALUES (114, '数据库管理', 1, 'com.yaoliyun.generator.controller.DbManageController.addTableColumn()', 'POST', 1, 'admin', '研发部门', '/tool/dbmanage/table/yaoliyun_test/column', '127.0.0.1', '内网IP', '\"yaoliyun_test\" {\"columnComment\":\"标题\",\"columnLength\":255,\"columnName\":\"title\",\"dataType\":\"VARCHAR\",\"extra\":\"\",\"isNullable\":\"YES\",\"params\":{}}', '{\"msg\":\"添加字段成功\",\"code\":200}', 0, NULL, '2025-11-06 12:39:44', 182);
INSERT INTO `sys_oper_log` VALUES (115, '数据库管理', 0, 'com.yaoliyun.generator.controller.DbManageController.backupTable()', 'POST', 1, 'admin', '研发部门', '/tool/dbmanage/table/yaoliyun_test/backup', '127.0.0.1', '内网IP', '\"yaoliyun_test\"', '{\"msg\":\"备份成功\",\"code\":200}', 0, NULL, '2025-11-06 12:40:33', 8);
INSERT INTO `sys_oper_log` VALUES (116, '数据库管理', 2, 'com.yaoliyun.generator.controller.DbManageController.modifyTableColumn()', 'PUT', 1, 'admin', '研发部门', '/tool/dbmanage/table/yaoliyun_test/column/id', '127.0.0.1', '内网IP', '\"yaoliyun_test\" \"id\" {\"columnComment\":\"主键\",\"columnName\":\"id\",\"columnScale\":0,\"dataType\":\"bigint\",\"isNullable\":\"NO\",\"params\":{}}', '{\"msg\":\"修改字段成功\",\"code\":200}', 0, NULL, '2025-11-06 12:40:33', 47);
INSERT INTO `sys_oper_log` VALUES (117, '数据库管理', 0, 'com.yaoliyun.generator.controller.DbManageController.backupTable()', 'POST', 1, 'admin', '研发部门', '/tool/dbmanage/table/yaoliyun_test/backup', '127.0.0.1', '内网IP', '\"yaoliyun_test\"', '{\"msg\":\"备份成功\",\"code\":200}', 0, NULL, '2025-11-06 12:40:57', 5);
INSERT INTO `sys_oper_log` VALUES (118, '数据库管理', 2, 'com.yaoliyun.generator.controller.DbManageController.modifyTableColumn()', 'PUT', 1, 'admin', '研发部门', '/tool/dbmanage/table/yaoliyun_test/column/id', '127.0.0.1', '内网IP', '\"yaoliyun_test\" \"id\" {\"columnComment\":\"id\",\"columnName\":\"id\",\"columnScale\":0,\"dataType\":\"bigint\",\"isNullable\":\"NO\",\"params\":{}}', '{\"msg\":\"修改字段成功\",\"code\":200}', 0, NULL, '2025-11-06 12:40:58', 10);
INSERT INTO `sys_oper_log` VALUES (119, '数据库管理', 0, 'com.yaoliyun.generator.controller.DbManageController.backupTable()', 'POST', 1, 'admin', '研发部门', '/tool/dbmanage/table/yaoliyun_test/backup', '127.0.0.1', '内网IP', '\"yaoliyun_test\"', '{\"msg\":\"备份成功\",\"code\":200}', 0, NULL, '2025-11-06 12:43:31', 7);
INSERT INTO `sys_oper_log` VALUES (120, '数据库管理', 2, 'com.yaoliyun.generator.controller.DbManageController.modifyTableColumn()', 'PUT', 1, 'admin', '研发部门', '/tool/dbmanage/table/yaoliyun_test/column/id', '127.0.0.1', '内网IP', '\"yaoliyun_test\" \"id\" {\"columnComment\":\"id\",\"columnName\":\"id\",\"columnScale\":0,\"dataType\":\"bigint\",\"extra\":\"auto_increment\",\"isNullable\":\"NO\",\"params\":{}}', '{\"msg\":\"修改字段成功\",\"code\":200}', 0, NULL, '2025-11-06 12:43:31', 41);
INSERT INTO `sys_oper_log` VALUES (121, '菜单管理', 1, 'com.yaoliyun.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"测试\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"test\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:19:42', 34);
INSERT INTO `sys_oper_log` VALUES (122, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-11-06 13:19:42\",\"icon\":\"button\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2148,\"menuName\":\"测试菜单\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"test\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:19:55', 11);
INSERT INTO `sys_oper_log` VALUES (123, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:20:23', 43);
INSERT INTO `sys_oper_log` VALUES (124, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:20:23\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:20:23\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-06 13:20:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"usableColumn\":false}],\"crud\":true,\"functionAuthor\":\"ruoyi\",\"functionName\":\"测试\",\"genPath\":\"/\",\"genType\":\"0\",\"moduleName\":\"system\",\"options\":\"{\\\"parentMenuId\\\":2148}\",\"packageName\":\"com.yaol', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:20:31', 18);
INSERT INTO `sys_oper_log` VALUES (125, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-06 13:20:34', 175);
INSERT INTO `sys_oper_log` VALUES (126, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-06 13:27:37', 162);
INSERT INTO `sys_oper_log` VALUES (127, '测试', 1, 'com.yaoliyun.system.controller.YaoliyunTestController.add()', 'POST', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"id\":1,\"name\":\"111\",\"params\":{},\"title\":\"222\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:27:50', 7);
INSERT INTO `sys_oper_log` VALUES (128, '测试', 1, 'com.yaoliyun.system.controller.YaoliyunTestController.add()', 'POST', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"id\":2,\"name\":\"333\",\"params\":{},\"title\":\"2332\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:27:56', 5);
INSERT INTO `sys_oper_log` VALUES (129, '测试', 3, 'com.yaoliyun.system.controller.YaoliyunTestController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/test/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:27:58', 9);
INSERT INTO `sys_oper_log` VALUES (130, '测试', 3, 'com.yaoliyun.system.controller.YaoliyunTestController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/test/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:28:00', 6);
INSERT INTO `sys_oper_log` VALUES (131, '代码生成', 6, 'com.yaoliyun.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"chat_sessions\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:29:14', 40);
INSERT INTO `sys_oper_log` VALUES (132, '数据库管理', 1, 'com.yaoliyun.generator.controller.DbManageController.addTableColumn()', 'POST', 1, 'admin', '研发部门', '/tool/dbmanage/table/yaoliyun_test/column', '127.0.0.1', '内网IP', '\"yaoliyun_test\" {\"columnComment\":\"会话编号\",\"columnLength\":255,\"columnName\":\"message_id\",\"dataType\":\"BIGINT\",\"extra\":\"\",\"isNullable\":\"YES\",\"params\":{}}', '{\"msg\":\"添加字段成功\",\"code\":200}', 0, NULL, '2025-11-06 13:30:51', 116);
INSERT INTO `sys_oper_log` VALUES (133, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:31:01', 20);
INSERT INTO `sys_oper_log` VALUES (134, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/chat_sessions', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:31:48', 24);
INSERT INTO `sys_oper_log` VALUES (135, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:31:01\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:31:01\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-06 13:20:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:31:01\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"会话编号\",\"columnId\":66,\"columnName\":\"message_id\",\"columnType\":\"bigint\",\"createBy\":\"\",\"crea', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:32:41', 25);
INSERT INTO `sys_oper_log` VALUES (136, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-06 13:32:44', 29);
INSERT INTO `sys_oper_log` VALUES (137, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-06 13:35:50', 108);
INSERT INTO `sys_oper_log` VALUES (138, '测试', 1, 'com.yaoliyun.system.controller.YaoliyunTestController.add()', 'POST', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"id\":3,\"messageId\":12,\"name\":\"22\",\"params\":{},\"title\":\"333\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:36:08', 8);
INSERT INTO `sys_oper_log` VALUES (139, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:32:41\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:32:41\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-06 13:20:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:32:41\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"会话编号\",\"columnId\":66,\"columnName\":\"message_id\",\"columnType\":\"bigint\",\"createBy\":\"\",\"crea', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:53:12', 30);
INSERT INTO `sys_oper_log` VALUES (140, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-06 13:53:14', 31);
INSERT INTO `sys_oper_log` VALUES (141, '测试', 2, 'com.yaoliyun.system.controller.YaoliyunTestController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"contactName\":\"测试1\",\"id\":3,\"messageId\":10,\"name\":\"22\",\"params\":{},\"title\":\"333\",\"userId\":\"100\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 13:53:50', 12);
INSERT INTO `sys_oper_log` VALUES (142, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:53:12\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:53:12\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-06 13:20:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-06 13:53:12\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"会话编号\",\"columnId\":66,\"columnName\":\"message_id\",\"columnType\":\"bigint\",\"createBy\":\"\",\"crea', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:11:08', 30);
INSERT INTO `sys_oper_log` VALUES (143, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:11:13', 106);
INSERT INTO `sys_oper_log` VALUES (144, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:15:41', 100);
INSERT INTO `sys_oper_log` VALUES (145, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:11:08\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:11:08\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-06 13:20:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:11:08\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"会话编号\",\"columnId\":66,\"columnName\":\"message_id\",\"columnType\":\"bigint\",\"createBy\":\"\",\"crea', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:20:21', 24);
INSERT INTO `sys_oper_log` VALUES (146, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:20:27', 29);
INSERT INTO `sys_oper_log` VALUES (147, '删除生成代码文件', 3, 'com.yaoliyun.generator.controller.GenController.deleteGeneratedFiles()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/deleteGeneratedFiles/yaoliyun_test', '127.0.0.1', '内网IP', '\"yaoliyun_test\"', '{\"msg\":\"生成代码文件删除成功\",\"code\":200}', 0, NULL, '2025-11-11 18:21:14', 20);
INSERT INTO `sys_oper_log` VALUES (148, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:20:21\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:20:21\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-06 13:20:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:20:21\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"会话编号\",\"columnId\":66,\"columnName\":\"message_id\",\"columnType\":\"bigint\",\"createBy\":\"\",\"crea', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:21:36', 12);
INSERT INTO `sys_oper_log` VALUES (149, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:21:40', 38);
INSERT INTO `sys_oper_log` VALUES (150, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:21:36\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:21:36\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-06 13:20:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:21:36\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:24:49', 35);
INSERT INTO `sys_oper_log` VALUES (151, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:24:59', 97);
INSERT INTO `sys_oper_log` VALUES (152, '删除生成代码文件', 3, 'com.yaoliyun.generator.controller.GenController.deleteGeneratedFiles()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/deleteGeneratedFiles/yaoliyun_test', '127.0.0.1', '内网IP', '\"yaoliyun_test\"', '{\"msg\":\"生成代码文件删除成功\",\"code\":200}', 0, NULL, '2025-11-11 18:26:04', 63);
INSERT INTO `sys_oper_log` VALUES (153, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:26:07', 86);
INSERT INTO `sys_oper_log` VALUES (154, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:29:14', 110);
INSERT INTO `sys_oper_log` VALUES (155, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:24:49\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:24:49\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-06 13:20:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:24:49\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:33:47', 27);
INSERT INTO `sys_oper_log` VALUES (156, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:33:49', 33);
INSERT INTO `sys_oper_log` VALUES (157, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:33:56', 25);
INSERT INTO `sys_oper_log` VALUES (158, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"生成代码失败：\\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'c.is_list\' in \'field list\'\\r\\n### The error may exist in file [D:\\\\瑶力云代码生成器模板Vue2\\\\yaoliyun-generator\\\\target\\\\classes\\\\mapper\\\\generator\\\\GenTableMapper.xml]\\r\\n### The error may involve com.yaoliyun.generator.mapper.GenTableMapper.selectGenTableByName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: SELECT t.table_id, t.table_name, t.table_comment, t.sub_table_name, t.sub_table_fk_name, t.class_name, t.tpl_category, t.tpl_web_type, t.package_name, t.module_name, t.business_name, t.function_name, t.function_author, t.gen_type, t.gen_path, t.options, t.remark,      c.column_id, c.column_name, c.column_comment, c.column_type, c.java_type, c.java_field, c.is_pk, c.is_increment, c.is_required, c.is_insert, c.is_edit, c.is_list, c.is_query, c.query_type, c.html_type, c.dict_type, c.sort,      c.is_foreign_key, c.foreign_table_name, c.foreign_column_name, c.foreign_display_field, c.foreign_display_field_name  FROM gen_table t    LEFT JOIN gen_table_column c ON t.table_id = c.table_id  where t.table_name = ? order by c.sort\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'c.is_list\' in \'field list\'\\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'c.is_list\' in \'field list\'\",\"code\":500}', 0, NULL, '2025-11-11 18:37:30', 60);
INSERT INTO `sys_oper_log` VALUES (159, '测试', 3, 'com.yaoliyun.system.controller.YaoliyunTestController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/test/3', '127.0.0.1', '内网IP', '[3]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:40:36', 8);
INSERT INTO `sys_oper_log` VALUES (160, '删除生成代码文件', 3, 'com.yaoliyun.generator.controller.GenController.deleteGeneratedFiles()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/deleteGeneratedFiles/yaoliyun_test', '127.0.0.1', '内网IP', '\"yaoliyun_test\"', '{\"msg\":\"生成代码文件删除成功\",\"code\":200}', 0, NULL, '2025-11-11 18:40:42', 52);
INSERT INTO `sys_oper_log` VALUES (161, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:41:23', 26);
INSERT INTO `sys_oper_log` VALUES (162, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.synchDb()', 'GET', 1, 'admin', '研发部门', '/tool/gen/synchDb/chat_sessions', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:41:48', 40);
INSERT INTO `sys_oper_log` VALUES (163, '代码生成', 3, 'com.yaoliyun.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/18', '127.0.0.1', '内网IP', '[18]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:42:12', 16);
INSERT INTO `sys_oper_log` VALUES (164, '代码生成', 6, 'com.yaoliyun.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"chat_sessions\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:42:18', 37);
INSERT INTO `sys_oper_log` VALUES (165, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:41:23\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:41:23\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"会话编号\",\"columnId\":55,\"columnName\":\"m', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:42:53', 25);
INSERT INTO `sys_oper_log` VALUES (166, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:42:56', 94);
INSERT INTO `sys_oper_log` VALUES (167, '测试', 1, 'com.yaoliyun.system.controller.YaoliyunTestController.add()', 'POST', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"id\":4,\"messageId\":12,\"name\":\"32452\",\"params\":{},\"title\":\"2352\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:43:32', 15);
INSERT INTO `sys_oper_log` VALUES (168, '测试', 2, 'com.yaoliyun.system.controller.YaoliyunTestController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"contactName\":\"测试1\",\"id\":4,\"lastMessage\":\"http://localhost:8080/profile/upload/2025/11/01/VYoGtIs1wm541cd1d4e8d35f20bae5da5746f3290bde_20251101124202A003.jpg\",\"messageId\":11,\"name\":\"32452\",\"params\":{},\"title\":\"2352\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:43:39', 7);
INSERT INTO `sys_oper_log` VALUES (169, '测试', 2, 'com.yaoliyun.system.controller.YaoliyunTestController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"contactName\":\"1233\",\"id\":4,\"lastMessage\":\"http://localhost:8080/profile/upload/2025/11/01/VYoGtIs1wm541cd1d4e8d35f20bae5da5746f3290bde_20251101124202A003.jpg\",\"messageId\":7,\"name\":\"32452\",\"params\":{},\"title\":\"2352\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:43:44', 6);
INSERT INTO `sys_oper_log` VALUES (170, '测试', 2, 'com.yaoliyun.system.controller.YaoliyunTestController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"contactName\":\"23424\",\"id\":4,\"lastMessage\":\"http://localhost:8080/profile/upload/2025/11/02/金渐层_20251102122238A001.jpg\",\"messageId\":9,\"name\":\"32452\",\"params\":{},\"title\":\"2352\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-11 18:43:48', 6);
INSERT INTO `sys_oper_log` VALUES (171, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 18:46:53', 120);
INSERT INTO `sys_oper_log` VALUES (172, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 19:11:41', 109);
INSERT INTO `sys_oper_log` VALUES (173, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 19:14:12', 137);
INSERT INTO `sys_oper_log` VALUES (174, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 19:20:05', 92651);
INSERT INTO `sys_oper_log` VALUES (175, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 19:21:36', 73584);
INSERT INTO `sys_oper_log` VALUES (176, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-11 19:21:45', 140);
INSERT INTO `sys_oper_log` VALUES (177, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 10:48:57', 21641);
INSERT INTO `sys_oper_log` VALUES (178, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 10:49:56', 40619);
INSERT INTO `sys_oper_log` VALUES (179, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 10:51:58', 424);
INSERT INTO `sys_oper_log` VALUES (180, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 10:53:55', 57122);
INSERT INTO `sys_oper_log` VALUES (181, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 10:54:34', 158);
INSERT INTO `sys_oper_log` VALUES (182, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 10:58:40', 122);
INSERT INTO `sys_oper_log` VALUES (183, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:42:53\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:42:53\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-11 18:42:53\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 10:59:34', 23);
INSERT INTO `sys_oper_log` VALUES (184, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 10:59:38', 32);
INSERT INTO `sys_oper_log` VALUES (185, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 10:59:34\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 10:59:34\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 10:59:34\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 11:01:05', 57);
INSERT INTO `sys_oper_log` VALUES (186, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 11:01:08', 94);
INSERT INTO `sys_oper_log` VALUES (187, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 11:01:11', 30);
INSERT INTO `sys_oper_log` VALUES (188, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:01:05\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:01:05\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:01:05\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 11:03:56', 31);
INSERT INTO `sys_oper_log` VALUES (189, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:03:56\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:03:56\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:03:56\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 11:08:02', 54);
INSERT INTO `sys_oper_log` VALUES (190, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:08:02\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:08:02\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:08:02\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 11:09:03', 23);
INSERT INTO `sys_oper_log` VALUES (191, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:09:03\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:09:03\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:09:03\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 11:11:29', 42);
INSERT INTO `sys_oper_log` VALUES (192, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 11:11:32', 96);
INSERT INTO `sys_oper_log` VALUES (193, '测试', 1, 'com.yaoliyun.system.controller.YaoliyunTestController.add()', 'POST', 1, 'admin', '研发部门', '/system/test', '127.0.0.1', '内网IP', '{\"id\":5,\"messageId\":11,\"name\":\"222\",\"params\":{},\"title\":\"1212\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 11:11:51', 10);
INSERT INTO `sys_oper_log` VALUES (194, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:11:29\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:11:29\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:11:29\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 11:12:21', 12);
INSERT INTO `sys_oper_log` VALUES (195, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"test\",\"className\":\"YaoliyunTest\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"id\",\"columnId\":52,\"columnName\":\"id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:12:21\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"名字\",\"columnId\":53,\"columnName\":\"name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 18:42:10\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:12:21\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"标题\",\"columnId\":54,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"\",\"createTime\":\"2025-11-11 18:41:23\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":17,\"updateBy\":\"\",\"updateTime\":\"2025-11-14 11:12:21\",\"usableColumn\":false},{\"capJavaField\":\"MessageId\",\"columnComment\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-14 11:12:36', 14);
INSERT INTO `sys_oper_log` VALUES (196, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/yaoliyun_test', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-11-14 11:12:38', 30);
INSERT INTO `sys_oper_log` VALUES (197, '删除生成代码文件', 3, 'com.yaoliyun.generator.controller.GenController.deleteGeneratedFiles()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/deleteGeneratedFiles/yaoliyun_test', '127.0.0.1', '内网IP', '\"yaoliyun_test\"', '{\"msg\":\"生成代码文件删除成功\",\"code\":200}', 0, NULL, '2025-11-14 11:13:21', 58);
INSERT INTO `sys_oper_log` VALUES (198, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-08-07 11:38:58\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-13 16:00:58', 57);
INSERT INTO `sys_oper_log` VALUES (199, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/dept/index\",\"createTime\":\"2025-08-07 11:38:58\",\"icon\":\"tree\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":103,\"menuName\":\"部门管理\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":1,\"path\":\"dept\",\"perms\":\"system:dept:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-13 16:01:07', 7);
INSERT INTO `sys_oper_log` VALUES (200, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/post/index\",\"createTime\":\"2025-08-07 11:38:58\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":104,\"menuName\":\"岗位管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"post\",\"perms\":\"system:post:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-13 16:01:13', 7);
INSERT INTO `sys_oper_log` VALUES (201, '代码生成', 3, 'com.yaoliyun.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/19', '127.0.0.1', '内网IP', '[19]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:01:46', 22);
INSERT INTO `sys_oper_log` VALUES (202, '代码生成', 3, 'com.yaoliyun.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/17', '127.0.0.1', '内网IP', '[17]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:01:51', 6);
INSERT INTO `sys_oper_log` VALUES (203, '代码生成', 6, 'com.yaoliyun.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"garbage_knowledge_article,garbage_quiz_question,user_quiz_record,garbage_recognition_record,user_points_record,garbage_category,garbage_item,garbage_item_keyword\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:02:14', 159);
INSERT INTO `sys_oper_log` VALUES (204, '代码生成', 6, 'com.yaoliyun.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"sys_user\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:02:23', 57);
INSERT INTO `sys_oper_log` VALUES (205, '菜单管理', 1, 'com.yaoliyun.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"垃圾分类识别管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"garbage\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:03:18', 8);
INSERT INTO `sys_oper_log` VALUES (206, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"article\",\"className\":\"GarbageKnowledgeArticle\",\"columns\":[{\"capJavaField\":\"ArticleId\",\"columnComment\":\"文章ID\",\"columnId\":110,\"columnName\":\"article_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"articleId\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":23,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CategoryId\",\"columnComment\":\"关联分类ID\",\"columnId\":111,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":true,\"foreignColumnName\":\"category_id\",\"foreignDisplayField\":\"category_name\",\"foreignDisplayFieldConfig\":\"[{\\\"foreignField\\\":\\\"category_name\\\",\\\"javaFieldName\\\":\\\"categoryName\\\",\\\"fieldComment\\\":\\\"类别名称\\\",\\\"isList\\\":\\\"1\\\",\\\"isQuery\\\":\\\"1\\\",\\\"queryType\\\":\\\"EQ\\\"}]\",\"foreignDisplayFieldName\":\"categoryName\",\"foreignTableName\":\"garbage_category\",\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"categoryId\",\"javaType\":\"Long\",\"list\":true,\"listForeignFieldObjects\":[{\"foreignField\":\"category_name\",\"javaFieldName\":\"categoryName\",\"fieldComment\":\"类别名称\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}],\"listForeignFields\":\"categoryName\",\"params\":{},\"pk\":false,\"query\":true,\"queryForeignField\":\"categoryName\",\"queryForeignFieldComment\":\"类别名称\",\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":23,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"文章标题\",\"columnId\":112,\"columnName\":\"title\",\"columnType\":\"varchar(200)\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"d', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:04:47', 29);
INSERT INTO `sys_oper_log` VALUES (207, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"question\",\"className\":\"GarbageQuizQuestion\",\"columns\":[{\"capJavaField\":\"QuestionId\",\"columnComment\":\"题目ID\",\"columnId\":122,\"columnName\":\"question_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"questionId\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":24,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ArticleId\",\"columnComment\":\"关联文章ID\",\"columnId\":123,\"columnName\":\"article_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":true,\"foreignColumnName\":\"article_id\",\"foreignDisplayField\":\"title\",\"foreignDisplayFieldConfig\":\"[{\\\"foreignField\\\":\\\"title\\\",\\\"javaFieldName\\\":\\\"title\\\",\\\"fieldComment\\\":\\\"文章标题\\\",\\\"isList\\\":\\\"1\\\",\\\"isQuery\\\":\\\"1\\\",\\\"queryType\\\":\\\"EQ\\\"}]\",\"foreignDisplayFieldName\":\"title\",\"foreignTableName\":\"garbage_knowledge_article\",\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"articleId\",\"javaType\":\"Long\",\"list\":true,\"listForeignFieldObjects\":[{\"foreignField\":\"title\",\"javaFieldName\":\"title\",\"fieldComment\":\"文章标题\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}],\"listForeignFields\":\"title\",\"params\":{},\"pk\":false,\"query\":true,\"queryForeignField\":\"title\",\"queryForeignFieldComment\":\"文章标题\",\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":24,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CategoryId\",\"columnComment\":\"关联分类ID\",\"columnId\":124,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":true,\"foreignColumnName\":\"ca', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:06:23', 32);
INSERT INTO `sys_oper_log` VALUES (208, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"record\",\"className\":\"GarbageRecognitionRecord\",\"columns\":[{\"capJavaField\":\"RecordId\",\"columnComment\":\"记录ID\",\"columnId\":139,\"columnName\":\"record_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"recordId\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":25,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":140,\"columnName\":\"user_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":true,\"foreignColumnName\":\"user_id\",\"foreignDisplayField\":\"nick_name\",\"foreignDisplayFieldConfig\":\"[{\\\"foreignField\\\":\\\"nick_name\\\",\\\"javaFieldName\\\":\\\"nickName\\\",\\\"fieldComment\\\":\\\"用户昵称\\\",\\\"isList\\\":\\\"1\\\",\\\"isQuery\\\":\\\"1\\\",\\\"queryType\\\":\\\"EQ\\\"}]\",\"foreignDisplayFieldName\":\"nickName\",\"foreignTableName\":\"sys_user\",\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"listForeignFieldObjects\":[{\"foreignField\":\"nick_name\",\"javaFieldName\":\"nickName\",\"fieldComment\":\"用户昵称\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}],\"listForeignFields\":\"nickName\",\"params\":{},\"pk\":false,\"query\":true,\"queryForeignField\":\"nickName\",\"queryForeignFieldComment\":\"用户昵称\",\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":25,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ImageUrl\",\"columnComment\":\"原图URL\",\"columnId\":141,\"columnName\":\"image_url\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:08:19', 39);
INSERT INTO `sys_oper_log` VALUES (209, '代码生成', 3, 'com.yaoliyun.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/26', '127.0.0.1', '内网IP', '[26]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:09:08', 11);
INSERT INTO `sys_oper_log` VALUES (210, '代码生成', 3, 'com.yaoliyun.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/27', '127.0.0.1', '内网IP', '[27]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:09:12', 15);
INSERT INTO `sys_oper_log` VALUES (211, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"category\",\"className\":\"GarbageCategory\",\"columns\":[{\"capJavaField\":\"CategoryId\",\"columnComment\":\"类别ID\",\"columnId\":78,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:13\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"categoryId\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":20,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CategoryName\",\"columnComment\":\"类别名称\",\"columnId\":79,\"columnName\":\"category_name\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:13\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"categoryName\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":20,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CategoryCode\",\"columnComment\":\"类别编码\",\"columnId\":80,\"columnName\":\"category_code\",\"columnType\":\"varchar(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:13\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"categoryCode\",\"javaType\":\"String\",\"list\":true,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":20,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Description\",\"columnComment\":\"类别描述\",\"columnId\":', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:09:34', 26);
INSERT INTO `sys_oper_log` VALUES (212, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"item\",\"className\":\"GarbageItem\",\"columns\":[{\"capJavaField\":\"ItemId\",\"columnComment\":\"物品ID\",\"columnId\":92,\"columnName\":\"item_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:13\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"itemId\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":21,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CategoryId\",\"columnComment\":\"所属类别ID（关联垃圾分类类别表）\",\"columnId\":93,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:13\",\"dictType\":\"\",\"edit\":true,\"foreignColumnName\":\"category_id\",\"foreignDisplayField\":\"category_name\",\"foreignDisplayFieldConfig\":\"[{\\\"foreignField\\\":\\\"category_name\\\",\\\"javaFieldName\\\":\\\"categoryName\\\",\\\"fieldComment\\\":\\\"类别名称\\\",\\\"isList\\\":\\\"1\\\",\\\"isQuery\\\":\\\"0\\\",\\\"queryType\\\":\\\"EQ\\\"}]\",\"foreignDisplayFieldName\":\"categoryName\",\"foreignTableName\":\"garbage_category\",\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"categoryId\",\"javaType\":\"Long\",\"list\":true,\"listForeignFieldObjects\":[{\"foreignField\":\"category_name\",\"javaFieldName\":\"categoryName\",\"fieldComment\":\"类别名称\",\"isList\":\"1\",\"isQuery\":\"0\",\"queryType\":\"EQ\"}],\"listForeignFields\":\"categoryName\",\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":21,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ItemName\",\"columnComment\":\"物品名称\",\"columnId\":94,\"columnName\":\"item_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:13\",\"dictType\":\"\",\"edit\":true,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increm', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:13:04', 21);
INSERT INTO `sys_oper_log` VALUES (213, '代码生成', 3, 'com.yaoliyun.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/22', '127.0.0.1', '内网IP', '[22]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:13:23', 17);
INSERT INTO `sys_oper_log` VALUES (214, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/garbage_knowledge_article', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-12-16 10:17:08', 152);
INSERT INTO `sys_oper_log` VALUES (215, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/garbage_quiz_question', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-12-16 10:17:13', 48);
INSERT INTO `sys_oper_log` VALUES (216, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/garbage_recognition_record', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-12-16 10:17:19', 40);
INSERT INTO `sys_oper_log` VALUES (217, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/garbage_category', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-12-16 10:17:23', 34);
INSERT INTO `sys_oper_log` VALUES (218, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/garbage_item', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-12-16 10:17:28', 40);
INSERT INTO `sys_oper_log` VALUES (219, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/article/index\",\"createTime\":\"2025-12-16 10:17:08\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2180,\"menuName\":\"知识文章\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2179,\"path\":\"article\",\"perms\":\"system:article:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:18:37', 16);
INSERT INTO `sys_oper_log` VALUES (220, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/question/index\",\"createTime\":\"2025-12-16 10:17:13\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2186,\"menuName\":\"测验题目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2179,\"path\":\"question\",\"perms\":\"system:question:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:18:44', 7);
INSERT INTO `sys_oper_log` VALUES (221, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/record/index\",\"createTime\":\"2025-12-16 10:17:19\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2192,\"menuName\":\"识别记录\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2179,\"path\":\"record\",\"perms\":\"system:record:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:18:50', 9);
INSERT INTO `sys_oper_log` VALUES (222, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/category/index\",\"createTime\":\"2025-12-16 10:17:23\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2198,\"menuName\":\"分类类别\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2179,\"path\":\"category\",\"perms\":\"system:category:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 10:18:59', 15);
INSERT INTO `sys_oper_log` VALUES (223, '代码生成', 2, 'com.yaoliyun.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"question\",\"className\":\"GarbageQuizQuestion\",\"columns\":[{\"capJavaField\":\"QuestionId\",\"columnComment\":\"题目ID\",\"columnId\":122,\"columnName\":\"question_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":false,\"foreignDisplayField\":\"name\",\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isForeignKey\":\"0\",\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"questionId\",\"javaType\":\"Long\",\"list\":false,\"listForeignFieldObjects\":[],\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":24,\"updateBy\":\"\",\"updateTime\":\"2025-12-16 10:06:23\",\"usableColumn\":false},{\"capJavaField\":\"ArticleId\",\"columnComment\":\"关联文章ID\",\"columnId\":123,\"columnName\":\"article_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-12-16 10:02:14\",\"dictType\":\"\",\"edit\":true,\"foreignColumnName\":\"article_id\",\"foreignDisplayField\":\"title\",\"foreignDisplayFieldConfig\":\"[{\\\"foreignField\\\":\\\"title\\\",\\\"javaFieldName\\\":\\\"title\\\",\\\"fieldComment\\\":\\\"文章标题\\\",\\\"isList\\\":\\\"1\\\",\\\"isQuery\\\":\\\"1\\\",\\\"queryType\\\":\\\"EQ\\\"}]\",\"foreignDisplayFieldName\":\"title\",\"foreignTableName\":\"garbage_knowledge_article\",\"htmlType\":\"select\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isForeignKey\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"articleId\",\"javaType\":\"Long\",\"list\":true,\"listForeignFieldObjects\":[{\"foreignField\":\"title\",\"javaFieldName\":\"title\",\"fieldComment\":\"文章标题\",\"isList\":\"1\",\"isQuery\":\"1\",\"queryType\":\"EQ\"}],\"listForeignFields\":\"title\",\"params\":{},\"pk\":false,\"query\":true,\"queryForeignField\":\"title\",\"queryForeignFieldComment\":\"文章标题\",\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":false,\"tableId\":24,\"updateBy\":\"\",\"updateTime\":\"2025-12-16 10:06:23\",\"usableColumn\":false},{\"capJavaField\":\"CategoryId\",\"columnComment\":\"关联分类ID\",\"columnId\":124,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 11:31:23', 51);
INSERT INTO `sys_oper_log` VALUES (224, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUSEhIWFRUXFxUXFRYVFxUXFhUVFRUXFhcVFxUYHSggGBolHRUVITEhJSkrLi4uFx8zODMsNygtLisBCgoKDg0OFxAQFysfHR0tLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLSstLS0rLS0tLS0tLS0tLS0tLf/AABEIAOEA4QMBIgACEQEDEQH/xAAcAAABBQEBAQAAAAAAAAAAAAADAAECBAUGBwj/xAA6EAABAwIDBQYGAQMDBQEAAAABAAIRAyEEMUEFElFhcRMigZGh8AYyscHR4VJCcvEjM2IHFIKS4hX/xAAZAQADAQEBAAAAAAAAAAAAAAABAgMABAX/xAAiEQACAgMBAAIDAQEAAAAAAAAAAQIRAxIhMQRBEyIyFFH/2gAMAwEAAhEDEQA/AOxCaVKUy8c9USYFOkFjCSTpisYYOUkySxhFNKeUoWMIlV8QEYlDddBhoqliYhWd1QcFoxbdIDAtCssCtYZ4GQHW0q4aLXNndAPECD5CxVvwtITczmIzUKudwwVXdiOcdEiQWy66oBmYQn4ngPP8Kk+pw/ah2Tj+06i2I5JBamInMzy08lXdJR24Y5n1TEjS6vHFXpKWSyLWIoaEgVB71ckSOaK2kEKk4opaTl5JWhkSFMKQbyQQ4hSFVLQ1k5SUO0SQoJZSTFOuI6hJJgU6xhJJikVjDpk28nlAwgmJTymCzMQKaFNQc5BJvwNpChBqhENT2PynpOBudMwFfHGnbF3TA4UkmACVr1CWdOdlT/7vRoG7yzB+iFVc51vd008yXELo2CruNU3sG3B62I6fhAxNMNggdRP0Vo4YtBkx7B/Kp0aILjvGeE6A2yXMptdYzjwJSxDNCB6K1vcIVCqxpO4LG9s8reqZ1OJLRBtabaeS6F8hIg8LLVbeOajTap4WuCIAknS5nKwUazXNJ3R55CfqZT/6Ii/hkScOKIKNpAtx/at4OiIFg48T+NFpAka/jyV4zUvBHGjnmJls4+i2oO62Hjhk7iI48FjrGQyUJyphYINJEhJY1llJNKdecdgkkydEwkydRmFjDwkoh08vfJRqP43TKDF3RPeCiT7zKAcUBb0/QQzWcchHX8Kixom8jC1Hez+NFXfiR/cfTzyTdjPzGeuXlkmfT4BVUCbmQNUnOw5flEwdKTIMff8AKEFZ3g0RxXNnmlxFsMH6yyYFoRsLTdIJB9PIhc1tbatSk3eB3gSAIaS7eOQAHHJcbtf4sx+HqAmuxrhfsWjtAAdKhJieinhg8nhTJOOP1nqvxBJDGtzcQPLXyk+Cz8dVDXyDf3CF8L7fbtCj2m72daldzMx3m/O06tP5GiI3CB+885kkN/tgD8pM0ZJhxyTjwpYGoS4u1Jtx4T75LSxNMNALvmOQ1KHgsDuOY0XgXPP7fpa1PBF1YveIDQAwfdJCLZR0geHwYDZ/qH04J2tnwEfaUbEOLflHUoFB55zPuyq+cJlnDsFhMdFcm0O8DxVUG0qw2sHNImCAYK7cU0+HPki7M9+Ig2QMQBvuj+TvqiCkG3JsPU8FXeZXQxJpLwQUmtUIUmpRAm5zSUZSWMEunUS5MCeQ8ZXAotnY5JE1Bzjp6odasG5lVatYnIeJt+1RYybyF0kcfsg1cSBYG/mVW3Cc3eARGsAsFVQRJz6R7dxyEcz+EjSJ+Yz6BFYzkpEp9QWAa0DRS3wpylKIo0qFR8IkqtXMkBLklrFsaKt0CM5qxhh/UfJHw+GnNadDBCCInmvN0cnZ3xnFKjH29TltGq1p/wBGq19RrRJNPdc0uDRnulzXxnDDAXimPY9mJcYNR7nvIMbzXNfZpa4yHd0zvZCRFwvoOns+5k2GV8uhzVWtsiiZ3aFNzjcktbMnMm1yuzDm0VNHHnw/kdpmB8CYYMc+uQ2mOx3HtYIZ2jnbwa0SbNHE/wBQXRYFjcvFctig6nVbhxDB', '{\"msg\":\"数据返回为空\",\"code\":500}', 0, NULL, '2025-12-16 11:34:39', 604);
INSERT INTO `sys_oper_log` VALUES (225, '代码生成到项目', 8, 'com.yaoliyun.generator.controller.GenController.genCodeToProject()', 'GET', 1, 'admin', '研发部门', '/tool/gen/genCodeToProject/garbage_item', '127.0.0.1', '内网IP', '{}', '{\"msg\":\"代码生成成功，已自动放置到项目目录并执行SQL脚本\",\"code\":200}', 0, NULL, '2025-12-16 11:36:22', 43);
INSERT INTO `sys_oper_log` VALUES (226, '垃圾分类知识文章', 2, 'com.yaoliyun.system.controller.GarbageKnowledgeArticleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/article', '127.0.0.1', '内网IP', '{\"articleId\":1,\"categoryId\":1,\"categoryName\":\"可回收物\",\"content\":\"<h2>什么是可回收物？</h2><p>可回收物是指适宜回收利用和资源化利用的生活废弃物。主要包括：</p><ol><li data-list=\\\"bullet\\\"><span class=\\\"ql-ui\\\" contenteditable=\\\"false\\\"></span><strong>废纸</strong>：报纸、书本、纸箱、纸袋等</li><li data-list=\\\"bullet\\\"><span class=\\\"ql-ui\\\" contenteditable=\\\"false\\\"></span><strong>废塑料</strong>：塑料瓶、塑料袋、塑料桶等</li><li data-list=\\\"bullet\\\"><span class=\\\"ql-ui\\\" contenteditable=\\\"false\\\"></span><strong>废金属</strong>：易拉罐、金属罐、废铁等</li><li data-list=\\\"bullet\\\"><span class=\\\"ql-ui\\\" contenteditable=\\\"false\\\"></span><strong>废玻璃</strong>：玻璃瓶、玻璃杯等</li><li data-list=\\\"bullet\\\"><span class=\\\"ql-ui\\\" contenteditable=\\\"false\\\"></span><strong>废织物</strong>：旧衣服、旧床单、旧毛巾等</li></ol><h2>投放要求</h2><p>1. 纸类应尽量叠放整齐，避免揉团</p><p>2. 塑料垃圾应清空内容物，清洁后压扁投放</p><p>3. 玻璃类应轻投轻放，有尖锐边角的应包裹后投放</p>\",\"coverImage\":\"http://localhost:8080/profile/upload/2025/12/16/微信图片_20250517153115_20251216113840A001.jpg\",\"createBy\":\"admin\",\"createTime\":\"2025-12-13 16:25:15\",\"params\":{},\"sortOrder\":1,\"status\":\"0\",\"title\":\"可回收物分类指南\",\"updateBy\":\"\",\"updateTime\":\"2025-12-16 11:38:41\",\"viewCount\":0}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 11:38:41', 24);
INSERT INTO `sys_oper_log` VALUES (227, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"塑料瓶\"}', '{\"msg\":\"数据返回为空\",\"code\":500}', 0, NULL, '2025-12-16 11:39:29', 417);
INSERT INTO `sys_oper_log` VALUES (228, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"塑料瓶\"}', '{\"msg\":\"数据返回为空\",\"code\":500}', 0, NULL, '2025-12-16 11:40:56', 224);
INSERT INTO `sys_oper_log` VALUES (229, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"电池\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[],\"total\":0}}', 0, NULL, '2025-12-16 11:45:02', 420);
INSERT INTO `sys_oper_log` VALUES (230, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"电池\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"aipre\":0,\"contain\":\"常见包括废电池、废荧光灯管、废灯泡、废水银温度计、废油漆桶、过期药品、农药、杀虫剂等。\",\"explain\":\"有毒有害垃圾是指存有对人体健康有害的重金属、有毒的物质或者对环境造成现实危害或者潜在危害的废弃物。\",\"name\":\"充电电池\",\"tip\":\"分类投放有害垃圾时，应注意轻放。其中：废灯管等易破损的有害垃圾应连带包装或包裹后投放；废弃药品宜连带包装一并投放；杀虫剂等压力罐装容器，应排空内容物后投放；在公共场所产生有害垃圾且未发现对应收集容器时，应携带至有害垃圾投放点妥善投放。\",\"type\":1,\"typeName\":\"有害垃圾\"},{\"aipre\":0,\"contain\":\"常见包括废电池、废荧光灯管、废灯泡、废水银温度计、废油漆桶、过期药品、农药、杀虫剂等。\",\"explain\":\"有毒有害垃圾是指存有对人体健康有害的重金属、有毒的物质或者对环境造成现实危害或者潜在危害的废弃物。\",\"name\":\"干电池\",\"tip\":\"分类投放有害垃圾时，应注意轻放。其中：废灯管等易破损的有害垃圾应连带包装或包裹后投放；废弃药品宜连带包装一并投放；杀虫剂等压力罐装容器，应排空内容物后投放；在公共场所产生有害垃圾且未发现对应收集容器时，应携带至有害垃圾投放点妥善投放。\",\"type\":1,\"typeName\":\"有害垃圾\"},{\"aipre\":0,\"contain\":\"常见包括砖瓦陶瓷、渣土、卫生间废纸、猫砂、污损塑料、毛发、硬壳、一次性制品、灰土、瓷器碎片等难以回收的废弃物\",\"explain\":\"干垃圾即其它垃圾，指除可回收物、有害垃圾、厨余垃圾（湿垃圾）以外的其它生活废弃物。\",\"name\":\"干电池（无汞）\",\"tip\":\"尽量沥干水分；难以辨识类别的生活垃圾都可以投入干垃圾容器内\",\"type\":3,\"typeName\":\"其他垃圾(干垃圾)\"},{\"aipre\":0,\"contain\":\"常见包括废电池、废荧光灯管、废灯泡、废水银温度计、废油漆桶、过期药品、农药、杀虫剂等。\",\"explain\":\"有毒有害垃圾是指存有对人体健康有害的重金属、有毒的物质或者对环境造成现实危害或者潜在危害的废弃物。\",\"name\":\"废电池\",\"tip\":\"分类投放有害垃圾时，应注意轻放。其中：废灯管等易破损的有害垃圾应连带包装或包裹后投放；废弃药品宜连带包装一并投放；杀虫剂等压力罐装容器，应排空内容物后投放；在公共场所产生有害垃圾且未发现对应收集容器时，应携带至有害垃圾投放点妥善投放。\",\"type\":1,\"typeName\":\"有害垃圾\"},{\"aipre\":0,\"contain\":\"常见包括废电池、废荧光灯管、废灯泡、废水银温度计、废油漆桶、过期药品、农药、杀虫剂等。\",\"explain\":\"有毒有害垃圾是指存有对人体健康有害的重金属、有毒的物质或者对环境造成现实危害或者潜在危害的废弃物。\",\"name\":\"手机充电电池\",\"tip\":\"分类投放有害垃圾时，应注意轻放。其中：废灯管等易破损的有害垃圾应连带包装或包裹后投放；废弃药品宜连带包装一并投放；杀虫剂等压力罐装容器，应排空内容物后投放；在公共场所产生有害垃圾且未发现对应收集容器时，应携带至有害垃圾投放点妥善投放。\",\"type\":1,\"typeName\":\"有害垃圾\"},{\"aipre\":0,\"contain\":\"常见包括废电池、废荧光灯管、废灯泡、废水银温度计、废油漆桶、过期药品、农药、杀虫剂等。\",\"explain\":\"有毒有害垃圾是指存有对人体健康有害的重金属、有毒的物质或者对环境造成现实危害或者潜在危害的废弃物。\",\"name\":\"手机电池\",\"tip\":\"分类投放有害垃圾时，应注意轻放。其中：废灯管等易破损的有害垃圾应连带包装或包裹后投放；废弃药品宜连带包装一并投放；杀虫剂等压力罐装容器，应排空内容物后投放；在公共场所产生有害垃圾且未发现对应收集容器时，应携带至有害垃圾投放点妥善投放。\",\"type\":1,\"typeName\":\"有害垃圾\"},{\"aipre\":0,\"contain\":\"常见包括砖瓦陶瓷、渣土、卫生间废纸、猫砂、污损塑料、毛发、硬壳、一次性制品、灰土、瓷器碎片等难以回收的废弃物\",\"explain\":\"干垃圾即其它垃圾，指除可回收物、有害垃圾、厨余垃圾（湿垃圾）以外的其它生活废弃物。\",\"name\":\"无汞电池\",\"tip\":\"尽量沥干水分；难以辨识类别的生活垃圾都可以投入干垃圾容器内\",\"type\":3,\"typeName\":\"其他垃圾(干垃圾)\"},{\"aipre\":0,\"contain\":\"常见包括废电池、废荧光灯管、废', 0, NULL, '2025-12-16 11:46:40', 588);
INSERT INTO `sys_oper_log` VALUES (231, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUSEhIWFRUXFxUXFRYVFxUXFhUVFRUXFhcVFxUYHSggGBolHRUVITEhJSkrLi4uFx8zODMsNygtLisBCgoKDg0OFxAQFysfHR0tLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLSstLS0rLS0tLS0tLS0tLS0tLf/AABEIAOEA4QMBIgACEQEDEQH/xAAcAAABBQEBAQAAAAAAAAAAAAADAAECBAUGBwj/xAA6EAABAwIDBQYGAQMDBQEAAAABAAIRAyEEMUEFElFhcRMigZGh8AYyscHR4VJCcvEjM2IHFIKS4hX/xAAZAQADAQEBAAAAAAAAAAAAAAABAgMABAX/xAAiEQACAgMBAAIDAQEAAAAAAAAAAQIRAxIhMQRBEyIyFFH/2gAMAwEAAhEDEQA/AOxCaVKUy8c9USYFOkFjCSTpisYYOUkySxhFNKeUoWMIlV8QEYlDddBhoqliYhWd1QcFoxbdIDAtCssCtYZ4GQHW0q4aLXNndAPECD5CxVvwtITczmIzUKudwwVXdiOcdEiQWy66oBmYQn4ngPP8Kk+pw/ah2Tj+06i2I5JBamInMzy08lXdJR24Y5n1TEjS6vHFXpKWSyLWIoaEgVB71ckSOaK2kEKk4opaTl5JWhkSFMKQbyQQ4hSFVLQ1k5SUO0SQoJZSTFOuI6hJJgU6xhJJikVjDpk28nlAwgmJTymCzMQKaFNQc5BJvwNpChBqhENT2PynpOBudMwFfHGnbF3TA4UkmACVr1CWdOdlT/7vRoG7yzB+iFVc51vd008yXELo2CruNU3sG3B62I6fhAxNMNggdRP0Vo4YtBkx7B/Kp0aILjvGeE6A2yXMptdYzjwJSxDNCB6K1vcIVCqxpO4LG9s8reqZ1OJLRBtabaeS6F8hIg8LLVbeOajTap4WuCIAknS5nKwUazXNJ3R55CfqZT/6Ii/hkScOKIKNpAtx/at4OiIFg48T+NFpAka/jyV4zUvBHGjnmJls4+i2oO62Hjhk7iI48FjrGQyUJyphYINJEhJY1llJNKdecdgkkydEwkydRmFjDwkoh08vfJRqP43TKDF3RPeCiT7zKAcUBb0/QQzWcchHX8Kixom8jC1Hez+NFXfiR/cfTzyTdjPzGeuXlkmfT4BVUCbmQNUnOw5flEwdKTIMff8AKEFZ3g0RxXNnmlxFsMH6yyYFoRsLTdIJB9PIhc1tbatSk3eB3gSAIaS7eOQAHHJcbtf4sx+HqAmuxrhfsWjtAAdKhJieinhg8nhTJOOP1nqvxBJDGtzcQPLXyk+Cz8dVDXyDf3CF8L7fbtCj2m72daldzMx3m/O06tP5GiI3CB+885kkN/tgD8pM0ZJhxyTjwpYGoS4u1Jtx4T75LSxNMNALvmOQ1KHgsDuOY0XgXPP7fpa1PBF1YveIDQAwfdJCLZR0geHwYDZ/qH04J2tnwEfaUbEOLflHUoFB55zPuyq+cJlnDsFhMdFcm0O8DxVUG0qw2sHNImCAYK7cU0+HPki7M9+Ig2QMQBvuj+TvqiCkG3JsPU8FXeZXQxJpLwQUmtUIUmpRAm5zSUZSWMEunUS5MCeQ8ZXAotnY5JE1Bzjp6odasG5lVatYnIeJt+1RYybyF0kcfsg1cSBYG/mVW3Cc3eARGsAsFVQRJz6R7dxyEcz+EjSJ+Yz6BFYzkpEp9QWAa0DRS3wpylKIo0qFR8IkqtXMkBLklrFsaKt0CM5qxhh/UfJHw+GnNadDBCCInmvN0cnZ3xnFKjH29TltGq1p/wBGq19RrRJNPdc0uDRnulzXxnDDAXimPY9mJcYNR7nvIMbzXNfZpa4yHd0zvZCRFwvoOns+5k2GV8uhzVWtsiiZ3aFNzjcktbMnMm1yuzDm0VNHHnw/kdpmB8CYYMc+uQ2mOx3HtYIZ2jnbwa0SbNHE/wBQXRYFjcvFctig6nVbhxDB', '{\"msg\":\"数据返回为空\",\"code\":500}', 0, NULL, '2025-12-16 11:46:57', 453);
INSERT INTO `sys_oper_log` VALUES (232, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAsJCQcJCQcJCQkJCwkJCQkJCQsJCwsMCwsLDA0QDBEODQ4MEhkSJRodJR0ZHxwpKRYlNzU2GioyPi0pMBk7IRP/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCAC6ARYDASIAAhEBAxEB/8QAHAAAAgMBAQEBAAAAAAAAAAAABAUCAwYBAAcI/8QAPhAAAgIBBAECBAQFAgUDAwUAAQIDBBEABRIhMRNBFCJRYQYycYEjQpGhsRVSJDPB0fBi4fElQ5IHFhdj4v/EABsBAAIDAQEBAAAAAAAAAAAAAAMEAQIFBgAH/8QAMxEAAQQABAMHAwQDAAMAAAAAAQACAxEEEiExQVFhBRMicYGR8KGx0TLB4fEUFSMGM0L/2gAMAwEAAhEDEQA/APpYSTv9frrogkY55aJCH31YMDwNZzWl2+iYMlbIYVmPljrpr48MdE69ohgaVXvXIQQyg9H+upelJj2P6aucEjrVYZl0BzRGadsrh7nBVFXXznXskaKBDDsai8Kt2Mg/bQ3YbOLZqvCXg5D5P117XWikU+Mj7aksLnsjA++lhC7NlARMzQLtQ7GO9WoT39c67wiX8zZOuetEvSjTcOGeDbtEJzwdlcudS0IbLew0P8arzPXEh9VV5MuCOuj0f3GtAUwAE76INJjgZ8jXsp7kaB5SH6/31wLKfY6tlC8jT6Oc8gNd9SIfzjQYilPsde9Gb/adS1jW/pUIv1Ij/MNeDRZ/MP66D9Gb/ade9GUfynXixu5UhHAp7MNS60uKSjwG1zlMv+4anKBsvUj3UkdeRoduQ85H6jVYsSr7/wBdTFsHpl60tLhhIbV2uyqlnkz02qWac+X6+2js1ZfIAP8ATUhXi8g5/XWc/BPTLZ2DglJjLEeSfvqwQP110NNRDEP5dSEaD+XXm4B45K5xl7BLoYG9SMknA70z1wIo7A713vT0EPdA2lJZDIbUH+x8fTVbZPecamxP071Ahj0fb30tKQTovNUP361799S4edeIwP20qGkaothdVte1xcd69qQSqGrVx1zUj3rmNapbxQl0a4RjUtcJ1Z1AaqAvajImRkY610a7qoGdtFTsbVAzkY851eDgfNgdaqeZEBC9nQzSSSH31WKHuzurHxIl50Xx3qhpnbx1+mvLCzYz1qzEMfkgn6aM5waLcVAHJU4dv31NYGPZwNeksxoPIXHucaFkurxVg3IMxVQpGSR561nz9pwQ6Xqjtw738EaIoV8sM6TbwFqzU9zgXJgdUnX/AHIehn+6/uNDy75EngEnJHXfY1GLeKVgTQyrG7yRyD05pAg4gZJPIY+479tZMvazMSO7b70nH9nSRszv0Hsn62oXSOSPiUdQyH6gjI14WSx4oAWA7A7I1ka1698BJWry15MOOAU5laNiWHHPjvPWgoN63CB2ihkHOUhDy8g5x50P/ZTOcGgacUzhOzP8qMvYRp1+63DXSrAFlBBwQ3XepmzKCFJTJHXHBHf3GsIZb0886yzn1UBZyST4+nHV8S/ivLKkTiH0Fk5M8YdiSfkCE5zj7aGzH4mzf3TMvZLIw23iz89ltPisHBdfHjI14WiT0yn+mstU27eiFmknjrse1SZWkbH/AKgvQ/rqdi2tBI2vJngxV3gcr6jEZHENj9dT/scXmoAe/wDCWfgIg7Kx4cei1QsH3A131kPRXWahvyXVg+G4wqyFouTF3lAOOyPpqc129SaNbBX58Yx3n6/fRHdsSxmnNPz2Q/8AWknLx5LR/wDDP5AGoGtC35W0nXc48x4ZXD/lKe/7aYCSTv5W+XGSvzAZGfbTuH7aZJpxScuEdHvoptVlXtcEarDTR/Ufrq5LLZ851b6sTdOP6jWtFi4pBoUuY3N3VSXD4cZH10Uksb+CP00M9aNwTGcZ', '{\"msg\":\"数据返回为空\",\"code\":500}', 0, NULL, '2025-12-16 11:57:51', 673);
INSERT INTO `sys_oper_log` VALUES (233, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAsJCQcJCQcJCQkJCwkJCQkJCQsJCwsMCwsLDA0QDBEODQ4MEhkSJRodJR0ZHxwpKRYlNzU2GioyPi0pMBk7IRP/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCAC6ARYDASIAAhEBAxEB/8QAHAAAAgMBAQEBAAAAAAAAAAAABAUCAwYBAAcI/8QAPhAAAgIBBAECBAQFAgUDAwUAAQIDBBEABRIhMRNBFCJRYQYycYEjQpGhsRVSJDPB0fBi4fElQ5IHFhdj4v/EABsBAAIDAQEBAAAAAAAAAAAAAAMEAQIFBgAH/8QAMxEAAQQABAMHAwQDAAMAAAAAAQACAxEEEiExQVFhBRMicYGR8KGx0TLB4fEUFSMGM0L/2gAMAwEAAhEDEQA/APpYSTv9frrogkY55aJCH31YMDwNZzWl2+iYMlbIYVmPljrpr48MdE69ohgaVXvXIQQyg9H+upelJj2P6aucEjrVYZl0BzRGadsrh7nBVFXXznXskaKBDDsai8Kt2Mg/bQ3YbOLZqvCXg5D5P117XWikU+Mj7aksLnsjA++lhC7NlARMzQLtQ7GO9WoT39c67wiX8zZOuetEvSjTcOGeDbtEJzwdlcudS0IbLew0P8arzPXEh9VV5MuCOuj0f3GtAUwAE76INJjgZ8jXsp7kaB5SH6/31wLKfY6tlC8jT6Oc8gNd9SIfzjQYilPsde9Gb/adS1jW/pUIv1Ij/MNeDRZ/MP66D9Gb/ade9GUfynXixu5UhHAp7MNS60uKSjwG1zlMv+4anKBsvUj3UkdeRoduQ85H6jVYsSr7/wBdTFsHpl60tLhhIbV2uyqlnkz02qWac+X6+2js1ZfIAP8ATUhXi8g5/XWc/BPTLZ2DglJjLEeSfvqwQP110NNRDEP5dSEaD+XXm4B45K5xl7BLoYG9SMknA70z1wIo7A713vT0EPdA2lJZDIbUH+x8fTVbZPecamxP071Ahj0fb30tKQTovNUP361799S4edeIwP20qGkaothdVte1xcd69qQSqGrVx1zUj3rmNapbxQl0a4RjUtcJ1Z1AaqAvajImRkY610a7qoGdtFTsbVAzkY851eDgfNgdaqeZEBC9nQzSSSH31WKHuzurHxIl50Xx3qhpnbx1+mvLCzYz1qzEMfkgn6aM5waLcVAHJU4dv31NYGPZwNeksxoPIXHucaFkurxVg3IMxVQpGSR561nz9pwQ6Xqjtw738EaIoV8sM6TbwFqzU9zgXJgdUnX/AHIehn+6/uNDy75EngEnJHXfY1GLeKVgTQyrG7yRyD05pAg4gZJPIY+479tZMvazMSO7b70nH9nSRszv0Hsn62oXSOSPiUdQyH6gjI14WSx4oAWA7A7I1ka1698BJWry15MOOAU5laNiWHHPjvPWgoN63CB2ihkHOUhDy8g5x50P/ZTOcGgacUzhOzP8qMvYRp1+63DXSrAFlBBwQ3XepmzKCFJTJHXHBHf3GsIZb0886yzn1UBZyST4+nHV8S/ivLKkTiH0Fk5M8YdiSfkCE5zj7aGzH4mzf3TMvZLIw23iz89ltPisHBdfHjI14WiT0yn+mstU27eiFmknjrse1SZWkbH/AKgvQ/rqdi2tBI2vJngxV3gcr6jEZHENj9dT/scXmoAe/wDCWfgIg7Kx4cei1QsH3A131kPRXWahvyXVg+G4wqyFouTF3lAOOyPpqc129SaNbBX58Yx3n6/fRHdsSxmnNPz2Q/8AWknLx5LR/wDDP5AGoGtC35W0nXc48x4ZXD/lKe/7aYCSTv5W+XGSvzAZGfbTuH7aZJpxScuEdHvoptVlXtcEarDTR/Ufrq5LLZ851b6sTdOP6jWtFi4pBoUuY3N3VSXD4cZH10Uksb+CP00M9aNwTGcZ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"lajitip\":\"夫妻肺片的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"夫妻肺片\",\"trust\":0},{\"lajitip\":\"重庆毛血旺的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"重庆毛血旺\",\"trust\":0},{\"lajitip\":\"钵钵鸡的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"钵钵鸡\",\"trust\":0},{\"lajitip\":\"水煮牛肉的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"水煮牛肉\",\"trust\":0},{\"lajitip\":\"粉丝是厨余湿垃圾，常见包括剩菜剩饭、果皮、蛋壳、骨头等。投放时应注意去除包装、分别投置。\",\"lajitype\":2,\"lajitypeName\":\"厨余垃圾(湿垃圾)\",\"name\":\"粉丝\",\"trust\":0}]}}', 0, NULL, '2025-12-16 12:03:10', 1490);
INSERT INTO `sys_oper_log` VALUES (234, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQEBLAEsAAD/4QCKRXhpZgAATU0AKgAAAAgABgEaAAUAAAABAAAAVgEbAAUAAAABAAAAXgEoAAMAAAABAAIAAAE7AAIAAAAKAAAAZgITAAMAAAABAAEAAIKYAAIAAAASAAAAcAAAAAAAAAEsAAAAAQAAASwAAAAB5pGE5Zu+572RAGh0dHA6Ly82OTlwaWMuY29tAP/iC+BJQ0NfUFJPRklMRQABAQAAC9AAAAAAAgAAAG1udHJSR0IgWFlaIAffAAIADwAAAAAAAGFjc3AAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAD21gABAAAAANMtAAAAAD0Ost6uk5e+m2cmzowKQ84AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEGRlc2MAAAFEAAAAY2JYWVoAAAGoAAAAFGJUUkMAAAG8AAAIDGdUUkMAAAG8AAAIDHJUUkMAAAG8AAAIDGRtZGQAAAnIAAAAiGdYWVoAAApQAAAAFGx1bWkAAApkAAAAFG1lYXMAAAp4AAAAJGJrcHQAAAqcAAAAFHJYWVoAAAqwAAAAFHRlY2gAAArEAAAADHZ1ZWQAAArQAAAAh3d0cHQAAAtYAAAAFGNwcnQAAAtsAAAAN2NoYWQAAAukAAAALGRlc2MAAAAAAAAACXNSR0IyMDE0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABYWVogAAAAAAAAJKAAAA+EAAC2z2N1cnYAAAAAAAAEAAAAAAUACgAPABQAGQAeACMAKAAtADIANwA7AEAARQBKAE8AVABZAF4AYwBoAG0AcgB3AHwAgQCGAIsAkACVAJoAnwCkAKkArgCyALcAvADBAMYAywDQANUA2wDgAOUA6wDwAPYA+wEBAQcBDQETARkBHwElASsBMgE4AT4BRQFMAVIBWQFgAWcBbgF1AXwBgwGLAZIBmgGhAakBsQG5AcEByQHRAdkB4QHpAfIB+gIDAgwCFAIdAiYCLwI4AkECSwJUAl0CZwJxAnoChAKOApgCogKsArYCwQLLAtUC4ALrAvUDAAMLAxYDIQMtAzgDQwNPA1oDZgNyA34DigOWA6IDrgO6A8cD0wPgA+wD+QQGBBMEIAQtBDsESARVBGMEcQR+BIwEmgSoBLYExATTBOEE8AT+BQ0FHAUrBToFSQVYBWcFdwWGBZYFpgW1BcUF1QXlBfYGBgYWBicGNwZIBlkGagZ7BowGnQavBsAG0QbjBvUHBwcZBysHPQdPB2EHdAeGB5kHrAe/B9IH5Qf4CAsIHwgyCEYIWghuCIIIlgiqCL4I0gjnCPsJEAklCToJTwlkCXkJjwmkCboJzwnlCfsKEQonCj0KVApqCoEKmAquCsUK3ArzCwsLIgs5C1ELaQuAC5gLsAvIC+EL+QwSDCoMQwxcDHUMjgynDMAM2QzzDQ0NJg1ADVoNdA2ODakNww3eDfgOEw4uDkkOZA5/DpsOtg7SDu4PCQ8lD0EPXg96D5YPsw/PD+wQCRAmEEMQYRB+EJsQuRDXEPURExExEU8RbRGMEaoRyRHoEgcSJhJFEmQShBKjEsMS4xMDEyMTQxNjE4MTpBPFE+UUBhQnFEkUahSLFK0UzhTwFRIVNBVWFXgVmxW9FeAWAxYmFkkWbBaPFrIW1hb6Fx0XQRdlF4kXrhfSF/cYGxhAGGUYihivGNUY+hkgGUUZaxmRGbcZ3RoEGioaURp3Gp4axRrsGxQbOxtjG4obshvaHAIcKhxSHHscoxzMHPUdHh1HHXAdmR3DHeweFh5AHmoelB6+HukfEx8+H2kflB+/H+ogFSBBIGwgmCDEIPAhHCFIIXUhoSHOIfsiJyJVIoIiryLdIwojOCNmI5QjwiPwJB8kTSR8JKsk2iUJJTglaCWX', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"lajitip\":\"屏幕截图的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"屏幕截图\",\"trust\":0},{\"lajitip\":\"瓶饮的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"瓶饮\",\"trust\":0},{\"lajitip\":\"显示器屏幕是可回收垃圾，常见包括各类废金属、玻璃瓶、饮料瓶、电子产品等。投放时应注意轻投轻放、清洁干燥、避免污染。\",\"lajitype\":0,\"lajitypeName\":\"可回收垃圾\",\"name\":\"显示器屏幕\",\"trust\":0},{\"lajitip\":\"吊灯的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"吊灯\",\"trust\":0},{\"lajitip\":\"瓶子是有毒有害垃圾，常见包括废电池、废油漆桶、各类过期药品等。投放时应注意尽量排空内容物或包裹妥善后投放。\",\"lajitype\":1,\"lajitypeName\":\"有害垃圾\",\"name\":\"瓶子\",\"trust\":0}]}}', 0, NULL, '2025-12-16 12:08:37', 1801);
INSERT INTO `sys_oper_log` VALUES (235, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQEBLAEsAAD/4QCKRXhpZgAATU0AKgAAAAgABgEaAAUAAAABAAAAVgEbAAUAAAABAAAAXgEoAAMAAAABAAIAAAE7AAIAAAAKAAAAZgITAAMAAAABAAEAAIKYAAIAAAASAAAAcAAAAAAAAAEsAAAAAQAAASwAAAAB5pGE5Zu+572RAGh0dHA6Ly82OTlwaWMuY29tAP/iC+BJQ0NfUFJPRklMRQABAQAAC9AAAAAAAgAAAG1udHJSR0IgWFlaIAffAAIADwAAAAAAAGFjc3AAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAD21gABAAAAANMtAAAAAD0Ost6uk5e+m2cmzowKQ84AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEGRlc2MAAAFEAAAAY2JYWVoAAAGoAAAAFGJUUkMAAAG8AAAIDGdUUkMAAAG8AAAIDHJUUkMAAAG8AAAIDGRtZGQAAAnIAAAAiGdYWVoAAApQAAAAFGx1bWkAAApkAAAAFG1lYXMAAAp4AAAAJGJrcHQAAAqcAAAAFHJYWVoAAAqwAAAAFHRlY2gAAArEAAAADHZ1ZWQAAArQAAAAh3d0cHQAAAtYAAAAFGNwcnQAAAtsAAAAN2NoYWQAAAukAAAALGRlc2MAAAAAAAAACXNSR0IyMDE0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABYWVogAAAAAAAAJKAAAA+EAAC2z2N1cnYAAAAAAAAEAAAAAAUACgAPABQAGQAeACMAKAAtADIANwA7AEAARQBKAE8AVABZAF4AYwBoAG0AcgB3AHwAgQCGAIsAkACVAJoAnwCkAKkArgCyALcAvADBAMYAywDQANUA2wDgAOUA6wDwAPYA+wEBAQcBDQETARkBHwElASsBMgE4AT4BRQFMAVIBWQFgAWcBbgF1AXwBgwGLAZIBmgGhAakBsQG5AcEByQHRAdkB4QHpAfIB+gIDAgwCFAIdAiYCLwI4AkECSwJUAl0CZwJxAnoChAKOApgCogKsArYCwQLLAtUC4ALrAvUDAAMLAxYDIQMtAzgDQwNPA1oDZgNyA34DigOWA6IDrgO6A8cD0wPgA+wD+QQGBBMEIAQtBDsESARVBGMEcQR+BIwEmgSoBLYExATTBOEE8AT+BQ0FHAUrBToFSQVYBWcFdwWGBZYFpgW1BcUF1QXlBfYGBgYWBicGNwZIBlkGagZ7BowGnQavBsAG0QbjBvUHBwcZBysHPQdPB2EHdAeGB5kHrAe/B9IH5Qf4CAsIHwgyCEYIWghuCIIIlgiqCL4I0gjnCPsJEAklCToJTwlkCXkJjwmkCboJzwnlCfsKEQonCj0KVApqCoEKmAquCsUK3ArzCwsLIgs5C1ELaQuAC5gLsAvIC+EL+QwSDCoMQwxcDHUMjgynDMAM2QzzDQ0NJg1ADVoNdA2ODakNww3eDfgOEw4uDkkOZA5/DpsOtg7SDu4PCQ8lD0EPXg96D5YPsw/PD+wQCRAmEEMQYRB+EJsQuRDXEPURExExEU8RbRGMEaoRyRHoEgcSJhJFEmQShBKjEsMS4xMDEyMTQxNjE4MTpBPFE+UUBhQnFEkUahSLFK0UzhTwFRIVNBVWFXgVmxW9FeAWAxYmFkkWbBaPFrIW1hb6Fx0XQRdlF4kXrhfSF/cYGxhAGGUYihivGNUY+hkgGUUZaxmRGbcZ3RoEGioaURp3Gp4axRrsGxQbOxtjG4obshvaHAIcKhxSHHscoxzMHPUdHh1HHXAdmR3DHeweFh5AHmoelB6+HukfEx8+H2kflB+/H+ogFSBBIGwgmCDEIPAhHCFIIXUhoSHOIfsiJyJVIoIiryLdIwojOCNmI5QjwiPwJB8kTSR8JKsk2iUJJTglaCWX', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"lajitip\":\"屏幕截图的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"屏幕截图\",\"trust\":0},{\"lajitip\":\"瓶饮的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"瓶饮\",\"trust\":0},{\"lajitip\":\"显示器屏幕是可回收垃圾，常见包括各类废金属、玻璃瓶、饮料瓶、电子产品等。投放时应注意轻投轻放、清洁干燥、避免污染。\",\"lajitype\":0,\"lajitypeName\":\"可回收垃圾\",\"name\":\"显示器屏幕\",\"trust\":0},{\"lajitip\":\"吊灯的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"吊灯\",\"trust\":0},{\"lajitip\":\"瓶子是有毒有害垃圾，常见包括废电池、废油漆桶、各类过期药品等。投放时应注意尽量排空内容物或包裹妥善后投放。\",\"lajitype\":1,\"lajitypeName\":\"有害垃圾\",\"name\":\"瓶子\",\"trust\":0}]}}', 0, NULL, '2025-12-16 12:09:41', 490);
INSERT INTO `sys_oper_log` VALUES (236, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQEASABIAAD/4QCKRXhpZgAATU0AKgAAAAgABgEaAAUAAAABAAAAVgEbAAUAAAABAAAAXgEoAAMAAAABAAIAAAE7AAIAAAAKAAAAZgITAAMAAAABAAEAAIKYAAIAAAASAAAAcAAAAAAAAABIAAAAAQAAAEgAAAAB5pGE5Zu+572RAGh0dHA6Ly82OTlwaWMuY29tAP/iC+BJQ0NfUFJPRklMRQABAQAAC9AAAAAAAgAAAG1udHJSR0IgWFlaIAffAAIADwAAAAAAAGFjc3AAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAD21gABAAAAANMtAAAAAD0Ost6uk5e+m2cmzowKQ84AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEGRlc2MAAAFEAAAAY2JYWVoAAAGoAAAAFGJUUkMAAAG8AAAIDGdUUkMAAAG8AAAIDHJUUkMAAAG8AAAIDGRtZGQAAAnIAAAAiGdYWVoAAApQAAAAFGx1bWkAAApkAAAAFG1lYXMAAAp4AAAAJGJrcHQAAAqcAAAAFHJYWVoAAAqwAAAAFHRlY2gAAArEAAAADHZ1ZWQAAArQAAAAh3d0cHQAAAtYAAAAFGNwcnQAAAtsAAAAN2NoYWQAAAukAAAALGRlc2MAAAAAAAAACXNSR0IyMDE0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABYWVogAAAAAAAAJKAAAA+EAAC2z2N1cnYAAAAAAAAEAAAAAAUACgAPABQAGQAeACMAKAAtADIANwA7AEAARQBKAE8AVABZAF4AYwBoAG0AcgB3AHwAgQCGAIsAkACVAJoAnwCkAKkArgCyALcAvADBAMYAywDQANUA2wDgAOUA6wDwAPYA+wEBAQcBDQETARkBHwElASsBMgE4AT4BRQFMAVIBWQFgAWcBbgF1AXwBgwGLAZIBmgGhAakBsQG5AcEByQHRAdkB4QHpAfIB+gIDAgwCFAIdAiYCLwI4AkECSwJUAl0CZwJxAnoChAKOApgCogKsArYCwQLLAtUC4ALrAvUDAAMLAxYDIQMtAzgDQwNPA1oDZgNyA34DigOWA6IDrgO6A8cD0wPgA+wD+QQGBBMEIAQtBDsESARVBGMEcQR+BIwEmgSoBLYExATTBOEE8AT+BQ0FHAUrBToFSQVYBWcFdwWGBZYFpgW1BcUF1QXlBfYGBgYWBicGNwZIBlkGagZ7BowGnQavBsAG0QbjBvUHBwcZBysHPQdPB2EHdAeGB5kHrAe/B9IH5Qf4CAsIHwgyCEYIWghuCIIIlgiqCL4I0gjnCPsJEAklCToJTwlkCXkJjwmkCboJzwnlCfsKEQonCj0KVApqCoEKmAquCsUK3ArzCwsLIgs5C1ELaQuAC5gLsAvIC+EL+QwSDCoMQwxcDHUMjgynDMAM2QzzDQ0NJg1ADVoNdA2ODakNww3eDfgOEw4uDkkOZA5/DpsOtg7SDu4PCQ8lD0EPXg96D5YPsw/PD+wQCRAmEEMQYRB+EJsQuRDXEPURExExEU8RbRGMEaoRyRHoEgcSJhJFEmQShBKjEsMS4xMDEyMTQxNjE4MTpBPFE+UUBhQnFEkUahSLFK0UzhTwFRIVNBVWFXgVmxW9FeAWAxYmFkkWbBaPFrIW1hb6Fx0XQRdlF4kXrhfSF/cYGxhAGGUYihivGNUY+hkgGUUZaxmRGbcZ3RoEGioaURp3Gp4axRrsGxQbOxtjG4obshvaHAIcKhxSHHscoxzMHPUdHh1HHXAdmR3DHeweFh5AHmoelB6+HukfEx8+H2kflB+/H+ogFSBBIGwgmCDEIPAhHCFIIXUhoSHOIfsiJyJVIoIiryLdIwojOCNmI5QjwiPwJB8kTSR8JKsk2iUJJTglaCWX', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"lajitip\":\"玩具是可回收垃圾，常见包括各类废金属、玻璃瓶、饮料瓶、电子产品等。投放时应注意轻投轻放、清洁干燥、避免污染。\",\"lajitype\":0,\"lajitypeName\":\"可回收垃圾\",\"name\":\"玩具\",\"trust\":0},{\"lajitip\":\"原材料的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"原材料\",\"trust\":0},{\"lajitip\":\"工艺品是可回收垃圾，常见包括各类废金属、玻璃瓶、饮料瓶、电子产品等。投放时应注意轻投轻放、清洁干燥、避免污染。\",\"lajitype\":0,\"lajitypeName\":\"可回收垃圾\",\"name\":\"工艺品\",\"trust\":0},{\"lajitip\":\"沙发是可回收垃圾，常见包括各类废金属、玻璃瓶、饮料瓶、电子产品等。投放时应注意轻投轻放、清洁干燥、避免污染。\",\"lajitype\":0,\"lajitypeName\":\"可回收垃圾\",\"name\":\"沙发\",\"trust\":0},{\"lajitip\":\"纤维棉的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"纤维棉\",\"trust\":0}]}}', 0, NULL, '2025-12-16 12:11:10', 2771);
INSERT INTO `sys_oper_log` VALUES (237, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAsJCQcJCQcJCQkJCwkJCQkJCQsJCwsMCwsLDA0QDBEODQ4MEhkSJRodJR0ZHxwpKRYlNzU2GioyPi0pMBk7IRP/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCAC0AJ8DASIAAhEBAxEB/8QAHAAAAQUBAQEAAAAAAAAAAAAAAAEDBAUGAgcI/8QAOhAAAgEDAgQFAQYFAgcBAAAAAQIDAAQREiEFMUFREyJhcYGRBhQyobHBQlLR4fAzcgcVIyRDYqLx/8QAGwEAAgMBAQEAAAAAAAAAAAAAAAMCBAUBBgf/xAArEQACAgICAQIFAwUAAAAAAAAAAQIRAyEEEjFBUQUTImFxFNHwMoGRobH/2gAMAwEAAhEDEQA/APU9+5o37miipALv3NJv3NFFABv3NLv3NJS0AJv3NG/c0UUAG/c0u/c0lFABv3NG/c0UUAG/c0b9zRRQAu/c0m/c0UUAG/c0u/c0lFABv3NG/c0UUAFFFFABRRRQAUtJRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUtACUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFdhDQ2iNWd2CqoyxPICi6Dzo5wa5keOFC8jKo7sQB35mqfiX2l4XYRuUngmmUjMKZYjqdTg4rK8S4nxDjcSwRxtF4Qllj1PjXEw1K7EnGBnB26Z9qGbnY8eo7Zscb4VlyOM8/0Qb8vX/aL/iX2s4XZ5EEonkBwdK+Qd8MdzXXDvtXZ31xbWYjzcTmQL4bgqRHH4zDB31Y6fnXmNxa3Kto8aGUBf8Axzwv1zjSHziq/wALiEc0UsJnidSoVolc51bEak3325VSxczJKdydI3+d8J4ceF34b7y/O/8AC/Y+gA8ZR5M5RNWWG48vPBFUt99oeGW2hDdRiR0dhGql3ULtiTB2J6VmE4jaPwi3trG1uImif7tdyQO72baIfFfxC7c+50n0JOwzsNrbzLLdJFJGupXj+/ztFFID0WVgoP1+adm5sk0omP8ADuHxnF5eU2kvZKvby9fzya5fttGjv4y6YcDS7IcDfGcLuf8AO1W1r9oUubW3uAFAmVmU4I8oYrnBJ542rIWHC+JcZAtoorA2uzSuJnmCpq05Vk2J9NdbKP7PWVtBCgISKCNYxqkCRhV8oydz+dZ+bPzMkK4/n3EfFI8VZE+Pr7Wmvzab/wAEy34rBMwU6twSSikhcdDjfJqyx2rPPJDYSCKJIZUKnLRsTpbkQ22NulXFldxToo1YfqCAPpitD4fnyTThmdtfz+5k9ZVdEjFGK7NR3mVZ44ydzGzY+Rj961iI7iilGCKTY5wc4OD70AJS0GkoAKKKKAIknEwMgaF+rGqTjl5xC5sjbWaTy3NxKqLHEhLGMbk45Adya0KcPtYxuM05qhgHkVRnYYA3A7mq+aCnBxvyXuLnWDLHIo3Xuee2v2D41chXvru3tFbdo0BuJVHY4IT/AOjVuv8Aw/4T4eiTiXFidOljHJAikc9Okxnb0JNaY3LMeYwK4a6OMZ99qq4+Phx/0o0ed8U53OXTNJdfZJV+/wDszU/2E4L4iSrd3aOpBIEdoysR1KGPTn4pni3Ari2tVfgiPLdJjxHuXWeYqMn/AKMcy+GD7YrTNcA49dh603qY7jOM/FRlhxvSRCPKzNRWZ91H0ltfuYXgcd9FJw5eIFoOGrqkihlgVZGMRKvPIEXXjPlXON27LvaXY4bxS+knvRJNbBYhb2z+a3QwgjUqcwW6747g9LbiPC4rtmuQpW9EH3dX1EK8QfxBG/TnyPr25c8Dso7dfvV1qMmZEihkVcLg41kHfPb69awuRx+TLOscf6Xu/wACc+W8qnhh1Ven5/m/+E9OFW5WLPixReHr', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"lajitip\":\"猪蹄（生）的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"猪蹄（生）\",\"trust\":0},{\"lajitip\":\"牛肉是厨余湿垃圾，常见包括剩菜剩饭、果皮、蛋壳、骨头等。投放时应注意去除包装、分别投置。\",\"lajitype\":2,\"lajitypeName\":\"厨余垃圾(湿垃圾)\",\"name\":\"牛肉\",\"trust\":0},{\"lajitip\":\"羊肉是厨余湿垃圾，常见包括剩菜剩饭、果皮、蛋壳、骨头等。投放时应注意去除包装、分别投置。\",\"lajitype\":2,\"lajitypeName\":\"厨余垃圾(湿垃圾)\",\"name\":\"羊肉\",\"trust\":0},{\"lajitip\":\"牛肉片/卷（生）的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"牛肉片/卷（生）\",\"trust\":0},{\"lajitip\":\"包装食品的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"包装食品\",\"trust\":0}]}}', 0, NULL, '2025-12-16 12:15:25', 1494);
INSERT INTO `sys_oper_log` VALUES (238, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"玻璃瓶\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"化妆品玻璃瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"巴黎水玻璃瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"玻璃瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"精华玻璃瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括砖瓦陶瓷、渣土、卫生间废纸、猫砂、污损塑料、毛发、硬壳、一次性制品、灰土、瓷器碎片等难以回收的废弃物\",\"explain\":\"干垃圾即其它垃圾，指除可回收物、有害垃圾、厨余垃圾（湿垃圾）以外的其它生活废弃物。\",\"name\":\"脏玻璃瓶\",\"tip\":\"尽量沥干水分；难以辨识类别的生活垃圾都可以投入干垃圾容器内\",\"type\":3,\"typeName\":\"其他垃圾(干垃圾)\"},{\"aipre\":0,\"contain\":\"常见包括废电池、废荧光灯管、废灯泡、废水银温度计、废油漆桶、过期药品、农药、杀虫剂等。\",\"explain\":\"有毒有害垃圾是指存有对人体健康有害的重金属、有毒的物质或者对环境造成现实危害或者潜在危害的废弃物。\",\"name\":\"药水玻璃瓶\",\"tip\":\"分类投放有害垃圾时，应注意轻放。其中：废灯管等易破损的有害垃圾应连带包装或包裹后投放；废弃药品宜连带包装一并投放；杀虫剂等压力罐装容器，应排空内容物后投放；在公共场所产生有害垃圾且未发现对应收集容器时，应携带至有害垃圾投放点妥善投放。\",\"type\":1,\"typeName\":\"有害垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"酸奶玻璃瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"食用油玻璃瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利', 0, NULL, '2025-12-16 13:54:49', 353);
INSERT INTO `sys_oper_log` VALUES (239, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"灯泡\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"灯泡\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"电灯泡\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"白炽灯泡\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"小灯泡\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"}]}}', 0, NULL, '2025-12-16 13:54:56', 500);
INSERT INTO `sys_oper_log` VALUES (240, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"纸巾\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"aipre\":1,\"contain\":\"常见包括砖瓦陶瓷、渣土、卫生间废纸、猫砂、污损塑料、毛发、硬壳、一次性制品、灰土、瓷器碎片等难以回收的废弃物\",\"explain\":\"干垃圾即其它垃圾，指除可回收物、有害垃圾、厨余垃圾（湿垃圾）以外的其它生活废弃物。\",\"name\":\"纸巾\",\"tip\":\"尽量沥干水分；难以辨识类别的生活垃圾都可以投入干垃圾容器内\",\"type\":3,\"typeName\":\"其他垃圾(干垃圾)\"}]}}', 0, NULL, '2025-12-16 13:55:07', 200);
INSERT INTO `sys_oper_log` VALUES (241, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAsJCQcJCQcJCQkJCwkJCQkJCQsJCwsMCwsLDA0QDBEODQ4MEhkSJRodJR0ZHxwpKRYlNzU2GioyPi0pMBk7IRP/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCAC6ARYDASIAAhEBAxEB/8QAHAAAAgMBAQEBAAAAAAAAAAAABAUCAwYBAAcI/8QAPhAAAgIBBAECBAQFAgUDAwUAAQIDBBEABRIhMRNBFCJRYQYycYEjQpGhsRVSJDPB0fBi4fElQ5IHFhdj4v/EABsBAAIDAQEBAAAAAAAAAAAAAAMEAQIFBgAH/8QAMxEAAQQABAMHAwQDAAMAAAAAAQACAxEEEiExQVFhBRMicYGR8KGx0TLB4fEUFSMGM0L/2gAMAwEAAhEDEQA/APpYSTv9frrogkY55aJCH31YMDwNZzWl2+iYMlbIYVmPljrpr48MdE69ohgaVXvXIQQyg9H+upelJj2P6aucEjrVYZl0BzRGadsrh7nBVFXXznXskaKBDDsai8Kt2Mg/bQ3YbOLZqvCXg5D5P117XWikU+Mj7aksLnsjA++lhC7NlARMzQLtQ7GO9WoT39c67wiX8zZOuetEvSjTcOGeDbtEJzwdlcudS0IbLew0P8arzPXEh9VV5MuCOuj0f3GtAUwAE76INJjgZ8jXsp7kaB5SH6/31wLKfY6tlC8jT6Oc8gNd9SIfzjQYilPsde9Gb/adS1jW/pUIv1Ij/MNeDRZ/MP66D9Gb/ade9GUfynXixu5UhHAp7MNS60uKSjwG1zlMv+4anKBsvUj3UkdeRoduQ85H6jVYsSr7/wBdTFsHpl60tLhhIbV2uyqlnkz02qWac+X6+2js1ZfIAP8ATUhXi8g5/XWc/BPTLZ2DglJjLEeSfvqwQP110NNRDEP5dSEaD+XXm4B45K5xl7BLoYG9SMknA70z1wIo7A713vT0EPdA2lJZDIbUH+x8fTVbZPecamxP071Ahj0fb30tKQTovNUP361799S4edeIwP20qGkaothdVte1xcd69qQSqGrVx1zUj3rmNapbxQl0a4RjUtcJ1Z1AaqAvajImRkY610a7qoGdtFTsbVAzkY851eDgfNgdaqeZEBC9nQzSSSH31WKHuzurHxIl50Xx3qhpnbx1+mvLCzYz1qzEMfkgn6aM5waLcVAHJU4dv31NYGPZwNeksxoPIXHucaFkurxVg3IMxVQpGSR561nz9pwQ6Xqjtw738EaIoV8sM6TbwFqzU9zgXJgdUnX/AHIehn+6/uNDy75EngEnJHXfY1GLeKVgTQyrG7yRyD05pAg4gZJPIY+479tZMvazMSO7b70nH9nSRszv0Hsn62oXSOSPiUdQyH6gjI14WSx4oAWA7A7I1ka1698BJWry15MOOAU5laNiWHHPjvPWgoN63CB2ihkHOUhDy8g5x50P/ZTOcGgacUzhOzP8qMvYRp1+63DXSrAFlBBwQ3XepmzKCFJTJHXHBHf3GsIZb0886yzn1UBZyST4+nHV8S/ivLKkTiH0Fk5M8YdiSfkCE5zj7aGzH4mzf3TMvZLIw23iz89ltPisHBdfHjI14WiT0yn+mstU27eiFmknjrse1SZWkbH/AKgvQ/rqdi2tBI2vJngxV3gcr6jEZHENj9dT/scXmoAe/wDCWfgIg7Kx4cei1QsH3A131kPRXWahvyXVg+G4wqyFouTF3lAOOyPpqc129SaNbBX58Yx3n6/fRHdsSxmnNPz2Q/8AWknLx5LR/wDDP5AGoGtC35W0nXc48x4ZXD/lKe/7aYCSTv5W+XGSvzAZGfbTuH7aZJpxScuEdHvoptVlXtcEarDTR/Ufrq5LLZ851b6sTdOP6jWtFi4pBoUuY3N3VSXD4cZH10Uksb+CP00M9aNwTGcZ', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"lajitip\":\"夫妻肺片的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"夫妻肺片\",\"trust\":0},{\"lajitip\":\"重庆毛血旺的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"重庆毛血旺\",\"trust\":0},{\"lajitip\":\"钵钵鸡的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"钵钵鸡\",\"trust\":0},{\"lajitip\":\"水煮牛肉的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"水煮牛肉\",\"trust\":0},{\"lajitip\":\"粉丝是厨余湿垃圾，常见包括剩菜剩饭、果皮、蛋壳、骨头等。投放时应注意去除包装、分别投置。\",\"lajitype\":2,\"lajitypeName\":\"厨余垃圾(湿垃圾)\",\"name\":\"粉丝\",\"trust\":0}]}}', 0, NULL, '2025-12-16 13:55:25', 399);
INSERT INTO `sys_oper_log` VALUES (242, '垃圾分类类别', 2, 'com.yaoliyun.system.controller.GarbageCategoryController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/category', '127.0.0.1', '内网IP', '{\"categoryCode\":\"recyclable\",\"categoryId\":1,\"categoryName\":\"可回收物\",\"colorCode\":\"#3498db\",\"createBy\":\"admin\",\"createTime\":\"2025-12-13 16:24:53\",\"description\":\"可回收物是指适宜回收利用和资源化利用的生活废弃物，包括废纸、废塑料、废金属、废玻璃、废织物等。\",\"disposalGuidelines\":\"投放要求：\\n1. 纸类应尽量叠放整齐，避免揉团，纸板也应拆开叠放\\n2. 塑料垃圾应清空内容物，清洁后压扁投放\\n3. 玻璃类应轻投轻放，有尖锐边角的应包裹后投放\\n4. 织物应叠放整齐，避免污染\\n5. 金属类应清洁干燥，避免混入其他垃圾\",\"iconUrl\":\"http://localhost:8080/profile/upload/2025/12/16/0541.jpg_wh860_20251216140946A001.jpg\",\"params\":{},\"sortOrder\":1,\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2025-12-16 14:09:49\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 14:09:49', 28);
INSERT INTO `sys_oper_log` VALUES (243, '角色管理', 2, 'com.yaoliyun.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-08-07 11:38:58\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2179,2180,2,2181,2186,2187,2188,2189,2190,2191,2192,2193,2194,2195,2196,2197,2198,2199,2200,2201,2202,2203,2204,2205,2206,2207,2208,2209,1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,2050,116,1055,1056,1057,1058,1059,1060,2051,117,2052,2053,2060,2061,2062,2063,2064,2065,2066,2067,2068,2069,4],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-16 14:10:18', 34);
INSERT INTO `sys_oper_log` VALUES (244, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"塑料瓶\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"PET塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶瓶盖\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶盖\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"牛奶塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"硬质塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶子\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"}]}}', 0, NULL, '2025-12-17 17:57:50', 305);
INSERT INTO `sys_oper_log` VALUES (245, '垃圾识别', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.recognize()', 'POST', 1, 'admin', '研发部门', '/system/recognition/recognize', '127.0.0.1', '内网IP', '{\"img\":\"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAsJCQcJCQcJCQkJCwkJCQkJCQsJCwsMCwsLDA0QDBEODQ4MEhkSJRodJR0ZHxwpKRYlNzU2GioyPi0pMBk7IRP/2wBDAQcICAsJCxULCxUsHRkdLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCz/wAARCADJAS4DASIAAhEBAxEB/8QAHAAAAgMBAQEBAAAAAAAAAAAABAUCAwYBBwAI/8QATRAAAgEDAgMFBAQICwcDBQAAAQIDAAQRBSESMUEGEyJRcRQyYYFCkaGxFSNSU3JzksEHFiQzNIKDk6Ky0TVDYsLS4fAlRXRUVWOUw//EABsBAAIDAQEBAAAAAAAAAAAAAAMEAQIFBgAH/8QAMxEAAgIBAwMDAQYFBQEAAAAAAAECAxEEEiETMUEFIlEyFGFxkaHRI0JSgbEVJJLB4fH/2gAMAwEAAhEDEQA/APUeI5O/Wu8Rqonc+tfZrMUhxxLeI+dc4j51DIrmRVmyFEs4vjXOI+dQyK+J2qE+CcHxJ86jxHzqJaocVC8hMcEyT50LKxwd/tq4tQszbGhXL2lodwR3OTvQzO2+9WOd6Hc86yPI0RZz51U0h33rjHnVDGjIGybTMOtDyTMetcc0LI+KOijJtMwOc18LodTigneqS9GjwDkhmbwAc/tqs37Z2NLC533qPF8aMmwTRobXU8MMsa11jeCRFw3P415ishBByae6ZqhiIVjttimqrMcMXnHHY9FWXON6kZDg70gt9TiYDxjpRPtsZ+kPlTe5AwueTnuazep6l7PxHi5edMLm8RVJBGcVhdauHmfhB5k0JzTeA8Km1kJbtfJAxAUsB5YFFW/8IMaMolt5uEkZIKnA9Kx72jkEnOaVTqY2pquS7FZ0n6C0rU7XVLaO4gYMrqD8fQ0dIvEjr5g15F/B/rTW91Jp0r/i5cywZPJh7yj769dDBlBHUVM0Ai2nhnnGqIyXU6sMEMdvh50olb4nrRH8IM95a6jZmB+BZYJC22xKtVjhF0e2uZU8fcRsxx1K1nS9rwa0J7kZm4VpZipPhU5NK74KHUKcgc6MmuQobfxMd/nQgQysQQcDfNGigcmDKh4vl99bjsqvc2WsXRBL3U62MJH5Ead8+MHpkVjJCqTMpOAEzn6q9E0aG3g0zsgz8KQIl5rd+3RYXiMwJ88gKPnV5wdixEGpqDyzz/tjaGx7SaxCQQHkjnXPlNEkn7zUZL9pNO0RVGDDbzQOxOcmOUgbemKN7c3lnql/ZanayI/f23c3HCCrLJA5A41bcHhIpXpUCXkEkLcXFDM0gK5J4ZFXb7DWvpf4UtrM7VYshuR+hGbc+tdU1SzDiNdV65jya3guzXCahxVAvVpFUW8VfE1XxCvi1THsefc+Y1DiqDuKhxihZWS/gtZqEmbnU3kFCSyDehWyyiYrkpdt6HduddeSh3fnWaHycc/GqHbnXzvQzvRIrJRs+d+dDSNmuPJ8apZs0xGJRsixqljU2NVGjJFGRJqBNSJ+NVk1dA2fcVTSQqdj8aoJrnFRAUhrFfSoOZNN7C5muGJySoOKyqM7EhEduHHFwKzYz58IraaLacFtGxB4n8RyPOvTlJImqG6RO5LBDknYVnHjM07MeQO1aTVCsUbeZ5Ujh4cE9edRVl8mi4pcFM0ShMY6VmNRQBjjzrU3DbGszqAzxnoKcrzkDYuBdZ3UlldWt0hw0EqyeoB3FfoHSbxLu1t5FbIeNWB8wRmvzm3M+tesdhNU47G2t5G8UQMY35gcqdyZ1scPJd250176fTmROIqZEbHkxWlWvNNDZ2GmAYZ1D581jGMVtNWZTNZsR/vR/rWe1ez/AAtf2gtzxSWykMByUNjdzyrNsb6qSHqsKrLMBFYzT967BivEFQKPEzeQFPo9AvTArSGOAlRhW3b51qBDpGixHvFa4veQEa54WP0Q', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"lajitip\":\"书籍是可回收垃圾，常见包括各类废金属、玻璃瓶、饮料瓶、电子产品等。投放时应注意轻投轻放、清洁干燥、避免污染。\",\"lajitype\":0,\"lajitypeName\":\"可回收垃圾\",\"name\":\"书籍\",\"trust\":0},{\"lajitip\":\"家具是可回收垃圾，常见包括各类废金属、玻璃瓶、饮料瓶、电子产品等。投放时应注意轻投轻放、清洁干燥、避免污染。\",\"lajitype\":0,\"lajitypeName\":\"可回收垃圾\",\"name\":\"家具\",\"trust\":0},{\"lajitip\":\"教室的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"教室\",\"trust\":0},{\"lajitip\":\"书本是可回收垃圾，常见包括各类废金属、玻璃瓶、饮料瓶、电子产品等。投放时应注意轻投轻放、清洁干燥、避免污染。\",\"lajitype\":0,\"lajitypeName\":\"可回收垃圾\",\"name\":\"书本\",\"trust\":0},{\"lajitip\":\"七项全能的垃圾分类系统暂时无法判别，请重新尝试拍摄物体的主要特征。\",\"lajitype\":4,\"lajitypeName\":\"未知结果\",\"name\":\"七项全能\",\"trust\":0}]}}', 0, NULL, '2025-12-17 17:59:53', 1369);
INSERT INTO `sys_oper_log` VALUES (246, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"塑料瓶\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"PET塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶瓶盖\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶盖\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"牛奶塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"硬质塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶子\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"}]}}', 0, NULL, '2025-12-17 18:01:22', 160);
INSERT INTO `sys_oper_log` VALUES (247, '菜单管理', 2, 'com.yaoliyun.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-08-07 11:38:58\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-17 18:02:53', 11);
INSERT INTO `sys_oper_log` VALUES (248, 'AI简单聊天', 0, 'com.yaoliyun.web.controller.ai.AiChatController.simpleChat()', 'POST', 1, 'admin', '研发部门', '/ai/chat/simple', '127.0.0.1', '内网IP', '{\"message\":\"您好\"}', '{\"msg\":\"您好呀😊！请问有什么可以帮到您的吗？\",\"code\":200}', 0, NULL, '2026-03-06 19:23:01', 2103);
INSERT INTO `sys_oper_log` VALUES (249, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"塑料瓶\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"PET塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶瓶盖\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶盖\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"牛奶塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"硬质塑料瓶\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"塑料瓶子\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"}]}}', 0, NULL, '2026-03-06 19:23:04', 235);
INSERT INTO `sys_oper_log` VALUES (250, '垃圾分类查询-名称', 0, 'com.yaoliyun.system.controller.GarbageRecognitionController.searchByName()', 'GET', 1, 'admin', '研发部门', '/system/recognition/searchByName', '127.0.0.1', '内网IP', '{\"mode\":\"0\",\"num\":\"10\",\"page\":\"1\",\"word\":\"灯泡\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"list\":[{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"灯泡\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"电灯泡\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"白炽灯泡\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"},{\"aipre\":0,\"contain\":\"常见包括各类废金属、玻璃瓶、易拉罐、饮料瓶、塑料玩具、书本、报纸、广告单、纸板箱、衣服、床上用品、电子产品等\",\"explain\":\"可回收垃圾是指适宜回收、可循环利用的生活废弃物。\",\"name\":\"小灯泡\",\"tip\":\"轻投轻放；清洁干燥，避免污染，费纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的、应包裹后投放\",\"type\":0,\"typeName\":\"可回收垃圾\"}]}}', 0, NULL, '2026-03-06 19:23:48', 171);

-- ----------------------------
-- Table structure for sys_page_template
-- ----------------------------
DROP TABLE IF EXISTS `sys_page_template`;
CREATE TABLE `sys_page_template`  (
  `template_id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板名称',
  `template_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板类型（index首页 list列表 detail详情 form表单 login登录 user用户中心）',
  `template_description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模板描述',
  `preview_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '预览图片路径',
  `template_code` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板代码（源代码）',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'common' COMMENT '分类（ecommerce电商 social社交 tool工具 common通用）',
  `tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签（逗号分隔）',
  `download_count` int NULL DEFAULT 0 COMMENT '下载使用次数',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序（数字越小越靠前）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`template_id`) USING BTREE,
  INDEX `idx_template_type`(`template_type` ASC) USING BTREE COMMENT '模板类型索引',
  INDEX `idx_category`(`category` ASC) USING BTREE COMMENT '分类索引',
  INDEX `idx_status`(`status` ASC) USING BTREE COMMENT '状态索引',
  INDEX `idx_sort_order`(`sort_order` ASC, `create_time` ASC) USING BTREE COMMENT '排序索引',
  INDEX `idx_download_count`(`download_count` DESC) USING BTREE COMMENT '下载次数索引'
) ENGINE = InnoDB AUTO_INCREMENT = 88 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '页面模板管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_page_template
-- ----------------------------

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2025-08-07 11:38:58', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2025-08-07 11:38:58', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-08-07 11:38:58', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-08-07 11:38:58', 'admin', '2025-12-16 14:10:18', '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (2, 2050);
INSERT INTO `sys_role_menu` VALUES (2, 2051);
INSERT INTO `sys_role_menu` VALUES (2, 2052);
INSERT INTO `sys_role_menu` VALUES (2, 2053);
INSERT INTO `sys_role_menu` VALUES (2, 2060);
INSERT INTO `sys_role_menu` VALUES (2, 2061);
INSERT INTO `sys_role_menu` VALUES (2, 2062);
INSERT INTO `sys_role_menu` VALUES (2, 2063);
INSERT INTO `sys_role_menu` VALUES (2, 2064);
INSERT INTO `sys_role_menu` VALUES (2, 2065);
INSERT INTO `sys_role_menu` VALUES (2, 2066);
INSERT INTO `sys_role_menu` VALUES (2, 2067);
INSERT INTO `sys_role_menu` VALUES (2, 2068);
INSERT INTO `sys_role_menu` VALUES (2, 2069);
INSERT INTO `sys_role_menu` VALUES (2, 2179);
INSERT INTO `sys_role_menu` VALUES (2, 2180);
INSERT INTO `sys_role_menu` VALUES (2, 2181);
INSERT INTO `sys_role_menu` VALUES (2, 2186);
INSERT INTO `sys_role_menu` VALUES (2, 2187);
INSERT INTO `sys_role_menu` VALUES (2, 2188);
INSERT INTO `sys_role_menu` VALUES (2, 2189);
INSERT INTO `sys_role_menu` VALUES (2, 2190);
INSERT INTO `sys_role_menu` VALUES (2, 2191);
INSERT INTO `sys_role_menu` VALUES (2, 2192);
INSERT INTO `sys_role_menu` VALUES (2, 2193);
INSERT INTO `sys_role_menu` VALUES (2, 2194);
INSERT INTO `sys_role_menu` VALUES (2, 2195);
INSERT INTO `sys_role_menu` VALUES (2, 2196);
INSERT INTO `sys_role_menu` VALUES (2, 2197);
INSERT INTO `sys_role_menu` VALUES (2, 2198);
INSERT INTO `sys_role_menu` VALUES (2, 2199);
INSERT INTO `sys_role_menu` VALUES (2, 2200);
INSERT INTO `sys_role_menu` VALUES (2, 2201);
INSERT INTO `sys_role_menu` VALUES (2, 2202);
INSERT INTO `sys_role_menu` VALUES (2, 2203);
INSERT INTO `sys_role_menu` VALUES (2, 2204);
INSERT INTO `sys_role_menu` VALUES (2, 2205);
INSERT INTO `sys_role_menu` VALUES (2, 2206);
INSERT INTO `sys_role_menu` VALUES (2, 2207);
INSERT INTO `sys_role_menu` VALUES (2, 2208);
INSERT INTO `sys_role_menu` VALUES (2, 2209);

-- ----------------------------
-- Table structure for sys_uniapp_page
-- ----------------------------
DROP TABLE IF EXISTS `sys_uniapp_page`;
CREATE TABLE `sys_uniapp_page`  (
  `page_id` bigint NOT NULL AUTO_INCREMENT COMMENT '页面ID',
  `page_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '页面路径',
  `page_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '页面标题',
  `navigation_style` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'default' COMMENT '导航栏样式(default/custom)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '页面状态(0正常 1停用)',
  `is_tabbar` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否为TabBar页面(0否 1是)',
  `tabbar_text` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'TabBar文本',
  `tabbar_order` int NULL DEFAULT 0 COMMENT 'TabBar排序（数字越小越靠前）',
  `tabbar_selected_icon` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'TabBar选中状态图标路径',
  `tabbar_icon_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'TabBar未选中状态图标路径',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '页面描述',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`page_id`) USING BTREE,
  UNIQUE INDEX `uk_page_path`(`page_path` ASC) USING BTREE COMMENT '页面路径唯一索引',
  INDEX `idx_status`(`status` ASC) USING BTREE COMMENT '状态索引',
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE COMMENT '创建时间索引',
  INDEX `idx_tabbar_order`(`is_tabbar` ASC, `tabbar_order` ASC) USING BTREE COMMENT 'TabBar排序索引'
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'UniApp页面管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_uniapp_page
-- ----------------------------
INSERT INTO `sys_uniapp_page` VALUES (1, 'pages/index/index', '首页', 'default', '0', '1', '首页', 1, '', '', '系统首页，展示项目架构和核心功能', 'admin', '2025-08-24 17:16:44', 'admin', '2025-08-27 22:25:26');
INSERT INTO `sys_uniapp_page` VALUES (2, 'pages/login/login', '微信登录', 'custom', '0', '0', NULL, 0, NULL, NULL, '微信登录页面', 'admin', '2025-08-24 17:16:44', 'admin', '2025-08-24 17:57:54');
INSERT INTO `sys_uniapp_page` VALUES (3, 'pages/user/index', '个人中心', 'default', '0', '1', '个人中心', 5, '', '', '用户个人中心页面', 'admin', '2025-08-24 17:16:44', 'admin', '2025-08-27 22:25:26');
INSERT INTO `sys_uniapp_page` VALUES (7, 'pages/ai/chat', 'AI智能助手', 'default', '0', '1', '智能助手', 2, NULL, NULL, 'AI聊天助手页面', 'admin', '2025-08-24 17:16:44', 'admin', '2025-08-27 22:25:26');
INSERT INTO `sys_uniapp_page` VALUES (8, 'pages/chat/test', '即时通讯测试', 'default', '0', '0', NULL, 0, NULL, NULL, 'WebSocket即时通讯测试页面', 'admin', '2025-08-24 17:16:44', '', NULL);
INSERT INTO `sys_uniapp_page` VALUES (9, 'pages/chat/list', '聊天列表', 'default', '0', '0', NULL, 0, NULL, NULL, '聊天会话列表页面', 'admin', '2025-08-24 17:16:44', '', NULL);
INSERT INTO `sys_uniapp_page` VALUES (10, 'pages/chat/detail', '聊天详情', 'default', '0', '0', NULL, 0, NULL, NULL, '聊天会话详情页面', 'admin', '2025-08-24 17:16:44', '', NULL);
INSERT INTO `sys_uniapp_page` VALUES (11, 'pages/product/list', '商品列表', 'custom', '0', '0', '分类', 4, NULL, NULL, '自动生成的页面', 'admin', '2025-08-24 17:51:15', 'admin', '2025-08-27 22:20:02');
INSERT INTO `sys_uniapp_page` VALUES (12, 'pages/product/detail', '商品详情', 'default', '0', '0', NULL, 0, NULL, NULL, '自动生成的页面', 'admin', '2025-08-24 17:52:21', '', '2025-08-24 18:05:08');
INSERT INTO `sys_uniapp_page` VALUES (13, 'pages/news/list', '新闻列表', 'default', '0', '1', '新闻动态', 3, NULL, NULL, '自动生成的页面', 'admin', '2025-08-24 18:08:36', 'admin', '2025-08-31 11:14:15');
INSERT INTO `sys_uniapp_page` VALUES (14, 'pages/news/detail', '新闻详情', 'default', '0', '0', NULL, 0, NULL, NULL, '自动生成的页面', 'admin', '2025-08-24 18:08:57', '', NULL);
INSERT INTO `sys_uniapp_page` VALUES (15, 'pages/goods/list', '商品', 'default', '0', '1', '商品', 4, NULL, NULL, '自动生成的页面', 'admin', '2025-08-25 17:57:58', 'admin', '2025-09-12 14:26:05');
INSERT INTO `sys_uniapp_page` VALUES (17, 'pages/order/list', '订单页面', 'default', '0', '0', '订单页面', 4, NULL, NULL, '自动生成的页面', 'admin', '2025-08-27 22:19:49', 'admin', '2025-09-12 14:25:53');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `wechat_openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信openid',
  `wechat_unionid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信unionid',
  `wechat_session_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信会话密钥',
  `login_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'password' COMMENT '登录类型（password密码登录 wechat微信登录）',
  `total_points` int NULL DEFAULT 0 COMMENT '总积分',
  `user_level` int NULL DEFAULT 1 COMMENT '用户等级',
  `recognition_count` int NULL DEFAULT 0 COMMENT '识别次数',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `uk_wechat_openid`(`wechat_openid` ASC) USING BTREE COMMENT '微信openid唯一索引',
  INDEX `idx_total_points`(`total_points` DESC) USING BTREE COMMENT '积分排行索引'
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '瑶力云', '00', 'ry@163.com', '15888888888', '1', 'http://localhost:8080/profile/upload/2025/11/01/X49iRse5M86pc6426a8df17963e29fb02e0b008751ac_20251101132957A007.jpg', '$2a$10$Zh1AnqllaTt1TyRarrune.ibYSTpniNMGNv16MxHjCAsaCSuukv/2', '0', '0', '127.0.0.1', '2026-03-06 19:19:40', '2025-11-01 13:42:06', NULL, NULL, NULL, 'password', 0, 1, 0, 'admin', '2025-08-07 11:38:58', '', '2026-03-06 19:19:39', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '瑶力云', '00', 'ry@qq.com', '15666666666', '1', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dbilOnZzX-SFW26EsAxOnwHaK6?w=198&h=293&c=7&r=0&o=7&pid=1.7&rm=3', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-08-07 11:38:58', '2025-08-07 11:38:58', NULL, NULL, NULL, 'password', 0, 1, 0, 'admin', '2025-08-07 11:38:58', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (100, 103, 'wx_omUiV6yw', '微信用户', '00', '', '', '2', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dbilOnZzX-SFW26EsAxOnwHaK6?w=198&h=293&c=7&r=0&o=7&pid=1.7&rm=3', '$2a$10$K2WU7DiC8ZRCH1zxuHyfeeTyI2g3WPF7ilQV6LoZ3ialLH7/a9g0O', '0', '0', '127.0.0.1', '2025-08-20 15:33:08', '2025-08-17 19:32:41', 'omUiV6ywZFgmdFWpQFWYfpF9AGlM', NULL, 'a8QkArmnaPkHCZJNlHVu6A==', 'wechat', 0, 1, 0, 'system', '2025-08-17 19:32:41', 'system', '2025-08-20 15:33:08', '微信登录用户，默认密码：123456');
INSERT INTO `sys_user` VALUES (101, 103, 'wx_oZCJs1wV', '微信用户', '00', '', '', '2', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dbilOnZzX-SFW26EsAxOnwHaK6?w=198&h=293&c=7&r=0&o=7&pid=1.7&rm=3', '$2a$10$lKCdKWMQ3Bu9ziLJ0aTZ5u.2o/1bn07UB5EA3syWomk8tflvyuMzi', '0', '0', '127.0.0.1', '2025-09-12 13:21:32', '2025-09-08 20:02:49', 'oZCJs1wVAKn2adO51QRWviMHlKpQ', NULL, 'OFXlQ5fDG0R6LNc1HpRMXg==', 'wechat', 0, 1, 0, 'system', '2025-09-08 20:02:49', 'admin', '2025-09-12 13:21:32', '微信登录用户，默认密码：123456');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (101, 2);

SET FOREIGN_KEY_CHECKS = 1;
