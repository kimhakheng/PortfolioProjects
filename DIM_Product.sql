-- Cleaned DIM_Products Table
SELECT TOP (1000) 
	  p.ProductKey
      ,p.ProductAlternateKey AS ProductItemCode
      --,[ProductSubcategoryKey]
      --,[WeightUnitMeasureCode]
      --,[SizeUnitMeasureCode]
      ,p.EnglishProductName AS ProductName
      ,ps.EnglishProductSubcategoryName AS SubCategory -- Joined in from Sub Category Table
      ,pc.EnglishProductCategoryName AS ProductCategory -- Joined in from Category Table
      --,[StandardCost]
      --,[FinishedGoodsFlag]
      ,p.Color AS ProductColor
      --,[SafetyStockLevel]
      --,[ReorderPoint]
      --,[ListPrice]
      ,p.Size AS ProductSize
      --,[SizeRange]
      --,[Weight]
      --,[DaysToManufacture]
      ,p.ProductLine AS ProductLine
      --,[DealerPrice]
      --,[Class]
      --,[Style]
      ,p.ModelName AS ProductModelName
      --,[LargePhoto]
      ,p.EnglishDescription AS ProductDescription
      --,[FrenchDescription]
      --,[ChineseDescription]
      --,[ArabicDescription]
      --,[HebrewDescription]
      --,[ThaiDescription]
      --,[GermanDescription]
      --,[JapaneseDescription]
      --,[TurkishDescription]
      --,[StartDate]
      --,[EndDate]
      --,[Status]
	  ,ISNULL (p.Status, 'Outdated') AS ProductStatus
  FROM dbo.DimProduct as p
	LEFT JOIN dbo.DimProductSubcategory AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
  ORDER BY
	p.ProductKey ASC