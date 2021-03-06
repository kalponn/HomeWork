Attribute VB_Name = "Module1"
Sub Multiple_year_stock_data()


' housekeeping declare the variables
Dim i As Long
Dim lastrow As Long
Dim laststock As String
Dim currentstock As String
Dim totalstockvolume As Double
Dim j As Integer
Dim current As Worksheet
Dim currentstockopen As Double
Dim currentstockclose As Double



'loop thru each worksheet  and process all the records within that sheet.

For Each current In Worksheets

    ' counts the number of rows in the current worksheet
        lastrow = current.Cells(Rows.Count, 1).End(xlUp).Row + 1
    
    'set the variables and get the first row data
        
        current.Cells(1, 10) = "Ticker Sym"
        current.Cells(1, 11) = "Total Stock Volume"
        current.Cells(1, 12) = "Yearly Change"
        current.Cells(1, 13) = "Percent Change"
        j = 1
        laststock = current.Cells(2, 1).Value
        currentstockopen = current.Cells(2, 3).Value
        totalstockvolume = 0
  
    
    
    ' loop thru the rows in the current worksheet and calculate the total stock volume for each ticker
    
        For i = 2 To lastrow
            
            ' set the current stock variable
            currentstock = current.Cells(i, 1).Value
           
            ' compare this to the last saved stock . if it matches , then add the total volume , else print the last stock details and set the current one to last stock
            If currentstock = laststock Then
                totalstockvolume = totalstockvolume + current.Cells(i, 7)
            Else
                currentstockclose = current.Cells(i - 1, 6)
                'calculate the change in stock value
                    changeinstock = currentstockclose - currentstockopen
                ' this counter is to manage the display
                    j = j + 1
                'display the stocker ticker , total stockvolume, change in stock, percent change
                    current.Cells(j, 10) = laststock
                    current.Cells(j, 11) = totalstockvolume
                    current.Cells(j, 12) = changeinstock
                
                'set the color to red if change in stock is < 0 and green if its > 0
                    If changeinstock < 0 Then
                       current.Cells(j, 12).Interior.Color = vbRed
                    Else
                       current.Cells(j, 12).Interior.Color = vbGreen
                    End If
                
                ' check for division by 0 and then calculate the percent change
                    If currentstockopen = 0 Then
                        current.Cells(j, 13) = 0
                    Else
                        current.Cells(j, 13) = changeinstock / currentstockopen
                    End If
                'format the percent fields
                    current.Cells(j, 13).Style = "Percent"
                    current.Cells(j, 13).NumberFormat = "0.00%"
                
                'reset the last stock ticker and total volume and stock open
                laststock = currentstock
                totalstockvolume = current.Cells(i, 7)
                currentstockopen = current.Cells(i, 3).Value
           
           End If
        Next i
    
        ' the below logic is to loop thru the output rows for calculating the max and least percentage change and greatest total volume
        lRow = current.Cells(Rows.Count, 10).End(xlUp).Row + 1
        
        maxperchange = 0
        maxamtchange = 0
        leastperchange = 0
  
        For y = 2 To lRow
            If current.Range("M" & y).Value > maxperchange Then
                maxperchange = current.Range("M" & y).Value
                maxperticker = current.Range("J" & y).Value
            End If
         
            If current.Range("K" & y).Value > maxamtchange Then
                maxamtchange = current.Range("K" & y).Value
                maxamtticker = current.Range("J" & y).Value
            End If
         
            If current.Range("M" & y).Value < leastperchange Then
                leastperchange = current.Range("M" & y).Value
                leastperticker = current.Range("J" & y).Value
            End If
        Next y
    
    
        'print the max percentage change , least percentage change , max total volume details
           current.Range("Q2").Value = "Ticker"
           current.Range("R2").Value = "Value"
           
           current.Range("P4").Value = "Greatest % increase"
           current.Range("Q4").Value = maxperticker
           current.Range("R4").Value = maxperchange
           current.Range("R4").Style = "Percent"
           current.Range("R4").NumberFormat = "0.00%"
           
           current.Range("P5").Value = "Greatest % decrease"
           current.Range("Q5").Value = leastperticker
           current.Range("R5").Value = leastperchange
           current.Range("R5").Style = "Percent"
           current.Range("R5").NumberFormat = "0.00%"
           
           current.Range("P6").Value = "Greatest Total Volume"
           current.Range("Q6").Value = maxamtticker
           current.Range("R6").Value = maxamtchange
   

Next


End Sub
