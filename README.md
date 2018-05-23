# SYSOUT Retrieval Services
SYSOUT Retrieval Services (SRS) is a product that retrieves data from
the JES spool using the SYSOUT Application Program Interface (SAPI).
SRS supports a robust set of SYSOUT selection criteria (documented
below) that can be specified by the user on the `EXEC PARM=` statement.
Using these criteria, SRS builds the necessary data structures and
calls SAPI asking for SYSOUT data that matches the selection request.
If JES finds and returns a spool data set, SRS copies the data to a
file specified by the user.

For more complex applications, SRS supports a user-written *despooler*
routine.  In this mode, SRS still processes selection criteria, and
makes the SAPI call.  But instead of writing the spool data to a file,
SRS calls the despooler routine, one record at a time, to process the
data.  The SRSJWRAP program (which is shipped with SRS) is one example
of a special despooler routine.

## History
SRS was developed by Dave Danner but he's no longer in a position to
do any changes to SRS. Dave agreed that I take over the project.

# Download
SRS is distributed as an XMIT (as usual for z/OS binaries). You can get it
from the [CBT Tape](http://www.cbttape.org/) - see [File #790](http://www.cbttape.org/ftp/cbt/CBT790.zip).
This file will contain compiled load modules and the source code. The most actual version of
SRS is here at GitHub (but no load modules).

# Invocation

SRS can be invoked from a batch job or started task as follows:

    //DESPOOL EXEC SRS,PARM='options'

*options* specify a combination of SRS control options and SYSOUT
selection criteria.  An explanation of each option follows.
Required characters are in uppercase while optional characters are
in lowercase.  For example, the DDname keyword can be specified as
DD=, DDN=, DDNA=, DDNAM=, or DDNAME=.

## The following options specify what SYSOUT to select

Option            |  Description                                                      | Default    | Example
------------------|-------------------------------------------------------------------|------------|--------
Q=*c*             | The SYSOUT class (alternative to CLASS)                           | *none*     | Q=Z
CLASS=*c*         | The SYSOUT class (alternative to Q)                               | *none*     | CLASS=Z
Jobname=*jobname* | The jobname (wild-card characters supported)                      | *none*     | JOBNAME=MYJOB
JI=*jobid*        | The 8-character JES jobid (alternative to JOBID)                  | *none*     | JI=JOB98754
JOBId=*jobid*     | The 8-character JES jobid  (alternative to JI)                    | *none*     | JOBID=JOB98754
Dest=*destid*     | The destination (or 'ALL' to select all destinations)             | *LOCAL*    | DEST=SRSDEST
Forms=*forms*     | The forms ID (or 'ALL' to select all forms)                       | *STD*      | FORMS=STDX
Writer=*writer*   | The writer name (or 'ALL' to select all writer names)             | *null*     | WRITER=SRSWTR
STATus=*status*   | The status of data sets to select ('HELD', 'NONHELD', or 'ALL')   | *NONHELD*  | STATUS=ALL
DDname=*ddname*   | The DDNAME of the spool data set (wild-card characters supported) | *none*     | DD=JES*


## The following options control SRS processing

Option            |  Description                                                                              | Default     | Example
------------------|-------------------------------------------------------------------------------------------|-------------|--------
Program=*pgnmane* | The name of the special despooler program                                                 | *SRSGENER*  | P=MYPROG
PPARM=*parms*     | Parameter list passed to the despooler program (must be enclosed in parentheses)          | *none*      | PPARM=(FOO=BA)
LIMit=*lim*       | The maximum number of output groups to select (1-9999)                                    | *unlimited* | LIMIT=42
WAIT=*wait*       | Whether SRS is to wait for data sets or end when no more spool data sets remain to select | *NO if invoked in batch; YES if STC* | WAIT=YES
DISP=*disp*       | The disposition of selected spool data sets ('KEEP' or 'DELETE')                          | *DELETE*    | DISP=KEEP
SEP=*opt*         | Specifies whether separator records are to be written to the output data stream prior to the actual SYSOUT data (valid options are 'JOB', 'OUTGRP', 'YES', 'DATASET', 'DS' or 'NO')  | *NO*       | SEP=JOB
SEPId=*sepid*     | Specifies a one to eight byte character string that can be used to identify separator records.  <sepid> will appear at the beginning of each separator                               | **SRS>*    | SEPID=**SEP**
OPTs=*options*    | Specifies a one or two character suffix that is appended to 'SRSOPT' to form the options module name.  The options module must be accessible (STEPLIB, link list, etc.) and must have been created using a current version of the SRSOPTS macro  | *S* (uses module SRSOPTS)  | OPTS=99 (uses module SRSOPT99)

### Description of valid values for option SEP

Value             |  Description                                                                              
------------------|----------------------------
NO                | No separator records are produced
JOB               | Writes a record containing the job name and JOBID before each job's selected SYSOUT
OUTGRP or YES     | Writes a record containing (in addition to the JOB record) the SYSOUT class, destination, writer name, forms name, and output group name before each output group's selected SYSOUT
DATASET or DS     | Writes a record containing (in addition to the OUTGRP record) the DDNAME before each data set's selected SYSOUT

## Parameters for despooler SRSGENER

The following options can be specified on the PPARM= keyword if default processing (i.e. no special despooler program, wich means SRSGENER) is in effect.

Option            | Description   | Default   
------------------|---------------|---------
OUTFILE=*file*    | Specifies the DDNAME of the data set to write spool data records to | *SYSUT2* 
DEFER_OPEN=*yn*   | Specifies whether the OUTFILE= file should be opened at SRS initialization or after the first record is despooled.  If 'YES' is specified and the OUTFILE= file is a new data set that does not specify LRECL information, SRS will use the record length of the first record despooled as the LRECL.  If 'NO', LRECL must be specified on the OUTFILE= file or a S013-34 abend will occur. | *YES*

# SYSOUT Application Program Interface (SAPI)
See https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.ieaf200/sapi.htm for a complete documentation
of the SAPI.
