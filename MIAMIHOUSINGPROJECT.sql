
CREATE OR REPLACE MODEL `alien-proton-416015.MiamiData.predOceanDistance`

OPTIONS
  (model_type='linear_reg',
  input_label_cols=['SALE_PRC']) AS
SELECT structure_quality, SALE_PRC FROM `alien-proton-416015.MiamiData.HousingData`
WHERE Mod(AGE,2) = 0;

SELECT SALE_PRC FROM `alien-proton-416015.MiamiData.HousingData`
--Making Table with avg house price each month"
DECLARE CURR_AVG FLOAT64;
DECLARE Counter INT64;
SET Counter=1;

SELECT LND_SQFOOT,SALE_PRC FROM `alien-proton-416015.MiamiData.HousingData`;

SELECT LONGITUDE,LATITUDE FROM `alien-proton-416015.MiamiData.HousingData`;

SELECT 
CONCAT(LATITUDE,', ',LONGITUDE) AS COORDINATES, SALE_PRC FROM `alien-proton-416015.MiamiData.HousingData`;

WHILE (Counter <= 12) DO
    SET CURR_AVG = (SELECT AVG(SALE_PRC) FROM `alien-proton-416015.MiamiData.HousingData` WHERE month_sold = Counter);
    INSERT INTO `alien-proton-416015.MiamiData.MONTHLY_AVGS` (`CURR_MONTHLY_AVG`,`MONTH`) VALUES (CURR_AVG,Counter);
    SET Counter  = Counter  + 1;
END WHILE;

CREATE OR REPLACE TABLE `alien-proton-416015.MiamiData.MONTHLY_AVGS` (
  `MONTH` INT64,
  `CURR_MONTHLY_AVG` FLOAT64,
  `FIRST_NAME` STRING,
  `LAST_NAME` STRING);
--------------------------------------------------------------

SELECT `MONTH`,`CURR_MONTHLY_AVG` from `alien-proton-416015.MiamiData.MONTHLY_AVGS`ORDER BY `MONTH` ASC;
--WATERFRONT PROPERTIES----
SELECT 'OCEAN_DIST' FROM `alien-proton-416015.MiamiData.HousingData` WHERE OCEAN_DIST < 5000;


SELECT * ML.PREDICT(MODEL `MiamiData.predOceanDistance`,
    (
    SELECT * FROM 'alien-proton-416015.MiamiData.HousingData'
    WHERE Mod(AGE,2) = 1)
);