BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET workarea_size_policy=manual';

   EXECUTE IMMEDIATE 'ALTER SESSION SET sort_area_size=2147483647';
END;
/

ALTER SESSION SET workarea_size_policy=auto;