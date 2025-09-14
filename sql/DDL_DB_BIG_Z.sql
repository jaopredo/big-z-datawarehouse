CREATE DATABASE big_z;

\c big_z

CREATE SCHEMA big_z;


CREATE TABLE big_z.supplier (
    SupplierID SERIAL PRIMARY KEY,
    SupplierNAME TEXT NOT NULL
);

CREATE TABLE big_z.depot (
    DepotID SERIAL PRIMARY KEY,
    DepotSize INT NOT NULL,
    DepotZip TEXT NOT NULL,
);

CREATE TABLE big_z.product (
    ProductID SERIAL PRIMARY KEY,
    ProductName TEXT NOT NULL,
    ProductType TEXT NOT NULL,
    SupplierID INT NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES big_z.supplier(SupplierID)
);
