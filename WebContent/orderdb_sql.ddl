DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATETIME,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);


CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT,
    orderId             INT,
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);


CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);


CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);


INSERT INTO category(categoryName) VALUES ('Sports');
INSERT INTO category(categoryName) VALUES ('Life Style');
INSERT INTO category(categoryName) VALUES ('Coffee');
INSERT INTO category(categoryName) VALUES ('Cups');
INSERT INTO category(categoryName) VALUES ('Accessories');
INSERT INTO category(categoryName) VALUES ('Food Jars');
INSERT INTO category(categoryName) VALUES ('Bags');
INSERT INTO category(categoryName) VALUES ('Beer,Wine');



INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Everyday Flask', 1, '500ml insulated flask, good for all your daily needs',50.00,'./img/everydayflask.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Kids Flask',1,'300ml insulated flask perfect for your childs first day at school',30.00,'./img/Kidsflask.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Insulated Flask',2,'1L bottle to keep any drink warm, or cold!',80.00,'./img/Insulatedflask.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Sports Water Bottle',2,'500mL water bottle to accompany you in the wils',25.00,'./img/sportswaterbottle.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Sports Water Bottle XL',2,'The 1L version of our popular Sports Water Bottle',40.99, './img/plzwork.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Coffee Mug',2,'200mL mug perfect for you morning coffee',25.00, './img/CoffeeMug.png');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Coffee Mug XL',4,'The 1L version of our popular Coffee Mug',35.00,'./img/CoffeeMugXL.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Hydro Cup',2,'A cup, usefull for multiple purposes',5.00, './img/Hydrocup.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Everday Flask Mouth Replacement',5,'Replacement parts for your flask',20.00, './img/EverdayFlaskMouthReplacement.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Replacement Straw',6,'Replacement straw, compatible with all our flasks',10.00, './img/ReplacementStraw.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Food Jar 1',3,'Able to fit 500g of food',21.00, './img/Foodjar1.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Food Jar 2',3,'Able to fit 700g of food',38.00, './img/Foodjar2.png');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Food Jar 3',4,'Able to fit 1kg of Food',23.25, './img/Foodjar3.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Hydroflask Bag',2,'Own you very own Hydroflask branded bag!',100.00,'./img/Hydroflaskbag.jpg');
INSERT product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Alcohol Flask',7,'Keeps all types of alcohol fresh',50.99,'./img/Alcoholflask.jpg');

    
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Avi', 'Pradhan', 'apr@ubc.com', '111-111-111', '111 UBC Street', 'Kelowna', 'BC', 'V1V 1E1','Canada', 'avi', 'pw' )
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Daniel', 'Krasnov', 'dk@ubc.com', '222-222-222', '222 UBC Street', 'Kelowna', 'BC', 'V2V 121', 'Canada', 'dan', 'pw')
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Ross', 'Cooper', 'rc@ubc.com', '333-333-333', '333 Hill Street', 'Vancouver', 'BC', 'V3V 131', 'Canada', 'ross', 'pw')
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Keiran', 'Malott', 'km@ubc.com', '444-444-444', '444 River Street', 'Toronto', 'ON', 'V4V 141', 'Canada', 'kei', 'pw')

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);


INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES ('Visa', '1234567890123456', '2025-06-01 00:00:00', 1)
INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES ('Mastercard', '5299640000000000', '2026-07-01 00:00:00', 2)
INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES ('Visa', '0000000000000000', '2023-02-01 00:00:00', 3)
INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES ('Amex', '370601052937734', '2028-04-01 00:00:00', 4)
INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES ('Mastercard', '5516697954443486', '2023-01-01 00:00:00', 5)
INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES ('Amex', '378350952578402', '2024-10-01 00:00:00', 6)
INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES ('Visa', '4916801926971355', '2028-01-01 00:00:00', 7)


INSERT INTO warehouse (warehouseId, warehouseName) VALUES (1, 'Bottler.INC')
INSERT INTO warehouse (warehouseId, warehouseName) VALUES (2, 'Water.Co')
INSERT INTO warehouse (warehouseId, warehouseName) VALUES (3, 'Plastic Warehouse')
INSERT INTO warehouse (warehouseId, warehouseName) VALUES (4, 'Best Warehouse')
INSERT INTO warehouse (warehouseId, warehouseName) VALUES (5, 'EZ Shipping Warehouse')
INSERT INTO warehouse (warehouseId, warehouseName) VALUES (6, '#1 Warehouse')

INSERT INTO shipment (shipmentId, shipmentDate, shipmentDesc, warehouseId, orderId) VALUES (1, '2020-10-02 05:30:20', 'Shipment of bottles', 1, 1 )
INSERT INTO shipment (shipmentId, shipmentDate, shipmentDesc, warehouseId, orderId) VALUES (2, '2020-05-20 11:02:45', 'Shipment jugs', 2, 5 )
INSERT INTO shipment (shipmentId, shipmentDate, shipmentDesc, warehouseId, orderId) VALUES (1, '2019-11-11 09:05:11', 'Shipment bottles and jugs', 3, 3 )
INSERT INTO shipment (shipmentId, shipmentDate, shipmentDesc, warehouseId, orderId) VALUES (1, '2019-11-19 03:20:01', 'Shipment of straws', 4, 5 )
INSERT INTO shipment (shipmentId, shipmentDate, shipmentDesc, warehouseId, orderId) VALUES (1, '2019-10-02 12:04:59', 'Shipment of replacements', 5, 7 )
INSERT INTO shipment (shipmentId, shipmentDate, shipmentDesc, warehouseId, orderId) VALUES (1, '2019-09-02 03:23:04','Shipment of bottles', 6, 2 )

INSERT INTO productinventory (productId, warehouseId, quantity, price) VALUES (1, 1, 500, 25000.00)
INSERT INTO productinventory (productId, warehouseId, quantity, price) VALUES (2,1 , 1000, 45000.00)
INSERT INTO productinventory (productId, warehouseId, quantity, price) VALUES (3,2, 200, 4650.00)
INSERT INTO productinventory (productId, warehouseId, quantity, price) VALUES (4, 3, 900, 34200.00)
INSERT INTO productinventory (productId, warehouseId, quantity, price) VALUES (5,4, 2500, 127475.00)
INSERT INTO productinventory (productId, warehouseId, quantity, price) VALUES (6,5, 1100, 27000.00)
INSERT INTO productinventory (productId, warehouseId, quantity, price) VALUES (7,6, 350, 1750.00)

INSERT INTO review (reviewId, reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (1, 5, '2021-11-01 09:30:24', 1, 3, 'I love this product a lot, worth the money')
INSERT INTO review (reviewId, reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (2, 4, '2021-12-23 08:30:43', 2, 5, 'Will definitly buy again')
/* INSERT INTO review (reviewId, reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (3, 5 '2021-12-23 08:30:43', 4, 1, 'Works as advertised') */



