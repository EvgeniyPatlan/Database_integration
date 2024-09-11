
import mysql.connector
import pymongo
import random
from faker import Faker

fake = Faker()

# Configuration for MySQL (Percona MySQL)
mysql_config = {
    'host': 'localhost',
    'user': 'mysql_user',
    'password': 'mysql_password',
    'database': 'mydb',
    'port': 3306
}

# Configuration for MongoDB (Percona MongoDB)
mongo_config = {
    'host': 'localhost',
    'port': 27017,
    'username': 'mongo_user',
    'password': 'mongo_password',
    'database': 'testdb',
    'collection': 'orders'
}

# Generate data for MySQL
def populate_mysql():
    conn = mysql.connector.connect(**mysql_config)
    cursor = conn.cursor()
    cursor.execute('DELETE FROM customers')  # Clear table before inserting new data
    for _ in range(1000):
        name = fake.name()
        email = fake.email()
        cursor.execute('INSERT INTO customers (name, email) VALUES (%s, %s)', (name, email))
    conn.commit()
    cursor.close()
    conn.close()
    print("Inserted 1000 rows into MySQL customers table.")

# Generate data for MongoDB
def populate_mongodb():
    client = pymongo.MongoClient(f"mongodb://{mongo_config['username']}:{mongo_config['password']}@{mongo_config['host']}:{mongo_config['port']}/")
    db = client[mongo_config['database']]
    collection = db[mongo_config['collection']]
    collection.delete_many({})  # Clear collection before inserting new data
    orders = []
    for _ in range(1000):
        order = {
            "order_id": random.randint(1, 100000),
            "customer_name": fake.name(),
            "order_date": fake.date_this_decade().isoformat(),
            "amount": random.uniform(10, 500)
        }
        orders.append(order)
    collection.insert_many(orders)
    print("Inserted 1000 rows into MongoDB orders collection.")

if __name__ == "__main__":
    populate_mysql()
    populate_mongodb()
