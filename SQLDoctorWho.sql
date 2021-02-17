Create database DoctorWho

CREATE TABLE tblEnemy(
EnemyId int NOT NULL,
EnemyName varchar(50) NULL,
Description varchar(200) NULL,
CONSTRAINT PK_tblEnemy PRIMARY KEY (EnemyId));
go
CREATE TABLE tblEpisodeEnemy(
EpisodeEnemyId int  NOT NULL,
EpisodeId int NULL,
EnemyId int NULL,
CONSTRAINT PK_tblEpisodeEnemy PRIMARY KEY (EpisodeEnemyId));
Go
CREATE TABLE tblAuthor(
	AuthorId int  NOT NULL,
	AuthorName varchar(50) NULL,
 CONSTRAINT PK_tblAuthor PRIMARY KEY (AuthorId));
go
 CREATE TABLE tblEpisode(
	EpisodeId int  NOT NULL,
	SeriesNumber int NULL,
	EpisodeNumber int NULL,
	EpisodeType varchar(50) NULL,
	Title varchar (100) NULL,
	EpisodeDatedate date NULL,
	AuthorId int NULL,
	DoctorId int NULL,
	Notes varchar(150) NULL,
 CONSTRAINT PK_tblEpisode PRIMARY KEY (EpisodeId));
go
 CREATE TABLE tblDoctor(
	DoctorId int  NOT NULL,
	DoctorNumber int NULL,
	DoctorName varchar(50) NULL,
	BirthDate date NULL,
	FirstEpisodeDate date NULL,
	LastEpisodeDate date NULL,
 CONSTRAINT PK_tblDoctor PRIMARY KEY (DoctorId));
go
  CREATE TABLE tblEpisodeCompanion(
	EpisodeCompanionId int NOT NULL,
	EpisodeId int NULL,
	CompanionId int NULL,
 CONSTRAINT PK_tblEpisodeCompanion PRIMARY KEY (EpisodeCompanionId));
go
   CREATE TABLE tblCompanion(
	CompanionId int  NOT NULL,
	CompanionName varchar(50) NULL,
	WhoPlayed varchar(50) NULL,
 CONSTRAINT PK_tblCompanion PRIMARY KEY (CompanionId));

go
INSERT INTO tblEnemy (EnemyId,EnemyName,Description) VALUES (1,'TestEnemyName_1', 'TestEnemyDescription_1')
INSERT INTO tblEpisodeEnemy (EpisodeEnemyId,EpisodeId,EnemyId) VALUES (1,1,1)
INSERT INTO tblEpisode(EpisodeId,SeriesNumber,EpisodeNumber,EpisodeType,Title,EpisodeDatedate,AuthorId,DoctorId,Notes) VALUES (1,2,5,'comedey','Brooklyn99', GETDATE(),1,1,'Funny')
INSERT INTO tblAuthor(AuthorId,AuthorName) VALUES (1,'Jake')
INSERT INTO tblEpisodeCompanion(EpisodeCompanionId,EpisodeId,CompanionId) VALUES(1,1,1)
INSERT INTO tblCompanion(CompanionId,CompanionName,WhoPlayed) VALUES(1,'Test1','Test1_WhoPlayed')
INSERT INTO tblDoctor(DoctorId,DoctorNumber,DoctorName,BirthDate,FirstEpisodeDate,LastEpisodeDate) VALUES(1,1234,'Areej',try_convert(date, '01-04-1999', 105),try_convert(date, '01-04-2000', 105),try_convert(date, '01-04-2008', 105))
go
INSERT INTO tblEnemy (EnemyId,EnemyName,Description) VALUES (2,'TestEnemyName_2', 'TestEnemyDescription_2')
INSERT INTO tblEpisodeEnemy (EpisodeEnemyId,EpisodeId,EnemyId) VALUES (2,2,2)
INSERT INTO tblEpisode(EpisodeId,SeriesNumber,EpisodeNumber,EpisodeType,Title,EpisodeDatedate,AuthorId,DoctorId,Notes) VALUES (2,2,5,'mystery','CSI', GETDATE(),2,2,'mystery')
INSERT INTO tblAuthor(AuthorId,AuthorName) VALUES (2,'Areej')
INSERT INTO tblEpisodeCompanion(EpisodeCompanionId,EpisodeId,CompanionId) VALUES(2,2,2)
INSERT INTO tblCompanion(CompanionId,CompanionName,WhoPlayed) VALUES(2,'Test2','Test2_WhoPlayed')
INSERT INTO tblDoctor(DoctorId,DoctorNumber,DoctorName,BirthDate,FirstEpisodeDate,LastEpisodeDate) VALUES(2,1334,'Test',try_convert(date, '01-04-1999', 105),try_convert(date, '01-04-2000', 105),try_convert(date, '01-04-2008', 105))

