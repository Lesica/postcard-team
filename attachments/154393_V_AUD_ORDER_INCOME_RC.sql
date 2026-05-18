/*
 * Запрос на анализ по инциденту по V_AUD_ORDER_INCOME_RC от kravchenko_sd@magnit.ru
 * Таблица сверки заявок и приходов РЦ
 */




SHOW VIEW PRD_VD_DM.V_AUD_ORDER_INCOME_RC
/*
REPLACE VIEW PRD_VD_DM.V_AUD_ORDER_INCOME_RC
     AS 
   LOCK ROW FOR ACCESS
 SELECT d.cntr_id                AS CNTR_ID
      , c.cntr_guid              AS CNTR_GUID
      , d.whs_id                 AS WHS_ID
      , w.whs_guid               AS WHS_GUID
      , d.art_id                 AS ART_ID
      , ae.art_guid              AS ART_GUID
      , au.art_unified_id        AS ART_UNIFIED_ID
      , aee.art_guid             AS ART_UNIFIED_GUID
      , d.order_id               AS ORDER_ID
      , d.order_guid             AS ORDER_GUID
      , d.order_num              AS ORDER_NUM
      , d.order_dt               AS ORDER_DT
      , d.order_doc_dt           AS ORDER_DOC_DT
      , d.order_status           AS ORDER_STATUS
      , d.order_qnty             AS ORDER_QNTY
      , d.order_opsum            AS ORDER_OPSUM
      , d.order_price            AS ORDER_PRICE
      , d.income_id              AS INCOME_ID
      , d.income_guid            AS INCOME_GUID
      , d.income_num             AS INCOME_NUM
      , d.income_dt              AS INCOME_DT
      , d.income_opsum           AS INCOME_OPSUM
      , d.income_price           AS INCOME_PRICE
      , d.income_qnty            AS INCOME_QNTY
      , d.income_reg_dt          AS INCOME_REG_DT
      , d.canceled_reason        AS CANCELED_REASON
      , d.canceled_dtm           AS CANCELED_DTM
      , d.over_income_qnty       AS OVER_INCOME_QNTY
      , d.over_income_opsum      AS OVER_INCOME_OPSUM
      , d.ordrsp_id              AS ORDRSP_ID
      , d.ordrsp_num             AS ORDRSP_NUM
      , d.ordrsp_dt              AS ORDRSP_DT
      , d.ordrsp_doc_dt          AS ORDRSP_DOC_DT
      , d.ordrsp_status          AS ORDRSP_STATUS
      , d.ordrsp_qnty            AS ORDRSP_QNTY
      , d.ordrsp_opsum           AS ORDRSP_OPSUM
      , d.ordrsp_begin_id        AS ORDRSP_BEGIN_ID
      , d.ordrsp_begin_num       AS ORDRSP_BEGIN_NUM
      , d.ordrsp_begin_dt        AS ORDRSP_BEGIN_DT
      , d.ordrsp_begin_doc_dt    AS ORDRSP_BEGIN_DOC_DT
      , d.ordrsp_begin_status    AS ORDRSP_BEGIN_STATUS
      , d.ordrsp_begin_qnty      AS ORDRSP_BEGIN_QNTY
      , d.ordrsp_begin_opsum     AS ORDRSP_BEGIN_OPSUM
      , d.is_order_split         AS IS_ORDER_SPLIT
      , d.send_type              AS SEND_TYPE
      , d.invoice_num            AS INVOICE_NUM
      , d.order_income_type_id   AS ORDER_INCOME_TYPE_ID
      , d.is_order_income        AS IS_ORDER_INCOME
      , d.notify_price           AS NOTIFY_PRICE
      , d.notify_begin_dt        AS NOTIFY_BEGIN_DT
      , d.notify_end_dt          AS NOTIFY_END_DT
      , d.notify_insert_dtm      AS NOTIFY_INSERT_DTM
      , d.is_exw                 AS IS_EXW
      , d.is_exw_fresh           AS IS_EXW_FRESH
      , r.name                   AS SHORTAGE_REASON_NAME
      , d.shortage_id            AS SHORTAGE_ID
      , d.is_transit             AS IS_TRANSIT
      , oap.is_promo             AS IS_PROMO
      , oap.src_change_dtm       AS PROMO_DTM
      , d.calc_dt                AS CALC_DT
   FROM prd_db_dm.d_aud_order_income_rc          AS d
   JOIN prd_vd_dm.v_cntr                         AS c   ON c.cntr_id  = d.cntr_id
   JOIN prd_vd_dm.v_warehouse                    AS w   ON w.whs_id   = d.whs_id
   JOIN prd_vd_dm.v_art                          AS ae  ON ae.art_id  = d.art_id
   LEFT JOIN prd_vd_dm.v_art_unified             AS au  ON au.art_id  = d.art_id
   LEFT JOIN prd_vd_dm.v_art                     AS aee ON aee.art_id = au.art_unified_id
   LEFT JOIN prd_vd_dm.v_oprt_art_promo_lnk      AS oap ON d.order_id = oap.oprt_id
                                                       AND d.art_id   = oap.art_id
   LEFT JOIN prd_vd_dm.v_sp_oprt_shortage_reason AS r   ON r.shortage_id = d.shortage_id;
*/

