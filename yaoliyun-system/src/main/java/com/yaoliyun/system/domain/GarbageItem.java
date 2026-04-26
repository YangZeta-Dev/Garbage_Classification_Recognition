package com.yaoliyun.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.yaoliyun.common.annotation.Excel;
import com.yaoliyun.common.core.domain.BaseEntity;

/**
 * 垃圾物品对象 garbage_item
 * 
 * @author ruoyi
 * @date 2025-12-16
 */
public class GarbageItem extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 物品ID */
    private Long itemId;

    /** 所属类别ID（关联垃圾分类类别表） */
    @Excel(name = "所属类别ID", readConverterExp = "关=联垃圾分类类别表")
    private Long categoryId;

    /** 所属类别ID（关联垃圾分类类别表）关联字段（关联garbage_category表） */
    private String categoryName;

    /** 物品名称 */
    @Excel(name = "物品名称")
    private String itemName;

    /** 名称拼音 */
    @Excel(name = "名称拼音")
    private String itemNamePinyin;

    /** 处理建议 */
    @Excel(name = "处理建议")
    private String disposalSuggestion;

    /** 物品图片URL */
    @Excel(name = "物品图片URL")
    private String imageUrl;

    /** 环保小贴士 */
    @Excel(name = "环保小贴士")
    private String environmentalTips;

    /** 搜索次数 */
    @Excel(name = "搜索次数")
    private Long searchCount;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    public void setItemId(Long itemId) 
    {
        this.itemId = itemId;
    }

    public Long getItemId() 
    {
        return itemId;
    }

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

    public void setItemName(String itemName) 
    {
        this.itemName = itemName;
    }

    public String getItemName() 
    {
        return itemName;
    }

    public void setItemNamePinyin(String itemNamePinyin) 
    {
        this.itemNamePinyin = itemNamePinyin;
    }

    public String getItemNamePinyin() 
    {
        return itemNamePinyin;
    }

    public void setDisposalSuggestion(String disposalSuggestion) 
    {
        this.disposalSuggestion = disposalSuggestion;
    }

    public String getDisposalSuggestion() 
    {
        return disposalSuggestion;
    }

    public void setImageUrl(String imageUrl) 
    {
        this.imageUrl = imageUrl;
    }

    public String getImageUrl() 
    {
        return imageUrl;
    }

    public void setEnvironmentalTips(String environmentalTips) 
    {
        this.environmentalTips = environmentalTips;
    }

    public String getEnvironmentalTips() 
    {
        return environmentalTips;
    }

    public void setSearchCount(Long searchCount) 
    {
        this.searchCount = searchCount;
    }

    public Long getSearchCount() 
    {
        return searchCount;
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
            .append("itemId", getItemId())
            .append("categoryId", getCategoryId())
            .append("itemName", getItemName())
            .append("itemNamePinyin", getItemNamePinyin())
            .append("disposalSuggestion", getDisposalSuggestion())
            .append("imageUrl", getImageUrl())
            .append("environmentalTips", getEnvironmentalTips())
            .append("searchCount", getSearchCount())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
