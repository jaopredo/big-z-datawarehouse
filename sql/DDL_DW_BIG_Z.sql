\c big_z

CREATE SCHEMA dw_big_z;

CREATE TABLE dw_big_z.DepotDimension (
    DepotKey UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    DepotID INT NOT NULL,
    DepotSize TEXT NOT NULL,
    DepotZip TEXT NOT NULL
);

CREATE TABLE dw_big_z.EmployeeDimension (
    EmployeeKey UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    EmployeeID INT NOT NULL,
    EmployeeName TEXT NOT NULL,
    EmployeeTitle employeetitle NOT NULL,
    EmployeeEducationLevel employeeeducationlevel NOT NULL
);

CREATE TYPE dw_big_z.WEEKDAY AS ENUM('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT');
CREATE TABLE dw_big_z.Calendar (
    CalendarKey UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    CompleteDate DATE NOT NULL,
    WeekDay dw_big_z.WEEKDAY NOT NULL,
    MonthDay INT NOT NULL CHECK (1 <= MonthDay AND MonthDay <= 31),
    Month INT NOT NULL CHECK (1 <= Month AND Month <= 12),
    Trimestry INT NOT NULL CHECK (1 <= Trimestry AND Trimestry <= 4),
    Year INT NOT NULL CHECK (0 <= Year)
);

CREATE TABLE dw_big_z.ProductDimension (
    ProductKey UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductName TEXT NOT NULL,
    ProductType TEXT NOT NULL,
    SupplierName TEXT NOT NULL
);

CREATE TABLE dw_big_z.CustomerDimension (
    CustomerKey UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    CustomerID INT NOT NULL,
    CustomerType TEXT NOT NULL,
    CustomerZip TEXT NOT NULL
);

CREATE TABLE dw_big_z.OrderFact (
    OrderID INT NOT NULL,
    ProductsQuantity INT NOT NULL,
    OrderHour TIME NOT NULL,
    CustomerKey UUID NOT NULL,
    ProductKey UUID NOT NULL,
    CalendarKey UUID NOT NULL,
    DepotKey UUID NOT NULL,
    EmployeeKey UUID NOT NULL,

    PRIMARY KEY (
        OrderID,
        CustomerKey,
        ProductKey,
        CalendarKey,
        DepotKey,
        EmployeeKey
    ),

    FOREIGN KEY (CustomerKey) REFERENCES dw_big_z.CustomerDimension(CustomerKey),
    FOREIGN KEY (ProductKey) REFERENCES dw_big_z.ProductDimension(ProductKey),
    FOREIGN KEY (CalendarKey) REFERENCES dw_big_z.Calendar(CalendarKey),
    FOREIGN KEY (DepotKey) REFERENCES dw_big_z.DepotDimension(DepotKey),
    FOREIGN KEY (EmployeeKey) REFERENCES dw_big_z.EmployeeDimension(EmployeeKey)
);