HELP TABLE PRD_VD_DM.V_AUD_ORDER_INCOME_RC;
/*
Column Name                   |Type|Comment                                                                                    
------------------------------+----+-------------------------------------------------------------------------------------------
CNTR_ID                       |    |ID поставщика ТС                                                                           
CNTR_GUID                     |    |GUID поставщика ТС                                                                         
WHS_ID                        |    |ID МХ                                                                                      
WHS_GUID                      |    |GUID МХ                                                                                    
ART_ID                        |    |ID ТП                                                                                      
ART_GUID                      |    |GUID ТП                                                                                    
ART_UNIFIED_ID                |    |ID ТП аналога                                                                              
ART_UNIFIED_GUID              |    |GUID ТП аналога                                                                            
ORDER_ID                      |    |ID операции Заявка                                                                         
ORDER_GUID                    |    |GUID операции Заявка                                                                       
ORDER_NUM                     |    |Номер операции Заявка                                                                      
ORDER_DT                      |    |Дата операции Заявка (дата ожидаемого прихода)                                             
ORDER_DOC_DT                  |    |Дата документа заведения операции Заявка                                                   
ORDER_STATUS                  |    |Статус операции Заявка                                                                     
ORDER_QNTY                    |    |Количество товара в заявке                                                                 
ORDER_OPSUM                   |    |Сумма в рублях по операции Заявка                                                          
ORDER_PRICE                   |    |Цена товара в заявке                                                                       
INCOME_ID                     |    |ID операции Приход                                                                         
INCOME_GUID                   |    |GUID операции Приход                                                                       
INCOME_NUM                    |    |Номер операции Приход                                                                      
INCOME_DT                     |    |Дата операции Приход                                                                       
INCOME_OPSUM                  |    |Сумма в рублях по операции Приход                                                          
INCOME_PRICE                  |    |Цена ТП в операции Приход                                                                  
INCOME_QNTY                   |    |Приход, шт.                                                                                
INCOME_REG_DT                 |    |Дата регистрации на РЦ к Приходу( id = 24889)                                              
CANCELED_REASON               |    |Причина обнуления                                                                          
CANCELED_DTM                  |    |Дата и время обнуления                                                                     
OVER_INCOME_QNTY              |    |Количество товара операции Недовоз/перевоз от поставщика (Если перевоз , то значение больше
OVER_INCOME_OPSUM             |    |Сумма в рублях по операции Недовоз/перевоз от поставщика (Если перевоз , то значение больше
ORDRSP_ID                     |    |ID операции ORDRSP                                                                         
ORDRSP_NUM                    |    |Номер операции ORDRSP                                                                      
ORDRSP_DT                     |    |Дата операции ORDRSP                                                                       
ORDRSP_DOC_DT                 |    |Дата документа заведения операции ORDRSP                                                   
ORDRSP_STATUS                 |    |Статус операции ORDRSP                                                                     
ORDRSP_QNTY                   |    |Количество товара по операции ORDRSP                                                       
ORDRSP_OPSUM                  |    |Сумма в рублях по операции ORDRSP                                                          
ORDRSP_BEGIN_ID               |    |ID первичной операции ORDRSP                                                               
ORDRSP_BEGIN_NUM              |    |Номер первичной операции ORDRSP                                                            
ORDRSP_BEGIN_DT               |    |Дата первичной операции ORDRSP                                                             
ORDRSP_BEGIN_DOC_DT           |    |Дата документа заведения первичной операции ORDRSP                                         
ORDRSP_BEGIN_STATUS           |    |Статус первичной операции ORDRSP                                                           
ORDRSP_BEGIN_QNTY             |    |Количество товара в первичной операции ORDRSP                                              
ORDRSP_BEGIN_OPSUM            |    |Сумма в рублях по первичной операции ORDRSP                                                
IS_ORDER_SPLIT                |    |Признак деления заказа (1 - разделен, 0 - нет)                                             
SEND_TYPE                     |    |Тип отправки(доп поле заявки): edi,почта                                                   
INVOICE_NUM                   |    |Номер товарной накладной (ТН)                                                              
ORDER_INCOME_TYPE_ID          |    |Тип связи заявки с приходом                                                                
IS_ORDER_INCOME               |    |Признак связи заявки с приходом (1 - есть, 0 - нет)                                        
NOTIFY_PRICE                  |    |Цена из ЦУ                                                                                 
NOTIFY_BEGIN_DT               |    |Дата начала действия ЦУ                                                                    
NOTIFY_END_DT                 |    |Дата окончания действия ЦУ                                                                 
NOTIFY_INSERT_DTM             |    |Дата и время добавления ЦУ В источник                                                      
IS_EXW                        |    |Признак самовывоза                                                                         
IS_EXW_FRESH                  |    |Признак самовывоза для ФРЕШ                                                                
SHORTAGE_REASON_NAME          |    |Причина недопоставки / корректировки заказа                                                
SHORTAGE_ID                   |    |Идентификатор причины недопоставки                                                         
IS_TRANSIT                    |    |Признак транзитного заказа                                                                 
IS_PROMO                      |    |Признак промо ТП в заявке                                                                  
PROMO_DTM                     |    |Время изменения признака промо ТП в заявке                                                 
CALC_DT                       |    |Дата расчета                                                                               
*/

