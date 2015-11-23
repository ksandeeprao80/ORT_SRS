--- KK FINAL SCRIPT FOR MUSIC CLOSET 

DECLARE @CustomerId INT
SET @CustomerId = 1 
	SELECT 
		(
			SELECT 
			(
				SELECT
					TL.LibId, TL.LibName
				FOR XML PATH(''), TYPE 
			),
		(
			SELECT 
			(
				SELECT
					TLC.CategoryId, TLC.CategoryName, 
					ISNULL(TFL.NoOfFiles,0) AS 'NoOfFiles'
				FOR XML PATH('Category'), TYPE 
			)
				FOR XML PATH('Categories'), TYPE 	 
		)
			FOR XML PATH('MusicLibrary'), TYPE 
		)  
	FROM DBO.TR_Library TL
	INNER JOIN DBO.MS_LibraryType MLT
		ON TL.LibTypeId = MLT.LibTypeId
		AND MLT.TypeName = 'File'
		AND TL.CustomerId = @CustomerId
	LEFT OUTER JOIN DBO.TR_LibraryCategory TLC
		ON TL.LibId = TLC.LibId
	LEFT OUTER JOIN
	(
		SELECT 
			Category AS CategoryId, LibId, ISNULL(COUNT(1),0) AS NoOfFiles
		FROM dbo.TR_FileLibrary
	 	GROUP BY LibId, Category 
	) TFL
		ON TLC.LibId = TFL.LibId
		AND TLC.CategoryId = TFL.CategoryId	
	
	ORDER BY TL.LibId, TLC.CategoryId
	FOR XML PATH(''),
	ROOT('MusicLibraries')



--SELECT ( SELECT 'White' AS Color1,
--'Blue' AS Color2,
--'Black' AS Color3,
--'Light' AS 'Color4/@Special',
--'Green' AS Color4,
--'Red' AS Color5
--FOR
--XML PATH('Colors'),
--TYPE
--),
--( SELECT 'Apple' AS Fruits1,
--'Pineapple' AS Fruits2,
--'Grapes' AS Fruits3,
--'Melon' AS Fruits4
--FOR
--XML PATH('Fruits'),
--TYPE
--)
--FOR XML PATH(''),
--ROOT('SampleXML')
--GO 

--- 1
	--SELECT 
	--	(
	--		SELECT 
	--		(
	--			SELECT
	--				TL.LibId, TL.LibName
	--			FOR XML PATH(''), TYPE 
	--		),
	--		TLC.CategoryId, TLC.CategoryName, 
	--		ISNULL(TFL.NoOfFiles,0) AS 'NoOfFiles'
	--		FOR XML PATH('MusicLibrary'), TYPE 
	--	)  
	--FROM DBO.TR_Library TL
	--INNER JOIN DBO.MS_LibraryType MLT
	--	ON TL.LibTypeId = MLT.LibTypeId
	--	AND MLT.TypeName = 'File'
	--	AND TL.CustomerId = 1--@CustomerId
	--LEFT OUTER JOIN DBO.TR_LibraryCategory TLC
	--	ON TL.LibId = TLC.LibId
	--LEFT OUTER JOIN
	--(
	--	SELECT 
	--		Category AS CategoryId, LibId, ISNULL(COUNT(1),0) AS NoOfFiles
	--	FROM dbo.TR_FileLibrary
	-- 	GROUP BY LibId, Category 
	--) TFL
	--	ON TLC.LibId = TFL.LibId
	--	AND TLC.CategoryId = TFL.CategoryId	
	--ORDER BY TL.LibId, TLC.CategoryId
	--FOR XML PATH(''),
	--ROOT('MusicLibraries')
	
	------- 2
	
	--SELECT 
	--	(
	--		SELECT 
	--		(
	--			SELECT
	--				TL.LibId, TL.LibName
	--			FOR XML PATH(''), TYPE 
	--		),
	--	(
	--		SELECT 
	--		(
	--			SELECT
	--				TLC.CategoryId, TLC.CategoryName, 
	--				ISNULL(TFL.NoOfFiles,0) AS 'NoOfFiles'
	--			FOR XML PATH('Category'), TYPE 
	--		)
	--	)
	--		FOR XML PATH('MusicLibrary'), TYPE 
	--	)  
	--FROM DBO.TR_Library TL
	--INNER JOIN DBO.MS_LibraryType MLT
	--	ON TL.LibTypeId = MLT.LibTypeId
	--	AND MLT.TypeName = 'File'
	--	AND TL.CustomerId = 1--@CustomerId
	--LEFT OUTER JOIN DBO.TR_LibraryCategory TLC
	--	ON TL.LibId = TLC.LibId
	--LEFT OUTER JOIN
	--(
	--	SELECT 
	--		Category AS CategoryId, LibId, ISNULL(COUNT(1),0) AS NoOfFiles
	--	FROM dbo.TR_FileLibrary
	-- 	GROUP BY LibId, Category 
	--) TFL
	--	ON TLC.LibId = TFL.LibId
	--	AND TLC.CategoryId = TFL.CategoryId	
	--ORDER BY TL.LibId, TLC.CategoryId
	--FOR XML PATH(''),
	--ROOT('MusicLibraries')
	
	