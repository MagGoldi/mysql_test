-- Транзакции 3. Незафиксированные изменения
-- Продемонстрировать возможность чтения незафиксированных изменений при 
-- использовании уровня изоляции READ UNCOMMITTED и отсутствие такой возможности 
-- при уровне изоляции READ COMMITTED.

---------------------------------------------------------------------------------
USE parks_management;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;

	INSERT INTO maintenance (tree_id, volunteer_id, maintenance_date, work_notes)
	VALUES (1, 1, '2024-11-27', '{"task":"test123"}');

    SELECT * FROM maintenance;

commit;
rollback;
---------------------------------------------------------------------------------
USE parks_management;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;

	INSERT INTO maintenance (tree_id, volunteer_id, maintenance_date, work_notes)
	VALUES (2, 2, '2024-11-27', '{"task":"test123"}');

	SELECT * FROM maintenance;

commit;
rollback;
---------------------------------------------------------------------------------

