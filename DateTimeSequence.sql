/*
	Problem:	To generate a sequence of dates or time units between two given bounds.
	Solution:	The solution to this problem is a two-part solution. The first part relies on generating a 
				sequence of numbers which will form the backbone of the solution. This backbone is then converted
				to the desired time units which needs to be generated between the given bounds.
	Reference:	Microsoft SQL Server 2021 High-Performance T-SQL Using Window Functions by Itzik Ben Gan
				Chapter 5, Page 137 - 138
*/

-- Function to return a table of numbers between lowerbound and upperbound
Create Function dbo.GetNumbers(@LowerBound As Bigint, @UpperBound As Bigint) Returns Table
As 
Return

-- By default, the CTE will always generate numbers starting with 1 going all the way upto 42,99,67,296
-- SQL Engine is smart and will only generate numbers up until the upperbound when defined
With 
Level0 As (Select 1 as SeedValue1 Union All Select 1 As SeedValue2), -- 2^1 = 2 values
Level1 As (Select 1 As GeneratedValues From Level0 As A Cross Join Level0 As B), -- 2^2 = 4 values
Level2 As (Select 1 As GeneratedValues From Level1 As A Cross Join Level1 As B), -- 2^4 = 16 values
Level3 As (Select 1 As GeneratedValues From Level2 As A Cross Join Level2 As B), -- 2^8 = 256 values
Level4 As (Select 1 As GeneratedValues From Level3 As A Cross Join Level3 As B), -- 2^16 = 65,536 values
Level5 As (Select 1 As GeneratedValues From Level4 As A Cross Join Level4 As B), -- 2^32 = 42,99,67,296 values
Numbers As (Select Row_Number() Over(Order By GeneratedValues) As GeneratedValues From Level5) -- Obtain unique integers

-- Return the numbers between the lower and the upper bound
Select @LowerBound + GeneratedValues - 1 As GeneratedNumbers From Numbers
Order By GeneratedValues
Offset 0 Rows Fetch First @UpperBound - @LowerBound + 1 Rows Only;
Go

/*
Example: To generate consecutive dates between two given dates, we first will generate the total gap
		 in terms of the number of days (sequence of numbers) between the given bounds and then use that sequence 
		 and add the days to the lower bound to reach the upper bound in a continuous manner.
*/
Declare 
@Start as Date = '20210101',
@End as Date = '20210131'

Select Dateadd(day, GeneratedNumbers, @Start) as Dates
From dbo.GetNumbers(0, DateDiff(day, @Start, @End))

/*
Example: To generate consecutive 12 hour units between the provided bounds, we will first generate
				a sequence consisting of the total number of such units between the provided bounds. Then add units
				progresively to the lower bound to reach the upper bound in a continous manner.
*/
Declare 
@Start as Datetime2 = '2021-01-01 00:00:00',
@End as Datetime2 = '2021-01-31 00:00:00'

Select Dateadd(hour, GeneratedNumbers*12, @start) As TimeSlots
from dbo.GetNumbers(0, datediff(hour, @Start, @End)/12) 