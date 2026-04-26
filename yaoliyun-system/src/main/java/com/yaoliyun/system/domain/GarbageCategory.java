package com.yaoliyun.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.yaoliyun.common.annotation.Excel;
import com.yaoliyun.common.core.domain.BaseEntity;

/**
 * 垃圾分类类别对象 garbage_category
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public class GarbageCategory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 类别ID */
    private Long categoryId;

    /** 类别名称 */
    @Excel(name = "类别名称")
    private String categoryName;

    /** 类别编码 */
    @Excel(name = "类别编码")
    private String categoryCode;

    /** 类别描述 */
    @Excel(name = "类别描述")
    private String description;

    /** 图标URL */
    @Excel(name = "图标URL")
    private String iconUrl;

    /** 颜色代码 */
    @Excel(name = "颜色代码")
    private String colorCode;

    /** 处理指南 */
    @Excel(name = "处理指南")
    private String disposalGuidelines;

    /** 排序号 */
    @Excel(name = "排序号")
    private Long sortOrder;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    public void setCategoryId(Long categoryId) 
    {
        this.categoryId = categoryId;
    }

    public Long getCategoryId() 
    {
        return categoryId;
    }

    public void setCategoryName(String categoryName) 
    {
        this.categoryName = categoryName;
    }

    public String getCategoryName() 
    {
        return categoryName;
    }

    public void setCategoryCode(String categoryCode) 
    {
        this.categoryCode = categoryCode;
    }

    public String getCategoryCode() 
    {
        return categoryCode;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }

    public void setIconUrl(String iconUrl) 
    {
        this.iconUrl = iconUrl;
    }

    public String getIconUrl() 
    {
        return iconUrl;
    }

    public void setColorCode(String colorCode) 
    {
        this.colorCode = colorCode;
    }

    public String getColorCode() 
    {
        return colorCode;
    }

    public void setDisposalGuidelines(String disposalGuidelines) 
    {
        this.disposalGuidelines = disposalGuidelines;
    }

    public String getDisposalGuidelines() 
    {
        return disposalGuidelines;
    }

    public void setSortOrder(Long sortOrder) 
    {
        this.sortOrder = sortOrder;
    }

    public Long getSortOrder() 
    {
        return sortOrder;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("categoryId", getCategoryId())
            .append("categoryName", getCategoryName())
            .append("categoryCode", getCategoryCode())
            .append("description", getDescription())
            .append("iconUrl", getIconUrl())
            .append("colorCode", getColorCode())
            .append("disposalGuidelines", getDisposalGuidelines())
            .append("sortOrder", getSortOrder())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
