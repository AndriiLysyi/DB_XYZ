:setvar DatabaseName "XYZ"

IF EXISTS (SELECT [name] FROM [master].[sys].[databases] WHERE [name] = N'$(DatabaseName)')
BEGIN
	PRINT 'The database already exists'; 
	RETURN;
END;

CREATE DATABASE $(DatabaseName);
GO

USE $(DatabaseName);
GO

CREATE TABLE [Contact](
    [ContactID] [int] IDENTITY (1, 1) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[CellPhone] [nvarchar](25) NOT NULL
);
GO

CREATE TABLE [Customer](
    [CustomerID] [int] IDENTITY (1, 1) NOT NULL,
	[ContactID]	[int] NOT NULL
);
GO

CREATE TABLE [Driver](
    [DriverID] [int] IDENTITY (1, 1) NOT NULL,
	[ContactID]	[int] NOT NULL
);
GO

CREATE TABLE [Truck](
    [TruckID] [int] IDENTITY (1, 1) NOT NULL,
	[BrandName]	[nvarchar](100) NOT NULL,
	[RegistrationNumber] [nvarchar](50) NOT NULL,
	[Payload] [decimal] (6, 2) NULL CONSTRAINT [CK_Truck_Payload] CHECK ([Payload] >= 0.00),
	[Volume] [decimal] (6, 2) NULL CONSTRAINT [CK_Truck_Volume] CHECK ([Volume] >= 0.00),
	[FuelConsumption] [decimal] (3, 2) NULL CONSTRAINT [CK_Truck_FuelConsumption] CHECK ([FuelConsumption] >= 0.00)
);
GO

CREATE TABLE [Route](
    [RouteID] [int] IDENTITY (1, 1) NOT NULL,
	[OriginalWarehouseID] [int] NOT NULL,
	[DestinationWarehouseID] [int] NOT NULL,
	[Distance] [decimal] (6, 2) NULL CONSTRAINT [CK_Route_Distance] CHECK ([Distance] >= 0.00)
);
GO

