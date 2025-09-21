
-- Making the easiest loads (Product, Customer and Depot because we only need to make a quick read
-- on the tables)

-- Inserting the products on the dimension
INSERT INTO dw_big_z.ProductDimension SELECT
    gen_random_uuid(),
    p.ProductID,
    p.ProductName,
    p.ProductType,
    s.SupplierName
FROM big_z.Product p LEFT JOIN big_z.Supplier s ON p.SupplierID=s.SupplierID;


-- Inserting the customers on the dimension
INSERT INTO dw_big_z.CustomerDimension SELECT
    gen_random_uuid(),
    c.CustomerID,
    c.CustomerType,
    c.CustomerZip
FROM big_z.Customer c;


-- Inserting the depots on the dimension
INSERT INTO dw_big_z.DepotDimension SELECT
    gen_random_uuid(),
    d.DepotID,
    d.DepotSize,
    d.DepotZip
FROM big_z.Depot d;


-- Now I unite the employees informations from the two fonts to insert onto the 
INSERT INTO dw_big_z.EmployeeDimension SELECT
    gen_random_uuid(),
    e.EmployeeID,
    e.EmployeeName,
    e.EmployeeTitle,
    e.EmployeeEducationLevel
FROM big_z.Employee o LEFT JOIN human_resources.Employee e ON o.EmployeeID=e.EmployeeID;

-- Now I insert all the order's dates onto the calendar dimension
INSERT INTO dw_big_z.Calendar SELECT
    gen_random_uuid(),
    c.CompleteDate,
    c.WeekDay,
    c.MonthDay,
    c.Month,
    c.Trimestry,
    c.Year
FROM (
    SELECT DISTINCT
        o.OrderDate AS CompleteDate,
        CAST(TO_CHAR(o.OrderDate, 'DY') AS dw_big_z.WEEKDAY) AS WeekDay,
        EXTRACT(DAY FROM o.OrderDate) AS MonthDay,
        EXTRACT(MONTH FROM o.OrderDate) AS Month,
        CAST(TO_CHAR(o.OrderDate, 'Q') AS INT) AS Trimestry,
        EXTRACT(YEAR FROM o.OrderDate) AS Year
    FROM big_z.Order o
) c
EXCEPT SELECT
    dwc.CalendarKey,
    dwc.CompleteDate,
    dwc.WeekDay,
    dwc.MonthDay,
    dwc.Month,
    dwc.Trimestry,
    dwc.Year
FROM dw_big_z.Calendar dwc;