go
ALTER TABLE tblEpisode
ADD CONSTRAINT FK_tblEpisode_tblAuthor
FOREIGN KEY (AuthorId) REFERENCES tblAuthor(AuthorId);
go
ALTER TABLE tblEpisode
ADD CONSTRAINT FK_tblEpisode_tblDoctor
FOREIGN KEY (DoctorId) REFERENCES tblDoctor(DoctorId);
go
ALTER TABLE tblEpisodeCompanion
ADD CONSTRAINT FK_tblEpisodeCompanion_tblCompanion
FOREIGN KEY (CompanionId) REFERENCES tblCompanion(CompanionId);
go
ALTER TABLE tblEpisodeEnemy
ADD CONSTRAINT FK_tblEpisodeEnemy_tblEnemy
FOREIGN KEY (EnemyId) REFERENCES tblEnemy(EnemyId);
go
ALTER TABLE tblEpisodeCompanion
ADD CONSTRAINT FK_tblEpisodeCompanion_tblEpisode
FOREIGN KEY (EpisodeId) REFERENCES tblEpisode(EpisodeId);
go
ALTER TABLE tblEpisodeEnemy
ADD CONSTRAINT FK_tblEpisodeEnemy_tblEpisode
FOREIGN KEY (EpisodeId) REFERENCES tblEpisode(EpisodeId);

go
CREATE FUNCTION fnCompanions(@Episode_Id int )
RETURNS varchar(50)
AS
begin
 DECLARE @result VARCHAR(50) 
  SELECT
		@result =C.CompanionName
			
	FROM
		tblEpisodeCompanion AS EC
		INNER JOIN tblCompanion AS C ON EC.CompanionId = c.CompanionId
	WHERE
		EC.EpisodeId = @Episode_Id
return @result
end
go
CREATE FUNCTION fnEnemies(@EpisodeId int)
RETURNS varchar(50)
AS
begin
	declare @result varchar(50)

	SELECT
		@result =C.EnemyName		
	FROM
		tblEpisodeEnemy AS EC
		INNER JOIN tblEnemy AS C ON EC.EnemyId = C.EnemyId
	WHERE
		EC.EpisodeId = @EpisodeId

	return @result
end
go

CREATE view viewEpisodes
AS
SELECT 
	SeriesNumber,
	EpisodeNumber,
	EpisodeType,
	Title,
	a.AuthorName,
	d.DoctorName,
	dbo.fnCompanions(e.EpisodeId) AS companions,
	dbo.fnEnemies(e.EpisodeId) AS enemies
FROM
	tblEpisode AS e
	INNER JOIN tblAuthor AS a ON a.AuthorId = e.AuthorId
	INNER JOIN tblDoctor AS d on e.DoctorId = d.DoctorId

	go

CREATE PROCEDURE  spSummariseEpisodes
as
begin
SELECT CompanionName,
    COUNT(CompanionName) AS companion_freq
    FROM     tblCompanion
    GROUP BY CompanionName
    ORDER BY companion_freq DESC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY

SELECT EnemyName,
    COUNT(EnemyName) AS Enemy_freq
    FROM     tblEnemy
    GROUP BY EnemyName
    ORDER BY Enemy_freq DESC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
	end 