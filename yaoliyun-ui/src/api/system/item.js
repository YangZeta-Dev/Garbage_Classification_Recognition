import request from '@/utils/request'

// 查询垃圾物品列表
export function listItem(query) {
  return request({
    url: '/system/item/list',
    method: 'get',
    params: query
  })
}

// 查询垃圾物品详细
export function getItem(itemId) {
  return request({
    url: '/system/item/' + itemId,
    method: 'get'
  })
}

// 新增垃圾物品
export function addItem(data) {
  return request({
    url: '/system/item',
    method: 'post',
    data: data
  })
}

// 修改垃圾物品
export function updateItem(data) {
  return request({
    url: '/system/item',
    method: 'put',
    data: data
  })
}

// 删除垃圾物品
export function delItem(itemId) {
  return request({
    url: '/system/item/' + itemId,
    method: 'delete'
  })
}

// 批量删除垃圾物品
export function delItems(itemIds) {
  return request({
    url: '/system/item/' + itemIds,
    method: 'delete'
  })
}

// 导出垃圾物品
export function exportItem(query) {
  return request({
    url: '/system/item/export',
    method: 'post',
    params: query
  })
}

// 查询所属类别ID（关联垃圾分类类别表）选项列表
export function getCategoryIdOptions() {
  return request({
    url: '/system/item/categoryId/options',
    method: 'get'
  })
}
