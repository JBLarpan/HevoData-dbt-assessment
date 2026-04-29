{{
    config(
        materialized='table'
    )
}}


WITH customers
     AS ( SELECT *
          FROM   {{ ref('stg_customers') }} ), 
     orders
     AS ( SELECT *
          FROM   {{ ref('stg_orders') }} ), 
     payments
     AS ( SELECT *
          FROM   {{ ref('stg_payments') }} ), 
     order_summary
     AS ( SELECT   customer_id,
                   Min(order_date) AS first_order,
                   Max(order_date) AS most_recent_order,
                   Count(order_id) AS number_of_orders
          FROM     orders
          GROUP BY customer_id ), 
     payment_summary
     AS ( SELECT   o.customer_id,
                   Sum(p.amount) AS customer_lifetime_value
          FROM     payments p
                   JOIN orders o
                   ON p.order_id = o.order_id
          GROUP BY o.customer_id ), 
     final
     AS ( SELECT c.customer_id,
                 c.first_name,
                 c.last_name,
                 os.first_order,
                 os.most_recent_order,
                 Coalesce(os.number_of_orders, 0)        AS number_of_orders,
                 Coalesce(ps.customer_lifetime_value, 0) AS customer_lifetime_value
          FROM   customers c
                 LEFT JOIN order_summary os
                 ON c.customer_id = os.customer_id
                 LEFT JOIN payment_summary ps
                 ON c.customer_id = ps.customer_id ) 
  SELECT *
  FROM   final 