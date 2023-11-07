--funcition-----------------------
--funcition lay account len tu database
GO
CREATE FUNCTION uf_PermissionRole(@username char(50), @password char(25))
RETURNS TABLE
AS
RETURN Select a_username, a_password, e_name, ac.e_id from ACCOUNT as ac inner join Employee as em on ac.e_id = em.e_id Where a_username = @username and a_password = @password

--ACCOUNT
--funcition kiem tra xem account do co ton tai trong database 
GO
CREATE FUNCTION uf_CheckLogin (@username char(50), @password char(25))
RETURNS INT
AS
BEGIN
	DECLARE @result int
	SELECT @result=Count(*) FROM ACCOUNT Where a_username=@username AND a_password = @password
	RETURN @result		
END

--PRODUCT
--tìm kiếm mặt hàng theo mã mặt hàng
CREATE FUNCTION fn_FindProductByIDType (@idtype VARCHAR(10))
RETURNS TABLE
AS
RETURN
(
    SELECT p_id as "Mã mặt hàng", 
           p_name as "Tên mặt hàng",
           p_price as "Giá",
           p_image,
           p_size as "Kích thước",
           p_quantity as "Số lượng"
    FROM PRODUCT
    WHERE p_id LIKE '%' + @idtype + '%' AND p_status = 1
);
GO

--tìm kiếm mặt hàng theo tên mặt hàng
CREATE FUNCTION fn_FindProductByName (@name VARCHAR(225))
RETURNS TABLE
AS
RETURN
(
    SELECT p_id as "Mã mặt hàng", 
           p_name as "Tên mặt hàng",
           p_price as "Giá",
           p_image,
           p_size as "Kích thước",
           p_quantity as "Số lượng"
    FROM PRODUCT
    WHERE p_name LIKE '%' + @name + '%' AND p_status = 1
);
GO
	
--BILL
--tìm kiếm hóa đơn theo mã hóa đơn
GO
CREATE FUNCTION func_timBillTheoMaBill (@b_id varchar(10))
RETURNS TABLE
AS
RETURN 
(
SELECT b.b_id as"Mã hóa đơn", 
	b.b_date as "Ngày thanh toán", 
	b.b_totalpay as "Tổng thanh toán", 
	b.b_discount as "Giảm giá", 
	c.c_phone as "Số điện thoại", 
	c.c_name as "Tên khách hàng"  
	FROM CUSTOMER c INNER JOIN BILL b ON c.c_phone = b.c_phone
WHERE b.b_id LIKE '%' + @b_id + '%' AND b_status = 1 );


--tìm kiếm hóa đơn theo sđt khách hàng
CREATE FUNCTION func_timBillTheoSDT (@c_phone varchar(10))
RETURNS TABLE
AS
RETURN 
(
	SELECT b.b_id as "Mã hóa đơn", 
	b.b_date as "Ngày thanh toán", 
	b.b_totalpay as "Tổng thanh toán", 
	b.b_discount as "Giảm giá", 
	c.c_phone as "Số điện thoại", 
	c.c_name as "Tên khách hàng" 
	FROM CUSTOMER c INNER JOIN BILL b ON c.c_phone = b.c_phone
	WHERE c.c_phone LIKE '%' + @c_phone + '%' AND b_status = 1 );

--tìm kiếm hóa đơn theo mã sp
GO
CREATE FUNCTION func_timBillTheoMaMatHang(@p_id varchar(10))	
RETURNS TABLE
AS
RETURN ( SELECT b.b_id, b.b_date, b.b_totalpay, b.b_discount, c.c_phone, c.c_name  
	FROM (CUSTOMER c INNER JOIN BILL b ON c.c_phone = b.c_phone) INNER JOIN DETAIL_BILL db ON db.b_id = b.b_id
WHERE p_id LIKE '%' + @p_id + '%' AND b_status = 1 );

--tìm kiếm hóa đơn theo ngày
CREATE FUNCTION func_timBillTheoNgay
(
    @ngayBatDau DATE,
    @ngayKetThuc DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT b.b_id, b.b_date, b.b_totalpay, b.b_discount, c.c_phone, c.c_name
    FROM CUSTOMER c
    INNER JOIN BILL b ON c.c_phone = b.c_phone
    WHERE b.b_status = 1 AND b.b_date BETWEEN @ngayBatDau AND @ngayKetThuc
);

--Customer
--Tim kiem khach hang theo sdt
CREATE FUNCTION [dbo].[SearchCustomerByPhone](@phone varchar(10))
RETURNS TABLE
AS
RETURN
(
    SELECT c_phone, c_name, c_point, c_status
    FROM CUSTOMER
    WHERE c_phone = @phone
);
