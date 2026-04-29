WITH source
     AS ( SELECT *
          FROM   {{ source('hevo_source', 'postgres_raw_orders') }}
          WHERE  __hevo__marked_deleted = FALSE ), 
     renamed
     AS ( SELECT id      AS order_id,
                 user_id AS customer_id,
                 order_date,
                 status
          FROM   source ) 
  SELECT *
  FROM   renamed 