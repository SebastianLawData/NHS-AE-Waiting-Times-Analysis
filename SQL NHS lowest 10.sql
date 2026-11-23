WITH hospital_data AS (
    SELECT
        ORG_DESCRIPTION,
        SUM(MEASURE_VALUE) AS total_attendances,
        SUM(CASE
            WHEN MEASURE = '04:01 or above'
            THEN MEASURE_VALUE ELSE 0
        END) AS over_4_hours,
        SUM(CASE
            WHEN MEASURE_VALUE = '*'
            THEN 1 ELSE 0
        END) AS suppressed_values
    FROM NHS_ae
    WHERE MEASURE_TYPE = 'Duration in Department'
      AND GEOGRAPHY_LEVEL = 'Provider' AND MEASURE != 'Not Known'
    GROUP BY ORG_CODE, ORG_DESCRIPTION
)

SELECT
    ORG_DESCRIPTION, total_attendances, over_4_hours,
    ROUND(
        over_4_hours * 100.0 / total_attendances,
        2
    ) AS percentage_over_4_hours
FROM hospital_data
WHERE suppressed_values = 0 AND total_attendances > 0
ORDER BY percentage_over_4_hours ASC;