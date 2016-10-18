README.txt

Welcome to the example code for Expert Oracle SQL!

The listings in my book are best used with Oracle 12.1.0.1 and use the sample schemas extensively.

Installing Sample Schemas
-------------------------

There are two ways to install the sample schemas. The first is to install them as part of database creation
with DBCA. If you already have a database you can install the sample schemas by downloading them
from:

http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html

You can then accept the license agreement and select "show all" against the operating system
of your choice and look for a zipfile with a name like "12c examples".  Once you have downloaded and unzipped
these files you can follow the instructions in the manual entitled "Sample Schemas".

Running Expert Oracle SQL examples for the first time
-----------------------------------------------------

If you are running Windows, the best way to get started is to find the file "examples_setup.bat" in my Install directory
and run that by double-clicking in an explorer window. This will:

	- Create a user called "book" with suitable privileges
	- Install the SCOTT schema
	- Set db_file_multiblock_read_count to 128 as recommended in the book
	- Delete any system statistics
	- Import statistics for the sample schemas so that execution plans are reproducible

Running the listings in a chapter
---------------------------------

The supplied scripts are setup in a way to allow you to run each chapter independently but sometimes one
listing in a chapter uses objects created by a listing that appears earlier in the chapter. You can run all
the listings in a chapter in sequence from SQL*Plus by using the "chapter_n_all_listings.sql" script; you will
be prompted at the start of each listing.

After the initial setup you should proably connect using book/book. There are only a couple of special cases
where you need SYSDBA.

Bonus scripts
-------------

There is a bonus script corruption.sql in the chapter_18 folder and a bonus script hybrid_hash.sql in the chapter_11
folder. These are explained in the book.

12.1.0.1 bug
------------

There is a bug in 12.1.0.1 that causes join cardinalities to be calculated incorrectly when the
HIGH_VALUE and LOW_VALUE column statistics are NULL. The code in chapter_20\tstats_package_body.sql
contains a workaround that conditionally uses very high and very low values in place of NULL.

Good Luck

--Tony


