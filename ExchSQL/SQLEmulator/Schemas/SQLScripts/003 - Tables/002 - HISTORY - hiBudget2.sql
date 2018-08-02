-- Add new calculated column for hiBudget2 for backward compatibility for Exchequer Analytics and Exchequer LIVE
IF NOT EXISTS (SELECT TOP 1 1
               FROM   sys.columns
               WHERE  OBJECT_SCHEMA_NAME(object_id) = '!ActiveSchema!'
               AND    OBJECT_NAME(object_id)        = 'HISTORY'
               AND    name = 'hiBudget2')
BEGIN
  ALTER TABLE !ActiveSchema!.HISTORY
        ADD hiBudget2 AS hiRevisedBudget1
END  
GO