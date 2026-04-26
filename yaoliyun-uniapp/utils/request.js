export const baseURl = 'http://localhost:8080'



export default function request(config) {
	return new Promise((resolve, reject) => {
		// 构建请求头
		let headers = {
			"content-type": "application/json"
		}

		// 处理Authorization
		if (!config.headers || config.headers.isToken !== false) {
			const token = uni.getStorageSync('token')
			if (token) {
				headers["Authorization"] = token
			}
		}

		// 合并自定义headers
		if (config.headers) {
			Object.assign(headers, config.headers)
		}

		uni.request({
			url: baseURl + config['url'],
			method: config['method'],
			header: headers,
			data: config['params'] ? config['params'] : config['data'],
			success: (res) => {
				// console.log(res)
				if (res.statusCode === 200) {
					if(res.data.code==200){
						resolve(res.data)
					}else if(res.data.code==401){
						uni.showModal({
							title:'温馨提示',
							content:'当前登录已过期请重新登录',
							success: (res) => {
								if(res.confirm){
									uni.navigateTo({
										url:'/pages/login/login'
									})
								}else{
									uni.switchTab({
										url:'/pages/index/index'
									})
								}
							}
						})
					}else{
						console.log(res.data)
						reject(res)
					}
				} else {
					reject(res)
				}
			},
			fail(res) {	
				reject(res)
			}
		})
	})
}

// 文件上传函数
export const uploadFile = (filePath) => {
	return new Promise((resolve, reject) => {
		uni.uploadFile({
			url: baseURl + '/common/upload',  // 上传文件的接口路径
			filePath: filePath,
			name: 'file',  // 文件对应的 key，开发者在服务端可以通过这个 key 获取文件的二进制内容
			header: {
				"Authorization": uni.getStorageSync('token') ? uni.getStorageSync('token') : '',
			},
			success: (res) => {
				if (res.statusCode === 200) {
					try {
						const data = JSON.parse(res.data);
						console.log(data)
						if (data.code === 200) {
							resolve(data);
						} else if (data.code === 401) {
							uni.showModal({
								title: '温馨提示',
								content: '当前登录已过期请重新登录',
								success: (res) => {
									if (res.confirm) {
										uni.reLaunch({
											url: '/pages/login/login'
										});
									} else {
										uni.switchTab({
											url: '/pages/index/index'
										});
									}
								}
							});
						} else if (data.code === 500){
							uni.showToast({
								title: '服务器异常',
								icon: 'none'
							});
							reject(new Error('服务器异常'));
						}
						else{
							uni.showToast({
								title: data.msg || '上传失败',
								icon: 'none'
							});
							reject(new Error(data.msg || '上传失败'));
						}
					} catch (e) {
						uni.showToast({
							title: '服务器返回数据格式错误',
							icon: 'none'
						});
						reject(e);
					}
				} else {
					uni.showToast({
						title: '上传失败，服务器状态码：' + res.statusCode,
						icon: 'none'
					});
					reject(new Error('上传失败，状态码：' + res.statusCode));
				}
			},
			fail: (err) => {
				uni.showToast({
					title: '上传请求失败',
					icon: 'none'
				});
				reject(err);
			}
		});
	});
}