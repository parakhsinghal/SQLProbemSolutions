-- Create a databae to learn the concept of paging
Create Database Paging;
Go

-- Create a table for storing data
Create Table MyTable
(
	Id		int				Identity(1,1),
	FName	nvarchar(150),
	LName	nvarchar(150),
	RowId	RowVersion
);
Go

-- Creation of a primary key
Alter Table MyTable
Add Constraint PK_MyTable_Id Primary Key (Id);
Go

-- Creating a clustered index on the primary key
Create Clustered Index CI_MyTable_ClusteredIndex on MyTable(Id);
Go

-- Creating a non-clustered index on the first and last name columns
Create NonClustered Index NCI_MyTable_CoveringIndex on MyTable(FName, LName);
Go

-- Inserting data into the table
Declare @Id int = 0;
Select @Id = Id From MyTable

Insert Into MyTable (FName, LName) Values 
('Parakh' + Cast(@Id as nvarchar(3)), 'Singhal' + Cast(@Id as nvarchar(3)));
Go 100

-- Paging through the results
Declare 
@PageSize	int				= 10,
@PageNumber int				= 3,
@OrderBy	nvarchar(150)	= 'Id Desc'

Select Id, FName, LName
From MyTable
Order By 
	Case When @OrderBy = 'Id Asc'	Then Id End Asc,
	Case When @OrderBy = 'Id Desc'	Then Id End Desc,
	Case When @OrderBy = 'FName Asc' Then FName End Asc,
	Case When @OrderBy = 'FName Desc' Then LName End Desc,
	Case When @OrderBy = 'LName Asc' Then LName End Asc,
	Case When @OrderBy = 'LName Desc' Then LName End Desc
Offset (@PageNumber - 1) * @PageSize Rows Fetch Next @PageSize Rows Only;