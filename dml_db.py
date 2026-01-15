import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta
from dotenv import load_dotenv
import os
from config import *

load_dotenv()


# Quantidades
SUPPLIERS = 10
DEPOTS = 20
PRODUCTS = 100
ORDERCLERKS = 30
EMPLOYEES = 20
ORDER = 200
CUSTOMER = 97
ORDERVIA_MAXIMUM = 10
MAXIMUM_PRODUCT_AMOUNT = 15


# Inicializa o Faker
fake = Faker()

# Conexão com o banco
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cur = conn.cursor()

# ---------- SUPPLIER ----------
suppliers = []
for i in range(SUPPLIERS):
    supplier_name = fake.company()
    suppliers.append(i+1)
    cur.execute("INSERT INTO big_z.supplier (SupplierName) VALUES (%s)", (supplier_name,))


# ---------- DEPOT ----------
# Tamanhos fixos, zips falsos mas realistas
depots = []
for i in range(DEPOTS):
    depots.append(i+1)
    size = random.choice(["Small", "Medium", "Large"])
    cur.execute("INSERT INTO big_z.depot (DepotSize, DepotZip) VALUES (%s, %s)",
                (size, fake.postcode()))


# ---------- PRODUCT ----------
products = []
for i in range(PRODUCTS):
    products.append(i+1)
    name = fake.word()
    ptype = fake.word()
    sid = random.choice(suppliers)
    cur.execute("INSERT INTO big_z.product (ProductName, ProductType, SupplierID) VALUES (%s, %s, %s)",
                (name, ptype, sid))


# ---------- ORDERCLERK ----------
# Inserting into the big_z schema and, later, on the humanresources table
employees = []
for i in range(ORDERCLERKS):
    employees.append(i+1)
    name = fake.first_name()
    cur.execute("INSERT INTO big_z.employee (EmployeeName) VALUES (%s)", (name,))
    cur.execute("INSERT INTO human_resources.employee (EmployeeName, EmployeeTitle, EmployeeEducationLevel, EmployeeYearOfHire) VALUES (%s, %s, %s, %s)",
        (
            name,
            'order clerck',
            random.choice(['highschool', 'college', 'master', 'phd']),
            random.randint(2020, 2025)
        )
    )

for j in range(EMPLOYEES):
    cur.execute("INSERT INTO human_resources.employee (EmployeeName, EmployeeTitle, EmployeeEducationLevel, EmployeeYearOfHire) VALUES (%s, %s, %s, %s)",
        (
            fake.first_name(),
            random.choice(['order clerck', 'manager', 'staff']),
            random.choice(['highschool', 'college', 'master', 'phd']),
            random.randint(2000, 2025)
        )
    )

# ---------- CUSTOMER ----------
customers = []
for i in range(CUSTOMER):
    customers.append(i+1)
    cur.execute("INSERT INTO big_z.customer (CustomerName, CustomerType, CustomerZip) VALUES (%s, %s, %s)",
                (fake.name(), random.choice(["Repair Shop", "Retailer"]), fake.postcode()))

# ---------- ORDERS + ORDEREDVIA ----------
start_date = datetime(2020, 1, 1, 9, 0)
for _ in range(ORDER):  # 10 pedidos
    cust_id = random.choice(customers)
    depot_id = random.choice(depots)
    clerk_id = random.choice(employees)
    order_date = start_date + timedelta(days=random.randint(0, 5))
    order_time = order_date + timedelta(minutes=random.randint(0, 120))

    # Inserir pedido
    repeated = random.random() <= .20
    orders_ids = []
    cur.execute("""
        INSERT INTO big_z."order" (CustomerID, DepotID, OCID, OrderDate, OrderTime)
        VALUES (%s, %s, %s, %s, %s) RETURNING OrderID
    """, (cust_id, depot_id, clerk_id, order_date.date(), order_time.time()))
    orders_ids.append(cur.fetchone()[0])
    if repeated:
        cur.execute("""
            INSERT INTO big_z."order" (CustomerID, DepotID, OCID, OrderDate, OrderTime)
            VALUES (%s, %s, %s, %s, %s) RETURNING OrderID
        """, (cust_id, depot_id, clerk_id, order_date.date(), order_time.time()))
        orders_ids.append(cur.fetchone()[0])

    # Inserir entre 1 e ORDERVIA_MAXIMUM produtos no pedido
    prods = random.sample(products, k=random.randint(1,ORDERVIA_MAXIMUM))
    for prod in prods:
        qty = random.randint(1, MAXIMUM_PRODUCT_AMOUNT)
        for order_id in orders_ids:
            cur.execute("INSERT INTO big_z.orderedvia (ProductID, OrderID, OrderedviaQuantity) VALUES (%s, %s, %s)",
                        (prod, order_id, qty))


conn.commit()
cur.close()
conn.close()
