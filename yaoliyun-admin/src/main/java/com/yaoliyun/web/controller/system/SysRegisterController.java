package com.yaoliyun.web.controller.system;

import com.yaoliyun.common.core.domain.entity.SysUser;
import com.yaoliyun.system.service.ISysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import com.yaoliyun.common.core.controller.BaseController;
import com.yaoliyun.common.core.domain.AjaxResult;
import com.yaoliyun.common.core.domain.model.RegisterBody;
import com.yaoliyun.common.utils.StringUtils;
import com.yaoliyun.framework.web.service.SysRegisterService;
import com.yaoliyun.system.service.ISysConfigService;

/**
 * 注册验证
 *
 * @author ruoyi
 */
@RestController
public class SysRegisterController extends BaseController
{
    @Autowired
    private SysRegisterService registerService;

    @Autowired
    private ISysConfigService configService;

    @Autowired
    private ISysUserService userService;

    @PostMapping("/register")
    public AjaxResult register(@RequestBody RegisterBody user)
    {
        if (!("true".equals(configService.selectConfigByKey("sys.account.registerUser"))))
        {
            return error("当前系统没有开启注册功能！");
        }
        String msg = registerService.register(user);
        SysUser userId=userService.selectUserByUserName(user.getUsername());
        Long[] Array=new Long[1];
        Array[0]=2L;
        userService.insertUserAuth(userId.getUserId(),Array);
        return StringUtils.isEmpty(msg) ? success() : error(msg);
    }
}