SELECT order_id, art_id, COUNT(*)
FROM PRD_VD_DM.v_oprt_art_promo_lnk
GROUP BY order_id, art_id
HAVING COUNT(*) > 1
SAMPLE 10;
/*
SQL Error [5628] [HY000]: [Teradata Database] [TeraJDBC 17.00.00.03] [Error 5628] [SQLState HY000] Column order_id not found in PRD_VD_DM.v_oprt_art_promo_lnk.*/

SELECT art_id, COUNT(*) FROM PRD_VD_DM.v_art_unified
GROUP BY art_id HAVING COUNT(*) > 1 SAMPLE 100;
-- empty

SELECT UserName, SpoolSpace, TempSpace, PermSpace
FROM DBC.UsersV WHERE UserName='svc_claim_infa';
/*
 * UserName|SpoolSpace|TempSpace|PermSpace|
--------+----------+---------+---------+
 */


LOCK TABLE PRD_VD_DM.v_oprt_art_promo_lnk FOR ACCESS
SELECT oprt_id, art_id, COUNT(*)
FROM PRD_VD_DM.v_oprt_art_promo_lnk
GROUP BY oprt_id, art_id
HAVING COUNT(*) > 1
SAMPLE 10;
/*
OPRT_ID|ART_ID|Count(*)|
-------+------+--------+
 */


б) Структура v_oprt_art_promo_lnk:
-- Витрина линка дополнительных атрибутов ТП в операции (признак промо)
HELP TABLE PRD_VD_DM.v_oprt_art_promo_lnk;
/*
Column Name                   |Type|Comment                                 |Nu
------------------------------+----+----------------------------------------+--
OPRT_ID                       |    |ID операции                             |  
SRC_CHANGE_DTM                |    |Дата/время изменения записи на источнике|  
ART_ID                        |    |ID товара                               |  
IS_PROMO                      |    |Признак промо ТП в заявке               |  
 */

