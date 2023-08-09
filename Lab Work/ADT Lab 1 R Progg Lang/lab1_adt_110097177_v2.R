
##### Advanced Database Topics - Lab 1 #####

##### PART 1: Data Exploration #####

##### Question 1: Import the Vehicle dataset, summarize it and explain the output (2 marks). #####
##### Solution of 1st Question: #####

#Data is imported in "vehicle_data" data.frame 
vehicle_data <- read.csv("C:/Users/rahul/Downloads/Vehicle.csv")

#Checking the type of dataset to work on further
dataset_type_check <- class(vehicle_data)
print(dataset_type_check)

#Summarizing the vehicle_data which mainly shows the Minimum Value, 1st Quantile, Median, Mean, 
#3rd Quantile, Maximum Value of numeric data columns and for string columns, it will return the count of values
summary(vehicle_data)

##### Question 2: Show the structure and dimension of the dataset and explain it (2 marks). #####
##### Solution of 2nd Question: #####

# str will display the structure and Summary of the Vehicle Dataset.
str(vehicle_data)

# dim will display the dimensions of the Vehicle Dataset i.e. it will return column count and rows count.
dim(vehicle_data)


##### Question 3: Show the column names of the Vehicle dataset and the first 3 rows and the last 6 rows of it (2 marks).  #####
##### Solution of 3rd Question: #####

# Method to display the column names of the Vehicle Dataset
colnames(vehicle_data)

# Displaying the first 3 rows of the Vehicle Dataset using head function
head(vehicle_data, n = 3)

# Displaying the last 6 rows of the Vehicle Dataset using tail function
tail(vehicle_data, n = 6)

##### Question 4: Show the average Kms_Driven for each type of car (Car_Name) in the dataset (1 mark). #####
##### Solution of 4th Question: #####


# Calculating the average number of kilometers for each car and storing in average_kms_driven
average_kms_per_car <- aggregate(vehicle_data$Kms_Driven, by = list(vehicle_data$Car_Name), FUN = mean)

# Naming the columns in the result
colnames(average_kms_per_car) <- c("Car_Name", "Average_Kilometers_Driven")

# Displaying the result
average_kms_per_car

##### Question 5: What is the average Selling_Price of the cars in each year? (1 mark). #####
##### Solution of 5th Question: #####

# Calculating the average Selling_Price for each year and saving in average_price_per_year dataframe
average_price_per_year <- aggregate(Selling_Price ~ Year, data = vehicle_data, FUN = mean)

# Displaying the result after calculation
average_price_per_year

##### Question 6 : Show the unique combinations of Car_Name, Fuel_Type, Seller_Type, and Transmission 
#(Contd.) in the Vehicle dataset. (2 marks)#####
##### Solution of 6th Question: #####

# Selecting the columns of interest
required_columns <- c("Car_Name", "Fuel_Type", "Seller_Type", "Transmission")

# Extracting the unique combinations
uniq_comb <- unique(vehicle_data[required_columns])

# Displaying the result
uniq_comb


##### Question 7 : What are the different combinations of Car_Name, Fuel_Type, Seller_Type, and Transmission in the Vehicle dataset, and how many times does it occur? (Display all such in both ascending and descending orders) (2 marks)#####
##### Solution of 7th Question: #####

# Creating a combination column
reqd_data$Combination <- paste(vehicle_data$Car_Name, vehicle_data$Fuel_Type, vehicle_data$Seller_Type, vehicle_data$Transmission, sep = ", ")

# Calculating the frequencies of combinations
comb_freq <- table(reqd_data$Combination)

# Sorting the combinations in ascending order of frequency
sorted_comb_asc <- sort(comb_freq)

# Sorting the combinations in descending order of frequency
sorted_comb_desc <- sort(comb_freq, decreasing = TRUE)

# Displaying the combinations and their frequencies in ascending order
sorted_comb_asc

# Displaying the combinations and their frequencies in descending order
sorted_comb_desc


##### PART 2: Data Pre-Processing#####

