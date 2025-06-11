INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber)
VALUES
('John', 'Doe', 'john.doe@example.com', '111-222-3333'),
('Jane', 'Smith', 'jane.smith@example.com', NULL),
('Alice', 'Johnson', 'alice.j@example.com', '444-555-6666');

INSERT INTO Authors (FirstName, LastName, Biography)
VALUES
('Charles', 'Dickens', NULL),
('Jane', 'Austen', 'Famous for romantic novels'),
('Mark', 'Twain', 'American humorist and novelist');

INSERT INTO Books (Title, AuthorID, ISBN, PublicationYear, Price)
VALUES
('Great Expectations', 1, '9780141439563', 1861, 15.99),
('Pride and Prejudice', 2, '9780141439518', 1813, 12.50),
('The Adventures of Tom Sawyer', 3, '9780486280590', 1876, 8.75);

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '2024-03-01', 25.00),
(2, '2024-03-05', 18.75);

INSERT INTO OrderDetails (OrderID, BookID, Quantity, PriceAtOrder)
VALUES
(1, 1, 1, 15.99),
(1, 2, 1, 12.50),
(2, 3, 2, 8.75),
(2, 1, 1, 15.99);


