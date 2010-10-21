/* *************************************************************************/
/* CREATED BY:      Jesse Blocher (UNC-Chapel Hill)                                               
/* MODIFIED BY:                                                    
/* DATE CREATED:    Oct 2010                                                                                                            
/* PROG NAME:       cusip_indexing.sas                                                              
/* Project:         Corr > FUnd
/* This File:       Identify 
/************************************************************************************/
 
%include 'corr_header.sas'; *header file with basic options and libraries;


/* Datasets required to run:
 * corrwork.cusip_indexingYY0MM			: Cusip, rowid, year, month simple data YY 1980 to 2009, MM 1 to 12
 * corrwork.cusips_temp					: the above concatenated together
 * corr.corr_el_YYYY0MM					: correlation matrices as edgelists

 */

/* Datasets Produced:

 */

proc sql;
	create table unique_cusips as select unique cusip from corrwork.cusips_temp;
quit;

data corrwork.unique_cusip_indices;
	set unique_cusips;
	cusip_index = _N_;
run;

proc contents data = corrwork.cusips_temp; run;

proc sql;
 create table corr.cusip_index_lookup_table as
 select a.year, a.month, a.rowid, b.cusip_index
 from
 corrwork.cusips_temp as a
 LEFT JOIN
 corrwork.unique_cusip_indices as b
 on a.cusip = b.cusip;
quit;

proc contents data = corr.corr_el_198001; run;

%macro append_el();

data corrwork.master_old_el;
	set corr.corr_el_198001;
run;
%do y=1980 %to 2009;
	%do q=1 %to 12;
		proc append base = corrwork.master_old_el data = corr.corr_el_&y.0&q ; run;
	%end;
%end;

%mend;

%append_el;

proc contents data = corrwork.master_old_el; run;

proc sql;
	create table corrtemp2   as
	select a.*, b.cusip_index as i
	from corrwork.master_old_el as a
	left join
	corr.cusip_index_lookup_table as b
	on a.col1 = b.cusip_index;
	
	create table corr.master_corr_el  as
	select a.i, b.cusip_index as j, a.col3 as w, a.col4 as t
	from corrtemp2 as a
	left join
	corr.cusip_index_lookup_table as b
	on a.col2 = b.cusip_index;
quit;

proc contents data = corr.master_corr_el; run;
proc print data = corr.master_corr_el (obs = 100); run;