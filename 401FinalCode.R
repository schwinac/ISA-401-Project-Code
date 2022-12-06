if(require(pacman)==FALSE) install.packages('pacman')
pacman::p_load(tidyverse, readxl, dplyr, lubridate, readr)

VSRR1 = read_csv('VSRR.csv') # Read in df 1
colnames(VSRR1)[2] = 'year'

VSRR2 = read_csv('VSRR2.csv') # Read in df 2
colnames(VSRR1)[5] = 'County' 

df = right_join(x = VSRR1, y = VSRR2, by = c('County' = 'County')) # Merge df's

poverty = read_csv('Poverty.csv') # Read in df 3
df = right_join(x = df, y = poverty, by = c('County' = 'County')) # Merge df's

miles = read_csv('Miles.csv') # Readin df 4
colnames(miles)[1] = 'County'
miles$County = str_to_title(miles$County) # Fix capitalization of column name
df = left_join(x = df, y = miles, by = c('County' = 'County')) # Marge df's

df = subset(df, select = -c(`Data as of`)) # Remove column
df = subset(df, select = -c(State.y)) # Remove column
colnames(df)[3] = 'State'

df$Day = 1 # Create new column to combine 3 columns into a date column
df$Date<-as.Date(with(df,paste(year,Month,Day,sep="-")),"%Y-%m-%d") # Create date column
df = subset(df, select = -c(year,Month)) 
df = subset(df, select = -c(Day)) # Deleting year, month, and day columns 
df = df %>% 
  relocate(Date) # Make Date column the first one 

df$`CENTERLINE MILES` = as.double(df$`CENTERLINE MILES`) # Convert character value to dbl
glimpse(df) # See data types and check they are correct
class(df$`Sum of Deaths`) 
is.null(df) #Check to see if there are any null values

write.csv(df, file = "df.csv")

  
  
  
  
  