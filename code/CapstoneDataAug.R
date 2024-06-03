# Load stringr library (so that you can split the column)
library(stringr)

# Check your current working directory
getwd()

# Set your working directory
# NEED TO CHANGE FOR YOUR MACHINE
setwd("/Users/oliviabraun/capstone csv")
getwd()

response_data <- read.csv("client_daily_reponse_details_clients.csv", header = TRUE, sep = ",")
student_data_1 <- read.csv("Student_data_May2024_AEs.csv", header = TRUE, sep = ",")
student_data_2 <- read.csv("Student_data_May2024.csv", header = TRUE, sep = ",")

View(response_data)
View(student_data_1)
View(student_data_2)

# Remove rows in student_data_1 where 'enrollment_facility' is either NA or an empty string
student_data_1_clean <- subset(student_data_1, !is.na(enrollment_facility) & trimws(enrollment_facility) != "")

# Remove rows in student_data_2 where 'enrollment_facility' is either NA or an empty string
student_data_2_clean <- subset(student_data_2, !is.na(enrollment_facility) & trimws(enrollment_facility) != "")

# View the modified data frames
View(student_data_1_clean)
View(student_data_2_clean)

# Make a list of all unique enrollment facilities for data 1
data_1_fac <- unique(student_data_1_clean$enrollment_facility)
# Check enrollment facilities
# print(data_1_fac)

# Make a list of all unique enrollment facilities for data 2
data_2_fac <- unique(student_data_2_clean$enrollment_facility)
# Check enrollment facilities
# print(data_2_fac)

# Make a list of all the enrollment facilities for all data
all_fac = unique(c(unique_facilities, data_2_fac))
# Check enrollment facilities
# print(all_fac)

# Make facilities into a data frame
facilities <- data.frame(enrollment_facilities = all_fac)
# Write the names of the facilities to a CSV
write.csv(facilities, "facilities.csv", row.names=FALSE)

# Add the lat and long for the facilities via the internet
# I just googled the names of the facilities and added an associated lat and long
# in the second column of the excel doc associated with the CSV, next to the 
# facilities name then saved the document

# Pulling the data from the updated CSV
fac_data <- read.csv("facilities.csv", header = TRUE, sep = ",")
# Check new data
View(fac_data)

if ("lat_long" %in% colnames(fac_data)) {
  # Remove spaces and anything not a comma or a number
  fac_data$lat_long <- gsub(" ", "", fac_data$lat_long)
  # print(fac_data$lat_long)
  fac_data$lat_long <- gsub("\xca", "", fac_data$lat_long)
  # print(fac_data$lat_long)
  # Split name column into latitude and longitude
  fac_data[c('lat', 'long')] <- str_split_fixed(fac_data$lat_long, ',', 2)
  # Make data frame with 
  lookup_table <- data.frame(
    enrollment_facility = fac_data$enrollment_facilities,
    lat_long = fac_data$lat_long,
    longitude = fac_data$long,
    latitude = fac_data$lat
  )
} else if ("iso" %in% colnames(fac_data)) {
  fac_data$iso <- gsub(" ", "", fac_data$iso)
  print(fac_data$iso)
  fac_data$lat_long <- gsub("\xca", "", fac_data$iso)
  #print(fac_data$iso)
  # Make data frame with 
  lookup_table <- data.frame(
    enrollment_facility = fac_data$enrollment_facilities,
    iso = fac_data$iso
  )
}

# Check new columns have been added correctly
# View(fac_data)

aug_data_1 <- merge(student_data_1_clean, lookup_table, by = "enrollment_facility", all.x = TRUE)
aug_data_2 <- merge(student_data_2_clean, lookup_table, by = "enrollment_facility", all.x = TRUE)

# View(aug_data_1)
# View(aug_data_2)

# Write to CSV files
write.csv(aug_data_1, "aug_data_1_kenya_iso.csv", row.names=FALSE)
write.csv(aug_data_2, "aug_data_2_kenya_iso.csv", row.names=FALSE)

