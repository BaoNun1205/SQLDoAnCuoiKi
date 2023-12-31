﻿--PROCEDURE

--Product
--Thêm mặt hàng
CREATE PROCEDURE proc_AddProduct
	@pid VARCHAR(10),
	@name VARCHAR(255),	
	@price DECIMAL(15, 0),
	@image image,
	@size VARCHAR(10),
	@quantity INT
AS
BEGIN
	BEGIN TRY
		Begin Tran insert_Pro
		INSERT INTO dbo.Product VALUES(@pid, @name, @price, @image, @size, @quantity, default)
		Commit Tran insert_Pro
	END TRY
	BEGIN CATCH
		Rollback Tran insert_Pro
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--Cập nhật mặt hàng
CREATE PROC proc_UpdateProduct
	@pid VARCHAR(10),
	@name VARCHAR(255),	
	@price DECIMAL(15, 0),
	@image image,
	@size VARCHAR(10),
	@quantity INT
AS
BEGIN
	Begin Try
		Begin Tran update_Pro
		UPDATE Product 
		SET p_name = @name, p_price = @price, p_image = @image, p_size = @size, p_quantity = @quantity
		WHERE p_id = @pid
		Commit Tran update_Pro
	End Try
	Begin Catch		
		Rollback Tran update_Pro
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	End Catch
END
GO

--Xóa mặt hàng
CREATE PROC proc_DeleteProduct
	@pid VARCHAR(10)
AS
BEGIN
	Begin Try
		Begin Tran delete_Pro
		Update Product Set p_status = 0 WHERE Product.p_id = @pid
		Commit Tran delete_Pro
	End Try
	Begin Catch
		Print N'Không thể xóa mặt hàng' 
		Rollback Tran delete_Pro
	End Catch
END
GO

--tạo mã mặt hàng tự động
CREATE PROCEDURE proc_CreateAutoProductID
    @idtype VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        SELECT CONCAT(@idtype, RIGHT(CONCAT('000',ISNULL(right(max(p_id),4),0) + 1),4))
                                            FROM PRODUCT where p_id like @idtype + '%'
    END TRY
    BEGIN CATCH
        PRINT 'Có lỗi xảy ra'
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

--SHIPMENT
--Thêm lô hàng mới
CREATE PROCEDURE proc_AddShipment
	@shid VARCHAR(10),
	@sid VARCHAR(10),
	@imDate DATE
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN insert_Ship
		INSERT INTO dbo.SHIPMENT VALUES(@shid, @sid, @imDate, default)
		COMMIT TRAN insert_Ship
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN insert_Ship
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO


--Thêm thông tin mặt hàng trong lô hàng mới
CREATE PROCEDURE proc_AddDetailShipment
	@shid VARCHAR(10),
	@pid VARCHAR(10),
	@imPrice DECIMAL(15, 0),
	@quantity INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN insert_DetailShip

		-- Thêm dữ liệu vào bảng DETAIL_SHIPMENT
		INSERT INTO dbo.DETAIL_SHIPMENT VALUES(@shid, @pid, @imPrice, @quantity, default)

		COMMIT TRAN insert_DetailShip
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN insert_DetailShip
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END

--Xóa lô hàng
CREATE PROC proc_DeleteShipment
	@shid VARCHAR(10)
AS
BEGIN
	Begin Try
		Begin Tran delete_Ship

		--Xóa dữ liệu tương ứng trong chi tiết lô hàng
		Update DETAIL_SHIPMENT Set ds_status = 0 WHERE sh_id = @shid

		--Xóa lô hàng
		Update SHIPMENT Set sh_status = 0 WHERE sh_id = @shid
		Commit Tran delete_Ship
	End Try
	Begin Catch
		Print N'Không thể xóa lô hàng' 
		Rollback Tran delete_Ship
	End Catch
END

--tạo mã lô hàng tự động
CREATE PROCEDURE proc_CreateAutoShipmentID
AS
BEGIN
    BEGIN TRY
        SELECT CONCAT('SH', RIGHT(CONCAT('000',ISNULL(right(max(sh_id),4),0) + 1),4))
                                            FROM SHIPMENT where sh_id like 'SH' + '%'
    END TRY
    BEGIN CATCH
        PRINT 'Có lỗi xảy ra'
        PRINT ERROR_MESSAGE();
    END CATCH;
END;

--Customer
--Them khach hang
CREATE PROCEDURE [dbo].[proc_AddCustomer]
	@SDT varchar(10),
	@TenKH nvarchar(50),
	@Diem DECIMAL(15, 0)
AS
BEGIN
	Begin Try
		Begin Tran insert_Cus
		INSERT INTO CUSTOMER(c_phone, c_name, c_point, c_status)
		VALUES (@SDT , @TenKH, @Diem, 1)
		Commit Tran insert_Cus
	End Try
	Begin Catch
		Rollback Tran insert_Cus
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	End Catch
END
--Cập nhật khách hàng
CREATE PROC proc_UpdateCustomer
	@phone VARCHAR(10),
	@name VARCHAR(255),	
	@point DECIMAL(15, 0),
	@status bit
AS
BEGIN
	Begin Try
		Begin Tran update_Cus
		UPDATE CUSTOMER 
		SET c_name = @name, c_point = @point, c_status = @status
		WHERE c_phone = @phone
		Commit Tran update_Cus
	End Try
	Begin Catch
		Rollback Tran update_Cus
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	End Catch
END
GO

--Xóa khách hàng
CREATE PROC proc_DeleteCustomer
	@phone VARCHAR(10)
AS
BEGIN
	Begin Try
		Begin Tran delete_Cus
		Update CUSTOMER Set c_status = 0 WHERE CUSTOMER.c_phone = @phone
		Commit Tran delete_Cus
	End Try
	Begin Catch
		Print N'Không thể xóa khách hàng' 
		Rollback Tran delete_Cus
	End Catch
END
GO
--Employee
--Thêm nhan vien
CREATE PROCEDURE proc_AddEmployee
	@id VARCHAR(10),
	@name VARCHAR(255),
	@address VARCHAR(255),
	@phone VARCHAR(10),
	@gender VARCHAR(10)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN insert_Emp

		-- Insert into EMPLOYEE table
		INSERT INTO dbo.EMPLOYEE VALUES(@id, @name, @address, @phone, @gender, default)
		COMMIT TRAN insert_Emp
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN insert_Emp
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO
--Cap nhat nhan vien
CREATE PROCEDURE proc_UpdateEmployee
	@id VARCHAR(10),
	@name VARCHAR(255),	
	@address VARCHAR(255),
	@phone VARCHAR(10),
	@gender VARCHAR(10)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN update_Emp

		-- Update EMPLOYEE table
		UPDATE EMPLOYEE 
		SET e_name = @name, e_address = @address, e_phone = @phone, e_gender = @gender
		WHERE e_id = @id
		COMMIT TRAN update_Emp
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN update_Emp
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--Xóa nhân viên
CREATE PROCEDURE proc_DeleteEmployee
	@id VARCHAR(10)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN delete_Emp
		UPDATE EMPLOYEE 
		SET e_status = 0
		WHERE e_id = @id
		COMMIT TRAN delete_Emp
	END TRY
	BEGIN CATCH
		PRINT N'Không thể xóa nhân viên' 
		ROLLBACK TRAN delete_Emp
	END CATCH
END
GO

--SUPPERLIER
--Thêm nhà cung cấp
CREATE PROCEDURE proc_AddSupplier
	@s_id varchar(10),
	@s_name varchar(255),
	@s_phone varchar(10),
	@s_address varchar(255)
AS
BEGIN
	BEGIN TRY
		Begin Tran insert_Sup
		INSERT INTO SUPPLIER VALUES(@s_id, @s_name, @s_phone, @s_address, default)
		Commit Tran insert_Sup
	END TRY
	BEGIN CATCH
		Rollback Tran insert_Sup
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--xóa supplier 
CREATE PROC proc_DeleteSupplier
	@s_id VARCHAR(10)
AS
BEGIN
	Begin Try
		Begin Tran delete_Supplier
		Update SUPPLIER Set s_status = 0 WHERE SUPPLIER.s_id = @s_id
		Commit Tran delete_Supplier
	End Try
	Begin Catch
		Print N'Không thể xóa nhà cung cấp' 
		Rollback Tran delete_Supplier
	End Catch
END
GO
	
--cập nhật supplier
CREATE PROC proc_updateSupplier
	@s_id varchar(10),
	@s_name varchar(255),
	@s_phone varchar(10),
	@s_address varchar(255)
AS
BEGIN
	Begin Try
		Begin Tran update_Pro
		UPDATE SUPPLIER 
		SET s_name = @s_name, s_phone = @s_phone, s_address = @s_address
		WHERE s_id= @s_id
		Commit Tran update_Pro
	End Try
	Begin Catch
		Rollback Tran update_Pro
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	End Catch
END
GO
	