##### Question 8: Find if there are any missing values in the Vehicle dataset (1 mark). #####
##### Solution of 8th Question: #####
##### ANSWER 8 #####

# Checking for missing values in dataset
find_missing_values <- any(is.na(vehicle_data))

# Displaying the result for missing values in the dataset
find_missing_values

##### Question 9: Find which columns contain missing values in the vehicles dataset. What are the total missing values for each column? (3 marks) #####
##### Solution of 9th Question: #####
##### ANSWER 9 #####

# Checking for missing values in each column of the dataset
missing_columns <- colSums(is.na(vehicle_data))

# Displaying the columns with missing values and their total missing values for each column.
missing_columns

##### Question 10: Replace the missing values in the dataset with the most repeated value of that field. Check if the missing values were replaced successfully (4 marks).#####
##### Solution of 10th Question: #####

# Replace the missing values with mode (most frequent value) for each column. It is also called as Outlier detection and treatment.
replace_missing_val_with_mode <- function(x) {
  if (is.factor(x)) {
    levels <- unique(x)
    mode_level <- levels[which.max(tabulate(match(x, levels)))]
    x[is.na(x)] <- mode_level
  } else if (is.numeric(x)) {
    x[is.na(x)] <- median(x, na.rm = TRUE)
  }
  return(x)
}

#Filling data with most frequent value
data_filled <- as.data.frame(lapply(vehicle_data, replace_missing_val_with_mode))

# Checking if all the missing values were replaced in complete data frame
missing_val_replaced <- any(is.na(data_filled))

# Displaying the result after applying required functions
missing_val_replaced

##### Question 11: Find if the dataset has duplicate rows. Remove them, if exist (4 marks). #####
##### Solution of 11th Question: #####


# Check if duplicate rows exists in the dataset
any_duplicates <- any(duplicated(vehicle_data))

# Remove duplicate rows if they exist in the dataframe
if (any_duplicates) {
  data_unique <- unique(vehicle_data)
} else {
  data_unique <- vehicle_data
}

# Display the status after checking the dataset if it has duplicate rows
any_duplicates

##### Question 12: Replace the values of the following attributes:
##### a Fuel_Type: “Petrol”: 0, “Diesel”: 1, “CNG”: 2 ####
##### b Seller_Type: “Dealer”: 0, “Individual”: 1 #####
##### c Transmission: “Manual”: 0, “Automatic”: 1 #####
##### Show the conversion output of the specific attribute (6 marks). #####
##### Solution of  Question: #####

# Convert factor variables to character to avoid errors
vehicle_data$Fuel_Type <- as.character(vehicle_data$Fuel_Type)
vehicle_data$Seller_Type <- as.character(vehicle_data$Seller_Type)
vehicle_data$Transmission <- as.character(vehicle_data$Transmission)

# Check levels before value replacements before performing operations
levels_before <- levels(vehicle_data$Fuel_Type)
levels_before <- levels(vehicle_data$Seller_Type)
levels_before <- levels(vehicle_data$Transmission)

# Replacing Fuel_Type values as per problem statement
vehicle_data$Fuel_Type <- replace(vehicle_data$Fuel_Type, vehicle_data$Fuel_Type == "Petrol", 0)
vehicle_data$Fuel_Type <- replace(vehicle_data$Fuel_Type, vehicle_data$Fuel_Type == "Diesel", 1)
vehicle_data$Fuel_Type <- replace(vehicle_data$Fuel_Type, vehicle_data$Fuel_Type == "CNG", 2)

# Replacing Seller_Type values as per problem statement
vehicle_data$Seller_Type <- replace(vehicle_data$Seller_Type, vehicle_data$Seller_Type == "Dealer", 0)
vehicle_data$Seller_Type <- replace(vehicle_data$Seller_Type, vehicle_data$Seller_Type == "Individual", 1)

# Replacing Transmission values as per problem statement
vehicle_data$Transmission <- replace(vehicle_data$Transmission, vehicle_data$Transmission == "Manual", 0)
vehicle_data$Transmission <- replace(vehicle_data$Transmission, vehicle_data$Transmission == "Automatic", 1)

