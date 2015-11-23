IF EXISTS 
(
	SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[UspSaveDefaultSurveyCateogries]') 
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1
)
DROP PROCEDURE [dbo].[UspSaveDefaultSurveyCateogries]
GO

CREATE PROCEDURE UspSaveDefaultSurveyCateogries
  @CustomerId INT
AS
BEGIN

	INSERT INTO TR_Library(LibTypeId,LibName,CustomerId,IsActive,CreatedBy,CreatedOn)
	VALUES (6,'Default',@CustomerId,1,1,GETDATE())
	
	DECLARE @LIBID INT
	
	SET @LIBID = @@IDENTITY
	
	INSERT INTO TR_LibraryCategory(CategoryName,LibId,CategoryDescription,CreatedBy,CreatedOn)
	VALUES('Weekly Chart Music Test',@LIBID,'Weekly Chart Music Test',1,GETDATE())
	
	DECLARE @CATID INT
	
	SET @CATID = @@IDENTITY
	
	UPDATE TR_Survey SET CategoryId = @CATID WHERE CustomerId = @CustomerId

	INSERT INTO TR_LibraryCategory(CategoryName,LibId,CategoryDescription,CreatedBy,CreatedOn)
	VALUES('Library Music Test',@LIBID,'Library Music Test',1,GETDATE())

	INSERT INTO TR_LibraryCategory(CategoryName,LibId,CategoryDescription,CreatedBy,CreatedOn)
	VALUES('Perceptual Study',@LIBID,'Perceptual Study',1,GETDATE())
END