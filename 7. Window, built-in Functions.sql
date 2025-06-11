--using a ranking window function to retrieve the Title, Price, FirstName,
--and LastName of the top 2 most expensive books for each author.
--If there are ties for the 2nd spot, include all tied books.

WITH RankedBooks AS (
    SELECT
        B.Title,
        B.Price,
        A.FirstName,
        A.LastName,
  
        DENSE_RANK() OVER (
            PARTITION BY A.AuthorID          
            ORDER BY B.Price DESC           
        ) AS PriceRank
    FROM
        Books AS B
    JOIN
        Authors AS A ON B.AuthorID = A.AuthorID
)
SELECT
    Title,
    Price,
    FirstName,
    LastName
FROM
    RankedBooks
WHERE
    PriceRank <= 2 
ORDER BY
    FirstName, LastName, Price DESC;


--retrieve the Title and Price of each book, and add a new column named PriceCategory.
--The PriceCategory should be:
		--'Expensive' if Price is greater than or equal to 30.00
		--'Moderate' if Price is between 15.00 and 29.99 (inclusive)
		--'Affordable' if Price is less than 15.00

SELECT
    Title,
    Price,
    CASE
        WHEN Price >= 30.00 THEN 'Expensive'
        WHEN Price >= 15.00 AND Price < 30.00 THEN 'Moderate'
        ELSE 'Affordable'
    END AS PriceCategory
FROM
    Books;


--retrieve the OrderID, OrderDate, and a new column called DaysSinceOrder
--which calculates the number of full days between the OrderDate and the current date.

SELECT
    OrderID,
    OrderDate,
    DATEDIFF(day, OrderDate, GETDATE()) AS DaysSinceOrder
FROM
    Orders;

--retrieve the OrderID and OrderDate, but display the OrderDate in the 'YYYY-MM-DD' string format

SELECT
    OrderID,
    FORMAT(OrderDate, 'yyyy-MM-dd') AS FormattedOrderDate
FROM
    Orders;

--retrieve the Title and Price of all books,
--and add a new column called RoundedPrice which displays the Price rounded to two decimal places.

SELECT
    Title,
    Price,
    ROUND(Price, 2) AS RoundedPrice
FROM
    Books;

--retrieve the OrderID, OrderDate, TotalAmount of each order, and a new column named PreviousOrderAmount
--which shows the TotalAmount of the immediately preceding order placed by the same customer.
		--Orders should be considered in chronological order (OrderDate then OrderID for ties).
		--If it's the first order for a customer, PreviousOrderAmount should be NULL.

SELECT
    OrderID,
    OrderDate,
    TotalAmount,
    LAG(TotalAmount, 1, NULL) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate, OrderID
    ) AS PreviousOrderAmount
FROM
    Orders
ORDER BY
    CustomerID, OrderDate, OrderID;


--pivot the data to show the total Quantity of specific books sold, broken down by OrderYear.
		--Include the Book Title as rows.
		--Include OrderYear (2023 and 2024) as columns.
		--Focus only on the books with titles '1984' and 'Pride and Prejudice'.
		--Sum the quantity sold for each book within each order year.

SELECT
    B.Title AS BookTitle,
    SUM(CASE WHEN YEAR(O.OrderDate) = 2023 THEN OD.Quantity ELSE 0 END) AS Quantity_2023,
    SUM(CASE WHEN YEAR(O.OrderDate) = 2024 THEN OD.Quantity ELSE 0 END) AS Quantity_2024
    -- Add more years as needed
FROM
    Books AS B
JOIN
    OrderDetails AS OD ON B.BookID = OD.BookID
JOIN
    Orders AS O ON OD.OrderID = O.OrderID
WHERE
    B.Title IN ('1984', 'Pride and Prejudice')
GROUP BY
    B.Title
ORDER BY
    B.Title;