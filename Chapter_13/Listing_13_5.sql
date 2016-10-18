SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ no_eliminate_join(parent_tab) */
               nested_tab.document_typ, COUNT (*) cnt
          FROM pm.print_media parent_tab
              ,TABLE (parent_tab.ad_textdocs_ntab) nested_tab
      GROUP BY nested_tab.document_typ;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT /*+   eliminate_join(parent_tab) */
              nested_tab.document_typ, COUNT (*) cnt
          FROM pm.print_media parent_tab
              ,TABLE (parent_tab.ad_textdocs_ntab) nested_tab
      GROUP BY nested_tab.document_typ;

SELECT * FROM TABLE (DBMS_XPLAN.display);