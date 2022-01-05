Use master;
Go

Create Database GeonamesTemp;
Go

Create Login GeonamesLogin With Password = 'rhtdmo';
Go

Use GeonamesTemp;
Go

Create User GeonamesApp For Login GeonamesLogin With Default_Schema = dbo;
Go

Alter Role [db_datareader] Add Member GeonamesApp;
Go

Alter Role [db_datawriter] Add Member GeonamesApp;
Go

-- Going reverse
Alter Role db_datareader Drop Member GeonamesApp;
Go

Alter Role db_datawriter Drop Member GeonamesApp;
Go

Drop User GeonamesApp;
Go

Use master;
Go

Drop Login GeonamesLogin;
Go