в) То же для v_art_unified:

SHOW VIEW PRD_VD_DM.v_art_unified;
/*
REPLACE VIEW PRD_VD_DM.V_ART_UNIFIED AS 
SELECT am.ART_ID
     , aul.DWH_ART_UNIFIED_ID                AS ART_UNIFIED_ID       
     , ae.IS_NORMALIZED 
     , af.CGRT_MAX_SALE_PRICE
     , af.CGRT_MAX_SALE_PRICE_APPLY_DT
  FROM PRD_VD_DM.V_ART_MDM am
  LEFT JOIN PRD_VD_DM.V_ART_EXT ae ON ae.ART_ID = am.ART_ID
  LEFT JOIN PRD_VD_RDV.V_ART_UNIFIED_L aul ON aul.DWH_ART_ID = am.ART_ID    
  LEFT JOIN PRD_VD_RDV.V_ART_UNIFIED_LS auls ON auls.DWH_ART_UNIFIED_L_ID = aul.DWH_ART_UNIFIED_L_ID
                                            AND aul.DWH_REC_STATUS = 1
                                            AND auls.DWH_REC_STATUS = 1
                                            AND auls.SRC_ACTN_TYPE <> 'D' 
  LEFT JOIN PRD_VD_DM.V_ART_MDM_FACET_PIVOT af ON af.ART_ID = am.ART_ID
 WHERE am.IS_UNIFIED = 0 
QUALIFY ROW_NUMBER() OVER (PARTITION BY am.ART_ID ORDER BY auls.SRC_CHANGE_DTM DESC) = 1
 */


