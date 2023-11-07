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
	--Kiểm tra số điện thoại
	IF EXISTS (SELECT * FROM inserted WHERE TRIM(c_phone) = '')
    BEGIN
        RAISERROR('Số điện thoại không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
	IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE c_phone IN (SELECT c_phone FROM inserted))
	BEGIN
		RAISERROR('Số điện thoại đã tồn tại', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
    -- Kiểm tra tên khách hàng
    IF EXISTS (SELECT * FROM inserted WHERE TRIM(c_name) = '')
    BEGIN
        RAISERROR('Tên khách hàng không được để trống', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Kiểm tra điểm
    IF EXISTS (SELECT * FROM inserted WHERE c_point <= 0)
    BEGIN
        RAISERROR('Điểm tích lũy không được âm', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END;
