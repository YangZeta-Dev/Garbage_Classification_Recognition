package com.yaoliyun.system.service;

import java.util.List;
import java.util.Map;
import com.yaoliyun.system.domain.SysPageTemplate;

/**
 * 页面模板管理Service接口
 * 
 * @author yaoliyun
 * @date 2025-01-26
 */
public interface ISysPageTemplateService 
{
    /**
     * 查询页面模板管理
     * 
     * @param templateId 页面模板管理主键
     * @return 页面模板管理
     */
    public SysPageTemplate selectSysPageTemplateByTemplateId(Long templateId);

    /**
     * 查询页面模板管理列表
     * 
     * @param sysPageTemplate 页面模板管理
     * @return 页面模板管理集合
     */
    public List<SysPageTemplate> selectSysPageTemplateList(SysPageTemplate sysPageTemplate);

    /**
     * 查询热门模板列表
     * 
     * @param limit 限制数量
     * @return 页面模板管理集合
     */
    public List<SysPageTemplate> selectPopularTemplates(int limit);

    /**
     * 根据分类查询模板列表
     * 
     * @param category 分类
     * @return 页面模板管理集合
     */
    public List<SysPageTemplate> selectTemplatesByCategory(String category);

    /**
     * 根据类型查询模板列表
     * 
     * @param templateType 模板类型
     * @return 页面模板管理集合
     */
    public List<SysPageTemplate> selectTemplatesByType(String templateType);

    /**
     * 新增页面模板管理
     * 
     * @param sysPageTemplate 页面模板管理
     * @return 结果
     */
    public int insertSysPageTemplate(SysPageTemplate sysPageTemplate);

    /**
     * 修改页面模板管理
     * 
     * @param sysPageTemplate 页面模板管理
     * @return 结果
     */
    public int updateSysPageTemplate(SysPageTemplate sysPageTemplate);

    /**
     * 批量删除页面模板管理
     * 
     * @param templateIds 需要删除的页面模板管理主键集合
     * @return 结果
     */
    public int deleteSysPageTemplateByTemplateIds(Long[] templateIds);

    /**
     * 删除页面模板管理信息
     * 
     * @param templateId 页面模板管理主键
     * @return 结果
     */
    public int deleteSysPageTemplateByTemplateId(Long templateId);

    /**
     * 获取模板代码内容
     * 
     * @param templateId 模板ID
     * @return 模板代码
     */
    public String getTemplateCode(Long templateId);

    /**
     * 使用模板（增加下载次数）
     * 
     * @param templateId 模板ID
     * @return 结果
     */
    public boolean useTemplate(Long templateId);

    /**
     * 复制模板代码
     * 
     * @param templateId 模板ID
     * @return 模板代码
     */
    public String copyTemplateCode(Long templateId);

    /**
     * 获取模板统计信息
     * 
     * @return 统计信息
     */
    public Map<String, Object> getTemplateStatistics();

    /**
     * 保存模板代码
     * 
     * @param sysPageTemplate 页面模板对象
     * @param code 原始代码
     * @return 结果
     */
    public int saveTemplateWithCode(SysPageTemplate sysPageTemplate, String code);

    /**
     * 更新模板代码
     * 
     * @param sysPageTemplate 页面模板对象
     * @param code 原始代码
     * @return 结果
     */
    public int updateTemplateWithCode(SysPageTemplate sysPageTemplate, String code);
} 