# Convert back to factor variables to stay consistent
vehicle_data$Fuel_Type <- as.factor(vehicle_data$Fuel_Type)
vehicle_data$Seller_Type <- as.factor(vehicle_data$Seller_Type)
vehicle_data$Transmission <- as.factor(vehicle_data$Transmission)

# Check levels after value replacements to stay consistent
levels_after <- levels(vehicle_data$Fuel_Type)
levels_after <- levels(vehicle_data$Seller_Type)
levels_after <- levels(vehicle_data$Transmission)

# Display the conversion output for attributes of("Fuel_Type", "Seller_Type", "Transmission")
conversed_output <- vehicle_data[, c("Fuel_Type", "Seller_Type", "Transmission")]

# Show the conversion output as
conversed_output

##### Question 13: Add a new field called ‘Age’, and input the values by using the field Year. Show the output (4 marks). #####
##### Solution of 13 Question: #####

# Saving current year in current_year variable as integer
current_year <- as.integer(format(Sys.Date(), "%Y"))

# Calculating 'Age' field based on 'Current Year' and Year Column of Dataset
vehicle_data$Age <- current_year - vehicle_data$Year

# Display the output with the new 'Age' field with "Car_Name", "Year", "Age" columns
reqd_output_with_age <- vehicle_data[, c("Car_Name", "Year", "Age")]
reqd_output_with_age

##### Question 14: Create a new dataset by selecting only the columns “Car_name”, “Selling_Price”, “Present_Price”, and “Kms_Drive”. Show the output of the new dataset (4 marks).#####
##### Solution of 14th Question: #####

# Creating a new dataset with the selected columns such as "Car_Name", "Selling_Price", "Present_Price", "Kms_Driven"
reqd_dataset <- vehicle_data[, c("Car_Name", "Selling_Price", "Present_Price", "Kms_Driven")]

# Displaying the output of the new dataset with the selected columns such as "Car_Name", "Selling_Price", "Present_Price", "Kms_Driven"
reqd_dataset

##### Question 15:  Shuffle the rows of the Vehicle dataset randomly and show the output (2 marks). #####
##### Solution of 15th  Question: #####

# Shuffling the rows randomly using nrow of sample function
my_shuffled_data <- vehicle_data[sample(nrow(vehicle_data)), ]

# Displaying the output of the shuffled dataset
my_shuffled_data


##### PART 3: Data Visualization #####

##### Question 16: Import the Vehicle dataset. Create a scatter plot of the Selling_Price Vs Present_Price. Colour code  the points based on the Transmission (5 marks).
##### a. Add labels, title and colour to the plot. The colour should be red for Transmission type ‘0’ and blue for ‘1’.
##### b. Add open triangles to the plot.
##### c. What do you understand from the output (5 marks)?  #####
##### Solution of 16th Question: #####

# Importing the dataset
vehicle_data <- read.csv("C:/Users/rahul/Downloads/Vehicle.csv")

# Import the ggplot2 library
library(ggplot2)

# Create scatter plot
my_scatter_plot <- ggplot(vehicle_data, aes(x = Present_Price, y = Selling_Price, color = factor(Transmission))) +
  geom_point(shape = 2, size = 3) +
  scale_color_manual(values = c('Automatic'= "red",'Manual'= "blue")) +
  labs(title = "Scatter Plot: Selling_Price vs Present_Price", x = "Present_Price", y = "Selling_Price")

# Show the scatter plot
print(my_scatter_plot)

##### Question 17: Create a box plot of the Selling_Price Vs Transmission and Fuel_Type (5 marks). #####
##### Solution of 17th Question: #####

# Converting Transmission and Fuel_Type to factors to avoid errors well in advance
vehicle_data$Transmission <- as.factor(vehicle_data$Transmission)
vehicle_data$Fuel_Type <- as.factor(vehicle_data$Fuel_Type)

# Creating box plot with suitable labels
my_box_plot <- ggplot(vehicle_data, aes(x = Transmission, y = Selling_Price, fill = Fuel_Type)) +
  geom_boxplot() +
  labs(title = "Box Plot: Selling_Price VS Transmission and Fuel_Type(Columns Considered)", x = "Transmission", y = "Selling_Price")


# Show the box plot
print(my_box_plot)

##### Question 18 :Create a scatter plot of the Selling_Price Vs Kms_Driven, and use k-means clustering to cluster the points into 4 clusters. Colour-code based on the cluster they belong to (10 marks).
##### Solution of 18th Question: #####

# Install stats package
#install.packages("stats")
library(stats)

# Select the columns of interest
reqd_data <- vehicle_data[, c("Selling_Price", "Kms_Driven")]

# Perform k-means clustering with 4 clusters
k <- 4
kmeans_clusters <- kmeans(reqd_data, centers = k)

# Add cluster labels to the dataset
vehicle_data$Cluster <- kmeans_clusters$cluster

# Create scatter plot with cluster coloring
my_scatter_plot_cluster <- ggplot(vehicle_data, aes(x = Selling_Price, y = Kms_Driven, color = as.factor(Cluster))) +
  geom_point() +
  labs(title = "Scatter Plot: Selling_Price vs Kms_Driven with K-means Clustering", x = "Selling_Price", y = "Kms_Driven")

# Show the scatter plot
print(my_scatter_plot_cluster)

##### Question 19: Create a scatter plot of the Selling_Price Vs Present_Price, and use hierarchical clustering to cluster  the points into 3 clusters? Colour-code the points based on the cluster they belong to (10 marks). #####
##### Solution of 19th Question: #####

# Performing Hierarchical clustering on Selling_Price Vs Present_Price
library(ggplot2)

# Choosing required columns as per problem statement("Selling_Price", "Present_Price")
reqd_data <- vehicle_data[, c("Selling_Price", "Present_Price")]

# Create Scatter plot
plot(reqd_data$Selling_Price, reqd_data$Present_Price, main = "Scatter Plot of Comparison Selling_Price and Present_Price", xlab = "Selling_Price", ylab = "Present_Price")


# Calculating the distance matrix 
dist_matrix <- dist(reqd_data[, c("Selling_Price", "Present_Price")])

# Performing the hierarchical clustering on distance matrix
hc <- hclust(dist_matrix, method = "ward.D2")

# Cutting into 3 clusters
clusters <- cutree(hc, k = 3)

# Defining Color codes to show for points based on clusters
colors <- c("cyan", "yellow", "green")

points(reqd_data$Selling_Price, reqd_data$Present_Price, pch = 16, col = colors[clusters])

# Adding cluster labels now
text(reqd_data$Selling_Price, reqd_data$Present_Price, labels = clusters, pos = 3)

# Adding a legend with appropriate legends, col and pch parameters
legend("topright", legend = c("Cluster 1", "Cluster 2", "Cluster 3"), col = colors, pch = 16)


##### Question 20: Add a new field called ‘Age’, and calculate it using the field ‘Year’. Create a barplot for the following fields of the dataset: (10 marks) #####
##### a. ‘Age’, ‘Year’, ‘Transmission’, ‘Seller_Type’, ‘Fuel_Type’ and ‘Owner’ #####
##### b. Add labels, titles, and colours to the plot #####
##### Solution of 20th Question: #####

# Calculating the Age field by computing difference with the current year
vehicle_data$Age <- as.integer(format(Sys.Date(), "%Y")) - vehicle_data$Year

# Creating the bar plot for the calculated column i.e. Age which is computed above
barplot(table(vehicle_data$Age),main = "Age Distribution of Vehicles with their frequency",xlab = "Age",ylab = "Frequency of Occurence",col = "pink")

# Add color legends to fill with pink
legend("topright",legend = c("Age"),fill = "pink")

# Create bar plot for Year vs the frequency of occurrence
barplot(table(vehicle_data$Year),main = "Year Distribution wrt Frequency of Vehicles",xlab = "Year",ylab = "Frequency",col = "yellow")

# Add color legend to fill with yellow
legend("topright",legend = c("Year"),fill = "yellow")

