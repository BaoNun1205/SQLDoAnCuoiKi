--VIEW
--xem cac mat hang hien co
CREATE VIEW V_PRODUCTS 
AS
SELECT 
	p.p_id as "Mã mặt hàng",
	p.p_name as "Tên mặt hàng",
	p_price as "Giá",
	p_image,
	p.p_size as "Kích thước",
	p.p_quantity as "Số lượng"
FROM PRODUCT p
WHERE p.p_status = 1

--Xem Diem khach hang
CREATE VIEW V_CUSTOMER_POINT 
AS
SELECT c.c_phone AS "Số điện thoại",
       c.c_name AS "Tên khách hàng",
       c.c_point AS "Điểm tích lũy"
FROM CUSTOMER c;

GO
--Xem thong tin hoa don
CREATE VIEW V_INFO_BILL
AS
SELECT b.b_id as "Mã hóa đơn", 
	 b.b_date as "Ngày thanh toán",
	 b.b_totalpay as "Tổng thanh toán",
	 b.b_discount as "Giảm giá",
	 c.c_phone as "Số điện thoại",
	 c.c_name as "Tên khách hàng"
FROM CUSTOMER c INNER JOIN BILL b
ON c.c_phone = b.c_phone
WHERE b.b_status = 1

GO
--Xem chi tiet hoa don
CREATE VIEW V_INFO_DETAIL_BILL
AS
SELECT d.b_id as "Mã hóa đơn",
	 p.p_id as "Mã sản phẩm",
	 p.p_name as "Tên sản phẩm",
	 p.p_price as "Giá",
	 d.db_quantity as "Số lượng"
FROM (DETAIL_BILL d INNER JOIN PRODUCT p ON d.p_id = p.p_id) INNER JOIN BILL b ON b.b_id = d.b_id
WHERE b.b_status = 1

GO
--Xem tai khoan va thong tin cua nhan vie ndo
CREATE VIEW V_INFO_ACCOUNT
AS
SELECT a.a_username as "Tên đăng nhập",
	 a.a_password as "Mật khẩu",
	 a.a_status as "Trạng thái tài khoản",
	 a.e_id as "Mã nhân viên",
	 e.e_name as "Tên nhân viên",
	 e.e_phone as "Số điện thoại",
	 e.e_address as "Địa chỉ",
	 e.e_gender as "Giới tính",
	 e.e_status as "Tình trạng"
FROM EMPLOYEE e INNER JOIN ACCOUNT a
ON e.e_id = a.e_id;

GO

--Xem so luong mat hang ban duoc
CREATE VIEW V_SOLD_ITEMS_COUNT 
AS
SELECT p.p_id AS "Mã mặt hàng",
       p.p_name AS "Tên mặt hàng",
	 p.p_size as "Kích thước",
       SUM(db.db_quantity) AS "Số lượng đã bán"
FROM PRODUCT p INNER JOIN DETAIL_BILL db ON p.p_id = db.p_id
WHERE db.db_status = 1
GROUP BY p.p_id, p.p_name, p.p_size;

GO
--Xem chi tiet mat hang ban duoc trong ngay
CREATE VIEW V_SALESSUMMARY 
AS
SELECT
    p.p_id AS "Mã sản phẩm",
    p.p_name AS "Tên sản phẩm",
    p.p_price AS "Giá sản phẩm",
    d.db_quantity AS "Số lượng bán",
    b.b_date AS "Ngày bán"
FROM DETAIL_BILL d INNER JOIN BILL b ON d.b_id = b.b_id 
INNER JOIN PRODUCT p ON d.p_id = p.p_id
WHERE
    b.b_status = 1

GO
--Xem thong tin lo hang va nha cung cap
CREATE VIEW V_INFO_SHIPMENT
AS
SELECT s.s_id as "Mã nhà cung cấp",
	 s.s_name as "Tên nhà cung cấp",
	 s.s_phone as "Số điện thoại",
	 s.s_address as "Địa chỉ",
	 sh.sh_id as "Mã lô hàng",
	 sh.sh_imDate as "Ngày nhập"
FROM SHIPMENT sh INNER JOIN SUPPLIER s 
ON sh.s_id = s.s_id
WHERE sh.sh_status=1;


GO
--Xem chi tiet lo hang
CREATE VIEW V_INFO_DETAIL_SHIPMENT
AS
SELECT sh.sh_id as "Mã lô hàng",
	 p.p_id as "Mã mặt hàng",
	 p.p_name as "Tên mặt hàng",
	 p.p_size as "Kích thước",
	 ds.p_imPrice as "Giá nhập",
	 ds.p_quantity as "Số lượng"
FROM SHIPMENT sh INNER JOIN DETAIL_SHIPMENT ds ON sh.sh_id = ds.sh_id
INNER JOIN PRODUCT p
ON ds.p_id = p.p_id
WHERE sh.sh_status=1;

GO