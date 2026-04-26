import request from '@/utils/request'

// 查询垃圾分类知识文章列表
export function listArticle(query) {
  return request({
    url: '/system/article/list',
    method: 'get',
    params: query
  })
}

// 查询垃圾分类知识文章详细
export function getArticle(articleId) {
  return request({
    url: '/system/article/' + articleId,
    method: 'get'
  })
}

// 新增垃圾分类知识文章
export function addArticle(data) {
  return request({
    url: '/system/article',
    method: 'post',
    data: data
  })
}

// 修改垃圾分类知识文章
export function updateArticle(data) {
  return request({
    url: '/system/article',
    method: 'put',
    data: data
  })
}

// 删除垃圾分类知识文章
export function delArticle(articleId) {
  return request({
    url: '/system/article/' + articleId,
    method: 'delete'
  })
}

// 批量删除垃圾分类知识文章
export function delArticles(articleIds) {
  return request({
    url: '/system/article/' + articleIds,
    method: 'delete'
  })
}

// 导出垃圾分类知识文章
export function exportArticle(query) {
  return request({
    url: '/system/article/export',
    method: 'post',
    params: query
  })
}

// 查询关联分类ID选项列表
export function getCategoryIdOptions() {
  return request({
    url: '/system/article/categoryId/options',
    method: 'get'
  })
}
