# Supply Chain Analysis Project

## Overview
This project involves analyzing a supply chain dataset using Python for data preprocessing, exploratory data analysis (EDA), and machine learning, followed by SQL scripting for database operations. The goal is to understand the dataset, clean and visualize the data, build predictive models, and manage data using SQL.

## Dataset
### Source
The dataset used in this project is from the DataCo SMART SUPPLY CHAIN FOR BIG DATA ANALYSIS, which was published on 13 March 2019 by contributors Fabian Constante, Fernando Silva, and António Pereira. The dataset is structured and allows the use of machine learning algorithms and R software for analysis.

## Project Structure
- **Jupyter Notebook**: Contains the Python code for data analysis and machine learning.
- **SQL Script**: Contains SQL commands for creating and populating database tables.
- **Dataset**: The original dataset used for the project.

## Files
- `Supply_Chain_project (2).ipynb`: Jupyter Notebook with data analysis and machine learning code.
- `Supply_Chain_project.sql`: SQL script for database operations.
- `DataCoSupplyChainDataset.csv`: Original dataset.

## Steps Involved
1. **Data Loading and Preprocessing**
    - Import necessary libraries.
    - Load the dataset from a CSV file.
    - Check for missing values and handle them.
    - Convert date columns to datetime format.

2. **Exploratory Data Analysis (EDA)**
    - Generate summary statistics.
    - Visualize distributions of key variables.
    - Examine relationships between variables through scatter plots and count plots.

3. **Feature Engineering**
    - Create new columns based on existing data.

4. **Machine Learning**
    - Split data into training and test sets.
    - Train models (Decision Tree, Linear Regression, Logistic Regression).
    - Evaluate model performance using accuracy and mean squared error.

5. **Data Export**
    - Split the dataset into multiple CSV files for different tables (customers, orders, sales, products).

6. **SQL Scripting**
    - Create tables and insert data into a MySQL database from the CSV files.

## Usage
1. **Data Analysis and Machine Learning**:
    - Open `Supply_Chain_project (2).ipynb` in Jupyter Notebook.
    - Run the cells sequentially to perform data loading, preprocessing, EDA, feature engineering, and machine learning.
    - Export the cleaned and processed data into separate CSV files.

2. **SQL Database Operations**:
    - Use the `Supply_Chain_project.sql` script to create and populate tables in a MySQL database.
    - Ensure that the database connection details in the script match your MySQL server configuration.

## Requirements
- Python 3.x
- Libraries: pandas, numpy, matplotlib, seaborn, sklearn, sqlalchemy
- MySQL server

## Conclusion
This project demonstrates a comprehensive workflow for supply chain data analysis, from data preprocessing and visualization to machine learning and database management. The provided scripts and notebooks can be adapted for similar datasets and analytical tasks.

## Author
- Ali Soltanshai

## License
This project is licensed under the MIT License - see the LICENSE file for details.
