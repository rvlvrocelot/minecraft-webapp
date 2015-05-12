USE [InvestorEconomics]
GO
/****** Object:  StoredProcedure [PRODUCTION].[UpdateFundCodeMap]    Script Date: 12/22/2014 8:54:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* DO NOT USE THIS YET*/

ALTER PROCEDURE [PRODUCTION].[UpdateFundCodeMap]
AS

--INSERT INTO dbo.FundCodeMap
--        ( 
--          IFIC_CODE ,
--          SOURCE
--        )
--SELECT a.IFIC_ID_CODE
--			, 'IFIC PIM' 
--FROM 
--(SELECT DISTINCT IFIC_ID_CODE FROM RawDB.IFIC.PrimaryInvestmentManagement) a
--LEFT JOIN dbo.FundCodeMap fcm ON ISNULL(a.IFIC_ID_CODE, 'blargh') = ISNULL(fcm.IFIC_CODE, 'blargh')
--WHERE fcm.FundId IS NULL 

---------
/*
Insert into fundcodemap new entities
*/
INSERT INTO dbo.FundCodeMap
        ( 
          FUND_CODE ,
          IFIC_CODE ,
          SOURCE
        )
SELECT 
			mj.Fund_Code
			, mj.IFIC_CODE
			, CASE WHEN mj.IFIC_CODE LIKE '%*%' THEN 'IFIC MFOF' ELSE 'Investor Insight' END
FROM RawDB.INSIGHT.ModelcodeframeJul96 mj
LEFT JOIN dbo.FundCodeMap fcm ON mj.IFIC_CODE = fcm.IFIC_CODE OR mj.FUND_CODE = fcm.FUND_CODE
WHERE fcm.FUNDID IS NULL  

--Put the set of fund mappings that are not currently in fundcodemap into temp table
IF OBJECT_ID('tempdb..#MapNotIN') IS NOT NULL DROP TABLE #MapNotIN

SELECT FUND_CODE, IFIC_CODE
INTO #MapNotIN
FROM   RawDB.INSIGHT.ModelcodeframeJul96 mj
WHERE  ISNULL(IFIC_CODE, 'x') NOT IN (SELECT ISNULL(IFIC_CODE, 'x') FROM dbo.FundCodeMap fcm WHERE fcm.FUND_CODE = mj.FUND_CODE)

-- Update fundcode map with fund code values from #MapNotIn joined in on IFIC_Code: Duplicates will be cleaned up after
UPDATE fcm
SET fcm.fund_code = mnt.Fund_code
--SELECT *
FROM 
#MapNoTIN mnt
JOIN dbo.FundCodeMap fcm ON mnt.IFIC_CODE=fcm.IFIC_CODE
WHERE fcm.FUND_CODE IS NULL 

-- Update fundcode map with ific code values from #MapNotIn joined in on Fund_Code: Duplicates will be cleaned up after
UPDATE fcm 
SET fcm.IFIC_CODE = mnt.IFIC_CODE
, fcm.[SOURCE] =  'IFIC MFOF'
--SELECT *
FROM 
#MapNoTIN mnt
JOIN dbo.FundCodeMap fcm ON mnt.Fund_CODE=fcm.FUND_CODE
WHERE fcm.IFIC_CODE IS NULL 

-- Clean out duplicates (fundcode and ific code mapped the same but with different fundids) by putting them into another temp table
IF OBJECT_ID('tempdb..#UpdateFundID') IS NOT NULL DROP TABLE #UpdateFundID


SELECT fcm.*, f.MSNO, f.MSPNO
INTO #UpdateFundID
FROM 
dbo.FundCodeMap fcm
JOIN dbo.fund f ON fcm.FundId = f.FundId
JOIN dbo.FundCodeMap b ON fcm.FUND_CODE = b.FUND_CODE
WHERE b.FundId <> fcm.FundId
ORDER BY fcm.FUND_CODE

