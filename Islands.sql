/*
	Problem:	To find continuous sections of values spaced apart a fixed interval, in the presence of 
				sections of discontinuous values. Also known as the islands problem in SQL world.
	Solution:	The solution to this problem relies on using the dense rank function to generate a continuous
				rank of the values available. Then calculate the difference between the dense rank and the values.
				The difference between the continuous values and the dense rank will remain constant. Islands can 
				be identified by the difference when grouped together.
	Reference:	Microsoft SQL Server 2021 High-Performance T-SQL Using Window Functions by Itzik Ben Gan
				Chapter 5, Page 195-197
*/

/*
Example: Find the island in the orderid column of the created table. The values in orderid 
		 are separated by a fixed interval of 1.
*/
Create Table dbo.Orders
(
	OrderId		int		Primary Key,
	OrderValue	money	Not Null,
	DateOfOrder	Date	Not Null
);
Go

Insert Into dbo.Orders (OrderId, OrderValue, DateOfOrder) Values 
(1, 10, '2021-01-01'),
(2, 20, '2021-01-02'),
(4, 30, '2021-01-05'),
(5, 60, '2021-01-09'),
(9, 90, '2021-01-10'),
(10, 10, '2021-01-13'),
(11, 110, '2021-01-15'),
(15, 90, '2021-01-16'),
(16, 80, '2021-02-02'),
(17, 90, '2021-02-03');
Go

With PrepData As
(
	Select 
	OrderId as CurrentOrderId, 
	Dense_Rank() Over(Order by OrderId) as DenseRank,
	OrderId - Dense_Rank() Over(Order by OrderId) as Diff
	From dbo.Orders
)

Select 
Min(CurrentOrderId) as RangeStart,
Max(CurrentOrderId) as RangeEnd
From PrepData
Group by Diff;
Go

/*
Example: Find the island in the dateoforder column of the created table. The values in dateoforder 
		 are separated by a fixed interval of 1 day.
*/

With PrepData As
(
	Select 
	DateOfOrder as CurrentOrderDate,
	Dense_Rank() Over(Order by DateOfOrder) as NextOrderDate,
	DateAdd(Day, -1 * Dense_Rank() Over(Order by DateOfOrder), DateOfOrder) as Diff
	From dbo.Orders
)

Select 
Min(CurrentOrderDate) as RangeStart, 
Max(CurrentOrderDate) as RangeEnd
From PrepData
Group by Diff
Go