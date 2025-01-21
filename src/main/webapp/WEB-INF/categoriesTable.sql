CREATE DATABASE IF NOT EXISTS Project_Document_JSP;

USE Project_Document_JSP;

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT DEFAULT NULL,     
    name VARCHAR(255) NOT NULL,           
    type ENUM('main_title', 'document_categories', 'document_items') NOT NULL, 
    document_contents TEXT DEFAULT NULL,     
    document_images VARCHAR(255) DEFAULT NULL, 
    document_secprogram_info VARCHAR(255) DEFAULT NULL,
    document_cost_online INT DEFAULT NULL,
    document_cost_offline INT DEFAULT NULL,
    document_agencies VARCHAR(255) DEFAULT NULL,
    document_agency_images VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE CASCADE
);

INSERT INTO categories (id, parent_id, name, type)
SELECT 1, NULL, '법률, 행정', 'main_title' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 1 AND name = '법률, 행정' AND type = 'main_title')
UNION ALL
SELECT 2, NULL, '금융, 세무', 'main_title' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 2 AND name = '금융, 세무' AND type = 'main_title')
UNION ALL
SELECT 3, NULL, '자동차', 'main_title' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 3 AND name = '자동차' AND type = 'main_title')
UNION ALL
SELECT 4, NULL, '부동산', 'main_title' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 4 AND name = '부동산' AND type = 'main_title')
UNION ALL
SELECT 5, NULL, '사업, 근로', 'main_title' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 5 AND name = '사업, 근로' AND type = 'main_title');

INSERT INTO categories (id, parent_id, name, type)
SELECT 6, 1, '개인 신분', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 6 AND parent_id = 1 AND name = '개인 신분' AND type = 'document_categories')
UNION ALL
SELECT 7, 1, '가족 관계', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 7 AND parent_id = 1 AND name = '가족 관계' AND type = 'document_categories')
UNION ALL
SELECT 8, 1, '거주', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 8 AND parent_id = 1 AND name = '거주' AND type = 'document_categories')
UNION ALL
SELECT 9, 2, '납세 및 세금', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 9 AND parent_id = 2 AND name = '납세 및 세금' AND type = 'document_categories')
UNION ALL
SELECT 10, 3, '등록 및 보험', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 10 AND parent_id = 3 AND name = '등록 및 보험' AND type = 'document_categories')
UNION ALL
SELECT 11, 3, '세금 및 소유', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 11 AND parent_id = 3 AND name = '세금 및 소유' AND type = 'document_categories')
UNION ALL
SELECT 12, 4, '등기', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 12 AND parent_id = 4 AND name = '등기' AND type = 'document_categories')
UNION ALL
SELECT 13, 4, '매매 및 계약', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 13 AND parent_id = 4 AND name = '매매 및 계약' AND type = 'document_categories')
UNION ALL
SELECT 14, 5, '사업', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 14 AND parent_id = 5 AND name = '사업' AND type = 'document_categories')
UNION ALL
SELECT 15, 5, '건강보험', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 15 AND parent_id = 5 AND name = '건강보험' AND type = 'document_categories')
UNION ALL
SELECT 16, 5, '소득 사실 증명', 'document_categories' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 16 AND parent_id = 5 AND name = '소득 사실 증명' AND type = 'document_categories');