EXPLAIN SELECT * FROM PRD_VD_DM.V_AUD_ORDER_INCOME_RC
WHERE income_dt = DATE '2026-05-09';
/*
Explanation                                                             |
------------------------------------------------------------------------+
 This request is eligible for incremental planning and execution (IPE)  |
 but does not meet cost thresholds. The following is the static plan    |
 for the request.                                                       |
  1) First, we lock prd_db_dm.d_whs in view                             |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC in TD_MAP1 for access, we lock     |
     prd_db_dm.d in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC in TD_MAP1 for |
     access, we lock prd_db_dm.d in view                                |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC in TD_MAP1 for access, we lock     |
     PRD_DB_DM.D_CNTR in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC in        |
     TD_MAP1 for access, we lock prd_db_dm.da in view                   |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC in TD_MAP1 for access, we lock     |
     prd_db_rdv.l in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC in TD_MAP1    |
     for access, we lock PRD_DB_RDV.hs in view                          |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC in TD_MAP1 for access, we lock     |
     PRD_DB_RDV.h in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC in TD_MAP1    |
     for access, we lock prd_db_rdv.T_ART_UNIFIED_LS in view            |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC in TD_MAP1 for access, and we lock |
     prd_db_rdv.T_ART_UNIFIED_L in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC |
     in TD_MAP1 for access.                                             |
  2) Next, we do an all-AMPs JOIN step in TD_MAP1 from                  |
     prd_db_rdv.T_ART_UNIFIED_L in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC |
     by way of a RowHash match scan with no residual conditions, which  |
     is joined to prd_db_rdv.T_ART_UNIFIED_LS in view                   |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC by way of a RowHash match scan     |
     with a condition of ("(prd_db_rdv.T_ART_UNIFIED_LS in view         |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC.DWH_REC_STATUS = 1) AND            |
     (prd_db_rdv.T_ART_UNIFIED_LS in view                               |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC.SRC_ACTN_TYPE <> 'D')").           |
     prd_db_rdv.T_ART_UNIFIED_L and prd_db_rdv.T_ART_UNIFIED_LS are     |
     left outer joined using a merge join, with condition(s) used for   |
     non-matching on left table (                                       |
     "(prd_db_rdv.T_ART_UNIFIED_L.DWH_REC_STATUS = 1) AND (NOT          |
     (prd_db_rdv.T_ART_UNIFIED_L.DWH_ART_UNIFIED_L_ID IS NULL ))"),     |
     with a join condition of (                                         |
     "prd_db_rdv.T_ART_UNIFIED_LS.DWH_ART_UNIFIED_L_ID =                |
     prd_db_rdv.T_ART_UNIFIED_L.DWH_ART_UNIFIED_L_ID").  The result     |
     goes into Spool 4 (all_amps) (compressed columns allowed), which   |
     is redistributed by the hash code of (                             |
     prd_db_rdv.T_ART_UNIFIED_L.DWH_ART_ID) to all AMPs in TD_Map1.     |
     Then we do a SORT to order Spool 4 by row hash.  The size of Spool |
     4 is estimated with low confidence to be 5,436 rows (168,516       |
     bytes).  The estimated time for this step is 0.00 seconds.         |
  3) We do an all-AMPs JOIN step in TD_MAP1 from prd_db_dm.d in view    |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC by way of a RowHash match scan     |
     with a condition of ("prd_db_dm.d in view                          |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC.IS_UNIFIED = 0"), which is joined  |
     to Spool 4 (Last Use) by way of a RowHash match scan.  prd_db_dm.d |
     and Spool 4 are left outer joined using a merge join, with         |
     condition(s) used for non-matching on left table ("NOT             |
     (prd_db_dm.d.ART_ID IS NULL)"), with a join condition of (         |
     "DWH_ART_ID = prd_db_dm.d.ART_ID").  The result goes into Spool 3  |
     (all_amps) (compressed columns allowed), which is built locally on |
     the AMPs.  The size of Spool 3 is estimated with low confidence to |
     be 15,004 rows (495,132 bytes).  The estimated time for this step  |
     is 0.08 seconds.                                                   |
  4) We do an all-AMPs STAT FUNCTION step in TD_Map1 from Spool 3 (Last |
     Use) by way of an all-rows scan into Spool 7 (Last Use), which is  |
     built locally on the AMPs in TD_Map1.  The result rows are put     |
     into Spool 5 (all_amps) (compressed columns allowed), which is     |
     built locally on the AMPs.  The size is estimated with low         |
     confidence to be 15,004 rows (675,180 bytes).                      |
  5) We do an all-AMPs RETRIEVE step in TD_Map1 from Spool 5 (Last Use) |
     by way of an all-rows scan with a condition of ("(Field_4          |
     (DECIMAL(18,0)))= 1.") into Spool 1 (used to materialize view,     |
     derived table, table function or table operator au) (all_amps)     |
     (compressed columns allowed), which is built locally on the AMPs.  |
     The size of Spool 1 is estimated with low confidence to be 15,004  |
     rows (435,116 bytes).  The estimated time for this step is 0.00    |
     seconds.                                                           |
  6) We do an all-AMPs RETRIEVE step in TD_Map1 from Spool 1 (Last Use) |
     by way of an all-rows scan into Spool 10 (all_amps) (compressed    |
     columns allowed), which is duplicated on all AMPs in TD_Map1.  The |
     size of Spool 10 is estimated with low confidence to be 8,642,304  |
     rows (181,488,384 bytes).  The estimated time for this step is     |
     0.07 seconds.                                                      |
  7) We do an all-AMPs JOIN step in TD_Map1 from Spool 10 (Last Use) by |
     way of an all-rows scan, which is joined to prd_db_dm.d in view    |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC by way of an all-rows scan with a  |
     condition of ("prd_db_dm.d in view                                 |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC.INCOME_DT = DATE '2026-05-09'").   |
     Spool 10 and prd_db_dm.d are right outer joined using a dynamic    |
     hash join, with condition(s) used for non-matching on right table  |
     ("NOT (prd_db_dm.d.ART_ID IS NULL)"), with a join condition of (   |
     "ART_ID = prd_db_dm.d.ART_ID").  The result goes into Spool 11     |
     (all_amps) (compressed columns allowed), which is built locally on |
     the AMPs.  Then we do a SORT to order Spool 11 by the hash code of |
     (prd_db_dm.d.ORDER_ID, prd_db_dm.d.ART_ID).  The size of Spool 11  |
     is estimated with no confidence to be 2,881,885 rows (             |
     2,639,806,660 bytes).  The estimated time for this step is 0.43    |
     seconds.                                                           |
  8) We execute the following steps in parallel.                        |
       1) We do an all-AMPs RETRIEVE step in TD_MAP1 from prd_db_dm.da  |
          in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC by way of an all-rows |
          scan with no residual conditions split into Spool 13          |
          (all_amps) with a condition of ("ART_ID IN (:*) OR (ART_ID IN |
          (:*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*,  |
          :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*,   |
          :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*,   |
          :*, :*, :*, :*))") to qualify rows matching skewed rows of    |
          the skewed relation (compressed columns allowed) and Spool 14 |
          (all_amps) with remaining rows (compressed columns allowed).  |
          Spool 13 is duplicated on all AMPs in TD_Map1.  Then we do a  |
          SORT to order Spool 13 by row hash.  The size of Spool 13 is  |
          estimated with high confidence to be 28,800 rows.  Spool 14   |
          is built locally on the AMPs.  The size of Spool 14 is        |
          estimated with high confidence to be 1,304,570 rows.  The     |
          estimated time for this step is 0.02 seconds.                 |
       2) We do an all-AMPs JOIN step in TD_Map1 from Spool 11 (Last    |
          Use) by way of a RowHash match scan, which is joined to       |
          prd_db_rdv.l in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC by way   |
          of a RowHash match scan with a condition of ("prd_db_rdv.l in |
          view PRD_VD_DM.V_AUD_ORDER_INCOME_RC.DWH_REC_STATUS = 1").    |
          Spool 11 and prd_db_rdv.l are left outer joined using a merge |
          join, with condition(s) used for non-matching on left table ( |
          "(NOT (ORDER_ID IS NULL )) AND (NOT (ART_ID IS NULL ))"),     |
          with a join condition of ("(ORDER_ID =                        |
          prd_db_rdv.l.DWH_OPRT_ID) AND (ART_ID =                       |
          prd_db_rdv.l.DWH_ART_ID)").  The result is split into Spool   |
          15 (all_amps) with a condition of ("ART_UNIFIED_ID IN (:*) OR |
          (ART_UNIFIED_ID IN (:*, :*, :*, :*, :*, :*, :*, :*, :*, :*,   |
          :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*,   |
          :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*, :*,   |
          :*, :*, :*, :*, :*, :*, :*, :*, :*))") to qualify skewed rows |
          and Spool 16 (all_amps) with remaining rows.  Spool 15 is     |
          built locally on the AMPs.  Then we do a SORT to order Spool  |
          15 by row hash.  The size of Spool 15 is estimated with no    |
          confidence to be 2,881,339 rows (2,671,001,253 bytes).  Spool |
          16 is redistributed by hash code to all AMPs in TD_Map1.      |
          Then we do a SORT to order Spool 16 by row hash.  The size of |
          Spool 16 is estimated with no confidence to be 546 rows (     |
          506,142 bytes).  The estimated time for this step is 0.23     |
          seconds.                                                      |
  9) We do an all-AMPs JOIN step in TD_Map1 from Spool 13 (Last Use) by |
     way of a RowHash match scan, which is joined to Spool 15 (Last     |
     Use) by way of a RowHash match scan.  Spool 13 and Spool 15 are    |
     right outer joined using a merge join, with condition(s) used for  |
     non-matching on right table ("NOT (ART_UNIFIED_ID IS NULL)"), with |
     a join condition of ("ART_ID = ART_UNIFIED_ID").  The result goes  |
     into Spool 17 (all_amps), which is redistributed by the hash code  |
     of (prd_db_dm.d.CNTR_ID) to all AMPs in TD_Map1.  The size of      |
     Spool 17 is estimated with no confidence to be 2,881,339 rows (    |
     2,855,406,949 bytes).  The estimated time for this step is 0.03    |
     seconds.                                                           |
 10) We do an all-AMPs JOIN step in TD_Map1 from Spool 16 (Last Use) by |
     way of a RowHash match scan, which is joined to Spool 14 (Last     |
     Use) by way of a RowHash match scan.  Spool 16 and Spool 14 are    |
     left outer joined using a merge join, with condition(s) used for   |
     non-matching on left table ("NOT (ART_UNIFIED_ID IS NULL)"), with  |
     a join condition of ("ART_ID = ART_UNIFIED_ID").  The result goes  |
     into Spool 17 (all_amps), which is redistributed by the hash code  |
     of (prd_db_dm.d.CNTR_ID) to all AMPs in TD_Map1.  The size of      |
     Spool 17 is estimated with no confidence to be 546 rows (541,086   |
     bytes).  The estimated time for this step is 0.66 seconds.         |
 11) We do an all-AMPs JOIN step in TD_MAP1 from prd_db_dm.da in view   |
     PRD_VD_DM.V_AUD_ORDER_INCOME_RC by way of an all-rows scan with no |
     residual conditions, which is joined to Spool 17 (Last Use) by way |
     of an all-rows scan locking prd_db_dm.da for access.  prd_db_dm.da |
     and Spool 17 are joined using a single partition in-memory hash    |
     join, with a join condition of ("prd_db_dm.da.ART_ID = ART_ID").   |
     The result goes into Spool 20 (all_amps) (compressed columns       |
     allowed) fanned out into 11 hash join partitions, which is built   |
     locally on the AMPs.  Spool 20 is built as in-memory optimized     |
     spool with 3 column partitions.  The size of Spool 20 is estimated |
     with no confidence to be 2,881,885 rows (3,063,443,755 bytes).     |
     The estimated time for this step is 0.15 seconds.                  |
 12) We do an all-AMPs RETRIEVE step in TD_MAP1 from PRD_DB_DM.C in     |
     view PRD_VD_DM.V_AUD_ORDER_INCOME_RC by way of an all-rows scan    |
     with no residual conditions locking for access into Spool 21       |
     (all_amps) (compressed columns allowed) fanned out into 11 hash    |
     join partitions, which is duplicated on all AMPs in TD_Map1.       |
     Spool 21 is built as in-memory optimized spool with 3 column       |
     partitions.  The size of Spool 21 is estimated with high           |
     confidence to be 125,493,696 rows (10,666,964,160 bytes).  The     |
     estimated time for this step is 1.27 seconds.                      |
 13) We do an all-AMPs JOIN step in TD_Map1 from Spool 20 (Last Use),   |
     which is joined to Spool 21 (Last Use).  Spool 20 and Spool 21 are |
     joined using a in-memory hash join of 11 partitions, with a join   |
     condition of ("CNTR_ID = CNTR_ID").  The result goes into Spool 22 |
     (all_amps) (compressed columns allowed) fanned out into 11 hash    |
     join partitions, which is built locally on the AMPs.  Spool 22 is  |
     built as in-memory optimized spool with 3 column partitions.  The  |
     size of Spool 22 is estimated with no confidence to be 2,881,885   |
     rows (3,247,884,395 bytes).  The estimated time for this step is   |
     0.28 seconds.                                                      |
 14) We execute the following steps in parallel.                        |
      1) We do an all-AMPs RETRIEVE step in TD_MAP1 from prd_db_dm.w in |
         view PRD_VD_DM.V_AUD_ORDER_INCOME_RC by way of an all-rows     |
         scan with a condition of ("((prd_db_dm.w in view               |
         PRD_VD_DM.V_AUD_ORDER_INCOME_RC.FRMT_ID <> 1) OR (prd_db_dm.w  |
         in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC.WHS_LEVEL_ID <= 2 ))   |
         AND (((prd_db_dm.w in view                                     |
         PRD_VD_DM.V_AUD_ORDER_INCOME_RC.FRMT_ID <> 3) OR (prd_db_dm.w  |
         in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC.WHS_LEVEL_ID <= 2 ))   |
         AND ((prd_db_dm.w in view                                      |
         PRD_VD_DM.V_AUD_ORDER_INCOME_RC.FRMT_ID <> 2) OR (prd_db_dm.w  |
         in view PRD_VD_DM.V_AUD_ORDER_INCOME_RC.WHS_LEVEL_ID <= 2 )))")|
         locking for access into Spool 23 (all_amps) (compressed        |
         columns allowed) fanned out into 11 hash join partitions,      |
         which is duplicated on all AMPs in TD_Map1.  Spool 23 is built |
         as in-memory optimized spool with 3 column partitions.  The    |
*/