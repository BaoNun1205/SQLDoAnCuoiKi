--Trigger
--Product
--Kiểm tra trước khi thêm hoặc sửa thông tin mặt hàng
CREATE TRIGGER trg_CheckProduct
ON PRODUCT
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra p_name
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(p_name) = '')
    BEGIN
        RAISERROR('Tên mặt hàng không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

	-- Kiểm tra trùng tên
	IF EXISTS (
		SELECT 1
		FROM PRODUCT p
		INNER JOIN inserted i ON TRIM(p.p_name) = TRIM(i.p_name)
		WHERE p.p_id <> i.p_id -- Loại trừ việc so sánh với chính bản ghi đang được cập nhật
	)
	BEGIN
		RAISERROR('Tên mặt hàng đã tồn tại trong bảng', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

    -- Kiểm tra p_size
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(p_size) = '')
    BEGIN
        RAISERROR('Kích thước mặt hàng không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;

--Kiểm tra thông tin lô hàng
CREATE TRIGGER trg_CheckShipment
ON SHIPMENT
AFTER INSERT
AS
BEGIN
	-- Kiểm tra ngày nhập lô hàng
	IF NOT EXISTS (SELECT * FROM inserted WHERE 
	(datediff(day,[sh_imDate],getdate())>=(0)))
	 BEGIN
		 RAISERROR ('Ngày nhập lô hàng không thể là trong tương lai', 16, 1)
		 ROLLBACK TRANSACTION
		 RETURN
	 END
END;

--Cập nhật số lượng mặt hàng sau khi thêm vào kho thành công
CREATE TRIGGER trig_UpdateWarehouse_AfterShip
ON Detail_Shipment
AFTER INSERT
AS BEGIN
      DECLARE @p_id VARCHAR(10)
      DECLARE @p_quantity INT
 
      SELECT @p_id = p_id, @p_quantity = p_quantity
      from inserted
 
      Update PRODUCT
      SET p_quantity = p_quantity + @p_quantity
      WHERE p_id = @p_id
END

--Customer
--Kiểm tra trước khi thêm và cập nhật khách hàng
CREATE TRIGGER trg_CheckCustomer
ON CUSTOMER
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra tên khách hàng
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(c_name) = '')
    BEGIN
        RAISERROR('Tên khách hàng không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;

--Employee
CREATE TRIGGER trg_CheckEmployee
ON EMPLOYEE
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra tên nhân viên
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(e_name) = '')
    BEGIN
        RAISERROR('Tên nhân viên không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
	-- Kiểm tra giới tính nhân viên
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(e_gender) = '')
    BEGIN
        RAISERROR('Giới tính nhân viên không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
	-- Kiểm tra số điện thoại nhân viên
	IF EXISTS (
		SELECT 1
		FROM EMPLOYEE e
		INNER JOIN inserted i ON TRIM(e.e_phone) = TRIM(i.e_phone)
		WHERE e.e_id <> i.e_id and e.e_status = 1 -- Loại trừ việc so sánh với chính bản ghi đang được cập nhật, xét tài khoản hoạt động
	)
	BEGIN
		RAISERROR('Số điện thoại đã được sử dụng', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

	-- Kiểm tra địa chỉ nhân viên
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(e_address) = '')
    BEGIN
        RAISERROR('Địa chỉ không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;
GO

--ACCOUNT
--Kiểm tra trước khi thêm và cập nhật account nhan vien
CREATE TRIGGER trg_CheckAccount
ON ACCOUNT
AFTER INSERT, UPDATE
AS
BEGIN
	-- Kiểm tra password
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(a_password) = '')
    BEGIN
        RAISERROR('Password không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;
GO
--SUPPILIER
CREATE TRIGGER trg_CheckSuppiler
ON SUPPLIER
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra s_name
    IF (EXISTS (SELECT * FROM INSERTED WHERE s_name = ''))
    BEGIN
        RAISERROR('Tên nhà cung cấp không được để trống.', 16, 1);
		ROLLBACK TRANSACTION
        RETURN
    END

    -- Kiểm tra s_address
    IF (EXISTS (SELECT * FROM INSERTED WHERE s_address = ''))
    BEGIN
        RAISERROR('Địa chỉ nhà cung cấp không được để trống.', 16, 1);
		ROLLBACK TRANSACTION
        RETURN
    END
END;
GO

--trigger tự trừ hàng trong kho khi mua
CREATE TRIGGER Sub_Product
ON DETAIL_BILL
AFTER INSERT
AS
BEGIN
	DECLARE @p_id VARCHAR(10)
	DECLARE @db_quantity INT

	Select @p_id = i.p_id, @db_quantity = i.db_quantity
	from inserted i

	UPDATE PRODUCT
	SET p_quantity = p_quantity - @db_quantity
	WHERE p_id = @p_id
END
GO

--Cập nhật điểm cho khách hàng
CREATE TRIGGER trg_UpdatePoint
ON BILL
AFTER INSERT 
AS 
BEGIN
	DECLARE @b_id VARCHAR(10)
	DECLARE @c_point DECIMAL(15, 0)
	DECLARE @c_phone VARCHAR(10)
	DECLARE @b_totalpay DECIMAL(15, 0)
	DECLARE @b_discount DECIMAL(15, 0)
	DECLARE @totalpay DECIMAL(15, 0)

	Select @b_id = i.b_id, @c_phone = i.c_phone, @b_totalpay = i.b_totalpay, @b_discount = i.b_discount
	from inserted i
	SELECT @c_point = c.c_point FROM CUSTOMER c WHERE c_phone = @c_phone

	UPDATE CUSTOMER
	SET c_point = CASE
		WHEN @b_totalpay - @b_discount - @c_point > 0
			THEN (@b_totalpay - @b_discount - @c_point) * 0.02
		ELSE @c_point - (@b_totalpay - @b_discount)  + ((@b_totalpay - @b_discount) * 0.02)
		END
	WHERE c_phone = @c_phone;
	UPDATE BILL
	SET b_totalpay = CASE
		WHEN @b_totalpay - @b_discount - @c_point > 0
			THEN @b_totalpay - @b_discount - @c_point
		ELSE 0
		END
	WHERE b_id = @b_id
END
GO

--Tạo tài khoảng login và user khi tạo tài khoản mới
CREATE TRIGGER addAccountRole ON ACCOUNT
AFTER INSERT
AS
BEGIN
	DECLARE @a_username VARCHAR(50), @a_password VARCHAR(25), @a_role INT

	SELECT @a_username = i.a_username, @a_password = i.a_password, @a_role = i.a_role
	FROM inserted i

	DECLARE @sqlString VARCHAR(2000)
	SET @sqlString = 'CREATE LOGIN [' + @a_username + '] WITH PASSWORD=''' + @a_password +
''', DEFAULT_DATABASE=[CuaHangDBMS], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF'
	EXEC (@sqlString)

	SET @sqlString = 'CREATE USER ' + @a_username + ' FOR LOGIN ' + @a_username
	EXEC (@sqlString)

	IF (@a_role = 1)
		SET @sqlString = 'ALTER SERVER ROLE sysadmin ADD MEMBER ' + @a_username
	ELSE
		SET @sqlString = 'ALTER ROLE Staff ADD MEMBER ' + @a_username

	EXEC (@sqlString)
END
GO

--Cập nhật mật khẩu thì tự động cập nhật user
CREATE TRIGGER updateAccountPassword ON ACCOUNT
AFTER UPDATE
AS
BEGIN
    DECLARE @a_username VARCHAR(50), @a_password VARCHAR(25)

    -- Lấy thông tin tài khoản sau khi cập nhật
    SELECT @a_username = i.a_username, @a_password = i.a_password
    FROM inserted i

    -- Kiểm tra xem mật khẩu đã thay đổi hay không
    IF UPDATE(a_password)
    BEGIN
        DECLARE @sqlString VARCHAR(2000)
        
        -- Cập nhật mật khẩu trong login
        SET @sqlString = 'ALTER LOGIN [' + @a_username + '] WITH PASSWORD = ''' + @a_password + ''''
        EXEC (@sqlString)
    END
END

