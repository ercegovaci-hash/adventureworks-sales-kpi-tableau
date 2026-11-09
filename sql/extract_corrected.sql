-- Corrected single-table extract: one row per order line (FactInternetSales grain).
-- Changes vs extract_original.sql:
--   * DimEmployee removed: no employee column is selected, and joining it on
--     SalesTerritoryKey repeats every sale once per employee in that territory.
--   * The duplicated join condition is gone.
-- Check after running: the row count must equal SELECT COUNT(*) FROM FactInternetSales.
SELECT c.FirstName, c.LastName,
       d.EnglishMonthName, d.CalendarYear, d.CalendarQuarter,
       ps.EnglishProductSubcategoryName, pc.EnglishProductCategoryName,
       g.City, g.StateProvinceName, g.EnglishCountryRegionName,
       st.SalesTerritoryRegion, st.SalesTerritoryCountry, st.SalesTerritoryGroup,
       f.SalesOrderNumber, f.SalesOrderLineNumber, f.OrderDate,
       f.SalesAmount, f.TotalProductCost, f.ExtendedAmount, f.UnitPrice, f.OrderQuantity
FROM ((((((FactInternetSales AS f
      INNER JOIN DimDate AS d               ON f.OrderDateKey = d.DateKey)
      INNER JOIN DimCustomer AS c           ON f.CustomerKey = c.CustomerKey)
      INNER JOIN DimGeography AS g          ON c.GeographyKey = g.GeographyKey)
      INNER JOIN DimSalesTerritory AS st    ON f.SalesTerritoryKey = st.SalesTerritoryKey)
      INNER JOIN DimProduct AS p            ON f.ProductKey = p.ProductKey)
      INNER JOIN DimProductSubcategory AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey)
      INNER JOIN DimProductCategory AS pc   ON ps.ProductCategoryKey = pc.ProductCategoryKey;
