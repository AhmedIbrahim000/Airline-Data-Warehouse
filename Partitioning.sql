
--1 create file group [partition scheme]
ALTER DATABASE [FlightMS]
ADD FILEGROUP FG_TotalTickets_12_2022;

ALTER DATABASE [FlightMS]
ADD FILEGROUP FG_NoOfFlightMonthly_12_2022;

ALTER DATABASE [FlightMS]
ADD FILEGROUP FG_NoAirplaneModels;

ALTER DATABASE [FlightMS]
ADD FILEGROUP FG_NoAirport;

ALTER DATABASE [FlightMS]
ADD FILEGROUP FG_NoSeatFortPlane;

--2- create file 
ALTER DATABASE [FlightMS]
ADD FILE
(
  NAME = [F_TotalTickets_12_2022],
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FG_TotalTickets_12_2022.ndf',--your DATA Path -- secondary storage extention
  -- as .mdf is primary
  -- https://docs.fileformat.com/database/ndf/
    SIZE = 2 MB  -- default 1 MB  
    --MAXSIZE = UNLIMITED, 
) TO FILEGROUP FG_TotalTickets_12_2022

ALTER DATABASE [FlightMS]
ADD FILE
(
  NAME = [F_NoOfFlightMonthly_12_2022],
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FG_NoOfFlightMonthly_12_2022.ndf',--your DATA Path -- secondary storage extention
  -- as .mdf is primary
  -- https://docs.fileformat.com/database/ndf/
    SIZE = 2 MB  -- default 1 MB  
    --MAXSIZE = UNLIMITED, 
) TO FILEGROUP FG_NoOfFlightMonthly_12_2022

ALTER DATABASE [FlightMS]
ADD FILE
(
  NAME = [F_NoAirplaneModels],
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FG_NoAirplaneModels.ndf',--your DATA Path -- secondary storage extention
  -- as .mdf is primary
  -- https://docs.fileformat.com/database/ndf/
    SIZE = 2 MB  -- default 1 MB  
    --MAXSIZE = UNLIMITED, 
) TO FILEGROUP FG_NoAirplaneModels

ALTER DATABASE [FlightMS]
ADD FILE
(
  NAME = [F_NoAirport],
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FG_NoAirport.ndf',--your DATA Path -- secondary storage extention
  -- as .mdf is primary
  -- https://docs.fileformat.com/database/ndf/
    SIZE = 2 MB  -- default 1 MB  
    --MAXSIZE = UNLIMITED, 
) TO FILEGROUP FG_NoAirport

ALTER DATABASE [FlightMS]
ADD FILE
(
  NAME = [F_NoSeatFortPlane],
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\FG_NoSeatFortPlane.ndf',--your DATA Path -- secondary storage extention
  -- as .mdf is primary
  -- https://docs.fileformat.com/database/ndf/
    SIZE = 2 MB  -- default 1 MB  
    --MAXSIZE = UNLIMITED, 
) TO FILEGROUP FG_NoSeatFortPlane
GO

--3-- Partition Function
CREATE PARTITION FUNCTION [Num_FlightMonthly] (int)
AS RANGE RIGHT FOR VALUES 
(
  '368'  -- each value will be the last value in the file group
);

--4-- Adding a Partition Scheme with File Groups to the Partition Function
CREATE PARTITION SCHEME PS_MonthlyNoFlight
AS PARTITION Num_FlightMonthly
TO 
( 
  'FG_TotalTickets_12_2022',
  'primary'
);


			-- Now create table with partition scheme --
CREATE TABLE FactFight
(
  registration_key varchar(100),
  flight_key int,
  airport_key int,
  ticket_key int,
  total_ticket_sold int,
  number_of_flights_monthly int
) ON PS_MonthlyNoFlight ([total_ticket_sold]); -- define that the partiono is based on the order date
GO


INSERT INTO FactFight (registration_key, flight_key, airport_key, ticket_key, total_ticket_sold, number_of_flights_monthly)
VALUES
('1001', '301', '202', '10', 245, 1),
('1002', '302', '207', '20', 250, 1),
('1003', '303', '200', '30', 216, 1),
('1004', '304', '200', '40', 200, 1),
('1005', '305', '208', '50', 220, 1),
('1006', '306', '205', '60', 180, 1),
('1007', '307', '200', '70', 100, 1),
('1008', '308', '203', '80', 175, 1),
('1009', '309', '210', '90', 293, 1),
('1010', '310', '201', '100', 368, 1)


-- check1 fg stored
SELECT
  name
FROM sys.filegroups
WHERE type = 'FG';


-- check2 files stored
SELECT 
	*
FROM sys.database_files
where type_desc = 'ROWS';


--
SELECT DISTINCT o.name as table_name, rv.value as partition_range, fg.name as file_groupName, p.partition_number, p.rows as number_of_rows
FROM sys.partitions p
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id 
LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
WHERE o.object_id = OBJECT_ID('FactFight');