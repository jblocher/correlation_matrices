/* *************************************************************************/
/* CREATED BY:      Jesse Blocher (UNC-Chapel Hill)                                               
/* MODIFIED BY:                                                    
/* DATE CREATED:    Sept 2010                                                                                                            
/* PROG NAME:       subdivide_holdings.sas                                                              
/* Project:         Market Interconnectedness and Fires Sales, Momentum
/* This File:       Divides up our "equity" group - i.e. those portfolios with some nonzero equity holdings.
/************************************************************************************/
 
%include 'corr_header.sas'; *header file with basic options and libraries;


/* Datasets required to run:
 * corr.fourig_sas_monthlyXXX			: eigenvectors, monthly
 * corr.yrmo_newXXXX					: original return data from WRDS
 */

/* Datasets Produced:
 * corrwork.cusip_indexingYY0MM			: Cusip, rowid, year, month simple data YY 1980 to 2009, MM 1 to 12
 * corr.foureigenvectors				: all combined into one
 */


** First, lets merge in the CUSIPs;
%macro assign_rowid();
	
	%do y=1980 %to 2009;
	%do q=1 %to 12;
		data corrwork.cusip_indexing&y.0&q ;
			set corr.yrmo_new&y.0&q (keep = cusip);
			rowid = _N_;
			year = &y ;
			month = &q ;
		run;
	
	%end;
	%end;
	
	%do i=1 %to 360;
	data matrix_indexing&i;
		set corr.foureig_sas_monthly&i ;
		rowid = _N_;
	run;
	%end;

%mend;

%assign_rowid();

%macro assemble_data();
	
	data corrwork.foureig_temp;
		set matrix_indexing1;
	run;
	
	%do b=2 %to 360;
		proc append base = corrwork.foureig_temp data = matrix_indexing&b ;
	%end;
	
	
	data corrwork.cusips_temp;
		set corrwork.cusip_indexing198001;
	run;
	
	%do y=1980 %to 2009;
	%do q=1 %to 12;
		proc append base = corrwork.cusips_temp data = corrwork.cusip_indexing&y.0&q ;
	%end;
	%end;

%mend;

%assemble_data();

proc sql;
	create table corr.foureigenvectors as
	select a.col3 as ev1, a.col4 as ev2, a.col5 as ev3, a.col6 as ev4, b.year, b.month, b.cusip, mdy(b.month,1,b.year) as date format=date10. 
	from
	corrwork.foureig_temp as a, corrwork.cusips_temp as b
	where a.rowid = b.rowid and a.col1 = b.year and a.col2 = b.month;
quit;


/* should be this big:
NOTE: The data set CORRWORK.BYQTRRET_TRANS_TEMP has 876729 observations and 69 variables.
*/

proc print data = corr.foureigenvectors (obs = 200);
run;
proc contents data = corr.foureigenvectors; run;