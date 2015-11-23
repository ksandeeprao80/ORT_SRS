BEGIN TRY
BEGIN TRAN

	DECLARE @LibId INT
	SET @LibId = 0

	INSERT INTO DBO.TR_Library
	(LibTypeId,LibName,CustomerId,IsActive)
	SELECT LibTypeId,'Client Logos' AS LibName,1 AS CustomerId, 1 AS IsActive 
	FROM MS_LibraryType WHERE TypeName = 'GRAPHIC'

	SET @LibId = @@IDENTITY

	---1----------------------------------------------
	DECLARE @Category_1_to_9 INT
	SET @Category_1_to_9 = 0
	INSERT INTO TR_LibraryCategory
	(CategoryName,LibId)
	SELECT 'Category_1_to_9',@LibId 
	SET @Category_1_to_9 = @@IDENTITY
	---2----------------------------------------------
	DECLARE @Category_A_to_D INT
	SET @Category_A_to_D = 0
	INSERT INTO TR_LibraryCategory
	(CategoryName,LibId)
	SELECT 'Category_A_to_D',@LibId  
	SET @Category_A_to_D = @@IDENTITY
	---3----------------------------------------------
	DECLARE @Category_E_to_H INT
	SET @Category_E_to_H = 0
	INSERT INTO TR_LibraryCategory
	(CategoryName,LibId)
	SELECT 'Category_E_to_H',@LibId 
	SET @Category_E_to_H = @@IDENTITY 
	---4----------------------------------------------
	DECLARE @Category_I_to_L INT
	SET @Category_I_to_L = 0
	INSERT INTO TR_LibraryCategory
	(CategoryName,LibId)
	SELECT 'Category_I_to_L',@LibId  
	SET @Category_I_to_L = @@IDENTITY
	---5----------------------------------------------
	DECLARE @Category_M_to_P INT
	SET @Category_M_to_P = 0
	INSERT INTO TR_LibraryCategory
	(CategoryName,LibId)
	SELECT 'Category_M_to_P',@LibId  
	SET @Category_M_to_P = @@IDENTITY
	---6----------------------------------------------
	DECLARE @Category_Q_to_T INT
	SET @Category_Q_to_T = 0
	INSERT INTO TR_LibraryCategory
	(CategoryName,LibId)
	SELECT 'Category_Q_to_T',@LibId  
	SET @Category_Q_to_T = @@IDENTITY
	---7----------------------------------------------
	DECLARE @Category_U_to_Z INT
	SET @Category_U_to_Z = 0
	INSERT INTO TR_LibraryCategory
	(CategoryName,LibId)
	SELECT 'Category_U_to_Z',@LibId 
	SET @Category_U_to_Z = @@IDENTITY
	-------------------------------------------------
 
 	INSERT INTO TR_GraphicFiles
	(LibId, CategoryId,GraphicFileName,Extension,FilePath,CustomerId,UploadedBy,UploadedDate)
	SELECT @LibId, @Category_1_to_9,'1007 Heart FM logo.bmp',RIGHT('1007 Heart FM logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'2009 98 Dublin new_rate_music.jpg',RIGHT('2009 98 Dublin new_rate_music.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'89_0 RTL logo.JPG',RIGHT('89_0 RTL logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'890 rtl logo.jpe',RIGHT('890 rtl logo.jpe',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'91X logo.JPG',RIGHT('91X logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'91X_logo.eps',RIGHT('91X_logo.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'98 Dublin rate music logo.png',RIGHT('98 Dublin rate music logo.png',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'98 Dublin rate our music logo.jpg',RIGHT('98 Dublin rate our music logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'98 Dublin rate_the_music_raw logo.jpg',RIGHT('98 Dublin rate_the_music_raw logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'98fm Dublin logo 2011.jpg',RIGHT('98fm Dublin logo 2011.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'98FM Dublin logo.JPG',RIGHT('98FM Dublin logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'98fm Dublin Rate the Music logo 2011.jpg',RIGHT('98fm Dublin Rate the Music logo 2011.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'98FM Dublin Rate the Music logo.jpg',RIGHT('98FM Dublin Rate the Music logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_1_to_9,'98FMdefini‡Ýo.jpg',RIGHT('98FMdefini‡Ýo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'aire logovariety strap.jpg',RIGHT('aire logovariety strap.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Albany Broadcasting logo.JPG',RIGHT('Albany Broadcasting logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'AMOR Mexico logo.BMP',RIGHT('AMOR Mexico logo.BMP',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Ant Bayern logo bit.bmp',RIGHT('Ant Bayern logo bit.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Ant Thuringen.JPG',RIGHT('Ant Thuringen.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'ARN logo.jpg',RIGHT('ARN logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'AZUL Mexico logo.BMP',RIGHT('AZUL Mexico logo.BMP',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Bauer Radio logo.bmp',RIGHT('Bauer Radio logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Bauer Radio logo.jpg',RIGHT('Bauer Radio logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'BauerMedia logo.jpg',RIGHT('BauerMedia logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'BauerMedia_Logo_GreyMedia copy.jpg',RIGHT('BauerMedia_Logo_GreyMedia copy.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Beat 102-103 Logo.jpg',RIGHT('Beat 102-103 Logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Bell Media logo.bmp',RIGHT('Bell Media logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Bell Media logo.jpg',RIGHT('Bell Media logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Bell Media logo.png',RIGHT('Bell Media logo.png',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Bonneville logo.TIF',RIGHT('Bonneville logo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Border Media Partners logo.jpg',RIGHT('Border Media Partners logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Bounce Edmonton logo.JPG',RIGHT('Bounce Edmonton logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Capital Radio logo.bmp',RIGHT('Capital Radio logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Caz! logo.JPG',RIGHT('Caz! logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'CBS Radio.bmp',RIGHT('CBS Radio.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'CBS Radio-EYE ONLY.bmp',RIGHT('CBS Radio-EYE ONLY.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Chrysalis Radio logo.bmp',RIGHT('Chrysalis Radio logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Chum-FM logo.jpg',RIGHT('Chum-FM logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Citadel Bcasting logo.JPG',RIGHT('Citadel Bcasting logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'City logo.jpg',RIGHT('City logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Clear Channel logo.JPG',RIGHT('Clear Channel logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'CLT-UFA_logo.bmp',RIGHT('CLT-UFA_logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Communicorp logo.JPG',RIGHT('Communicorp logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Connoisseur Media logo.bmp',RIGHT('Connoisseur Media logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Couleur3.bmp',RIGHT('Couleur3.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'DC101logo.bmp',RIGHT('DC101logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Deea logo.TIF',RIGHT('Deea logo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'Derti 98.6 Athens logo.JPG',RIGHT('Derti 98.6 Athens logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_A_to_D,'DIGITAL Mexico logo.BMP',RIGHT('DIGITAL Mexico logo.BMP',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'East Coast Radio logo 0907.jpg',RIGHT('East Coast Radio logo 0907.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'East Coast Radio logo.bmp',RIGHT('East Coast Radio logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Eldoradio_logo.jpg',RIGHT('Eldoradio_logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Emap logo.bmp',RIGHT('Emap logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Emmis Int''l logo.bmp',RIGHT('Emmis Int''l logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Energy Calgary logo.jpg',RIGHT('Energy Calgary logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Entercom logo.jpg',RIGHT('Entercom logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'EROClogo.bmp',RIGHT('EROClogo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'europa fm logo 2006.jpg',RIGHT('europa fm logo 2006.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Europa FM Romania logo.jpg',RIGHT('Europa FM Romania logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Europa FM Spain logo.gif',RIGHT('Europa FM Spain logo.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'europa FM_logo.jpg',RIGHT('europa FM_logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Europa Plus logo 2012.jpg',RIGHT('Europa Plus logo 2012.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Europa Plus logo.jpg',RIGHT('Europa Plus logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'filelist.txt',RIGHT('filelist.txt',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Flow Toronto Logo_2011.jpg',RIGHT('Flow Toronto Logo_2011.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Flow_935_Logo_2011_COLOUR.jpg',RIGHT('Flow_935_Logo_2011_COLOUR.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'FM PLus Sofia logo.jpg',RIGHT('FM PLus Sofia logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'FM104 Dublin logo.JPG',RIGHT('FM104 Dublin logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Forth One logo.TIF',RIGHT('Forth One logo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Frekvence 1 CZ logo.jpg',RIGHT('Frekvence 1 CZ logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Fun Radio bl back.bmp',RIGHT('Fun Radio bl back.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Fun Radio Logo.bmp',RIGHT('Fun Radio Logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Gagasi logo 0907.jpg',RIGHT('Gagasi logo 0907.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Gagasi logo.bmp',RIGHT('Gagasi logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Galaxy 102 cornerlogo-text.bmp',RIGHT('Galaxy 102 cornerlogo-text.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'galaxy 102 logo.bmp',RIGHT('galaxy 102 logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Galaxy 105.bmp',RIGHT('Galaxy 105.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Germany Radio Salu logo.bmp',RIGHT('Germany Radio Salu logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Globo FM Cor.jpg',RIGHT('Globo FM Cor.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Greater Media.TIF',RIGHT('Greater Media.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Hall Communications logo.bmp',RIGHT('Hall Communications logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'hallamfm.jpg',RIGHT('hallamfm.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Heart 1049 logo 0907.jpg',RIGHT('Heart 1049 logo 0907.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Heart South Africa.bmp',RIGHT('Heart South Africa.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Heart Thessaloniki logo.bmp',RIGHT('Heart Thessaloniki logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Hit FM Spain logo.jpg',RIGHT('Hit FM Spain logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Hit-Radio Brocken logo.JPG',RIGHT('Hit-Radio Brocken logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'Hit-Radio Niedersachsen logo.JPG',RIGHT('Hit-Radio Niedersachsen logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_E_to_H,'HR Sachsen.JPG',RIGHT('HR Sachsen.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Imako Greece logo.bmp',RIGHT('Imako Greece logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Imako Greece logo.JPG',RIGHT('Imako Greece logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Inside Radio logo.TIF',RIGHT('Inside Radio logo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Ireland Spin 1038 logo blackbg_with_web.jpg',RIGHT('Ireland Spin 1038 logo blackbg_with_web.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Ireland Spin 1038 whitebg_with_web.jpg',RIGHT('Ireland Spin 1038 whitebg_with_web.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Iskelma Finland logo.JPG',RIGHT('Iskelma Finland logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Jacaranda logo 0907.jpg',RIGHT('Jacaranda logo 0907.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Jacaranda logo.jpg',RIGHT('Jacaranda logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Jamn 945 Boston logo.bmp',RIGHT('Jamn 945 Boston logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Journal Broadcast logo.bmp',RIGHT('Journal Broadcast logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Joy FM Turkey logo.jpg',RIGHT('Joy FM Turkey logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'JoyTurk-Logo.jpg',RIGHT('JoyTurk-Logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'JUICE logo.jpg',RIGHT('JUICE logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'J-WAVE-Logo.jpg',RIGHT('J-WAVE-Logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kagiso Group logo.JPG',RIGHT('Kagiso Group logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kagiso Media logo.bmp',RIGHT('Kagiso Media logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KASE logo.bmp',RIGHT('KASE logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kaya FM logo 0907.jpg',RIGHT('Kaya FM logo 0907.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KDAY logo.JPG',RIGHT('KDAY logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KDMX logo.gif',RIGHT('KDMX logo.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kerrang logo.JPG',RIGHT('Kerrang logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KEY103 Manchester NO SHADOW.jpg',RIGHT('KEY103 Manchester NO SHADOW.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KHHT LA logo.bmp',RIGHT('KHHT LA logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KIJZ Portland logo.bmp',RIGHT('KIJZ Portland logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss 100 logo.jpg',RIGHT('Kiss 100 logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss 108 logo.bmp',RIGHT('Kiss 108 logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss 98 Prague logo.jpg',RIGHT('Kiss 98 Prague logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss FM Athens logo.jpg',RIGHT('Kiss FM Athens logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss FM Spain logo.jpg',RIGHT('Kiss FM Spain logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss FM Spain.jpg',RIGHT('Kiss FM Spain.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss Radio black background logo 1104.JPG',RIGHT('Kiss Radio black background logo 1104.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss Radio white background logo 1104.JPG',RIGHT('Kiss Radio white background logo 1104.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss Romania logo.bmp',RIGHT('Kiss Romania logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kiss Romania logo.JPG',RIGHT('Kiss Romania logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KKCW Portland logo.bmp',RIGHT('KKCW Portland logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KKRZ Z100 logo.tif',RIGHT('KKRZ Z100 logo.tif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'kmel logo.bmp',RIGHT('kmel logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KMLE logo.bmp',RIGHT('KMLE logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Kool 1015 Calgary logo.jpg',RIGHT('Kool 1015 Calgary logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KOST logo.bmp',RIGHT('KOST logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KQMV_Animated_Logo.gif',RIGHT('KQMV_Animated_Logo.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KTFM Jammin San Antonio logo.JPG',RIGHT('KTFM Jammin San Antonio logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KTST logo.bmp',RIGHT('KTST logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'ktwv logo.bmp',RIGHT('ktwv logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KVET logo.bmp',RIGHT('KVET logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'KWNRFlagLogo.jpg',RIGHT('KWNRFlagLogo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Lagardere logo.JPG',RIGHT('Lagardere logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'LARI logo.jpg',RIGHT('LARI logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Lincoln Financial Media logo.JPG',RIGHT('Lincoln Financial Media logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'litecolor.jpg',RIGHT('litecolor.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Local Media San Diego logo.jpg',RIGHT('Local Media San Diego logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Logocolorvector3oct03copy.jpg',RIGHT('Logocolorvector3oct03copy.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_I_to_L,'Los_40_Principales spain logo.jpg',RIGHT('Los_40_Principales spain logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'magic 1067 boston logo.jpg',RIGHT('magic 1067 boston logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Magic 925 San Diego logo.JPG',RIGHT('Magic 925 San Diego logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Magic106 7stacked 150 jpeg update 07-24-12.jpg',RIGHT('Magic106 7stacked 150 jpeg update 07-24-12.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Magic106 7stacked 150 psd file.psd',RIGHT('Magic106 7stacked 150 psd file.psd',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'magic92.5_PANTONE.EPS',RIGHT('magic92.5_PANTONE.EPS',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Maxima Spain logo.gif',RIGHT('Maxima Spain logo.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'MDM logo.jpg',RIGHT('MDM logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'metro.jpg',RIGHT('metro.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Midwest Family Bcasting logo.JPG',RIGHT('Midwest Family Bcasting logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Millennium Radio logo.bmp',RIGHT('Millennium Radio logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Mix106 Mexico logo.bmp',RIGHT('Mix106 Mexico logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Movin 925 Seattle logo.JPG',RIGHT('Movin 925 Seattle logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'NAB EROC logo orange.bmp',RIGHT('NAB EROC logo orange.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'NAB EROC logo.bmp',RIGHT('NAB EROC logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'NAB EROC.gif',RIGHT('NAB EROC.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'NextMedia logo.JPG',RIGHT('NextMedia logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Nitro logo new 0607.jpg',RIGHT('Nitro logo new 0607.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Nitro logo.JPG',RIGHT('Nitro logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Nitro Radio logo.JPG',RIGHT('Nitro Radio logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Nostalgia logo.bmp',RIGHT('Nostalgia logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Option Musique logo.bmp',RIGHT('Option Musique logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'p3logo00.bmp',RIGHT('p3logo00.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Power 1051 NY logo.JPG',RIGHT('Power 1051 NY logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Project Logo bl on white.JPG',RIGHT('Project Logo bl on white.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'Project logo.JPG',RIGHT('Project logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_M_to_P,'promoma logo.bmp',RIGHT('promoma logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Q102 dublin logo.JPG',RIGHT('Q102 dublin logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'q102 logo.bmp',RIGHT('q102 logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Q1045 logo.JPG',RIGHT('Q1045 logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'QMFM Vancouver logo.jpg',RIGHT('QMFM Vancouver logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio 1 Hungary logo.JPG',RIGHT('Radio 1 Hungary logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio 2 Denmark logo.JPG',RIGHT('Radio 2 Denmark logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio 2 DK logo.JPG',RIGHT('Radio 2 DK logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio 21 Romania logo orange.jpg',RIGHT('Radio 21 Romania logo orange.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Brocken logo.gif',RIGHT('Radio Brocken logo.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Brocken logo.JPG',RIGHT('Radio Brocken logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio City 1059 logo.bmp',RIGHT('Radio City 1059 logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Comercial logo.bmp',RIGHT('Radio Comercial logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Globo.TIF',RIGHT('Radio Globo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Gong logo.JPG',RIGHT('Radio Gong logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Gong logo.TIF',RIGHT('Radio Gong logo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio NRW logo.tif',RIGHT('Radio NRW logo.tif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio One logo.JPG',RIGHT('Radio One logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Retro logo',RIGHT('Radio Retro logo',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Sfera 102.2 logo.JPG',RIGHT('Radio Sfera 102.2 logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio Zet logo.jpg',RIGHT('Radio Zet logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio21 logo.gif',RIGHT('Radio21 logo.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Radio7_Logo_2006 new.jpg',RIGHT('Radio7_Logo_2006 new.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RadioDays logo.jpg',RIGHT('RadioDays logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Renda Bcasting logo.JPG',RIGHT('Renda Bcasting logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Retro FM.jpg',RIGHT('Retro FM.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RFM France logo.jpg',RIGHT('RFM France logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RGBtfm.jpg',RIGHT('RGBtfm.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Rock FM logo eps.eps',RIGHT('Rock FM logo eps.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Rock FM logo.eps',RIGHT('Rock FM logo.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Rock FM logo.jpg',RIGHT('Rock FM logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RockFM no shadow.jpg',RIGHT('RockFM no shadow.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Rose logo.jpg',RIGHT('Rose logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RSO logo.TIF',RIGHT('RSO logo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RTL Berlin logo 0303.doc',RIGHT('RTL Berlin logo 0303.doc',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RTL Berlin logo.JPG',RIGHT('RTL Berlin logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RTL Berlin_Logo.eps',RIGHT('RTL Berlin_Logo.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RTL Group Logo.bmp',RIGHT('RTL Group Logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RTL2_logo.bmp',RIGHT('RTL2_logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RTL-FM 1104.JPG',RIGHT('RTL-FM 1104.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RTLFM_logo-CMYK.eps',RIGHT('RTLFM_logo-CMYK.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'RTLNL-U.eps',RIGHT('RTLNL-U.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Salu.gif',RIGHT('Salu.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'SBS logo 2007.bmp',RIGHT('SBS logo 2007.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'SBS logo 2007.JPG',RIGHT('SBS logo 2007.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Sfera logo.TIF',RIGHT('Sfera logo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'SGR.JPG',RIGHT('SGR.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'sky denmark logo.eps',RIGHT('sky denmark logo.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'SkyRadio Hessen Logo.PNG',RIGHT('SkyRadio Hessen Logo.PNG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'SkyRadio Holland logo.jpg',RIGHT('SkyRadio Holland logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Slam FM Holland logo.gif',RIGHT('Slam FM Holland logo.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Smooth Radio logo.jpg',RIGHT('Smooth Radio logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Sonic Vancouver Logo.png',RIGHT('Sonic Vancouver Logo.png',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Spin 1038 Dublin logo 2011.jpg',RIGHT('Spin 1038 Dublin logo 2011.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Spin logo.bmp',RIGHT('Spin logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Spin Southwest logo.jpg',RIGHT('Spin Southwest logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Spree logo.JPG',RIGHT('Spree logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Standard Radio logo.bmp',RIGHT('Standard Radio logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Star FM Thessaloniki logo.bmp',RIGHT('Star FM Thessaloniki logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Swiss Pop logo.bmp',RIGHT('Swiss Pop logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Taverner Research logo.jpg',RIGHT('Taverner Research logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'TFM Radio.JPG',RIGHT('TFM Radio.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'TFM.bmp',RIGHT('TFM.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'The Beat Vancouver logo.jpg',RIGHT('The Beat Vancouver logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'The Voice Bulgaria logo.jpg',RIGHT('The Voice Bulgaria logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Today FM ireland logo edited.jpg',RIGHT('Today FM ireland logo edited.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Today FM ireland logo hi res.eps',RIGHT('Today FM ireland logo hi res.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Today FM Ireland logo update 07-12.png',RIGHT('Today FM Ireland logo update 07-12.png',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'Today FM ireland logo.jpg',RIGHT('Today FM ireland logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_Q_to_T,'TV2 Radio Danmark logo.JPG',RIGHT('TV2 Radio Danmark logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Vibe FM logo.pdf',RIGHT('Vibe FM logo.pdf',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'VIKINGFM logo.jpg',RIGHT('VIKINGFM logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Virgin Radio France logo.JPG',RIGHT('Virgin Radio France logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'virgin radio logo.jpg',RIGHT('virgin radio logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Vitosha Bulgaria logo.jpg',RIGHT('Vitosha Bulgaria logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Voice Logo.bmp',RIGHT('Voice Logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WALK logo.JPG',RIGHT('WALK logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WBTZ Burlington logo.JPG',RIGHT('WBTZ Burlington logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WCAA logo.jpg',RIGHT('WCAA logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WCTK Cat Country 98-1 cat logo.TIF',RIGHT('WCTK Cat Country 98-1 cat logo.TIF',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WGN logo.JPG',RIGHT('WGN logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WHUR Logo.jpg',RIGHT('WHUR Logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Wild 949 logo.bmp',RIGHT('Wild 949 logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WIZN Burlington logo.JPG',RIGHT('WIZN Burlington logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WJJZ Philly logo.JPG',RIGHT('WJJZ Philly logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WJMN logo.bmp',RIGHT('WJMN logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WJOY Burlington logo.JPG',RIGHT('WJOY Burlington logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WJPZAlumniLogo.jpg',RIGHT('WJPZAlumniLogo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WKOL Burlington logo.JPG',RIGHT('WKOL Burlington logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'wktifm logo.gif',RIGHT('wktifm logo.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WKTU logo.JPG',RIGHT('WKTU logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WKZF logo.jpg',RIGHT('WKZF logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WLTW NY logo.JPG',RIGHT('WLTW NY logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WMMX logo.jpg',RIGHT('WMMX logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'wnic.gif',RIGHT('wnic.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'wnua logo.bmp',RIGHT('wnua logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WOKO Burlington logo.JPG',RIGHT('WOKO Burlington logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Wolf Logo.bmp',RIGHT('Wolf Logo.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WROZ  Lancaster logo.jpg',RIGHT('WROZ  Lancaster logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'WWDC_2004.gif',RIGHT('WWDC_2004.gif',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Z100 NY logo.JPG',RIGHT('Z100 NY logo.JPG',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'z100.bmp',RIGHT('z100.bmp',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'z89 logo.jpg',RIGHT('z89 logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Z90 San Diego logo.jpg',RIGHT('Z90 San Diego logo.jpg',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'Z90BabyBlue.eps',RIGHT('Z90BabyBlue.eps',4),'',1,5,GETDATE() UNION
	SELECT @LibId, @Category_U_to_Z,'ZMS logo.JPG',RIGHT('ZMS logo.JPG',4),'',1,5,GETDATE()  

COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH