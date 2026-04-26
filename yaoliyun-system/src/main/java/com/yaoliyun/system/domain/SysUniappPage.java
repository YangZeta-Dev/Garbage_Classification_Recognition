package com.yaoliyun.system.domain;

import com.yaoliyun.common.annotation.Excel;
import com.yaoliyun.common.core.domain.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;

/**
 * UniApp页面管理对象 sys_uniapp_page
 * 
 * @author yaoliyun
 * @date 2024-01-15
 */
public class SysUniappPage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 页面ID */
    private Long pageId;

    /** 页面路径 */
    @Excel(name = "页面路径")
    private String pagePath;

    /** 页面标题 */
    @Excel(name = "页面标题")
    private String pageTitle;

    /** 导航栏样式(default/custom) */
    @Excel(name = "导航栏样式")
    private String navigationStyle;

    /** 页面状态(0正常 1停用) */
    @Excel(name = "页面状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 是否为TabBar页面(0否 1是) */
    @Excel(name = "TabBar页面", readConverterExp = "0=否,1=是")
    private String isTabbar;

    /** TabBar文本 */
    @Excel(name = "TabBar文本")
    private String tabbarText;

    /** TabBar排序（数字越小越靠前） */
    @Excel(name = "TabBar排序")
    private Integer tabbarOrder;

    /** TabBar选中状态图标路径 */
    @Excel(name = "TabBar选中图标")
    private String tabbarSelectedIcon;

    /** TabBar未选中状态图标路径 */
    @Excel(name = "TabBar图标")
    private String tabbarIconPath;

    /** 页面描述 */
    @Excel(name = "页面描述")
    private String description;

    /** 创建者 */
    private String createBy;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    /** 更新者 */
    private String updateBy;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;

    public void setPageId(Long pageId) 
    {
        this.pageId = pageId;
    }

    public Long getPageId() 
    {
        return pageId;
    }

    public void setPagePath(String pagePath) 
    {
        this.pagePath = pagePath;
    }

    public String getPagePath() 
    {
        return pagePath;
    }

    public void setPageTitle(String pageTitle) 
    {
        this.pageTitle = pageTitle;
    }

    public String getPageTitle() 
    {
        return pageTitle;
    }

    public void setNavigationStyle(String navigationStyle) 
    {
        this.navigationStyle = navigationStyle;
    }

    public String getNavigationStyle() 
    {
        return navigationStyle;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setIsTabbar(String isTabbar) 
    {
        this.isTabbar = isTabbar;
    }

    public String getIsTabbar() 
    {
        return isTabbar;
    }

    public void setTabbarText(String tabbarText) 
    {
        this.tabbarText = tabbarText;
    }

    public String getTabbarText() 
    {
        return tabbarText;
    }

    public void setTabbarOrder(Integer tabbarOrder) 
    {
        this.tabbarOrder = tabbarOrder;
    }

    public Integer getTabbarOrder() 
    {
        return tabbarOrder;
    }

    public void setTabbarSelectedIcon(String tabbarSelectedIcon) 
    {
        this.tabbarSelectedIcon = tabbarSelectedIcon;
    }

    public String getTabbarSelectedIcon() 
    {
        return tabbarSelectedIcon;
    }

    public void setTabbarIconPath(String tabbarIconPath) 
    {
        this.tabbarIconPath = tabbarIconPath;
    }

    public String getTabbarIconPath() 
    {
        return tabbarIconPath;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }

    public void setCreateBy(String createBy) 
    {
        this.createBy = createBy;
    }

    public String getCreateBy() 
    {
        return createBy;
    }

    public void setCreateTime(Date createTime) 
    {
        this.createTime = createTime;
    }

    public Date getCreateTime() 
    {
        return createTime;
    }

    public void setUpdateBy(String updateBy) 
    {
        this.updateBy = updateBy;
    }

    public String getUpdateBy() 
    {
        return updateBy;
    }

    public void setUpdateTime(Date updateTime) 
    {
        this.updateTime = updateTime;
    }

    public Date getUpdateTime() 
    {
        return updateTime;
    }

    @Override
    public String toString() {
        return "SysUniappPage{" +
                "pageId=" + pageId +
                ", pagePath='" + pagePath + '\'' +
                ", pageTitle='" + pageTitle + '\'' +
                ", navigationStyle='" + navigationStyle + '\'' +
                ", status='" + status + '\'' +
                ", isTabbar='" + isTabbar + '\'' +
                ", tabbarText='" + tabbarText + '\'' +
                ", tabbarOrder=" + tabbarOrder +
                ", tabbarSelectedIcon='" + tabbarSelectedIcon + '\'' +
                ", tabbarIconPath='" + tabbarIconPath + '\'' +
                ", description='" + description + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime=" + createTime +
                ", updateBy='" + updateBy + '\'' +
                ", updateTime=" + updateTime +
                '}';
    }
} 