use master;
begin
declare @sql nvarchar(max);
select @sql = coalesce(@sql,'') + 'kill ' + convert(varchar, spid) + ';'
from master..sysprocesses
where dbid in (db_id('TalentGate'),db_id('EngineeringDB'),db_id('MarketingDB'),db_id('SupportDB')) and cmd = 'AWAITING COMMAND' and spid <> @@spid;
exec(@sql);
end;
go
if db_id('TalentGate') 		is not null drop database TalentGate;
if db_id('EngineeringDB') 	is not null drop database EngineeringDB;
if db_id('MarketingDB')  	is not null drop database MarketingDB;
if db_id('SupportDB') 		is not null drop database SupportDB;
create database EngineeringDB;
create database MarketingDB;
create database SupportDB;
use PdbLogic;
exec Pdbinstall 'TalentGate',@ColumnName='DepartmentId',@ProductTypeId=3,@ProcedureSyncModeId=3;
go
use TalentGate;
exec PdbcreatePartition 'TalentGate','EngineeringDB',1;
exec PdbcreatePartition 'TalentGate','MarketingDB',2;
exec PdbcreatePartition 'TalentGate','SupportDB',3;

create table Departments
	(	DepartmentId		PartitionDBType			not null primary key
	,	Name				nvarchar(128)			not null unique
	);

create table Positions
	(	DepartmentId		PartitionDBType		 	not null references Departments (DepartmentId)
	,	Id  				smallint identity(1,1) 	not null primary key
	,	Name				nvarchar(128)			not null unique
	);
	
create table Teams
	(	DepartmentId		PartitionDBType		 	not null references Departments (DepartmentId)
	,	Id  				smallint identity(1,1) 	not null primary key
	,	Name				nvarchar(128)			not null unique
	);
	
create table Employees
	(	DepartmentId		PartitionDBType		 	not null references Departments (DepartmentId)
	,	Id  				smallint identity(1,1) 	not null primary key
	,	FirstName			nvarchar(128)			not null
	,	LastName			nvarchar(128)			not null
	,	EMail				nvarchar(256)			not null unique
	,	PositionId			smallint				not null references Positions (Id)
	,	TeamId				smallint				not null references Teams (Id)
	,	ManagerEmployeeId	smallint				
	,	unique (FirstName,LastName)
	);

alter table Employees add foreign key (ManagerEmployeeId) references Employees (Id);	

create table Jobs
	(	DepartmentId		PartitionDBType		 	not null references Departments (DepartmentId)
	,	Id  				smallint identity(1,1) 	not null primary key
	,	Name				nvarchar(128)			not null
	,	PositionId			smallint				not null references Positions (Id)
	,	TeamId				smallint				not null references Teams (Id)
	);

insert into PdbDepartments values (1,'Engineering');
insert into PdbDepartments values (2,'Marketing');
insert into PdbDepartments values (3,'Support');

insert into PdbPositions (DepartmentId,Name) values (1,'FullStack Developer');
insert into PdbPositions (DepartmentId,Name) values (1,'Server Side Developer');
insert into PdbPositions (DepartmentId,Name) values (1,'System Architect');
insert into PdbPositions (DepartmentId,Name) values (1,'Database Administrator');
insert into PdbPositions (DepartmentId,Name) values (1,'Bigdata Administrator');
insert into PdbPositions (DepartmentId,Name) values (1,'DevOps');
insert into PdbPositions (DepartmentId,Name) values (1,'BI Developer');
insert into PdbPositions (DepartmentId,Name) values (1,'BI Analyst');
insert into PdbPositions (DepartmentId,Name) values (1,'Data Scientist');
insert into PdbPositions (DepartmentId,Name) values (1,'Systems Administrator');
insert into PdbPositions (DepartmentId,Name) values (1,'QA Automation Engineer');
insert into PdbPositions (DepartmentId,Name) values (1,'Security Engineer');
insert into PdbPositions (DepartmentId,Name) values (2,'Business Development');
insert into PdbPositions (DepartmentId,Name) values (2,'Account Executive');
insert into PdbPositions (DepartmentId,Name) values (2,'Media Relations Manager');
insert into PdbPositions (DepartmentId,Name) values (2,'Strategic Planner');
insert into PdbPositions (DepartmentId,Name) values (3,'Customer Support Engineer');
insert into PdbPositions (DepartmentId,Name) values (3,'Technical Support Engineer');
insert into PdbPositions (DepartmentId,Name) values (3,'IT Support Engineer');
insert into PdbPositions (DepartmentId,Name) values (3,'Field Support Engineer');

insert into PdbTeams (DepartmentId,Name) values (1,'Development');
insert into PdbTeams (DepartmentId,Name) values (2,'Business');
insert into PdbTeams (DepartmentId,Name) values (3,'Customer');

insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Rob','Mariano','rob.mariano@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Parvati','Shallow','parvati.shallow@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Russell','Hantz','russell.hantz@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Ozzy','Lusth','ozzy.lusth@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Yul','Kwon','yul.kwon@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Tom','Westman','tom.westman@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Cirie','Fields','cirie.fields@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Richard','Hatch','richard.hatch@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Rob','Cesternino','rob.cesternino@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Kim','Spradlin','kim.spradlin@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Colby','Donaldson','colby.donaldson@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Rupert','Boneham','rupert.boneham@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Ethan','Zohn','ethan.zohn@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Amanda','Kimmel','amanda.kimmel@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (1,'Todd','Herzog','todd.herzog@partitiondb.com',(select Id from PdbPositions where Name = 'FullStack Developer'),(select Id from PdbTeams where Name = 'Development'),(select Id from PdbEmployees where DepartmentId = 1 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Jonathan','Penner','jonathan.penner@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'John','Cochran','john.cochran@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Stephenie','LaGrossa','stephenie.lagrossa@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Brian','Heidik','brian.heidik@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Tyson','Apostol','tyson.apostol@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Tina','Wesson','tina.wesson@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Amber','Brkich','amber.brkich@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Jerri','Manthey','jerri.manthey@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Bob','Crowley','bob.crowley@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Danni','Boatwright','danni.boatwright@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Aras','Baskauskas','aras.baskauskas@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Courtney','Yates','courtney.yates@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Rudy','Boesch','rudy.boesch@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Jenna','Morasca','jenna.morasca@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (2,'Earl','Cole','earl.cole@partitiondb.com',(select Id from PdbPositions where Name = 'Business Development'),(select Id from PdbTeams where Name = 'Business'),(select Id from PdbEmployees where DepartmentId = 2 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Tony','Vlachos','tony.vlachos@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Spencer','Bledsoe','spencer.bledsoe@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Jonny','Fairplay','jonny.fairplay@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'James','Clement','james.clement@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Natalie','White','natalie.white@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Stephen','Fishbach','stephen.fishbach@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Chris','Daugherty','chris.daugherty@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Hayden','Moss','hayden.moss@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Elisabeth','Hasselbeck','elisabeth.hasselbeck@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Benjamin','Wade','benjamin.wade@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Jessica','Kiper','jessica.kiper@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Corinne','Kaplan','corinne.kaplan@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Terry','Deitz','terry.deitz@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Eliza','Orlins','eliza.orlins@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));
insert into PdbEmployees (DepartmentId,FirstName,LastName,EMail,PositionId,TeamId,ManagerEmployeeId) values (3,'Michael','Skupin','michael.skupin@partitiondb.com',(select Id from PdbPositions where Name = 'Customer Support Engineer'),(select Id from PdbTeams where Name = 'Customer'),(select Id from PdbEmployees where DepartmentId = 3 and ManagerEmployeeId is null));

if object_id('GetEmployees','P') is not null drop procedure GetEmployees
go 
create procedure GetEmployees-- 
	(	@DepartmentId tinyint = null
	)
as
begin
	select Departments.Name Department,Teams.Name Team,Employees.Id EmployeeId,Employees.FirstName,Employees.LastName,Positions.Name Position,ManagerEmployees.FirstName ManagerFirstName,ManagerEmployees.LastName ManagerLastName
	from PdbEmployees Employees 
	join PdbDepartments Departments on Employees.DepartmentId = Departments.DepartmentId
	join PdbPositions Positions on Employees.PositionId = Positions.Id
	join PdbTeams Teams on Employees.TeamId = Teams.Id
	left join PdbEmployees ManagerEmployees on Employees.ManagerEmployeeId = ManagerEmployees.Id
	where @DepartmentId is null or Employees.DepartmentId = @DepartmentId;
end;
go

if object_id('GetEmployeesPU','P') is not null drop procedure GetEmployeesPU
go 
create procedure GetEmployeesPU-- 
	(	@DepartmentId tinyint = null
	)
as
begin
	select Departments.Name Department,Teams.Name Team,Employees.Id EmployeeId,Employees.FirstName,Employees.LastName,Positions.Name Position,ManagerEmployees.FirstName ManagerFirstName,ManagerEmployees.LastName ManagerLastName
	from PdbEmployees Employees 
	join PdbDepartments Departments on Employees.DepartmentId = Departments.DepartmentId
	join PdbPositions Positions on Employees.PositionId = Positions.Id
	join PdbTeams Teams on Employees.TeamId = Teams.Id
	left join PdbEmployees ManagerEmployees on Employees.ManagerEmployeeId = ManagerEmployees.Id
	where @DepartmentId is null or Employees.DepartmentId = @DepartmentId;
end;
go

if object_id('GetEmployeesPE','P') is not null drop procedure GetEmployeesPE
go 
create procedure GetEmployeesPE-- 
	(	@DepartmentId tinyint = null
	)
as
begin
	select Departments.Name Department,Teams.Name Team,Employees.Id EmployeeId,Employees.FirstName,Employees.LastName,Positions.Name Position,ManagerEmployees.FirstName ManagerFirstName,ManagerEmployees.LastName ManagerLastName
	from PdbEmployees Employees 
	join PdbDepartments Departments on Employees.DepartmentId = Departments.DepartmentId
	join PdbPositions Positions on Employees.PositionId = Positions.Id
	join PdbTeams Teams on Employees.TeamId = Teams.Id
	left join PdbEmployees ManagerEmployees on Employees.ManagerEmployeeId = ManagerEmployees.Id
	where @DepartmentId is null or Employees.DepartmentId = @DepartmentId;
end;
go

exec GetEmployees;
exec GetEmployeesPU;
exec GetEmployeesPU 1;
exec PdbGetEmployeesPU 1;
exec PdbGetEmployeesPE 1;