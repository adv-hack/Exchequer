-- Quantity Discounts
SELECT RecMfix
      ,SubType
      ,Stock.stCode
      ,FQB
      ,TQB
      ,QBType
      ,QBCurr
      ,QSPrice
      ,QBand
      ,QDiscP
      ,QDiscA
      ,QMUMG
      ,QStkFolio
      ,QCCode
      ,QUseDates
      ,QStartD
      ,QEndD
FROM ZZZZ01.EXSTKCHK
INNER JOIN ZZZZ01.Stock ON QStkFolio = ZZZZ01.Stock.stFolioNum
WHERE RecMfix = 'D' AND SubType = 'C'