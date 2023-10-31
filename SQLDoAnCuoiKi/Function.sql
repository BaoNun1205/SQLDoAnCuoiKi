--funcition-----------------------
--funcition lay account len tu database
GO
CREATE FUNCTION uf_PermissionRole(@username char(50), @password char(25))
RETURNS TABLE
AS
RETURN Select a_username, a_password, e_name, ac.e_id from ACCOUNT as ac inner join Employee as em on ac.e_id = em.e_id Where a_username = @username and a_password = @password


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