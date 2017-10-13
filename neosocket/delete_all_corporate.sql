
delete from billing_enterprise_history
delete from billing_enterprise_history_billing_payments
delete from billing_enterprise_history_item_detail_enterprise
delete from billing_enterprise_history_user
delete from billing_payments
delete from calification where operation_id not in (select id from operation);
delete from delay_operation where user_id not in (select id from user);
delete from techno_rides_mail_queue where from_id not in (select id from user);
delete from techno_rides_mail_queue where to_id not in (select id from user);
delete from user_role where user_id not in (select id from user);
delete from operation where user_id not in (select id from user);
delete from temporal_favorites where user_id not in (select id from user)
