import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta
from dotenv import load_dotenv
import os

load_dotenv()


# Quantidades
SUPPLIERS = 10
DEPOTS = 20
PRODUCTS = 100
ORDERCLERK = 40
ORDER = 200
CUSTOMER = 97
ORDERVIA_MAXIMUM = 10
MAXIMUM_PRODUCT_AMOUNT = 15


# Inicializa o Faker
fake = Faker()

# Conexão com o banco
conn = psycopg2.connect(
    dbname='big_z',
    user='joao.pedro',
    password='joao.pedro',
    host='10.61.49.160',
    port='3389'
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
orderclerks = []
for i in range(ORDERCLERK):
    orderclerks.append(i+1)
    cur.execute("INSERT INTO big_z.orderclerk (OCName) VALUES (%s)", (fake.first_name(),))

# ---------- CUSTOMER ----------
customers = []
for i in range(CUSTOMER):
    customers.append(i+1)
    cur.execute("INSERT INTO big_z.customer (CustomerName, CustomerType, CustomerZip) VALUES (%s, %s, %s)",
                (fake.company(), random.choice(["Repair Shop", "Retailer"]), fake.postcode()))

# ---------- ORDERS + ORDEREDVIA ----------
start_date = datetime(2020, 1, 1, 9, 0)
for _ in range(ORDER):  # 10 pedidos
    cust_id = random.choice(customers)
    depot_id = random.choice(depots)
    clerk_id = random.choice(orderclerks)
    order_date = start_date + timedelta(days=random.randint(0, 5))
    order_time = order_date + timedelta(minutes=random.randint(0, 120))

    # Inserir pedido
    cur.execute("""
        INSERT INTO big_z."order" (CustomerID, DepotID, OCID, OrderDate, OrderTime)
        VALUES (%s, %s, %s, %s, %s) RETURNING OrderID
    """, (cust_id, depot_id, clerk_id, order_date.date(), order_time.time()))
    order_id = cur.fetchone()[0]

    # Inserir entre 1 e ORDERVIA_MAXIMUM produtos no pedido
    for _ in range(random.randint(1, ORDERVIA_MAXIMUM)):
        prod_id = random.choice(products)
        qty = random.randint(1, MAXIMUM_PRODUCT_AMOUNT)
        cur.execute("INSERT INTO big_z.orderedvia (ProductID, OrderID, Quantity) VALUES (%s, %s, %s)",
                    (prod_id, order_id, qty))


conn.commit()
cur.close()
conn.close()
