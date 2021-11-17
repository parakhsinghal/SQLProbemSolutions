/*
	Problem:	To find discontinuous sections in an otherwise contiguous series of values spaced apart
				by a fixed interval. Also known as the gaps problem in SQL world.
	Solution:	The solution to this problem relies on using he Lead window function which would give us access
				to the next value in context of the present value. If the difference between the current and 
				the next vlue is greater than 1, then we have found a gap.
	Reference:	Microsoft SQL Server 2021 High-Performance T-SQL Using Window Functions by Itzik Ben Gan
				Chapter 5, Page 193-195
*/

/*
Example: Find the gap in the orderid column of the created table. The values in orderid 
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
	Lead(OrderId) Over(Order by OrderID) as NextOrderId
	From dbo.Orders
)

Select 
CurrentOrderId + 1 as RangeStart, 
NextOrderId - 1 as RangeEnd
From PrepData
Where NextOrderId - CurrentOrderId > 1;
Go

/*
Example: Find the gap in the dateoforder column of the created table. The values in dateoforder 
		 are separated by a fixed interval of 1 day.
*/

With PrepData As
(
	Select 
	DateOfOrder as CurrentOrderDate,
	Lead(DateOfOrder) Over(Order by DateOfOrder) as NextOrderDate
	From dbo.Orders
)

Select 
DateAdd(Day, 1, CurrentOrderDate) as RangeStart, 
DateAdd(Day, -1, NextOrderDate) as RangeEnd
From PrepData
Where DateDiff(Day, CurrentOrderDate, NextOrderDate) > 1;
Go