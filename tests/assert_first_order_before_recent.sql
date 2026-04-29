-- This test fails if first_order is ever AFTER most_recent_order
-- which would indicate corrupted date data

select *
from {{ ref('customers') }}
where first_order > most_recent_order
