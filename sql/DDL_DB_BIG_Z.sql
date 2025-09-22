CREATE DATABASE big_z;

\c big_z

CREATE SCHEMA big_z;


CREATE TABLE big_z.Suppliers (
    SupplierID SERIAL PRIMARY KEY,
    SupplierNAME TEXT NOT NULL
);

CREATE TABLE big_z.Depots (
    DepotID SERIAL PRIMARY KEY,
    DepotSize TEXT NOT NULL,
    DepotZip TEXT NOT NULL
);

CREATE TABLE big_z.Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName TEXT NOT NULL,
    ProductType TEXT NOT NULL,
    SupplierID INT NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES big_z.Suppliers(SupplierID)
);

CREATE TABLE big_z.Employees (
    EmployeeID SERIAL PRIMARY KEY,
    EmployeeName TEXT NOT NULL
);

CREATE TABLE big_z.Customers (
    CustomerID SERIAL PRIMARY KEY,
    CustomerName TEXT NOT NULL,
    CustomerType TEXT NOT NULL,
    CustomerZip TEXT NOT NULL
);

CREATE TABLE big_z.Orders (
    OrderID SERIAL PRIMARY KEY,
    OrderDate DATE NOT NULL,
    OrderTime TIME NOT NULL,
    CustomerID INT NOT NULL,
    DepotID INT NOT NULL,
    OCID INT NOT NULL,

    FOREIGN KEY (CustomerID) REFERENCES big_z.Customers(CustomerID),
    FOREIGN KEY (DepotID) REFERENCES big_z.Depots(DepotID),
    FOREIGN KEY (OCID) REFERENCES big_z.Employees(EmployeeID)
);

CREATE TABLE big_z.OrderedVia (
    ProductID INT NOT NULL,
    OrderID INT NOT NULL,
    OrderedviaQuantity INT NOT NULL,

    FOREIGN KEY (ProductID) REFERENCES big_z.Products(ProductID),
    FOREIGN KEY (OrderID) REFERENCES big_z.Orders(OrderID)
);


CREATE SCHEMA human_resources;

CREATE TYPE human_resources.EMPLOYEETITLE AS ENUM('order clerck', 'manager', 'staff');
CREATE TYPE human_resources.EMPLOYEEEDUCATIONLEVEL AS ENUM('highschool', 'college', 'master', 'phd');
CREATE TABLE human_resources.Employees (
    EmployeeID SERIAL PRIMARY KEY,
    EmployeeName TEXT NOT NULL,
    EmployeeTitle human_resources.EMPLOYEETITLE NOT NULL,
    EmployeeEducationLevel human_resources.EMPLOYEEEDUCATIONLEVEL NOT NULL DEFAULT 'highschool',
    EmployeeYearOfHire INT NOT NULL
);
