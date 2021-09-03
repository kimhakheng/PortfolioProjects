/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject.dbo.Sheet1$

---------------------------------------------------------------------------------------------------


-- Standardize Data Format

ALTER TABLE Sheet1$
Add SaleDateConverted date;

Update Sheet1$
SET SaleDateConverted = CONVERT(date, SaleDate)

Select SaleDateConverted, CONVERT(date, SaleDate)
From PortfolioProject.dbo.Sheet1$

---------------------------------------------------------------------------------------------------


-- Populate Property Address data

Select *
From PortfolioProject.dbo.Sheet1$
--Where PropertyAddress is null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.Sheet1$ a
JOIN PortfolioProject.dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, 'No Address')
From PortfolioProject.dbo.Sheet1$ a
JOIN PortfolioProject.dbo.Sheet1$ b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


---------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Column (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.Sheet1$


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.Sheet1$


ALTER TABLE Sheet1$
Add PropertySplitAddress Nvarchar(255);

Update Sheet1$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, ABS(CHARINDEX(',', PropertyAddress) -1))

ALTER TABLE Sheet1$
Add PropertySplitCity Nvarchar(255);

Update Sheet1$
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
From PortfolioProject.dbo.Sheet1$





Select OwnerAddress
From PortfolioProject.dbo.Sheet1$

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.Sheet1$



ALTER TABLE Sheet1$
Add OwnerSplitAddress Nvarchar(255);

Update Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE Sheet1$
Add OwnerSplitCity Nvarchar(255);

Update Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE Sheet1$
Add OwnerSplitState Nvarchar(255);

Update Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)




---------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.Sheet1$
Group By SoldAsVacant

Select SoldAsVacant, 
	CASE When SoldAsVacant = 'Y' THEN 'Yes' 
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 End
From PortfolioProject.dbo.Sheet1$


Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes' 
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 End




---------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.Sheet1$
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.Sheet1$



---------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.Sheet1$


ALTER TABLE PortfolioProject.dbo.Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate