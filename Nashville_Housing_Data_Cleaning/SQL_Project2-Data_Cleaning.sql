/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

-- #Standardize Date Format

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Run the below command to check the format of the SaleDateConverted Column(should be in Date format)
SELECT SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing


----------------------------------------------------------------------------------------------------------------------------------

-- #Populate Property Address Data (In this query, we are putting the same PropertyAddress in other rows that have Null values in the PropertAddress, and they also have the same ParcelID and different UniqueID)

SELECT a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress )
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL 


UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL 


----------------------------------------------------------------------------------------------------------------------------------


-- #Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing



-- 1. Breaking out PropertyAddress

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


-- 2. Breaking out OwnerAddress

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)  -- PARSENAME is normally used to split and retrieve parts of a SQL Server object name (e.g., Database.Schema.Table.Column), but here it is creatively used to split parts of the OwnerAddress.
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)  -- expression: The modified OwnerAddress (with '.' replacing ','). The part of the string to extract (1 = last part, 2 = second last part, etc.).
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--After running the below code you can see the OwnerSplitAddress, OwnerSplitCity, OwnerSplitState at the end fo the table 

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing



----------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT SoldAsVacant
FROM PortfolioProject.dbo.NashvilleHousing
WHERE SoldAsVacant = 'Y' or SoldAsVacant = 'N'

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE 
   WHEN SoldAsVacant = 'Y' THEN 'Yes'
   WHEN SoldAsVacant = 'N' THEN 'No'
   ELSE SoldAsVacant
END 


-- Now after running the below code if you got blank columns this means that there is no Y and N in SoldAsVacant column
SELECT SoldAsVacant
FROM PortfolioProject.dbo.NashvilleHousing
WHERE SoldAsVacant = 'Y' or SoldAsVacant = 'N'


----------------------------------------------------------------------------------------------------------------------------------


-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                ORDER BY 
                   UniqueID
                   ) AS row_num

FROM PortfolioProject.dbo.NashvilleHousing
)


DELETE 
FROM RowNumCTE
WHERE row_num > 1



-- After running the below code if you got blank columns then this means that there is no row left with same values 

WITH RowNumCTE AS(
SELECT *,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                ORDER BY 
                   UniqueID
                   ) AS row_num

FROM PortfolioProject.dbo.NashvilleHousing
)


SELECT * 
FROM RowNumCTE
WHERE row_num > 1



----------------------------------------------------------------------------------------------------------------------------------


-- Delete Unused Columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate 