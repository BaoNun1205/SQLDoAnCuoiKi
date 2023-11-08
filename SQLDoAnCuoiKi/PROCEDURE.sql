--PROCEDURE

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
		Begin Tran insert_Proc
		INSERT INTO dbo.Product VALUES(@pid, @name, @price, @image, @size, @quantity, default)
		Commit Tran insert_Proc
	END TRY
	BEGIN CATCH
		Rollback Tran insert_Proc
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
		Begin Tran update_Proc
		UPDATE Product 
		SET p_name = @name, p_price = @price, p_image = @image, p_size = @size, p_quantity = @quantity
		WHERE p_id = @pid
		Commit Tran update_Proc
	End Try
	Begin Catch		
		Rollback Tran update_Proc
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
		Begin Tran delete_Proc
		Update Product Set p_status = 0 WHERE Product.p_id = @pid
		Commit Tran delete_Proc
	End Try
	Begin Catch
		Print N'Không thể xóa mặt hàng' 
		Rollback Tran delete_Proc
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
		BEGIN TRAN insert_Proc
		INSERT INTO dbo.SHIPMENT VALUES(@shid, @sid, @imDate, default)
		COMMIT TRAN insert_Proc
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN insert_Proc
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
		BEGIN TRAN insert_Proc

		-- Thêm dữ liệu vào bảng DETAIL_SHIPMENT
		INSERT INTO dbo.DETAIL_SHIPMENT VALUES(@shid, @pid, @imPrice, @quantity, default)

		COMMIT TRAN insert_Proc
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN insert_Proc
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
		Begin Tran delete_Proc
		Update SHIPMENT Set sh_status = 0 WHERE sh_id = @shid
		Commit Tran delete_Proc
	End Try
	Begin Catch
		Print N'Không thể xóa lô hàng' 
		Rollback Tran delete_Proc
	End Catch
END
GO

--tạo mã lô hàng tự động
CREATE PROCEDURE proc_CreateAutoShipmentID
    @prefix VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        SELECT CONCAT(@prefix, RIGHT(CONCAT('000',ISNULL(right(max(sh_id),4),0) + 1),4))
                                            FROM SHIPMENT where sh_id like @prefix + '%'
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
		Begin Tran insert_Proc
		INSERT INTO CUSTOMER(c_phone, c_name, c_point, c_status)
		VALUES (@SDT , @TenKH, @Diem, 1)
		Commit Tran insert_Proc
	End Try
	Begin Catch
		Rollback Tran insert_Proc
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
		Begin Tran update_Proc
		UPDATE CUSTOMER 
		SET c_name = @name, c_point = @point, c_status = @status
		WHERE c_phone = @phone
		Commit Tran update_Proc
	End Try
	Begin Catch
		Rollback Tran update_Proc
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
		Begin Tran delete_Proc
		Update CUSTOMER Set c_status = 0 WHERE CUSTOMER.c_phone = @phone
		Commit Tran delete_Proc
	End Try
	Begin Catch
		Print N'Không thể xóa khách hàng' 
		Rollback Tran delete_Proc
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
		Begin Tran insert_Proc
		INSERT INTO dbo.EMPLOYEE VALUES(@id, @name, @address, @phone, @gender, default)
		Commit Tran insert_Proc
	END TRY
	BEGIN CATCH
		Rollback Tran insert_Proc
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	END CATCH
END
GO
--Cap nhat nhan vien
CREATE PROC proc_UpdateEmployee
	@id VARCHAR(10),
	@name VARCHAR(255),	
	@address VARCHAR(255),
	@phone VARCHAR(10),
	@gender VARCHAR(10)
AS
BEGIN
	Begin Try
		Begin Tran update_Proc
		UPDATE EMPLOYEE 
		SET e_name = @name, e_address = @address, e_phone = @phone, e_gender = @gender
		WHERE e_id = @id
		Commit Tran update_Proc
	End Try
	Begin Catch
		Rollback Tran update_Proc
		DECLARE @err NVARCHAR(MAX)
		SELECT @err = ERROR_MESSAGE()
		RAISERROR(@err, 16, 1)
	End Catch
END
GO

--Xóa nhân viên
CREATE PROC proc_DeleteEmployee
	@id VARCHAR(10)
AS
BEGIN
	Begin Try
		Begin Tran delete_Proc
		Update EMPLOYEE Set e_status = 0 WHERE EMPLOYEE.e_id = @id
		Commit Tran delete_Proc
	End Try
	Begin Catch
		Print N'Không thể xóa nhân viên' 
		Rollback Tran delete_Proc
	End Catch
END
GO
--Tim nhan vien
--tìm mặt hàng bằng ID
CREATE PROCEDURE proc_FindEmployeeByID
    @id VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        SELECT p_id as "Mã mặt hàng", 
			   p_name as "Tên mặt hàng",
			   p_price as "Giá",
			   p_image,
			   p_size as "Kích thước",
			   p_quantity as "Số lượng"
        FROM EMPLOYEE
        WHERE p_id LIKE '%' + @idtype + '%' AND p_status = 1;
    END TRY
    BEGIN CATCH
        PRINT 'Có lỗi xảy ra. Hãy kiểm tra xem mặt hàng có tồn tại không.'
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
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
		Begin Tran insert_Proc
		INSERT INTO SUPPLIER VALUES(@s_id, @s_name, @s_phone, @s_address, default)
		Commit Tran insert_Proc
	END TRY
	BEGIN CATCH
		print N'Gặp lỗi trong quá trình thêm nhà cung cấp'
		Rollback Tran insert_Proc
	END CATCH
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
		Begin Tran insert_Proc
		INSERT INTO dbo.Bill VALUES(@b_id, @date, @totalpay, @discount, default, @c_phone, @e_id)
		Commit Tran insert_Proc
	END TRY
	BEGIN CATCH
		print N'Gặp lỗi trong quá trình thêm Bill'
		print error_message()
		Rollback Tran insert_Proc
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
		Begin Tran insert_Proc
		INSERT INTO dbo.DETAIL_BILL VALUES(@b_id, @p_id, @db_quantity,default)
		Commit Tran insert_Proc
	END TRY
	BEGIN CATCH
		print N'Gặp lỗi trong quá trình thêm chi tiết Bill'
		print error_message()
		Rollback Tran insert_Proc
	END CATCH
END
GO

--Xóa Bill
CREATE PROC proc_DeleteBill
    @bid VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION delete_Proc

        -- Xóa dữ liệu tương ứng trong chi tiết hóa đơn
        UPDATE DETAIL_BILL SET db_status = 0 WHERE b_id = @bid

        -- Xóa hóa đơn
        UPDATE BILL SET b_status = 0 WHERE b_id = @bid

        COMMIT TRANSACTION delete_Proc
    END TRY
    BEGIN CATCH
        PRINT N'Không thể xóa hóa đơn' 
        ROLLBACK TRANSACTION delete_Proc
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
