-- ============================================================
-- Uber Data Engineering Pipeline
-- Analytics Query
-- ============================================================
-- This query joins all dimension tables with the fact table
-- to produce a single, denormalized analytics table
-- (tbl_analytics) suitable for BI reporting and dashboards.
--
-- Run this in Google BigQuery after the Mage pipeline
-- has successfully loaded all dimension and fact tables.
--
-- Replace YOUR_PROJECT_ID with your actual GCP project ID.
-- ============================================================

CREATE OR REPLACE TABLE `YOUR_PROJECT_ID.uber_data_engineering_yt.tbl_analytics` AS (

  SELECT
    f.VendorID,

    -- Datetime fields
    d.tpep_pickup_datetime,
    d.tpep_dropoff_datetime,
    d.pick_hour,
    d.pick_day,
    d.pick_month,
    d.pick_year,
    d.pick_weekday,
    d.drop_hour,
    d.drop_day,
    d.drop_month,
    d.drop_year,
    d.drop_weekday,

    -- Passenger and distance
    p.passenger_count,
    t.trip_distance,

    -- Rate code
    r.rate_code_name,

    -- Location
    pick.pickup_latitude,
    pick.pickup_longitude,
    drop.dropoff_latitude,
    drop.dropoff_longitude,

    -- Payment
    pay.payment_type_name,

    -- Fare breakdown
    f.fare_amount,
    f.extra,
    f.mta_tax,
    f.tip_amount,
    f.tolls_amount,
    f.improvement_surcharge,
    f.total_amount

  FROM `YOUR_PROJECT_ID.uber_data_engineering_yt.fact_table` f

  JOIN `YOUR_PROJECT_ID.uber_data_engineering_yt.datetime_dim` d
    ON f.datetime_id = d.datetime_id

  JOIN `YOUR_PROJECT_ID.uber_data_engineering_yt.passenger_count_dim` p
    ON f.passenger_count_id = p.passenger_count_id

  JOIN `YOUR_PROJECT_ID.uber_data_engineering_yt.trip_distance_dim` t
    ON f.trip_distance_id = t.trip_distance_id

  JOIN `YOUR_PROJECT_ID.uber_data_engineering_yt.rate_code_dim` r
    ON f.rate_code_id = r.rate_code_id

  JOIN `YOUR_PROJECT_ID.uber_data_engineering_yt.pickup_location_dim` pick
    ON f.pickup_location_id = pick.pickup_location_id

  JOIN `YOUR_PROJECT_ID.uber_data_engineering_yt.dropoff_location_dim` drop
    ON f.dropoff_location_id = drop.dropoff_location_id

  JOIN `YOUR_PROJECT_ID.uber_data_engineering_yt.payment_type_dim` pay
    ON f.payment_type_id = pay.payment_type_id

);

-- ============================================================
-- Validation: Check row count of analytics table
-- ============================================================
-- SELECT COUNT(*) as total_rows
-- FROM `YOUR_PROJECT_ID.uber_data_engineering_yt.tbl_analytics`;

-- ============================================================
-- Sample analysis: Trips and average fare by payment type
-- ============================================================
-- SELECT
--   payment_type_name,
--   COUNT(*) as trip_count,
--   ROUND(AVG(total_amount), 2) as avg_total_fare,
--   ROUND(SUM(total_amount), 2) as total_revenue
-- FROM `YOUR_PROJECT_ID.uber_data_engineering_yt.tbl_analytics`
-- GROUP BY payment_type_name
-- ORDER BY trip_count DESC;
