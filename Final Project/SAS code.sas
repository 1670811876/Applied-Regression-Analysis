ods pdf file="E:\SAS\Final Project\结果文件.pdf";
proc import datafile='E:\SAS\Final Project\insurance.csv' out=file_data replace;
    getnames=yes;
run;
proc print data=file_data;
run;
/*为指示变量编码*/
data file_data_new;
	set file_data;
	select;
		when (sex="female") sex_new=0;
		when (sex="male") sex_new=1;
	end;
run;
data file_data_new;
	set file_data_new;
	select;
		when (smoker="no") smoker_new=0;
		when (smoker="yes") smoker_new=1;
	end;
run;
data file_data_new;
	set file_data_new;
	select;
		when (region="northwest") region1=0;
		when (region="northeast") region1=1;
		when (region="southwest") region1=0;
		when (region="southeast") region1=0;
	end;
run;
data file_data_new;
	set file_data_new;
	select;
		when (region="northwest") region2=0;
		when (region="northeast") region2=0;
		when (region="southwest") region2=1;
		when (region="southeast") region2=0;
	end;
run;
data file_data_new;
	set file_data_new;
	select;
		when (region="northwest") region3=0;
		when (region="northeast") region3=0;
		when (region="southwest") region3=0;
		when (region="southeast") region3=1;
	end;
run;
proc print data=file_data_new;
run;
proc reg data=file_data_new outest=model1_test;
    model charges=age bmi children smoker_new sex_new region1 region2 region3/r corrb vif collin dw spec;
    output out=res_data1 r=res_multi student=stu_res press=press_res rstudent=rstu_res h=h;
	plot r.*p.;
run;
proc univariate data=res_data1 normal plot;
    var res_multi;
run;
proc print data=model1_test;
run;
proc reg data=file_data_new;
    model charges=age bmi children smoker_new sex_new region1 region2 region3/selection=stepwise;
	plot r.*p.;
run;
proc reg data=file_data_new outest=model2_test;
    model charges=age bmi children smoker_new region1/r corrb vif collin dw spec;
    output out=res_data2 r=res_multi student=stu_res press=press_res rstudent=rstu_res h=h;
	plot r.*p.;
run;
proc univariate data=res_data2 normal plot;
    var res_multi;
run;
proc print data=model2_test;
run;
data res_data_model;   
    set res_data2;
    if (stu_res>3 or stu_res<-3) then delete; 
	if (cookd>0.003) then delete;
run;
proc print data=res_data_model;
run;
proc reg data=res_data_model outest=model3_test;
    model charges=age bmi children smoker_new region1/r corrb vif collin dw spec;
	output out=res_data3 r=res_multi;
    plot r.*p.;
run;
proc univariate data=res_data3 normal plot;
    var res_multi;
run;
proc print data=model3_test;
run;
ods pdf close;
DM "LOG;
file'E:\SAS\Final Project\日志文件.txt'";
