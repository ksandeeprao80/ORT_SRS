ALTER TABLE TR_TrendCrossTabs ADD IsCalculated INT DEFAULT 0 
GO
UPDATE TR_TrendCrossTabs SET IsCalculated = 0