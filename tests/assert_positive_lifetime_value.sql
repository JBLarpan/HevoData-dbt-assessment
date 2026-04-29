-- This test fails if any customer has a negative lifetime value
-- A negative value would indicate a data quality issue in payments

select *
from {{ ref('customers') }}
where customer_lifetime_value < 0