-- Update fundcode map's fundids by keeping the fundids (of the duplicates) that's already associated with ms code matched either by Pablo or IE team
UPDATE fcm 
SET fcm.fundid = u1.fundid
FROM 
(SELECT * FROM  #UpdateFundID WHERE MSNO <> '*') u1
JOIN 
(SELECT * FROM #UpdateFundID WHERE msno = '*') u2 ON u1.FUND_CODE = u2.FUND_CODE
JOIN dbo.FundCodeMap fcm ON u2.Id = fcm.Id
--ORDER BY u1.FUND_CODE

IF OBJECT_ID('tempdb..#UpdateFundID') IS NOT NULL DROP TABLE #UpdateFundID

-- Go back and recreate temp table of duplicates with different fundids
IF OBJECT_ID('tempdb..#UpdateFundID2') IS NOT NULL DROP TABLE #UpdateFundID2

SELECT fcm.*, f.MSNO, f.MSPNO
INTO #UpdateFundID2
FROM 
dbo.FundCodeMap fcm
JOIN dbo.fund f ON fcm.FundId = f.FundId
JOIN dbo.FundCodeMap b ON fcm.FUND_CODE = b.FUND_CODE
WHERE b.FundId <> fcm.FundId
ORDER BY fcm.FUND_CODE

-- Update fundcode map's fundids by keeping the fundids (of the duplicates) that was inserted into FundCode map later (by fundcodemap's ID key)
UPDATE fcm 
SET fcm.fundid = u2.fundid
--SELECT fcm.FundId, fcm.FUND_CODE, u2.*
FROM #UpdateFundID2 u1
JOIN #UpdateFundID u2 ON u1.FUND_CODE = u2.FUND_CODE
JOIN dbo.FundCodeMap fcm ON u1.Id = fcm.Id
WHERE u1.ID < u2.ID
--ORDER BY u1.FUND_CODE

IF OBJECT_ID('tempdb..#UpdateFundID2') IS NOT NULL DROP TABLE #UpdateFundID2

IF OBJECT_ID('tempdb..#MapNotIN') IS NOT NULL DROP TABLE #MapNotIN

-- TO prevent old fundids in Fund table from causing trouble, it needs to be cleaned of fundids that are not in fundcodemap
DELETE
FROM dbo.fund
WHERE FundId NOT IN (SELECT DISTINCT fundid FROM dbo.FundCodeMap)

-- FOR CHECKING ONLY - There should be none left. Lawd help us if there are triplets :/

--IF OBJECT_ID('tempdb..#UpdateFundID') IS NOT NULL DROP TABLE #UpdateFundID
--SELECT fcm.*, f.MSNO, f.MSPNO 
--INTO #UpdateFundID
--FROM 
--dbo.FundCodeMap fcm
--JOIN dbo.fund f ON fcm.FundId = f.FundId
--LEFT JOIN 
--		(SELECT FundId, FUND_CODE
--		FROM dbo.FundCodeMap fcm
--		GROUP BY FundId, FUND_CODE
--		HAVING COUNT(*) > 1) a ON fcm.FundId = a.FundId AND  fcm.FUND_CODE = a.FUND_CODE
--WHERE a.FundId IS NULL AND
--fcm.FUND_CODE IN 
--(SELECT FUND_CODE 
--FROM dbo.FundCodeMap fcm 
--WHERE IFIC_CODE IS NOT NULL AND FUND_CODE IS NOT NULL 
--GROUP BY FUND_CODE
--HAVING COUNT(*) > 1)
--ORDER BY fcm.FUND_CODE

/*
The lines below were used to make further adjustments for JUNE 2014 data
*/

--UPDATE fcm2 
--SET fcm2.ific_code = a.ific_code
--, fcm2.[SOURCE] = 'IFIC MFOF'
--FROM 
--(SELECT mnt.FUND_CODE, mnt.IFIC_CODE FROM #MapNoTIN mnt
--LEFT JOIN dbo.FundCodeMap fcm ON mnt.FUND_CODE = fcm.FUND_CODE AND mnt.IFIC_CODE = fcm.IFIC_CODE
--WHERE mnt.FUND_CODE NOT IN (7508,7509,18150)
--AND fcm.FundId IS NULL) a 
--LEFT JOIN dbo.FundCodeMap fcm2 ON a.FUND_CODE = fcm2.FUND_CODE
--WHERE fcm2.FundId IS NOT NULL 

--INSERT INTO dbo.FundCodeMap
--        ( 
--          FUND_CODE ,
--          IFIC_CODE ,
--          SOURCE
--        )
--SELECT 
--		a.FUND_CODE
--		, a.IFIC_CODE
--		,'IFIC MFOF'
--FROM 
--(SELECT mnt.FUND_CODE, mnt.IFIC_CODE FROM #MapNoTIN mnt
--LEFT JOIN dbo.FundCodeMap fcm ON mnt.FUND_CODE = fcm.FUND_CODE AND mnt.IFIC_CODE = fcm.IFIC_CODE
--WHERE mnt.FUND_CODE NOT IN (7508,7509,18150)
--AND fcm.FundId IS NULL) a 
--LEFT JOIN dbo.FundCodeMap fcm2 ON a.FUND_CODE = fcm2.FUND_CODE
--WHERE fcm2.FundId IS NULL 

--SELECT mnt.FUND_CODE, mnt.IFIC_CODE FROM #MapNoTIN mnt
--LEFT JOIN dbo.FundCodeMap fcm ON mnt.FUND_CODE = fcm.FUND_CODE AND mnt.IFIC_CODE = fcm.IFIC_CODE
--WHERE mnt.FUND_CODE NOT IN (7508,7509,18150)
--AND fcm.FundId IS NULL