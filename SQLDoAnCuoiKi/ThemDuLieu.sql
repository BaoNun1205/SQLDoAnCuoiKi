-- Chèn thông tin vào bảng CUSTOMER
INSERT INTO CUSTOMER (c_phone, c_name, c_point, c_status)
VALUES
    ('0963331888', 'Nguyen Van Anh', 100, 1),
    ('0987654321', 'Tran Thi Huong',  50, 1),
    ('0987645635', 'Tran Thi Diem',  50, 1),
    ('0987656734', 'Tran Thi Chau',  50, 1),
    ('0987656456', 'Tran Thi Suong',  50, 1),
    ('0987687578', 'Tran Thi Sa',  50, 1),
    ('0967589321', 'Tran Thi Binh', 50, 1),
    ('0987678234', 'Tran Thi Tu',  50, 1),
    ('0987973451', 'Tran Thi Lan',  50, 1),
    ('0987697456', 'Tran Thi Huong',  50, 1),
    ('0987988901', 'Tran Thi Hoa',  50, 1),
    ('0987564731', 'Tran Thi My', 50, 1),
    ('0987654569', 'Tran Thi Chieu',  50, 1),
    ('0987898761', 'Tran Thi Chinh', 50, 1);

-- Chèn thông tin vào bảng EMPLOYEE
INSERT INTO EMPLOYEE (e_id, e_name, e_address, e_phone, e_gender, e_status)
VALUES
    ('EMP001', 'Le Nguyen Bao', '789 DEF Street', '0963456546', 'Nam', 1)


-- Chèn thông tin vào bảng ACCOUNT
INSERT INTO ACCOUNT (a_username, a_password, e_id)
VALUES
    ('bao', '123', 'EMP001')

INSERT INTO SUPPLIER (s_id, s_name, s_phone, s_address, s_status)
VALUES
    ('S001', 'Nha cung cap X', '0963647486', '789 GUH Street', 1),
    ('S002', 'Nha cung cap Y', '0967835657', '456 THU Lane', 1),
    ('S003', 'Nha cung cap Z', '0967835688', '456 GYH Street', 1),
    ('S004', 'Nha cung cap W', '0975673435', '202 Supplier Avenue', 1);
