

use AdventureWorks2022
go 

--------------
with summary_data as (

 SELECT 
        d.SalesOrderID, 
        CONVERT(DATE,h.OrderDate) as OrderDate,
        h.CustomerID,
		SUM(d.UnitPrice * d.OrderQty) AS [Revenue before Discount],
        SUM(d.UnitPrice * d.OrderQty * d.UnitPriceDiscount) AS Discount,
        SUM((d.UnitPrice * d.OrderQty) - (d.UnitPrice * d.OrderQty * d.UnitPriceDiscount)) AS Revenue,
        SUM(p.StandardCost * d.OrderQty) AS Cost,
		max(h.TaxAmt) as TaxAmt,
		max(h.Freight) as Freight
    FROM Sales.SalesOrderDetail d
    LEFT JOIN Sales.SalesOrderHeader h ON d.SalesOrderID = h.SalesOrderID
    LEFT JOIN Production.Product p ON d.ProductID = p.ProductID
    GROUP BY d.SalesOrderID,h.OrderDate,h.CustomerID
)	

select 
	convert(date,min(OrderDate)) as [Date from],  convert(date,max(OrderDate)) as [Date to], -- date range
	format(COUNT(distinct(SalesOrderID)),'N0') as [Number of orders], --number of orders
	format(COUNT(distinct(CustomerID)),'N0') as [Number of customers], --number of customers,
	format(sum(Revenue),'N0') as Revenue,
	format(sum(Cost), 'n0') as Cost,

	format((sum(Revenue) - sum(Cost)), 'n0') as [Gross Profit],-- Gross Profit (Before Tax & Freight),
		format((sum(TaxAmt) + sum(Freight)),'n0') as Fee,
	format((sum(Revenue) - sum(Cost) - sum(TaxAmt) - sum(Freight)), 'n0') as [Net Profit]-- Net Profit (Final Profit after Tax & Freight)
from summary_data







