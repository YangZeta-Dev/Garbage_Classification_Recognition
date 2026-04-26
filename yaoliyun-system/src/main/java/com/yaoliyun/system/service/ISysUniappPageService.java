package com.yaoliyun.system.service;

import java.util.List;
import com.yaoliyun.system.domain.SysUniappPage;

/**
 * UniApp页面管理Service接口
 * 
 * @author yaoliyun
 * @date 2024-01-15
 */
public interface ISysUniappPageService 
{
    /**
     * 查询UniApp页面管理
     * 
     * @param pageId UniApp页面管理主键
     * @return UniApp页面管理
     */
    public SysUniappPage selectSysUniappPageByPageId(Long pageId);

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
     * 批量删除UniApp页面管理
     * 
     * @param pageIds 需要删除的UniApp页面管理主键集合
     * @return 结果
     */
    public int deleteSysUniappPageByPageIds(Long[] pageIds);

    /**
     * 删除UniApp页面管理信息
     * 
     * @param pageId UniApp页面管理主键
     * @return 结果
     */
    public int deleteSysUniappPageByPageId(Long pageId);

    /**
     * 创建页面文件和目录
     * 
     * @param pageInfo 页面信息
     * @return 结果
     */
    public boolean createPageFile(String pageInfo);

    /**
     * 删除页面文件和目录
     * 
     * @param pagePath 页面路径
     * @return 结果
     */
    public boolean deletePageFile(String pagePath);

    /**
     * 更新pages.json配置
     * 
     * @return 结果
     */
    public boolean updatePagesJson();

    /**
     * 备份pages.json文件
     * 
     * @return 结果
     */
    public boolean backupPagesJson();

    /**
     * 同步pages.json中的页面到数据库
     * 
     * @return 结果
     */
    public boolean syncPagesFromJson();

    /**
     * 检查页面路径是否存在
     * 
     * @param pagePath 页面路径
     * @return 结果
     */
    public boolean checkPagePathExists(String pagePath);

    /**
     * 验证页面路径格式
     * 
     * @param pagePath 页面路径
     * @return 结果
     */
    public boolean validatePagePath(String pagePath);

    /**
     * 查询TabBar页面列表，按排序字段排序
     * 
     * @return TabBar页面集合
     */
    public List<SysUniappPage> selectTabbarPagesList();

    /**
     * 获取页面代码内容
     * 
     * @param pagePath 页面路径
     * @return 页面代码内容
     */
    public String getPageCode(String pagePath);

    /**
     * 保存页面代码内容
     * 
     * @param pagePath 页面路径
     * @param code 页面代码内容
     * @return 保存结果
     */
    public boolean savePageCode(String pagePath, String code);

    /**
     * 从备份文件恢复页面代码
     * 
     * @param pagePath 页面路径
     * @param backupFileName 备份文件名
     * @return 恢复结果
     */
    public boolean restoreFromBackup(String pagePath, String backupFileName);

    /**
     * 获取页面的备份文件列表
     * 
     * @param pagePath 页面路径
     * @return 备份文件列表
     */
    public List<String> getPageBackupFiles(String pagePath);

    /**
     * 获取pages.json的备份文件列表
     * 
     * @return 备份文件列表
     */
    public List<String> getPagesJsonBackupFiles();

    /**
     * 清理指定天数之前的备份文件
     * 
     * @param days 保留天数
     * @return 清理结果
     */
    public boolean cleanOldBackups(int days);
} 