.timer on
-- Create a table with 1 million rows
CREATE TABLE test(id INTEGER, val TEXT);
BEGIN TRANSACTION;
WITH RECURSIVE c(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM c WHERE x<1000000)
INSERT INTO test SELECT x, hex(randomblob(16)) FROM c;
COMMIT;

-- Run a complex query that forces a full table scan and string manipulation
SELECT COUNT(*) FROM test WHERE val LIKE '%A%B%C%';

-- Run a math-heavy query
SELECT SUM(id * id) FROM test;
