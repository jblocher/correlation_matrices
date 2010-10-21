/* *************************************************************************/
/* CREATED BY:      Jesse Blocher (UNC-Chapel Hill)                                               
/* MODIFIED BY:                                                    
/* DATE CREATED:    Sept 2010                                                                                                            
/* PROG NAME:       form_ff_portfolios.sas                                                              
/* Project:         Correlations > Market Fundamentals
/* This File:       Pulls together FF Factors
/************************************************************************************/
 
%include 'corr_header.sas'; *header file with basic options and libraries;


/* Datasets required to run:
 * corr.FF_Research_Data_Factors		: YYYYMM  Mkt-RF     SMB     HML      RF
 * corr.FF_Momentum_Factor				: YYYYMM  Mom
 */

/* Datasets Produced:
 * corr.dgtw_portfolios					: Portfolio returns by permno year month
 */
 

proc contents data = corr.stocks_with_dgtw_assignments; run; 
proc contents data = corr.bench; run;  


proc sql;
	create table corrwork.dgtw_portfolios_raw as
	select a.permno, b.*
	from corr.stocks_with_dgtw_assignments as a, corr.bench as b
	where a.year = b.year and a.book_m_jun = b.book_m_jun and a.size_jun = b.size_jun and a.mom_jun = b.mom_jun;
quit;

** need to sort to transpose. goal is to move monthly returns to rows;
proc sort data = corrwork.dgtw_portfolios_raw out = corrwork.sorted_byport_permno;
by year permno book_m_jun size_jun mom_jun;
run;

* automatically transposes all numeric variables. Keep default headings because they are numeric, I think;
proc transpose 	data = corrwork.sorted_byport_permno 
				out = corrwork.dgtw_first_try (rename=(col1=dgtw_return))
				name = text_month;
	by year permno book_m_jun size_jun mom_jun;
run;

data corr.dgtw_factors (drop = date_c date2 text_month);
	set corrwork.dgtw_first_try;
	date_c = '01' || substr(text_month,1,3) || '2000';
	date2 = input(date_c,date9.);
	month = month(date2);
run;

title 'print some transposed data';
proc contents data = corr.dgtw_factors;run;
proc print data = corr.dgtw_factors (obs = 10);run;