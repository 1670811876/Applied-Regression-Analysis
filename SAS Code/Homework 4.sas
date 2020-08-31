/*9.2*/
proc import datafile='E:\Applied Regression Analysis\Data Sets\data-ex-10-1_(Hald_Cement).XLS' out=data1 dbms=XLS replace;
	getnames=yes;
run;
proc print data=data1;
run;
proc reg data=data1;
	model y=x1-x4/corrb vif collin;
run;
/*9.4*/
proc reg data=data1;
model y=x1-x4/noint collin;
run;
/*9.5*/
data new_data1;
	set data1;
run;
proc standard data=new_data1 mean=0 out=new_data1;
	var x1-x4;
run;
proc reg data=new_data1;
	model y=x1-x4/collin;
run;
/*10.1*/
proc import datafile='E:\Applied Regression Analysis\Data Sets\data-table-B1.XLS' out=data2 dbms=XLS replace;
	getnames=yes;
run;
proc print data=data2;
run;
proc reg ;
	model y=x1-x9/selection=forward;
run;
proc reg ;
	model y=x1-x9/selection=backward;
run;
proc reg ;
	model y=x1-x9/selection=stepwise;
run;
/*10.2*/
proc reg data=data2;
	model y=x1 x2 x4 x7-x9/adjrsq mse cp;
run;
/*13.1*/
proc import datafile='E:\Applied Regression Analysis\Data Sets\data-prob-13-1.XLS' out=data3 dbms=XLS replace;
	getnames=yes;
run;
proc print data=data3;
run;
proc logistic ;
	model y=x/link=logit;
run;
/*13.4*/
proc import datafile='E:\Applied Regression Analysis\Data Sets\data-prob-13-4.XLS' out=data4 dbms=XLS replace;
	getnames=yes;
run;
proc print data=data4;
run;
data new_data4;
input x f y ;
datalines;
5	100	1
5	400	0
7	378	0
7	122	1
9	353	0
9	147	1
11	324	0
11	176	1
13	289	0
13	211	1
15	256	0
15	244	1
17	223	0
17	277	1
19	190	0
19	310	1
21	157	0
21	343	1
23	128	0
23	372	1
25	391	1
25	109	0
;
run;
proc logistic ;
model y=x/link=logit scale=n aggregate ;
freq f;
run;
