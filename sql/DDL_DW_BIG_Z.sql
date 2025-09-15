\c big_z

CREATE SCHEMA dw_big_z;

CREATE TABLE dw_big_z.DepotDimension (
    DepotKey VARCHAR PRIMARY KEY,
    DepotID INT NOT NULL,
    DepotSize TEXT NOT NULL,
    DepotZip TEXT NOT NULL
);

CREATE TABLE dw_big_z.EmployeeDimension (
    EmployeeKey VARCHAR PRIMARY KEY,
    EmployeeID INT NOT NULL,
    EmployeeName TEXT NOT NULL,
    EmployeeTitle employeetitle NOT NULL,
    EmployeeEducationLevel employeeeducationlevel NOT NULL
);

CREATE TABLE dw_big_z.Calendar (
    CalendarKey VARCHAR PRIMARY KEY,
    CompleteDate DATE NOT NULL,
    WeekDay INT NOT NULL CHECK (1 <= WeekDay AND WeekDay <= 7),
    MonthDay INT NOT NULL CHECK (1 <= MonthDay AND MonthDay <= 30),
    Month INT NOT NULL CHECK (1 <= Month AND Month <= 12),
    Trimestry INT NOT NULL CHECK (1 <= Trimestry AND Trimestry <= 4),
    Year INT NOT NULL CHECK (0 <= Year)
);

CREATE TABLE dw_big_z.ProductDimension (
    ProductKey VARCHAR PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductName TEXT NOT NULL,
    ProductType TEXT NOT NULL,
    SupplierName TEXT NOT NULL
);

CREATE TABLE dw_big_z.CustomerDimension (
    CustomerKey VARCHAR PRIMARY KEY,
    CustomerID INT NOT NULL,
    CustomerType TEXT NOT NULL,
    CustomerZip TEXT NOT NULL
);

CREATE TABLE dw_big_z.OrderFact (
    OrderID INT NOT NULL PRIMARY KEY,
    ProductsQuantity INT NOT NULL,
    OrderHour TIME NOT NULL,
    CustomerKey VARCHAR NOT NULL,
    ProductKey VARCHAR NOT NULL,
    CalendarKey VARCHAR NOT NULL,
    DepotKey VARCHAR NOT NULL,
    EmployeeKey VARCHAR NOT NULL,

    FOREIGN KEY (CustomerKey) REFERENCES dw_big_z.CustomerDimension(CustomerKey),
    FOREIGN KEY (ProductKey) REFERENCES dw_big_z.ProductDimension(ProductKey),
    FOREIGN KEY (CalendarKey) REFERENCES dw_big_z.Calendar(CalendarKey),
    FOREIGN KEY (DepotKey) REFERENCES dw_big_z.DepotDimension(DepotKey),
    FOREIGN KEY (EmployeeKey) REFERENCES dw_big_z.EmployeeDimension(EmployeeKey)
);
