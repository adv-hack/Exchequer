USE [DATABASE]
GO

INSERT INTO [COMPANY].[ContactRole]
           ([crRoleId]
           ,[crRoleDescription]
           ,[crRoleAppliesToCustomer]
           ,[crRoleAppliesToSupplier])
     VALUES
           (1,'General Contact', 1, 1),
           (2,'Send Quote', 1, 1),
           (3,'Send Order', 1, 1),
           (4,'Send Delivery Note', 1, 1),
           (5,'Send Invoice', 1, 1),
           (6,'Send Receipt', 1, 0),
           (7,'Send Remittance', 0, 1),
           (8,'Send Statement', 1, 0),
           (9,'Send Debt Chase 1', 1, 0),
           (10,'Send Debt Chase 2', 1, 0),
           (11,'Send Debt Chase 3', 1, 0)
GO

-- SELECT * FROM [COMPANY].ContactRole

