package com.yaoliyun.system.mapper;

import java.util.List;
import com.yaoliyun.system.domain.SysPageTemplate;

/**
 * 页面模板管理Mapper接口
 * 
 * @author yaoliyun
 * @date 2025-01-26
 */
public interface SysPageTemplateMapper 
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
     * 查询热门模板列表（按下载次数排序）
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
     * 删除页面模板管理
     * 
     * @param templateId 页面模板管理主键
     * @return 结果
     */
    public int deleteSysPageTemplateByTemplateId(Long templateId);

    /**
     * 批量删除页面模板管理
     * 
     * @param templateIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSysPageTemplateByTemplateIds(Long[] templateIds);

    /**
     * 增加模板下载次数
     * 
     * @param templateId 模板ID
     * @return 结果
     */
    public int incrementDownloadCount(Long templateId);
} 