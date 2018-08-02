Attribute VB_Name = "Encoder"
Option Explicit

Private Const sB64 As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

'// base64 decodes input string
'// only decoded non-printing characters are TAB, LF, CR
Public Function b64Decode(sSource As String) As String
    Dim sResult As String


    '// remove line breaks
    sSource = Replace(sSource, vbCrLf, "")
    
    Dim lTemp As Long
    Dim lLen As Long
    lTemp = InStr(sSource, "=") - 1
    If (lTemp > 0) Then
        lLen = lTemp
    Else
        lLen = Len(sSource)
    End If

    Dim lQuads As Long
    Dim lQuad As Long
    Dim lExtras As Long
    
    lQuads = (lLen) \ 4
    lExtras = (lLen) Mod 4
    

    '// iterate through source
    Dim i As Long
    For i = 0 To lQuads - 1 '    for (i = 0; i < iQuads; i ++)
  
        '// represent quad as 32bit number
        lQuad = 0

        lQuad = lQuad + mapB64ChrToVal(Mid$(sSource, i * 4 + 1, 1)) * 262144  '// 2^18
        lQuad = lQuad + mapB64ChrToVal(Mid$(sSource, i * 4 + 2, 1)) * 4096  '// 2^12
        lQuad = lQuad + mapB64ChrToVal(Mid$(sSource, i * 4 + 3, 1)) * 64    '// 2^6
        lQuad = lQuad + mapB64ChrToVal(Mid$(sSource, i * 4 + 4, 1))

        '// map to 3 ascii characters
        sResult = sResult & Chr((lQuad And 16711680) / 65536) '// (AND 2^16 * 255) / 2^16
        sResult = sResult & Chr((lQuad And 65280) / 256)      '// (AND 2^8 * 255) / 2^8
        sResult = sResult & Chr(lQuad And 255)            '// (AND 255)
    Next i

    lTemp = 0
    '// extra characters
    If (lExtras = 2) Then
        lTemp = mapB64ChrToVal(Mid$(sSource, lLen - 1, 1)) * 64
        lTemp = lTemp + mapB64ChrToVal(Mid$(sSource, lLen, 1))
        sResult = sResult & Chr((lTemp And 4080) / 16)
    
    ElseIf (lExtras = 3) Then
        
        lTemp = mapB64ChrToVal(Mid$(sSource, lLen - 2, 1)) * 4096
        lTemp = lTemp + mapB64ChrToVal(Mid$(sSource, lLen - 1, 1)) * 64
        lTemp = lTemp + mapB64ChrToVal(Mid$(sSource, lLen, 1))
        sResult = sResult & Chr((lTemp And 261120) / 1024)
        sResult = sResult & Chr((lTemp And 1020) / 4)
    End If
    
    b64Decode = sResult
    
End Function


'Returns base64 character from base64 code
Private Function mapValToB64Chr(iChr) As String
    
    Dim sChr As String
    
    sChr = Mid$(sB64, iChr + 1, 1)
    
    mapValToB64Chr = sChr

End Function

'// returns base64 code from base64 character
Private Function mapB64ChrToVal(sChr) As Long

    Dim iChr As Long
    
    iChr = InStr(sB64, sChr) - 1
    
    mapB64ChrToVal = iChr
End Function


Public Function b64Encode(sSource As String) As String
    Dim iSourceLength As Long
    Dim iTrips As Long
    Dim iExtras As Long
    Dim iLoop As Long
    Dim sResult As String
    Dim lTrip As Long
    
    iSourceLength = Len(sSource)
    iTrips = iSourceLength \ 3
    iExtras = iSourceLength Mod 3
    
    For iLoop = 0 To iTrips - 1
        lTrip = 0
    
       'Respresent number as 24bit Number
        lTrip = lTrip + Asc(Mid(sSource, iLoop * 3 + 1, 1)) * 65536 '2^16
        lTrip = lTrip + Asc(Mid(sSource, iLoop * 3 + 2, 1)) * 256 '2^8
        lTrip = lTrip + Asc(Mid(sSource, iLoop * 3 + 3, 1))
        
        'Map to 4 Base64 Characters
        sResult = sResult + mapValToB64Chr((lTrip And 16515072) / 262144) 'and (2^18 * 63)/2^18
        sResult = sResult + mapValToB64Chr((lTrip And 258048) / 4096) 'and (2^12 * 63)/2^12
        sResult = sResult + mapValToB64Chr((lTrip And 4032) / 64) 'and (2^6 * 63)/2^6
        sResult = sResult + mapValToB64Chr(lTrip And 63) 'and 63
    Next iLoop
    
   'Deal with Extra Characters
    Select Case iExtras
        Case 1
           sResult = sResult & mapValToB64Chr((Asc(Mid(sSource, iSourceLength, 1)) And 252) / 4)
           sResult = sResult & mapValToB64Chr((Asc(Mid(sSource, iSourceLength, 1)) And 3) * 16)
           sResult = sResult & "=="
        Case 2
           sResult = sResult & mapValToB64Chr((Asc(Mid(sSource, iSourceLength - 1, 1)) And 252) / 4)
           sResult = sResult & mapValToB64Chr(((Asc(Mid(sSource, iSourceLength - 1, 1)) And 3) * 16) + ((Asc(Mid(sSource, iSourceLength, 1)) And 240) / 16))
           sResult = sResult & mapValToB64Chr((Asc(Mid(sSource, iSourceLength, 1)) And 15) * 4)
           sResult = sResult & "="
           
    End Select

    b64Encode = sResult

End Function