CREATE TABLE [Shipment](
    [ShipmentID] [int] IDENTITY (1, 1) NOT NULL,
	[TruckID] [int] NOT NULL,
	[RouteID] [int] NOT NULL,
	[DriverID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL CONSTRAINT [DF_Shipment_StartDate] DEFAULT (GETDATE()),
	[EndtDate] [datetime] NULL,

	 CONSTRAINT [CK_Shipment_EndtDate] CHECK (([EndtDate] >= [StartDate]) OR ([EndtDate] IS NULL))
);
GO

CREATE TABLE [Warehouse](
    [WarehouseID] [int] IDENTITY (1, 1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[City] [nvarchar](50) NOT NULL
);
GO

CREATE TABLE [Cargo](
    [CargoID] [int] IDENTITY (1, 1) NOT NULL,
	[Weight] [decimal] (6, 2) NULL CONSTRAINT [CK_Cargo_Weight] CHECK ([Weight] >= 0.00),
	[Volume] [decimal] (6, 2) NULL CONSTRAINT [CK_Cargo_Volume] CHECK ([Volume] >= 0.00),
	[SenderID] [int] NOT NULL,
	[RecipientID] [int] NOT NULL,
	[Price] [money] NOT NULL CONSTRAINT [CK_Cargo_Price] CHECK ([Price] >= 0.00),
	[Destination] [int] NOT NULL,
	[ShipmentID] [int] NULL
);
GO

CREATE TABLE [CanDrive](
    [TruckID] [int] NOT NULL,
	[DriverID] [int] NOT NULL,
);
GO


-- ****************************************


ALTER TABLE [Contact] WITH CHECK ADD 
    CONSTRAINT [PK_Contact_ID] PRIMARY KEY CLUSTERED
    (
        [ContactID]
    );
GO

ALTER TABLE [Customer] WITH CHECK ADD 
    CONSTRAINT [PK_Ñustomer_ID] PRIMARY KEY CLUSTERED
    (
        [CustomerID]
    );
GO

ALTER TABLE [Driver] WITH CHECK ADD 
    CONSTRAINT [PK_Driver_ID] PRIMARY KEY CLUSTERED
    (
        [DriverID]
    );
GO

ALTER TABLE [Truck] WITH CHECK ADD 
    CONSTRAINT [PK_Truck_ID] PRIMARY KEY CLUSTERED
    (
        [TruckID]
    );
GO

ALTER TABLE [Route] WITH CHECK ADD 
    CONSTRAINT [PK_Route_ID] PRIMARY KEY CLUSTERED
    (
        [RouteID]
    );
GO

ALTER TABLE [Shipment] WITH CHECK ADD 
    CONSTRAINT [PK_Shipment_ID] PRIMARY KEY CLUSTERED
    (
        [ShipmentID]
    );
GO

ALTER TABLE [Warehouse] WITH CHECK ADD 
    CONSTRAINT [PK_Warehouse_ID] PRIMARY KEY CLUSTERED
    (
        [WarehouseID]
    );
GO

ALTER TABLE [Cargo] WITH CHECK ADD 
    CONSTRAINT [PK_Cargo_ID] PRIMARY KEY CLUSTERED
    (
        [CargoID]
    );
GO

-- ****************************************

ALTER TABLE [Customer] ADD 
    CONSTRAINT [FK_Customer_ContactID] FOREIGN KEY 
    (
        [ContactID]
    ) REFERENCES [Contact](
        [ContactID]
    );
GO

ALTER TABLE [Driver] ADD 
    CONSTRAINT [FK_Driver_ContactID] FOREIGN KEY 
    (
        [ContactID]
    ) REFERENCES [Contact](
        [ContactID]
    );
GO

ALTER TABLE [Route] ADD 
    CONSTRAINT [FK_Route_OriginalWarehouseID] FOREIGN KEY 
    (
        [OriginalWarehouseID]
    ) REFERENCES [Warehouse](
        [WarehouseID]
    ),
	 CONSTRAINT [FK_Route_DestinationWarehouseID] FOREIGN KEY 
    (
        [DestinationWarehouseID]
    ) REFERENCES [Warehouse](
        [WarehouseID]
    );
GO

ALTER TABLE [Shipment] ADD 
    CONSTRAINT [FK_Shipment_TruckID] FOREIGN KEY 
    (
        [TruckID]
    ) REFERENCES [Truck](
        [TruckID]
    ),
	 CONSTRAINT [FK_Shipment_RouteID] FOREIGN KEY 
    (
        [RouteID]
    ) REFERENCES [Route](
        [RouteID]
    ),
	CONSTRAINT [FK_Shipment_DriverID] FOREIGN KEY 
    (
        [DriverID]
    ) REFERENCES [Driver](
        [DriverID]
    );
GO

ALTER TABLE [Cargo] ADD 
    CONSTRAINT [FK_Cargo_SenderID] FOREIGN KEY 
    (
        [SenderID]
    ) REFERENCES [Customer](
        [CustomerID]
    ),
	 CONSTRAINT [FK_Cargo_RecipientID] FOREIGN KEY 
    (
        [RecipientID]
    ) REFERENCES [Customer](
        [CustomerID]
    ),
	CONSTRAINT [FK_Cargo_Destination] FOREIGN KEY 
    (
        [Destination]
    ) REFERENCES [Route](
        [RouteID]
    ),
	CONSTRAINT [FK_Cargo_ShipmentID] FOREIGN KEY 
    (
        [ShipmentID]
    ) REFERENCES [Shipment](
        [ShipmentID]
    );
GO

ALTER TABLE [CanDrive] ADD 
    CONSTRAINT [FK_CanDrive_TruckID] FOREIGN KEY 
    (
        [TruckID]
    ) REFERENCES [Truck](
        [TruckID]
    ),
	 CONSTRAINT [FK_CanDrive_DriverID] FOREIGN KEY 
    (
        [DriverID]
    ) REFERENCES [Driver](
        [DriverID]
    );
GO


