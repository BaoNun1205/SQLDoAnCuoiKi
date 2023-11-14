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

--Tim top 10 san pham ban duoc nhieu nhat
CREATE FUNCTION fn_FindProductSell(@date INT)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 10 p.p_id, 
              p.p_name,
              p.p_size,
              SUM(db.db_quantity) AS quantity
	FROM (PRODUCT p 
	INNER JOIN DETAIL_BILL db ON p.p_id = db.p_id) INNER JOIN BILL b ON b.b_id = db.b_id
	WHERE b.b_date >= DATEADD(DAY, -@date, GETDATE())  -- Chọn các hóa đơn trong vòng @days ngày gần đây
	GROUP BY p.p_id, p.p_name, p.p_size
	ORDER BY quantity DESC
);

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
WHERE b.b_id LIKE '%' + @b_id + '%' AND b_status = 1 
);
GO

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
	WHERE c.c_phone LIKE '%' + @c_phone + '%' AND b_status = 1 
);
GO

--tìm kiếm hóa đơn theo mã sp
GO
CREATE FUNCTION func_timBillTheoMaMatHang(@p_id varchar(10))	
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
	FROM (CUSTOMER c INNER JOIN BILL b ON c.c_phone = b.c_phone) INNER JOIN DETAIL_BILL db ON db.b_id = b.b_id
	WHERE p_id LIKE '%' + @p_id + '%' AND b_status = 1 
);
GO

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
    SELECT b.b_id as "Mã hóa đơn", 
	b.b_date as "Ngày thanh toán", 
	b.b_totalpay as "Tổng thanh toán", 
	b.b_discount as "Giảm giá", 
	c.c_phone as "Số điện thoại", 
	c.c_name as "Tên khách hàng" 
	FROM CUSTOMER c INNER JOIN BILL b ON c.c_phone = b.c_phone
	WHERE b.b_status = 1 AND b_date BETWEEN @ngayBatDau AND @ngayKetThuc
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
--Tim kiem khach hang theo ten
CREATE FUNCTION [dbo].[SearchCustomerByName](@name nvarchar(50))
RETURNS TABLE
AS
RETURN
(
    SELECT c_phone, c_name, c_point, c_status
    FROM CUSTOMER
    WHERE c_name LIKE N'%' + @name + '%'
);

--Employee
--Tim kiem nhan vien theo id
CREATE FUNCTION [dbo].[SearchEmployeeByID](@id varchar(10))
RETURNS TABLE
AS
RETURN
(
    SELECT e.e_id, e.e_name, e.e_address, e.e_phone, e.e_gender, a.a_username, a.a_password
    FROM EMPLOYEE e INNER JOIN ACCOUNT a
	ON e.e_id = a.e_id
    WHERE e.e_id LIKE '%' + @id + '%' and e.e_status = 1
);
--Tim kiem nhan vien theo ten
CREATE FUNCTION [dbo].[SearchEmployeeByName](@name nvarchar(50))
RETURNS TABLE
AS
RETURN
(
    SELECT e.e_id, e.e_name, e.e_address, e.e_phone, e.e_gender, a.a_username, a.a_password
    FROM EMPLOYEE e INNER JOIN ACCOUNT a
	ON e.e_id = a.e_id
    WHERE e.e_name LIKE N'%' + @name + '%' and e.e_status = 1
);

--THỐNG KÊ
-- Tổng tiền nhập hàng
CREATE FUNCTION dbo.CalculateTotalImportAmountInLastNDays(
    @numberOfDays INT
)
RETURNS DECIMAL(15, 0)
AS
BEGIN
    DECLARE @totalAmount DECIMAL(15, 0);
    DECLARE @startDate DATE = DATEADD(DAY, -@numberOfDays, GETDATE());
    
    SELECT @totalAmount = SUM(DS.p_imPrice * DS.p_quantity)
    FROM SHIPMENT SH
    JOIN DETAIL_SHIPMENT DS ON SH.sh_id = DS.sh_id
    WHERE SH.sh_imDate >= @startDate;

    RETURN ISNULL(@totalAmount, 0);
END;

--Tổng tiền bán hàng
CREATE FUNCTION dbo.CalculateTotalSalesAmountInLastNDays(
    @numberOfDays INT
)
RETURNS DECIMAL(15, 0)
AS
BEGIN
    DECLARE @totalSalesAmount DECIMAL(15, 0);
    DECLARE @startDate DATE = DATEADD(DAY, -@numberOfDays, GETDATE());

    SELECT @totalSalesAmount = SUM(DB.db_quantity * P.p_price)
    FROM BILL B
    JOIN DETAIL_BILL DB ON B.b_id = DB.b_id
    JOIN PRODUCT P ON DB.p_id = P.p_id
    WHERE B.b_date >= @startDate;

    RETURN ISNULL(@totalSalesAmount, 0);
END;
--số khách hàng
CREATE FUNCTION func_Customers()
RETURNS INT
AS
BEGIN
	DECLARE @result int
	SELECT @result= Count(*) FROM CUSTOMER Where c_status=1
	RETURN @result
END
go