--Tạo mã nhà cung cấp tự động
CREATE PROCEDURE proc_CreateAutoSupplierID
AS
BEGIN
    BEGIN TRY
        SELECT CONCAT('S', RIGHT(CONCAT('000',ISNULL(right(max(s_id),3),0) + 1),3))
                                            FROM SUPPLIER where s_id like 'S' + '%'
    END TRY
    BEGIN CATCH
        PRINT 'Có lỗi xảy ra'
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

--Tạo bill khi thanh toán
CREATE PROCEDURE proc_AddBill
	@b_id VARCHAR(10),
	@date DATE, 
	@totalpay DECIMAL(15, 0),
	@discount DECIMAL(15, 0),
	@c_phone VARCHAR(10),
	@e_id VARCHAR(10)
AS
BEGIN
	BEGIN TRY
		Begin Tran insert_Bill
		INSERT INTO dbo.Bill VALUES(@b_id, @date, @totalpay, @discount, default, @c_phone, @e_id)
		Commit Tran insert_Bill
	END TRY
	BEGIN CATCH
		print N'Gặp lỗi trong quá trình thêm Bill'
		Rollback Tran insert_Bill
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--Tạo DetailBill khi them Bill
CREATE PROCEDURE proc_AddDetailBill
	@b_id VARCHAR(10),
	@p_id VARCHAR(10),
	@db_quantity INT
AS
BEGIN
	BEGIN TRY
		Begin Tran insert_DetailBill
		INSERT INTO dbo.DETAIL_BILL VALUES(@b_id, @p_id, @db_quantity,default)
		Commit Tran insert_DetailBill
	END TRY
	BEGIN CATCH
		print N'Gặp lỗi trong quá trình thêm chi tiết Bill'
		Rollback Tran insert_Bill
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--Xóa Bill
CREATE PROC proc_DeleteBill
    @bid VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION delete_Bill

        -- Xóa dữ liệu tương ứng trong chi tiết hóa đơn
        UPDATE DETAIL_BILL SET db_status = 0 WHERE b_id = @bid

        -- Xóa hóa đơn
        UPDATE BILL SET b_status = 0 WHERE b_id = @bid

        COMMIT TRANSACTION delete_Bill
    END TRY
    BEGIN CATCH
        PRINT N'Không thể xóa hóa đơn' 
        ROLLBACK TRANSACTION delete_Bill
    END CATCH
END
GO

--Tạo Id tăng tự động cho bill
CREATE PROCEDURE proc_CreateAutoBillID
AS
BEGIN
    BEGIN TRY
        SELECT CONCAT('B', RIGHT(CONCAT('000',ISNULL(right(max(b_id),4),0) + 1),4))
                                            FROM BILL where b_id like 'B' + '%'
    END TRY
    BEGIN CATCH
        PRINT 'Có lỗi xảy ra'
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

--Tạo tài khoản
CREATE PROCEDURE pro_AddAccount
	@ausername NVARCHAR(50),
	@apassword VARCHAR(25),
	@eid VARCHAR(10),
	@arole BIT
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN insert_Acc

		-- Kiểm tra xem @ausername có bắt đầu bằng một ký tự chữ không
		IF ISNULL(PATINDEX('[A-Za-z]%', @ausername), 0) = 0
		BEGIN
			-- Nếu không, báo lỗi và hủy bỏ giao dịch
			ROLLBACK TRAN insert_Acc
			RAISERROR('Tên người dùng phải bắt đầu bằng một ký tự chữ.', 16, 1)
			RETURN
		END

		-- Nếu kiểm tra qua, thực hiện chèn dữ liệu
		INSERT INTO dbo.ACCOUNT VALUES(@ausername, @apassword, default, @eid, @arole)

		COMMIT TRAN insert_Acc
	END TRY
	BEGIN CATCH
		-- Xử lý lỗi
		ROLLBACK TRAN insert_Acc
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO

--Cập nhật tài khoản
CREATE PROC proc_updateAccount
	@a_username VARCHAR(50),
	@a_password VARCHAR(25)
AS
BEGIN
	Begin Try
		Begin Tran update_Acc
		UPDATE ACCOUNT
		SET a_password = @a_password
		WHERE a_username = @a_username
		Commit Tran update_Acc
	End Try
	Begin Catch
		Rollback Tran update_Acc
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	End Catch
END