INSERT INTO categories (id, parent_id, name, type, document_contents, document_images, document_secprogram_info, document_cost_online, document_cost_offline, document_agencies, document_agency_images)
SELECT 17, 6, '인감증명서', 'document_items', '', 'image/pid6-1.png', NULL, NULL, '600', '정부24', 'icons/gov24.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 17 AND parent_id = 6 AND name = '인감증명서' AND type = 'document_items')
UNION ALL
SELECT 18, 6, '주민등록등본', 'document_items', '', 'image/pid6-2.png', NULL, NULL, '400', '정부24', 'icons/gov24.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 18 AND parent_id = 6 AND name = '주민등록등본' AND type = 'document_items')
UNION ALL
SELECT 19, 6, '신분증사본', 'document_items', '', 'image/pid6-3.png', NULL, NULL, '100', '정부24', 'icons/gov24.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 19 AND parent_id = 6 AND name = '신분증사본' AND type = 'document_items')
UNION ALL
SELECT 20, 7, '혼인관계증명서', 'document_items', '', 'image/pid7-1.png', NULL, NULL, '1000', '대한민국 법원', 'icons/scourt.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 20 AND parent_id = 7 AND name = '혼인관계증명서' AND type = 'document_items')
UNION ALL
SELECT 21, 7, '가족관계증명서', 'document_items', '', 'image/pid7-2.png', NULL, NULL, '1000', '정부24', 'icons/gov24.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 21 AND parent_id = 7 AND name = '가족관계증명서' AND type = 'document_items')
UNION ALL
SELECT 22, 8, '거소사실증명서', 'document_items', '', 'image/pid8-1.png', NULL, NULL, '2000', '정부24', 'icons/gov24.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 22 AND parent_id = 8 AND name = '거소사실증명서' AND type = 'document_items')
UNION ALL
SELECT 23, 9, '납세증명서', 'document_items', '', 'image/pid9-1.png', NULL, NULL, '800', '홈택스', 'icons/hometax.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 23 AND parent_id = 9 AND name = '납세증명서' AND type = 'document_items')
UNION ALL
SELECT 24, 10, '자동차등록증', 'document_items', '', 'image/pid10-1.png', NULL, '600', '700', '자동차 민원', 'icons/ecar.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 24 AND parent_id = 10 AND name = '자동차등록증' AND type = 'document_items')
UNION ALL
SELECT 25, 10, '자동차보험가입증명서', 'document_items', '', 'image/pid10-2.png', NULL, NULL, NULL, '가입한 보험사', NULL 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 25 AND parent_id = 10 AND name = '자동차보험가입증명서' AND type = 'document_items')
UNION ALL
SELECT 26, 11, '자동차세완납증명서', 'document_items', '', 'image/pid11-1.png', NULL, NULL, '800', '정부24', 'icons/gov24.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 26 AND parent_id = 11 AND name = '자동차세완납증명서' AND type = 'document_items')
UNION ALL
SELECT 27, 11, '자동차양도증명서', 'document_items', '', 'image/pid11-2.png', NULL, NULL, '800', '홈택스', 'icons/hometax.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 27 AND parent_id = 11 AND name = '자동차양도증명서' AND type = 'document_items')
UNION ALL
SELECT 28, 12, '부동산등기부등본', 'document_items', '', 'image/pid12-1.png', NULL, '700', '1000', '대법원 인터넷등기소', 'icons/iros.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 28 AND parent_id = 12 AND name = '부동산등기부등본' AND type = 'document_items')
UNION ALL
SELECT 29, 12, '부동산등기권리증', 'document_items', '', 'image/pid12-2.png', NULL, NULL, NULL, '법무사 사무실 방문 필요', NULL 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 29 AND parent_id = 12 AND name = '부동산등기권리증' AND type = 'document_items')
UNION ALL
SELECT 30, 13, '부동산매매계약서', 'document_items', '', 'image/pid13-1.png', NULL, NULL, NULL, '부동산 중개업소 방문 필요', NULL 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 30 AND parent_id = 13 AND name = '부동산매매계약서' AND type = 'document_items')
UNION ALL
SELECT 31, 13, '부동산거래신고필증', 'document_items', '', 'image/pid13-2.png', NULL, NULL, NULL, '국토교통비', 'icons/molit.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 31 AND parent_id = 13 AND name = '부동산거래신고필증' AND type = 'document_items')
UNION ALL
SELECT 32, 13, '부동산자금조달계획서', 'document_items', '', 'image/pid13-3.png', NULL, NULL, NULL, '국가법령정보센터', 'icons/lawinfocenter.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 32 AND parent_id = 13 AND name = '부동산자금조달계획서' AND type = 'document_items')
UNION ALL
SELECT 33, 14, '사업자등록증', 'document_items', '', 'image/pid14-1.png', NULL, 30000, NULL, '홈택스', 'icons/hometax.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 33 AND parent_id = 14 AND name = '사업자등록증' AND type = 'document_items')
UNION ALL
SELECT 34, 15, '건강보험자격득실확인서', 'document_items', '', 'image/pid15-1.png', NULL, NULL, NULL, '국민건강보험공단', 'icons/nhis.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 34 AND parent_id = 15 AND name = '건강보험자격득실확인서' AND type = 'document_items')
UNION ALL
SELECT 35, 16, '소득금액증명서', 'document_items', '', 'image/pid16-1.png', NULL, NULL, NULL, '홈택스', 'icons/hometax.png' 
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE id = 35 AND parent_id = 16 AND name = '소득금액증명서' AND type = 'document_items');