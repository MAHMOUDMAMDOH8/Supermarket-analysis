use Supermarket
create table DIMSegment
(
  SEG_ID varchar(12) primary key ,
  Segment varchar(15) not null
)
create table DIMlocation 
(
  [LOC ID] varchar(15) primary key ,
  Country varchar(20) not null ,
  Region varchar(20) not null,
  State varchar(20) not null ,
  City varchar(25) not null,
  [Postal Code] varchar(20) not null
)
create table DIMcustomer 
(
  [Customer ID] varchar(20) primary key ,
  Name varchar(30) not null,
)
create table DIMShipMode
(
  [Ship ID] varchar(15) primary key ,
  mode varchar(25) not null 
)
create table DIMProduct 
(
  [Product ID] varchar(25) primary key ,
  Name varchar(150) not null,
  [category] varchar(25) not null ,
  [sub-category] varchar(15) not null
)
create table DimDate
(
  [order Date] Date primary key ,
  Year int not null,
  Quarter int not null ,
  Month int not null
)
create table Forder
(
  [Trans-id] int primary key ,
  [Order ID] varchar(60) not null,
  [Order Date] Date not null ,
  [Ship Date] Date not null ,
  [Product ID] varchar(25) not null,
  [Ship ID] varchar(15) not null ,
  [Customer ID] varchar(20) not null,
  [LOC ID] varchar(15) not null ,
  SEG_ID varchar(12) not null ,
  Sales float not null,
  Quantity  int not null ,
  Discount float not null,
  Profit float not null,
  constraint DateFK foreign key ([Order Date]) references DimDate([Order Date]),
  constraint productFK foreign key ([Product ID]) references DIMProduct([Product ID]),
  constraint customerFK foreign key ([Customer ID]) references DIMcustomer([Customer ID]),
  constraint ShipFK foreign key ([Ship ID]) references DIMShipMode([Ship ID]),
  constraint SEGFK foreign key (SEG_ID) references DIMSegment(SEG_ID),
  constraint LOCFK foreign key ([LOC ID]) references DIMlocation([LOC ID])
)
----------------------------------------------------------
insert into DIMSegment(SEG_ID  ,Segment)
select *
from [E-commerce2].[dbo].[Segment]

----------------------------------------------------------

insert into DIMlocation([LOC ID],Country,Region,State,City,[Postal Code])
select *
from [E-commerce2].[dbo].Location
----------------------------------------------------------

insert into DIMcustomer([Customer ID],Name)
select C.[Customer ID],C.Name
from [E-commerce2].[dbo].Customer C
----------------------------------------------------------

insert into DIMShipMode([Ship ID],mode)
select *
from [E-commerce2].[dbo].Ship 
----------------------------------------------------------
insert into DIMProduct([Product ID],Name,category,[sub-category])
select P.[Product ID],P.Name,C.Name,S.Name
from [E-commerce2].[dbo].Product P inner join  [E-commerce2].[dbo].Subcategory S
on P.[SUB-category ID]=S.[SUB-category ID] inner join [E-commerce2].[dbo].Category C
on S.[Category ID] = C.[Category ID]
----------------------------------------------------------
insert into DimDate([order Date],Year,Quarter,Month)
SELECT DISTINCT O.[Order Date], 
                YEAR(O.[Order Date]) AS Year,
                DATEPART(QUARTER, O.[Order Date]) AS Quarter,
                MONTH(O.[Order Date]) AS Month
FROM [E-commerce2].[dbo].[order_details] O
order by Year,Month
----------------------------------------------------------
insert into Forder([Trans-id],[Order ID],[Order Date],[Ship Date],[Ship ID],[Product ID],[Customer ID],[LOC ID],SEG_ID,Sales,Quantity,Discount,Profit)
Select O.[Trans-id],OD.[Order ID],OD.[Order Date],OD.[Ship Date],OD.[Ship ID],OD.[Product ID],o.[Customer ID],C.[LOC ID],C.[SEG ID],o.Sales,o.Quantity,o.Discount,o.Profit
from [E-commerce2].[dbo].Orders O inner join [E-commerce2].[dbo].order_details OD
on O.[Trans-id] = OD.[Trans-id] inner join [E-commerce2].[dbo].Customer C
on C.[Customer ID]= o.[Customer ID]