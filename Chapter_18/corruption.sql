DECLARE
   l_hwm                  NUMBER;
   l_hwm_extentid         NUMBER;
   l_total_blocks         NUMBER;
   l_total_bytes          NUMBER;
   l_unused_blocks        NUMBER;
   l_unused_bytes         NUMBER;
   l_lastusedextfileid    NUMBER;
   l_lastusedextblockid   NUMBER;
   l_last_used_block      NUMBER;
   l_segment_space_mgmt   VARCHAR2 (255);
   l_unformatted_blocks   NUMBER;
   l_unformatted_bytes    NUMBER;
   l_fs1_blocks           NUMBER;
   l_fs1_bytes            NUMBER;
   l_fs2_blocks           NUMBER;
   l_fs2_bytes            NUMBER;
   l_fs3_blocks           NUMBER;
   l_fs3_bytes            NUMBER;
   l_fs4_blocks           NUMBER;
   l_fs4_bytes            NUMBER;
   l_full_blocks          NUMBER;
   l_full_bytes           NUMBER;

   CURSOR c1
   IS
      SELECT /*+
       no_merge(e) no_merge(seg)
       no_merge(ts) no_merge(c)
       leading(c e seg ts)
       use_hash(e) use_hash(seg)
       use_hash(ts) use_hash(c)
       no_swap_join_inputs(ts)
       no_swap_join_inputs(seg)
       no_swap_join_inputs(e)
        */
             e.owner
            ,e.segment_type
            ,e.segment_name
            ,e.partition_name
            ,e.extent_id
            ,c.file#
            ,GREATEST (e.block_id, c.block#) corr_start_block#
            ,LEAST (e.block_id + e.blocks - 1, c.block# + c.blocks - 1)
                corr_end_block#
            ,ts.segment_space_management
            ,CASE
                WHEN seg.segment_type IN ('TABLE'
                                         ,'TABLE PARTITION'
                                         ,'TABLE SUBPARTITION'
                                         ,'INDEX'
                                         ,'INDEX PARTITION'
                                         ,'INDEX SUBPARTITION'
                                         ,'CLUSTER')
                THEN
                   'Y'
                WHEN seg.segment_type IN ('LOB'
                                         ,'LOB PARTITION'
                                         ,'LOB SUBPARTITION')
                $IF DBMS_DB_VERSION.VER_LE_10  $THEN
                $ELSE
                AND lnnvl (seg.segment_subtype =
                                               'SECUREFILES')
                $END
                THEN
                   'Y'
                ELSE
                   'N'
             END
                AS has_high_water_mark
        FROM dba_extents e
            ,dba_segments seg
            ,dba_tablespaces ts
            ,v$database_block_corruption c
       WHERE     e.file_id = c.file#
             AND e.block_id <= c.block# + c.blocks - 1
             AND e.block_id + e.blocks - 1 >= c.block#
             AND seg.segment_name = e.segment_name
             AND seg.owner = e.owner
             AND LNNVL (e.partition_name <> seg.partition_name)
             AND seg.tablespace_name = ts.tablespace_name;
BEGIN
   FOR r IN c1
   LOOP
      IF r.has_high_water_mark = 'N'
      THEN
         DBMS_OUTPUT.put_line (
               '*** FATAL *** Segment '
            || r.owner
            || '.'
            || r.segment_name
            || ' of type '
            || r.segment_type
            || ' marked corrupt between blocks '
            || r.corr_start_block#
            || ' and '
            || r.corr_end_block#
            || ' in file '
            || r.file#
            || ' and has no high water mark');
      ELSE
         --
         -- Get the HWM data from the segment header
         --
         DBMS_SPACE.unused_space (
            segment_owner               => r.owner
           ,segment_name                => r.segment_name
           ,segment_type                => r.segment_type
           ,partition_name              => r.partition_name
           ,total_blocks                => l_total_blocks
           ,total_bytes                 => l_total_bytes
           ,unused_blocks               => l_unused_blocks
           ,unused_bytes                => l_unused_bytes
           ,last_used_extent_file_id    => l_lastusedextfileid
           ,last_used_extent_block_id   => l_lastusedextblockid
           ,last_used_block             => l_last_used_block);

         --
         --  if the segment is in an ASSM tablespace, we must use this API
         -- call to get the Low High Water Mark information
         --
         IF l_segment_space_mgmt = 'AUTO'
         THEN
            DBMS_SPACE.space_usage (r.owner
                                   ,r.segment_name
                                   ,r.segment_type
                                   ,l_unformatted_blocks
                                   ,l_unformatted_bytes
                                   ,l_fs1_blocks
                                   ,l_fs1_bytes
                                   ,l_fs2_blocks
                                   ,l_fs2_bytes
                                   ,l_fs3_blocks
                                   ,l_fs3_bytes
                                   ,l_fs4_blocks
                                   ,l_fs4_bytes
                                   ,l_full_blocks
                                   ,l_full_bytes
                                   ,r.partition_name);
            --
            -- Now adjust the High HWM to the Low HWM
            --
            l_last_used_block := l_last_used_block - l_unformatted_blocks;
         END IF;

         l_hwm := l_lastusedextblockid + l_last_used_block - 1;

         --
         -- identify the extent id of the HWM
         --
         SELECT extent_id
           INTO l_hwm_extentid
           FROM dba_extents
          WHERE     file_id = l_lastusedextfileid
                AND block_id = l_lastusedextblockid;

         IF    r.extent_id > l_hwm_extentid
            OR (r.extent_id = l_hwm_extentid AND r.corr_start_block# > l_hwm)
         THEN
            DBMS_OUTPUT.put_line (
                  '*** INFO  *** Segment '
               || r.owner
               || '.'
               || r.segment_name
               || ' of type '
               || r.segment_type
               || ' marked corrupt between blocks '
               || r.corr_start_block#
               || ' and '
               || r.corr_end_block#
               || ' in file '
               || r.file#
               || ' but is above the high water mark of file# '
               || l_lastusedextfileid
               || ' block '
               || l_hwm);
         ELSE
            DBMS_OUTPUT.put_line (
                  '*** FATAL *** Segment '
               || r.owner
               || '.'
               || r.segment_name
               || ' of type '
               || r.segment_type
               || ' marked corrupt between blocks '
               || r.corr_start_block#
               || ' and '
               || r.corr_end_block#
               || ' in file '
               || r.file#
               || ' and the corruption is below/at the high water mark of file# '
               || l_lastusedextfileid
               || ' block '
               || l_hwm);
         END IF;
      END IF;
   END LOOP;
END;
/