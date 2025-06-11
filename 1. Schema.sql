-- DB Creation

CREATE database BookStore;

USE BookStore;

--Tables and Relationships

CREATE table Customers (
CustomerID int PRIMARY KEY identity (1,1),
FirstName nvarchar (50) NOT NULL,
LastName nvarchar (50) NOT NULL,
Email nvarchar (100) UNIQUE,
PhoneNumber nvarchar (20)
);


CREATE table Authors (
AuthorID int PRIMARY KEY identity (1,1),
FirstName nvarchar (50) NOT NULL,
LastName nvarchar (50) NOT NULL,
Biography nvarchar (500)
)

CREATE table Books (
BookID int PRIMARY KEY identity (1,1),
Title nvarchar (200) NOT NULL,
AuthorID int NOT NULL FOREIGN KEY references Authors(AuthorID),
ISBN char(13) UNIQUE NOT NULL,
PublicationYear int NOT NULL,
Price DECIMAL (10, 2) NOT NULL
)

CREATE table Orders (
OrderID int PRIMARY KEY identity (1,1),
CustomerID int NOT NULL FOREIGN KEY references Customers (CustomerID),
OrderDate datetime NOT NULL DEFAULT getdate(),
TotalAmount DECIMAL (10, 2) NOT NULL
)

CREATE table OrderDetails (
OrderID int NOT NULL FOREIGN KEY references Orders(OrderID),
BookID int NOT NULL FOREIGN KEY references Books(BookID),
Quantity int NOT NULL DEFAULT 1,
PriceAtOrder DECIMAL (10, 2) NOT NULL,
PRIMARY KEY (OrderID, BookID)
)

ALTER TABLE Orders
ADD CONSTRAINT DF_Status DEFAULT 'Pending' for Status;

ALTER TABLE Books
ADD CONSTRAINT CK_Books_PricePositive CHECK (Price > 0.00)

ALTER TABLE Customers
ADD CONSTRAINT UQ_Customers_Email UNIQUE (Email)