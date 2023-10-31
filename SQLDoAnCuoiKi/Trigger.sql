--Trigger
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