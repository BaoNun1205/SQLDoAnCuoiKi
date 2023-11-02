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
		Begin Tran insert_Pro
		INSERT INTO dbo.Product VALUES(@pid, @name, @price, @image, @size, @quantity, default)
		Commit Tran insert_Pro
	END TRY
	BEGIN CATCH
		print N'Gặp lỗi trong quá trình thêm mặt hàng'
		Rollback Tran insert_Pro
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
		Print N'Không thể cập nhật mặt hàng'
		Rollback Tran update_Pro
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

--Tìm mặt hàng bằng tên
CREATE PROCEDURE proc_FindProduct
    @searchChar VARCHAR(225)
AS
BEGIN
    BEGIN TRY
        SELECT p_id as "Mã mặt hàng", 
			   p_name as "Tên mặt hàng",
			   p_price as "Giá",
			   p_image,
			   p_size as "Kích thước",
			   p_quantity as "Số lượng"
        FROM PRODUCT
        WHERE p_name LIKE '%' + @searchChar + '%' AND p_status = 1;
    END TRY
    BEGIN CATCH
        PRINT 'Có lỗi xảy ra. Hãy kiểm tra xem đối tượng có tồn tại không.'
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO

--tìm mặt hàng bằng ID
CREATE PROCEDURE proc_FindProductByIDType
    @idtype VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        SELECT p_id as "Mã mặt hàng", 
			   p_name as "Tên mặt hàng",
			   p_price as "Giá",
			   p_image,
			   p_size as "Kích thước",
			   p_quantity as "Số lượng"
        FROM PRODUCT
        WHERE p_id LIKE '%' + @idtype + '%' AND p_status = 1;
    END TRY
    BEGIN CATCH
        PRINT 'Có lỗi xảy ra. Hãy kiểm tra xem mặt hàng có tồn tại không.'
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
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

		-- Kiểm tra nếu shid chưa tồn tại, thì thêm vào bảng SHIPMENT
		IF NOT EXISTS (SELECT sh_id FROM dbo.SHIPMENT WHERE sh_id = @shid)
		BEGIN
			INSERT INTO dbo.SHIPMENT VALUES(@shid, @sid, @imDate, default)
		END

		COMMIT TRAN insert_Ship
	END TRY
	BEGIN CATCH
		PRINT N'Gặp lỗi trong quá trình thêm lo hàng'
		ROLLBACK TRAN insert_Ship
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
		PRINT N'Gặp lỗi trong quá trình thêm thông tin'
		ROLLBACK TRAN insert_DetailShip
	END CATCH
END
GO

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
--Thêm khach hang
CREATE PROCEDURE proc_AddCustomer
	@phone VARCHAR(10),
	@name VARCHAR(255),	
	@point DECIMAL(15, 0)
AS
BEGIN
	BEGIN TRY
		Begin Tran insert_Cus
		INSERT INTO dbo.Customer VALUES(@phone, @name, @point, default)
		Commit Tran insert_Cus
	END TRY
	BEGIN CATCH
		print N'Gặp lỗi trong quá trình thêm khách hàng'
		Rollback Tran insert_Cus
	END CATCH
END
GO
