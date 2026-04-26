package com.yaoliyun.web.controller.system;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.yaoliyun.common.annotation.Anonymous;
import com.yaoliyun.common.config.RuoYiConfig;
import com.yaoliyun.common.core.controller.BaseController;
import com.yaoliyun.common.core.domain.AjaxResult;
import com.yaoliyun.common.utils.StringUtils;
import com.yaoliyun.system.service.ISysIndexService;

/**
 * 首页
 *
 * @author ruoyi
 */
@RestController
public class SysIndexController extends BaseController
{
    /** 系统基础配置 */
    @Autowired
    private RuoYiConfig ruoyiConfig;

    @Autowired
    private ISysIndexService sysIndexService;

    /**
     * 访问首页，提示语
     */
    @RequestMapping("/")
    public String index()
    {
        return StringUtils.format("欢迎使用{}后台管理框架，当前版本：v{}，请通过前端地址访问。", ruoyiConfig.getName(), ruoyiConfig.getVersion());
    }

    /**
     * 获取系统统计概览数据
     */
    @Anonymous
    @GetMapping("/system/index/overview")
    public AjaxResult getOverview()
    {
        Map<String, Object> data = sysIndexService.getSystemOverview();
        return success(data);
    }

    /**
     * 获取用户注册趋势数据（最近30天）
     */
    @Anonymous
    @GetMapping("/system/index/userTrend")
    public AjaxResult getUserTrend()
    {
        Map<String, Object> data = sysIndexService.getUserRegistrationTrend();
        return success(data);
    }

    /**
     * 获取在线用户趋势数据（最近24小时）
     */
    @Anonymous
    @GetMapping("/system/index/onlineTrend")
    public AjaxResult getOnlineTrend()
    {
        Map<String, Object> data = sysIndexService.getOnlineUserTrend();
        return success(data);
    }

    /**
     * 获取系统模块使用统计
     */
    @Anonymous
    @GetMapping("/system/index/moduleUsage")
    public AjaxResult getModuleUsage()
    {
        List<Map<String, Object>> data = sysIndexService.getModuleUsageStats();
        return success(data);
    }

    /**
     * 获取垃圾分类统计概览数据
     */
    @Anonymous
    @GetMapping("/system/index/garbageOverview")
    public AjaxResult getGarbageOverview()
    {
        Map<String, Object> data = sysIndexService.getGarbageOverview();
        return success(data);
    }

    /**
     * 获取各分类识别统计
     */
    @Anonymous
    @GetMapping("/system/index/categoryStats")
    public AjaxResult getCategoryStats()
    {
        List<Map<String, Object>> data = sysIndexService.getCategoryRecognitionStats();
        return success(data);
    }

    /**
     * 获取识别趋势数据（最近30天）
     */
    @Anonymous
    @GetMapping("/system/index/recognitionTrend")
    public AjaxResult getRecognitionTrend()
    {
        Map<String, Object> data = sysIndexService.getRecognitionTrend();
        return success(data);
    }
}
