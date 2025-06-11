--retrieve the Title of all books that have never been included in an order.

SELECT B.Title  FROM Books B
LEFT JOIN OrderDetails OD
ON B.BookID = OD.BookID
WHERE OD.BookID IS NULL
------OR----------
SELECT B.Title
FROM Books AS B
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderDetails AS OD
    WHERE OD.BookID = B.BookID
);

--retrieve the FirstName and LastName of all customers
--who have placed an order that includes the book titled 'Pride and Prejudice'.

SELECT C.FirstName, C.LastName FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Books B ON OD.BookID = B.BookID
WHERE B.Title = 'Pride and Prejudice'


--retrieve the FirstName and LastName of all customers who placed an order on the exact same date as the customer with CustomerID 1.
--Do not include CustomerID 1 in the final. result

SELECT DISTINCT C.FirstName, C.LastName FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
WHERE O.OrderDate IN (SELECT OrderDate FROM Orders WHERE CustomerID = 1)
  AND C.CustomerID <> 1;


--Retrieve the FirstName and LastName of authors who have written more books than 'Jane Austen'.
--The result should also include the Number of Books for each of these authors.


SELECT
    A.FirstName,
    A.LastName,
    COUNT(B.BookID) AS Number_of_Books FROM Authors AS A

JOIN Books AS B ON A.AuthorID = B.AuthorID

GROUP BY A.AuthorID, A.FirstName, A.LastName

HAVING COUNT(B.BookID) > (
    SELECT COUNT(B2.BookID)
    FROM Authors AS A2

    JOIN Books AS B2 ON A2.AuthorID = B2.AuthorID
    WHERE A2.FirstName = 'Jane' AND A2.LastName = 'Austen'
);

--retrieve the OrderID and OrderDate for orders where every single book in that order has a PriceAtOrder less than 20.00.


SELECT O.OrderID, O.OrderDate
FROM Orders AS O
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderDetails AS OD
    WHERE OD.OrderID = O.OrderID   
      AND OD.PriceAtOrder >= 20.00 
);
----------OR----------
SELECT O.OrderID, O.OrderDate
FROM Orders AS O
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, O.OrderDate
HAVING MAX(OD.PriceAtOrder) < 20.00;


--retrieve the FirstName and LastName of customers
--who have placed an order that includes at least one book written by 'Charles Dickens'.

SELECT DISTINCT C.FirstName, C.LastName
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
JOIN Books AS B ON OD.BookID = B.BookID
JOIN Authors AS A ON B.AuthorID = A.AuthorID
WHERE A.FirstName = 'Charles' AND A.LastName = 'Dickens';


