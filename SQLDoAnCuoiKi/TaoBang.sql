CREATE DATABASE QLCUAHANG
GO

USE QLCUAHANG
GO 

-- Tạo bảng CUSTOMER
CREATE TABLE CUSTOMER (
    c_phone VARCHAR(10) CHECK (LEN(c_phone) = 10) CONSTRAINT PK_CUSTOMER PRIMARY KEY,
    c_name NVARCHAR(50) NOT NULL,
    c_point DECIMAL(15, 0) check (c_point  >= 0),
    c_status BIT DEFAULT 1
);
GO

-- Tạo bảng EMPLOYEE
CREATE TABLE EMPLOYEE (
    e_id VARCHAR(10) CONSTRAINT PK_EMPLOYEE PRIMARY KEY,
    e_name NVARCHAR(50) NOT NULL,
    e_address NVARCHAR(255) NOT NULL,
    e_phone VARCHAR(10) CHECK (LEN(e_phone) = 10),
    e_gender NVARCHAR(10) NOT NULL,
    e_status BIT DEFAULT 1
);
GO

-- Tạo bảng ACCOUNT
CREATE TABLE ACCOUNT (
    a_username VARCHAR(50) CONSTRAINT PK_ACCOUNT PRIMARY KEY,
    a_password VARCHAR(25) NOT NULL,
	a_status BIT DEFAULT 1,
    e_id VARCHAR(10) CONSTRAINT FR_ACCOUNT_EMPLOYEE 
	FOREIGN KEY REFERENCES EMPLOYEE(e_id),
	a_role INT
);
GO

-- Tạo bảng PRODUCT
CREATE TABLE PRODUCT (
    p_id VARCHAR(10) CONSTRAINT PK_PRODUCT PRIMARY KEY,
    p_name NVARCHAR(255) NOT NULL,
    p_price DECIMAL(15, 0) CHECK (p_price > 0),
    p_image IMAGE NOT NULL,
    p_size NVARCHAR(10) NOT NULL,
    p_quantity INT CHECK (p_quantity >=0),
    p_status BIT DEFAULT 1
);
GO

-- Tạo bảng BILL
CREATE TABLE BILL (
    b_id VARCHAR(10) CONSTRAINT PK_BILL PRIMARY KEY,
    b_date DATE NOT NULL,
    b_totalpay DECIMAL(15, 0) ,
    b_discount DECIMAL(15, 0) NOT NULL,
    b_status BIT DEFAULT 1,
    c_phone VARCHAR(10) CHECK (LEN(c_phone) = 10),
    e_id VARCHAR(10),
    FOREIGN KEY (c_phone) REFERENCES CUSTOMER(c_phone),
    FOREIGN KEY (e_id) REFERENCES EMPLOYEE(e_id)
);
GO

-- Tạo bảng DETAIL_BILL
CREATE TABLE DETAIL_BILL (
    b_id VARCHAR(10),
    p_id VARCHAR(10),
    db_quantity INT NOT NULL,
    db_status BIT DEFAULT 1
    PRIMARY KEY (b_id, p_id),
    FOREIGN KEY (b_id) REFERENCES BILL(b_id),
    FOREIGN KEY (p_id) REFERENCES PRODUCT(p_id)
);
GO

-- Tạo bảng SUPPLIER
CREATE TABLE SUPPLIER (
    s_id VARCHAR(10) CONSTRAINT PK_SUPPLIER PRIMARY KEY,
    s_name NVARCHAR(255) NOT NULL,
    s_phone VARCHAR(10) CHECK (LEN(s_phone) = 10),
    s_address NVARCHAR(255) NOT NULL,
    s_status BIT DEFAULT 1
);
GO

-- Tạo bảng SHIPMENT
CREATE TABLE SHIPMENT (
    sh_id VARCHAR(10) CONSTRAINT PK_SHIPMENT PRIMARY KEY,
    s_id VARCHAR(10) CONSTRAINT FK_SHIPMENT_SUPPLIER   
	FOREIGN KEY REFERENCES SUPPLIER(s_id),
    sh_imDate DATE NOT NULL,
    sh_status BIT DEFAULT 1
);
GO

-- Tạo bảng DETAIL_SHIPMENT
CREATE TABLE DETAIL_SHIPMENT (
	sh_id VARCHAR(10),
	p_id VARCHAR(10),
    p_imPrice DECIMAL(15, 0) CHECK (p_imPrice > 0),
	p_quantity INT CHECK (p_quantity > 0),
	ds_status BIT DEFAULT 1,
	PRIMARY KEY (sh_id, p_id),
	FOREIGN KEY (sh_id) REFERENCES SHIPMENT(sh_id),
	FOREIGN KEY (p_id) REFERENCES PRODUCT(p_id)
);
GO
