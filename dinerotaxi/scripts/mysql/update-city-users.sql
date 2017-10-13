update  user realuser INNER  join user rtaxi on rtaxi.class='ar.com.goliath.Company' and realuser.rtaxi_id is not null and rtaxi.city_id is not null and rtaxi.id=realuser.rtaxi_id   set realuser.city_id=rtaxi.city_id
#select count(*) from user where user.class='ar.com.goliath.Company' and city_id is null
#update user set city_id = 15  where user.class='ar.com.goliath.Company' and city_id is null

