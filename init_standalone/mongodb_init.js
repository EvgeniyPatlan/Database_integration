
db = db.getSiblingDB('testdb');
db.createCollection('orders');
db.orders.insertMany([
  { order_id: 1, customer_name: 'John Doe', order_date: '2024-09-11', amount: 200.50 },
  { order_id: 2, customer_name: 'Jane Smith', order_date: '2024-09-12', amount: 150.25 }
]);
