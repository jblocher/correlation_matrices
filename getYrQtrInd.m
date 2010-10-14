function datev = getYrQtrInd(startYr,endYr)
% getTimeXAxis returns a matrix where the first column is an integer index,
% the second column is a year, the third is qtr for iteratively working
% with yrqtr files.
%  
%  Parameters:
%  startYR is the start year
%  endYr is the ending year
%  Note: we do all 4 quarters. If you need less, truncate the result or
%  just don't use them.
%  
%  Returns:
%  datev: matrix with 3 columns, length (endYr-startYr+1)*4.

yr = startYr:endYr;
qtr = 1:4; 
ind = 1:(endYr-startYr+1)*4;

yrlist = repmat(yr,1,4);
sorted_yrlist = sort(yrlist);
qtrlist = repmat(qtr,1,length(yr));
datev = [ind' sorted_yrlist' qtrlist'];
