# iot_dooralarm version 0.1
using an ESP8266 eval board for a IoT door alarm

it uses wifi to go online, resolve ntp pool IP, sync time. If the door contact is open and time is between specific parameters, the buzzer is fired. Otherwise, only the LED is blinking.
All code is written in lua, hence the ESP is flashed with nodeMCU firmware from https://nodemcu-build.com

ESP8266 eval boards come with a battery container, which is quite usefull for an easy power supply. And they are cheap.
<img src=https://github.com/yjeanrenaud/iot_dooralarm/blob/master/yj_dooralarm1.jpg>
I housed the components in an old match box which sits on the door frame
<img src=https://github.com/yjeanrenaud/iot_dooralarm/blob/master/yj_dooralarm2.jpg>
and punched a hole in the top for the rgb led
<img src=https://github.com/yjeanrenaud/iot_dooralarm/blob/master/yj_dooralarm3.jpg>
note the contact is closed by a pice of tinfoil which is attached to the door via double-sided adhesive tape. I used jumper wires to connect it so the box can easily be removed from site without disassembly.

coming up next: 
- documentation of wiring
- config wifi via httpd instead of hardcoded creds
