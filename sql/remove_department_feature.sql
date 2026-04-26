-- 去部门化最小改造脚本（保留表结构，只关闭部门功能入口）
-- 建议先备份数据库后执行。

START TRANSACTION;

-- 1) 隐藏并停用部门管理菜单及按钮
UPDATE sys_menu
SET visible = '1', status = '1', update_by = 'migration', update_time = NOW()
WHERE menu_id IN (103, 1016, 1017, 1018, 1019);

-- 2) 清理角色和部门菜单的关联授权
DELETE FROM sys_role_menu
WHERE menu_id IN (103, 1016, 1017, 1018, 1019);

-- 3) 普通角色改为“仅本人数据”，避免继续按部门做数据权限
UPDATE sys_role
SET data_scope = '5', update_by = 'migration', update_time = NOW()
WHERE role_key = 'common';

-- 4) 清理普通角色的角色-部门关联
DELETE rd FROM sys_role_dept rd
INNER JOIN sys_role r ON r.role_id = rd.role_id
WHERE r.role_key = 'common';

COMMIT;

