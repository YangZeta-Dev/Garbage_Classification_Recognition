package com.yaoliyun.system.mapper;

import java.util.List;
import com.yaoliyun.system.domain.SysUniappPage;

/**
 * UniApp页面管理Mapper接口
 * 
 * @author yaoliyun
 * @date 2024-01-15
 */
public interface SysUniappPageMapper 
{
    /**
     * 查询UniApp页面管理
     * 
     * @param pageId UniApp页面管理主键
     * @return UniApp页面管理
     */
    public SysUniappPage selectSysUniappPageByPageId(Long pageId);

    /**
     * 根据页面路径查询UniApp页面管理
     * 
     * @param pagePath 页面路径
     * @return UniApp页面管理
     */
    public SysUniappPage selectSysUniappPageByPath(String pagePath);

    /**
     * 查询UniApp页面管理列表
     * 
     * @param sysUniappPage UniApp页面管理
     * @return UniApp页面管理集合
     */
    public List<SysUniappPage> selectSysUniappPageList(SysUniappPage sysUniappPage);

    /**
     * 新增UniApp页面管理
     * 
     * @param sysUniappPage UniApp页面管理
     * @return 结果
     */
    public int insertSysUniappPage(SysUniappPage sysUniappPage);

    /**
     * 修改UniApp页面管理
     * 
     * @param sysUniappPage UniApp页面管理
     * @return 结果
     */
    public int updateSysUniappPage(SysUniappPage sysUniappPage);

    /**
     * 删除UniApp页面管理
     * 
     * @param pageId UniApp页面管理主键
     * @return 结果
     */
    public int deleteSysUniappPageByPageId(Long pageId);

    /**
     * 批量删除UniApp页面管理
     * 
     * @param pageIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSysUniappPageByPageIds(Long[] pageIds);

    /**
     * 根据页面路径删除UniApp页面管理
     * 
     * @param pagePath 页面路径
     * @return 结果
     */
    public int deleteSysUniappPageByPath(String pagePath);

    /**
     * 查询TabBar页面列表，按排序字段排序
     * 
     * @return TabBar页面集合
     */
    public List<SysUniappPage> selectTabbarPagesList();
} 