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
 * 
 */
 
 
proc contents data = corr.stocks_with_dgtw_assignments; run; 
proc contents data = corr.bench; run;  
/*
proc sql;
	create table corr.ff_four_factors as
	select a.col1 as yrmo, a.col2 as MktMinusRf, a.col3 as SMB, a.col4 as HML, a.col5 as Rf, b.col2 as Mom,
			substr(a.col1,1,4) as year, substr(a.col1,5,2) as month
	from corr.FF_Research_Data_Factors as a, corr.FF_Momentum_Factor as b
	where a.col1 = b.col1;
quit;