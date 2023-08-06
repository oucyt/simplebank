-- 错误的删除顺序导致降级失败
-- 2023/08/05 16:54:44 Applying all down migrations
-- 2023/08/05 16:54:44 Start buffering 1/d init_schema
-- 2023/08/05 16:54:44 Read and execute 1/d init_schema
-- 2023/08/05 16:54:44 error: migration failed: cannot drop table accounts because other objects depend on it, constraint entries_account_id_fkey on table entries depends on table accounts
-- constraint transfers_from_account_id_fkey on table transfers depends on table accounts
-- constraint transfers_to_account_id_fkey on table transfers depends on table accounts in line 0: DROP TABLE IF EXISTS accounts;
-- DROP TABLE IF EXISTS entries;
-- DROP TABLE IF EXISTS transfers; (details: pq: cannot drop table accounts because other objects depend on it)
-- DROP TABLE IF EXISTS accounts;
-- DROP TABLE IF EXISTS entries;
-- DROP TABLE IF EXISTS transfers;
DROP TABLE IF EXISTS entries;
DROP TABLE IF EXISTS transfers;
DROP TABLE IF EXISTS accounts;