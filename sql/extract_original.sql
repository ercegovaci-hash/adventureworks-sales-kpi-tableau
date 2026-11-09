-- Single-table extract used for the Tableau workbook (as submitted).
-- Run in Microsoft Access against the AdventureWorksDW database; the result was
-- saved as Sales-Marketing-KPIs.xlsx, which is the workbook's data source.
-- NOTE: see extract_corrected.sql - the join to DimEmployee is not needed and
-- can repeat a sale once per employee assigned to its sales territory.
SELECT DimCustomer.FirstName, DimCustomer.LastName,
       DimDate.EnglishMonthName, DimDate.CalendarYear, DimDate.CalendarQuarter,
       DimProductSubcategory.EnglishProductSubcategoryName,
       DimProductCategory.EnglishProductCategoryName,
       DimGeography.City, DimGeography.StateProvinceName, DimGeography.EnglishCountryRegionName,
       DimSalesTerritory.SalesTerritoryRegion, DimSalesTerritory.SalesTerritoryCountry,
       DimSalesTerritory.SalesTerritoryGroup,
       FactInternetSales.SalesOrderNumber, FactInternetSales.SalesOrderLineNumber,
       FactInternetSales.OrderDate, FactInternetSales.SalesAmount,
       FactInternetSales.TotalProductCost, FactInternetSales.ExtendedAmount,
       FactInternetSales.UnitPrice, FactInternetSales.OrderQuantity
FROM ((DimProductCategory
       INNER JOIN DimProductSubcategory
               ON DimProductCategory.ProductCategoryKey = DimProductSubcategory.ProductCategoryKey)
       INNER JOIN DimProduct
               ON DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey)
INNER JOIN (DimDate
       INNER JOIN (((DimSalesTerritory
                     INNER JOIN DimEmployee
                             ON (DimSalesTerritory.SalesTerritoryKey = DimEmployee.SalesTerritoryKey)
                            AND (DimSalesTerritory.SalesTerritoryKey = DimEmployee.SalesTerritoryKey))
                    INNER JOIN (DimGeography
                                INNER JOIN DimCustomer
                                        ON DimGeography.GeographyKey = DimCustomer.GeographyKey)
                            ON DimSalesTerritory.SalesTerritoryKey = DimGeography.SalesTerritoryKey)
                   INNER JOIN FactInternetSales
                           ON (DimSalesTerritory.SalesTerritoryKey = FactInternetSales.SalesTerritoryKey)
                          AND (DimCustomer.CustomerKey = FactInternetSales.CustomerKey))
               ON (DimDate.DateKey = FactInternetSales.OrderDateKey))
        ON DimProduct.ProductKey = FactInternetSales.ProductKey;
