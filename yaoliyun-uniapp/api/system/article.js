import request from '@/utils/request'

// 查询垃圾分类知识文章列表
export function listArticle(query) {
  return request({
    url: '/system/article/list',
    method: 'GET',
    data: query
  })
}

// 查询垃圾分类知识文章详细
export function getArticle(articleId) {
  return request({
    url: '/system/article/' + articleId,
    method: 'GET'
  })
}

// 查询垃圾分类知识文章详细（前端访问，浏览量+1）
export function getArticleDetail(articleId) {
  return request({
    url: '/system/article/detail/' + articleId,
    method: 'GET'
  })
}

// 新增垃圾分类知识文章
export function addArticle(data) {
  return request({
    url: '/system/article',
    method: 'POST',
    data: data
  })
}

// 修改垃圾分类知识文章
export function updateArticle(data) {
  return request({
    url: '/system/article',
    method: 'PUT',
    data: data
  })
}

// 删除垃圾分类知识文章
export function delArticle(articleId) {
  return request({
    url: '/system/article/' + articleId,
    method: 'DELETE'
  })
}

// 批量删除垃圾分类知识文章
export function delArticles(articleIds) {
  return request({
    url: '/system/article/' + articleIds,
    method: 'DELETE'
  })
}

// 导出垃圾分类知识文章
export function exportArticle(query) {
  return request({
    url: '/system/article/export',
    method: 'POST',
    data: query
  })
}
