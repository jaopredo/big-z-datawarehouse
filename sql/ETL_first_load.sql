
-- Making the easiest loads (Product, Customer and Depot because we only need to make a quick read
-- on the tables)

-- Inserting the products on the dimension
INSERT INTO dw_big_z.ProductDimension SELECT
    gen_random_uuid(),
    p.ProductID,
    p.ProductName,
    p.ProductType,
    s.SupplierName
FROM big_z.Products p LEFT JOIN big_z.Suppliers s ON p.SupplierID=s.SupplierID;


-- Inserting the customers on the dimension
INSERT INTO dw_big_z.CustomerDimension SELECT
    gen_random_uuid(),
    c.CustomerID,
    c.CustomerType,
    c.CustomerZip
FROM big_z.Customers c;


-- Inserting the depots on the dimension
INSERT INTO dw_big_z.DepotDimension SELECT
    gen_random_uuid(),
    d.DepotID,
    d.DepotSize,
    d.DepotZip
FROM big_z.Depots d;


-- Now I unite the employees informations from the two fonts to insert onto the 
INSERT INTO dw_big_z.EmployeeDimension SELECT
    gen_random_uuid(),
    e.EmployeeID,
    CASE
        WHEN CHAR_LENGTH(e.EmployeeName) >= CHAR_LENGTH(o.EmployeeName)
        THEN e.EmployeeName
        ELSE o.EmployeeName
    END AS EmployeeName,
    e.EmployeeTitle,
    e.EmployeeEducationLevel
FROM big_z.Employees o LEFT JOIN human_resources.Employees e ON o.EmployeeID=e.EmployeeID;

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
    FROM big_z.Orders o
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


-- To finish, inserting the data into the Facts Table
INSERT INTO dw_big_z.OrderFact SELECT
    o.OrderID,
    ov.OrderedviaQuantity,
    o.OrderTime,
    dwc.CustomerKey,
    dwp.ProductKey,
    dwcal.CalendarKey,
    dwd.DepotKey,
    dwe.EmployeeKey
FROM (
    SELECT DISTINCT ON (ord.OrderDate, ord.OrderTime, ord.CustomerID, ord.DepotID, ord.OCID)
        *
    FROM big_z.Orders ord
) o
    INNER JOIN big_z.OrderedVia ov ON o.OrderID=ov.OrderID
    INNER JOIN big_z.Products p ON ov.ProductID=p.ProductID
    INNER JOIN big_z.Depots d ON d.DepotID=o.DepotID
    LEFT JOIN human_resources.Employees e ON e.EmployeeID=o.OCID
    INNER JOIN big_z.Customers c ON c.CustomerID=o.CustomerID

    INNER JOIN dw_big_z.CustomerDimension dwc ON dwc.CustomerID=o.CustomerID
    INNER JOIN dw_big_z.EmployeeDimension dwe ON dwe.EmployeeID=o.OCID
    INNER JOIN dw_big_z.DepotDimension dwd ON dwd.DepotID=o.DepotID
    INNER JOIN dw_big_z.ProductDimension dwp ON dwp.ProductID=ov.ProductID
    INNER JOIN dw_big_z.Calendar dwcal ON dwcal.CompleteDate=o.OrderDate
;
