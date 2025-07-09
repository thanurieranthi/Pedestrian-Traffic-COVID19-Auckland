
get_data_in_time_range <- function(dataset, start_time, end_time, time) {
  filtered_data <- subset(dataset, time >= start_time & time <= end_time)
  return(filtered_data)
}

get_dataset_in_time_range <- function(dataset, start_time, end_time) {
  filtered_data <- subset(dataset, dataset$dateTime >= start_time & dataset$dateTime <= end_time)
  return(filtered_data)
}