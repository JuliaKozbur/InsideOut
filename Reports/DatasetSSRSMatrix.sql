USE [DS2DW]
GO
/****** Object:  StoredProcedure [dbo].[RiseSum2]    Script Date: 24-Oct-17 14:12:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[RiseSum2] @Year int
AS    
;with cte as (
 SELECT SUM([NetAmountLine]) as Sales, [ProductCategoryName], [WeekNumOfMonth], [MonthName], [Year]
FROM [DS2DW].[dbo].[ProductDim] PrDim JOIN
[DS2DW].[dbo].[OrdersFacts] Facts ON PrDim.ProductID=Facts.ProductID
JOIN [DS2DW].[dbo].[DateDim] DateDim ON Facts.DateID=DateDim.DateID
WHERE [Year]=@Year
GROUP BY  [ProductCategoryName],[WeekNumOfMonth], [MonthName], [Year])

SELECT  Sales, 
SUM(Sales) OVER (PARTITION BY [MonthName], [ProductCategoryName] ORDER BY [WeekNumOfMonth] ROWS UNBOUNDED PRECEDING) as RiseSum, 
[ProductCategoryName],
[WeekNumOfMonth],
 [MonthName],
  [Year]
FROM cte 
 ;  
