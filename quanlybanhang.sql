CREATE DATABASE QUANLYBANHANG;
USE QUANLYBANHANG;

-- TẠO BẢNG 
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID VARCHAR(4) NOT NULL,
    NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE NOT NULL,
    PHONE VARCHAR(25) UNIQUE NOT NULL,
    ADDRESS VARCHAR(255),
    PRIMARY KEY (CUSTOMER_ID)
);

CREATE TABLE ORDERS (
    ORDER_ID VARCHAR(4) NOT NULL,
    CUSTOMER_ID VARCHAR(4) NOT NULL,
    ORDER_DATE DATE NOT NULL,
    TOTAL_AMOUNT DOUBLE NOT NULL,
    PRIMARY KEY (ORDER_ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID)
);

CREATE TABLE PRODUCTS (
    PRODUCT_ID VARCHAR(4) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    DESCRIPTION TEXT,
    PRICE DOUBLE NOT NULL,
    STATUS BIT(1) DEFAULT 1 NOT NULL,
    PRIMARY KEY (PRODUCT_ID)
);

CREATE TABLE ORDERS_DETAILS (
    ORDER_ID VARCHAR(4) NOT NULL,
    PRODUCT_ID VARCHAR(4) NOT NULL,
    QUANTITY INT(11) NOT NULL,
    PRICE DOUBLE NOT NULL,
    PRIMARY KEY (ORDER_ID, PRODUCT_ID),
    FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID)
);

