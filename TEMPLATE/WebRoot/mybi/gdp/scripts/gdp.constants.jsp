<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript">
var cycleObj = {};

//大周期
var cycle = [
             {id:"D", nam:"<s:text name='etl_holiday_cycle_d'/>"}, 
             {id:"W", nam:"<s:text name='etl_holiday_cycle_w'/>"}, 
             {id:"X", nam:"<s:text name='etl_holiday_cycle_x'/>"},
             {id:"M", nam:"<s:text name='etl_holiday_cycle_m'/>"},
             {id:"Q", nam:"<s:text name='etl_holiday_cycle_q'/>"},
             {id:"R", nam:"<s:text name='etl_holiday_cycle_r'/>"},
             {id:"S", nam:"<s:text name='etl_holiday_cycle_s'/>"},
             {id:"Y", nam:"<s:text name='etl_holiday_cycle_y'/>"}
           ];
//天     
var cycleD = [{id:"D0", nam:"<s:text name='etl_holiday_day_first'/>"}];

//周
var cycleW =[
             {id:"W1", nam:"<s:text name='etl_holiday_week_monday'/>"}, 
             {id:"W2", nam:"<s:text name='etl_holiday_week_tuesday'/>"}, 
             {id:"W3", nam:"<s:text name='etl_holiday_week_wednesday'/>"},
             {id:"W4", nam:"<s:text name='etl_holiday_week_thursday'/>"},
             {id:"W5", nam:"<s:text name='etl_holiday_week_friday'/>"},
             {id:"W6", nam:"<s:text name='etl_holiday_week_saturday'/>"},
             {id:"W0", nam:"<s:text name='etl_holiday_week_sunday'/>"}
            ];
