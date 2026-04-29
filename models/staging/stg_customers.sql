WITH source
     AS ( SELECT *
          FROM   {{ source('hevo_source', 'postgres_raw_customers') }}
          WHERE  __hevo__marked_deleted = FALSE ), 
     renamed
     AS ( SELECT id AS customer_id,
                 first_name,
                 last_name
          FROM   source ) 
  SELECT *
  FROM   renamed 