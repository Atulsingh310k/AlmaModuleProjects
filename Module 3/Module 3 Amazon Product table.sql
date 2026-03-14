-- =============================================
-- SCHEMA DESIGN BASED ON TOP FEATURES (PostgreSQL Compatible)
-- =============================================

-- 1. USER TABLE (Renamed to app_user to avoid reserved word)
CREATE TABLE app_user (
    UserID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address TEXT,
    AccountType VARCHAR(20) CHECK (AccountType IN ('Customer', 'Seller')) NOT NULL,
    RegistrationDate DATE NOT NULL
);

-- 2. PRODUCT TABLE
CREATE TABLE Product (
    ProductID SERIAL PRIMARY KEY,
    SellerID INT NOT NULL,
    ProductName VARCHAR(150) NOT NULL,
    Category VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT DEFAULT 0,
    FOREIGN KEY (SellerID) REFERENCES app_user(UserID)
);

-- 3. ORDER TABLE
CREATE TABLE CustomerOrder (
    OrderID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(20) CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed', 'Refunded')) DEFAULT 'Pending',
    ShippingStatus VARCHAR(20) CHECK (ShippingStatus IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    FOREIGN KEY (UserID) REFERENCES app_user(UserID)
);

-- 4. ORDER ITEM TABLE
CREATE TABLE OrderItem (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES CustomerOrder(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- 5. REVIEW TABLE
CREATE TABLE Review (
    ReviewID SERIAL PRIMARY KEY,
    ProductID INT NOT NULL,
    UserID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (UserID) REFERENCES app_user(UserID)
);

-- 6. PAYMENT TABLE
CREATE TABLE Payment (
    PaymentID SERIAL PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentMethod VARCHAR(30) CHECK (PaymentMethod IN 
        ('Credit Card', 'Debit Card', 'PayPal', 'UPI', 'NetBanking', 'Cash on Delivery')) NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    TransactionStatus VARCHAR(20) CHECK (TransactionStatus IN ('Success', 'Failed', 'Pending', 'Refunded')) DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES CustomerOrder(OrderID)
);

-- 7. WAREHOUSE TABLE
CREATE TABLE Warehouse (
    WarehouseID SERIAL PRIMARY KEY,
    Location VARCHAR(200) NOT NULL,
    ManagerName VARCHAR(100)
);

-- 8. INVENTORY TABLE
CREATE TABLE Inventory (
    InventoryID SERIAL PRIMARY KEY,
    WarehouseID INT NOT NULL,
    ProductID INT NOT NULL,
    QuantityAvailable INT DEFAULT 0,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- 9. RECOMMENDATION TABLE
CREATE TABLE Recommendation (
    RecommendationID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    RecommendationScore DECIMAL(5,2),
    FOREIGN KEY (UserID) REFERENCES app_user(UserID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
