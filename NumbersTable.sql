/*
	Problem:	When dealing with a host of problems, we may require a table that contains numbers.
	Solution:	The provided solution can be used to generate a numbers table in memory, or can be used
				to feed a table on disk with generated numbers, or can be used as the core of a 
				table valued function.
*/

Declare 
@LowerBound Bigint = 21,
@UpperBound Bigint = 30; 

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

Select @LowerBound + GeneratedValues - 1 As GeneratedNumbers From Numbers
Order By GeneratedValues
Offset 0 Rows Fetch First @UpperBound - @LowerBound + 1 Rows Only;