--query which extracts accelerometer data and converts raw data to units g using calibration values
SELECT a.device_info_serial, a.date_time, a.index, 
(a.x_acceleration-d.x_o)/d.x_s as x_cal,  
(a.y_acceleration-d.y_o)/d.y_s as y_cal, 
(a.z_acceleration-d.z_o)/d.z_s as z_cal, t.speed,
t.latitude, t.longitude, t.altitude
FROM gps.uva_device d, gps.uva_tracking_speed t 
FULL OUTER JOIN gps.uva_acceleration101 a  
USING (device_info_serial, date_time)
WHERE a.device_info_serial = 355 
AND a.device_info_serial = d.device_info_serial  
AND a.date_time > '2010-07-04 09:59:21' AND a.date_time < '2010-07-04 12:03:38'
ORDER BY a.date_time, a.index
