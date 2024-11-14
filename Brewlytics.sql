-- What is the total volume of beer produced for each beer style?
SELECT 
    Beer_Style, SUM(Volume_Produced) AS Total_volume_produced
FROM
    brewery.Brewlytics
GROUP BY Beer_Style
ORDER BY Total_volume_produced DESC;

-- Calculate the average Fermentation_Time and Temperature for all beer batches in the dataset. 
SELECT 
    Fermentation_Time,
    AVG(Fermentation_Time) AS avg_fermentation_time,
    AVG(Temperature) AS avg_Temperature
FROM
    brewery.Brewlytics
GROUP BY Fermentation_Time
ORDER BY Fermentation_Time ASC;

-- Retrieve all records from the dataset where the pH_Level is greater than 4.5
SELECT 
    *
FROM
    brewery.Brewlytics
WHERE
    pH_Level > 4.5;
-- List the top 5 beer batches with the highest
Select 
	Batch_ID,
    Beer_Style,
    sum(Total_Sales) as Total_Sales
From brewery.Brewlytics
Group by 
Batch_ID,Beer_Style
Order by Total_Sales
limit 5 ;

-- Find the total Loss_During_Brewing, Loss_During_Fermentation, and Loss_During_Bottling_Kegging for each Beer_Style. 
SELECT 
    Beer_Style,
    SUM(Loss_During_Brewing) AS total_loss_Brewing,
    SUM(Loss_During_Fermentation) AS total_loss_fermentation,
    SUM(Loss_During_Bottling_Kegging) AS total_loss_bottling_kegging
FROM
    brewery.Brewlytics
GROUP BY Beer_Style
ORDER BY total_loss_Brewing , total_loss_fermentation , total_loss_bottling_kegging;

-- Calculate the average Quality_Score for each Beer_Style in the dataset and order the results in descending order of the average Quality_Score
Select 
Beer_Style,
avg(Quality_Score) as avg_quality_Score
From
brewery.Brewlytics
Group by Beer_Style
Order by avg_quality_Score desc;

-- Find the Batch_ID and Total_Sales for all batches produced in a specific Location

SELECT 
    Batch_ID, Location, 
    SUM(Total_Sales) AS total_sales
FROM
    brewery.Brewlytics
GROUP BY Batch_ID , Location
Order by total_sales DESC
limit 10 ;

-- Calculate the total Volume_Produced grouped by Month_Year and Location.
select Month_Year,Location,
sum(Volume_Produced) as total_volume_produced
From brewery.Brewlytics
Group by Month_Year,Location
order by total_volume_produced desc;

-- For each Beer_Style, calculate the average Interaction_Alcohol_Gravity and Inctraction_pH_Bitterness
select Beer_Style,
avg(Interaction_Alcohol_Gravity) as Avg_Interaction_Alcohol_Gravity,
avg(Inctraction_pH_Bitterness) as Avg_Inctraction_pH_Bitterness
From brewery.Brewlytics
Group by Beer_Style
Order by Avg_Interaction_Alcohol_Gravity,Avg_Inctraction_pH_Bitterness desc;

-- calculate the average Brewhouse_Efficiency for each Beer_Style. Then, use this CTE to find all batches with a Brewhouse_Efficiency higher than their style's average.
with avgBrewhouseEfficiency as (
select Beer_Style,
avg(Brewhouse_Efficiency)  AS Avg_Efficiency
From brewery.Brewlytics
Group by Beer_Style
)
select  b.Batch_ID,
    b.Beer_Style,
    b.Brewhouse_Efficiency
FROM 
    brewery.Brewlytics b
JOIN 
    avgBrewhouseEfficiency a ON b.Beer_Style = a.Beer_Style
WHERE 
    b.Brewhouse_Efficiency > a.Avg_Efficiency;

-- Identify the Batch_ID with the highest Total_Sales for each Beer_Style.
select
b.Beer_Style,
b.Batch_ID,
b.Total_Sales
from brewery.Brewlytics b
where 
b.Total_Sales =(
	Select 
    Max(Total_Sales)
    from brewery.Brewlytics
    where 
    Beer_Style =b.Beer_Style
    );
    
    
    with avgBrewhouseEfficiency as (
select Beer_Style,
avg(Brewhouse_Efficiency)  AS Avg_Efficiency
From brewery.Brewlytics
Group by Beer_Style
)
select  b.Batch_ID,
    b.Beer_Style,
    b.Brewhouse_Efficiency
FROM 
    brewery.Brewlytics b
JOIN 
    avgBrewhouseEfficiency a ON b.Beer_Style = a.Beer_Style
WHERE 
    b.Brewhouse_Efficiency > a.Avg_Efficiency;
    
   

     -- finds the total Loss_During_Brewing, Loss_During_Fermentation, and Loss_During_Bottling_Kegging for each batch

    
    SELECT 
    Beer_Style,
    (Loss_During_Brewing + 
     Loss_During_Fermentation + 
     Loss_During_Bottling_Kegging) AS total_losses
FROM 
    brewery.Brewlytics
WHERE 
    (Loss_During_Brewing + 
     Loss_During_Fermentation + 
     Loss_During_Bottling_Kegging) > (
        SELECT 
            (AVG(Loss_During_Brewing) + 
             AVG(Loss_During_Fermentation) + 
             AVG(Loss_During_Bottling_Kegging)) AS avg_losses
        FROM 
            brewery.Brewlytics
        WHERE 
            brewery.Brewlytics.Beer_Style = Beer_Style
    );


with  total_losses as (
select 
   Beer_Style,
    (Loss_During_Brewing + 
     Loss_During_Fermentation + 
     Loss_During_Bottling_Kegging) AS total_losses
     From  brewery.Brewlytics
Where 
    (Loss_During_Brewing + 
     Loss_During_Fermentation + 
     Loss_During_Bottling_Kegging) >(
     select (AVG(Loss_During_Brewing) + 
             AVG(Loss_During_Fermentation) + 
             AVG(Loss_During_Bottling_Kegging)) AS avg_losses
             From brewery.Brewlytics
             )
	)
    select 
     t.Beer_Style,
     t.total_losses,
     a.avg_losses
     From total_losses as t 
     inner join 
     (select 
     Beer_style,
     (AVG(Loss_During_Brewing) + 
             AVG(Loss_During_Fermentation) + 
             AVG(Loss_During_Bottling_Kegging))AS avg_losses
             From brewery.Brewlytics
             group by 
    Beer_style
    ) as a
    on t.Beer_Style =a.Beer_Style;
        





    