import Layout from '@/layout'

const pageTemplateRouter = {
  path: '/pageTemplate',
  component: Layout,
  redirect: '/pageTemplate/template',
  name: 'PageTemplate',
  meta: {
    title: '页面模板管理',
    icon: 'template'
  },
  children: [
    {
      path: 'template',
      component: () => import('@/views/system/pageTemplate/index'),
      name: 'Template',
      meta: { title: '模板管理', icon: 'list' }
    },
    {
      path: 'category',
      component: () => import('@/views/system/pageTemplate/category'),
      name: 'TemplateCategory',
      meta: { title: '模板分类', icon: 'category' }
    },
    {
      path: 'statistics',
      component: () => import('@/views/system/pageTemplate/statistics'),
      name: 'TemplateStatistics',
      meta: { title: '模板统计', icon: 'chart' }
    }
  ]
}

export default pageTemplateRouter 