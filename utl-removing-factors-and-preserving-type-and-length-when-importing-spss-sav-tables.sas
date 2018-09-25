
Removing factors and preserving type and length when importing spss sav tables

github
https://tinyurl.com/ycfgmmc8
https://github.com/rogerjdeangelis/utl-removing-factors-and-preserving-type-and-length-when-importing-spss-sav-tables

SAS Forum
https://tinyurl.com/y8s9gd3u
https://communities.sas.com/t5/SAS-Programming/Importing-SPSS-sav-file-into-SAS-question/m-p/498744

github macros
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

INPUT
=====

 SPSS sav file

  d:/sav/utl-importing-spss-sav-tables.sav

 SAV.CLASS total obs=19

  NAME       SEX    AGE    HEIGHT    WEIGHT

  Alfred      M      14     69.0      112.5
  Alice       F      13     56.5       84.0
  Barbara     F      13     65.3       98.0
  Carol       F      14     62.8      102.5
  Henry       M      14     63.5      102.5
  ....

 VARIABLE attributes

  Variable    Type

  NAME        String    ** from sashelp.class so length is 8
  SEX         String    ** from sashelp.class so length is 1
  AGE         Numeric
  HEIGHT      Numeric
  WEIGHT      Numeric



EXAMPLE OUTPUT (SAS dataset from SPSS table)
--------------------------------------------

 WORK.WANT total obs=19

 NAME       SEX    AGE    HEIGHT    WEIGHT

 Alfred      M      14     69.0      112.5
 Alice       F      13     56.5       84.0
 Barbara     F      13     65.3       98.0
 Carol       F      14     62.8      102.5
 Henry       M      14     63.5      102.5
 James       M      12     57.3       83.0
..


 #    Variable    Type    Len

 1    NAME        Char      8  ** matches the original length (sashelp.class)
 2    SEX         Char      1  ** matches the original length (sashelp.class)
 3    AGE         Num       8
 4    HEIGHT      Num       8
 5    WEIGHT      Num       8


PROCESS
=======


* just in case;
%utlfkil(d:/sav/utl-importing-spss-sav-tables.xpt);

%utl_submit_r64('
  library(foreign);
  library(SASxport);
  want<-read.spss("d:/sav/utl-importing-spss-sav-tables.sav");
  want <- as.data.frame(lapply(want,
    function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F);
  write.xport(want,file="d:/sav/utl-importing-spss-sav-tables.xpt");
');

libname xpt xport "d:/sav/utl-importing-spss-sav-tables.xpt";

proc contents data=xpt.want position;
run;quit;

data want;
 set xpt.want;
run;quit;

proc print;
run;quit;


OUTPUT (see above)

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

* libname fails so EG weakens classic SAS;
proc export data=sashelp.class
   file="d:/sav/utl-importing-spss-sav-tables.sav"
   dbms=spss replace;
   fmtlib=library.formats;
run;quit;

*_
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
;

> library(foreign);
> library(SASxport);
> want<-read.spss("d:/sav/utl-importing-spss-sav-tables.sav");
> want <- as.data.frame(lapply(want,
>   function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F);
> write.xport(want,file="d:/sav/utl-importing-spss-sav-tables.xpt");

NOTE: 3 lines were written to file PRINT.
Stderr output:

Attaching package: 'SASxport'

The following objects are masked from 'package:foreign':

    lookup.xport, read.xport

Warning message:
package 'SASxport' was built under R version 3.3.3

In read.spss("d:/sav/utl-importing-spss-sav-tables.sav") :
  d:/sav/utl-importing-spss-sav-tables.sav: Compression bias (0) is not the usual value of 100

NOTE: 2 records were read from the infile RUT.
      The minimum record length was 2.
      The maximum record length was 290.

5303  libname xpt xport "d:/sav/utl-importing-spss-sav-tables.xpt";

NOTE: Libref XPT was successfully assigned as follows:
      Engine:        XPORT
      Physical Name: d:\sav\utl-importing-spss-sav-tables.xpt
5304  proc contents data=xpt.want position;
5305  run;

NOTE: PROCEDURE CONTENTS used (Total process time):
      real time           0.03 seconds

5305!     quit;

5306  data want;
5307   set xpt.want;
5308  run;

NOTE: There were 19 observations read from the data set XPT.WANT.
NOTE: The data set WORK.WANT has 19 observations and 5 variables.
NOTE: DATA statement used (Total process time):
      real time           0.02 seconds
5308!     quit;



