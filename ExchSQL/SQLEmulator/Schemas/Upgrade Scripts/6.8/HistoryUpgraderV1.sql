--/////////////////////////////////////////////////////////////////////////////
--// Filename         : HistoryUpgraderV1.sql
--// Author           : Simon Molloy / Chris Sandow
--// Date             : 30 August 2011
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description      : SQL Script to add computer columns to the History table
--//                    for the 6.8 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//  1 30 August 2011: File Creation - Simon Molloy / Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

-- Trial Balance (Simplified) Report
-- Add fields and index
--
-- Date: 6 July 2011
---------------------------------------

--
-- Add computed columns
---------------------------------
-- If the index does not exist, assume that the table has not been upgraded yet,
-- and add the computed columns.
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'HISTORY_IndexCandidate_NominalCodes')
BEGIN
  alter TABLE [!ActiveSchema!].[HISTORY]
  add 
    [hiCodeComputed_NominalCode] as 
    case 
      when ((hiExClass >= 65 and hiExClass <= 67) or hiExClass= 72) then 
        case cast(substring(hiCode,2,6) as varchar(6))        
          -- Committed                
          when 'CMT'+CHAR(2)+CHAR(2)+'!' then 
            case cast(substring(hiCode,12,1) as varchar(1))
              when ' ' then
                (CONVERT([int],CONVERT([varbinary](max),reverse(substring(CONVERT([varbinary](max),[hiCode],(0)),(8),(4))),(0)),(0)))
              else          
                case cast(substring(hiCode,16,1) as varchar(1))
                  when char(2) then
                    case cast(SUBSTRING(hiCode,8,1) as varchar(1))
                      when 'C' then (CONVERT([int],CONVERT([varbinary](max),reverse(substring(CONVERT([varbinary](max),[hiCode],(0)),(9),(4))),(0)),(0)))
                    end
                  when char(1) then
                    case cast(SUBSTRING(hiCode,8,1) as varchar(1))              
                      when 'D' then (CONVERT([int],CONVERT([varbinary](max),reverse(substring(CONVERT([varbinary](max),[hiCode],(0)),(9),(4))),(0)),(0)))
                    end           
                  else
                    (CONVERT([int],CONVERT([varbinary](max),reverse(substring(CONVERT([varbinary](max),[hiCode],(0)),(9),(4))),(0)),(0)))               
                end
            end
          else        
            case cast(substring(hiCode, 6, 1) as varchar(1))
              when ' ' then
                (CONVERT([int],CONVERT([varbinary](max),reverse(substring(CONVERT([varbinary](max),[hiCode],(0)),(2),(4))),(0)),(0)))           
              else
                case cast(substring(hiCode,10,1) as varchar(1))
                  when char(2) then
                    case cast(SUBSTRING(hiCode,2,1) as varchar(1))
                      when 'C' then (CONVERT([int],CONVERT([varbinary](max),reverse(substring(CONVERT([varbinary](max),[hiCode],(0)),(3),(4))),(0)),(0)))
                    end
                  when char(1) then
                    case cast(SUBSTRING(hiCode,2,1) as varchar(1))
                      when 'D' then (CONVERT([int],CONVERT([varbinary](max),reverse(substring(CONVERT([varbinary](max),[hiCode],(0)),(3),(4))),(0)),(0)))
                    end
                  else
                    (CONVERT([int],CONVERT([varbinary](max),reverse(substring(CONVERT([varbinary](max),[hiCode],(0)),(3),(4))),(0)),(0)))
                end
            end
        end
    end persisted,
    
    [hiCodeComputed_IsCommitted] as
    cast(
      (case 
        when ((hiExClass >= 65 and hiExClass <= 67) or hiExClass= 72) then 
          case cast(substring(hiCode,2,6) as varchar(6))
            when 'CMT'+CHAR(2)+CHAR(2)+'!' then 1
            else 0
          end
      end)
    as bit) persisted,
    
    [hiCodeComputed_CostCentre] as 
    cast(
    (
    case 
      when ((hiExClass >= 65 and hiExClass <= 67) or hiExClass= 72) then 
        case cast(substring(hiCode,2,6) as varchar(6))        
          -- Committed                
          when 'CMT'+CHAR(2)+CHAR(2)+'!' then           
            case cast(substring(hiCode,12,1) as varchar(1))
              when ' ' then ''
              else
                case cast(substring(hiCode,8,1) as varchar(1))
                  when 'C' then
                    case 
                      when
                      (
                        (cast(substring(hiCode,16,1) as varchar(1)) = ' ') 
                        or (cast(substring(hiCode,16,1) as varchar(1)) = char(1))
                        or (cast(substring(hiCode,16,1) as varchar(1)) = char(2))
                      ) 
                      then
                        cast(substring(hiCode, 13, 3) as varchar(3))
                      else
                        ''
                    end
                  when 'D' then               
                    -- Only want where only a department
                    case cast(substring(hiCode,16,1) as varchar(1))
                      when ' ' then ''
                      else null             
                    end                 
                end
            end
          else        
            case cast(substring(hiCode,6,1) as varchar(1))
              when ' ' then ''
              else
                case cast(substring(hiCode,2,1) as varchar(1))
                  when 'C' then
                    case 
                      when
                      (
                        (cast(substring(hiCode,10,1) as varchar(1)) = ' ') 
                        or (cast(substring(hiCode,10,1) as varchar(1)) = char(1))
                        or (cast(substring(hiCode,10,1) as varchar(1)) = char(2))
                      ) 
                      then
                        cast(substring(hiCode, 7, 3) as varchar(3))
                      else
                        ''
                    end
                  when 'D' then               
                    -- Only want where only a department
                    case cast(substring(hiCode,10,1) as varchar(1))
                      when ' ' then ''
                      else null             
                    end                 
                end
            end
  
        end
    end) as varchar(3)) persisted,
    
    [hiCodeComputed_Department] as 
    case 
      when ((hiExClass >= 65 and hiExClass <= 67) or hiExClass= 72) then 
        case cast(substring(hiCode,2,6) as varchar(6))
          when 'CMT'+CHAR(2)+CHAR(2)+'!' then
            case cast(substring(hiCode, 14, 2) as varchar(2))
              when '  ' then ''
              else
                case cast(substring(hiCode,8,1) as varchar(1))
                  when 'C' then cast(substring(hiCode,17,3) as varchar(3))
                  when 'D' then 
                    -- As above
                    case cast(substring(hiCode,17,3) as varchar(3))
                      when '   ' then cast(substring(hiCode,13,3) as varchar(3))
                      else null             
                    end
                  else ''
                end 
            end
          else
            case cast(substring(hiCode, 7, 3) as varchar(3))
              when '   ' then ''
              else
                case cast(substring(hiCode,2,1) as varchar(1))
                  when 'C' then cast(substring(hiCode,11,3) as varchar(3))
                  when 'D' then 
                    -- As above
                    case cast(substring(hiCode,11,3) as varchar(3))
                      when '   ' then cast(substring(hiCode,7,3) as varchar(3))
                      else null
                    end 
                  else ''
                end     
            end
        end
    end persisted
END    
GO

-- If the index doesn't exist, create it
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[HISTORY]') AND name = N'HISTORY_IndexCandidate_NominalCodes')
BEGIN
  -- Add index
  CREATE NONCLUSTERED INDEX [HISTORY_IndexCandidate_NominalCodes] ON [!ActiveSchema!].[HISTORY] 
  (
    [hiCodeComputed_NominalCode] ASC,
    [hiCodeComputed_CostCentre] ASC,
    [hiCodeComputed_Department] ASC,
    [hiCodeComputed_IsCommitted] ASC,
    [hiExCLass] ASC,
    [hiCurrency] ASC,
    [hiYear] ASC,
    [hiPeriod] ASC
  )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
END
GO

