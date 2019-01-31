# Modules
import os
import csv


# Set path for input file read
csvpath = os.path.join("..", "Resources", "budget_data.csv")


# Specify the file to write to
outfile = '../Resources/PyBankoutput.txt'

# Iniitialize variables
totalmonths = 0
totalamt = 0

# open the csv file
with open(csvpath, newline="") as csvfile:
	csvreader = csv.reader(csvfile, delimiter=",")
	linecount = 0

# Read the header row first
	csv_header = next(csvfile)	

	currentamt = 0
	lastamtchange = 0
	curramtchange = 0
	maxincreasemonth = ''
	maxincreaseamt = 0
	maxdecreasemonth = ''
	maxdecreaseamt = 0  
	lastamt = 0 
	changeinbalance = [] 

# Loop through the file and  determine total amt , max increase , decrease .
	for row in csvreader:
		currentamt = int(row[1])
		totalmonths = totalmonths + 1
		totalamt = totalamt + currentamt
		curramtchange = currentamt - lastamt
		if linecount == 0:
				#store first row amt
				firstrowamt = currentamt
		else:
			changeinbalance.append(curramtchange)
			if curramtchange > maxincreaseamt:
					maxincreaseamt = curramtchange 
					maxincreasemonth = (row[0])
				
			if curramtchange < maxdecreaseamt:
					maxdecreaseamt = curramtchange
					maxdecreasemonth = (row[0])
			
		lastamt = currentamt
		linecount += 1

	#store the last row amt
	lastrowamt = currentamt
	

	#calculate average change
	#averagechange = round((lastrowamt - firstrowamt ) / (totalmonths - 1),2)
	averagechange = round( sum(changeinbalance)/len(changeinbalance),2) 

	#print the values to terminal
	print("lendgth of list" + str( len(changeinbalance)))
	print("sum of list" + str( sum(changeinbalance)))
	print("Total Months: " + str(totalmonths))
	print("Total: " +"$"+ str(totalamt))
	print("Average Change: " +"$"+ str(averagechange))
	print("Greatest Increase in Profits: "+ str(maxincreasemonth) + " ($" + str(maxincreaseamt) + ")")
	print("Greatest Decrease in Profits: "+ str(maxdecreasemonth) + " ($" + str(maxdecreaseamt) + ")")
	


	# Open the file using "write" mode. Specify the variable to hold the contents
with open(outfile, 'w') as file:
	file.write("Total Months: "  + str(totalmonths) + "\n")
	file.write("Total: "  +"$"+ str(totalamt) + "\n")
	file.write("Average Change: " +"$"+ str(averagechange) + "\n")
	file.write("Greatest Increase in Profits: "+ str(maxincreasemonth) + " ($" + str(maxincreaseamt) + ")\n")
	file.write("Greatest Decrease in Profits: "+ str(maxdecreasemonth) + " ($" + str(maxdecreaseamt) + ")\n")
		


