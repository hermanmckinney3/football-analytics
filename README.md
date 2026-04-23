College Football Data Analysis

## Overview
This project focuses on collecting, analyzing, and visualizing college football data using multiple tools.

## Components
- API Data Pull (Python)
- SQL Queries for data exploration
- Power BI Dashboard for visualization
- Statistical analysis (correlation, ANOVA)

## Tools
Python, pandas, SQL, Power BI

## Data
Data was pulled using the CFBD API and stored in a PostgreSQL database.  
Due to size, the dataset is not included in this repository.

## Power BI Dashboard
Analyzes performance trends for North Carolina Football teams (Wake Forest, NC State, North Carolina, Duke) in 2025.

Key metrics include:
- Points per game
- Average total yards
- Turnovers per game

![Dashboard Preview](dashboard_preview.png)


## Points vs First Downs Analysis
This analysis explores the relationship between points scored and total first downs at the game level for North Carolina FBS teams (Wake Forest, NC State, North Carolina, Duke).
![Points vs First Downs](points_vs_firstdowns.png)

### Key Finding
A moderate positive correlation (r = 0.61) was observed between first downs and points scored, suggesting that teams that sustain drives more effectively tend to generate higher scoring outputs.

### Tools
Python, pandas, Plotly