# Create bar plot for Transmission vs the frequency of occurrence
barplot(table(vehicle_data$Transmission),main = "Transmission Distribution wrt Frequency",xlab = "Transmission Type",ylab = "Frequency",col = "cyan")

# Add color legend(Transmission) to fill with cyan
legend("topright",legend = c("Transmission Type"),fill = "cyan")

# Create bar plot for Seller_Type vs the frequency of occurrence
barplot(table(vehicle_data$Seller_Type),main = "Seller Type Distribution wrt Frequency",xlab = "Seller_Type",ylab = "Frequency",col = "magenta")

# Add color legend(Seller_Type) to fill with magenta
legend("topright",legend = c("Seller_Type"),fill = "magenta")

# Create bar plot for Fuel_Type vs the frequency of occurrence
barplot(table(vehicle_data$Fuel_Type),main = "Fuel Type wrt Frequency",xlab = "Fuel_Type",ylab = "Frequency",col = "red")

# Add color legend(Fuel_Type) to fill with red
legend("topright",legend = c("Fuel_Type"),fill = "red")

# Create bar plot for Owner vs the frequency of occurrence
barplot(table(vehicle_data$Owner),main = "Owner Type and its Frequency of occurence",xlab = "Owner",ylab = "Frequency",col = "brown")

# Add color legend(Owner) to fill with brown
legend("topright",legend = c("Owner"),fill = "brown")

##### Question 21:  Create a correlation plot of the whole dataset variables and explain the output. Do not forget to convert some of the variable’s datatype if required and possible (10 marks). #####
##### Solution of 21th Question: #####

# Conversion of variables(Car_Name,Fuel_Type,Transmission,Seller_Type) to a factor with numerical values as these are string
vehicle_data$Car_Name <- as.numeric(factor(vehicle_data$Car_Name))
vehicle_data$Fuel_Type <- as.numeric(factor(vehicle_data$Fuel_Type))
vehicle_data$Transmission <- as.numeric(factor(vehicle_data$Transmission))
vehicle_data$Seller_Type <- as.numeric(factor(vehicle_data$Seller_Type))

# Computing correlation matrix using cor function on vehicle data after conversion of datatype of some columns
my_correlation_matrix <- cor(vehicle_data)

# Create correlation plot as color method
library(corrplot)
corrplot(my_correlation_matrix, method = "color", type = "full", tl.cex = 0.7)

# Create correlation plot as number method
corrplot(my_correlation_matrix, method = "number", type = "full", tl.cex = 0.7)


##### Question 22: Create a scatter plot of the Selling_Price Vs Kms_Driven, and use DBSCAN clustering to cluster  the points into 3 clusters. Color-code based on the cluster they belong to. Add a legend to the plot (5 marks) #####
##### Solution of 22th Question: #####

# Create a subset of the dataset with only the required columns
reqd_data <- vehicle_data[, c("Selling_Price", "Kms_Driven")]

#Installing and fetching required libraries like dbscan,ggplot2
#install.packages('dbscan')
library('dbscan')
library('ggplot2')

# Applying DBSCAN clustering with eps value of 10000 and MinPts of 3
dbscan_res <- dbscan(reqd_data, eps = 10000, MinPts = 3)

# Adding the cluster labels to the considered data
subset_dataset$Cluster <- dbscan_res$cluster

# Creating a scatter plot with 3 different colors and 3 labelled clusters
my_scatter_plot_DBSCAN <- ggplot(subset_dataset, aes(x = Selling_Price, y = Kms_Driven, color = factor(subset_dataset$Cluster))) +
  geom_point() +
  labs(title = "Scatter Plot of Selling_Price vs Kms_Driven with DBSCAN Clustering",
       x = "Selling_Price", y = "Kms_Driven") +
  scale_color_manual(values = c("yellow", "pink", "purple"), labels = c("Cluster 1", "Cluster 2", "Cluster 3")) +
  theme_bw()

# Display the scatter plot with the print function
print(my_scatter_plot_DBSCAN)