-- THÊM DỮ LIỆU VÀO BẢNG
-- CUSTOMERS
INSERT INTO CUSTOMERS (CUSTOMER_ID, NAME, EMAIL, PHONE, ADDRESS) 
VALUES 
('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365',  'Vinh, Nghệ An'),
('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

-- PRODUCTS
INSERT INTO PRODUCTS (PRODUCT_ID, NAME, DESCRIPTION, PRICE) 
VALUES 
('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999),
('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999),
('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999),
('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 4090000),
('P005', 'Airpods 2 2022', 'Spatial Audio', 18999999);

-- ORDER
INSERT INTO ORDERS (ORDER_ID, CUSTOMER_ID, ORDER_DATE, TOTAL_AMOUNT) 
VALUES 
('H001', 'C001', '2023-02-22', 52999997),
('H002', 'C001', '2023-03-11', 80999997),
('H003', 'C002', '2023-01-22', 54359998),
('H004', 'C003', '2023-03-14', 102999995),
('H005', 'C003', '2022-03-12', 80999997),
('H006', 'C004', '2023-02-01', 110449994),
('H007', 'C004', '2023-03-29', 79999996),
('H008', 'C005', '2023-02-14', 29999998),
('H009', 'C005', '2023-01-10', 28999999),
('H010', 'C005', '2023-04-01', 149999994);

-- ORDER DETAIL
INSERT INTO ORDERS_DETAILS (ORDER_ID, PRODUCT_ID, PRICE, QUANTITY) 
VALUES 
('H001', 'P002', 14999999, 1),
('H001', 'P004', 18999999, 2),
('H002', 'P001', 22999999, 1),
('H002', 'P003', 28999999, 2),
('H003', 'P004', 18999999, 2),
('H003', 'P005', 4090000, 4),
('H004', 'P002', 14999999, 3),
('H004', 'P003', 28999999, 2),
('H005', 'P001', 22999999, 1),
('H005', 'P003', 28999999, 2),
('H006', 'P005', 4090000, 5),
('H006', 'P002', 14999999, 6),
('H007', 'P004', 18999999, 3),
('H007', 'P001', 22999999, 1),
('H008', 'P002', 14999999, 2),
('H009', 'P003', 28999999, 1),
('H010', 'P003', 28999999, 2),
('H010', 'P001', 22999999, 4);

-- BÀI 3: TRUY VẤN DỮ LIỆU [30 ĐIỂM]:
-- 1. LẤY RA TẤT CẢ THÔNG TIN GỒM: TÊN, EMAIL, SỐ ĐIỆN THOẠI VÀ ĐỊA CHỈ TRONG BẢNG CUSTOMERS .
SELECT 
    NAME AS 'TÊN', EMAIL, PHONE AS 'SỐ ĐIỆN THOẠI'
FROM
    CUSTOMERS;

-- 2. THỐNG KÊ NHỮNG KHÁCH HÀNG MUA HÀNG TRONG THÁNG 3/2023 (THÔNG TIN BAO GỒM TÊN, SỐ ĐIỆN
-- THOẠI VÀ ĐỊA CHỈ KHÁCH HÀNG).
SELECT C.NAME AS 'TÊN',EMAIL,PHONE AS 'SỐ ĐIỆN THOẠI', ADDRESS AS 'ĐỊA CHỈ'
FROM CUSTOMERS C JOIN ORDERS O ON C.CUSTOMER_ID=O.CUSTOMER_ID
WHERE C.CUSTOMER_ID IN (SELECT CUSTOMER_ID FROM ORDERS WHERE MONTH(ORDER_DATE)=3 AND YEAR(ORDER_DATE)=2023) 
GROUP BY C.CUSTOMER_ID;
-- 3. THỐNG KÊ DOANH THUA THEO TỪNG THÁNG CỦA CỬA HÀNG TRONG NĂM 2023 (THÔNG TIN BAO GỒM
-- THÁNG VÀ TỔNG DOANH THU ). [4 ĐIỂM]
WITH AllMonths AS (
    SELECT 1 AS MonthNumber
    UNION SELECT 2
    UNION SELECT 3
    UNION SELECT 4
    UNION SELECT 5
    UNION SELECT 6
    UNION SELECT 7
    UNION SELECT 8
    UNION SELECT 9
    UNION SELECT 10
    UNION SELECT 11
    UNION SELECT 12
)

SELECT 
    m.MonthNumber AS 'THÁNG',
    COALESCE(SUM(o.TOTAL_AMOUNT), 0) AS 'DOANH THU THÁNG'
FROM
    AllMonths m
LEFT JOIN ORDERS o ON m.MonthNumber = MONTH(o.ORDER_DATE) AND YEAR(o.ORDER_DATE) = 2023
GROUP BY m.MonthNumber
ORDER BY m.MonthNumber;

-- 4. THỐNG KÊ NHỮNG NGƯỜI DÙNG KHÔNG MUA HÀNG TRONG THÁNG 2/2023 (THÔNG TIN GỒM TÊN KHÁCH
-- HÀNG, ĐỊA CHỈ , EMAIL VÀ SỐ ĐIÊN THOẠI). [4 ĐIỂM]
SELECT C.NAME AS 'TÊN', ADDRESS AS 'ĐỊA CHỈ',EMAIL,PHONE AS 'SỐ ĐIỆN THOẠI'
 FROM CUSTOMERS C JOIN ORDERS O ON C.CUSTOMER_ID=O.CUSTOMER_ID
 WHERE C.CUSTOMER_ID NOT IN (SELECT CUSTOMER_ID FROM ORDERS WHERE MONTH(ORDER_DATE)=2 AND YEAR(ORDER_DATE)=2023)
 GROUP BY C.CUSTOMER_ID;

-- 5. THỐNG KÊ SỐ LƯỢNG TỪNG SẢN PHẨM ĐƯỢC BÁN RA TRONG THÁNG 3/2023 (THÔNG TIN BAO GỒM MÃ
-- SẢN PHẨM, TÊN SẢN PHẨM VÀ SỐ LƯỢNG BÁN RA). [4 ĐIỂM]
SELECT P.PRODUCT_ID AS 'MÃ SẢN PHẨM', P.NAME AS 'TÊN SẢN PHẨM', COALESCE(SUM(OD.QUANTITY), 0) AS 'SỐ LƯỢNG BÁN RA' 
FROM PRODUCTS P
LEFT JOIN ORDERS_DETAILS OD ON P.PRODUCT_ID = OD.PRODUCT_ID
LEFT JOIN ORDERS O ON OD.ORDER_ID = O.ORDER_ID
WHERE  MONTH(O.ORDER_DATE) = 3 AND YEAR(O.ORDER_DATE) = 2023
GROUP BY P.PRODUCT_ID, P.NAME;
-- 6. THỐNG KÊ TỔNG CHI TIÊU CỦA TỪNG KHÁCH HÀNG TRONG NĂM 2023 SẮP XẾP GIẢM DẦN THEO MỨC CHI
-- TIÊU (THÔNG TIN BAO GỒM MÃ KHÁCH HÀNG, TÊN KHÁCH HÀNG VÀ MỨC CHI TIÊU). [5 ĐIỂM]
SELECT C.CUSTOMER_ID AS 'MÃ KHÁCH HÀNG', C.NAME AS 'TÊN KHÁCH HÀNG', SUM(TOTAL_AMOUNT) AS 'TỔNG CHI TRONG NĂM'
 FROM CUSTOMERS C JOIN ORDERS O ON C.CUSTOMER_ID=O.CUSTOMER_ID 
 WHERE YEAR(ORDER_DATE)=2023
 GROUP BY C.CUSTOMER_ID 
 ORDER BY SUM(TOTAL_AMOUNT) DESC;

-- 7. THỐNG KÊ NHỮNG ĐƠN HÀNG MÀ TỔNG SỐ LƯỢNG SẢN PHẨM MUA TỪ 5 TRỞ LÊN (THÔNG TIN BAO GỒM
-- TÊN NGƯỜI MUA, TỔNG TIỀN , NGÀY TẠO HOÁ ĐƠN, TỔNG SỐ LƯỢNG SẢN PHẨM) . [5 ĐIỂM]
SELECT C.NAME AS 'TÊN NGƯỜI MUA', SUM(TOTAL_AMOUNT) AS 'TỔNG TIỀN', ORDER_DATE AS 'NGÀY HÓA ĐƠN', SUM(QUANTITY) AS 'TỔNG SỐ LƯƠNG SẢN PHẨM'
 FROM CUSTOMERS C JOIN ORDERS O ON C.CUSTOMER_ID=O.CUSTOMER_ID JOIN ORDERS_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID 
 GROUP BY O.ORDER_ID 
 HAVING SUM(QUANTITY)>=5;

-- BÀI 4: TẠO VIEW, PROCEDURE [30 ĐIỂM]:
-- 1. TẠO VIEW LẤY CÁC THÔNG TIN HOÁ ĐƠN BAO GỒM : TÊN KHÁCH HÀNG, SỐ ĐIỆN THOẠI, ĐỊA CHỈ, TỔNG
-- TIỀN VÀ NGÀY TẠO HOÁ ĐƠN . [3 ĐIỂM]
CREATE VIEW VIEW_CUSTOMER_ON_ORDER AS
SELECT C.NAME AS 'TÊN KHÁCH HÀNG', PHONE AS 'SỐ ĐIỆN THOẠI', ADDRESS AS 'ĐỊA CHỈ', TOTAL_AMOUNT AS 'TỔNG TIỀN', ORDER_DATE AS 'NGÀY TẠO HÓA ĐƠN'
FROM CUSTOMERS C JOIN ORDERS O ON C.CUSTOMER_ID=O.CUSTOMER_ID;

SELECT * FROM VIEW_CUSTOMER_ON_ORDER;
-- 2. TẠO VIEW HIỂN THỊ THÔNG TIN KHÁCH HÀNG GỒM : TÊN KHÁCH HÀNG, ĐỊA CHỈ, SỐ ĐIỆN THOẠI VÀ TỔNG
-- SỐ ĐƠN ĐÃ ĐẶT. [3 ĐIỂM
CREATE VIEW VIEW_CUSTOMER_DETAILS AS
SELECT C.NAME AS 'TÊN KHÁCH HÀNG', ADDRESS AS 'ĐỊA CHỈ', PHONE AS 'SỐ ĐIỆN THOẠI', COUNT(ORDER_ID) AS 'SỐ ĐƠN HÀNG' 
FROM CUSTOMERS C JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
 GROUP BY C.CUSTOMER_ID;
SELECT * FROM VIEW_CUSTOMER_DETAILS;

-- 3. TẠO VIEW HIỂN THỊ THÔNG TIN SẢN PHẨM GỒM: TÊN SẢN PHẨM, MÔ TẢ, GIÁ VÀ TỔNG SỐ LƯỢNG ĐÃ
-- BÁN RA CỦA MỖI SẢN PHẨM.
CREATE VIEW VIEW_PRODUCT_DETAILS AS
SELECT 
    P.NAME AS 'TÊN SẢN PHẨM', 
    P.DESCRIPTION AS 'MÔ TẢ', 
    P.PRICE AS 'GIÁ', 
    COALESCE(SUM(OD.QUANTITY), 0) AS 'TỔNG SỐ LƯỢNG ĐÃ BÁN RA'
FROM 
    PRODUCTS P
LEFT JOIN 
    ORDERS_DETAILS OD ON P.PRODUCT_ID = OD.PRODUCT_ID
GROUP BY 
    P.PRODUCT_ID, P.NAME, P.DESCRIPTION, P.PRICE;

SELECT * FROM VIEW_PRODUCT_DETAILS;
-- 4. ĐÁNH INDEX CHO TRƯỜNG `PHONE` VÀ `EMAIL` CỦA BẢNG CUSTOMER. [3 ĐIỂM]
CREATE INDEX IDX_PHONE ON CUSTOMERS(PHONE);
CREATE INDEX IDX_EMAIL ON CUSTOMERS(EMAIL);
-- 5. TẠO PROCEDURE LẤY TẤT CẢ THÔNG TIN CỦA 1 KHÁCH HÀNG DỰA TRÊN MÃ SỐ KHÁCH HÀNG.[3 ĐIỂM
DELIMITER //
CREATE PROCEDURE GET_CUSTOMER_BY_ID (
IN P_CUSTOMER_ID VARCHAR(4)
) 
BEGIN
SELECT * FROM CUSTOMERS WHERE CUSTOMER_ID = P_CUSTOMER_ID;
END //
DELIMITER ;

CALL GET_CUSTOMER_BY_ID('C001');
-- 6. TẠO PROCEDURE LẤY THÔNG TIN CỦA TẤT CẢ SẢN PHẨM. [3 ĐIỂM]
DELIMITER //
CREATE PROCEDURE VIEW_ALL_PRODUCTS()
BEGIN
SELECT * FROM PRODUCTS;
END //
DELIMITER ;

CALL VIEW_ALL_PRODUCTS();

-- 7. TẠO PROCEDURE HIỂN THỊ DANH SÁCH HOÁ ĐƠN DỰA TRÊN MÃ NGƯỜI DÙNG. [3 ĐIỂM]
DELIMITER //
CREATE PROCEDURE VIEW_ORDER_LIST_BY_CUSTOMER(
IN P_CUSTOMER_ID VARCHAR(4))
BEGIN
SELECT * FROM ORDERS WHERE CUSTOMER_ID = P_CUSTOMER_ID;
END //
DELIMITER ;

CALL VIEW_ORDER_LIST_BY_CUSTOMER('C002');

-- 8. TẠO PROCEDURE TẠO MỚI MỘT ĐƠN HÀNG VỚI CÁC THAM SỐ LÀ MÃ KHÁCH HÀNG, TỔNG
-- TIỀN VÀ NGÀY TẠO HOÁ ĐƠN, VÀ HIỂN THỊ RA MÃ HOÁ ĐƠN VỪA TẠO. [3 ĐIỂM]
DELIMITER //

CREATE PROCEDURE INSERT_NEW_ORDER (
    IN P_CUSTOMER_ID VARCHAR(4),
    IN P_ORDER_DATE DATE,
    IN P_TOTAL_AMOUNT DOUBLE,
    OUT P_ORDER_ID VARCHAR(4)
)
BEGIN
  DECLARE NEW_ORDER_NUMBER INT;
    DECLARE NEW_ORDER_PREFIX VARCHAR(4);

    -- LẤY SỐ ĐƠN HÀNG TIẾP THEO
    SELECT IFNULL(MAX(CAST(SUBSTRING(ORDER_ID, 2) AS UNSIGNED)), 0) + 1 INTO NEW_ORDER_NUMBER FROM ORDERS;

    -- TẠO MÃ ĐƠN HÀNG
    SET NEW_ORDER_PREFIX = CONCAT('H', LPAD(NEW_ORDER_NUMBER, 3, '0'));
    SET P_ORDER_ID = NEW_ORDER_PREFIX;

    -- CHÈN MỚI ĐƠN HÀNG VÀO BẢNG ORDERS
    INSERT INTO ORDERS(ORDER_ID, CUSTOMER_ID, ORDER_DATE, TOTAL_AMOUNT)
    VALUES (P_ORDER_ID, P_CUSTOMER_ID, P_ORDER_DATE, P_TOTAL_AMOUNT);

    -- TRẢ VỀ MÃ ĐƠN HÀNG VỪA TẠO
    SELECT P_ORDER_ID AS 'Mã đơn hàng mới';

END //

DELIMITER ;


CALL INSERT_NEW_ORDER('C002','2024-03-14',2356662,@NEW_ORDER_ID);

-- 9. TẠO PROCEDURE THỐNG KÊ SỐ LƯỢNG BÁN RA CỦA MỖI SẢN PHẨM TRONG KHOẢNG
-- THỜI GIAN CỤ THỂ VỚI 2 THAM SỐ LÀ NGÀY BẮT ĐẦU VÀ NGÀY KẾT THÚC. [3 ĐIỂM]
DELIMITER //
CREATE PROCEDURE VIEW_PRODUCT_SALE_IN_PERIOD(
IN P_START_DATE DATE,
IN P_END_DATE DATE)
BEGIN
SELECT P.NAME AS 'TÊN SẢN PHẨM', DESCRIPTION AS 'MÔ TẢ', P.PRICE AS 'GIÁ', SUM(QUANTITY) AS 'SỐ LƯỢNG ĐÃ BÁN' FROM PRODUCTS P JOIN ORDERS_DETAILS OD ON P.PRODUCT_ID = OD.PRODUCT_ID JOIN ORDERS O ON OD.ORDER_ID=O.ORDER_ID WHERE ORDER_DATE BETWEEN P_START_DATE AND P_END_DATE GROUP BY P.PRODUCT_ID;
END //
DELIMITER ;

CALL VIEW_PRODUCT_SALE_IN_PERIOD('2022-11-01','2024-01-01');
-- 10. TẠO PROCEDURE THỐNG KÊ SỐ LƯỢNG CỦA MỖI SẢN PHẨM ĐƯỢC BÁN RA THEO THỨ TỰ
-- GIẢM DẦN CỦA THÁNG ĐÓ VỚI THAM SỐ VÀO LÀ THÁNG VÀ NĂM CẦN THỐNG KÊ. [3 ĐIỂM]
DELIMITER //
CREATE PROCEDURE LIST_PRODUCT_SOLD_IN_MONTH (
IN P_MONTH INT,
IN P_YEAR INT)
BEGIN
 SELECT P.NAME AS 'TÊN SẢN PHẨM', COALESCE(SUM(OD.QUANTITY), 0) AS 'SỐ LƯỢNG ĐÃ BÁN' 
    FROM PRODUCTS P 
    LEFT JOIN ORDERS_DETAILS OD ON P.PRODUCT_ID = OD.PRODUCT_ID 
    LEFT JOIN ORDERS O ON OD.ORDER_ID = O.ORDER_ID 
    WHERE MONTH(O.ORDER_DATE) = P_MONTH AND YEAR(O.ORDER_DATE) = P_YEAR 
    GROUP BY P.PRODUCT_ID
    ORDER BY COALESCE(SUM(OD.QUANTITY), 0) DESC;
END //
DELIMITER ;

CALL LIST_PRODUCT_SOLD_IN_MONTH(1,2023);

