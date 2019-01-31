# Modules
import os
import csv



# Set path for input file read
csvpath = os.path.join("..", "Resources", "election_data.csv")


# Specify the file to write to
outfile = '../Resources/PyPolloutput.txt'

# set the variables to store total votes, candidates list , votes for each candidates, and percentages
totalvotes = 0
candidates = []
votesforcandidate = []
votespercent =[]
totalcandidatevotes = []

# open the csv file and 
with open(csvpath, newline="") as csvfile:
	csvreader = csv.reader(csvfile, delimiter=",")
	
	# Read the header row first
	csv_header = next(csvfile)
	

    
	# Loop through the file and count the total votes, build the candidates list , votes for each candidate 
	for row in csvreader:
		totalvotes += 1
		if row[2] in candidates:
			a = candidates.index(row[2])
			votesforcandidate[a] += 1
		else:
			candidates.append(row[2])
			votesforcandidate.append(1)
				
	# Loop thru the candidates to calculate the votes percentage and store in a list	
	i = 0
	for i in range(len(candidates)):
		votespercentage = (votesforcandidate[i]/ totalvotes ) * 100
		votespercent.append(round(votespercentage,3))
	
	#determine which candidate got the maximum votes percentage
	maxvotesindex = votespercent.index(max(votespercent))
	winner = candidates[maxvotesindex]

	#zip all the lists to build  candidate details record
	totalcandidatevotes = zip(candidates,votespercent,votesforcandidate)

	#print the details
	print("Election Results                                ")
	print("------------------------------------------------")
	print("Total Votes: " + str(totalvotes))
	print("------------------------------------------------")
	for values in totalcandidatevotes:
		pollcandidates = {"name": values[0] ,  "voteperc": values[1] ,"votesrecv": values[2]}
		print(values[0] + " :  " + str(values[1]) + "%" + " (" + str(values[2]) + ")")

	print("------------------------------------------------")
	print("winner: " + winner)
	print("------------------------------------------------")



	# Open the file using "write" mode. Specify the variable to hold the contents
with open(outfile, 'w') as file:
	
	file.write("Election Results                                "+ "\n")
	file.write("------------------------------------------------"+ "\n")
	file.write("Total Votes: " + str(totalvotes)+ "\n")
	file.write("------------------------------------------------"+ "\n")
	j = 0
	#for j in range(len(candidates)):
	#	file.write(candidates[j] + " : " + str(votespercent[j]) + "%" + " (" + str(votesforcandidate[j]) + ")"+ "\n")

	for value in totalcandidatevotes:
		file.write(value[0] + " : " + str(value[1]) + "%" + " (" + str(value[2]) + ")"+ "\n")

	#for pollcandidate in pollcandidates:
	#	file.write(pollcandidate['name'] + " " +  str(pollcandidate['voteperc']) + "%" + " (" + str(pollcandidate['votesrecv']) + ")"+ "\n")
	
	file.write("------------------------------------------------"+ "\n")
	file.write("winner: " + winner + "\n")
	file.write("------------------------------------------------"+ "\n")
	

