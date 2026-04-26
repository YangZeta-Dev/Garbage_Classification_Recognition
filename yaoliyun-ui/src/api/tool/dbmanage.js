import request from '@/utils/request'

// 查询数据库表列表
export function listTables(query) {
  return request({
    url: '/tool/dbmanage/tables',
    method: 'get',
    params: query
  })
}

// 查询数据库表详细
export function getTableInfo(tableName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName,
    method: 'get'
  })
}

// 查询表字段信息
export function getTableColumns(tableName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/columns',
    method: 'get'
  })
}

// 查询表索引信息
export function getTableIndexes(tableName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/indexes',
    method: 'get'
  })
}

// 获取表创建SQL
export function getCreateTableSql(tableName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/sql',
    method: 'get'
  })
}

// 新增数据库表
export function addTable(data) {
  return request({
    url: '/tool/dbmanage/table',
    method: 'post',
    data: data
  })
}

// 通过SQL创建表
export function addTableBySql(sql) {
  return request({
    url: '/tool/dbmanage/table/sql',
    method: 'post',
    data: { sql: sql }
  })
}

// 修改数据库表
export function updateTable(data) {
  return request({
    url: '/tool/dbmanage/table/' + data.tableName + '/comment',
    method: 'put',
    params: { comment: data.tableComment }
  })
}

// 删除数据库表
export function delTable(tableName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName,
    method: 'delete'
  })
}

// 修改表名
export function renameTable(oldTableName, newTableName) {
  return request({
    url: '/tool/dbmanage/table/' + oldTableName + '/rename',
    method: 'put',
    params: { newTableName: newTableName }
  })
}

// 修改表注释
export function alterTableComment(tableName, comment) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/comment',
    method: 'put',
    params: { comment: comment }
  })
}

// 修改表引擎
export function alterTableEngine(tableName, engine) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/engine',
    method: 'put',
    params: { engine: engine }
  })
}

// 添加表字段
export function addTableColumn(tableName, data, afterColumn) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/column',
    method: 'post',
    data: data,
    params: { afterColumn: afterColumn }
  })
}

// 修改表字段
export function modifyTableColumn(tableName, oldColumnName, data) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/column/' + oldColumnName,
    method: 'put',
    data: data
  })
}

// 删除表字段
export function dropTableColumn(tableName, columnName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/column/' + columnName,
    method: 'delete'
  })
}

// 创建索引
export function createIndex(tableName, data) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/index',
    method: 'post',
    data: data
  })
}

// 删除索引
export function dropIndex(tableName, indexName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/index/' + indexName,
    method: 'delete'
  })
}

// 检查表是否存在
export function checkTableExists(tableName) {
  return request({
    url: '/tool/dbmanage/check/table/' + tableName,
    method: 'get'
  })
}

// 检查字段是否存在
export function checkColumnExists(tableName, columnName) {
  return request({
    url: '/tool/dbmanage/check/column/' + tableName + '/' + columnName,
    method: 'get'
  })
}

// 检查索引是否存在
export function checkIndexExists(tableName, indexName) {
  return request({
    url: '/tool/dbmanage/check/index/' + tableName + '/' + indexName,
    method: 'get'
  })
}

// 执行原生SQL
export function executeSql(sql) {
  return request({
    url: '/tool/dbmanage/sql/execute',
    method: 'post',
    params: { sql: sql }
  })
}

// 获取数据库信息
export function getDatabaseInfo() {
  return request({
    url: '/tool/dbmanage/database/info',
    method: 'get'
  })
}

// 验证表名格式
export function validateTableName(tableName) {
  return request({
    url: '/tool/dbmanage/validate/tableName/' + tableName,
    method: 'get'
  })
}

// 验证字段名格式
export function validateColumnName(columnName) {
  return request({
    url: '/tool/dbmanage/validate/columnName/' + columnName,
    method: 'get'
  })
}

// 验证索引名格式
export function validateIndexName(indexName) {
  return request({
    url: '/tool/dbmanage/validate/indexName/' + indexName,
    method: 'get'
  })
}

// 导出数据库表信息
export function exportTable(query) {
  return request({
    url: '/tool/dbmanage/export',
    method: 'post',
    params: query
  })
}

// 构建字段SQL预览
export function previewColumnSql(data) {
  return request({
    url: '/tool/dbmanage/column/preview',
    method: 'post',
    data: data
  })
}

// 备份表结构和数据
export function backupTable(tableName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/backup',
    method: 'post'
  })
}

// 同步数据库统计信息
export function syncDatabase() {
  return request({
    url: '/tool/dbmanage/database/sync',
    method: 'post'
  })
}

// 获取表的准确行数
export function getAccurateTableRows(tableName) {
  return request({
    url: '/tool/dbmanage/table/' + tableName + '/rows',
    method: 'get'
  })
} 