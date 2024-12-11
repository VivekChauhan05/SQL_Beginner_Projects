# Nashville Housing Data Cleaning 🏠

This project delves into cleaning and transforming the `NashvilleHousing` dataset to improve its structure, consistency, and usability for analytical purposes. By standardizing date formats, splitting address fields, eliminating duplicates, and refining categorical data, the dataset becomes a reliable resource for subsequent analysis and reporting.

---

## Table of Contents

1. [Overview](#overview)  
2. [Data Cleaning Steps](#data-cleaning-steps)  
    - [Standardizing Date Format](#standardizing-date-format)  
    - [Populating Missing Property Address Data](#populating-missing-property-address-data)  
    - [Breaking Out Address Components](#breaking-out-address-components)  
    - [Updating Categorical Data](#updating-categorical-data)  
    - [Removing Duplicates](#removing-duplicates)  
    - [Deleting Unused Columns](#deleting-unused-columns)  
3. [SQL Environment](#sql-environment)  
4. [Author](#author)  

---

## Overview ✨

The `NashvilleHousing` dataset required a comprehensive cleaning process to address several data inconsistencies, such as missing values, non-standard formats, and redundant records. By applying these transformations, the dataset becomes structured and optimized for use in data visualization tools, predictive models, and exploratory data analysis.

---

## Data Cleaning Steps

### Standardizing Date Format 📅

- **Objective:** Ensure that the `SaleDate` column adheres to a standard date format for consistency and better usability.  
- **Actions:**  
  1. Added a new column `SaleDateConverted` with the `Date` data type.  
  2. Updated this column with converted values from the original `SaleDate`.  
  3. Verified the format of `SaleDateConverted` to confirm accuracy.  

### Populating Missing Property Address Data 🏡

- **Objective:** Address rows with missing `PropertyAddress` values by leveraging other rows with the same `ParcelID`.  
- **Actions:**  
  1. Queried rows where `PropertyAddress` was `NULL` to identify missing values.  
  2. Joined rows with the same `ParcelID` but different `UniqueID` to retrieve non-missing values.  
  3. Updated the missing `PropertyAddress` fields with these retrieved values.  
  4. Ensured that no `NULL` values remained in the `PropertyAddress` column.  

### Breaking Out Address Components 🗂️

#### Property Address

- **Objective:** Parse the `PropertyAddress` column into separate fields for `Address` and `City` to enhance granularity.  
- **Actions:**  
  1. Extracted the `Address` and `City` components using `SUBSTRING` and `CHARINDEX`.  
  2. Added new columns `PropertySplitAddress` and `PropertySplitCity` to store the extracted data.  
  3. Populated these columns with parsed values.  
  4. Confirmed the accuracy of the split through validation queries.  

#### Owner Address

- **Objective:** Decompose the `OwnerAddress` field into `Address`, `City`, and `State` components for improved clarity.  
- **Actions:**  
  1. Applied the `PARSENAME` function to split the `OwnerAddress` field into its respective parts.  
  2. Added columns `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitState` to store the parsed data.  
  3. Updated these columns with the extracted components.  
  4. Validated the splits and ensured proper allocation of data across the new columns.  

### Updating Categorical Data ✅

- **Objective:** Improve the readability of the `SoldAsVacant` column by replacing cryptic codes with more descriptive labels.  
- **Actions:**  
  1. Identified rows where `SoldAsVacant` contained `Y` or `N`.  
  2. Used a `CASE` statement to convert `Y` to `Yes` and `N` to `No`.  
  3. Confirmed that all values were correctly updated.  
  4. Ensured no residual `Y` or `N` values remained in the column.  

### Removing Duplicates 🗑️

- **Objective:** Eliminate duplicate rows to ensure data integrity and accuracy.  
- **Actions:**  
  1. Created a Common Table Expression (CTE) to assign row numbers to potential duplicate entries.  
  2. Used key columns (`ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, and `LegalReference`) for duplicate identification.  
  3. Deleted rows where the assigned row number exceeded `1`.  
  4. Validated the dataset to confirm that no duplicates persisted.  

### Deleting Unused Columns ✂️

- **Objective:** Streamline the dataset by removing redundant columns no longer needed post-transformation.  
- **Actions:**  
  1. Dropped the following columns:  
     - `OwnerAddress`  
     - `TaxDistrict`  
     - `PropertyAddress`  
     - `SaleDate`  
  2. Verified that the dataset structure was optimized and consistent with the analysis goals.  

---

## SQL Environment 🖥️

- **Database:** SQL Server or any compatible SQL environment.  
- **Dataset:** `PortfolioProject.dbo.NashvilleHousing`  
- **Skills Applied:**  
  - Data type conversions  
  - String manipulation  
  - Common Table Expressions (CTEs)  
  - Conditional updates  
  - Deduplication  
  - Column management  

---

## Author 🙌

**Vivek**  
A passionate data enthusiast with expertise in Artificial Intelligence and Machine Learning, dedicated to transforming raw data into actionable insights through systematic cleaning and analysis.