//旬            
var cycleX = [
             {id:"X1", nam:"<s:text name='etl_holiday_period_first'/>"}, 
             {id:"X2", nam:"<s:text name='etl_holiday_period_second'/>"}, 
             {id:"X3", nam:"<s:text name='etl_holiday_period_third'/>"},
             {id:"X4", nam:"<s:text name='etl_holiday_period_fourth'/>"},
             {id:"X5", nam:"<s:text name='etl_holiday_period_fifth'/>"},
             {id:"X6", nam:"<s:text name='etl_holiday_period_sixth'/>"},
             {id:"X7", nam:"<s:text name='etl_holiday_period_seventh'/>"},
             {id:"X8", nam:"<s:text name='etl_holiday_period_eighth'/>"},
             {id:"X9", nam:"<s:text name='etl_holiday_period_ninth'/>"},
             {id:"X0", nam:"<s:text name='etl_holiday_period_end'/>"}
            ];
            
     //月       
	 var cycleM = [
	             {id:"M1", nam:"<s:text name='etl_holiday_month_first'/>"}, 
	             {id:"M2", nam:"<s:text name='etl_holiday_month_second'/>"}, 
	             {id:"M3", nam:"<s:text name='etl_holiday_month_third'/>"},
	             {id:"M4", nam:"<s:text name='etl_holiday_month_fourth'/>"},
	             {id:"M5", nam:"<s:text name='etl_holiday_month_fifth'/>"},
	             {id:"M6", nam:"<s:text name='etl_holiday_month_sixth'/>"},
	             {id:"M7", nam:"<s:text name='etl_holiday_month_seventh'/>"},
	             {id:"M8", nam:"<s:text name='etl_holiday_month_eighth'/>"},
	             {id:"M9", nam:"<s:text name='etl_holiday_month_ninth'/>"},
	             {id:"M10", nam:"<s:text name='etl_holiday_month_tenth'/>"},
	             {id:"M11", nam:"<s:text name='etl_holiday_month_eleventh'/>"},
	             {id:"M12", nam:"<s:text name='etl_holiday_month_twelfth'/>"},
	             {id:"M13", nam:"<s:text name='etl_holiday_month_thirteenth'/>"},
	             {id:"M14", nam:"<s:text name='etl_holiday_month_fourteenth'/>"},
	             {id:"M15", nam:"<s:text name='etl_holiday_month_fifteenth'/>"},
	             {id:"M16", nam:"<s:text name='etl_holiday_month_sixteenth'/>"},
	             {id:"M17", nam:"<s:text name='etl_holiday_month_seventeenth'/>"},
	             {id:"M18", nam:"<s:text name='etl_holiday_month_eighteenth'/>"},
	             {id:"M19", nam:"<s:text name='etl_holiday_month_nineteenth'/>"},
	             {id:"M20", nam:"<s:text name='etl_holiday_month_twentieth'/>"},
	             {id:"M21", nam:"<s:text name='etl_holiday_month_twenty_first'/>"},
	             {id:"M22", nam:"<s:text name='etl_holiday_month_twenty_second'/>"},
	             {id:"M23", nam:"<s:text name='etl_holiday_month_twenty_third'/>"},
	             {id:"M24", nam:"<s:text name='etl_holiday_month_twenty_forth'/>"},
	             {id:"M25", nam:"<s:text name='etl_holiday_month_twenty_fifth'/>"},
	             {id:"M26", nam:"<s:text name='etl_holiday_month_twenty_sixth'/>"},
	             {id:"M27", nam:"<s:text name='etl_holiday_month_twenty_seventh'/>"},
	             {id:"M28", nam:"<s:text name='etl_holiday_month_twenty_eighth'/>"},
	             {id:"M29", nam:"<s:text name='etl_holiday_month_twenty_nineth'/>"},
	             {id:"M30", nam:"<s:text name='etl_holiday_month_thirtieth'/>"},
	             {id:"M0", nam:"<s:text name='etl_holiday_month_end'/>"}
	            ];

	 //季度
	 var cycleQ = [
	             {id:"Q1", nam:"<s:text name='etl_holiday_season1th_first'/>"}, 
	             {id:"Q2", nam:"<s:text name='etl_holiday_season1th_second'/>"}, 
	             {id:"Q3", nam:"<s:text name='etl_holiday_season1th_third'/>"},
	             {id:"Q4", nam:"<s:text name='etl_holiday_season1th_fourth'/>"},
	             {id:"Q5", nam:"<s:text name='etl_holiday_season1th_fifth'/>"},
	             {id:"Q6", nam:"<s:text name='etl_holiday_season1th_sixth'/>"},
	             {id:"Q7", nam:"<s:text name='etl_holiday_season1th_seventh'/>"},
	             {id:"Q8", nam:"<s:text name='etl_holiday_season1th_eighth'/>"},
	             {id:"Q9", nam:"<s:text name='etl_holiday_season1th_ninth'/>"},
	             {id:"Q10", nam:"<s:text name='etl_holiday_season1th_tenth'/>"},
	             {id:"Q11", nam:"<s:text name='etl_holiday_season1th_eleventh'/>"},
	             {id:"Q12", nam:"<s:text name='etl_holiday_season1th_twelfth'/>"},
	             {id:"Q13", nam:"<s:text name='etl_holiday_season1th_thirteenth'/>"},
	             {id:"Q14", nam:"<s:text name='etl_holiday_season1th_fourteenth'/>"},
	             {id:"Q15", nam:"<s:text name='etl_holiday_season1th_fifteenth'/>"},
	             {id:"Q16", nam:"<s:text name='etl_holiday_season1th_sixteenth'/>"},
	             {id:"Q17", nam:"<s:text name='etl_holiday_season1th_seventeenth'/>"},
	             {id:"Q18", nam:"<s:text name='etl_holiday_season1th_eighteenth'/>"},
	             {id:"Q19", nam:"<s:text name='etl_holiday_season1th_nineteenth'/>"},
	             {id:"Q20", nam:"<s:text name='etl_holiday_season1th_twentieth'/>"},
	             {id:"Q21", nam:"<s:text name='etl_holiday_season1th_twenty_first'/>"},
	             {id:"Q22", nam:"<s:text name='etl_holiday_season1th_twenty_second'/>"},
	             {id:"Q23", nam:"<s:text name='etl_holiday_season1th_twenty_third'/>"},
	             {id:"Q24", nam:"<s:text name='etl_holiday_season1th_twenty_forth'/>"},
	             {id:"Q25", nam:"<s:text name='etl_holiday_season1th_twenty_fifth'/>"},
	             {id:"Q26", nam:"<s:text name='etl_holiday_season1th_twenty_sixth'/>"},
	             {id:"Q27", nam:"<s:text name='etl_holiday_season1th_twenty_seventh'/>"},
	             {id:"Q28", nam:"<s:text name='etl_holiday_season1th_twenty_eighth'/>"},
	             {id:"Q29", nam:"<s:text name='etl_holiday_season1th_twenty_nineth'/>"},
	             {id:"Q30", nam:"<s:text name='etl_holiday_season1th_thirtieth'/>"},
	             {id:"Q0", nam:"<s:text name='etl_holiday_season1th_end'/>"}
	            ];

	 //每季度第一个月
	 var cycleR = [
	             {id:"R1", nam:"<s:text name='etl_holiday_season2th_first'/>"}, 
	             {id:"R2", nam:"<s:text name='etl_holiday_season2th_second'/>"}, 
	             {id:"R3", nam:"<s:text name='etl_holiday_season2th_third'/>"},
	             {id:"R4", nam:"<s:text name='etl_holiday_season2th_fourth'/>"},
	             {id:"R5", nam:"<s:text name='etl_holiday_season2th_fifth'/>"},
	             {id:"R6", nam:"<s:text name='etl_holiday_season2th_sixth'/>"},
	             {id:"R7", nam:"<s:text name='etl_holiday_season2th_seventh'/>"},
	             {id:"R8", nam:"<s:text name='etl_holiday_season2th_eighth'/>"},
	             {id:"R9", nam:"<s:text name='etl_holiday_season2th_ninth'/>"},
	             {id:"R10", nam:"<s:text name='etl_holiday_season2th_tenth'/>"},
	             {id:"R11", nam:"<s:text name='etl_holiday_season2th_eleventh'/>"},
	             {id:"R12", nam:"<s:text name='etl_holiday_season2th_twelfth'/>"},
	             {id:"R13", nam:"<s:text name='etl_holiday_season2th_thirteenth'/>"},
	             {id:"R14", nam:"<s:text name='etl_holiday_season2th_fourteenth'/>"},
	             {id:"R15", nam:"<s:text name='etl_holiday_season2th_fifteenth'/>"},
	             {id:"R16", nam:"<s:text name='etl_holiday_season2th_sixteenth'/>"},
	             {id:"R17", nam:"<s:text name='etl_holiday_season2th_seventeenth'/>"},
	             {id:"R18", nam:"<s:text name='etl_holiday_season2th_eighteenth'/>"},
	             {id:"R19", nam:"<s:text name='etl_holiday_season2th_nineteenth'/>"},
	             {id:"R20", nam:"<s:text name='etl_holiday_season2th_twentieth'/>"},
	             {id:"R21", nam:"<s:text name='etl_holiday_season2th_twenty_first'/>"},
	             {id:"R22", nam:"<s:text name='etl_holiday_season2th_twenty_second'/>"},
	             {id:"R23", nam:"<s:text name='etl_holiday_season2th_twenty_third'/>"},
	             {id:"R24", nam:"<s:text name='etl_holiday_season2th_twenty_forth'/>"},
	             {id:"R25", nam:"<s:text name='etl_holiday_season2th_twenty_fifth'/>"},
	             {id:"R26", nam:"<s:text name='etl_holiday_season2th_twenty_sixth'/>"},
	             {id:"R27", nam:"<s:text name='etl_holiday_season2th_twenty_seventh'/>"},
	             {id:"R28", nam:"<s:text name='etl_holiday_season2th_twenty_eighth'/>"},
	             {id:"R29", nam:"<s:text name='etl_holiday_season2th_twenty_nineth'/>"},
	             {id:"R30", nam:"<s:text name='etl_holiday_season2th_thirtieth'/>"},
	             {id:"R0", nam:"<s:text name='etl_holiday_season2th_end'/>"}
	            ];

	 //每季度第二个月
	 var cycleS = [
	             {id:"S1", nam:"<s:text name='etl_holiday_season3th_first'/>"}, 
	             {id:"S2", nam:"<s:text name='etl_holiday_season3th_second'/>"}, 
	             {id:"S3", nam:"<s:text name='etl_holiday_season3th_third'/>"},
	             {id:"S4", nam:"<s:text name='etl_holiday_season3th_fourth'/>"},
	             {id:"S5", nam:"<s:text name='etl_holiday_season3th_fifth'/>"},
	             {id:"S6", nam:"<s:text name='etl_holiday_season3th_sixth'/>"},
	             {id:"S7", nam:"<s:text name='etl_holiday_season3th_seventh'/>"},
	             {id:"S8", nam:"<s:text name='etl_holiday_season3th_eighth'/>"},
	             {id:"S9", nam:"<s:text name='etl_holiday_season3th_ninth'/>"},
	             {id:"S10", nam:"<s:text name='etl_holiday_season3th_tenth'/>"},
	             {id:"S11", nam:"<s:text name='etl_holiday_season3th_eleventh'/>"},
	             {id:"S12", nam:"<s:text name='etl_holiday_season3th_twelfth'/>"},
	             {id:"S13", nam:"<s:text name='etl_holiday_season3th_thirteenth'/>"},
	             {id:"S14", nam:"<s:text name='etl_holiday_season3th_fourteenth'/>"},
	             {id:"S15", nam:"<s:text name='etl_holiday_season3th_fifteenth'/>"},
	             {id:"S16", nam:"<s:text name='etl_holiday_season3th_sixteenth'/>"},
	             {id:"S17", nam:"<s:text name='etl_holiday_season3th_seventeenth'/>"},
	             {id:"S18", nam:"<s:text name='etl_holiday_season3th_eighteenth'/>"},
	             {id:"S19", nam:"<s:text name='etl_holiday_season3th_nineteenth'/>"},
	             {id:"S20", nam:"<s:text name='etl_holiday_season3th_twentieth'/>"},
	             {id:"S21", nam:"<s:text name='etl_holiday_season3th_twenty_first'/>"},
	             {id:"S22", nam:"<s:text name='etl_holiday_season3th_twenty_second'/>"},
	             {id:"S23", nam:"<s:text name='etl_holiday_season3th_twenty_third'/>"},
	             {id:"S24", nam:"<s:text name='etl_holiday_season3th_twenty_forth'/>"},
	             {id:"S25", nam:"<s:text name='etl_holiday_season3th_twenty_fifth'/>"},
	             {id:"S26", nam:"<s:text name='etl_holiday_season3th_twenty_sixth'/>"},
	             {id:"S27", nam:"<s:text name='etl_holiday_season3th_twenty_seventh'/>"},
	             {id:"S28", nam:"<s:text name='etl_holiday_season3th_twenty_eighth'/>"},
	             {id:"S29", nam:"<s:text name='etl_holiday_season3th_twenty_nineth'/>"},
	             {id:"S30", nam:"<s:text name='etl_holiday_season3th_thirtieth'/>"},
	             {id:"S0", nam:"<s:text name='etl_holiday_season3th_end'/>"}
	            ];
//年
var cycleY = [{id:"Y0", nam:"<s:text name='etl_holiday_year_end'/>"}];

 cycleObj["CYCLE"] = cycle;
 cycleObj["D"] = cycleD;
 cycleObj["W"] = cycleW;
 cycleObj["X"] = cycleX;
 cycleObj["M"] = cycleM;
 cycleObj["Q"] = cycleQ;
 cycleObj["R"] = cycleR;
 cycleObj["S"] = cycleS;
 cycleObj["Y"] = cycleY;
 </script>
 </head>
 </html>