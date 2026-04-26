import request from '@/utils/request'

// 查询生成表数据
export function listTable(query) {
  return request({
    url: '/tool/gen/list',
    method: 'get',
    params: query
  })
}
// 查询db数据库列表
export function listDbTable(query) {
  return request({
    url: '/tool/gen/db/list',
    method: 'get',
    params: query
  })
}

// 查询表详细信息
export function getGenTable(tableId) {
  return request({
    url: '/tool/gen/' + tableId,
    method: 'get'
  })
}

// 修改代码生成信息
export function updateGenTable(data) {
  return request({
    url: '/tool/gen',
    method: 'put',
    data: data
  })
}

// 导入表
export function importTable(data) {
  return request({
    url: '/tool/gen/importTable',
    method: 'post',
    params: data
  })
}

// 创建表
export function createTable(data) {
  return request({
    url: '/tool/gen/createTable',
    method: 'post',
    params: data
  })
}

// 预览生成代码
export function previewTable(tableId) {
  return request({
    url: '/tool/gen/preview/' + tableId,
    method: 'get'
  })
}

// 删除表数据
export function delTable(tableId) {
  return request({
    url: '/tool/gen/' + tableId,
    method: 'delete'
  })
}

// 生成代码（自定义路径）
export function genCode(tableName) {
  return request({
    url: '/tool/gen/genCode/' + tableName,
    method: 'get'
  })
}

// 生成代码到项目目录
export function genCodeToProject(tableName) {
  return request({
    url: '/tool/gen/genCodeToProject/' + tableName,
    method: 'get'
  })
}

// 上传并执行SQL文件
export function uploadAndExecuteSql(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/tool/gen/uploadAndExecuteSql',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除已生成的代码文件
export function deleteGeneratedFiles(tableName) {
  return request({
    url: '/tool/gen/deleteGeneratedFiles/' + tableName,
    method: 'delete'
  })
}

// 同步数据库
export function synchDb(tableName) {
  return request({
    url: '/tool/gen/synchDb/' + tableName,
    method: 'get'
  })
}

// ============ 外键管理相关API ============

// 查询表的外键关系列表
export function listForeignKeys(tableId) {
  return request({
    url: '/tool/gen/foreignKeys/' + tableId,
    method: 'get'
  })
}

// 查询数据库表的外键信息（从information_schema）
export function getDbForeignKeys(tableName) {
  return request({
    url: '/tool/gen/dbForeignKeys/' + tableName,
    method: 'get'
  })
}

// 更新外键关系配置
export function updateForeignKey(data) {
  return request({
    url: '/tool/gen/foreignKey',
    method: 'put',
    data: data
  })
}

// 启用/禁用外键关联
export function toggleForeignKey(fkId, isEnabled) {
  return request({
    url: '/tool/gen/foreignKey/' + fkId + '/toggle',
    method: 'put',
    params: { isEnabled }
  })
}

// 设置外键显示字段
export function setForeignKeyDisplayField(fkId, displayField) {
  return request({
    url: '/tool/gen/foreignKey/' + fkId + '/displayField',
    method: 'put',
    params: { displayField }
  })
}