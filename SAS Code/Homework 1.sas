/*2.6*/
proc import datafile='E:\Applied Regression Analysis\SAS\data-table-B3.csv' out = file_data;
getnames=yes;
run;
proc reg data=file_data;
model y=x1/clm alpha=0.05;
run;  
proc reg data=file_data;
model y=x1/cli alpha=0.05;
run;  

/*2.7*/
data file_data2;
input y x;
cards;
86.91	1.02
89.85	1.11
90.28	1.43
86.34	1.11
92.58	1.01
87.33	0.95
86.29	1.11
91.86	0.87
95.61	1.43
89.86	1.02
96.73	1.46
99.42	1.55
98.66	1.55
96.07	1.55
93.65	1.40
87.31	1.15
95.00	1.01
96.85	0.99
85.2	0.95
90.56	0.98
;
run;
proc reg data=file_data2;
model y=x/clb;
run; 
data file_data2_new;
input x;
cards;
1.00
;
run;
data file_data2;
set file_data2_new file_data2;
run;
proc reg data=file_data2;
model y=x/clm alpha=0.05;
run;
quit;
