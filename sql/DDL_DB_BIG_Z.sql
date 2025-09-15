CREATE DATABASE big_z;

\c big_z

CREATE SCHEMA big_z;


CREATE TABLE big_z.supplier (
    SupplierID SERIAL PRIMARY KEY,
    SupplierNAME TEXT NOT NULL
);

CREATE TABLE big_z.depot (
    DepotID SERIAL PRIMARY KEY,
    DepotSize TEXT NOT NULL,
    DepotZip TEXT NOT NULL
);

CREATE TABLE big_z.product (
    ProductID SERIAL PRIMARY KEY,
    ProductName TEXT NOT NULL,
    ProductType TEXT NOT NULL,
    SupplierID INT NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES big_z.supplier(SupplierID)
);

CREATE TABLE big_z.employee (
    EmployeeID SERIAL PRIMARY KEY,
    EmployeeName TEXT NOT NULL
);

CREATE TABLE big_z.customer (
    CustomerID SERIAL PRIMARY KEY,
    CustomerName TEXT NOT NULL,
    CustomerType TEXT NOT NULL,
    CustomerZip TEXT NOT NULL
);

CREATE TABLE big_z.order (
    OrderID SERIAL PRIMARY KEY,
    OrderDate DATE NOT NULL,
    OrderTime TIME NOT NULL,
    CustomerID INT NOT NULL,
    DepotID INT NOT NULL,
    OCID INT NOT NULL,

    FOREIGN KEY (CustomerID) REFERENCES big_z.customer(CustomerID),
    FOREIGN KEY (DepotID) REFERENCES big_z.depot(DepotID),
    FOREIGN KEY (OCID) REFERENCES big_z.employee(EmployeeID)
);

CREATE TABLE big_z.orderedvia (
    ProductID INT NOT NULL,
    OrderID INT NOT NULL,
    OrderedviaQuantity INT NOT NULL,

    FOREIGN KEY (ProductID) REFERENCES big_z.product(ProductID),
    FOREIGN KEY (OrderID) REFERENCES big_z.order(OrderID)
);


CREATE SCHEMA human_resources;

CREATE TYPE employeetitle AS ENUM('order clerck', 'manager', 'staff');
CREATE TYPE employeeeducationlevel AS ENUM('highschool', 'college', 'master', 'phd');
CREATE TABLE human_resources.employee (
    EmployeeID SERIAL PRIMARY KEY,
    EmployeeName TEXT NOT NULL,
    EmployeeTitle employeetitle NOT NULL,
    EmployeeEducationLevel employeeeducationlevel NOT NULL DEFAULT 'highschool',
    EmployeeYearOfHire INT NOT NULL
);
