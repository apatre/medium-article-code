-- This query will update  an existing new table 
CREATE TABLE experimental_dataset.photos_v_0_1
SELECT
  upload_session_id, MODEL, lon, equatorial_mount, make, id,
  (
    SELECT AS STRUCT
    detected_circle.* EXCEPT(center_x, center_y),
    CAST(detected_circle.center_y as STRING) AS center_y,
    CAST(detected_circle.center_x as STRING) AS center_x
  ) as detected_circle,
  uploaded_date, camera_datetime, storage_uri, 
  exposure_time, state, image_bucket, image_datetime, lat,
  vision_labels, user, is_mobile, image_type, width, totality,
  datetime_repaired, height, aperture_value
FROM
  `bigquery-public-data.eclipse_megamovie.photos_v_0_1`
WHERE
  upload_session_id = 'dd9aa9154fcbbc5f4c5dd79123341397ea73da8aaf27e8257e7476774616a358';
-- ===================================================================================

-- Creating sample data and using it for our medium article
-- -------------------------------------------------------
-- Creating schema of the table

CREATE TABLE IF NOT EXISTS `experimental_dataset.address` (
  id INT64,
  first_name STRING,
  last_name STRING,
  dob DATE,
  addresses
    ARRAY<
      STRUCT<
        status STRING,
        address STRING,
        city STRING,
        state STRING,
        zip INT64,
        numberOfYears INT64>>
) OPTIONS (
    description = 'Example name and addresses table');

-- Inserting data in the created schema
INSERT INTO `experimental_dataset.address`(
  id, first_name, last_name, dob, addresses)
  values(
    1, "John", "Doe", "1968-01-22", [
      STRUCT( "current", "123 First Avenue", "Seattle", "WA", 11111, 1),
      STRUCT( "previous", "456 Main Street", "Portland", "OR", 22222, 5)]);

INSERT INTO `experimental_dataset.address`(
  id, first_name, last_name, dob, addresses)
  values(
    2, "Jane", "Doe", "1980-10-16", [
      STRUCT( "current", "789 Any Avenue", "New York", "NY", 33333, 2),
      STRUCT( "previous", "321 Main Street", "Hoboken", "NJ", 44444, 3)]);

-- ALTER SQL script for the address table
ALTER TABLE IF EXISTS `experimental_dataset.address`
  ALTER COLUMN IF EXISTS id SET DATA TYPE (STRING);

-- In Query editor copy paste the below statement
SELECT
  * EXCEPT (addresses),
  ARRAY(
    SELECT AS STRUCT(
      addresses.* EXCEPT(zip, numberOfYears),
      CAST(zip AS STRING) AS zip,
      numberOfYears
    )
   FROM unnest(addresses)) AS addresses
FROM `experimental_dataset.address`;
-- Click More and select Query settings.
-- In the Destination section, do the following:
-- a) Select Set a destination table for query results.
-- b) For Project name, leave the value set to your default project. 
-- c) This is the project that contains mydataset.mytable. For Dataset, choose mydataset.
-- d) In the Table Id field, enter mytable.
-- e) For Destination table write preference, select Overwrite table. This option overwrites mytable using the query results.
-- Optionally, choose your data's location.
-- To update the settings, click Save.
-- Click Run.

-- Congratulations, you have learned how to update the data type in BigQuery.


