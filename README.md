# 🧍‍♀️ Pedestrian Traffic Analysis During COVID-19 in Auckland

This project investigates how pedestrian activity in Auckland's Central Business District (CBD) changed during the COVID-19 pandemic. Using time series methods in **R**, we examine patterns in foot traffic, highlight volume and variability changes, and compare behaviors across different COVID-19 alert levels.

---

## 📌 Summary

In the face of widespread remote work and public health restrictions, local business owners were concerned about decreased foot traffic in Auckland's CBD. This project validates their concerns using hourly pedestrian count data from 2017–2021.

Our findings show that average foot traffic dropped significantly during the pandemic, while daily and weekly patterns flattened and became more variable. This analysis provides insights to help businesses and city planners adapt to post-COVID realities.

---

## 🗂 Project Structure

| Folder           | Contents                                                                 |
|------------------|--------------------------------------------------------------------------|
| `Dataset/`       | Raw and preprocessed data, including pedestrian counts and alert levels |
| `Document/`      | Reports and presentation slides                                     |
| `SRC/`           | R source codes used for data processing and analysis                      |
| `Visualize/`     | Graphs and visual outputs from the analysis                              |

---

## 🧪 Tools and Methods

- **R / RStudio**
- **Time Series Decomposition**
- **Data Wrangling**
- **Trend, Seasonality, Residual Analysis**
- **Visualization (ggplot2 / base R)**

---

## 🔍 Key Findings

- 📉 Pedestrian traffic volume dropped notably during the pandemic.
- 🔁 Variance increased; weekday/weekend patterns diminished.
- 🗓️ Monthly seasonality remained present before and during the pandemic.
- ⚠️ Alert Level 1 showed behavior most similar to pre-pandemic patterns.

---

## 📁 File Structure in Details

### Dataset/
- `Pedestrian data 2017_to_2021.csv`: Cleaned pedestrian counts  
- `Pedestrian data 2017_to_2021_with_missing_values.csv`: Original data with NA values  
- `covid_alert_levels.csv`: COVID-19 alert levels in Auckland  

### Document/
- `report.pdf`: Final project report  
- `Presentation.pptx`: Summary presentation  

### SRC/
- `main.R`: Main script for running the analysis  
- `utils.R`: Supporting functions used in analysis  

### Visualize/
Contains 10+ output visualizations such as:
- `overall_decomp.jpg` – Time series decomposition  
- `daily_pattern_1.jpg` – Daily traffic patterns under Alert Level 1  
- `volume_vaiation_over_time.jpg` – Change in foot traffic over years  

---

## 👩 Author

**Thanuri Eranthi**  
📧 Contact available on request

---

