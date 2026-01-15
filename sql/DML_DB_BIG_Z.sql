-- Inserindo fornecedores (SUPPLIER)
INSERT INTO big_z.Suppliers (SupplierName) VALUES
('Super Tires'),   -- ST
('Batteries Etc'); -- BE

-- Inserindo depósitos (DEPOT)
INSERT INTO big_z.Depots (DepotSize, DepotZip) VALUES
( 'Small', '60611'), -- D1
( 'Large', '60660'), -- D2
( 'Large', '60611'); -- D3

-- Inserindo produtos (PRODUCT)
INSERT INTO big_z.Products (ProductName, ProductType, SupplierID) VALUES
('BigGripper', 'Tire', 1),   -- P1, fornecedor ST
('TractionWiz', 'Tire', 1),  -- P2, fornecedor ST
('SuretStart', 'Battery', 2);-- P3, fornecedor BE

-- Inserindo os atendentes (EMPLOYEES)
INSERT INTO human_resources.Employees (EmployeeName, EmployeeTitle, EmployeeEducationLevel, EmployeeYearOfHire) VALUES
('Tony', 'order clerk', 'highschool', 2010),   -- OC1
('Wes', 'order clerk', 'college', 2016),    -- OC2
('Lilly', 'order clerk', 'college', 2016);  -- OC3

-- Inserindo atendentes na tabela do operacional
INSERT INTO big_z.Employees (EmployeeID, EmployeeName) SELECT
    e.EmployeeID,
    e.EmployeeName
FROM human_resources.Employees e;

-- Inserindo clientes (CUSTOMER)
INSERT INTO big_z.Customers (CustomerName, CustomerType, CustomerZip) VALUES
('Auto Doc', 'Repair Shop', '60137'),   -- C1
('Bo''s Car Repair', 'Repair Shop', '60140'), -- C2
('JJ Auto Parts', 'Retailer', '60655'); -- C3

-- Inserindo pedidos (ORDER)
INSERT INTO big_z.Orders (CustomerID, DepotID, OCID, OrderDate, OrderTime) VALUES
(1, 1, 1, '2020-01-01', '09:00:00'), -- O1
(1, 2, 1, '2020-01-02', '09:00:00'), -- O2
(1, 3, 2, '2020-01-02', '09:30:00'), -- O3
(2, 1, 2, '2020-01-02', '09:00:00'), -- O4
(2, 2, 3, '2020-01-02', '09:15:00'), -- O5
(2, 3, 3, '2020-01-02', '09:45:00'), -- O6
(3, 1, 1, '2020-01-03', '09:00:00'), -- O7
(3, 2, 3, '2020-01-03', '09:45:00'); -- O8

-- Inserindo produtos de cada pedido (ORDEREDVIA)
INSERT INTO big_z.OrderedVia (ProductID, OrderID, OrderedviaQuantity) VALUES
(1, 1, 8),  -- P1 em O1
(2, 1, 4),  -- P2 em O1
(1, 2, 12), -- P1 em O2
(2, 3, 6),  -- P2 em O3
(3, 4, 7),  -- P3 em O4
(3, 5, 5),  -- P3 em O5
(1, 6, 2),  -- P1 em O6
(2, 6, 4),  -- P2 em O6
(3, 7, 3),  -- P3 em O7
(1, 8, 9),  -- P1 em O8
(2, 8, 6);  -- P2 em O8
