USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_Customers]    Script Date: 08/08/2012 17:29:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MS_Customers]') AND type in (N'U'))
DROP TABLE [dbo].[MS_Customers]
GO

USE [ORT_SRS]
GO

/****** Object:  Table [dbo].[MS_Customers]    Script Date: 08/08/2012 17:29:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MS_Customers](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](150) NOT NULL,
	[Abbreviation] [varchar](20) NULL,
	[ContactPerson] [varchar](150) NULL,
	[Address1] [varchar](150) NULL,
	[Address2] [varchar](150) NULL,
	[ZipCode] [varchar](20) NULL,
	[City] [int] NULL,
	[State] [int] NULL,
	[Country] [int] NULL,
	[Phone1] [varchar](20) NULL,
	[Phone2] [varchar](20) NULL,
	[Email] [varchar](150) NULL,
	[Website] [varchar](150) NULL,
	[IsActive] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_MS_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_MS_Customers] UNIQUE NONCLUSTERED 
(
	[CustomerName] ASC,
	[Abbreviation] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


