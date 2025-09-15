
SELECT
    gen_random_uuid(),
    p.ProductID,
    p.ProductName,
    p.ProductType,
    s.SupplierName
FROM big_z.Product p FULL JOIN big_z.Supplier s ON p.SupplierID=s.SupplierID;
