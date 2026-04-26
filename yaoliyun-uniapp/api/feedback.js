import request from '@/utils/request.js'

/**
 * 提交意见反馈
 * @param {Object} data - 反馈数据
 * @param {String} data.type - 反馈类型: suggestion(功能建议) | bug(问题反馈) | question(使用咨询) | other(其他)
 * @param {String} data.content - 反馈内容
 * @param {String} data.contact - 联系方式（可选）
 * @param {String} data.images - 图片URL，多个用逗号分隔（可选）
 */
export function submitFeedback(data) {
	// 模拟接口调用
	return new Promise((resolve) => {
		// 模拟网络延迟
		setTimeout(() => {
			console.log('提交反馈数据:', data)
			
			// 模拟成功响应
			resolve({
				code: 200,
				msg: '提交成功',
				data: {
					id: Date.now(),
					status: 'pending', // pending(待处理) | processing(处理中) | resolved(已解决)
					createTime: new Date().toISOString()
				}
			})
		}, 1000)
	})
	
	// 真实接口实现（取消注释使用）
	// return request({
	// 	url: '/system/feedback/submit',
	// 	method: 'post',
	// 	data: data
	// })
}

/**
 * 获取我的反馈列表
 * @param {Object} params - 查询参数
 * @param {Number} params.pageNum - 页码
 * @param {Number} params.pageSize - 每页数量
 * @param {String} params.status - 状态筛选
 */
export function getFeedbackList(params) {
	// 模拟接口调用
	return new Promise((resolve) => {
		setTimeout(() => {
			// 模拟反馈列表数据
			const mockList = [
				{
					id: 1,
					type: 'suggestion',
					typeName: '功能建议',
					content: '希望能增加夜间模式，保护眼睛',
					status: 'resolved',
					statusName: '已解决',
					createTime: '2024-01-15 10:30:00',
					reply: '感谢您的建议，夜间模式已在规划中，预计下个版本发布'
				},
				{
					id: 2,
					type: 'bug',
					typeName: '问题反馈',
					content: '上传图片时偶尔会失败',
					status: 'processing',
					statusName: '处理中',
					createTime: '2024-01-16 14:20:00',
					reply: null
				}
			]
			
			resolve({
				code: 200,
				msg: '查询成功',
				rows: mockList,
				total: mockList.length
			})
		}, 500)
	})
	
	// 真实接口实现（取消注释使用）
	// return request({
	// 	url: '/system/feedback/list',
	// 	method: 'get',
	// 	params: params
	// })
}

/**
 * 获取反馈详情
 * @param {Number} id - 反馈ID
 */
export function getFeedbackDetail(id) {
	// 模拟接口调用
	return new Promise((resolve) => {
		setTimeout(() => {
			resolve({
				code: 200,
				msg: '查询成功',
				data: {
					id: id,
					type: 'suggestion',
					typeName: '功能建议',
					content: '希望能增加夜间模式，保护眼睛',
					contact: '138****8888',
					images: [],
					status: 'resolved',
					statusName: '已解决',
					createTime: '2024-01-15 10:30:00',
					reply: '感谢您的建议，夜间模式已在规划中，预计下个版本发布',
					replyTime: '2024-01-16 09:00:00'
				}
			})
		}, 500)
	})
	
	// 真实接口实现（取消注释使用）
	// return request({
	// 	url: `/system/feedback/${id}`,
	// 	method: 'get'
	// })
}

