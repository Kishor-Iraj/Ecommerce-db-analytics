--create a view named ActiveBooks. 
--This view should display the BookID, Title, and Price of all books that have a Price greater than 0
--(assuming a price of 0 indicates an inactive or unavailable book).

CREATE VIEW ActiveBooks AS
SELECT
    BookID,
    Title,
    Price
FROM
    Books
WHERE
    Price > 0;


--create a stored procedure named GetBooksByAuthor.
--This stored procedure should accept an input parameter @AuthorID (integer)
--and return the Title and Price of all books written by that author.

CREATE PROCEDURE GetBooksByAuthor
    @AuthorID INT
AS
BEGIN
    SELECT
        Title,
        Price
    FROM
        Books
    WHERE
        AuthorID = @AuthorID;
END;

EXEC GetBooksByAuthor @AuthorID = 1;  -- Replace 1 with the actual AuthorID


--create a trigger that ensures the TotalAmount in the Orders table is always the sum of 
--Quantity * PriceAtOrder from its related OrderDetails.
--We'll need two triggers for this: one for INSERT and one for UPDATE on OrderDetails.

CREATE TRIGGER UpdateOrderTotalOnInsert
ON OrderDetails
AFTER INSERT
AS
BEGIN
    UPDATE O
    SET O.TotalAmount = (
        SELECT SUM(OD.Quantity * OD.PriceAtOrder)
        FROM OrderDetails AS OD
        WHERE OD.OrderID = O.OrderID
    )
    FROM Orders AS O
    JOIN inserted AS i ON O.OrderID = i.OrderID;
END;


CREATE TRIGGER UpdateOrderTotalOnDetailUpdate
ON OrderDetails
AFTER UPDATE
AS
BEGIN
    UPDATE O
    SET O.TotalAmount = (
        SELECT SUM(OD.Quantity * OD.PriceAtOrder)
        FROM OrderDetails AS OD
        WHERE OD.OrderID = O.OrderID
    )
    FROM Orders AS O
    JOIN (SELECT OrderID FROM inserted UNION SELECT OrderID FROM deleted) AS AffectedOrders
    ON O.OrderID = AffectedOrders.OrderID;
END;


