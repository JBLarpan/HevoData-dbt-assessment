WITH source
     AS ( SELECT *
          FROM   {{ source('hevo_source', 'postgres_raw_payments') }}
          WHERE  __hevo__marked_deleted = FALSE ), 
     renamed
     AS ( SELECT id AS payment_id,
                 order_id,
                 payment_method,
                 amount
          FROM   source ) 
  SELECT *
  FROM   renamed 